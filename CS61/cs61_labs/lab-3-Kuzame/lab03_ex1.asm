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
LD R3, DEC_65
LD R4, HEX_41

HALT
;------------
;Local data
;------------
DEC_65	.FILL	#65 ;#65 and x41 are equivalent to letter 'A'
HEX_41	.FILL	x41

.end
