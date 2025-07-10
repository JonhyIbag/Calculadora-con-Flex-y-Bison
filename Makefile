# Makefile para la Calculadora con Bison y Flex

# Nombre del ejecutable
PROGRAMA = Calculadora

# Archivos fuente
FUENTE_BISON = Calculadora.y
FUENTE_FLEX = Calculadora.l

# Archivos generados
BISON_C = Calculadora.tab.c
BISON_H = Calculadora.tab.h
FLEX_C = lex.yy.c

# Librería de Flex (ruta absoluta o relativa)
LIBFLEX = /usr/lib/libfl.a

# Compilador y opciones
CC = gcc
CFLAGS = -lm

# Regla principal
$(PROGRAMA): $(BISON_C) $(FLEX_C)
	$(CC) -o $(PROGRAMA) $(BISON_C) $(FLEX_C) $(CFLAGS) $(LIBFLEX)

# Generar archivos con bison y flex
$(BISON_C) $(BISON_H): $(FUENTE_BISON)
	bison -d $(FUENTE_BISON)

$(FLEX_C): $(FUENTE_FLEX)
	flex $(FUENTE_FLEX)

# Limpiar archivos generados
clean:
	rm -f $(PROGRAMA) $(BISON_C) $(BISON_H) $(FLEX_C)
