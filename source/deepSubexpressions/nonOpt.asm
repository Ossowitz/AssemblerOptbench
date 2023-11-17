L9:
    mov     eax, DWORD [rip+i]
    cmp     eax, 9
    jg      L11

    mov     edx, DWORD [rip+i5]
    mov     eax, DWORD [rip+i2]
    add     eax, edx
    mov     DWORD [rip+j5], eax
    jmp     L12

L11:
    mov     edx, DWORD [rip+i5]
    mov     eax, DWORD [rip+i2]
    add     eax, edx
    mov     DWORD [rip+k5], eax

L12:
    mov     eax, 0