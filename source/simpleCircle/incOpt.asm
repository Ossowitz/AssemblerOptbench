main:
        endbr64
        mov     eax, DWORD PTR k5[rip]    # k5_lsm.7, k5
        mov     edx, 1    # tmp103,
        test    eax, eax        # k5_lsm.7
        cmovg   edx, eax      # k5_lsm.7,, _13
        sub     eax, edx  # _31, _13
        lea     ecx, [rdx+rdx*4]  # tmp99,
        mov     DWORD PTR j5[rip], edx    # j5, _13
        mov     DWORD PTR k5[rip], eax    # k5, _31
        lea     eax, [rax+rax*2]  # tmp96,
        cdq
        idiv    ecx     # tmp99
        mov     DWORD PTR i5[rip], eax    # i5, tmp100
        xor     eax, eax  #
        ret
i5:
        .zero   4
k5:
        .zero   4
j5:
        .zero   4