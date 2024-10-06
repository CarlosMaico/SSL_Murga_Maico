%{
#include "calc.tab.h"  // Incluye el archivo de cabecera generado por Bison.
%}

%%

[0-9]+        { yylval = atoi(yytext); return NUMBER; }
"+"           { return PLUS; }
"-"           { return MINUS; }
[ \t\n]       { /* Ignora espacios, tabulaciones y saltos de línea */ }
.             { return yytext[0]; }  // Cualquier otro carácter no reconocido.

%%

int yywrap() {
    return 1;
}
