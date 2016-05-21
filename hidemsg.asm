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
global _start

_start:
   pop eax                                ;eax has the number of arguments
   cmp eax,NUMARGS
   pop eax                                ;eax has the name of the name of the program
   jne InvalidArguments                   ;if argc != 6
   je FirstArgument

FirstArgument:   
   mov eax, sys_write
   mov ebx, 1
   mov ecx, okmessage
   mov edx, okLen
   int 80h
   pop eax                                ;eax has the first argument (The message)
   mov ecx, eax
   cmp byte[ecx], 'a'
   je SecondArgument

SecondArgument:
   mov eax, sys_write
   mov ebx, 1
   mov ecx, okmessage
   mov edx, okLen
   int 80h
   call exit

InvalidArguments:
   mov eax, sys_write
   mov ebx, 1
   mov ecx, invalid
   mov edx, invalidLen
   int 80h
   call exit

exit:
   mov eax, sys_exit
   xor ebx, ebx
   int 80h
