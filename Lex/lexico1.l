%option noyywrap

%{

#include <stdio.h>

%%}

%%

[1-9][0-9]* {printf ("Encotre una contante entera decimal \n");}
0[0-7]* {printf ("Encontre una constante enterea octal \n")}
0[xX][0-9a-f-A-F]+ {printf ("Encontre una constante entera hexadecimal \n")}
[a-zA-Z_][a-zA-Z0-9_]* {printf ("Encontre un identificador")}

%%