#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Listado {
    int numero;
    char* cadena;
    struct Listado* siguiente;
};

// MOSTRAR LISTAS
void mostrarLista_OrdenAparicion(struct Listado* lista, char * tipoLexama, char * tipoValor) {
    if (lista == NULL) 
        return; 

    mostrarLista_OrdenAparicion(lista->siguiente, tipoLexama, tipoValor);
    
    if (strlen(lista->cadena) > 0)
        printf("%s (%s: %4d): %s\n", tipoLexama, tipoValor, lista->numero, lista->cadena);
}

void mostrarPalabrasReservadas(struct Listado* lista){
    if (lista == NULL)
        return;
    
    mostrarPalabrasReservadas(lista->siguiente); 
    int b = 9;
    double a = (unsigned int) b;
    switch (lista->numero) {
        case 1:
            printf("Palabra reservada - Tipo de dato: %20s\n", lista->cadena);
            break;
        case 2:
            printf("Palabra reservada - Modificador: %21s\n", lista->cadena);
            break;
        case 3:
            printf("Palabra reservada - Espec. de almacen.: %14s\n", lista->cadena);
            break;
        case 4:
            printf("Palabra reservada - Estructura de control: %11s\n", lista->cadena);
            break;
        default:
            printf("Palabra reservada: %35s\n", lista->cadena);
            break;
    }
}

void mostrarConstantes(struct Listado* lista){
    if (lista == NULL)
        return;
    
    mostrarConstantes(lista -> siguiente);

    double i, f;

    switch (lista->numero) {
        case 1:
            printf("Constante entera (Octal): %13s - Conversion a decimal: %5d\n", lista->cadena, strtol(lista->cadena, NULL, 8));
            break;
        case 2:
            printf("Constante entera (Hexadecimal): %7s - Conversion a decimal: %5d\n", lista->cadena, strtol(lista->cadena, NULL, 16));
            break;
        case 3:
            f = modf(atof(lista->cadena), &i);
            printf("Constante real: %23s - Parte Entera: %6g - Mantisa: %f\n", lista->cadena, i, f);
            break;
        case 4:
            printf("Constante caracter: %19s\n", lista->cadena);
            break;
        default:
            printf("Constante entera (Decimal): %11s\n", lista->cadena);
            break;
    }
}

void mostrarComentarios(struct Listado* lista){
    if (lista == NULL)
        return;
    
    mostrarComentarios(lista->siguiente);

    switch (lista->numero) {
        case 0:
            printf("Comentario (Simple):   %s\n", lista->cadena);
            break;
        default:
            printf("Comentario (Multiple): %s\n", lista->cadena);
            break;
    }
}

void mostrarDirectivas(struct Listado* lista, char * tipoLexama) {
    if (lista == NULL)
        return;
    
    mostrarDirectivas(lista->siguiente, tipoLexama);

    if (strlen(lista->cadena) > 0)
        printf("%s: %s\n", tipoLexama, lista->cadena);
}

// PUSH
void pushCadena(struct Listado** cabeza, char* nuevaCadena, int longitudCadena) { 
    char * cadenaIngreso = (char *)calloc(longitudCadena + 1, sizeof(char));    
    strncpy(cadenaIngreso, nuevaCadena, longitudCadena + 1);
    
    struct Listado* nuevoNodo = (struct Listado*) malloc(sizeof(struct Listado)); 
    
    nuevoNodo->cadena = strdup(cadenaIngreso); 
    nuevoNodo->numero = 0; 
    
    nuevoNodo->siguiente = (*cabeza); 
    
    (*cabeza) = nuevoNodo; 
}  

void pushLista(struct Listado** cabeza, char* nuevaCadena, int nuevoNumero, int longitudCadena) { 
    char * cadenaIngreso = (char *)calloc(longitudCadena+1, sizeof(char));    
    strncpy(cadenaIngreso, nuevaCadena, longitudCadena+1);
    
    struct Listado* nuevoNodo = (struct Listado*) malloc(sizeof(struct Listado)); 
    
    nuevoNodo->cadena = strdup(cadenaIngreso); 
    nuevoNodo->numero = nuevoNumero; 
    
    nuevoNodo->siguiente = (*cabeza); 
    
    (*cabeza) = nuevoNodo; 
}  

int repeticion(struct Listado** cabeza, char * cadIngreso){
    struct Listado * temp = (struct Listado *) malloc(sizeof(struct Listado));
    temp = (*cabeza);
    while(temp != NULL){
        if(!strcmp (temp->cadena, cadIngreso)){
            return temp->numero++;
        } else {
            temp = temp->siguiente;         
        }
    }
    return 0;
}

void pushListaSinRepetir(struct Listado** cabeza, char* nuevaCadena, int longitudCadena){
    char * cadenaIngreso = (char *)calloc(longitudCadena+1, sizeof(char));    
    strncpy(cadenaIngreso, nuevaCadena, longitudCadena+1);
    
    struct Listado* nuevoNodo = (struct Listado*) malloc(sizeof(struct Listado)); 

    int seRepite = repeticion(cabeza, cadenaIngreso);

    if(!seRepite){
        nuevoNodo->cadena = strdup(cadenaIngreso); 
        nuevoNodo->numero = 1;
        nuevoNodo->siguiente = (*cabeza); 
        (*cabeza) = nuevoNodo; 
    } else {
        nuevoNodo->numero = seRepite;
    }
}  

// ORDENAMIENTO ALFABETICO
void intercambioDeNodo(struct Listado *a, struct Listado *b) { 
    int temp = a->numero; 
    char * tempc = strdup(a->cadena);

    a->numero = b->numero; 
    a->cadena = strdup(b->cadena);
 
    b->numero = temp; 
    b->cadena = strdup(tempc);
} 

void ordenarAlfabeticamente(struct Listado *listaAOrdenar) { 
    int intercambio; 
    struct Listado *temp; 
    struct Listado *lptr = NULL; 
  
    if (listaAOrdenar == NULL) 
        return; 
  
    do { 
        intercambio = 0; 
        temp = listaAOrdenar; 
  
        while (temp->siguiente != lptr) { 
            if (strcasecmp (temp->cadena, temp->siguiente->cadena) < 0) {
                intercambioDeNodo(temp, temp->siguiente); 
                intercambio = 1; 
            } 
            temp = temp->siguiente; 
        } 
        lptr = temp; 
    } while (intercambio); 
} 

// MISCELANEO
int conseguirDecimal(char* nuevaCadena, int longitudCadena) { 
    char * cadenaIngreso = (char *)calloc(longitudCadena + 1, sizeof(char));    
    strncpy(cadenaIngreso, nuevaCadena, longitudCadena + 1);
   
    char * numeroAConvertir = strdup(cadenaIngreso); 
    
    return strtol(numeroAConvertir, NULL, 10);
}