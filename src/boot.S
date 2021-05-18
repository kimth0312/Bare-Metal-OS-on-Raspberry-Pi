#include "mm.h"

.section ".text.boot"

.globl _start
_start:
		mrs		x0, mpdir_el1
		and		x0, x0, #0xFF		// Check processor id
		cbz		x0, master			// Hang for all non-primary CPU
		b		proc_hang
									// We are going to use CPU 0 only out of 4 CPUs
	
proc_hang:
		b		proc_hang			// infinite loop

master:
		adr		x0, bss_begin
		adr		x1, bss_end
		sub		x1, x1, x0
		bl		memzero

		mov		sp, #LOW_MEMORY
		bl		kernel_main
		b		proc_hang
