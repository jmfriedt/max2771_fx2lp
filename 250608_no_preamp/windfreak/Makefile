all: windfreak
	
rs232.o: rs232.c
	gcc -c rs232.c

windfreak.o: windfreak.c
	gcc -c windfreak.c

windfreak:windfreak.o rs232.o
	gcc -o windfreak windfreak.c rs232.o -lcurses

clean:
	rm *.o windfreak
