%include 'help.asm'

section .bss

   source_file resb 1024
   destination_file resb 1024
   fd_in resb 1
   fd_out resb 1
   content resb 1024
   contentLength resb 1024
   message resb 1024
   messageLength resb 1024

section .data

   invalid: db 'Por favor ingresar los argumentos de la siguiente manera: hidemsg "Hola a todos" -f archivo1.ppm -o archivo2.ppm', 10, 0
   invalidLen: equ $ - invalid
   file: db 'image.ppm'
   okmessage: db 'Ok', 10, 0
   okLen: equ $ - okmessage   
   NUMARGS equ 6
   sys_exit equ 1
   sys_read equ 3
   sys_write equ 4
   sys_open equ 5
   sys_close equ 6
   sys_creat equ 8

section .text

global _start

_start:
   pop eax                          ;eax has the number of arguments
   cmp eax,NUMARGS
   pop eax                          ;eax has the name of the name of the program
   jne InvalidArguments             ;if argc != 6
   je FirstArgument

FirstArgument:   
   pop eax                          ;eax has the first argument (The message)
   mov [message], eax
   call length
   mov [messageLength], eax
   ;mov eax,sys_write
   ;mov ebx,1
   ;mov ecx, [message]
   ;mov edx,[messageLength]
   ;int 80h
   jmp SecondArgument

SecondArgument:
   pop eax                          ;eax has the second argument(-f)
   cmp byte[eax], '-'
   jne InvalidArguments
   cmp byte[eax+1], 'f'
   jne InvalidArguments
   jmp ThirdArgument

ThirdArgument:
   pop eax                          ;ebx has the third argument(The source file)
   mov [source_file],eax
   jmp FourthArgument

FourthArgument:
   pop eax                          ;eax has the fourth argument(-o)
   cmp byte[eax], '-'
   jne InvalidArguments
   cmp byte[eax+1], 'o'
   jne InvalidArguments
   jmp FifthArgument

FifthArgument:
   pop eax                          ;eax has the fifth argument(The output file)
   mov [destination_file],eax
   jmp OpenFile

OpenFile:
   mov ebx,[source_file]
   mov eax, sys_open
   mov ecx, 0
   int 80h
   mov eax, sys_read
   mov ebx, eax
   mov ecx, content
   mov edx, 26
   int 80h
   mov eax, content
   call length
   mov [contentLength], eax
   mov eax, sys_write
   mov ebx, 1
   mov ecx, content
   mov edx, [contentLength]
   int 80h
   mov eax, sys_creat
   mov ebx, [destination_file]
   mov ecx, 0777
   int 80h
   ;mov [fd_out], eax
   mov edx, [contentLength]
   mov ecx, content
   mov ebx, eax;[fd_out]
   mov eax, sys_write
   int 80h
   jmp exit
   
InvalidArguments:
   mov eax, sys_write
   mov ebx, 1
   mov ecx, invalid
   mov edx, invalidLen
   int 80h
   jmp exit


exit:
   mov eax, sys_exit
   xor ebx, ebx
   int 80h
