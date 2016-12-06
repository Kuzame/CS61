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
LDI R3, DEC_65_PTR
LDI R4, HEX_41_PTR

ADD R3, R3, #1		;add 1 to R3
ADD R4, R4, #1		;add 1 to R4

STI R3, DEC_65_PTR
STI R4, HEX_41_PTR

;They will now represent character 'B' at x4000 & x4001

;exercise3
LD R5, DEC_65_PTR
LD R6, HEX_41_PTR

LDR R3, R5, #0
LDR R4, R6, #0

ADD R3, R3, #1
ADD R4, R4, #1

STR R3, R5, #0
STR R4, R6, #0

;They will now represent character 'C' at x4000 & 4001

HALT
;------------
;Local data
;------------
DEC_65_PTR	.FILL	x4000
HEX_41_PTR	.FILL	x4001

;------------
;Remote Address
;------------
.orig x4000
NEW_DEC_65	.FILL #65
NEW_HEX_41	.FILL x41
.end