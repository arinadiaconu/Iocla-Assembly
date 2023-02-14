section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    xor eax, eax                ;reseteaza eax
    xor ecx, ecx                ;indicele din vectorul de ordine

urmatoarea_litera:
    xor edx, edx
    mov edx, [edi + 4 * ecx]    ;valoarea din vectorul de ordine
    
bucla:
    mov al, byte [esi + edx]  ;litera din haystack corespunzatoare
                              ;valorii din vectorul de ordine

    mov byte [ebx], al      ;salvarea literei in ciphertext
    inc ebx             ;se incrementeaza pozitia la fiecare pas
    
    ;la fiecare pas se salveaza toate literele corespunzatoare
    ;valorii din vectorul de ordine + deplasamentul len_cheie

    add edx, dword [len_cheie]
    cmp edx, [len_haystack]     ;se verifica sa nu depaseasca 
                                ;lungimea lui haystack
    jl bucla
    jmp conditie_finala

conditie_finala:
    inc ecx         ;se iau toate valorile din vectorul de ordine
    cmp ecx, [len_cheie]
    jl urmatoarea_litera

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY