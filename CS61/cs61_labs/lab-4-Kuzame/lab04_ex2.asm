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

LEA R0, intro ;exercise 2
PUTS

LD R6, size
LD R3, ptr

Loop ; scanning 10 characters
GETC
OUT
STR R0, R3, #0
ADD R3, R3, #1
ADD R6, R6, #-1
BRp Loop

LD R6, size ;resetting R3 and R6
LD R3, ptr

;Continuation on exercise 3

HALT
;------------
;Local data
;------------
intro		.STRINGZ	"Enter exactly 10 characters:\n"
size		.FILL	#10
ptr		.FILL	x4000


.orig x4000
new_ptr		.BLKW	#10

.end
