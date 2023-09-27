        mov     ecx, DWORD PTR h3[rip]    # h3.36_25, h3
        lea     edx, 1[rcx]       # _26,
        cmp     edx, 5    # _26,
        ja      .L10        #,
        movsx   rax, edx      # _26, _26
        sar     edx, 31   # tmp119,
        add     ecx, 4    # tmp121,
        imul    rax, rax, 1431655766    # tmp117, _26,
        mov     DWORD PTR g3[rip], ecx    # g3, tmp121
        shr     rax, 32   # tmp118,
        sub     eax, edx  # tmp120, tmp119
        mov     DWORD PTR m3[rip], eax    # m3, tmp120