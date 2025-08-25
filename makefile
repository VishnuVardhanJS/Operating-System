BUILD = build
SRC   = src
ISO   = iso

CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra

.PHONY: all run clean

all: os.iso

$(BUILD)/boot.o : $(SRC)/boot.s
	xc-as $(SRC)/boot.s -o $(BUILD)/boot.o

$(BUILD)/kernel.o : $(SRC)/kernel.c
	xc-gcc -c $(SRC)/kernel.c -o $(BUILD)/kernel.o $(CFLAGS)

$(ISO)/boot/os.bin : $(SRC)/kernel.c $(SRC)/kernel.ld $(BUILD)/kernel.o $(BUILD)/boot.o
	xc-gcc -T $(SRC)/kernel.ld -o $(ISO)/boot/os.bin -ffreestanding -O2 -nostdlib $(BUILD)/kernel.o $(BUILD)/boot.o -lgcc

os.iso : $(ISO)/boot/os.bin
	grub-mkrescue -o $@ $(ISO)

run: os.iso
	qemu-system-i386 -cdrom os.iso

clean:
	rm -f $(BUILD)/*.o $(ISO)/boot/os.bin os.iso
