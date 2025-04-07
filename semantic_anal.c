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

params semantic_anal(){
    params p;
    p.nbTypeAgents = 0;
    p.result = 1;
    for (int i = 0; i < tab1_size; i++) {
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_ENV){
            setEnvValues(&p.x, &p.y, i); // Affecte la taille de l'environnement
            continue;
        } 
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_CONT){
            if(!isValidContStrenght(i)) p.result = 0; //Vérifie la force du contexte
            if(tab1[i][5] != 0){
                if(!isValidPosition(i,p.x,p.y)) p.result = 0; //Vérifie la position du contexte si contexte localisé
            }
            continue;
        }
        if(tab1[i][0] == C_IDF && tab1[i][4] == TO_AG){
            if(!isValidPosition(i,p.x,p.y)) p.result = 0; //Vérifie la position de l'agent si agent localisé
            if(!isValidAgentAttributs(i)) p.result = 0; //Vérifie le nombre d'attributs de l'agent
            p.nbTypeAgents ++;

            continue;
        }
    }
    return p;
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

// ! Atention on considère, que deux types d'agenst ne peuvent pas avoir le même nom pour un attributs

int isValidAgentAttributs(int index){
    int line = tab1[index][3]; // Ligne de déclaration de l'agent
    int typeAgent = tab1[index][5]; // Index du type d'agent 
    int indexAgent = tab1[index][8]; // Index de l'agent déclaré
    Agent* agent = getAgent(indexAgent); // Agent déclaré
    int nbTypeAAtributs = tab1[typeAgent][5];// Nombre d'attributs du type d'agent
    int nbAgentAAtributs = agent->attributs_size; // Nombre d'attributs de l'agent déclaré

    if(nbTypeAAtributs != nbAgentAAtributs) { 
        char* agentName = at(index); // Nom de l'agent déclaré
        char* typeAgentName = at(typeAgent); // Nom du type d'agent
        fprintf(stderr,RED"[%d]"CRESET" -> Erreur: "MAG"[%s] "CRESET"Le nombre d'attributs de l'agent déclaré ne correspond pas au nombre d'attributs du type "CYN"%s"CRESET"\n", line, agentName,typeAgentName);
        free(agentName);
        free(typeAgentName);
        return 0;
    } 

    for(int i = 0; i < nbTypeAAtributs ; i++){
        char* nomAttrTypeA = at(typeAgent + i + 1); // Nom de l'attribut du type d'agent
        char* nomAttrAgent = agent->attributs[i].attr; // Nom de l'attribut de l'agent déclaré
        int typeAtrrTypeA = tab1[typeAgent + i + 1][5]; // Type de l'attribut du type d'agent
        int typeAtrrAgent = agent->attributs[i].type;

        if(strcmp(nomAttrTypeA, nomAttrAgent) != 0) { // Vérifie si le nom de l'attribut de l'agent déclaré est le même que celui du type d'agent
            char* agentName = at(index); // Nom de l'agent déclaré
            char* typeAgentName = at(typeAgent); // Nom du type d'agent
            fprintf(stderr,
                RED"[%d]"CRESET" -> Erreur: "MAG"[%s] "CRESET"Le nom de l'attribut "CYN"%s"CRESET" de l'agent ne correspond pas au nom de l'attribut "CYN"%s"CRESET" du type d'agent "CYN"%s"CRESET"\n", 
                line, agentName,nomAttrAgent,nomAttrTypeA,typeAgentName);
            free(agentName);
            free(typeAgentName);
            free(nomAttrTypeA);
            return 0;
        }
        if(typeAtrrTypeA != typeAtrrAgent) { // Vérifie si le type de l'attribut de l'agent déclaré est le même que celui du type d'agent
            char* agentName = at(index); // Nom de l'agent déclaré
            char* typeAgentName = at(typeAgent); // Nom du type d'agent
            const char* types[] = {"", "int", "double", "char", "string", "bool"};
            fprintf(stderr,
                RED"[%d]"CRESET" -> Erreur: "MAG"[%s] "CRESET"Le type de l'attribut "CYN"%s : %s"CRESET" de l'agent ne correspond pas au type de l'attribut "CYN"%s : %s"CRESET" du type d'agent "CYN"%s "CRESET"\n",
                line, agentName,nomAttrAgent,types[typeAtrrTypeA], nomAttrTypeA,types[typeAtrrAgent],typeAgentName);
            free(agentName);
            free(typeAgentName);
            free(nomAttrTypeA);
            return 0;
        }
        free(nomAttrTypeA);
    }

    return 1;
}