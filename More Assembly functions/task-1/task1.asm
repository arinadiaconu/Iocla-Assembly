section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list

sort:
	enter 0, 0

	; retin in ebx si in edx cei 2 parametri primiti de functie
	mov ebx, dword [ebp + 8]
	mov edx, dword [ebp + 12]
	; ecx retine minimul curent pentru fiecare 
	; parcurgere a vectorului incepand cu 2
	mov ecx, 2
	; esi este indicele fiecarei parcurgeri pentru cautarea 
	; valorii 1 prima data, iar apoi a valorii lui ecx
	mov esi, 0

	; prima data se parcurge vectorul pentru a gasi 
	; minimul si pentru a-l retine in eax - registrul 
	; ce retine valoarea de retur a functiei
find_first_element:
	cmp dword [edx], 1
	jne continue_loop
	
	; edi va retine mereu elementul curent al listei
	mov edi, edx
	; se retine adresa primului element al listei
	mov eax, edi
	jmp sort_my_array

	; se merge din 8 in 8 octeti, deoarece 4 octeti sunt
	; ocupati de 'int val', iar 4 octeti de adresa 'next'
continue_loop:
	inc esi
	add edx, 8
	; esi este incrementat pana la  
	; numarul de elemente din vector
	cmp esi, ebx
	jl find_first_element

	; dupa ce a fost retinut primul element al listei, 
	; se parcurge vectorul cautand de fiecare data minimul
	; curent dat de registrul ecx
sort_my_array:
	mov esi, 0
	mov edx, [ebp + 12]

find_current_min:
	; se compara fiecare element al vectorului cu valoarea din ecx
	cmp [edx], ecx
	jne next_address

	; elementul a fost gasit si este retinut in campul 'next'
	; al elementului anterior - cu adresa retinuta de edi
	mov [edi + 4], edx
	; se retine adresa elementului curent
	mov edi, edx
	; se mareste valoarea indicelui pentru a iesi din bucla 
	; odata ce elementul cautat a fost gasit
	mov esi, ebx

	; aceasta bucla trece la adresa urmatorului element in cazul
	; in care nu a fost gasita valoarea egala cu cea din ecx
next_address:
	add edx, 8
	inc esi
	cmp esi, ebx
	jl find_current_min

	; dupa gasirea fiecarui element egal cu valoarea din ecx, 
	; se incrementeaza ecx si se repeta procedeul pana cand
	; au fost parcurse toate elementele din vector
	inc ecx
	cmp ecx, ebx
	jle sort_my_array

	leave
	ret
