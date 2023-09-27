L9:
        mov     eax, DWORD PTR i[rip]
        cmp     eax, 9
        jg      .L11
        mov     edx, DWORD PTR i5[rip]
        mov     eax, DWORD PTR i2[rip]
        add     eax, edx
        mov     DWORD PTR j5[rip], eax
        jmp     .L12
.L11:
        mov     edx, DWORD PTR i5[rip]
        mov     eax, DWORD PTR i2[rip]
        add     eax, edx
        mov     DWORD PTR k5[rip], eax
.L12:
        mov     eax, 0