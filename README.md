
# MultiAgentCompil

## Etape 1 Liste des unités lexicales
- **Mot clé Environnement** : Chaîne « *Environnement* »
- **Identificateur** : chaîne de caractères de longueur supérieure ou égale à 1 constituée de lettres majuscules et minuscules non accentuées, de chiffres et de « _ », dont le premier caractère est une lettre
- **Crochet ouvrant** : Caractère *[*
- **Crochet fermant** : Caractère ]**
- **Nombre entier** : Chaîne de caractère constituée de chiffres entre 0 et 9 (au moins 1) et ne commençant pas par 0
- **Virgule** : Caractère *,*
- **Mot clé NewTypeAgent** : Chaîne « *NewTypeAgent* »
- **Accolade ouvrante** : Caractère *{*
- **Accolade fermante** : Caractère *}*
- **Deux points** : Caractère *:*
- **Type d’attribut** : Chaîne appartenant à l’ensembl *{int, double, char, string, boolean}*
- **Mot clé NewAgent** : Chaîne « *NewAgent* »
- **Egal** : Caractère *=*
- **Nombre réel** : Chaîne de caractères constituée de chiffres (au moins 1), commençant éventuellement par un signe (+ ou -), et comportant éventuellement une virgule (précédée et suivie d’au moins un chiffre)
- **Caractère** : Chaîne de 3 caractères constituée d’une cote (‘), d’un caractère quelconque et d’une cote
- **Chaîne de caractères** : Chaîne de caractères quelconques (au moins 1) entre guillemets
- **Booléen** : Chaîne appartenant à l’ensemble *{TRUE, FALSE}*
- **Mot clé NewContexte** : Chaîne « *NewContexte* »

## Etape 3 Grammaire décrivant la syntaxe des fichiers d'entrée 

**Axiome :**  S 

**Règles :**  
- **S** -> ENV IDF CO INT VG INT CF D 
- **D** -> NTYPA IDF AO LAF AF D | NAG IDF DPT IDF CO INT VG INT CF AO LAA AF D 
   | NCT IDF CO INT CF D | NCT IDF CO INT VG INT VG INT VG INT CF D | λ
- **LAF** -> IDF DPT T LAF | IDF DPT T
- **LAA** -> IDF EG V LAA | IDF EG V | λ
- **T** -> TINT | TDOUBL | TCAR | TCH | TBOOL
- **V** -> INT | REEL | CAR | CH | BOOL

**Symboles terminaux :** 

    ENV, NTYPA, NAG, NCT, IDF, INT, REEL, CAR, CH, BOOL, 
    TINT, TDOUBL, TCAR, TCH, TBOOL, AO, AF, CO, CF, VG, DPT, EG

**Symboles non terminaux :**

    S, D, LAF, LAA, T, V
    
    S -> Axiome
    D -> Déclaration
    LAF -> Liste d'attributs formel (paramètres des agents)
    LAA -> Liste d'attributs actuels (valeurs attribuées aux paramètres)
    T -> Type de données (int, double, char, ect...)
    V -> Valeur (42, 38.74, 'c', "Hello World", true/false)
