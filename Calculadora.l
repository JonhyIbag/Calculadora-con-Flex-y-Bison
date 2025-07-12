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

"aritmeticas"   { return INS_ARITMETICAS; }
"trigonometricas"   { return INS_TRIGONOMETRICAS; }
"logaritmos"    { return INS_LOGARITMOS; }
"potencia"   { return INS_POTENCIA; }
"raiz"     { return INS_RAIZ; }
"absoluto"  { return INS_ABSOLUTO; }
"constantes"    { return INS_CONSTANTES; }
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
.        {return INVALIDO; } // Cualquier otro caracter no válido;
%%
