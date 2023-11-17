        section .bss
ivector:
        resb    12
i:
        resd    1

        section .text
        global _start

_start:
        endbr64
        push    rbp
        mov     rbp, rsp

        mov     DWORD [rip+i], 0
        jmp     .L2

.L3:
        mov     eax, DWORD [rip+i]
        cdqe
        lea     rdx, [0+rax*4]
        lea     rax, [rip+ivector]
        mov     DWORD [rdx+rax], 1

        mov     eax, DWORD [rip+i]
        add     eax, 1
        mov     DWORD [rip+i], eax

.L2:
        mov     eax, DWORD [rip+i]
        cmp     eax, 2
        jle     .L3
        mov     eax, 0

        pop     rbp
        ret