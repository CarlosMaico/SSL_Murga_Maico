%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno; // Variable para el número de línea
void yyerror(const char *s);
extern FILE *yyin; // Declaramos yyin para usar archivos de entrada

typedef union {
    char *id; // Usaremos un puntero a char para los identificadores
} YYSTYPE;

#define YYSTYPE YYSTYPE
%}

%token <id> IDENTIFICADOR
%left '='

%%

// Definimos el input y las statements
input:
    /* vacío */
    | input statement
;

// Definimos las statements
statement:
    assignment ';' {
        printf("Asignacion: %s = %s; (Correcta)\n", $1, $3);
        free($1); // Liberamos la memoria del identificador izquierdo
        free($3); // Liberamos la memoria del identificador derecho
    }
    | assignment error {
        printf("Asignacion: %s = %s (Error: falta punto y coma en la línea %d)\n", $1, $3, yylineno);
        free($1); // Liberamos la memoria del identificador izquierdo
        free($3); // Liberamos la memoria del identificador derecho
        yyerrok; // Ignoramos el error y continuamos
    }
;

// Definimos las asignaciones
assignment:
    IDENTIFICADOR '=' IDENTIFICADOR {
        $$ = strdup($1); // Almacenamos una copia del identificador a la izquierda
        $3 = strdup($3); // Almacenamos una copia del identificador a la derecha
    }
;

%%

// Definimos el mensaje de error
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s en la línea %d\n", s, yylineno);
}

// Función principal
int main(int argc, char **argv) {
    if (argc > 1) {
        // Abrimos el archivo que se pasa como argumento
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            fprintf(stderr, "No se pudo abrir el archivo: %s\n", argv[1]);
            return 1;
        }
        // Asignamos el archivo a yyin
        yyin = archivo;
    }

    // Iniciamos el parser
    return yyparse();
}
