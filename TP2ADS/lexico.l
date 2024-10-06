%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#define YYSTYPE char*

// Definición de estructuras para las listas
typedef struct Nodo {
    void *dato;
    struct Nodo *siguiente;
} Nodo;

typedef struct {
    Nodo *cabeza;
    Nodo *cola;
} Lista;

// Definiciones de tipos de datos
typedef struct {
    char *nombre;
    int frecuencia;
} Identificador;

typedef struct {
    char *cadena;
    int longitud;
} LiteralCadena;

typedef struct {
    char *palabra;
    int linea;
    int columna;
} PalabraReservada;

typedef struct {
    int valor;
} ConstanteDecimal;

typedef struct {
    int valor;
} ConstanteHexadecimal;

typedef struct {
    int valor;
} ConstanteOctal;

typedef struct {
    int parteEntera;
    float mantisa;
} ConstanteReal;

typedef struct {
    char valor;
} ConstanteCaracter;

typedef struct {
    char operador;
    int frecuencia;
} Operador;

typedef struct {
    char *cadena;
    int linea;
    int columna;
} CadenaNoReconocida;

// Definición de listas
Lista *identificadores, *literalesCadenas, *palabrasReservadas, *constantesDecimales, *constantesHexadecimales, *constantesOctales, *constantesReales, *constantesCaracteres, *operadores, *cadenasNoReconocidas;

// Funciones auxiliares
Lista* crearLista();
Nodo* crearNodo(void *dato);
void agregarIdentificador(const char *nombre);
void agregarLiteralCadena(const char *cadena);
void agregarPalabraReservada(const char *palabra, int linea, int columna);
void agregarConstanteDecimal(int valor);
void agregarConstanteHexadecimal(int valor);
void agregarConstanteOctal(int valor);
void agregarConstanteReal(float mantisa, int parteEntera);
void agregarConstanteCaracter(char valor);
void agregarOperador(char operador);
void agregarCadenaNoReconocida(const char *cadena, int linea, int columna);
void imprimirListados();
void inicializarListas();
void imprimirFrecuenciaOperadores();
void imprimirPalabrasReservadas();
void imprimirCadenasNoReconocidas();

// Variables globales
int linea = 1, columna = 1;

%}



