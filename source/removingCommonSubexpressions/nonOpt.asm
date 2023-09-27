        mov     edx, DWORD PTR h3[rip]
        mov     eax, DWORD PTR k3[rip]
        add     eax, edx
        test    eax, eax
        js      .L13
        mov     edx, DWORD PTR h3[rip]
        mov     eax, DWORD PTR k3[rip]
        add     eax, edx
        cmp     eax, 5
        jle     .L14
.L13:
        lea     rax, .LC2[rip]
        mov     rdi, rax
        call    puts@PLT
        jmp     .L15
.L14:
        mov     edx, DWORD PTR h3[rip]
        mov     eax, DWORD PTR k3[rip]
        add     eax, edx
        mov     esi, DWORD PTR i3[rip]
        cdq
        idiv    esi
        mov     DWORD PTR m3[rip], eax
        mov     edx, DWORD PTR h3[rip]
        mov     eax, DWORD PTR k3[rip]
        add     edx, eax
        mov     eax, DWORD PTR i3[rip]
        add     eax, edx
        mov     DWORD PTR g3[rip], eax
.L15:
        mov     eax, 0