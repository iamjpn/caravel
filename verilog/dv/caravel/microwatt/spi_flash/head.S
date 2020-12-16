/* Copyright 2013-2014 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* Load an immediate 64-bit value into a register */
#define LOAD_IMM64(r, e)			\
	lis	r,(e)@highest;			\
	ori	r,r,(e)@higher;			\
	rldicr	r,r, 32, 31;			\
	oris	r,r, (e)@h;			\
	ori	r,r, (e)@l;

	.section ".head","ax"
	.global _start
_start:
#if 0
	LOAD_IMM64(1, 0x1122334455667788)
	LOAD_IMM64(2, 0xA1A1A2A4A5A6A7A8)
	LOAD_IMM64(3, 0xC0FFEEBAD15BADEE)
	LOAD_IMM64(4, 0x8395720349234084)
	LOAD_IMM64(5, 0x2342344142344144)

	li	0,0

	std	1,0(0)
	std	2,72(0)
	std	3,144(0)
	std	4,192(0)
	std	5,256(0)

1:	ld	10,0(0)
	cmpd	10,1
	bne	2f

	ld	10,72(0)
	cmpd	10,2
	bne	2f

	ld	10,144(0)
	cmpd	10,3
	bne	2f

	ld	10,192(0)
	cmpd	10,4
	bne	2f

	ld	10,256(0)
	cmpd	10,5
	bne	2f
	b	1b

2:	b	2b
#endif

	// A few nops that we can check for in our test case
	ori	31,31,0
	ori	1,1,0
	ori	16,16,0

	// Zero BSS
	LOAD_IMM64(%r10,__bss_start)
	LOAD_IMM64(%r11,__bss_end)
	subf	%r11,%r10,%r11
	addi	%r11,%r11,63
	srdi.	%r11,%r11,6
	beq	2f
	mtctr	%r11
1:	dcbz	0,%r10
	addi	%r10,%r10,64
	bdnz	1b

2:	LOAD_IMM64(%r1,__stack_top)
	li	%r0,0
	stdu	%r0,-16(%r1)
	LOAD_IMM64(%r12, main)
	mtctr	%r12
	bctrl
	attn // terminate on exit
	b .
