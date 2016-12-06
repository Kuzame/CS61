;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 8
; Lab section: 24
; TA: Bryan Marsh
;=================================================


.ORIG x3000

LD R0, string_data
LD R1, sub_get_string
JSRR R1
LD R1, sub_is_a_palindrome
JSRR R1

ADD R4, R4, #0
BRp PrintPalindrome
BRz PrintNotPalindrome
BRn EXIT ; shouldn't happened.. just in case
PrintPalindrome
	LEA R0, PALINDROME
	PUTS
	BRnzp EXIT
PrintNotPalindrome
	LEA R0, NOTPALINDROME
	PUTS
	BRnzp EXIT

EXIT

LEA R0, NEWLINE2
PUTS
HALT

NEWLINE2	.STRINGZ "\n"
PALINDROME	.STRINGZ "That is Palindrome\n"
NOTPALINDROME	.STRINGZ "That is NOT Palindrome\n"
sub_get_string	.FILL x3800
sub_is_a_palindrome	.FILL x4000
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

;--------------------------- sub_is_a_palindrome --------------------------------
;---------------------------------------------------------------------------------
; Subroutine: SUB_IS_A_PALINDROME
; Parameter (R0): The address of a string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R0) is
; a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise} 
;---------------------------------------------------------------------------------
.ORIG x4000

; backing up data
ST R0, BACKUP_R0_4000
ST R1, BACKUP_R1_4000
ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
ST R5, BACKUP_R5_4000
ST R6, BACKUP_R6_4000
ST R7, BACKUP_R7_4000

ADD R1, R0, #0	; R1 will preserve original address of data
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R6, R6, #0

ADD R5, R5, #-2
BRn ExitDivision

Division
	ADD R6, R6, #1
	ADD R5, R5, #-2
	BRzp Division
	
ExitDivision

;check if the result of division is positive
ADD R6, R6, #0
BRz OneOrZero

; R2 = left value
; R3 = right value
; R4 = used TEMPORARILY to iterate through the array
; R5 = n / number of chars in array
; R6 = result of division
LD R5, BACKUP_R5_4000

IsItPalindrome
	ADD R4, R1, #0
	ADD R4, R4, R6
	ADD R4, R4, #-1 ; since the data is stored starting from #000, not #001
	LDR R2, R4, #0
	ADD R4, R1, #0
	ADD R4, R4, R5
		NOT R6, R6 ; turn R6 to negative
		ADD R6, R6, #1
	ADD R4, R4, R6
		NOT R6, R6 ; turn R6 back to positive
		ADD R6, R6, #1
	LDR R3, R4, #0
	
	NOT R3, R3	;turn one of them negative, let's say R3
	ADD R3, R3, #1
	
	ADD R4, R2, R3
	BRnp IsNotPalindrome
	
	ADD R6, R6, #-1 ; decrement the R6
	BRnz IsPalindrome
	BRp IsItPalindrome
	
IsPalindrome
	AND R4, R4, #0
	ADD R4, R4, #1
	BRnzp ExitPalindrome

IsNotPalindrome
	AND R4, R4, #0
	BRnzp ExitPalindrome

OneOrZero
	ADD R5, R5, #1
	BRz IsOne
	BRn IsZero
IsOne ;1 character automatically makes it palindrome
	ADD R4, R4, #1
	BRnzp ExitPalindrome
IsZero ;no character shouldn't make it palindrome
	BRnzp ExitPalindrome

ExitPalindrome
LD R0, BACKUP_R0_4000
LD R1, BACKUP_R1_4000
LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
;LD R4, BACKUP_R4_4000 ;the value is stored in R4
LD R5, BACKUP_R5_4000
LD R6, BACKUP_R6_4000
LD R7, BACKUP_R7_4000
; returning
RET

; Subroutine Data
BACKUP_R0_4000 .BLKW	#1
BACKUP_R1_4000 .BLKW	#1
BACKUP_R2_4000 .BLKW	#1
BACKUP_R3_4000 .BLKW	#1
BACKUP_R4_4000 .BLKW	#1
BACKUP_R5_4000 .BLKW	#1
BACKUP_R6_4000 .BLKW	#1
BACKUP_R7_4000 .BLKW	#1

.end