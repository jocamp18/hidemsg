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
