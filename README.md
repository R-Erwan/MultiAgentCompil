
# MultiAgentCompil

## Liste des unités lexicales
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

## Grammaire décrivant la syntaxe des fichiers d'entrée 

**Symboles terminaux (Vt):** 

    ENV (Environnement) 
    NTYPA (NewTypeAgent)  
    NAG (NewAgent) 
    NCT (NewContexte)  
    TINT (Type d'attribut int)  
    TDOUBL (Type d'attribut double)  
    TCAR (Type d'attribut caractère)  
    TCH (Type d'attribut chaîne)  
    TBOOL (Type d'attribut booléen)  
    BOOL (Booléen)  
    IDF (Identificateur)
    CO (Crochet ouvrant)  
    CF (Crochet fermant)  
    VG (Virgule)  
    AO (Accolade ouvrante)  
    AF (Accolade fermante)  
    DPT (Deux points)  
    INT (Nombre entier)  
    EG (Egal)  
    REEL (Nombre réel)  
    CH (Chaîne de caractères)  
    CAR (Caractère)

**Symboles non terminaux (Vn) :**

- Program 
- decla_env (déclaration d’environnement) 
- suite_prog (suite du programme, après déclaration de l’environnement) 
- instruction 
- new_typ_agent (déclaration d’un nouveau type d’agent) 
- liste_decla_attributs (liste de déclarations d’attributs) 
- decla_attribut (déclaration d’un attribut) 
- type_attribut 
- new_agent (déclaration d’un nouvel agent) 
- liste_affect_attributs (liste d’instanciations d’attributs)  
- affect_attribut (instanciation d’un attribut) 
- valeur_attribut 
- new_context (déclaration d’un nouveau contexte)

**Axiome :** 

    program

**Règles :**  

- **program** -> decla_env suite_prog 
- **decla_env** -> ENV IDF CO INT VG INT CF 
- **suite_prog** -> instruction | instruction suite_prog 
- **instruction** -> new_typ_agent | new_agent | new_context 
- **new_typ_agent** -> NTYPA IDF AO liste_decla_attributs AF 
- **liste_decla_attributs** - decla_attribut | decla_attribut VG liste_decla_attributs 
- **decla_attribut** -> IDF DPT type_attribut 
- **type_attribut** -> TINT | TDOUBL | TCAR | TCH | TBOOL 
- **new_agent** -> NAG IDF DPT IDF CO INT VG INT CF AO liste_affect_attributs AF
- **liste_affect_attributs** -> affect_attribut | affect_attribut VG liste_affect_attributs 
- **affect_attribut** -> IDF EG valeur_attribut 
- **valeur_attribut** -> INT | REEL | CH | CAR | BOOL 
- **new_context** -> NCT IDF CO INT CF | NCT IDF CO INT VG INT VG INT VG INT CF

## Compilation

Flex et Bison (Lex et Yacc) pour l'analyse lexicale et syntaxique.

**Pour compiler :** 
```bash
make -> Compilation
make clean -> Effacer les fichiers de compilation
make distclean -> Nettoyage complet y compris executable
```

**Exécuter**
```bash
./analyseur < <fichier d'entrée>
```

## Table des symboles

**symbol_table.c** et **symbole_table.h**
### Activer la table des symboles
Fichier : *analyseur.lex* 
```python
int yywrap(){
    //affTab(); // Décommenter pour voir la table des symboles
    //prettyPrint(); // Décommenter pour voir la table des symboles avec un affichage plus joli
    return 1;
}
```
### Structure table des symboles
- **Colonne 1** : Catégorie des éléments (IDF et constantes comme ENT, CAR, REEL ...)
- **Colonne 2** : Position de début dans le tab2
- **Colonne 3** : Pour les IDF, son type d'objet (environnement ENV, type d'agent TYPA, attribut ATTR, agent AG, contexte CONT)
- **Colonne 4** : Enregistre le numéro de ligne pour l'affichage d'erreur.
- **Colonne > 4** : D'autres informations en fonction de l'élement.

### Les colonnes > 3 : 
- **Pour les ENV** : 
    - *5* : indice de tab1 ou on trouve la largeur
    - *6* :  indice de tab1 ou on trouve la longeur
- **Pour les CONT** :
    - *5* : indice de tab1 ou on trouve la force
    - *6* : indice de tab1 ou ou trouve le numero de ligne
    - *7* : indice de tab1 ou on trouve le numéro de colonne
    - *8* : indice de tab1 ou ou trouve le rayon d'influence
- **Pour les ATTR** : 
    - *5* : le type d'attribut (1 = INT, 2 = DOUBLE, 3 = CARACTERE, 4 = CHAINE, 5 = BOOL)
    - *6* : le type d'agent déclaré duquel il est un attribut.
- **Pour les TYPA** : Rien en plus, on pourrait peut être mettre le nombre d'attribut qu'il as.
- **Pour les AG** : Il faut trouver une idée, pour dire ou trouver la valeur X pour l'attribut Y, mais il y a un nombre variable d'attribut, et apart avec un nombre infini de colonne, je vois pas.

### Exemple de sortit avec pretty print

```
0 : [idf, 0, 3, env, 1, 2, 0, 0]
1 : [ent, 3, 3, , 0, 0, 0, 0]
2 : [ent, 6, 2, , 0, 0, 0, 0]
3 : [idf, 8, 6, typA, 0, 0, 0, 0]
4 : [idf, 14, 5, attr, 3, 3, 0, 0]
5 : [idf, 19, 6, attr, 2, 3, 0, 0]
6 : [idf, 25, 2, ag, 3, 7, 8, 0]
7 : [ent, 27, 3, , 0, 0, 0, 0]
8 : [ent, 30, 2, , 0, 0, 0, 0]
9 : [car, 32, 3, , 0, 0, 0, 0]
10 : [reel, 35, 3, , 0, 0, 0, 0]
11 : [idf, 38, 2, ag, 3, 12, 13, 0]
12 : [ent, 40, 3, , 0, 0, 0, 0]
13 : [ent, 43, 2, , 0, 0, 0, 0]
14 : [car, 45, 3, , 0, 0, 0, 0]
15 : [reel, 48, 4, , 0, 0, 0, 0]
16 : [idf, 52, 2, ag, 3, 17, 18, 0]
17 : [ent, 54, 3, , 0, 0, 0, 0]
4 : [idf, 14, 5, attr, 3, 3, 0, 0]
5 : [idf, 19, 6, attr, 2, 3, 0, 0]
6 : [idf, 25, 2, ag, 3, 7, 8, 0]
7 : [ent, 27, 3, , 0, 0, 0, 0]
8 : [ent, 30, 2, , 0, 0, 0, 0]
9 : [car, 32, 3, , 0, 0, 0, 0]
10 : [reel, 35, 3, , 0, 0, 0, 0]
11 : [idf, 38, 2, ag, 3, 12, 13, 0]
12 : [ent, 40, 3, , 0, 0, 0, 0]
13 : [ent, 43, 2, , 0, 0, 0, 0]
14 : [car, 45, 3, , 0, 0, 0, 0]
15 : [reel, 48, 4, , 0, 0, 0, 0]
16 : [idf, 52, 2, ag, 3, 17, 18, 0]
17 : [ent, 54, 3, , 0, 0, 0, 0]
10 : [reel, 35, 3, , 0, 0, 0, 0]
11 : [idf, 38, 2, ag, 3, 12, 13, 0]
12 : [ent, 40, 3, , 0, 0, 0, 0]
13 : [ent, 43, 2, , 0, 0, 0, 0]
14 : [car, 45, 3, , 0, 0, 0, 0]
15 : [reel, 48, 4, , 0, 0, 0, 0]
16 : [idf, 52, 2, ag, 3, 17, 18, 0]
17 : [ent, 54, 3, , 0, 0, 0, 0]
15 : [reel, 48, 4, , 0, 0, 0, 0]
16 : [idf, 52, 2, ag, 3, 17, 18, 0]
17 : [ent, 54, 3, , 0, 0, 0, 0]
18 : [ent, 57, 2, , 0, 0, 0, 0]
19 : [reel, 59, 3, , 0, 0, 0, 0]
20 : [idf, 62, 5, cont, 21, 22, 8, 23]
21 : [ent, 67, 2, , 0, 0, 0, 0]
22 : [ent, 69, 3, , 0, 0, 0, 0]
23 : [ent, 72, 1, , 0, 0, 0, 0]
24 : [idf, 73, 5, cont, 2, 0, 0, 0]
rue50050pietongenretaillep140010'M'1,8p230020'F'1,65p3350151,7arbre254505pluie
```
