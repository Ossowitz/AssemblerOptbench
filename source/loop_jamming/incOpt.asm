loop_jamming:
        endbr64
        mov     DWORD PTR i[rip], 5       # i,
        mov     eax, DWORD PTR j5[rip]    # j5, j5
        lea     eax, [rdi+rax*4]  # _3,
        mov     DWORD PTR k5[rip], eax    # k5, _3
        imul    eax, edi        # tmp90, x
        sal     eax, 2    # tmp91,
        mov     DWORD PTR i5[rip], eax    # i5, tmp91
        ret
mov     edi, 7    #,
        call    loop_jamming