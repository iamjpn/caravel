#!/bin/bash

CROSS_COMPILE=powerpc64le-linux-

${CROSS_COMPILE}gcc -Os -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -c hello_world.c
${CROSS_COMPILE}gcc -Os -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -c console.c
${CROSS_COMPILE}gcc -c head.S

${CROSS_COMPILE}ld -T powerpc.lds -o hello_world.elf console.o hello_world.o head.o

${CROSS_COMPILE}objcopy -O binary hello_world.elf hello_world.bin

./bin2hex-split.py hello_world.bin
