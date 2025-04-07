%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    #include "symbol_table.h"  // Inclusion du fichier de la table des symboles

    extern union yylval;
%}

%s CROCHETS

%%

Environnement {
    lastTypeObj = TO_ENV; 
    return ENV;
}

NewTypeAgent {
    lastTypeObj = TO_TYPA; 
    return NTYPA;
}

NewAgent {
    lastTypeObj = TO_AG; 
    return NAG;
}

NewContexte {
    lastTypeObj = TO_CONT; 
    return NCT;
}

int {
    return TINT;
}

double {
    return TDOUBL;
}

char {
    return TCAR;
}

string {
    return TCH;
}

boolean {
    return TBOOL;
}

TRUE|FALSE {
    yylval.valeur = (strcmp(yytext, "TRUE") == 0) ? 1 : 0;
    return BOOL;
}

[a-zA-Z][a-zA-Z0-9_]* {
    lastTypeObj = lastTypeObj == 0 ? TO_ATTR : lastTypeObj;
    checkAndUpdateTab(C_IDF,yytext,yylineno);
    strcpy(yylval.chaine, yytext); 
    return IDF;
}
"[" {
    BEGIN CROCHETS; 
    return CO;
}
"]" {
    BEGIN INITIAL;
    return CF;
}
"," {
    return VG;
}
"{" {
    return AO;
}
"}" {
    return AF;
}
":" {
    return DPT;
}
[1-9][0-9]* {
    checkAndUpdateTab(C_ENT,yytext,yylineno);
    yylval.valeur = atoi(yytext);
    return INT;
}
"=" {
    return EG;
}
<INITIAL>[-+]?[0-9]+(","[0-9]+)? {
    checkAndUpdateTab(C_REEL,yytext,yylineno);
    yylval.reel = atof(yytext); 
    return REEL;
}
\"[^"]+\" {
    checkAndUpdateTab(C_CHAINE,yytext,yylineno); 
    strcpy(yylval.chaine, yytext);
    return CH;
}
['].['] {
    checkAndUpdateTab(C_CHAR,yytext,yylineno);
    yylval.caractere = yytext[1];
    return CAR;
}
\n  { yylineno++; }

[\t\r ]+ ;	/* skip white space */
. {printf("Erreur lexicale. Caractère %s non reconnu\n",yytext);}

%%

int yywrap(){
    return 1;
}