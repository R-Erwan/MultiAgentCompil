# MultiAgentCompil

A compiler that translates a domain-specific language (DSL) describing multi-agent environments into MATLAB/Octave visualization scripts. The generated code renders a 2D grid where agents and their influence zones (contexts) are represented as colored regions in a bitmap image.

---

## Overview

MultiAgentCompil implements a classic compiler pipeline - lexing, parsing, semantic analysis, and code generation - targeting MATLAB as the output language. Users write a high-level description of a simulation environment (grid dimensions, agent types, agent instances with positions, and contextual influence zones), and the compiler produces a `.m` script that generates a color-coded BMP image of the environment.

```
source.mag  ──►  Lexer  ──►  Parser  ──►  Semantic Analysis  ──►  Transpiler  ──►  output.m
                (Flex)       (Bison)       (symbol table)          (MATLAB codegen)
```

---

## Features

- Custom DSL for declaring multi-agent environments
- Full compiler pipeline: lexical analysis → parsing → semantic validation → code generation
- Symbol table with a two-array architecture (metadata table + string pool)
- Semantic checks: position bounds, context strength range [0, 100], attribute type matching
- Automatic distinct color generation for agent types (HSV-based, maximally separated)
- Cross-platform build (Linux/macOS with `flex`/`bison`, Windows with `win_flex`/`win_bison`)
- Output: MATLAB/Octave `.m` script producing a BMP image via `imwrite`

---

## Language Reference

### Grammar (BNF)

```
program          → decla_env suite_prog

decla_env        → ENV IDF : INT × INT

suite_prog       → instruction suite_prog
                 | ε

instruction      → new_type_agent
                 | new_agent
                 | new_context

new_type_agent   → NTA IDF { liste_decl_attributs }

new_agent        → NAG IDF : IDF [ INT , INT ] { liste_affect_attributs }

new_context      → NCT IDF [ INT , INT ] INT

liste_decl_attributs  → decl_attribut liste_decl_attributs | ε
decl_attribut         → type IDF ;

liste_affect_attributs → affect_attribut liste_affect_attributs | ε
affect_attribut        → IDF = valeur ;

type             → int | double | char | string | boolean

valeur           → INT | REEL | CAR | CH | BOOL
```

### Lexical Tokens

| Token | Description |
|-------|-------------|
| `ENV` | Keyword `Environnement` |
| `NTA` | Keyword `NewTypeAgent` |
| `NAG` | Keyword `NewAgent` |
| `NCT` | Keyword `NewContexte` |
| `IDF` | Identifier `[a-zA-Z][a-zA-Z0-9_]*` |
| `INT` | Integer literal |
| `REEL` | Floating-point literal |
| `CAR` | Character literal `'x'` |
| `CH` | String literal `"..."` |
| `BOOL` | Boolean literal `true` / `false` |
| `type` | Primitive types: `int`, `double`, `char`, `string`, `boolean` |

### Example Source File

```
Environnement monde : 100 × 30

NewTypeAgent Soldat {
    int     id ;
    string  name ;
    boolean active ;
}

NewTypeAgent Medic {
    int    id ;
    double heal ;
}

NewAgent a1 : Soldat [ 10 , 5 ] {
    id     = 1 ;
    name   = "Alpha" ;
    active = true ;
}

NewAgent a2 : Medic [ 50 , 15 ] {
    id   = 2 ;
    heal = 3.5 ;
}

NewContexte zone1 [ 30 , 10 ] 60
NewContexte zone2 [ 70 , 20 ] 40
```

### Semantic Rules

| Rule | Constraint |
|------|-----------|
| Agent position | Must be within environment bounds (1 ≤ x ≤ width, 1 ≤ y ≤ height) |
| Context strength | Integer in [0, 100] |
| Context position | Center must be within environment bounds |
| Agent attributes | Must match the declared type (count, names, and value types) |

---

## Architecture

### Compiler Pipeline

| Stage | Files | Role |
|-------|-------|------|
| Lexer | `mag.lex` | Tokenizes source, populates symbol table entries |
| Parser | `mag.yacc` | Validates grammar, drives semantic actions |
| Symbol table | `symbol_table.c/h` | Stores all identifiers and literals |
| Semantic analysis | `semantic_anal.c/h` | Validates constraints listed above |
| Agent store | `agents.c/h` | Accumulates agent attribute values |
| Transpiler | `transpileur.c/h` | Emits MATLAB code |
| Color utility | `rgbColor.c/h` | Generates maximally distinct colors per agent type |

### Symbol Table Design

The symbol table uses a two-array architecture:

- **`tab1`** - metadata matrix with 9 columns per entry: category, position in `tab2`, length, line number, object type, and 4 auxiliary fields.
- **`tab2`** - contiguous string pool storing raw lexeme bytes.

Both arrays grow dynamically via `realloc` as symbols are inserted during lexing.

### Generated MATLAB Code

The transpiler produces a `.m` script structured as follows:

1. Allocate a 3D RGB array: `environment = zeros(width, height, 3)`
2. For each context, flood-fill a circular region with the context color
3. Place each agent as a single colored pixel at its declared position
4. Export: `imwrite(environment, 'output.bmp', 'bmp')`

Agent colors are computed in HSV space, evenly spaced in hue, and filtered to ensure sufficient perceptual distance from the background and context colors.

---

## Build

### Prerequisites

| Platform | Tools required |
|----------|---------------|
| Linux / macOS | `gcc`, `flex`, `bison`, `make` |
| Windows | `gcc`, `win_flex`, `win_bison`, `make` |

MATLAB or GNU Octave is required only to **run** the generated `.m` files, not to build the compiler.

### Compilation

```bash
make            # build the compiler (produces 'mag' or 'mag.exe')
make clean      # remove intermediate generated files
make distclean  # full clean including the binary
```

The Makefile detects the OS automatically via `uname`.

---

## Usage

```bash
./mag <input_file> <output_name>
```

- `<input_file>` - path to the `.mag` source file
- `<output_name>` - base name for the generated MATLAB script (no extension)

This produces `<output_name>.m`. Run it in MATLAB or Octave to generate the BMP image.

```matlab
% In MATLAB / Octave:
run('output.m')
```

---

## Project Structure

```
MultiAgentCompil/
├── mag.lex             # Flex lexer rules
├── mag.yacc            # Bison grammar and semantic actions
├── symbol_table.c/h    # Symbol table (two-array design)
├── semantic_anal.c/h   # Semantic validation
├── agents.c/h          # Agent attribute store
├── transpileur.c/h     # MATLAB code generator
├── rgbColor.c/h        # HSV color generation and distance
├── ANSI-color-codes.h  # Terminal color macros
├── makefile            # Cross-platform build
└── doc/
    ├── exemple1.txt    # Lexer stress test
    ├── exemple2.txt    # Syntax example
    ├── exemple3.txt    # Full simulation example
    └── *.txt           # Expected outputs and error traces
```

---

## License

This project is provided for academic and educational purposes.
