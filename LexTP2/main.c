#include <stdio.h>
#include<stdlib.h>
#include <string.h>

typedef struct {
    char *name;
    int count;
} Identifier;

typedef struct {
    char *value;
    int length;
} StringLiteral;

typedef struct {
    char *name;
    int line;
    int column;
} Keyword;

/* Storage for information */
Identifier identifiers[1000];
StringLiteral string_literals[1000];
Keyword keywords_found[1000];
int decimal_constants[1000];
int hex_constants[1000];
int octal_constants[1000];
double real_constants[1000];
char character_constants[1000];
char punctuation[1000][3];

/* Counters */
int identifier_count = 0;
int string_literal_count = 0;
int keyword_count = 0;
int decimal_constant_count = 0;
int hex_constant_count = 0;
int octal_constant_count = 0;
int real_constant_count = 0;
int character_constant_count = 0;
int punctuation_count = 0;

/* Flex variables */
int yylineno = 1;
int yycolumn = 1;

extern int yylex();
extern FILE *yyin;

void add_identifier(char *name) {
    for (int i = 0; i < identifier_count; i++) {
        if (strcmp(identifiers[i].name, name) == 0) {
            identifiers[i].count++;
            return;
        }
    }
    identifiers[identifier_count].name = strdup(name);
    identifiers[identifier_count].count = 1;
    identifier_count++;
}

void add_string_literal(char *value) {
    string_literals[string_literal_count].value = strdup(value);
    string_literals[string_literal_count].length = strlen(value);
    string_literal_count++;
}

void add_keyword(char *name, int line, int column) {
    keywords_found[keyword_count].name = strdup(name);
    keywords_found[keyword_count].line = line;
    keywords_found[keyword_count].column = column;
    keyword_count++;
}

void add_decimal_constant(int value) {
    decimal_constants[decimal_constant_count] = value;
    decimal_constant_count++;
}

void add_hex_constant(int value) {
    hex_constants[hex_constant_count] = value;
    hex_constant_count++;
}

void add_octal_constant(int value) {
    octal_constants[octal_constant_count] = value;
    octal_constant_count++;
}

void add_real_constant(double value) {
    real_constants[real_constant_count] = value;
    real_constant_count++;
}

void add_character_constant(char value) {
    character_constants[character_constant_count] = value;
    character_constant_count++;
}

void add_punctuation(char *symbol) {
    strncpy(punctuation[punctuation_count], symbol, 2);
    punctuation[punctuation_count][2] = '\0';
    punctuation_count++;
}

void report_unrecognized(char *text, int line, int column) {
    fprintf(stderr, "Unrecognized token: %s at %d:%d\n", text, line, column);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Could not open input file");
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);

    // Report results
    printf("Identifiers:\n");
    for (int i = 0; i < identifier_count; i++) {
        printf("%s: %d\n", identifiers[i].name, identifiers[i].count);
    }

    printf("\nString Literals:\n");
    for (int i = 0; i < string_literal_count; i++) {
        printf("%s (length: %d)\n", string_literals[i].value, string_literals[i].length);
    }

    printf("\nKeywords:\n");
    for (int i = 0; i < keyword_count; i++) {
        printf("%s at %d:%d\n", keywords_found[i].name, keywords_found[i].line, keywords_found[i].column);
    }

    printf("\nDecimal Constants:\n");
    for (int i = 0; i < decimal_constant_count; i++) {
        printf("%d\n", decimal_constants[i]);
    }

    printf("\nHexadecimal Constants:\n");
    for (int i = 0; i < hex_constant_count; i++) {
        printf("%d\n", hex_constants[i]);
    }

    printf("\nOctal Constants:\n");
    for (int i = 0; i < octal_constant_count; i++) {
        printf("%d\n", octal_constants[i]);
    }

    printf("\nReal Constants:\n");
    for (int i = 0; i < real_constant_count; i++) {
        printf("%f\n", real_constants[i]);
    }

    printf("\nCharacter Constants:\n");
    for (int i = 0; i < character_constant_count; i++) {
        printf("%c\n", character_constants[i]);
    }

    printf("\nPunctuation:\n");
    for (int i = 0; i < punctuation_count; i++) {
        printf("%s\n", punctuation[i]);
    }

    return 0;
}