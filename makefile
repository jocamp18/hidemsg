hidemsg: hidemsg.o
	ld -m elf_i386 -s -o hidemsg hidemsg.o
hidemsg.o: hidemsg.asm
	nasm -f elf hidemsg.asm
clean:
	rm *.o test.ppm test1.ppm hidemsg
