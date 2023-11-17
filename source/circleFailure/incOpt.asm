main:
        endbr64

        mov     rax, QWORD PTR .LC0[rip]
        mov     DWORD PTR ivector[rip+8], 1
        mov     DWORD PTR i[rip], 3
        mov     QWORD PTR ivector[rip], rax
        xor     eax, eax
        ret

i:
        .zero   4

ivector:
        .zero   12

.LC0:
        .long   1
        .long   1