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
   cmp byte[eax], 97
   je write
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

