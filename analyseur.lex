%{
	#include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

//Data CST
    #define NBCOLONNES 4

//Categories éléments CST
    enum categorie {
        C_IDF = 1,
        C_ENT = 2,
        C_REEL = 3,
        C_CHAR = 4,
        C_CHAINE = 5
    };

//Type obj identificateur CST
    enum typeObj {
        TO_ENV = 1,
        TO_TYPA = 2,
        TO_ATTR = 3,
        TO_AG = 4,
        TO_CONT = 5
    };

//Variables globales
    int** tab1;
    int tab1_size = 0;
    char* tab2;
    int tab2_size = 0;
    int lastTypeObj = 0;

    int checkAndUpdateTab(int categorie);
    void affTab();
    void prettyPrint();
%}
%s CROCHETS
%%
Environnement		{printf("Environnement\n"); lastTypeObj = TO_ENV;}
NewTypeAgent		{printf("NewTypeAgent\n"); lastTypeObj = TO_TYPA;}
NewAgent		{printf("NewAgent\n"); lastTypeObj = TO_AG;}
NewContexte		{printf("NewContexte\n"); lastTypeObj = TO_CONT;}
int			{printf("Type d'attribut : %s\n",yytext);}
double			{printf("Type d'attribut : %s\n",yytext);}
char		 	{printf("Type d'attribut : %s\n",yytext);}
string			{printf("Type d'attribut : %s\n",yytext);}
boolean			{printf("Type d'attribut : %s\n",yytext);}
TRUE|FALSE		{printf("Booléen : %s\n",yytext);}
[a-zA-Z][a-zA-Z0-9_]*	{
    printf("Identificateur : %s\n",yytext);
    lastTypeObj = lastTypeObj == 0 ? TO_ATTR : lastTypeObj;
    checkAndUpdateTab(C_IDF); 
    }
"["			{printf("Crochet ouvrant\n");BEGIN CROCHETS;}
"]"			{printf("Crochet fermant\n");BEGIN INITIAL;}
","			{printf("Virgule\n");}
"{"			{printf("Accolade ouvrante\n");}
"}"			{printf("Accolade fermante\n");}
":"			{printf("Deux-points\n");}
[1-9][0-9]*		{printf("Nombre entier : %s\n",yytext); checkAndUpdateTab(C_ENT);}
"="			{printf("Egal\n");}
<INITIAL>[-+]?[0-9]+(","[0-9]+)?	{printf("Nombre réel : %s\n",yytext); checkAndUpdateTab(C_REEL);}
\"[^"]+\"		{printf("Chaîne de caractères : %s\n",yytext); checkAndUpdateTab(C_CHAINE); }
['].[']			{printf("Caractère : %s\n",yytext); checkAndUpdateTab(C_CHAR); }
(\n|\r\n|" ")+		;
.			{printf("Erreur lexicale. Caractère %s non reconnu\n",yytext);}
%%


int yywrap(){
    // affTab();
    prettyPrint();
    return 1;
}

int main() {
    tab1 = malloc(sizeof(int*));
    tab2 = malloc(sizeof(char));
    tab2[0] = '\0';
    if (!tab1 || !tab2) {
        fprintf(stderr, "Erreur d'allocation mémoire\n");
        return 1;
    }

    yylex();

    for (int i = 0; i < tab1_size; i++) {
        free(tab1[i]);
    }

    free(tab1);
    free(tab2);
    return 0;
}

int checkAndUpdateTab(int categorie){
    for(int i = 0; i < tab1_size; i++){
        if(strncmp(yytext,&tab2[tab1[i][1]],tab1[i][2]) == 0){
            lastTypeObj = 0;
            return i;
        }
    }
    tab1 = realloc(tab1, sizeof(int*) * (tab1_size + 1));

    if (!tab1) {
        fprintf(stderr, "Erreur de réallocation mémoire tab1\n");
        exit(EXIT_FAILURE);
    }

    tab1[tab1_size] = malloc(sizeof(int) * NBCOLONNES);
    if (!tab1[tab1_size]) {
        fprintf(stderr, "Erreur d'allocation mémoire tab1[%d]\n", tab1_size);
        exit(EXIT_FAILURE);
    }

    int new_str_len = strlen(yytext);
    tab2 = realloc(tab2, tab2_size + new_str_len + 1);
    if (!tab2) {
        fprintf(stderr, "Erreur de réallocation mémoire tab2\n");
        exit(EXIT_FAILURE);
    }


    tab1[tab1_size][0] = categorie;
    tab1[tab1_size][1] = tab2_size;
    tab1[tab1_size][2] = new_str_len;
    tab1[tab1_size][3] = lastTypeObj;
    lastTypeObj = 0;


    strcpy(&tab2[tab2_size],yytext);
    tab2_size += new_str_len;

    return tab1_size++;
}

void affTab() {
    for (int i = 0; i < tab1_size; i++) {
        printf("%d : [%d, %d, %d, %d]\n", i, tab1[i][0], tab1[i][1], tab1[i][2], tab1[i][3]);
    }
    printf("%s\n", tab2);
}

void prettyPrint(){
    const char* categories[] = {"", "idf", "ent", "reel", "car", "cha"};
    const char* typeObj[] = {"", "env", "typA", "attr", "ag", "cont"};

    for (int i = 0; i < tab1_size; i++) {
        printf("%d : [%s, %d, %d, %s]\n", i, categories[tab1[i][0]], tab1[i][1], tab1[i][2], typeObj[tab1[i][3]]);
    }
    printf("%s\n", tab2);
}