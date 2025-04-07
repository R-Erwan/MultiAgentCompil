#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic_anal.h"
#include "symbol_table.h"
#include "agents.h"

extern int** tab1;
extern int tab1_size;
extern char* tab2;
extern int tab2_size;

int semantic_anal(){
    int envX;
    int envY;
    int error = 1;
    for (int i = 0; i < tab1_size; i++) {
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_ENV){
            setEnvValues(&envX, &envY, i); // Affecte la taille de l'environnement
            continue;
        } 
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_CONT){
            if(!isValidContStrenght(i)) error = 0; //Vérifie la force du contexte
            if(tab1[i][5] != 0){
                if(!isValidPosition(i,envX,envY)) error = 0; //Vérifie la position du contexte si contexte localisé
            }
            continue;
        }
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_AG){
            if(!isValidPosition(i,envX,envY)) error = 0; //Vérifie la position de l'agent si agent localisé

            continue;
        }
    }
    return error;
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

void setEnvValues(int* envX, int* envY, int index){
    char* X = at(tab1[index][5]);
    char* Y = at(tab1[index][6]);
    *envX = atoi(X);
    *envY = atoi(Y);
    free(X);
    free(Y);
}

int isValidContStrenght(int index) {
    int line = tab1[index][3];
    char* strenght = at(tab1[index][5]);
    int value = atoi(strenght);
    if(value < 0 || value > 100) {
        char* agentName = at(index);
        fprintf(stderr, RED"[%d]"CRESET"-> Erreur: "MAG"[%s -> %d] "CRESET"La force du contexte doit être comprise entre 0 et 100\n", line, agentName, value);
        free(strenght);
        free(agentName);
        return 0;
    }
    free(strenght);
    return 1;
}

int isValidPosition(int index, int envX, int envY) {
    int line = tab1[index][3];
    char* posX = at(tab1[index][6]);
    char* posY = at(tab1[index][7]);
    int x = atoi(posX);
    int y = atoi(posY);
    if(x < 0 || x >= envX || y < 0 || y >= envY) {
        char* agentName = at(index);
        fprintf(stderr, RED"[%d]"CRESET" -> Erreur: "MAG"[%s -> [%d,%d]] "CRESET"Position du contexte ou de l'agent invalide dans l'environnement "CYN"(%d, %d)"CRESET"\n", line, agentName, x, y, envX, envY);
        free(posX);
        free(posY);
        free(agentName);
        return 0;
    }
    free(posX);
    free(posY);
    return 1;
}
/*
int isValidAgentAttributs(int index){
    int line = tab1[index][3]; // Ligne de déclaration de l'agent
    int typeAgent = tab1[index][5]; // Type d'agent
    int indexAgent = tab1[index][8]; // Index de l'agent déclaré
    Agent* agent = getAgent(indexAgent); // Agent déclaré
    int nbTypeAAtributs = 

}*/