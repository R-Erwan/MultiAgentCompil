#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "agents.h"

AgentAttribut* current_attributs = NULL;
int agents_attr_size = 0;
int agents_attr_capacity = 10;

Agent* agents = NULL;
int agents_size = 0;
int agents_capacity = 10;

void initAgents() {
    agents = malloc(sizeof(Agent) * agents_capacity);
    if (!agents) {
        fprintf(stderr, "Erreur allocation agents\n");
        exit(EXIT_FAILURE);
    }
}

void initCurrentAttributs() {
    current_attributs = malloc(sizeof(AgentAttribut) * agents_attr_capacity);
    if (!current_attributs) {
        fprintf(stderr, "Erreur allocation attributs\n");
        exit(EXIT_FAILURE);
    }
}

int addAttribut(AgentAttribut attr) {
    if (agents_attr_size >= agents_attr_capacity) {
        agents_attr_capacity += 10;
        current_attributs = realloc(current_attributs, sizeof(AgentAttribut) * agents_attr_capacity);
        if (!current_attributs) {
            fprintf(stderr, "Erreur realloc attributs\n");
            exit(EXIT_FAILURE);
        }
    }
    current_attributs[agents_attr_size++] = attr;
    return agents_attr_size - 1;
}

void setAttributName(int index, char* name) {
    if (index < 0 || index >= agents_attr_size) {
        fprintf(stderr, "Index out of bounds\n");
        return;
    }
    strncpy(current_attributs[index].attr, name, sizeof(current_attributs[index].attr) - 1);
    current_attributs[index].attr[sizeof(current_attributs[index].attr) - 1] = '\0'; // Assurer la terminaison de la chaîne
}

int addAgent() {
    if (agents_size >= agents_capacity) {
        agents_capacity += 10;
        agents = realloc(agents, sizeof(Agent) * agents_capacity);
        if (!agents) {
            fprintf(stderr, "Erreur realloc agents\n");
            exit(EXIT_FAILURE);
        }
    }

    Agent new_agent;
    new_agent.attributs_size = agents_attr_size;
    new_agent.attributs = malloc(sizeof(AgentAttribut) * agents_attr_size);
    if (!new_agent.attributs) {
        fprintf(stderr, "Erreur alloc attributs agent\n");
        exit(EXIT_FAILURE);
    }
    memcpy(new_agent.attributs, current_attributs, sizeof(AgentAttribut) * agents_attr_size);

    agents[agents_size++] = new_agent;

    // Réinitialiser le tableau temporaire
    agents_attr_capacity = 10;
    memset(current_attributs, 0, sizeof(AgentAttribut) * agents_attr_capacity);
    agents_attr_size = 0;

    return agents_size - 1;
}

Agent* getAgent(int i) {
    if (i < 0 || i >= agents_size) {
        fprintf(stderr, "Index d'agent %d invalide.\n", i);
        return NULL;
    }
    return &agents[i];
}


// Affiche un agent donné
void printAgent(int i) {
    if (i < 0 || i >= agents_size) {
        printf("Index d'agent %d invalide.\n", i);
        return;
    }

    Agent agent = agents[i];
    printf("Agent #%d :\n", i);

    for (int j = 0; j < agent.attributs_size; ++j) {
        AgentAttribut attr = agent.attributs[j];
        printf("  - %s : ", attr.attr);
        switch (attr.type) {
            case 1: // entier
                printf("%d (int)\n", attr.value.entier);
                break;
            case 2: // réel
                printf("%f (float)\n", attr.value.reel);
                break;
            case 3: // caractère
                printf("'%c' (char)\n", attr.value.caractere);
                break;
            case 4: // chaîne
                printf("\"%s\" (string)\n", attr.value.chaine);
                break;
            case 5: // booléen
                printf("%s (bool)\n", attr.value.entier ? "true" : "false");
                break;
            default:
                printf("Type inconnu (%d)\n", attr.type);
                break;
        }
    }
    printf("\n");
}

// Affiche tous les agents
void printAllAgents() {
    printf("=== Liste des agents (%d au total) ===\n\n", agents_size);
    for (int i = 0; i < agents_size; ++i) {
        printAgent(i);
    }
}


void freeAllAgents() {
    for (int i = 0; i < agents_size; ++i) {
        free(agents[i].attributs);
    }
    free(agents);
    free(current_attributs);
}