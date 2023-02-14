section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; variabilele sunt deja salvate in registrele
	; eax - char* str si edx - int str_length
	
	; registrul esi retine numarul de paranteze deschise
	push 0
	pop esi
	; registrul edi retine numarul de paranteze inchise
	push 0
	pop edi
	; registrul ecx retine indicele cu care 
	; parcurg sirul de caractere
	push 0
	pop ecx

	; loop-ul are ca scop retinerea numarului de paranteze
	; deschise si inchise, dar si verificarea daca ordinea
	; este cea corecta; de exemplu ca nu apar situatii in
	; care este acelasi numar de paranteze inchise si deschise,
	; dar asezate invers ( de ex: "())(" )

verify_string:
	; ebx retine fiecare caracter din sir
	push dword [eax + ecx]
	pop ebx

	; daca acel caracter este paranteza deschisa, se 
	; incrementeaza variabila din esi; respectiv edi pentru
	; cazul in care este o paranteza inchisa
	cmp bl, '('
	je increment_esi
	jmp increment_edi

increment_esi:
	inc esi
	jmp exit_condition

increment_edi:
	inc edi
	jmp exit_condition

	; aceasta conditie verifica daca numarul parantezelor 
	; deschise este mereu mai mare decat al celor inchise.
	; in caz contrar, se returneza direct '0'
exit_condition:
	cmp edi, esi
	jg stop

	; daca numarul de paranteze respecta regula precizata 
	; anterior, se trece la urmatorul caracter pana cand
	; sunt parcurse toate caracterele din sirul primit
	inc ecx
	cmp ecx, edx
	jl verify_string

	; in momentul iesirii din loop mai este o conditie de 
	; verificat, si anume ca niciuna dintre variabilele ce
	; retin numarul de paranteze sa nu depaseasca jumatatea
	; lungimii sirului

	; retin lungimea sirului in eax, ce este si deimpartitul
	push edx
	pop eax
	; retin in ebx impartitorul - 2
	push 2
	pop ebx
	div bl
	
	; dupa ce am realizat impartirea lungimii sirului la 2, se 
	; compara fiecare din cele 2 variabile cu rezultatul obtinut
	cmp esi, eax
	jg stop

	cmp edi, eax
	jg stop

	; daca sunt respectate toate conditiile, se returneaza '1'
	push 1
	pop eax
	jmp the_end

	; se intoarce rezultatul '0'
stop:
	push 0
	pop eax

the_end:

	ret
