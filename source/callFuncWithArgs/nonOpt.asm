        section .text
        global _start

_dead_code:
        endbr64

        push    rbp
        mov     rbp, rsp

        mov     DWORD [rbp-20], edi
        mov     QWORD [rbp-32], rsi

        mov     eax, DWORD [rbp-20]
        mov     DWORD [rbp-4], eax

        nop

        pop     rbp
        ret

_start:
        lea     rax, [rel .LC3]
        mov     rsi, rax
        mov     edi, 1
        call    _dead_code

        mov     eax, 0
        ret