;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 3
; Lab section: 24
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
;------------
;Instruction
;------------
LD R0, HEX_61
LD R1, HEX_1A

DO_WHILE_LOOP
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP

HALT
;------------
;Local data
;------------
HEX_61	.FILL	x61 ;#65 and x41 are equivalent to letter 'A'
HEX_1A	.FILL	x1A

.end