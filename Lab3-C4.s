.section .data
ask_msg:    .string "Nhap nam sinh (4 ky tu): "
ask_len = . - ask_msg

msg1:   .string "Chua vao UIT\n"
msg1_len = . - msg1
msg2:   .string "Dang hoc tai UIT\n"
msg2_len = . - msg2
msg3:   .string "Da tot nghiep UIT\n"
msg3_len = . - msg3

msg_tuoi:   .string "Tuoi: "
msg_tuoi_len = . - msg_tuoi
msg_namTN:  .string "Nam da TN: "
msg_namTN_len = . - msg_namTN
msg_namVao: .string "Nam du kien vao UIT: "
msg_namVao_len = . - msg_namVao
msg_namDuKien: .string "Nam du kien TN: "
msg_namDuKien_len = . - msg_namDuKien

newline:    .string "\n"
newline_len = . - newline

year_now:   .long 2025         # Năm hiện tại
input:      .space 5           # Vùng nhớ để nhập chuỗi năm sinh
buffer:     .space 5           # Vùng nhớ để chuyển số thành chuỗi khi in ra

.section .bss
# BIẾN LƯU GIÁ TRỊ TRUNG GIAN 
.lcomm num, 4       # Lưu năm sinh
.lcomm tuoi, 4      # Lưu tuổi
.lcomm namTN, 4     # Lưu năm tốt nghiệp 
.lcomm namVao, 4    # Lưu năm vào UIT

.section .text
.global _start

_start:
	# in ra "Nhap nam sinh (4 ky tu): "
    movl $4, %eax            
    movl $1, %ebx             
    movl $ask_msg, %ecx      
    movl $ask_len, %edx       
    int $0x80

	# nhập năm sinh
    movl $3, %eax             
    movl $0, %ebx             
    movl $input, %ecx         
    movl $5, %edx             
    int $0x80

    movl $0, %ebx             # ebx = 0 
    movl $input, %esi         # esi = con trỏ tới chuỗi nhập
    movl $4, %ecx             # cần đọc 4 ký tự
convert_loop:
    movzbl (%esi), %eax       # lấy 1 ký tự (ASCII)
    subb $'0', %al            # trừ '0' để ra số thật
    imull $10, %ebx           # nhân kết quả cũ với 10
    addl %eax, %ebx           # cộng chữ số mới vào
    incl %esi                 # sang ký tự tiếp theo
    loop convert_loop
    movl %ebx, num            # lưu kết quả vào biến num

    # TÍNH TUỔI
    movl year_now, %eax
    subl num, %eax            # tuổi = 2025 - năm sinh
    movl %eax, tuoi

    # SO SÁNH TUỔI 
    movl tuoi, %eax
    cmpl $18, %eax
    jl younger                # nếu <18 -> chưa vào UIT
    cmpl $22, %eax
    jg older                  # nếu >22 -> đã tốt nghiệp

studying:
    # Đang học tại UIT 
    movl $4, %eax
    movl $1, %ebx
    movl $msg2, %ecx
    movl $msg2_len, %edx
    int $0x80
    jmp print_age_and_future

younger:
    # Chưa vào UIT 
    movl $4, %eax
    movl $1, %ebx
    movl $msg1, %ecx
    movl $msg1_len, %edx
    int $0x80
    jmp print_age_and_future

older:
    # Đã tốt nghiệp
    movl $4, %eax
    movl $1, %ebx
    movl $msg3, %ecx
    movl $msg3_len, %edx
    int $0x80

print_age_and_future:
    # In "Tuoi: "
    movl $4, %eax
    movl $1, %ebx
    movl $msg_tuoi, %ecx
    movl $msg_tuoi_len, %edx
    int $0x80

    # In số tuổi (chuyển số sang chuỗi)
    movl tuoi, %eax
    movl $buffer+4, %edi      # con trỏ đến cuối buffer
    movb $0, (%edi)           # kết thúc chuỗi = null
print_age_loop:
    decl %edi                 # lùi về 1 byte
    movl $0, %edx
    movl $10, %ecx
    divl %ecx                 # chia 10 -> quotient trong eax, remainder trong edx
    addb $'0', %dl            # chuyển remainder sang ký tự
    movb %dl, (%edi)          # lưu vào buffer
    testl %eax, %eax
    jnz print_age_loop        # nếu chưa hết thì lặp tiếp

    # In chuỗi tuổi ra màn hình
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $buffer+4, %edx
    subl %edi, %edx           # độ dài = end của buffer - start của buffer
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $newline_len, %edx
    int $0x80

    # IN NĂM DỰ KIẾN HOẶC NĂM ĐÃ TỐT NGHIỆP
    movl tuoi, %eax
    cmpl $18, %eax
    jl future_vao             # nếu <18 → in năm dự kiến vào UIT

    cmpl $22, %eax
    jle future_TN             # nếu <=22 → in năm dự kiến TN

    jmp past_TN               # nếu >22 → in năm đã TN

# Năm dự kiến vào UIT
future_vao:
    movl num, %eax
    addl $18, %eax            # năm sinh + 18
    movl $4, %eax
    movl $1, %ebx
    movl $msg_namVao, %ecx
    movl $msg_namVao_len, %edx
    int $0x80
    movl num, %eax
    addl $18, %eax
    jmp print_number

# Năm dự kiến tốt nghiệp 
future_TN:
    movl num, %eax
    addl $22, %eax            # năm sinh + 22
    movl $4, %eax
    movl $1, %ebx
    movl $msg_namDuKien, %ecx
    movl $msg_namDuKien_len, %edx
    int $0x80
    movl num, %eax
    addl $22, %eax
    jmp print_number

# Năm đã tốt nghiệp
past_TN:
    movl num, %eax
    addl $22, %eax
    movl $4, %eax
    movl $1, %ebx
    movl $msg_namTN, %ecx
    movl $msg_namTN_len, %edx
    int $0x80
    movl num, %eax
    addl $22, %eax

print_number:
    movl $buffer+4, %edi
    movb $0, (%edi)
print_year_loop:
    decl %edi
    movl $0, %edx
    movl $10, %ecx
    divl %ecx
    addb $'0', %dl
    movb %dl, (%edi)
    testl %eax, %eax
    jnz print_year_loop
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $buffer+4, %edx
    subl %edi, %edx
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $newline_len, %edx
    int $0x80

end:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
