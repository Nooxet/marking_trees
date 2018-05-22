
all: marking

marking: marking_funcs.s marking.c
	nasm -f elf marking_funcs.s -o marking_funcs.o
	gcc -m32  marking.c marking_funcs.o -o marking -lm

clean:
	rm -f *.o
