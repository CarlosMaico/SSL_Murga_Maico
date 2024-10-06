%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno; // Declaramos yylineno para poder usarlo
void yyerror(const char *s);
extern FILE *yyin; // Declaramos yyin para usar archivos de entrada
%}

%token IDENTIFICADOR
%left '='

%%

input:
    /* vacío */
    | input statement
;

statement:
    assignment ';'    { printf("Asignacion volida\n"); }
    | assignment      { yyerror("Falta punto y coma al final de la asignacin"); }
;

assignment:
    IDENTIFICADOR '=' IDENTIFICADOR
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s en la línea %d\n", s, yylineno);
}

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
