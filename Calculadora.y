%{
#include <stdio.h>
#include <stdlib.h>
#define _USE_MATH_DEFINES
#include <math.h>
extern int yylex();
void yyerror(const char *s);
%}

%union
{
    double real;
}
%token EXIT                                    // Comando para salir del programa
%token <real> NUMERO
%token LOG LN                                  // Logaritmo y logaritmo natural
%token ABS                                      // Valor absoluto
%token SQRT POW                                 // Raiz cuadrada y potencia
%token SIN COS TAN                              // Funciones trigonométricas
%token PI EULER                                 // Constantes matemáticas

// Declaración de tipos para las expresiones no terminales
%type <real> exp_real


%start linea
%left '+' '-'
%left '*' '/'
%left '%'                                    // Asignación de precedencia para los operadores aritméticos
%right NEG                                  // Asignación de precedencia para el operador unario negativo

%%

linea:  
        | linea exp '\n' {}
        ;

exp:    exp_real {printf("%f\n\n", $1);}
        | EXIT '\n' {printf("Gracias por utilizar el programa <3"); exit(0);} // Comando para salir del programa
        ;

exp_real:   //Expresiones terminales que incluyen el numero y  constantes
            NUMERO {$$ = $1;}
            | PI {$$ = M_PI;}
            | EULER {$$ = M_E;}
            //Expresiones no terminales para obtener las operaciones aritméticas
            | exp_real '+' exp_real {$$ = $1 + $3;}
            | exp_real '-' exp_real {$$ = $1 - $3;}
            | exp_real '*' exp_real {$$ = $1 * $3;}
            | exp_real '/' exp_real {
                if($3) $$ = $1 / $3;
                else $$=$1; // Manejo de división por cero
                }
            | exp_real '%' exp_real {$$ = (int)$1 % (int)$3;}
            //Expresiones no terminales para el uso de parentesis
            |'(' exp_real ')' {$$ = $2;}
            //Expresiones no terminales para obtener las operaciones trigonometricas
            |SIN '(' exp_real ')' {$$ = sin($3);}
            | COS '(' exp_real ')' {$$ = cos($3);}
            | TAN '(' exp_real ')' {$$ = tan($3);}
            //Expresiones no terminales para obtener la raiz cuadrada y potencia
            | SQRT '(' exp_real ')' {$$ = sqrt($3);}
            | POW '('exp_real ',' exp_real ')' {$$ = pow((int)$3, (int)$5);}
            //Expresiones no terminales para el valor absoluto
            | ABS '(' exp_real ')' {$$ = fabs($3);}
            //Expresiones no terminales para logaritmo y logaritmo natural
            | LOG '(' exp_real ')' {$$ = log10($3);}
            | LN '(' exp_real ')' {$$ = log($3);}
            | '-' exp_real %prec NEG {$$ = -$2;}
            ;

%%

int main()
{
    printf("Calculadora cientifica (CTRL+C para salir)\n");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    fprintf(stderr, "Error: %s\n", s);
}