#multiboot2

#Declare constants for the multiboot2 header.

.set MAGIC,    0xE85250D6 #'magic number' lets bootloader find the header
.set ARCH,     0 #architecture 0 means i386
.set LEN,      (header_end - header_start) #length of the header
.set CHECKSUM, 0x100000000 - (MAGIC + ARCH + LEN) #checksum of above, to prove we are multiboot2

.section .multiboot2
header_start:
  .align 4
  .long MAGIC
  .long ARCH
  .long LEN
  .long CHECKSUM
  .long 0 # End tag
  .long 8 # End tag
header_end:


.section .bss
  .align 16

stack_bottom:
  .skip 16384 # 16 KiB
stack_top:


.section .text
.global _start
.type _start, @function

_start:
  mov $stack_top, %esp
  call kernel_start

  cli

1: hlt
  jmp 1b

.size _start, . - _start


