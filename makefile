# Détection automatique du système d'exploitation
OS := $(shell uname 2>/dev/null || echo Windows)

# Définitions des commandes en fonction de l'OS
ifeq ($(OS), Windows)
    FLEX = win_flex
    CC = gcc
    EXE = .exe
    LFLAGS =
    CFLAGS = -Wall
    RM = del /F /Q
else
    FLEX = lex
    CC = gcc
    EXE =
    LFLAGS = -lfl
    CFLAGS = -Wall
    RM = rm -f
endif

# Fichiers
SRC = analyseur.lex
LEX_SRC = analyseur.yy.c
OUT = analyseur$(EXE)

# Règle principale
all: $(OUT)

# Génération de analyseur.yy.c
$(LEX_SRC): $(SRC)
	$(FLEX) -o $@ $<

# Compilation directe
$(OUT): $(LEX_SRC)
	$(CC) $(CFLAGS) $< -o $@ $(LFLAGS)

# Nettoyage des fichiers générés
clean:
	$(RM) $(LEX_SRC) $(OUT)
