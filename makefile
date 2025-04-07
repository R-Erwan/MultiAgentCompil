# Détection automatique du système d'exploitation
OS := $(shell uname 2>/dev/null || echo Windows)

# Définitions des commandes en fonction de l'OS
ifeq ($(OS), Windows)
    FLEX = win_flex
    YACC = win_bison
    CC = gcc
    EXE = .exe
    LFLAGS =
    CFLAGS = -Wall
    RM = del /F /Q
else
    FLEX = lex
    YACC = bison
    CC = gcc
    EXE =
    LFLAGS = -lfl
    CFLAGS = -Wall -Wextra -g
    RM = rm -f
endif

# Fichiers sources
LEX_SRC = analyseur.lex
YACC_SRC = analyseur.yacc
SYMBOL_TABLE_SRC = symbol_table.c
SYMBOL_TABLE_HDR = symbol_table.h
SEMANTIC_ANAL_SRC = semantic_anal.c
SEMANTIC_ANAL_HDR = semantic_anal.h
AGENT_SRC = agents.c
AGENT_HDR = agents.h


# Fichiers générés
LEX_OUT = analyseur.yy.c
YACC_OUT_C = y.tab.c
YACC_OUT_H = y.tab.h

# Objets
OBJS = $(LEX_OUT:.c=.o) $(YACC_OUT_C:.c=.o) $(SYMBOL_TABLE_SRC:.c=.o) $(SEMANTIC_ANAL_SRC:.c=.o) $(AGENT_SRC:.c=.o)


# Fichiers exécutable
OUT = analyseur$(EXE)

# Règle principale
all: $(OUT)

# Génération de y.tab.c et y.tab.h
$(YACC_OUT_C) $(YACC_OUT_H): $(YACC_SRC)
	$(YACC) -d -o $(YACC_OUT_C) $(YACC_SRC)

# Génération de analyseur.yy.c
$(LEX_OUT): $(LEX_SRC) $(YACC_OUT_H)
	$(FLEX) -o $@ $<

semantic_anal.o: semantic_anal.c semantic_anal.h symbol_table.h
	$(CC) $(CFLAGS) -c $< -o $@

# Compilation des fichiers .c en .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compilation finale de l'exécutable
$(OUT): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LFLAGS)

# Nettoyage des fichiers de compilation mais conserve l'exécutable
clean:
	$(RM) $(LEX_OUT) $(YACC_OUT_C) $(YACC_OUT_H) $(OBJS)

# Nettoyage complet, y compris l'exécutable
distclean: clean
	$(RM) $(OUT)
