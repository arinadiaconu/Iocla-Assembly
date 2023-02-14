section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; variabilele sunt deja salvate in registrele
	; eax - char* str si edx - int str_length
	
	push 0
	pop esi
	push 0
	pop edi

	push 0
	pop ecx

label:
	push dword [eax + ecx]
	pop ebx

	cmp bl, '('
	je increment_esi
	jmp increment_edi

increment_esi:
	inc esi
	jmp exit_condition

increment_edi:
	inc edi
	jmp exit_condition

exit_condition:
	cmp edi, esi
	jg stop

	inc ecx
	cmp ecx, edx
	jl label

	push edx
	pop eax
	push 2
	pop ebx
	div bl

	cmp esi, eax
	jg stop

	cmp edi, eax
	jg stop

	push 1
	pop eax
	jmp the_end

stop:
	push 0
	pop eax

the_end:

	ret
