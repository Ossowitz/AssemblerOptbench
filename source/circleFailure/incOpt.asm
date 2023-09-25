main:
        endbr64
; start(1) ->     for (i = 0; i < 3; i++) ivector[i] = 1;
        movabs  rax, 4294967297     # tmp88,
        mov     DWORD PTR ivector[rip+8], 1       # ivector[2],
        mov     QWORD PTR ivector[rip], rax       # MEM <...> [(int *)&ivector], tmp88
; end(1) -> for (i = 0; i < 3; i++)
        xor     eax, eax  #
        mov     DWORD PTR i[rip], 3       # i,
        ret
i:
        .zero   4
ivector:
        .zero   12
