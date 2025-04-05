%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symbol_table.h"  // Inclusion de la table des symboles
    #include "semantic_anal.h"  // Inclusion des fonctions sémantiques

    void yyerror(char *s);
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

%start program

%%

program : decla_env suite_prog {}
decla_env : ENV IDF CO INT VG INT CF{
    int i1 = checkTab($2); 
    int i2;
    char buff[12];
    sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,4,i2);
    sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,5,i2);
}
suite_prog : instruction {}
            | instruction suite_prog {}
instruction : new_typ_agent {}
            | new_agent {}
            | new_context {}
new_typ_agent : NTYPA IDF AO liste_decla_attributs AF { 
    int i1 = checkTab($2);   // WTF ?
    for (int i = 0; i < $4.taille; i++) {
        insertInto($4.tab[i], 5, i1); // On insère, pour chaque attribut le type d'aggent auquel il appartient
        }
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
    insertInto(i1,4,$3);
}
type_attribut : TINT { $$ = TA_INT; }
               | TDOUBL { $$ = TA_DOUBL; }
               | TCAR { $$ = TA_CAR; }
               | TCH { $$ = TA_CH; }
               | TBOOL { $$ = TA_BOOL; }

new_agent : NAG IDF DPT IDF CO INT VG INT CF AO liste_affect_attributs AF {
    int i1 = checkTab($2); 
    int i2;
    char buff[12];
    i2 = checkTab($4); insertInto(i1,4,i2);
    sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,5,i2);
    sprintf(buff, "%d", $8); i2 = checkTab(buff); insertInto(i1,6,i2);
}
liste_affect_attributs : affect_attribut {}
                        | affect_attribut VG liste_affect_attributs {}
affect_attribut : IDF EG valeur_attribut {}
valeur_attribut : INT {}
                | REEL {}
                | CH {}
                | CAR {}
                | BOOL {}
new_context : NCT IDF CO INT CF {  
        int i1 = checkTab($2);
        int i2;
        char buff[12];
        sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,4,i2);
    }
    | NCT IDF CO INT VG INT VG INT VG INT CF {
        int i1 = checkTab($2); 
        int i2;
        char buff[12];
        sprintf(buff, "%d", $4); i2 = checkTab(buff); insertInto(i1,4,i2);
        sprintf(buff, "%d", $6); i2 = checkTab(buff); insertInto(i1,5,i2);
        sprintf(buff, "%d", $8); i2 = checkTab(buff); insertInto(i1,6,i2);
        sprintf(buff, "%d", $10); i2 = checkTab(buff); insertInto(i1,7,i2);
    }

%%

int main() {
    initSymbolTable();  // Initialisation de la table des symboles

    yyparse();  // Analyse du fichier d'entrée
    printf("\nFin des analyses lexicale et syntaxique\n");
   // semantic_anal();

    freeSymbolTable();  // Libération de la mémoire à la fin
    return 0;
}

extern int yylineno;
void yyerror(char *s)
{
    fprintf(stderr, "Erreur à la ligne %d : %s\n", yylineno, s);
}
