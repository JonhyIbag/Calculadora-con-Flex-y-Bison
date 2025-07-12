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
    int entero;
}
%token EXIT                                    // Comando para salir del programa
%token <real> NUMERO
%token LOG LN                                  // Logaritmo y logaritmo natural
%token ABS                                      // Valor absoluto
%token SQRT POW                                 // Raiz cuadrada y potencia
%token SIN COS TAN                              // Funciones trigonométricas
%token PI EULER                                 // Constantes matemáticas
%token INS_ARITMETICAS INS_TRIGONOMETRICAS      // Comandos para mostrar las operaciones disponibles
%token INS_LOGARITMOS INS_POTENCIA INS_RAIZ     // Comandos para mostrar las operaciones disponibles
%token INS_ABSOLUTO INS_CONSTANTES              // Comandos para mostrar las operaciones disponibles
%token INVALIDO                                // Token para caracteres no válidos

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
    | error '\n'      { printf("Error: Entrada invalida. Intentalo de nuevo.\n\n"); yyerrok; }
    ;

exp:    
    exp_real {
        if (!isnan($1)) // Verifica si el resultado no es NaN (Not A Number)
            printf("%f\n\n", $1);
    }
    | errores_sintacticos
    | informacion
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
        if($3>0) 
            $$ = $1 / $3;
        else{
            printf("Error semantico: No puede realizar una division sobre 0.\n\n");
            $$ = NAN;
        }
    }
    | exp_real '%' exp_real {$$ = (int)$1 % (int)$3;}
    //Expresiones no terminales para el uso de parentesis
    |'(' exp_real ')' {$$ = $2;}
    //Expresiones no terminales para obtener las operaciones trigonometricas
    | SIN '(' exp_real ')' {$$ = sin($3);}
    | COS '(' exp_real ')' {$$ = cos($3);}
    | TAN '(' exp_real ')' {$$ = tan($3);}
    //Expresiones no terminales para obtener la raiz cuadrada y potencia
    | SQRT '(' exp_real ')' {
        if($3>=0) 
            $$ = log10($3);
        else {
            printf("Error semantico: El logaritmo de un negativo no esta definido.\n\n");
            $$ = NAN;
        }
    }
    | POW '('exp_real ',' exp_real ')' {$$ = pow((int)$3, (int)$5);}
    //Expresiones no terminales para el valor absoluto
    | ABS '(' exp_real ')' {$$ = fabs($3);}
    //Expresiones no terminales para logaritmo y logaritmo natural
    | LOG '(' exp_real ')' {
        if($3>=0) 
            $$ = log10($3);
        else {
            printf("Error semantico: El logaritmo de un negativo no esta definido.\n\n");
            $$ = NAN;
        }
    }
    | LN '(' exp_real ')' {$$ = log($3);}
    | '-' exp_real %prec NEG {$$ = -$2;}
    ;



errores_sintacticos:
    exp_real '+' '*' exp_real{printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'+' '/'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'+' '+' exp_real{printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'-' '+'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'-' '*'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'-' '/'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'/' '+'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'/' '*'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'/' '/'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'*' '+'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'*' '*'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}
    | exp_real'*' '/'exp_real {printf("Error de sintaxis: no puede colocar 2 operaciones juntas.\n\n");}

informacion:
    INS_ARITMETICAS{
        printf("Operaciones aritmeticas disponibles:\n"
            "1. Suma: a + b\n"
            "2. Resta: a - b\n"
            "3. Multiplicacion: a * b\n"
            "4. Division: a / b (no se permite división por cero)\n"
            "5. Modulo: a %% b\n\n");
    }
    | INS_TRIGONOMETRICAS{
        printf("Operaciones trigonometricas disponibles:\n"
            "1. Seno: sin(a)\n"
            "2. Coseno: cos(a)\n"
            "3. Tangente: tan(a)\n\n"
            "**Nota1: los angulos deben estar en radianes.\n"
            "**Nota2: \"a\" puede representar cualquier operacion aritmetica valida.\n\n");
    }
    | INS_LOGARITMOS{
        printf("Operaciones logaritmicas disponibles:\n"
            "1. Logaritmo base 10: log(a) con a >= 0\n"
            "2. Logaritmo natural: ln(a)\n"
            "**Nota: \"a\" puede representar cualquier operacion aritmetica valida.\n\n");
    }
    | INS_POTENCIA{
        printf("Operacion de potencia disponible:\n"
            "1. Potencia: pow(a, b) donde a es la base y b es el exponente.\n"
            "**Nota: \"a\" y \"b\" pueden representar cualquier operacion aritmetica valida.\n\n");
    }
    | INS_RAIZ{
        printf("Operacion de raiz cuadrada disponible:\n"
            "1. Raíz cuadrada: sqrt(a) con a >= 0.\n"
            "**Nota: \"a\" puede representar cualquier operacion aritmetica valida.\n\n");
    }
    | INS_ABSOLUTO{
        printf("Operacion de valor absoluto disponible:\n"
            "1. Valor absoluto: abs(a) donde a puede ser cualquier número real.\n"
            "**Nota: \"a\" puede representar cualquier operacion aritmetica valida.\n\n");
    }
    | INS_CONSTANTES{
        printf("Constantes matematicas disponibles:\n"
            "1. pi: Representa el valor de pi (3.14159...)\n"
            "2. e: Representa la constante de euler (2.71828...)\n\n");
    }

%%

int main()
{
    printf("**************Ingrese el comando de la izquierda para obtener la ayuda correspondiente**************\n\n"
        "\taritmeticas\t\tMuestra las operaciones aritmeticas disponibles\n"
        "\ttrigonometricas\t\tMuestra las operaciones trigonometricas disponibles\n"
        "\tlogaritmos\t\tMuestra las operaciones logaritmicas disponibles\n"
        "\tpotencia\t\tMuestra la sintaxis para elevar un nuemero a cierta potencia\n"
        "\traiz\t\t\tMuestra la sintaxis para obtener la raiz cuadrada de un numero\n"
        "\tabsoluto\t\tMuestra la sintaxis para obtener el valor absoluto de un numero\n"
        "\tconstantes\t\tMuestra las constantes matematicas disponibles\n"
        "\texit\t\t\tSalir del programa\n\n");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    //fprintf(stderr, "Error: %s\n", s);
}