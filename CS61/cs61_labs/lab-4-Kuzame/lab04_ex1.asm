;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 4
; Lab section: 24
; TA: Bryan Marsh
; 
;=================================================

.orig x3000
;------------
;Instruction
;------------
LD R1, DATA_PTR		;exercise 1 
LDR R3, R1, #0		;manipulate using ldr to get both x4000 and x4001 (below)
LDR R4, R1, #1

ADD R3, R3, #1		;add 1 to R3
ADD R4, R4, #1		;add 1 to R4

STR R3, R1, #0
STR R4, R1, #1

;They will now represent character 'B' at x4000 & x4001

LD R5, DATA_PTR

LDR R3, R5, #0
LDR R4, R5, #1

ADD R3, R3, #1
ADD R4, R4, #1

STR R3, R5, #0
STR R4, R5, #1

;They will now represent character 'C' at x4000 & 4001

HALT
;------------
;Local data
;------------
DATA_PTR	.FILL	x4000 ; only have DATA_PTR now

;------------
;Remote Address
;------------
.orig x4000
.FILL #65
.FILL x41
.end
