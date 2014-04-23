CC = gcc
AS = nasm
ASFLAGS = -f elf
OBJECTS = loader.o kmain.o
CFLAGS = 	-m32 \
			-nostdlib \
			-nostdinc \
			-fno-builtin \
			-fno-stack-protector \
			-nostartfiles \
			-nodefaultlibs \
			-Wall \
			-Wextra \
			-Werror \
			-c

LDFLAGS = -T link.ld -melf_i386

all: kernel.elf

run: minios.iso
	bochs -f bochsrc.txt -q

minios.iso : kernel.elf
	cp kernel.elf iso/boot/kernel.elf
	genisoimage -R                      \
		-b boot/grub/stage2_eltorito    \
		-no-emul-boot                   \
		-boot-load-size 4               \
		-A os                           \
		-input-charset utf8             \
		-quiet                          \
		-boot-info-table                \
		-o minios.iso                   \
		iso

kernel.elf: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

%.o: %.c
	$(CC) $(CFLAGS)  $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f *.o *.iso bochslog.txt iso/boot/kernel.elf
