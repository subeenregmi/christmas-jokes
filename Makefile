ASM=nasm
LINKER=ld

all: triangle.o
	$(LINKER) $< -o triangle

%.o : %.asm
	$(ASM) -f elf64 $< -o $@

clean:
	rm -rf *.o triangle

