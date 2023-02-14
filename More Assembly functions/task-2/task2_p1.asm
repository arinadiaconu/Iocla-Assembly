section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple for 2 numbers, a and b
cmmmc:
	; variabilele sunt deja salvate in registrele
	; eax - int a si edx - int b

	; se salveaza cate o copie a variabilelor primite
	; ca parametri pentru a putea calcula cel
	; mai mare divizor comun al celor 2 numere
	push eax
	pop esi					; int a
	push edx
	pop edi 				; int b

	; am implementat algoritmul de calculare a celui mai mare
	; divizor comun prin scaderi repetate
greatest_common_divisor:
	; se verifica care numar este mai mare
	cmp esi, edi
	; cazul in care primul numar este mai mare
	jg decrement_esi
	; cazul in care cel de-al doilea numar este mai mare
	jmp decrement_edi

	; se scade din primul cel de-al doilea numar
decrement_esi:
	sub esi, edi
	jmp exit_condition

	; se scade din cel de-al doilea primul numar
decrement_edi:
	sub edi, esi
	jmp exit_condition

	; conditia de iesire din bucla ce executa scaderile 
	; repetate este cele doua elemente sa devina egale
exit_condition:
	cmp esi, edi
	jne greatest_common_divisor

	; la iesirea din bucla ce a calculat cel mai mare 
	; divizor comun, registrul esi contine rezultatul

	; se inmulteste eax cu edx - adica a cu b
	mul edx

	; se imparte rezultatul din eax la cmmdc-ul calculat anterior
	div esi

	ret
