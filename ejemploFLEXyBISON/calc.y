%{
#include <stdio.h>
#include <stdlib.h>

int yylex();  // Declaración de la función yylex.
int yyerror(char *s);  // Declaración de la función yyerror.

%}

%token NUMBER
%token PLUS MINUS

%left PLUS MINUS

%%

calculation:
    expression { printf("Resultado: %d\n", $1); }
    ;

expression:
    expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | NUMBER { $$ = $1; }
    ;

%%

int main() {
    printf("Ingrese una expresión aritmética:\n");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
