#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic_anal.h"


extern int** tab1;
extern int tab1_size;
extern char* tab2;
extern int tab2_size;

int semantic_anal(){
    printf("Analyse sémantique en cours\n");
    for (int i = 0; i < tab1_size; i++) {
        if(tab1[i][0] == C_IDF && tab1[i][3] == TO_CONT){
            isValidCont(i);
        }
    }
    printf("Analyse sémantique terminée\n");
    return 0;
}
 
char* at(int line){
    char* str = malloc(tab1[line][2] + 1); 
    if (!str) {
        fprintf(stderr, "Erreur d'allocation mémoire\n");
        exit(EXIT_FAILURE);
    }
    strncpy(str, tab2 + tab1[line][1], tab1[line][2]);
    str[tab1[line][2]] = '\0'; 
    return str;
}


int isValidCont(int index) {
    if (index + 1 >= tab1_size) {
        printf("Erreur: Index %d hors limites dans isValidCont\n", index);
        return 1;
    }
    char* value = at(index+1);
    int forces = atoi(value);
    free(value); // Libérer la mémoire
}