section .data
    prompt db "Enter: ", 0
    
section .bss
    buffer resb 16

section .text
    global _start

_start:
    mov eax, 3          
    mov ebx, 0          
    mov ecx, buffer     
    mov edx, 16         
    int 0x80            

    mov esi, buffer     
    call parse_num      
    mov edi, eax        

    lodsb               
    mov bl, al          

    call parse_num      
    mov edx, eax        

    cmp bl, '+'
    je do_add
    cmp bl, '-'
    je do_sub
    jmp exit

do_add:
    add edi, edx
    jmp print_res

do_sub:
    sub edi, edx
    jmp print_res

parse_num:
    xor eax, eax
    xor ecx, ecx
next_digit:
    lodsb
    sub al, '0'
    jb done
    imul eax, ecx, 10
    add eax, ecx
    jmp next_digit
done:
    ret

print_res:
    mov eax, edi
    call display_out

exit:
    mov eax, 1          
    xor ebx, ebx        
    int 0x80            

display_out:
    ret
