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
   push edx
   mov eax, ebx
   mov ebx, 128
label1:
   cmp ebx, 1
   je a
   cmp eax, ebx
   jge nextToken
   push eax
   push ebx
   push ecx
   push edx
   call write 
   pop edx
   pop ecx
   pop ebx
   pop eax
   push eax
   push edx
   mov eax, ebx
   mov edx, 0
   mov ecx, 2
   div ecx
   mov ebx, eax
   pop edx
   pop eax
   jmp label1
      
a: 
   pop edx
   pop ebx
   pop eax
   inc eax
   ;inc eax
   ;cmp byte[eax], 0
   ;je exit
   dec edx
   cmp edx, 0
   jne ascii
   ;loop ascii
   ret

nextToken:
   sub eax, ebx
   push eax
   push ebx
   push ecx
   push edx
   call write
   pop edx
   pop ecx
   pop ebx
   pop eax
   push eax
   push ecx
   mov eax, ebx
   mov ecx, 2
   mov edx, 0
   div ecx
   mov ebx, eax
   pop ecx
   pop eax
   jmp label1

write:

   mov eax, sys_write
   mov ebx, 1
   mov ecx, [message]
   mov edx, [messageLength]
   int 80h
   ret
;mov eax,sys_write
   ;mov ebx,1
   ;mov ecx, [message]
   ;mov edx,[messageLength]
   ;int 80h


