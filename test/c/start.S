
.globl _start
_start:

	la sp, _eusrstack
	call main

	.word 0
