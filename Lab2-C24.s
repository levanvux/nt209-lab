.section .data               # Khai báo dữ liệu tĩnh
input_msg:      .ascii "Enter a string (5 characters): "
len_input_msg = . - input_msg

output_msg:     .ascii "Its reverse: "
len_output_msg = . - output_msg

.section .bss                # Khai báo vùng nhớ động
.lcomm string, 7             # Vùng nhớ chứa chuỗi nhập (5 ký tự + '\n' + '\0')
.lcomm output, 7             # Vùng nhớ chứa chuỗi đảo ngược (5 ký tự + '\n' + '\0')

.section .text
.globl _start

_start:
    # -------------------------------------
    # In lời nhắc nhập chuỗi
    # -------------------------------------
    movl $4, %eax             # syscall: write
    movl $1, %ebx             # file descriptor: stdout
    movl $input_msg, %ecx     # địa chỉ chuỗi cần in
    movl $len_input_msg, %edx # độ dài chuỗi
    int $0x80                 # gọi hệ thống

    # -------------------------------------
    # Đọc chuỗi từ bàn phím
    # -------------------------------------
    movl $3, %eax             # syscall: read
    movl $0, %ebx             # file descriptor: stdin
    movl $string, %ecx        # địa chỉ lưu chuỗi nhập
    movl $6, %edx             # đọc tối đa 6 byte (5 ký tự + '\n')
    int $0x80

    # -------------------------------------
    # Đảo ngược chuỗi
    # -------------------------------------
    movl $string, %esi        # %esi trỏ đến chuỗi gốc (input)
    movl $output, %edi        # %edi trỏ đến chuỗi kết quả (output)

    # Sao chép ký tự theo thứ tự ngược lại
    movb 0(%esi), %al         # Lấy ký tự thứ 1 của input
    movb %al, 4(%edi)         # Ghi vào vị trí thứ 5 của output

    movb 1(%esi), %al         # Lấy ký tự thứ 2 của input
    movb %al, 3(%edi)         # Ghi vào vị trí thứ 4 của output

    movb 2(%esi), %al         # Lấy ký tự thứ 3 của input
    movb %al, 2(%edi)         # Ghi vào vị trí thứ 3 của output

    movb 3(%esi), %al         # Lấy ký tự thứ 4 của input
    movb %al, 1(%edi)         # Ghi vào vị trí thứ 2 của output

    movb 4(%esi), %al         # Lấy ký tự thứ 5 của input
    movb %al, 0(%edi)         # Ghi vào vị trí thứ 1 của output

    # Thêm ký tự xuống dòng ở cuối chuỗi
    movb $'\n', 5(%edi)

    # -------------------------------------
    # In ra dòng "Its reverse: "
    # -------------------------------------
    movl $4, %eax             # syscall: write
    movl $1, %ebx             # stdout
    movl $output_msg, %ecx    # địa chỉ chuỗi "Its reverse: "
    movl $len_output_msg, %edx# độ dài chuỗi
    int $0x80                 # gọi hệ thống

    # -------------------------------------
    # In ra chuỗi kết quả đảo ngược
    # -------------------------------------
    movl $4, %eax             # syscall: write
    movl $1, %ebx             # stdout
    movl $output, %ecx        # địa chỉ chuỗi kết quả
    movl $6, %edx             # độ dài chuỗi (5 ký tự + '\n')
    int $0x80

    # -------------------------------------
    # Kết thúc chương trình
    # -------------------------------------
    movl $1, %eax             # syscall: exit
    xorl %ebx, %ebx           # exit code = 0
    int $0x80
