length:
   mov  ebx, eax
lp:
   cmp byte [eax], 0
   jz  lpend
   inc eax
   jmp lp
lpend:
   sub eax, ebx
   ret

Contentlength:
   mov  ebx, eax
   mov edx, 0
Contentlp:
   movzx ecx, byte[eax]
   cmp ecx, 0
   jz  Contentlpend
   inc eax
   inc edx
   jmp Contentlp
Contentlpend:
   ;sub eax, ebx
   mov eax, edx
   ret

;mov ebx, [file]
OpenCall:
   mov eax, sys_open
   mov ecx, 0
   int 80h
   ret

;mov ecx, content
;mov edx, num
ReadCall:
   mov eax, sys_read
   mov ebx, eax
   int 80h
   je exit
   ret

;mov ebx, [file]
CreatCall:
   mov eax, sys_creat
   mov ecx, 0777
   int 80h
   ret

ascii:
   movzx ebx, byte[eax]
   push eax
   push ebx
   push ecx
   cmp byte[eax], 0
   je exit
   
      
a: 
   pop ecx
   pop ebx
   pop eax
   inc eax 
   loop ascii
   ret


write:

   mov eax, sys_write
   mov ebx, 1
   mov ecx, [message]
   mov edx, [messageLength]
   int 80h
   jmp a
;mov eax,sys_write
   ;mov ebx,1
   ;mov ecx, [message]
   ;mov edx,[messageLength]
   ;int 80h


