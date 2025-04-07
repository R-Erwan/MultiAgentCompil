#ifndef AGENTS_H
#define AGENTS_H

enum typeAtrr {
    TA_INT = 1,
    TA_DOUBL = 2,
    TA_CAR = 3,
    TA_CH = 4,
    TA_BOOL = 5,
};

typedef struct {
    char attr[100];
    int type;
    union {
        int entier;
        char chaine[100];
        char caractere;
        float reel;
    } value;
} AgentAttribut;

typedef struct {
    AgentAttribut* attributs;
    int attributs_size;
} Agent;

void initAgents();
void initCurrentAttributs();
int addAttribut(AgentAttribut attr);
void setAttributName(int index, char* name);
int addAgent();
Agent* getAgent(int i);
void printAgent(int i);
void printAllAgents();
void freeAllAgents();


#endif // AGENTS_H