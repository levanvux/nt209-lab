# bản quyền của anh Nguyễn Đức Anh - MSSV 2252xx75


.section .bss
    .lcomm input, 3          # Vùng nhớ cho chuỗi nhập vào 
    .lcomm output, 12        # Vùng nhớ tạm để chuyển số thành chuỗi để in ra

.section .data
msg:       .asciz "Nhap so nguyen 2 chu so: "   # Thông báo nhập
evenMsg:   .asciz "1\n"                         # In ra nếu chẵn
oddMsg:    .asciz "0\n"                         # In ra nếu lẻ
newline:   .asciz "\n"                          # Xuống dòng

.section .text
.globl _start
_start:
    movl $4, %eax            # syscall: sys_write = 4
    movl $1, %ebx            # tham số 1: stdout (fd = 1)
    movl $msg, %ecx          # tham số 2: địa chỉ chuỗi msg
    movl $26, %edx           # tham số 3: độ dài chuỗi msg
    int $0x80                # gọi kernel

    movl $3, %eax            # syscall: sys_read = 3
    movl $0, %ebx            # tham số 1: stdin (fd = 0)
    movl $input, %ecx        # tham số 2: buffer lưu dữ liệu
    movl $3, %edx            # tham số 3: đọc tối đa 3 byte.
    int $0x80

    # input[0] = ký tự hàng chục, input[1] = ký tự hàng đơn vị

    movzbl input, %eax       # nạp input[0] (hàng chục) vào EAX, mở rộng zero
    subl $'0', %eax          # trừ '0' để chuyển từ ký tự → số
    imull $10, %eax, %eax    # nhân với 10 để thành giá trị hàng chục

    movzbl input+1, %ebx     # nạp input[1] (hàng đơn vị) vào EBX
    subl $'0', %ebx          # trừ '0' để ra số
    addl %ebx, %eax          # EAX = số nguyên x (hàng chục*10 + hàng đơn vị)

    movl %eax, %esi          # lưu x vào ESI để dùng sau
    testl $1, %eax            # kiểm tra bit cuối cùng
    jz print_even             # nếu bit = 0 → số chẵn → nhảy sang print_even

print_odd:
    # In "0\n"
    movl $4, %eax
    movl $1, %ebx
    movl $oddMsg, %ecx
    movl $2, %edx             # chuỗi "0\n" dài 2 byte
    int $0x80
    jmp print_nums            # sau đó in số x và x+1

print_even:
    # In "1\n"
    movl $4, %eax
    movl $1, %ebx
    movl $evenMsg, %ecx
    movl $2, %edx             # chuỗi "1\n" dài 2 byte
    int $0x80

print_nums:
    movl %esi, %eax           # EAX = x
    movl $output+11, %edi     # trỏ vào cuối buffer output
    movb $0, (%edi)           # đặt null terminator
    movl $10, %ebx            # chuẩn bị chia cho 10 (chuyển sang chuỗi thập phân)

itoa_loop1:                   # vòng lặp chuyển số x thành chuỗi
    xorl %edx, %edx           # xoá EDX (chuẩn bị lấy số dư)
    divl %ebx                 # EAX = EAX / 10, EDX = EAX % 10
    addb $'0', %dl            # chuyển số dư (0–9) thành ký tự ASCII
    decl %edi                 # lùi con trỏ 1 byte
    movb %dl, (%edi)          # lưu ký tự vào buffer
    testl %eax, %eax          # nếu EAX còn > 0 thì tiếp tục lặp
    jnz itoa_loop1

    # Gọi sys_write để in chuỗi số x
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx           # ECX = địa chỉ bắt đầu chuỗi
    movl $output+11, %edx
    subl %edi, %edx           # EDX = độ dài chuỗi
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    movl %esi, %eax           # EAX = x
    incl %eax                 # EAX = x + 1
    movl $output+11, %edi     # reset con trỏ buffer
    movb $0, (%edi)
    movl $10, %ebx

itoa_loop2:                   # vòng lặp chuyển (x+1) thành chuỗi
    xorl %edx, %edx
    divl %ebx
    addb $'0', %dl
    decl %edi
    movb %dl, (%edi)
    testl %eax, %eax
    jnz itoa_loop2

    # In chuỗi (x+1)
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $output+11, %edx
    subl %edi, %edx
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

exit:
    movl $1, %eax             
    xorl %ebx, %ebx          
    int $0x80
