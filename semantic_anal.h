#ifndef SEMANTIC_ANAL_H

#define SEMANTIC_ANAL_H

#include "ANSI-color-codes.h"

int semantic_anal();
char* at(int line);
void setEnvValues(int* envX, int* envY, int index);
int isValidContStrenght(int index);
int isValidPosition(int index, int envX, int envY);
int isValidAgentAttributs(int index);

#endif // SEMANTIC_ANAL_H