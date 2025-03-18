#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"


// Définition des variables globales
int** tab1 = NULL;
int tab1_size = 0;
char* tab2 = NULL;
int tab2_size = 0;
int lastTypeObj = 0;

extern char* yytext;

// Initialisation de la table des symboles
void initSymbolTable() {
    tab1 = malloc(sizeof(int*));
    tab2 = malloc(sizeof(char));
    tab2[0] = '\0';

    if (!tab1 || !tab2) {
        fprintf(stderr, "Erreur d'allocation mémoire\n");
        exit(EXIT_FAILURE);
    }
}

// Libération de la mémoire
void freeSymbolTable() {
    for (int i = 0; i < tab1_size; i++) {
        free(tab1[i]);
    }
    free(tab1);
    free(tab2);
}
int checkAndUpdateTab(int categorie) {
    for (int i = 0; i < tab1_size; i++) {
        // Utilisation de yytext pour rechercher dans tab2 (la chaîne des symboles)
        if (strncmp(yytext, &tab2[tab1[i][1]], tab1[i][2]) == 0) {
            lastTypeObj = 0;
            return i;
        }
    }

    // Réallocation de tab1 pour ajouter un nouvel élément
    tab1 = realloc(tab1, sizeof(int*) * (tab1_size + 1));
    if (!tab1) {
        fprintf(stderr, "Erreur de réallocation mémoire tab1\n");
        exit(EXIT_FAILURE);
    }

    // Allocation d'une nouvelle ligne dans tab1
    tab1[tab1_size] = malloc(sizeof(int) * NBCOLONNES);
    if (!tab1[tab1_size]) {
        fprintf(stderr, "Erreur d'allocation mémoire tab1[%d]\n", tab1_size);
        exit(EXIT_FAILURE);
    }

    int new_str_len = strlen(yytext);
    
    // Réallocation de tab2 pour ajouter la nouvelle chaîne
    tab2 = realloc(tab2, tab2_size + new_str_len + 1);
    if (!tab2) {
        fprintf(stderr, "Erreur de réallocation mémoire tab2\n");
        exit(EXIT_FAILURE);
    }

    // Remplissage des valeurs de tab1
    tab1[tab1_size][0] = categorie;
    tab1[tab1_size][1] = tab2_size;
    tab1[tab1_size][2] = new_str_len;
    tab1[tab1_size][3] = lastTypeObj;
    lastTypeObj = 0;

    // Copie de yytext dans tab2
    strcpy(&tab2[tab2_size], yytext);
    tab2_size += new_str_len;

    return tab1_size++;
}


// Affichage de la table des symboles
void affTab() {
    for (int i = 0; i < tab1_size; i++) {
        printf("%d : [%d, %d, %d, %d]\n", i, tab1[i][0], tab1[i][1], tab1[i][2], tab1[i][3]);
    }
    printf("%s\n", tab2);
}

// Affichage formaté de la table des symboles
void prettyPrint() {
    const char* categories[] = {"", "idf", "ent", "reel", "car", "cha"};
    const char* typeObj[] = {"", "env", "typA", "attr", "ag", "cont"};

    for (int i = 0; i < tab1_size; i++) {
        printf("%d : [%s, %d, %d, %s]\n", i, categories[tab1[i][0]], tab1[i][1], tab1[i][2], typeObj[tab1[i][3]]);
    }
    printf("%s\n", tab2);
}
