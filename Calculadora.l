%{
#include <stdio.h>
#include <stdlib.h>
#include "Calculadora.tab.h"
#define _USE_MATH_DEFINES
#include <math.h>

%}
Blanco  [ \t]
Digito       [0-9]
Entero      {Digito}+
Flotante    {Digito}*"."{Digito}+
Numero     {Entero}|{Flotante}
Simbolo [,%\+\-\*/\(\)\n]

%%

"sin"       { return SIN; }
"cos"       { return COS; }
"tan"       { return TAN; }
"pi"        {return PI; }
"e"         {return EULER; }
"sqrt"      { return SQRT; }
"pow"       { return POW; }
"abs"       { return ABS; }
"log"       { return LOG; }
"ln"        { return LN; }
"exit"      { return EXIT; }
{Blanco}    ; // Ignora espacios en blanco
{Numero}  { yylval.real = atof(yytext); return NUMERO; }
{Simbolo}   { return yytext[0]; }
.        { printf("Caracter no reconocido: %s\n", yytext); return -1; }
%%
