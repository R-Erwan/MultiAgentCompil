%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symbol_table.h"  // Inclusion de la table des symboles
    #include "semantic_anal.h"  // Inclusion des fonctions sémantiques
    #include "agents.h"  // Inclusion de la structure d'agent
    #include "transpileur.h"
    #include "ANSI-color-codes.h" // Inclusion des codes couleurs ANSI

    void yyerror(char *s);
    extern int yylex(void);
    extern int yylineno;

    typedef 

%}

%union {
    int valeur;
    struct {
        int tab[100];
        int taille;
    } valeurs;
    char chaine[100];
    char caractere;
    float reel;
}

%token <chaine> ENV;
%token <chaine> NTYPA;
%token <chaine> NAG;
%token <chaine> NCT;
%token <chaine> TINT;
%token <chaine> TDOUBL;
%token <chaine> TCAR;
%token <chaine> TCH;
%token <chaine> TBOOL;
%token <chaine> BOOL;
%token <chaine> IDF;
%token <chaine> CH;
%token <caractere> CO;
%token <caractere> CF;
%token <caractere> VG;
%token <caractere> AO;
%token <caractere> AF;
%token <caractere> DPT;
%token <caractere> EG;
%token <caractere> CAR;
%token <valeur> INT;
%token <reel> REEL;

%type<valeur> type_attribut
%type<valeur> decla_attribut
%type<valeurs> liste_decla_attributs
%type<valeur> valeur_attribut

%start program

%%

program : decla_env suite_prog {}
decla_env : ENV IDF CO INT VG INT CF{
    int i1 = checkTab($2); 
    int i2;
    char buff[12];
    sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,5,i2);
    sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,6,i2);
}
suite_prog : instruction {}
            | instruction suite_prog {}
instruction : new_typ_agent {}
            | new_agent {}
            | new_context {}
new_typ_agent : NTYPA IDF AO liste_decla_attributs AF { 
    int i1 = checkTab($2);   // WTF ?
    int nbAttributs = $4.taille;
    for (int i = 0; i < nbAttributs; i++) {
        insertInto($4.tab[i], 6, i1); // On insère, pour chaque attribut le type d'aggent auquel il appartient
    }
    insertInto(i1, 5, nbAttributs); // On insère le nombre d'attributs dans la table des symboles
     
}
liste_decla_attributs : decla_attribut {$$.tab[0] = $1; $$.taille = 1;} // WTF 2 ??
                        | decla_attribut VG liste_decla_attributs { // Fait remonter la liste des indices d'attributs
                            $$.tab[0] = $1;  
                            for (int i =0; i < $3.taille; i++) {
                                $$.tab[i+1] = $3.tab[i];
                                } 
                            $$.taille = $3.taille + 1;
                            }
decla_attribut : IDF DPT type_attribut {
    int i1 = checkTab($1); 
    $$ = i1; //Fait remonter l'indice de l'attribut
    insertInto(i1,5,$3);
}
type_attribut : TINT { $$ = TA_INT; }
               | TDOUBL { $$ = TA_DOUBL; }
               | TCAR { $$ = TA_CAR; }
               | TCH { $$ = TA_CH; }
               | TBOOL { $$ = TA_BOOL; }

new_agent : NAG IDF DPT IDF CO INT VG INT CF AO liste_affect_attributs AF {
    int i1 = checkTab($2); 
    int i2 = checkTab($4); 
    if(i1 > i2){ // Vérifie que le type d'agent à été délcaré avant l'agent
        insertInto(i1,5,i2);
        char buff[12];
        sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,6,i2);
        sprintf(buff, "%d", $8); i2 = checkTab(buff); insertInto(i1,7,i2);
        int agentIndex = addAgent();
        sprintf(buff, "%d", agentIndex);  insertInto(i1, 8, agentIndex); // On insère l'index de l'agent dans la table des symboles
    } else {
        fprintf(stderr, RED"[%d]"CRESET" -> Le type d'agent "MAG"%s"CRESET" n'as pas été déclaré avant l'agent "MAG"%s"CRESET"\n", yylineno, $4, $2);
    }

}
liste_affect_attributs : affect_attribut {}
                        | affect_attribut VG liste_affect_attributs {}
affect_attribut : IDF EG valeur_attribut { 
    setAttributName($3,$1);
}
valeur_attribut : INT {AgentAttribut a; a.type = TA_INT; a.value.entier = $1; $$ = addAttribut(a);}
                | REEL {AgentAttribut a; a.type = TA_DOUBL; a.value.reel = $1; $$ = addAttribut(a);}
                | CH {AgentAttribut a; a.type = TA_CH; strcpy(a.value.chaine, $1); $$ = addAttribut(a);}
                | CAR {AgentAttribut a; a.type = TA_CAR; a.value.caractere = $1; $$ = addAttribut(a);}
                | BOOL {AgentAttribut a; a.type = TA_BOOL; a.value.entier = atoi($1); $$ = addAttribut(a);}
new_context : NCT IDF CO INT CF {  
        int i1 = checkTab($2);
        int i2;
        char buff[12];
        sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,5,i2);
    }
    | NCT IDF CO INT VG INT VG INT VG INT CF {
        int i1 = checkTab($2); 
        int i2;
        char buff[12];
        sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,5,i2);
        sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,6,i2);
        sprintf(buff, "%d", $8); i2 = checkTab(buff); insertInto(i1,7,i2);
        sprintf(buff, "%d", $10); i2 = checkTab(buff); insertInto(i1,8,i2);
    }

%%

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <fichier d'entrée> <nom de sortie sans extension>\n", argv[0]);
        return 1;
    }

    // Redirige le fichier d'entrée vers stdin
    FILE *input = freopen(argv[1], "r", stdin);
    if (input == NULL) {
        perror("Erreur lors de l'ouverture du fichier d'entrée");
        return 1;
    }

    // Construire nom du fichier de sortie avec extension .m
    char output_file[256];
    snprintf(output_file, sizeof(output_file), "%s.m", argv[2]);

    initSymbolTable();
    initCurrentAttributs();
    initAgents();

    yyparse();
    //prettyPrint(); Affichage table des symboles
    printf("Fin des analyses lexicale et syntaxique\n");
    params p = semantic_anal();
    if (!p.result) {
        fprintf(stderr, BRED"Erreurs lors de l'analyse sémantique"CRESET"\n");
    } else {
        printf("Analyse sémantique terminée\n");
        transpile(output_file,p);
        printf("Fichier de sortie généré avec succès : "BLU"%s\n"CRESET, output_file);
    }

    freeAllAgents();
    freeSymbolTable();
    return 0;
}



void yyerror(char *s)
{
    fprintf(stderr, "Erreur à la ligne %d : %s\n", yylineno, s);
}
