#include "mips.h"
#include "yamon.h"

	.text
	.globl	start
start:
	li	a0,0			# test YAMON API
	LA	a1,print
	lw	t9,YAMON_PRINT
	jal	t9
	nop

	li	a0,0
	LA	a1,prc
	li	a2,24
	lw	t9,YAMON_PRINT_COUNT
	jal	t9
	nop

	li	t9,YAMON_START
	jr	t9

	
print:	.ascii  "YAMON API: PRINT"
	.byte	13,10,0
prc:	.ascii	"YAMON API: PRINT_COUNT"
	.byte   13,10,0
