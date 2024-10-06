%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Definición de estructuras para listas enlazadas
typedef struct Nodo {
    void *dato;
    struct Nodo *siguiente;
} Nodo;

typedef struct {
    Nodo *cabeza;
} ListaEnlazada;

// Funciones para manejar listas enlazadas
Nodo* crearNodo(void *dato) {
    Nodo *nuevoNodo = (Nodo*)malloc(sizeof(Nodo));
    nuevoNodo->dato = dato;
    nuevoNodo->siguiente = NULL;
    return nuevoNodo;
}

ListaEnlazada* crearLista() {
    ListaEnlazada *lista = (ListaEnlazada*)malloc(sizeof(ListaEnlazada));
    lista->cabeza = NULL;
    return lista;
}

void agregar(ListaEnlazada *lista, void *dato) {
    Nodo *nuevoNodo = crearNodo(dato);
    nuevoNodo->siguiente = lista->cabeza;
    lista->cabeza = nuevoNodo;
}

// Estructuras para almacenar diferentes tipos de datos
typedef struct {
    char *identificador;
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
    double mantisa;
    int parteEntera;
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

// Declaraciones de listas globales
ListaEnlazada *identificadores;
ListaEnlazada *literalesCadenas;
ListaEnlazada *palabrasReservadas;
ListaEnlazada *constantesDecimales;
ListaEnlazada *constantesHexadecimales;
ListaEnlazada *constantesOctales;
ListaEnlazada *constantesReales;
ListaEnlazada *constantesCaracteres;
ListaEnlazada *operadores;
ListaEnlazada *cadenasNoReconocidas;

// Inicialización de listas
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

// Funciones para agregar datos a las listas enlazadas correspondientes
void agregarIdentificador(char *identificador) {
    Nodo *actual = identificadores->cabeza;
    while (actual != NULL) {
        Identificador *id = (Identificador*)actual->dato;
        if (strcmp(id->identificador, identificador) == 0) {
            id->frecuencia++;
            return;
        }
        actual = actual->siguiente;
    }
    Identificador *nuevoId = (Identificador*)malloc(sizeof(Identificador));
    nuevoId->identificador = strdup(identificador);
    nuevoId->frecuencia = 1;
    agregar(identificadores, nuevoId);
}

void agregarLiteralCadena(char *cadena) {
    LiteralCadena *literal = (LiteralCadena*)malloc(sizeof(LiteralCadena));
    literal->cadena = strdup(cadena);
    literal->longitud = strlen(cadena);
    agregar(literalesCadenas, literal);
}

void agregarPalabraReservada(char *palabra, int linea, int columna) {
    PalabraReservada *reservada = (PalabraReservada*)malloc(sizeof(PalabraReservada));
    reservada->palabra = strdup(palabra);
    reservada->linea = linea;
    reservada->columna = columna;
    agregar(palabrasReservadas, reservada);
}

void agregarConstanteDecimal(int valor) {
    ConstanteDecimal *constante = (ConstanteDecimal*)malloc(sizeof(ConstanteDecimal));
    constante->valor = valor;
    agregar(constantesDecimales, constante);
}

void agregarConstanteHexadecimal(int valor) {
    ConstanteHexadecimal *constante = (ConstanteHexadecimal*)malloc(sizeof(ConstanteHexadecimal));
    constante->valor = valor;
    agregar(constantesHexadecimales, constante);
}

void agregarConstanteOctal(int valor) {
    ConstanteOctal *constante = (ConstanteOctal*)malloc(sizeof(ConstanteOctal));
    constante->valor = valor;
    agregar(constantesOctales, constante);
}

void agregarConstanteReal(double mantisa, int parteEntera) {
    ConstanteReal *constante = (ConstanteReal*)malloc(sizeof(ConstanteReal));
    constante->mantisa = mantisa;
    constante->parteEntera = parteEntera;
    agregar(constantesReales, constante);
}

void agregarConstanteCaracter(char valor) {
    ConstanteCaracter *constante = (ConstanteCaracter*)malloc(sizeof(ConstanteCaracter));
    constante->valor = valor;
    agregar(constantesCaracteres, constante);
}

void agregarOperador(char operador) {
    Nodo *actual = operadores->cabeza;
    while (actual != NULL) {
        Operador *op = (Operador*)actual->dato;
        if (op->operador == operador) {
            op->frecuencia++;
            return;
        }
        actual = actual->siguiente;
    }
    Operador *nuevoOp = (Operador*)malloc(sizeof(Operador));
    nuevoOp->operador = operador;
    nuevoOp->frecuencia = 1;
    agregar(operadores, nuevoOp);
}

void agregarCadenaNoReconocida(char *cadena, int linea, int columna) {
    CadenaNoReconocida *noReconocida = (CadenaNoReconocida*)malloc(sizeof(CadenaNoReconocida));
    noReconocida->cadena = strdup(cadena);
    noReconocida->linea = linea;
    noReconocida->columna = columna;
    agregar(cadenasNoReconocidas, noReconocida);
}

// Variables para seguimiento de líneas y columnas
int linea = 1;
int columna = 1;

// Función para imprimir los listados
void imprimirListados() {
    printf("* Listado de identificadores encontrados:\n");
    Nodo *actual = identificadores->cabeza;
    while (actual != NULL) {
        Identificador *id = (Identificador*)actual->dato;
        printf("%s: aparece %d veces\n", id->identificador, id->frecuencia);
        actual = actual->siguiente;
    }

    printf("\n* Listado de literales cadena encontrados:\n");
    actual = literalesCadenas->cabeza;
    while (actual != NULL) {
        LiteralCadena *literal = (LiteralCadena*)actual->dato;
        printf("\"%s\": longitud %d\n", literal->cadena, literal->longitud);
        actual = actual->siguiente;
    }

    printf("\n* Listado de palabras reservadas (tipos de dato):\n");
    actual = palabrasReservadas->cabeza;
    while (actual != NULL) {
        PalabraReservada *reservada = (PalabraReservada*)actual->dato;
        if (strcmp(reservada->palabra, "int") == 0 || strcmp(reservada->palabra, "void") == 0 || strcmp(reservada->palabra, "char") == 0) {
            printf("%s: linea %d, columna %d\n", reservada->palabra, reservada->linea, reservada->columna);
        }
        actual = actual->siguiente;
    }

    printf("\n* Listado de palabras reservadas (estructuras de control):\n");
    actual = palabrasReservadas->cabeza;
    while (actual != NULL) {
        PalabraReservada *reservada = (PalabraReservada*)actual->dato;
        if (strcmp(reservada->palabra, "if") == 0 || strcmp(reservada->palabra, "else") == 0 || strcmp(reservada->palabra, "while") == 0 ||
            strcmp(reservada->palabra, "for") == 0 || strcmp(reservada->palabra, "return") == 0) {
            printf("%s: linea %d, columna %d\n", reservada->palabra, reservada->linea, reservada->columna);
        }
        actual = actual->siguiente;
    }

    printf("\n* Listado de palabras reservadas (otros):\n");
    actual = palabrasReservadas->cabeza;
    while (actual != NULL) {
        PalabraReservada *reservada = (PalabraReservada*)actual->dato;
        if (strcmp(reservada->palabra, "sizeof") == 0) {
            printf("%s: linea %d, columna %d\n", reservada->palabra, reservada->linea, reservada->columna);
        }
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes enteras decimales:\n");
    int totalDecimales = 0;
    actual = constantesDecimales->cabeza;
    while (actual != NULL) {
        ConstanteDecimal *decimal = (ConstanteDecimal*)actual->dato;
        printf("%d: valor %d\n", decimal->valor, decimal->valor);
        totalDecimales += decimal->valor;
        actual = actual->siguiente;
    }
    printf("Total acumulado de sumar todas las constantes decimales: %d\n", totalDecimales);

    printf("\n* Listado de constantes enteras hexadecimales:\n");
    actual = constantesHexadecimales->cabeza;
    while (actual != NULL) {
        ConstanteHexadecimal *hexa = (ConstanteHexadecimal*)actual->dato;
        printf("%X: valor entero decimal %d\n", hexa->valor, hexa->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes enteras octales:\n");
    actual = constantesOctales->cabeza;
    while (actual != NULL) {
        ConstanteOctal *octal = (ConstanteOctal*)actual->dato;
        printf("%o: valor entero decimal %d\n", octal->valor, octal->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes reales:\n");
    actual = constantesReales->cabeza;
    while (actual != NULL) {
        ConstanteReal *real = (ConstanteReal*)actual->dato;
        printf("%lf: parte entera %lf , mantisa %lf\n", real->mantisa + real->parteEntera, (double)real->parteEntera, real->mantisa);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes caracter enumerados:\n");
    int contadorCaracteres = 1;
    actual = constantesCaracteres->cabeza;
    while (actual != NULL) {
        ConstanteCaracter *caracter = (ConstanteCaracter*)actual->dato;
        printf("%d) '%c'\n", contadorCaracteres, caracter->valor);
        contadorCaracteres++;
        actual = actual->siguiente;
    }

    // Imprimir operadores
    printf("\n* Listado de operadores/caracteres de puntuación:\n");
    actual = operadores->cabeza;
    while (actual != NULL) {
        Operador *op = (Operador*)actual->dato;
        printf("%c: aparece %d veces\n", op->operador, op->frecuencia);
        actual = actual->siguiente;
    }

    // Imprimir cadenas no reconocidas
    printf("\n* Listado de cadenas no reconocidas:\n");
    actual = cadenasNoReconocidas->cabeza;
    while (actual != NULL) {
        CadenaNoReconocida *noReconocida = (CadenaNoReconocida*)actual->dato;
        printf("%s: linea %d, columna %d\n", noReconocida->cadena, noReconocida->linea, noReconocida->columna);
        actual = actual->siguiente;
    }
}
%}

%%

(char|double|enum|float|int|long|short|struct|union|void|break|case|continue|default|do|else|for|goto|if|return|switch|while|auto|const|extern|register|signed|sizeof|static|typedef|unsigned|volatile) {
    agregarPalabraReservada(yytext, linea, columna);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    agregarIdentificador(yytext);
}

0|([1-9][0-9]*)[uU]?[lL]{0,2} {
    int valor = atoi(yytext);
    agregarConstanteDecimal(valor);
}

0[0-7]+[uU]?[lL]{0,2} {
    int valor = strtol(yytext, NULL, 8);
    agregarConstanteOctal(valor);
}

0[xX][0-9a-fA-F]+[uU]?[lL]{0,2} {
    int valor = strtol(yytext, NULL, 16);
    agregarConstanteHexadecimal(valor);
}

([0-9]+\.[0-9]*([eE][-+]?[0-9]+)?) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

([0-9]*\.[0-9]+([eE][-+]?[0-9]+)?) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

([0-9]+[eE][-+]?[0-9]+) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

([0-9]+\.[0-9]*([eE][-+]?[0-9]+)?[fFlL]?) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

([0-9]*\.[0-9]+([eE][-+]?[0-9]+)?[fFlL]?) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

([0-9]+[eE][-+]?[0-9]+[fFlL]?) {
    double valor = atof(yytext);
    agregarConstanteReal(modf(valor, &valor), (int)valor);
}

'[^'\\]' {
    agregarConstanteCaracter(yytext[1]);
}

\\[abfnrtv\'\"\?\\] {
    agregarConstanteCaracter(yytext[1]);
}

'\\[0-7]{1,3}' {
    int valor = strtol(yytext+1, NULL, 8);
    agregarConstanteCaracter(valor);
}

'\\x[0-9a-fA-F]+' {
    int valor = strtol(yytext+2, NULL, 16);
    agregarConstanteCaracter(valor);
}

[{}()[\].,;?:] {
    agregarOperador(yytext[0]);
    columna = columna + yyleng;
}

("="|"=="|">="|"<="|"!="|"&&"|"||"|"&"|"|"|"\^"|"\<<"|">>"|"+"|"-"|"*"|"/"|"%") {
    agregarOperador(yytext[0]);
    columna = columna + yyleng;
}


\"([^"\\]|\\.)*\" {
    agregarLiteralCadena(yytext);
}

. {
    agregarCadenaNoReconocida(yytext, linea, columna);
    columna++;
}


\n {
    linea++;
    columna = 1;
}


%%

int main(int argc, char* argv[]) {
    inicializarListas();
    yylex();
    imprimirListados();
    return 0;
}


