section .bss
file_name resb 1024
fd_in resb 1024

section .data
   invalid: db 'Por favor ingresar los argumentos de la siguiente manera: hidemsg Hola a todos -f archivo1.ppm -o archivo2.ppm', 10, 0
   invalidLen: equ $ - invalid
   file: db 'image.ppm'
   okmessage: db 'Ok', 10, 0
   okLen: equ $ - okmessage   
   NUMARGS equ 6
   sys_exit equ 1
   sys_write equ 4
   sys_open equ 5
section .text
global main

main:
   pop ecx
   pop ecx
   cmp ecx,NUMARGS
   jne InvalidArguments
   je FirstArgument

FirstArgument:   
   mov eax, sys_write
   mov ebx, 1
   mov ecx, okmessage
   mov edx, okLen
   int 80h
   pop eax
   pop eax
   pop eax
   mov ecx, eax
   cmp byte[eax], 'a'
   je secondArgument
InvalidArguments:
   mov eax, sys_write
   mov ebx, 1
   mov ecx, invalid
   mov edx, invalidLen
   int 80h
   mov eax, sys_exit
   xor ebx, ebx
   int 80h
secondArgument:
   mov eax, sys_write
   mov ebx, 1
   mov ecx, okmessage
   mov edx, okLen
   int 80h

