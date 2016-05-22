# hidemsg
Steganography

Compilation
nasm -f elf hidemsg.asm

Link
ld -m elf_i386 -s -o hidemsg hidemsg.o
