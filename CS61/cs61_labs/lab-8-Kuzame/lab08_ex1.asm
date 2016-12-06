;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 8
; Lab section: 24
; TA: Bryan Marsh
;=================================================
;--------------------------------------------------------------------------------------------------
; Subroutine: SUB_IS_A_PALINDROME
; Parameter (R0): The address of a string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R0) is
; a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise} 
;--------------------------------

.ORIG x3000

LD R0, string_data
JSR sub_get_string

HALT


sub_get_string	.FILL x3800
string_data	.FILL x5000

;--------------------------	sub_get_string ------------------------------
;---------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING 
; Parameter (R0): The address of where to start storing the string 
; Postcondition: The subroutine has allowed the user to input a string, 
;    terminated by the [ENTER] key, and has stored it in an array 
;    that starts at (R0) and is NULL-terminated. 
; Return Value: R5 The number of non-sentinel characters read from the user 
;---------------------------------------------------------------------------------
.ORIG x3800
; restoring data
ST R0, BACKUP_R0_3800
ST R1, BACKUP_R1_3800
ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R4, BACKUP_R4_3800
ST R5, BACKUP_R5_3800
ST R6, BACKUP_R6_3800
ST R7, BACKUP_R7_3800

ADD R4, R0, #0 ; R4 Preserve the original address here for printing
ADD R5, R0, #0 ; R5 will use address and add characters to it
ADD R6, R0, #0 ; R5 minus the original address (R6) to count number of characters
NOT R6, R6
ADD R6, R6, #1

Loop
GETC
OUT
BRz END_LOOP
STR R0, R5, #0
ADD R5, R5, #1
ADD R1, R0, #-10
BRnp Loop

ADD R5, R5, #-1
ADD R5, R5, R6

END_LOOP
LEA R0, NEWLINE
PUTS
ADD R0, R4, #0
PUTS
LEA R0, NEWLINE
PUTS

; restoring data
LD R0, BACKUP_R0_3800
LD R1, BACKUP_R1_3800
LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R4, BACKUP_R4_3800
;LD R5, BACKUP_R5_3800
LD R6, BACKUP_R6_3800
LD R7, BACKUP_R7_3800
; returning
RET

NEWLINE	.STRINGZ "\n"
BACKUP_R0_3800 .BLKW	#1
BACKUP_R1_3800 .BLKW	#1
BACKUP_R2_3800 .BLKW	#1
BACKUP_R3_3800 .BLKW	#1
BACKUP_R4_3800 .BLKW	#1
BACKUP_R5_3800 .BLKW	#1
BACKUP_R6_3800 .BLKW	#1
BACKUP_R7_3800 .BLKW	#1
.ORIG x5000

.end