DIGITO [0-9]
LETRA [a-zA-Z_]
ID ({LETRA}({LETRA}|{DIGITO})*)
HEX 0[xX][0-9a-fA-F]+
OCT 0[0-7]+
DEC {DIGITO}+
REAL {DIGITO}+"."{DIGITO}*
LITERAL_CADENA \".*\"
CARACTER_ENUMERADO '\'(.|\\[0tnr])\'|\'\\?.\'|'\\[abfnrtv\\''"'?]|'\0'

%%

input:
    { inicializarListas(); }
    { imprimirListados(); }
    ;

\n              { linea++; columna = 1; }

{ID}            { agregarIdentificador(yytext); columna += yyleng; }

"int"|"void"|"char"    { agregarPalabraReservada(yytext, linea, columna); columna += yyleng; }

"if"|"else"|"while"|"for"|"return" { agregarPalabraReservada(yytext, linea, columna); columna += yyleng; }

"sizeof"        { agregarPalabraReservada(yytext, linea, columna); columna += yyleng; }

{DEC}           { agregarConstanteDecimal(atoi(yytext)); columna += yyleng; }
{HEX}           { agregarConstanteHexadecimal(strtol(yytext, NULL, 0)); columna += yyleng; }
{OCT}           { agregarConstanteOctal(strtol(yytext, NULL, 0)); columna += yyleng; }
{REAL}          { float mantisa = modf(atof(yytext), &yyval.fval); agregarConstanteReal(mantisa, (int)yyval.fval); columna += yyleng; }

{CARACTER_ENUMERADO}   { agregarConstanteCaracter(yytext[1]); columna += yyleng; }

{LITERAL_CADENA} { agregarLiteralCadena(yytext); columna += yyleng; }

"(" | ")" | "{" | "}" | "*" | "=" | ";" | "+" {
    agregarOperador(yytext[0]);
    columna += yyleng;
}

.               { agregarCadenaNoReconocida(yytext, linea, columna); columna += yyleng; }

%%

int main() {
    yylex();
    return 0;
}

// Implementación de las funciones auxiliares

Lista* crearLista() {
    Lista *lista = (Lista*)malloc(sizeof(Lista));
    lista->cabeza = NULL;
    lista->cola = NULL;
    return lista;
}

Nodo* crearNodo(void *dato) {
    Nodo *nodo = (Nodo*)malloc(sizeof(Nodo));
    nodo->dato = dato;
    nodo->siguiente = NULL;
    return nodo;
}

void agregarIdentificador(const char *nombre) {
    Nodo *nodo = identificadores->cabeza;
    while (nodo) {
        Identificador *ident = (Identificador*)nodo->dato;
        if (strcmp(ident->nombre, nombre) == 0) {
            ident->frecuencia++;
            return;
        }
        nodo = nodo->siguiente;
    }
    Identificador *nuevoIdent = (Identificador*)malloc(sizeof(Identificador));
    nuevoIdent->nombre = strdup(nombre);
    nuevoIdent->frecuencia = 1;
    nodo = crearNodo(nuevoIdent);
    if (!identificadores->cabeza) {
        identificadores->cabeza = nodo;
    } else {
        identificadores->cola->siguiente = nodo;
    }
    identificadores->cola = nodo;
}

void agregarLiteralCadena(const char *cadena) {
    LiteralCadena *nuevoLiteral = (LiteralCadena*)malloc(sizeof(LiteralCadena));
    nuevoLiteral->cadena = strdup(cadena);
    nuevoLiteral->longitud = strlen(cadena) - 2; // Restar 2 por las comillas
    Nodo *nodo = crearNodo(nuevoLiteral);
    if (!literalesCadenas->cabeza) {
        literalesCadenas->cabeza = nodo;
    } else {
        literalesCadenas->cola->siguiente = nodo;
    }
    literalesCadenas->cola = nodo;
}

void agregarPalabraReservada(const char *palabra, int linea, int columna) {
    PalabraReservada *nuevaPalabra = (PalabraReservada*)malloc(sizeof(PalabraReservada));
    nuevaPalabra->palabra = strdup(palabra);
    nuevaPalabra->linea = linea;
    nuevaPalabra->columna = columna;
    Nodo *nodo = crearNodo(nuevaPalabra);
    if (!palabrasReservadas->cabeza) {
        palabrasReservadas->cabeza = nodo;
    } else {
        palabrasReservadas->cola->siguiente = nodo;
    }
    palabrasReservadas->cola = nodo;
}

void agregarConstanteDecimal(int valor) {
    ConstanteDecimal *nuevaConstante = (ConstanteDecimal*)malloc(sizeof(ConstanteDecimal));
    nuevaConstante->valor = valor;
    Nodo *nodo = crearNodo(nuevaConstante);
    if (!constantesDecimales->cabeza) {
        constantesDecimales->cabeza = nodo;
    } else {
        constantesDecimales->cola->siguiente = nodo;
    }
    constantesDecimales->cola = nodo;
}

void agregarConstanteHexadecimal(int valor) {
    ConstanteHexadecimal *nuevaConstante = (ConstanteHexadecimal*)malloc(sizeof(ConstanteHexadecimal));
    nuevaConstante->valor = valor;
    Nodo *nodo = crearNodo(nuevaConstante);
    if (!constantesHexadecimales->cabeza) {
        constantesHexadecimales->cabeza = nodo;
    } else {
        constantesHexadecimales->cola->siguiente = nodo;
    }
    constantesHexadecimales->cola = nodo;
}

void agregarConstanteOctal(int valor) {
    ConstanteOctal *nuevaConstante = (ConstanteOctal*)malloc(sizeof(ConstanteOctal));
    nuevaConstante->valor = valor;
    Nodo *nodo = crearNodo(nuevaConstante);
    if (!constantesOctales->cabeza) {
        constantesOctales->cabeza = nodo;
    } else {
        constantesOctales->cola->siguiente = nodo;
    }
    constantesOctales->cola = nodo;
}

void agregarConstanteReal(float mantisa, int parteEntera) {
    ConstanteReal *nuevaConstante = (ConstanteReal*)malloc(sizeof(ConstanteReal));
    nuevaConstante->mantisa = mantisa;
    nuevaConstante->parteEntera = parteEntera;
    Nodo *nodo = crearNodo(nuevaConstante);
    if (!constantesReales->cabeza) {
        constantesReales->cabeza = nodo;
    } else {
        constantesReales->cola->siguiente = nodo;
    }
    constantesReales->cola = nodo;
}

void agregarConstanteCaracter(char valor) {
    ConstanteCaracter *nuevoCaracter = (ConstanteCaracter*)malloc(sizeof(ConstanteCaracter));
    nuevoCaracter->valor = valor;
    Nodo *nodo = crearNodo(nuevoCaracter);
    if (!constantesCaracteres->cabeza) {
        constantesCaracteres->cabeza = nodo;
    } else {
        constantesCaracteres->cola->siguiente = nodo;
    }
    constantesCaracteres->cola = nodo;
}

void agregarOperador(char operador) {
    Nodo *nodo = operadores->cabeza;
    while (nodo) {
        Operador *op = (Operador*)nodo->dato;
        if (op->operador == operador) {
            op->frecuencia++;
            return;
        }
        nodo = nodo->siguiente;
    }
    Operador *nuevoOperador = (Operador*)malloc(sizeof(Operador));
    nuevoOperador->operador = operador;
    nuevoOperador->frecuencia = 1;
    nodo = crearNodo(nuevoOperador);
    if (!operadores->cabeza) {
        operadores->cabeza = nodo;
    } else {
        operadores->cola->siguiente = nodo;
    }
    operadores->cola = nodo;
}

void agregarCadenaNoReconocida(const char *cadena, int linea, int columna) {
    CadenaNoReconocida *nuevaCadena = (CadenaNoReconocida*)malloc(sizeof(CadenaNoReconocida));
    nuevaCadena->cadena = strdup(cadena);
    nuevaCadena->linea = linea;
    nuevaCadena->columna = columna;
    Nodo *nodo = crearNodo(nuevaCadena);
    if (!cadenasNoReconocidas->cabeza) {
        cadenasNoReconocidas->cabeza = nodo;
    } else {
        cadenasNoReconocidas->cola->siguiente = nodo;
    }
    cadenasNoReconocidas->cola = nodo;
}

void imprimirFrecuenciaOperadores() {
    Nodo *nodo = operadores->cabeza;
    printf("* Listado de operadores/caracteres de puntuación:\n");
    while (nodo) {
        Operador *op = (Operador*)nodo->dato;
        printf("%c: aparece %d veces\n", op->operador, op->frecuencia);
        nodo = nodo->siguiente;
    }
}

void imprimirPalabrasReservadas() {
    Nodo *nodo = palabrasReservadas->cabeza;
    while (nodo) {
        PalabraReservada *pr = (PalabraReservada*)nodo->dato;
        printf("%s: linea %d, columna %d\n", pr->palabra, pr->linea, pr->columna);
        nodo = nodo->siguiente;
    }
}

void imprimirCadenasNoReconocidas() {
    Nodo *nodo = cadenasNoReconocidas->cabeza;
    printf("* Listado de cadenas no reconocidas:\n");
    while (nodo) {
        CadenaNoReconocida *cnr = (CadenaNoReconocida*)nodo->dato;
        printf("%s: linea %d, columna %d\n", cnr->cadena, cnr->linea, cnr->columna);
        nodo = nodo->siguiente;
    }
}

void imprimirListados() {
    // Imprimir identificadores
    Nodo *nodo = identificadores->cabeza;
    printf("* Listado de identificadores encontrados:\n");
    while (nodo) {
        Identificador *id = (Identificador*)nodo->dato;
        printf("%s: aparece %d veces\n", id->nombre, id->frecuencia);
        nodo = nodo->siguiente;
    }

    // Imprimir literales cadenas
    nodo = literalesCadenas->cabeza;
    printf("\n* Listado de literales cadena encontrados:\n");
    while (nodo) {
        LiteralCadena *lc = (LiteralCadena*)nodo->dato;
        printf("%s: longitud %d\n", lc->cadena, lc->longitud);
        nodo = nodo->siguiente;
    }

    // Imprimir palabras reservadas por categoría
    printf("\n* Listado de palabras reservadas (tipos de dato):\n");
    imprimirPalabrasReservadas();

    printf("\n* Listado de palabras reservadas (estructuras de control):\n");
    imprimirPalabrasReservadas();

    printf("\n* Listado de palabras reservadas (otros):\n");
    imprimirPalabrasReservadas();

    // Imprimir constantes decimales
    nodo = constantesDecimales->cabeza;
    int sumaDecimales = 0;
    printf("\n* Listado de constantes enteras decimales:\n");
    while (nodo) {
        ConstanteDecimal *cd = (ConstanteDecimal*)nodo->dato;
        printf("%d: valor %d\n", cd->valor, cd->valor);
        sumaDecimales += cd->valor;
        nodo = nodo->siguiente;
    }
    printf("Total acumulado de sumar todas las constantes decimales: %d\n", sumaDecimales);

    // Imprimir constantes hexadecimales
    nodo = constantesHexadecimales->cabeza;
    printf("\n* Listado de constantes enteras hexadecimales:\n");
    while (nodo) {
        ConstanteHexadecimal *ch = (ConstanteHexadecimal*)nodo->dato;
        printf("0x%x: valor entero decimal %d\n", ch->valor, ch->valor);
        nodo = nodo->siguiente;
    }

    // Imprimir constantes octales
    nodo = constantesOctales->cabeza;
    printf("\n* Listado de constantes enteras octales:\n");
    while (nodo) {
        ConstanteOctal *co = (ConstanteOctal*)nodo->dato;
        printf("0%o: valor entero decimal %d\n", co->valor, co->valor);
        nodo = nodo->siguiente;
    }

    // Imprimir constantes reales
    nodo = constantesReales->cabeza;
    printf("\n* Listado de constantes reales:\n");
    while (nodo) {
        ConstanteReal *cr = (ConstanteReal*)nodo->dato;
        printf("%d.%d: parte entera %d, mantisa %f\n", cr->parteEntera, (int)(cr->mantisa * 1000000), cr->parteEntera, cr->mantisa);
        nodo = nodo->siguiente;
    }

    // Imprimir constantes de caracteres
    nodo = constantesCaracteres->cabeza;
    printf("\n* Listado de constantes caracter enumerados:\n");
    int contador = 1;
    while (nodo) {
        ConstanteCaracter *cc = (ConstanteCaracter*)nodo->dato;
        printf("%d) '%c'\n", contador++, cc->valor);
        nodo = nodo->siguiente;
    }

    // Imprimir operadores/caracteres de puntuación
    imprimirFrecuenciaOperadores();

    // Imprimir cadenas no reconocidas
    imprimirCadenasNoReconocidas();
}

void inicializarListas() {
    identificadores = crearLista();
    literalesCadenas = crearLista();
    palabrasReservadas = crearLista();
    constantesDecimales = crearLista();
    constantesHexadecimales = crearLista();
    constantesOctales = crearLista();
    constantesReales = crearLista();
    constantesCaracteres = crearLista();
    operadores = crearLista();
    cadenasNoReconocidas = crearLista();
}
