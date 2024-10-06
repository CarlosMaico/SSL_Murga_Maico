%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct Nodo {
    void *dato;
    struct Nodo *siguiente;
} Nodo;

typedef struct {
    Nodo *cabeza;
} ListaEnlazada;

Nodo* crearNodo(void *dato) {
    Nodo *nuevoNodo = (Nodo*)malloc(sizeof(Nodo));
    if (nuevoNodo == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    nuevoNodo->dato = dato;
    nuevoNodo->siguiente = NULL;
    return nuevoNodo;
}

ListaEnlazada* crearLista() {
    ListaEnlazada *lista = (ListaEnlazada*)malloc(sizeof(ListaEnlazada));
    if (lista == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    lista->cabeza = NULL;
    return lista;
}

void agregar(ListaEnlazada *lista, void *dato) {
    if (lista == NULL) {
        fprintf(stderr, "Lista no inicializada\n");
        return;
    }
    Nodo *nuevoNodo = crearNodo(dato);
    nuevoNodo->siguiente = lista->cabeza;
    lista->cabeza = nuevoNodo;
}

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
    int exponente;
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
    if (nuevoId == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    nuevoId->identificador = strdup(identificador);
    nuevoId->frecuencia = 1;
    agregar(identificadores, nuevoId);
}

void agregarLiteralCadena(char *cadena) {
    LiteralCadena *literal = (LiteralCadena*)malloc(sizeof(LiteralCadena));
    if (literal == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    literal->cadena = strdup(cadena);
    literal->longitud = strlen(cadena);
    agregar(literalesCadenas, literal);
}

void agregarPalabraReservada(char *palabra, int linea, int columna) {
    PalabraReservada *reservada = (PalabraReservada*)malloc(sizeof(PalabraReservada));
    if (reservada == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    reservada->palabra = strdup(palabra);
    reservada->linea = linea;
    reservada->columna = columna;
    agregar(palabrasReservadas, reservada);
}

void agregarConstanteDecimal(int valor) {
    ConstanteDecimal *constante = (ConstanteDecimal*)malloc(sizeof(ConstanteDecimal));
    if (constante == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    constante->valor = valor;
    agregar(constantesDecimales, constante);
}

void agregarConstanteHexadecimal(int valor) {
    ConstanteHexadecimal *constante = (ConstanteHexadecimal*)malloc(sizeof(ConstanteHexadecimal));
    if (constante == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    constante->valor = valor;
    agregar(constantesHexadecimales, constante);
}

void agregarConstanteOctal(int valor) {
    ConstanteOctal *constante = (ConstanteOctal*)malloc(sizeof(ConstanteOctal));
    if (constante == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    constante->valor = valor;
    agregar(constantesOctales, constante);
}

void agregarConstanteReal(double mantisa, int exponente) {
    ConstanteReal *constante = (ConstanteReal*)malloc(sizeof(ConstanteReal));
    if (constante == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    constante->mantisa = mantisa;
    constante->exponente = exponente;
    agregar(constantesReales, constante);
}

void agregarConstanteCaracter(char valor) {
    ConstanteCaracter *constante = (ConstanteCaracter*)malloc(sizeof(ConstanteCaracter));
    if (constante == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
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
    if (nuevoOp == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    nuevoOp->operador = operador;
    nuevoOp->frecuencia = 1;
    agregar(operadores, nuevoOp);
}

void agregarCadenaNoReconocida(char *cadena, int linea, int columna) {
    CadenaNoReconocida *noReconocida = (CadenaNoReconocida*)malloc(sizeof(CadenaNoReconocida));
    if (noReconocida == NULL) {
        fprintf(stderr, "Error de asignación de memoria\n");
        exit(EXIT_FAILURE);
    }
    noReconocida->cadena = strdup(cadena);
    noReconocida->linea = linea;
    noReconocida->columna = columna;
    agregar(cadenasNoReconocidas, noReconocida);
}

int linea = 1;
int columna = 1;

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

    printf("\n* Listado de palabras reservadas encontradas:\n");
    actual = palabrasReservadas->cabeza;
    while (actual != NULL) {
        PalabraReservada *reservada = (PalabraReservada*)actual->dato;
        printf("%s en linea %d columna %d\n", reservada->palabra, reservada->linea, reservada->columna);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes enteras decimales:\n");
    actual = constantesDecimales->cabeza;
    while (actual != NULL) {
        ConstanteDecimal *constante = (ConstanteDecimal*)actual->dato;
        printf("%d\n", constante->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes enteras hexadecimales:\n");
    actual = constantesHexadecimales->cabeza;
    while (actual != NULL) {
        ConstanteHexadecimal *constante = (ConstanteHexadecimal*)actual->dato;
        printf("0x%x\n", constante->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes enteras octales:\n");
    actual = constantesOctales->cabeza;
    while (actual != NULL) {
        ConstanteOctal *constante = (ConstanteOctal*)actual->dato;
        printf("0%o\n", constante->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes reales:\n");
    actual = constantesReales->cabeza;
    while (actual != NULL) {
        ConstanteReal *constante = (ConstanteReal*)actual->dato;
        printf("%fE%d\n", constante->mantisa, constante->exponente);
        actual = actual->siguiente;
    }

    printf("\n* Listado de constantes carácter:\n");
    actual = constantesCaracteres->cabeza;
    while (actual != NULL) {
        ConstanteCaracter *constante = (ConstanteCaracter*)actual->dato;
        printf("'%c'\n", constante->valor);
        actual = actual->siguiente;
    }

    printf("\n* Listado de operadores:\n");
    actual = operadores->cabeza;
    while (actual != NULL) {
        Operador *op = (Operador*)actual->dato;
        printf("%c: %d veces\n", op->operador, op->frecuencia);
        actual = actual->siguiente;
    }

    printf("\n* Listado de cadenas no reconocidas:\n");
    actual = cadenasNoReconocidas->cabeza;
    while (actual != NULL) {
        CadenaNoReconocida *noReconocida = (CadenaNoReconocida*)actual->dato;
        printf("\"%s\" en linea %d columna %d\n", noReconocida->cadena, noReconocida->linea, noReconocida->columna);
        actual = actual->siguiente;
    }
}
%}

WS          [ \t]+
NL          \n

DIGITO      [0-9]
LETRA       [a-zA-Z]
HEXDIGITO   [0-9a-fA-F]
OCTDIGITO   [0-7]
IDENT       {LETRA}({LETRA}|{DIGITO})*



%%



"int"|"void"|"char"                           { agregarPalabraReservada(yytext, linea, columna); }
"if"|"else"|"while"|"for"|"return"            { agregarPalabraReservada(yytext, linea, columna); }
"sizeof"                                      { agregarPalabraReservada(yytext, linea, columna); }

"0"{OCTDIGITO}+                               { agregarConstanteOctal(strtol(yytext, NULL, 8)); }

{IDENT}                                       { agregarIdentificador(yytext); }
{DIGITO}+                                     { agregarConstanteDecimal(atoi(yytext)); }
"0x"{HEXDIGITO}+                              { agregarConstanteHexadecimal(strtol(yytext, NULL, 16)); }

{DIGITO}+"."{DIGITO}*([eE][+-]?{DIGITO}+)?    { double mantisa = atof(yytext);
                                                int exponente = 0;
                                                char *e = strrchr(yytext, 'e');
                                                if (e) exponente = atoi(e + 1);
                                                agregarConstanteReal(mantisa, exponente); }

'[^\\'\n]'                                    { agregarConstanteCaracter(yytext[1]); }

"\\[abfnrtv\'\"\?\\]"                         { agregarConstanteCaracter(yytext[1]); }

'\\[0-7]{1,3}'                                { int valor = strtol(yytext+1, NULL, 8); agregarConstanteCaracter(valor); }

'\\x[0-9a-fA-F]+'                             { int valor = strtol(yytext+2, NULL, 16); agregarConstanteCaracter(valor); }

\"([^\\"]|\\.)*\"                             { agregarLiteralCadena(yytext); columna += yyleng; }

[{}()[\].,;?:]                                { agregarOperador(yytext[0]); columna += yyleng; }

("="|"=="|">="|"<="|"!="|"&&"|"||"|"&"|"|"|"\^"|"\<<"|">>"|"+"|"-"|"*"|"/"|"%") { agregarOperador(yytext[0]); columna += yyleng; }

{NL}                                          { linea++; columna = 1; }
{WS}                                          { /* Ignorar espacios y tabs */ }
.                                             { agregarCadenaNoReconocida(yytext, linea, columna); }

%%

int main(int argc, char *argv[]) {
    inicializarListas();
    yylex();
    imprimirListados();
    return 0;
}
