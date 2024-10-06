#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Nodo {
    void *dato;
    struct Nodo *siguiente;
} Nodo;

typedef struct {
    Nodo *cabeza;
} ListaEnlazada;

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

void agregarIdentificador(ListaEnlazada *lista, char *identificador) {
    Nodo *actual = lista->cabeza;
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
    agregar(lista, nuevoId);
}

void agregarLiteralCadena(ListaEnlazada *lista, char *cadena) {
    LiteralCadena *literal = (LiteralCadena*)malloc(sizeof(LiteralCadena));
    literal->cadena = strdup(cadena);
    literal->longitud = strlen(cadena);
    agregar(lista, literal);
}

void agregarPalabraReservada(ListaEnlazada *lista, char *palabra, int linea, int columna) {
    PalabraReservada *reservada = (PalabraReservada*)malloc(sizeof(PalabraReservada));
    reservada->palabra = strdup(palabra);
    reservada->linea = linea;
    reservada->columna = columna;
    agregar(lista, reservada);
}

void agregarConstanteDecimal(ListaEnlazada *lista, int valor) {
    ConstanteDecimal *constante = (ConstanteDecimal*)malloc(sizeof(ConstanteDecimal));
    constante->valor = valor;
    agregar(lista, constante);
}

void agregarConstanteHexadecimal(ListaEnlazada *lista, int valor) {
    ConstanteHexadecimal *constante = (ConstanteHexadecimal*)malloc(sizeof(ConstanteHexadecimal));
    constante->valor = valor;
    agregar(lista, constante);
}

void agregarConstanteOctal(ListaEnlazada *lista, int valor) {
    ConstanteOctal *constante = (ConstanteOctal*)malloc(sizeof(ConstanteOctal));
    constante->valor = valor;
    agregar(lista, constante);
}

void agregarConstanteReal(ListaEnlazada *lista, double mantisa, int parteEntera) {
    ConstanteReal *constante = (ConstanteReal*)malloc(sizeof(ConstanteReal));
    constante->mantisa = mantisa;
    constante->parteEntera = parteEntera;
    agregar(lista, constante);
}

void agregarConstanteCaracter(ListaEnlazada *lista, char valor) {
    ConstanteCaracter *constante = (ConstanteCaracter*)malloc(sizeof(ConstanteCaracter));
    constante->valor = valor;
    agregar(lista, constante);
}

void agregarOperador(ListaEnlazada *lista, char operador) {
    Nodo *actual = lista->cabeza;
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
    agregar(lista, nuevoOp);
}

void agregarCadenaNoReconocida(ListaEnlazada *lista, char *cadena, int linea, int columna) {
    CadenaNoReconocida *noReconocida = (CadenaNoReconocida*)malloc(sizeof(CadenaNoReconocida));
    noReconocida->cadena = strdup(cadena);
    noReconocida->linea = linea;
    noReconocida->columna = columna;
    agregar(lista, noReconocida);
}