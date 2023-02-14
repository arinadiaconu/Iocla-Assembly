;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .data
    tag             DD 0    ;valoare globala pentru tagul adresei
    cache_adr       DD 0    ;adresa lui cache
    offset          DD 0    ;offsetul adresei
    reg             DD 0    ;adresa registrului

section .text
    global load
    extern printf

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

    ;se elibereaza 2 registre si se salveaza 
    ;continutul lor in variabile globale
    mov [cache_adr], ecx    
    mov [reg], eax

    ;se calculeaza tag-ul pentru adresa de la care
    ;se vor obtine datele din cache

    mov eax, edx
    shr eax, OFFSET_BITS    ;shiftare la dreapta cu 3 biti
    mov [tag], eax          ;se salveaza rezultatul intr-o 
                            ;variabila globala

    ;se calculeaza offset-ul de la adresa data

    mov eax, edx
    shl eax, TAG_BITS       ;shiftare la stanga cu 29 biti
    shr eax, TAG_BITS       ;shiftare la dreapta cu 29 biti
    mov [offset], eax       ;se salveaza rezultatul

    ;se cauta tagul in vectorul de taguri

    mov ecx, CACHE_LINES    ;dimensiunea vectorului
    xor edx, edx            ;reseteaza edx

itereaza_tags:
    mov eax, [tag]
    mov esi, [ebx + edx]
    cmp eax, esi
    je  adauga_in_registru_direct       ;daca este gasit tagul

    inc edx
    cmp edx, ecx
    jl  itereaza_tags

    ;daca este iterat tot vectorul si nu este gasit tagul
    ;se inlocuieste linia din cache de la linia to_replace

    mov eax, [tag]
    shl eax, OFFSET_BITS        ;shiftare la stanga cu 3 biti
    mov esi, [cache_adr]
    xor edx, edx

scrie_in_memorie:
    mov cl, [eax]               ;valoarea de la adresa
    mov [esi + 8 * edi], cl     ;se scrie in matrice valoarea

    inc esi
    inc eax
    inc edx
    cmp edx, CACHE_LINE_SIZE    ;se scriu fix 8 valori in matrice
    jl scrie_in_memorie

    ;scrie in registru octetul cache[to_replace][offset]

    mov esi, [cache_adr]
    mov eax, [reg]
    add esi, [offset]              ;se calculeaza adresa din cache
    mov cl, byte [esi + 8 * edi]
    mov [eax], cl                  ;se scrie in registru

    ;modifica valoarea lui tags[to_replace]

    mov eax, [tag]
    mov [ebx + edi], eax
    jmp stop                    ;se incheie executia programului

adauga_in_registru_direct:
    mov eax, [cache_adr]
    mov esi, [reg]
    add eax, [offset]               ;se calculeaza adresa din cache
    mov bl, byte [eax + 8 * edx]
    mov byte [esi], bl              ;se scrie in registru

stop:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


