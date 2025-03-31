#ifndef SYMBOL_TABLE_H

#define SYMBOL_TABLE_H

#define NBCOLONNES 4

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

enum typeAtt {
    TA_INT = 1,
    TA_DOU = 2,
    TA_CAR = 3,
    TA_STR = 4,
    TA_BOO = 5
};

// Variables globales externes
extern int** tab1;
extern int tab1_size;
extern char* tab2;
extern int tab2_size;
extern int lastTypeObj;
extern int lastTypeAtt;

// Fonctions
int checkAndUpdateTab(int categorie);
void affTab();
void prettyPrint();
void initSymbolTable();
void freeSymbolTable();

#endif // SYMBOL_TABLE_H
