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

LD R2, ptr
LD R3, start
LD R4, size
LD R5, convert

Loop ; 
STR R3, R2, #0
ADD R3, R3, #1
ADD R2, R2, #1
ADD R4, R4, #-1
BRp Loop

LD R4, size ;resetting R2 and R4
LD R2, ptr

Loop2
LDR R0, R2, #0
ADD R0, R0, R5
OUT
LEA R0, NEWLINE
PUTS
ADD R2, R2, #1
ADD R4, R4, #-1
BRp Loop2

HALT
;------------
;Local data
;------------
NEWLINE		.STRINGZ	"\n"
size		.FILL	#10
start		.FILL	#0
ptr		.FILL	x4000
convert		.FILL	x30


.orig x4000
		.BLKW	#10

.end

