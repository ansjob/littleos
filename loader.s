global loader

MAGIC_NUMBER equ 0xBADB002
CHECKSUM equ -MAGIC_NUMBER

section .text:
align 4
	dd MAGIC_NUMBER
	dd CHECKSUM

loader:
	mov eax, 0xCAFEB00B
.loop:
	jmp .loop
