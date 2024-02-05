section .data
    numSetPrompt db "Please Enter a number to guess: ", 0
    lenSetPrompt equ $ - numSetPrompt
    numGuessPrompt db "Guess: ", 0
    lenGuessPrompt equ $ - numGuessPrompt
    sumPrompt db "The sum is: ", 0
    lenSumPrompt equ $ - sumPrompt
    newline db 0x0A
    lenNewLine equ 1

section .bss
    numToGuess resb 16
    numGuess resb 16
    numberSum resb 16

section .text
    global _start

%include "type_c.asm"

; Macros
%macro write_str 2
    mov eax, 4                  
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

%macro read_str_16 1
    mov eax, 3                  
    mov ebx, 0
    mov ecx, %1
    mov edx, 16
    int 0x80
%endmacro

_start:
    write_str numSetPrompt, lenSetPrompt
    read_str_16 numToGuess

    write_str numGuessPrompt, lenGuessPrompt
    read_str_16 numGuess

    ; Convert numGuess to integer
    lea esi, [numGuess]
    call ascii_to_int
    mov ebx, eax ; Store the converted numGuess in EBX

    ; Convert numToGuess to integer
    lea esi, [numToGuess]
    call ascii_to_int

    ; Add the two numbers
    add eax, ebx

; Convert the sum to ASCII
    call int_to_ascii

    ; Print the result
    lea ecx, [esi] ; Load the address of the first digit into ECX
    write_str ecx, 16 ; Modify this length based on your buffer size or calculate the length
    write_str newline, lenNewLine

    mov eax, 1              ; Exit system call
    int 0x80
