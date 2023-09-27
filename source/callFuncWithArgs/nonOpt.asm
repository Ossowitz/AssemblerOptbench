dead_code:
        endbr64
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR -20[rbp], edi
        mov     QWORD PTR -32[rbp], rsi
        mov     eax, DWORD PTR -20[rbp]
        mov     DWORD PTR -4[rbp], eax
        nop
        pop     rbp
        ret

lea     rax, .LC3[rip]
        mov     rsi, rax
        mov     edi, 1
        call    dead_code
        mov     eax, 0