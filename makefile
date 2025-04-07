# Détection de l'OS
OS := $(shell uname 2>/dev/null || echo Windows)

ifeq ($(OS), Windows)
    FLEX = win_flex
    YACC = win_bison
    EXE = .exe
    RM = del /F /Q
    LFLAGS =
    CFLAGS = -Wall
else
    FLEX = lex
    YACC = bison
    EXE =
    RM = rm -f
    LFLAGS = -lfl
    CFLAGS = -Wall -Wextra -g
endif

CC = gcc

# Générés
LEX_SRC = mag.lex
YACC_SRC = mag.yacc
LEX_OUT = analyseur.yy.c
YACC_OUT_C = y.tab.c
YACC_OUT_H = y.tab.h

# Auto-détection des fichiers sources, hors lex/yacc générés
SRCS = $(filter-out $(LEX_OUT) $(YACC_OUT_C), $(wildcard *.c))
OBJS = $(SRCS:.c=.o) $(LEX_OUT:.c=.o) $(YACC_OUT_C:.c=.o)

OUT = mag$(EXE)

# Cible principale
all: $(OUT)

# Fichiers générés
$(YACC_OUT_C) $(YACC_OUT_H): $(YACC_SRC)
	$(YACC) -d -o $(YACC_OUT_C) $(YACC_SRC)

$(LEX_OUT): $(LEX_SRC) $(YACC_OUT_H)
	$(FLEX) -o $@ $<

# Compilation générique
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link final
$(OUT): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS) -lm

# Nettoyage
clean:
	$(RM) $(LEX_OUT) $(YACC_OUT_C) $(YACC_OUT_H) *.o

distclean: clean
	$(RM) $(OUT)
