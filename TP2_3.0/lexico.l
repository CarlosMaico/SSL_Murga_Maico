%option noyywrap

%{
    #include <stdio.h>
    #include "utilidad.h"

    struct Listado *palabrasReservadas, *identificadores, *constantes, *literalesCadena, *comentarios, *caracteresPuntuacion, *directivas, *noReconocidos;
    int sumatoriaDecimales = 0, contadorDeLinea = 1;
%}

PALABRAS_RESERVADAS (break|continue|default|enum|goto|return|sizeof|typedef|union)
TIPO_DE_DATO (char|double|float|int|void|struct)
MODIFICADOR (const|long|short|unsigned|signed|volatile)
ESPECIFICADOR_DE_ALMACENAMIENTO (auto|extern|static|register)
ESTRUCTURA_DE_CONTROL (if|else|switch|case|for|do|while)

LETRA [a-zA-Z]
DIGITO_DECIMAL [0-9]
DIGITO_DECIMAL_SIN_CERO [1-9]
DIGITO_OCTAL [0-7] 
DIGITO_HEXADECIMAL [a-fA-F0-9] 

SUFIJO_LONG (l|L)
SUFIJO_ENTERO ({SUFIJO_LONG}|u|U)

SUFIJO_REAL ({SUFIJO_LONG}|f|F)
CONSTANTE_FRACCION (({DIGITO_DECIMAL}*)?"."{DIGITO_DECIMAL}*|{DIGITO_DECIMAL}*)
PARTE_EXPONENTE (e|E)("+"|"-")?{DIGITO_DECIMAL}*

SECUENCIA_ESCAPE_SIMPLE (a|b|f|n|r|t|v|\'|\"|\?|\\)

CARACTER_DE_PUNTUACION (\[|\]|\(|\)|\{|\}|\.|\-\>|\+\+|\-\-|\&|\*|\+|\-|\˜|\!|\/|\%|\<\<|\>\>|\<|\>|\<\=|\>\=|\=\=|\!\=|\ˆ|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\ˆ\=|\|\=|\?|\:|\;|\.\.\.|\,|\#|\#\#)

%%
\n contadorDeLinea++;;
{PALABRAS_RESERVADAS} {pushLista(&palabrasReservadas, yytext, 0, yyleng);};
{TIPO_DE_DATO} {pushLista(&palabrasReservadas, yytext, 1, yyleng);};
{MODIFICADOR} {pushLista(&palabrasReservadas, yytext, 2, yyleng);};
{ESPECIFICADOR_DE_ALMACENAMIENTO} {pushLista(&palabrasReservadas, yytext, 3, yyleng);};
{ESTRUCTURA_DE_CONTROL} {pushLista(&palabrasReservadas, yytext, 4, yyleng);};

\#(include|define) {pushListaSinRepetir(&directivas, yytext, yyleng);};


({LETRA}|"_")({LETRA}|"_"|{DIGITO_DECIMAL})* {pushListaSinRepetir(&identificadores, yytext, yyleng);};

{CARACTER_DE_PUNTUACION}  {pushListaSinRepetir(&caracteresPuntuacion, yytext, yyleng);};

{DIGITO_DECIMAL_SIN_CERO}{DIGITO_DECIMAL}*{SUFIJO_ENTERO}? {pushLista(&constantes, yytext, 0, yyleng); sumatoriaDecimales += conseguirDecimal(yytext, yyleng);};
0{DIGITO_OCTAL}*{SUFIJO_ENTERO}? {pushLista(&constantes, yytext, 1, yyleng);};
0[xX]{DIGITO_HEXADECIMAL}+{SUFIJO_ENTERO}? {pushLista(&constantes, yytext, 2, yyleng);};
({CONSTANTE_FRACCION}{PARTE_EXPONENTE}?{SUFIJO_REAL}?|{CONSTANTE_FRACCION}{PARTE_EXPONENTE}{SUFIJO_REAL}?) {pushLista(&constantes, yytext, 3, yyleng);};
\'([^\\\']|\\{SECUENCIA_ESCAPE_SIMPLE}|\\{DIGITO_OCTAL}{1,3}|\\x{DIGITO_HEXADECIMAL}{1,2})\' {pushLista(&constantes, yytext, 4, yyleng);};


\"(([^\"]|\\\")*[^\\])?\" {pushLista(&literalesCadena, yytext, yyleng - 2, yyleng);};

\/\/.*  {pushLista(&comentarios, yytext, 0, yyleng);};
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {pushLista(&comentarios, yytext, 1, yyleng);};

([ ])+ {;};
. {pushLista(&noReconocidos, yytext, contadorDeLinea, yyleng);};
%%

int main() {
    // Acciones previas a la invocación den analizador léxico 

    yyin = fopen("entrada.txt", "r");
    //yyout = fopen("salida.txt", "w");	

    // Invocación del analizador léxico 

    yylex();
	
    // Acciónes posteriores a la ejecución del analizador léxico, sirven por ejemplo, para hacer un informen de resumen.

    printf("Listado de identificadores\n");
    ordenarAlfabeticamente(identificadores);
    mostrarLista_OrdenAparicion(identificadores, "Identificador", "Cantidad de apariciones");

    printf("\nListado de literales cadena\n");
    mostrarLista_OrdenAparicion(literalesCadena, "Literal cadena", "Longitud");
   
    printf("\nListado de palabras reservadas\n");
    mostrarPalabrasReservadas(palabrasReservadas);

    printf("\nListado de constantes\n");
    mostrarConstantes(constantes);

    printf("\nSumatoria de enteros decimales = %d\n", sumatoriaDecimales);

    printf("\nListado de caracteres de puntuacion\n");
    mostrarLista_OrdenAparicion(caracteresPuntuacion, "Caracter", "Cantidad de apariciones");

    printf("\nListado de comentarios\n");
    mostrarComentarios(comentarios);

    printf("\nListado de directivas\n");
    mostrarLista_OrdenAparicion(directivas, "Directiva", "Cantidad de apariciones");

    printf("\nListado de no reconocidos\n");
    mostrarLista_OrdenAparicion(noReconocidos, "Cadena/Caracter no reconocida", "Numero de linea");
    
    return 0;
}