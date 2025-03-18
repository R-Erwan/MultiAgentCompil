
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

