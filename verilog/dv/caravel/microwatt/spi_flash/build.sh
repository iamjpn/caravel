#!/bin/bash

CROSS_COMPILE=powerpc64le-linux-

${CROSS_COMPILE}gcc -Os -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -c hello_world.c
${CROSS_COMPILE}gcc -Os -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -c console.c
${CROSS_COMPILE}gcc -c head.S

${CROSS_COMPILE}ld -T powerpc.lds -o hello_world.elf console.o hello_world.o head.o

${CROSS_COMPILE}objcopy -O verilog hello_world.elf microwatt.hex

# To fix the base address
sed -i 's/@F000/@0000/g' microwatt.hex
