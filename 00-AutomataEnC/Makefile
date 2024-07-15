#nombre del archivo .c con nuestro código
archivo := tp1


#Aca ponemos el compilador a usar, nosotros usaremos gcc
CC := gcc


#OBJS objetos necesarios
OBJS := 
#HDRS dependencias necesarias
HDRS :=


#ALL reglas asociadas al make que se realizarán al usar dicho comando
all: tp1


#tp1 es nuestra regla que queremos que se compile cuando hagamos usemos el comando make
tp1: $(archivo).c $(OBJS) $(HDRS)
    $(CC) $(archivo).c -o tp1


#Clean
clean:
    rm tp1
    rm salida.txt
