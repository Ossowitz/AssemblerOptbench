main:
        endbr64
        mov     eax, 10000
        mov     ecx, 10000
.L2:
        sub     eax, 1
        mov     edx, ecx
        sub     edx, eax
        test    eax, eax
        jg      .L2 #,
        mov     DWORD PTR k5[rip], eax
        mov     DWORD PTR j5[rip], edx
        lea     eax, [rax+rax*2]
        lea     ecx, [rdx+rdx*4]
        cdq
        idiv    ecx
        mov     DWORD PTR i5[rip], eax
        mov     eax, 0
        ret
i5:
        .zero   4
k5:
        .zero   4
j5:
        .zero   4