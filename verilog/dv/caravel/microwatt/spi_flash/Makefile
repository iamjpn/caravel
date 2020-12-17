FIRMWARE_PATH = ../..
VERILOG_PATH = ../../../..
RTL_PATH = $(VERILOG_PATH)/rtl
IP_PATH = ../../../../ip
BEHAVIOURAL_MODELS = ../../

GCC_PATH?=/ef/apps/bin
GCC_PREFIX?=riscv32-unknown-elf
PDK_PATH?=/ef/tech/SW/sky130A

POWERPC_CROSS_COMPILE?=powerpc64le-linux-
POWERPC_CFLAGS=-Os -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -nostdlib -I../include

SIM?=RTL

.SUFFIXES:

PATTERN = spi_flash

all:  ${PATTERN:=.vcd} 

%.vvp: %_tb.v mgmt_engine.hex microwatt.hex
ifeq ($(SIM),RTL)
	iverilog -DFUNCTIONAL -DSIM -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(RTL_PATH) \
	$< -o $@
else
	iverilog -DFUNCTIONAL -DSIM -DGL -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(VERILOG_PATH) -I $(RTL_PATH) \
	$< -o $@
endif

%.vcd: %.vvp
	vvp $<

# Management engine code

mgmt_engine.elf: mgmt_engine.c $(FIRMWARE_PATH)/sections.lds $(FIRMWARE_PATH)/start.s
	${GCC_PATH}/${GCC_PREFIX}-gcc -march=rv32imc -mabi=ilp32 -Wl,-Bstatic,-T,$(FIRMWARE_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(FIRMWARE_PATH)/start.s $<

mgmt_engine.hex: mgmt_engine.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@
	# to fix flash base address
	sed -i 's/@1000/@0000/g' $@

mgmt_engine.bin: mgmt_engine.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# Microwatt code
microwatt.elf: microwatt.c ../lib/console.c head.S ../microwatt.lds
	$(POWERPC_CROSS_COMPILE)gcc $(POWERPC_CFLAGS) -Wl,-Bstatic,-T,../microwatt.lds,--strip-debug -o $@ microwatt.c ../lib/console.c head.S

microwatt.hex: microwatt.elf
	$(POWERPC_CROSS_COMPILE)objcopy -O verilog $< $@
	# to fix flash base address
	sed -i 's/@F000/@0000/g' $@

microwatt.bin: microwatt.elf
	$(POWERPC_CROSS_COMPILE)objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# ---- Clean ----

clean:
	rm -f *.vvp *.vcd *.elf *.bin *.o *.vvp *.vcd *.log *.hex

.PHONY: clean hex all
