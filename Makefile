ASM=nasm
LINKER=ld

triangle: triangle.o
	$(LINKER) $< -o triangle

%.o : %.asm
	$(ASM) -f elf64 $< -o $@

clean:
	rm -rf *.o triangle

debug: triangle
	gdb -x gdb_commands.txt -args triangle 15

