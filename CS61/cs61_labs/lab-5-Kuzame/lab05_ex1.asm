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

Loop ; 
STR R3, R2, #0
ADD R3, R3, #1
ADD R2, R2, #1
ADD R4, R4, #-1
BRp Loop

;Continuation on exercise 3

HALT
;------------
;Local data
;------------
size		.FILL	#10
start		.FILL	#0
ptr		.FILL	x4000


.orig x4000
new_ptr		.BLKW	#10

.end
