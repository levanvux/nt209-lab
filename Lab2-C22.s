.section .data           # khai báo dữ liệu tĩnh
input_msg: .ascii "Nhap SBD (6 ky tu): "    
len_input_msg = . - input_msg                
output_msg: .ascii "MSSV: "
len_output_msg = . - output_msg
output_msg2: .ascii "Nien khoa "
len_output_msg2 = . - output_msg2
output_msg3: .ascii ", sinh vien nam "
len_output_msg3 = . - output_msg3
newline: .ascii "\n"

.section .bss            # vùng nhớ động
.lcomm sbd, 8            # chỗ lưu input sbd (6 ký tự + '\n' + '\0')
.lcomm mssv, 10          # chỗ lưu output mssv (8 ký tự + '\n' + '\0')
.lcomm nienkhoa, 5       # chỗ lưu output niên khoá 
.lcomm svnam, 5          # chỗ lưu output sinh viên năm mấy

.section .text           # mã lệnh thực thi
.globl _start             
_start:
    # in prompt nhập SBD
	movl $4, %eax             # syscall write
	movl $1, %ebx             # stdout 
	movl $input_msg, %ecx     # địa chỉ chuỗi cần in
	movl $len_input_msg, %edx # độ dài chuỗi
	int $0x80                 # gọi hệ thống 
	
	# đọc sbd từ bàn phím
	movl $3, %eax             # syscall read
	movl $0, %ebx             # stdin
	movl $sbd, %ecx           # nơi lưu input
	movl $8, %edx             # đọc tối đa 8 byte
	int $0x80
	
	# xử lý sbd để tạo mssv
	movl $sbd, %esi # địa chỉ sbd 
	movl $mssv, %edi # địa chỉ mssv
	
	movb 0(%esi), %al               # lấy ký tự 1 của sbd
    movb %al, 0(%edi)               # gán vào ký tự 1 của mssv

    movb 1(%esi), %al               # lấy ký tự 2 của sbd
    movb %al, 1(%edi)               # gán vào ký tự 2 của mssv

    movb $'5', 2(%edi)              # gán ký tự '5' vào vị trí 3 của mssv
    movb $'2', 3(%edi)              # gán ký tự '2' vào vị trí 4 của mssv

    movb 2(%esi), %al               # lấy ký tự 3 của sbd
    movb %al, 4(%edi)               # gán vào ký tự 5 của mssv

    movb 3(%esi), %al               # lấy ký tự 4 của sbd
    movb %al, 5(%edi)               # gán vào ký tự 6 của mssv

    movb 4(%esi), %al               # lấy ký tự 5 của sbd
    movb %al, 6(%edi)               # gán vào ký tự 7 của mssv

    movb 5(%esi), %al               # lấy ký tự 6 của sbd
    movb %al, 7(%edi)               # gán vào ký tự 8 của mssv

    movb $'\n', 8(%edi)             # thêm ký tự xuống dòng
	
	# in ra mssv
	movl $4, %eax
	movl $1, %ebx
	movl $output_msg, %ecx       
	movl $len_output_msg, %edx  
	int $0x80
	
	movl $4, %eax
	movl $1, %ebx
	movl $mssv, %ecx          # địa chỉ mssv 
	movl $9, %edx             # độ dài (8 ký tự + '\n')
	int $0x80
	
	# in ra "Nien khoa "
	movl $4, %eax
	movl $1, %ebx
	movl $output_msg2, %ecx      
	movl $len_output_msg2, %edx 
	int $0x80 
	
	# tìm niên khoá
	movl $mssv, %esi
	
	movb 0(%esi), %al         # ký tự đầu mssv
	subb $'0', %al            # chuyển sang số
	
	movb 1(%esi), %bl         # ký tự 2 mssv
	subb $'0', %bl            # chuyển sang số
	
	# tìm năm nhập học
	movzbl %al, %eax          # zero extend al -> eax
    imull $10, %eax
    movzbl %bl, %ebx          # zero extend bl -> ebx
    addl %ebx, %eax           # eax = năm nhập học
	
	# niên khóa = năm nhập học - 5
	movl %eax, %ebx
	subl $5, %ebx
	
	# in số niên khoá
	movl %ebx, %eax         # copy %ebx vào %eax để chia
	movl $10, %ecx
	xorl %edx, %edx         # xóa %edx để chuẩn bị chia
	divl %ecx               # %eax / 10, kết quả: %eax = hàng chục, %edx = hàng đơn vị

	# chuyển sang ký tự ASCII đúng cho %al và %dl
	addb $'0', %al   # %al là phần thấp của %eax
	addb $'0', %dl

	movl $nienkhoa, %esi
	movb %al, 0(%esi)    # lưu hàng chục
	movb %dl, 1(%esi)    # lưu hàng đơn vị
	
	# In 2 ký tự số
    movl $4, %eax
    movl $1, %ebx
    movl $nienkhoa, %ecx
    movl $2, %edx
    int $0x80
	
	# in ra ", sinh vien nam "
	movl $4, %eax
	movl $1, %ebx
	movl $output_msg3, %ecx      
	movl $len_output_msg3, %edx 
	int $0x80
	
	# tìm niên khoá
	movl $mssv, %esi
	
	movb 0(%esi), %al         # ký tự đầu mssv
	subb $'0', %al            # chuyển sang số
	
	movb 1(%esi), %bl         # ký tự 2 mssv
	subb $'0', %bl            # chuyển sang số
	
	# tìm năm nhập học
	movzbl %al, %eax          # zero extend al -> eax
    imull $10, %eax
    movzbl %bl, %ebx          # zero extend bl -> ebx
    addl %ebx, %eax           # eax = năm nhập học
	
	# sinh viên năm mấy = 26 - năm nhập học
	movl $26, %ebx
	subl %eax, %ebx
	
	movl $svnam, %esi      # địa chỉ svnam
	
	# chuyển thành ký tự
	addb $'0', %bl
	movb %bl, 0(%esi) 
    
    # in năm sinh viên
	movl $4, %eax
    movl $1, %ebx
    movl $svnam, %ecx
    movl $1, %edx
    int $0x80
	
	# in '\n'
	movl $4, %eax
	movl $1, %ebx
	movl $newline, %ecx
	movl $1, %edx
	int $0x80
	
	movl $1, %eax             # syscall exit
	xorl %ebx, %ebx           # exit code = 0
	int $0x80
