%option noyywrap

%{
#include <stdio.h>
%}

%%

[a-zA-Z_][a-zA-Z0-9_]* { printf("Identifier: %s\n", yytext); }

0|([1-9][0-9]*)[uU]?[lL]{0,2}  { printf("Decimal constant: %s\n", yytext); }

0[0-7]+[uU]?[lL]{0,2}          { printf("Octal constant: %s\n", yytext); }

0[xX][0-9a-fA-F]+[uU]?[lL]{0,2} { printf("Hexadecimal constant: %s\n", yytext); }

([0-9]+\.[0-9]*([eE][-+]?[0-9]+)?) { printf("Real constant (no suffix): %s\n", yytext); }
([0-9]*\.[0-9]+([eE][-+]?[0-9]+)?) { printf("Real constant (no suffix): %s\n", yytext); }
([0-9]+[eE][-+]?[0-9]+)            { printf("Real constant (no suffix): %s\n", yytext); }

([0-9]+\.[0-9]*([eE][-+]?[0-9]+)?[fFlL]?) { printf("Real constant (suffix): %s\n", yytext); }
([0-9]*\.[0-9]+([eE][-+]?[0-9]+)?[fFlL]?) { printf("Real constant (suffix): %s\n", yytext); }
([0-9]+[eE][-+]?[0-9]+[fFlL]?)            { printf("Real constant (suffix): %s\n", yytext); }

'[^'\\]'            { printf("Character constant (simple): %s\n", yytext); }

(a|b|f|n|r|t|v|\'|\"|\?|\\)  { printf("Character constant (simple escape): %s\n", yytext); }

'\\[0-7]{1,3}'      { printf("Character constant (octal escape): %s\n", yytext); }

'\\x[0-9a-fA-F]+'   { printf("Character constant (hexadecimal escape): %s\n", yytext); }

\"([^"\\]|\\.)*\"   { printf("String literal: %s\n", yytext); }

(char|double|enum|float|int|long|short|struct|union|void|break|case|continue|deafault|do|else|for|goto|if|return|switch|while|auto|const|extern|register|signed|sizeof|static|typedef|unsigned|volatile) { printf("Word Reserved: %s\n", yytext); } 
. {printf("word unrecognized: %s\n", yytext);} 
%%
int main(int argc, char **argv)
{
    yylex();
    return 0;
}
