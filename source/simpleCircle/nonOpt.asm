j5:
        .zero   4
k5:
        .zero   4
i5:
        .zero   4
main:
        endbr64
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR j5[rip], 0
        mov     DWORD PTR k5[rip], 10000
.L2:
        mov     eax, DWORD PTR k5[rip]
        sub     eax, 1
        mov     DWORD PTR k5[rip], eax
        mov     eax, DWORD PTR j5[rip]
        add     eax, 1
        mov     DWORD PTR j5[rip], eax
        mov     edx, DWORD PTR k5[rip]
        mov     eax, edx
        add     eax, eax
        lea     ecx, [rax+rdx]
        mov     edx, DWORD PTR j5[rip]
        mov     eax, edx
        sal     eax, 2
        lea     esi, [rdx+rax]
        mov     eax, ecx
        cdq
        idiv    esi
        mov     DWORD PTR i5[rip], eax
        mov     eax, DWORD PTR k5[rip]
        test    eax, eax
        jg      .L2
        mov     eax, 0
        pop     rbp
        ret