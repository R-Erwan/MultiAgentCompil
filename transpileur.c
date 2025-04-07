#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "transpileur.h"
#include "symbol_table.h"
#include "semantic_anal.h"
#include "agents.h"
#include "rgbColor.h"

int transpile(char *output_file, params p) {
    FILE *output = fopen(output_file, "w");
    if (output == NULL) {
        fprintf(stderr, "Error opening output file: %s\n", output_file);
        return 0;
    }

    char* envName;
    RGBColor bg = {0, 0, 0};
    RGBColor contColor = {255, 255, 255};
    RGBColor* colors = generateColors(p.nbTypeAgents, bg, contColor);
    int* typesAgents = calloc(p.nbTypeAgents, sizeof(int));    
    int countTA = 0;

    for (int i = 0; i < tab1_size; i++) {
        /* ===== ENVIRONNEMENT ===== */
        if (tab1[i][0] == C_IDF) {
            if (tab1[i][4] == TO_ENV) {
                // Gérer le cas où c'est un environnement
                envName = at(i);  // Récupère le nom de l'environnement
                char* x = at(tab1[i][5]);
                char* y = at(tab1[i][6]);
                fprintf(output,"%s = zeros(%s,%s,3);\n", envName, x, y);
            } 
        /* ===== AGENT ===== */
            else if (tab1[i][4] == TO_AG) {
                int typeAgentIndex = tab1[i][5]; // Index du type d'agent
                int newTypeAgent = 1;
                RGBColor color;

                for (int j = 0; j < p.nbTypeAgents; j++) {
                    if (typeAgentIndex == typesAgents[j]) {
                        color = colors[j];
                        newTypeAgent = 0;
                        break;
                    }
                }

                if (newTypeAgent) {
                    typesAgents[countTA] = typeAgentIndex;
                    color = colors[countTA];
                    countTA++;
                }
                
                char* posX = at(tab1[i][6]);
                char* posY = at(tab1[i][7]);
                int x = atoi(posX);
                int y = atoi(posY);

                fprintf(output, "%s(%d,%d,:) = [%d,%d,%d];\n",envName,x,y,color.r, color.g, color.b);
            } 
            /* ===== CONTEXTE ===== */
            else if (tab1[i][4] == TO_CONT){
                ;
            }
        }
    }

    fclose(output);
    free(colors);
    free(typesAgents);
    return 1;
}