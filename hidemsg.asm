%include 'help.asm'

section .bss
   stat resb 64
   source_file resb 1024
   destination_file resb 1024
   fd_in resb 1
   fd_out resb 1
   content resb 3200000
   contentLength resb 1024
   message resb 1024
   messageLength resb 1024
   ;quotient resb 1
   ;var resb 1
   temp resb 1024
   buffer resb 256
   bufferLength resb 2
struc STAT
    .st_dev: resd 1
    .st_ino: resd 1
    .st_mode: resw 1
    .st_nlink: resw 1
    .st_uid: resw 1
    .st_gid: resw 1
    .st_rdev: resd 1
    .st_size: resd 1
    .st_atime: resd 1
    .st_mtime: resd 1
    .st_ctime: resd 1
    .st_blksize: resd 1
    .st_blocks: resd 1
endstruc 

section .data

   invalid: db 'Por favor ingresar los argumentos de la siguiente manera: hidemsg "Hola a todos" -f archivo1.ppm -o archivo2.ppm', 10, 0
   invalidLen: equ $ - invalid
   file: db 'image.ppm'
   okmessage: db 'Ok', 10, 0
   okLen: equ $ - okmessage   
   one: db '1', 10, 0
   oneLen: equ $ - one
   zero: db '0', 10, 0
   zeroLen: equ $ - zero
   NUMARGS equ 6
   sys_exit equ 1
   sys_read equ 3
   sys_write equ 4
   sys_open equ 5
   sys_close equ 6
   sys_creat equ 8
   sys_stat equ 106
   initial equ 1   
   
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
   jmp BinaryNumber

BinaryNumber:
   ;movsx eax, byte[message]
   ;mov esi, [message]
   ;mov ecx, 10
   ;call ascii
   ;lea esi, [message]
   ;mov ecx, 4
   ;call string_to_int
   mov eax, [message] 
   mov edx, [messageLength]
   mov ecx, 1
   call ascii
   jmp OpenFile

OpenFile:
   mov eax, sys_stat
   mov ebx, [source_file]
   mov ecx, stat
   int 80h
   mov eax, dword [stat + STAT.st_size]
   mov [contentLength], eax
   mov ebx,[source_file]
   call OpenCall
   mov ecx, content
   mov edx, contentLength
   call ReadCall
   mov eax, content
   mov edx, [contentLength]
.loop:
   movzx ebx, byte[eax]
   cmp eax, 127
   jl .continue
   ;cmp esi, 10000
   ;je exit
   ;push ecx
   ;push eax
   ;mov eax, ecx
   ;and eax, 255
   ;cmp eax, 30
   ;jl exit
   ;pop eax
   ;pop ecx
   push eax
   push ecx
   push edx
   mov ecx, [message]
   mov eax, sys_write
   mov ebx, 1
   mov edx, 1
   int 80h
   pop edx
   pop ecx
   pop eax
   dec edx
   cmp edx, 0
   je .continue
   jmp .loop   

.continue:
   mov ebx, [destination_file]
   call CreatCall
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
