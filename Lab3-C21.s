.section .data
msg_input: .ascii "Enter a string (10 chars): "
len_msg_input = . - msg_input

msg_output: .ascii "Number of words: "
len_msg_output = . - msg_output

newline: .ascii "\n"

.section .bss
.lcomm str, 12        # chứa 10 ký tự + '\n' + '\0'
.lcomm count, 4       # đếm số từ 

.section .text
.globl _start
_start:
    # in prompt
    movl $4, %eax
    movl $1, %ebx
    movl $msg_input, %ecx
    movl $len_msg_input, %edx
    int $0x80

    # nhập chuỗi 10 ký tự
    movl $3, %eax
    movl $0, %ebx
    movl $str, %ecx
    movl $12, %edx
    int $0x80

    # khởi tạo
    movl $0, count     # count = 0
    movl $str, %esi    # ESI trỏ đến chuỗi
    movl $0, %ecx      # i = 0
    movl $1, %edx      # flag = 1 
    
    # flag = 1: đang ngoài từ (ví dụ: gặp dấu cách)
    # flag = 0: đang trong từ

count_loop:
    movb (%esi, %ecx, 1), %al  # lấy 1 ký tự str[i]
    cmpb $'\n', %al            # nếu gặp newline -> kết thúc
    je done_count

    cmpb $' ', %al             # nếu gặp space
    je space_found

    # nếu gặp ký tự khác space, kiểm tra flag
    cmpb $1, %dl               # kiểm tra nếu flag = 1
    jne cont_loop              # nếu không phải, tiếp tục vòng lặp
    
    addl $1, count             # tăng count
    movl $0, %edx              # flag = 0 
    jmp cont_loop

space_found:
    movl $1, %edx      # flag = 1 

cont_loop:
    incl %ecx          # i++
    jmp count_loop

done_count:
    # in "Number of words: "
    movl $4, %eax
    movl $1, %ebx
    movl $msg_output, %ecx
    movl $len_msg_output, %edx
    int $0x80

    # chuyển count sang ASCII
    movl count, %eax
    addl $'0', %eax
    movb %al, count

    # in ra count
    movl $4, %eax
    movl $1, %ebx
    movl $count, %ecx
    movl $1, %edx
    int $0x80

    # in newline
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
