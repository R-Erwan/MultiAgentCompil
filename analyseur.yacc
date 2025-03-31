%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
   // #include "symbol_table.h"  // Inclusion de la table des symboles

    void yyerror(char *s);
%}

%union {
    int valeur;
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

%start program

%%

program : decla_env suite_prog {}
decla_env : ENV IDF CO INT VG INT CF{}
suite_prog : instruction {}
            | instruction suite_prog {}
instruction : new_typ_agent {}
            | new_agent {}
            | new_context {}
new_typ_agent : NTYPA IDF AO liste_decla_attributs AF {}
liste_decla_attributs : decla_attribut {}
                        | decla_attribut VG liste_decla_attributs {}
decla_attribut : IDF DPT type_attribut {}
type_attribut : TINT {}
                | TDOUBL {}
                | TCAR {}
                | TCH {}
                | TBOOL {}
new_agent : NAG IDF DPT IDF CO INT VG INT CF AO liste_affect_attributs AF {}
liste_affect_attributs : affect_attribut {}
                        | affect_attribut VG liste_affect_attributs {}
affect_attribut : IDF EG valeur_attribut {}
valeur_attribut : INT {}
                | REEL {}
                | CH {}
                | CAR {}
                | BOOL {}
new_context : NCT IDF CO INT CF {}
            | NCT IDF CO INT VG INT VG INT VG INT CF {}

%%

int main() {
    initSymbolTable();  // Initialisation de la table des symboles

    yyparse();  // Analyse du fichier d'entrée
    printf("\nFin des analyses lexicale et syntaxique\n");
    

    freeSymbolTable();  // Libération de la mémoire à la fin
    return 0;
}

extern int yylineno;
void yyerror(char *s)
{
    fprintf(stderr, "Erreur à la ligne %d : %s\n", yylineno, s);
}
