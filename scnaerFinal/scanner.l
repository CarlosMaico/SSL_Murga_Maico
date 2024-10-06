%{
#include <stdio.h>  // Necesario para printf

// Flex usa la variable yylineno para seguir las líneas automáticamente
#define YYLTYPE struct { int first_line; int first_column; int last_line; int last_column; }
YYLTYPE yylloc;

%}

%option yylineno
%option noyywrap
%pointer
%x tokenNoReconocido


DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
IDENTIFICADOR  [a-zA-Z_][a-zA-Z0-9_]*
LETRA [a-zA-Z]

%%
\n {
    // Flex ya maneja el incremento de líneas automáticamente, solo necesitamos la columna
    yylloc.first_line = yylloc.last_line = yylineno;
    yylloc.first_column = yylloc.last_column = 1;
}

(char|double|enum|float|int|long|short|struct|union|void) {
    printf("Token: TIPO_DE_DATO        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
}

(signed|unsigned) {
    printf("Token: MODIFICADOR_DE_DATO Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
}

"if" { printf("Token: IF Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"else" { printf("Token: ELSE Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"while" { printf("Token: WHILE Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"for" { printf("Token: FOR Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"do" { printf("Token: DO Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"return" { printf("Token: RETURN Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column );}
"break" { printf("Token: BREAK Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"continue" { printf("Token: CONTINUE Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column); }
"switch"            {printf("Token: SWITCH Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"case"              {printf("Token: CASE Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column );}
"default"           {printf("Token: DEFAULT Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);  }
"=="                {printf("Token: IDENTICO Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"!="                {printf("Token: DISTINTO Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"<="                {printf("Token: MENORIGUAL Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column); }
">="                {printf("Token: MAYORIGUAL Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column );}
"&&"                {printf("Token: AND Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"||"                {printf("Token: OR Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}

"+" { printf("Token: MAS Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"-" { printf("Token: MENOS Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"*" { printf("Token: MULT Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"/" { printf("Token: DIV Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column) ;}
"++" {printf("Token: INCREMENTO Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"--" {printf("Token: DECREMENTO Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}

"^" { printf("Token: POTENCIA Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}

"=" {  printf("Token: IGUAL Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column) ;}
"+=" { printf("Token: MASIGUAL Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"-=" { printf("Token: MENOSIGUAL Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"*=" { printf("Token: MULTIGUAL Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"/=" { printf("Token: DIVIGUAL Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"("  { printf("Token: (        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
")"  { printf("Token: )        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"["  { printf("Token: [        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);}
"]"  { printf("Token: ]        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"{"  { printf("Token: {        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"}"  { printf("Token: }        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
";"  { printf("Token: ;        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
","  { printf("Token: ,        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"."  { printf("Token: .        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
">"  { printf("Token: >        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
"<"  { printf("Token: <        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}
":"  { printf("Token: :        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);}


[1-9]{DIGITO_DECIMAL}*[uU]?[lL]{0,2} {
     printf("Token: cONSTANTE        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
     
}

0{DIGITO_OCTAL}*[uU]?[lL]{0,2} {

     printf("Token: CONSTANTE        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
     
}

0[xX]{DIGITO_HEXADECIMAL}+[uU]?[lL]{0,2} {

     printf("Token: CONSTANTE        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
     
}

[0-9]+ { 

     printf("Token: CONSTANTE        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
     
}

({DIGITO_DECIMAL}+\.{DIGITO_DECIMAL}*([eE][-+]?{DIGITO_DECIMAL}+)?) {

     printf("Token: VALOR        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
    
}




[a-zA-Z_][a-zA-Z0-9_]* { 

     printf("Token: IDENTIFICADOR        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
     }


\"([^\\"]|\\.)*\" {

     printf("Token: lITERAL CADENA        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
    }

'(\\.|[^\\'])' {

     printf("Token: CONSTANTE        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
     }



[ \t]+ {  }

[^ \t\n] { yyless(0);BEGIN(tokenNoReconocido);}
<tokenNoReconocido>{
    <<EOF>> {

         printf("Token: TOKENnORECONCODIO        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
        BEGIN(INITIAL);
    }
    " "|\t|\n {
        yyless(0);

         printf("Token: TOKENNORECONOCIDO        Lexema: %-20s Línea: %d, Columna: %d\n",  yytext, yylloc.first_line, yylloc.first_column);
        BEGIN(INITIAL);
    }
    [^ \t\n]+ {
             printf("Token: TOKEN NO RECONCOIDO        Lexema: %-20s Línea: %d, Columna: %d\n", yytext, yylloc.first_line, yylloc.first_column);
        
    }
}




%%

int main(int argc, char **argv) {
    // Si se pasa un archivo como argumento, se utiliza ese archivo como entrada
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            fprintf(stderr, "No se pudo abrir el archivo: %s\n", argv[1]);
            return 1;
        }
        yyin = archivo;
    }

    // Procesa el archivo o entrada estándar
    yylex();

    // Cierra el archivo si fue abierto
    if (argc > 1) {
        fclose(yyin);
    }

    //{IDENTIFICADOR}[[:space:]]*=[[:space:]]*{IDENTIFICADOR}[^;]  { printf("ErrorSem: %-20s Línea: %d, Columna: %d\n", yytext, linea, columna); columna += yyleng;}

    return 0;
}