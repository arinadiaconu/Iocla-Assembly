; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

bucla:
    ;vectorul dates va fi parcurs in sens invers, incepand 
    ;de la indicele len - 1
    
    dec edx

    ;in eax se va retine initial anul curent, dupa care se
    ;va construi varsta scazand anul dat

    mov eax, [esi + my_date.year]
    cmp eax, [edi + my_date_size * edx + my_date.year]
    jnl compara_luni
    jmp data_invalida

compara_luni:
    ;se construieste varsta
    sub eax, [edi + my_date_size * edx + my_date.year]

    ;daca anul curent este mai mare decat cel dat, se
    ;compara lunile, pentru a vedea daca varsta este
    ;implinita sau nu la data curenta

    xor ebx, ebx
    mov bx, word [esi + my_date.month]
    cmp bx, word [edi + my_date_size * edx + my_date.month]
    
    jl data             ;daca varsta nu este implinita
    je compara_zile     ;lunile sunt egale
    jmp data_finala

data:
    ;conditia unei date invalide
    cmp eax, 0
    je data_finala

    ;varsta este cu un an mai mica
    sub eax, 1
    jmp data_finala

compara_zile:
    xor ebx, ebx
    mov bx, word [esi + my_date.day]
    cmp bx, word [edi + my_date_size * edx + my_date.day]
    jl data             ;daca varsta nu este implinita
    jmp data_finala

data_invalida:
    ;cand anul dat este mai mare decat cel din data curenta
    xor eax, eax
    jmp data_finala

data_finala:
    mov [ecx + 4 * edx], eax 
    
conditie_finala:    
    cmp edx, 0
    jg bucla

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
