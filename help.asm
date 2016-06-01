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
   mov ecx, 0420
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
   cmp ebx, 0
   je a
   cmp eax, ebx
   jge nextToken
   push eax
   push ebx
   push edx
   ;call writeZero
   mov byte[buffer + ecx], '0'
   inc ecx
   pop edx
   pop ebx
   pop eax
   push eax
   push ecx
   push edx
   mov eax, ebx
   mov edx, 0
   mov ecx, 2
   div ecx
   mov ebx, eax
   pop edx
   pop ecx
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
   call write
   ret

nextToken:
   sub eax, ebx
   push eax
   push ebx
   push edx
   ;call writeOne
   mov byte[buffer + ecx], '1'
   inc ecx
   pop edx
   pop ebx
   pop eax
   push eax
   push ecx
   push edx
   mov eax, ebx
   mov ecx, 2
   mov edx, 0
   div ecx
   mov ebx, eax
   pop edx
   pop ecx
   pop eax
   jmp label1

write:
   mov eax, [messageLength]
   mov ebx, 8
   mul ebx
   add eax,1
   mov [bufferLength], eax
   mov eax, sys_write
   mov ebx, 1
   mov ecx, buffer;[message]
   mov edx, [bufferLength]
   int 80h
   ret

writeOne: 
   mov eax, sys_write
   mov ebx, 1
   mov ecx, one
   mov edx, oneLen
   int 80h
   ret

writeZero: 
   mov eax, sys_write
   mov ebx, 1
   mov ecx, zero
   mov edx, zeroLen
   int 80h
   ret

