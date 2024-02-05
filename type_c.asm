section .data

section .bss
    number resd 1            ; Reserve space for a 32-bit integer

section .text
global ascii_to_int
global int_to_ascii

    ; Convert integer to ASCII string
; Expects: EAX containing the integer
int_to_ascii:
    test eax, eax          ; Check if number is zero
    jz convert_zero        ; Handle zero separately

    mov ebx, 10            ; Set divisor to 10
    lea edi, [numberSum+15] ; Set EDI to the end of the buffer
    mov byte [edi], 0      ; Null-terminate the string

convert_ascii_loop:
    xor edx, edx           ; Clear EDX for division
    div ebx                ; Divide EAX by 10, result in EAX, remainder in EDX
    add dl, '0'            ; Convert remainder to ASCII
    dec edi                ; Move back in the buffer
    mov [edi], dl          ; Store the ASCII character
    test eax, eax          ; Check if EAX is zero
    jnz convert_ascii_loop       ; If not, continue loop

    ; Adjust the buffer pointer to the start of the number
    mov esi, edi
    jmp finish_conversion

convert_zero:
    mov byte [numberSum], '0' ; Store '0'
    mov esi, numberSum
    jmp finish_conversion

finish_conversion:
    ; esi reg now has the converted int
    ret

; Convert ASCII to integer
; Expects: ESI pointing to the ASCII string
; Returns: Number in EAX
ascii_to_int:
    xor eax, eax            ; Clear EAX (will hold the result)
    xor ecx, ecx            ; ECX as counter/index
convert_int_loop:
    movzx edx, byte [esi + ecx] ; Load next byte
    cmp edx, '0'
    jb convert_done         ; Break if less than '0'
    cmp edx, '9'
    ja convert_done         ; Break if greater than '9'
    sub edx, '0'            ; Convert from ASCII to int
    imul eax, eax, 10       ; Shift existing number left by one decimal place
    add eax, edx            ; Add new digit to EAX
    inc ecx                 ; Move to next character
    jmp convert_int_loop
convert_done:
    ret
