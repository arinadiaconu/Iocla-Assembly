section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    mov eax, 0                  ;indicele de parcurgere a cuvintelor
    add edi, ecx                ;pentru a parcurge key de la 
                                ;sfarsit catre inceput
    jmp conditie_finala

bucla:
    mov bl, [esi + eax]         ;se ia fiecare litera din plaintext
    dec edi
    xor bl, byte [edi]          ;operatia de xor cu litera din key
    mov byte [edx + eax], bl    ;caracterul obtinut se pune in
                                ;ciphertext la acelasi indice eax
    inc eax

conditie_finala:
    cmp eax, ecx                ;daca eax nu este egal cu
                                ;ecx se repeta bucla
    jl bucla

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY