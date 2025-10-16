# bản quyền của anh Nguyễn Đức Anh - MSSV 2252xx75


.section .data
rs:   .string "Nt209"        # Định nghĩa chuỗi rs = "Nt209\0"
                             # Kết thúc chuỗi có ký tự null (0)
len:  .int . - rs - 1        # Tính độ dài chuỗi rs
                             # '.' là vị trí hiện tại (sau khi định nghĩa chuỗi)
                             # rs là địa chỉ bắt đầu chuỗi
                             # . - rs = số byte từ rs đến hiện tại
                             # trừ đi 1 để bỏ ký tự null '\0'
                             # => len = 5 (chuỗi "Nt209" có 5 ký tự)

out:  .byte 0                # Khai báo 1 byte để lưu ký tự cần in ra

.section .text
.globl _start
_start:
    movl len, %eax           # nạp giá trị len vào thanh ghi EAX
    addl $'0', %eax          # EAX = EAX + mã ASCII của '0' (48)
                             # Nếu len = 5 → EAX = 53 (mã ASCII của ký tự '5')
                             # Lưu ý: Cách này chỉ đúng với số 0–9

    movb %al, out            # Lấy 1 byte thấp nhất của EAX (%al)
                             # Lưu vào biến out
                             # out = '5'

    movl $4, %eax            # syscall số 4 = sys_write
    movl $1, %ebx            # file descriptor = 1 (stdout)
    movl $out, %ecx          # địa chỉ buffer = &out
    movl $1, %edx            # số byte cần in = 1
    int $0x80                # 

    movl $1, %eax            
    xorl %ebx, %ebx          
    int $0x80
