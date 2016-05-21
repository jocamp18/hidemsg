section .bss
   file_name resb 1024
   fd_in resb 1024
   info resb 1024
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
   sys_close equ 6
   sys_read equ 3
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
   jmp SecondArgument

SecondArgument:
   pop eax                          ;eax has the second argument(-f)
   cmp byte[eax], '-'
   jne InvalidArguments
   cmp byte[eax+1], 'f'
   jne InvalidArguments
   jmp ThirdArgument

ThirdArgument:
   pop ebx                          ;ebx has the third argument(The source file)
   mov eax, sys_open
   mov ecx, 0
   ;mov edx, 0777
   int 80h
   ;mov [fd_in], eax
   mov eax, sys_read
   mov ebx, eax
   mov ecx, info
   mov edx, 26
   int 80h
   ;mov eax, sys_close
   ;mov ebx, [fd_in]
   mov eax, sys_write
   mov ebx, 1
   mov ecx, info
   mov edx, 26
   int 80h
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
