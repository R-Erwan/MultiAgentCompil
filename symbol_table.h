#ifndef SYMBOL_TABLE_H

#define SYMBOL_TABLE_H

#define NBCOLONNES 9

// Catégories des éléments
enum categorie {
    C_IDF = 1,
    C_ENT = 2,
    C_REEL = 3,
    C_CHAR = 4,
    C_CHAINE = 5,
};

// Types d'objets identificateurs
enum typeObj {
    TO_ENV = 1,
    TO_TYPA = 2,
    TO_ATTR = 3,
    TO_AG = 4,
    TO_CONT = 5
};

// Variables globales externes
extern int** tab1;
extern int tab1_size;
extern char* tab2;
extern int tab2_size;
extern int lastTypeObj;

// Fonctions
int checkTab(char* text);
void insertInto(int i, int j, int value);
int checkAndUpdateTab(int categorie, char* text, int line);
void affTab();
void prettyPrint();
void initSymbolTable();
void freeSymbolTable();


#endif // SYMBOL_TABLE_H
