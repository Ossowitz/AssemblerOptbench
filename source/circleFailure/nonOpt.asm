ivector:
        .zero   12
i:
        .zero   4
main:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
; start(1) -> for (i = 0; i < 3; i++)
        mov     DWORD PTR i[rip], 0       # i,
        jmp     .L2       #
; end(1) -> for (i = 0; i < 3; i++)
.L3:
; start -> ivector[i] = 1;
        mov     eax, DWORD PTR i[rip]     # i.0_1, i
        cdqe
        lea     rdx, 0[0+rax*4]   # tmp89,
        lea     rax, ivector[rip] # tmp90,
        mov     DWORD PTR [rdx+rax], 1    # ivector[i.0_1],
; end -> ivector[i] = 1;

; start(2) -> for (i = 0; i < 3; i++)
        mov     eax, DWORD PTR i[rip]     # i.1_2, i
        add     eax, 1    # _3,
        mov     DWORD PTR i[rip], eax     # i, _3
; end(2) -> for (i = 0; i < 3; i++)
.L2:
; start(3) -> for (i = 0; i < 3; i++)
        mov     eax, DWORD PTR i[rip]     # i.2_4, i
        cmp     eax, 2    # i.2_4,
        jle     .L3       #,
        mov     eax, 0    # _8,
; end(3) -> for (i = 0; i < 3; i++)
        pop     rbp       #
        ret