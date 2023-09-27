	mov     eax, DWORD PTR k5[rip]
	mov     DWORD PTR j4[rip], eax
	cmp     eax, 6
	jle     .L4
	cmp     eax, DWORD PTR i4[rip]
	jg      .L8
.L8:
	mov     DWORD PTR i5[rip], 3