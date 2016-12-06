;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 9
; Lab section: 24
; TA: Bryan Marsh
;=================================================

.ORIG x3000

LD R3, CONVERT			; R3 = for conversion
LD R4, STACK_ADDRESS		;address of the stack
LD R5, max_data_stack		;max should be the address + max size available
ADD R5, R5, R4
ADD R6, R5, #0			;current top stack should be on the bottom
BRnzp Loop

Loop
LD R1, MENU
JSRR R1
ADD R1, R1, #-1
BRz IsOne
ADD R1, R1, #-1
BRz IsTwo
ADD R1, R1, #-1
BRz IsThree
ADD R1, R1, #-1
BRz IsFour

IsOne
	LEA R0, push_menu
	PUTS
	GETC
	OUT
	
	ADD R0, R0, R3
	
	LD R1, SUB_STACK_PUSH
	JSRR R1
	LEA R0, NEWLINE
	PUTS
	BRnzp Loop
IsTwo
	LD R1, SUB_STACK_POP
	JSRR R1
	ADD R0, R0, #0
	BRz Loop	;do nothing if the popped value is empty (go back to menu)
	ADD R1, R0, #0	;store it temporarily to R1
	LEA R0, pop_menu
	PUTS
	
	ADD R0, R1 ,#0
	LD R3, CONVERTBACK
	ADD R0, R0, R3
	OUT
	LD R3, CONVERT
	LEA R0, NEWLINE
	PUTS

	BRnzp Loop
IsThree
	BRnzp Loop
IsFour
	LEA R0, Exitting
	PUTS


HALT
;Subroutines address
MENU		.FILL	x3400
SUB_STACK_PUSH	.FILL	x4000
SUB_STACK_POP	.FILL	x4400
STACK_ADDRESS	.FILL	xA000

;Data
CONVERT		.FILL	xFFD0
CONVERTBACK	.FILL	x30
max_data_stack	.FILL	#05

;Strings 
push_menu	.STRINGZ	"Enter a number to be push: "
pop_menu	.STRINGZ	"The popped value is: "
NEWLINE		.STRINGZ	"\n"
Exitting	.STRINGZ	"Exitting the program"

.ORIG x3400
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                          user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
; R2 for conversion
LD R2, convert
BRnzp IsItOneToSeven
NotOneToSeven
LEA R0, Error_message_1
PUTS

IsItOneToSeven
LD R0, Menu_string_addr
PUTS
GETC
OUT
ADD R1, R0, #0
LEA R0, newline
PUTS
ADD R1, R1, R2
BRnz NotOneToSeven
ADD R1, R1, #-4
BRp NotOneToSeven
ADD R1, R1, #4


; restoring data
LD R0, BACKUP_R0_3400
;LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400
; returning
RET
BACKUP_R0_3400 .BLKW	#1
BACKUP_R1_3400 .BLKW	#1
BACKUP_R2_3400 .BLKW	#1
BACKUP_R3_3400 .BLKW	#1
BACKUP_R4_3400 .BLKW	#1
BACKUP_R5_3400 .BLKW	#1
BACKUP_R6_3400 .BLKW	#1
BACKUP_R7_3400 .BLKW	#1
;--------------------------------
;Data for subroutine MENU
;--------------------------------
convert			.FILL	xFFD0 ; This is equivalent to the negative value of x30
newline			.STRINGZ "\n"
Error_message_1 .STRINGZ "INVALID INPUT\n"
Menu_string_addr .FILL x6000


.ORIG x4000
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available 
;			address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1).
;		 If the stack was already full (TOS = MAX), the subroutine has printed an overflow 
;		 error message and terminated
; Return Value: R6 <-- updated TOS
;-----------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4000
ST R1, BACKUP_R1_4000
ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
ST R5, BACKUP_R5_4000
ST R6, BACKUP_R6_4000
ST R7, BACKUP_R7_4000

ADD R1, R6, #0
NOT R1, R1
ADD R1, R1, #1
ADD R1, R1, R4
BRnp NotOverflow
;IsOverflow
	LEA R0, overflow_error
	PUTS
	BRnzp ExitPush
NotOverflow
	ADD R6, R6, #-1
	STR R0, R6, #0


ExitPush
; restoring data
LD R0, BACKUP_R0_4000
LD R1, BACKUP_R1_4000
LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
LD R4, BACKUP_R4_4000
LD R5, BACKUP_R5_4000
;LD R6, BACKUP_R6_4000
LD R7, BACKUP_R7_4000
; returning
RET
BACKUP_R0_4000 .BLKW	#1
BACKUP_R1_4000 .BLKW	#1
BACKUP_R2_4000 .BLKW	#1
BACKUP_R3_4000 .BLKW	#1
BACKUP_R4_4000 .BLKW	#1
BACKUP_R5_4000 .BLKW	#1
BACKUP_R6_4000 .BLKW	#1
BACKUP_R7_4000 .BLKW	#1
;--------------------------------
;Data for subroutine 
;--------------------------------
STACK_FOR_4000 .Fill xA000
overflow_error	.STRINGZ	"Stack OVERFLOW! Can no longer PUSH!\n"

.ORIG x4400
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available 
;			address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[top]off the stack
;		If the stack was already empty (TOS = BASE), the subroutine has printed
;		an underflow error message and terminated
; Return Value: R0 <-- value popped of the stack
;		R6 <-- updated TOS
;-----------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4400
ST R1, BACKUP_R1_4400
ST R2, BACKUP_R2_4400
ST R3, BACKUP_R3_4400
ST R4, BACKUP_R4_4400
ST R5, BACKUP_R5_4400
ST R6, BACKUP_R6_4400
ST R7, BACKUP_R7_4400

ADD R1, R6, #0
NOT R1, R1
ADD R1, R1, #1
ADD R1, R1, R5
BRnp NotUnderflow
;IsUnderflow
	LEA R0, underflow_error
	PUTS
	AND R0, R0, #0
	BRnzp ExitPop
NotUnderflow
	LDR R0, R6, #0
	ADD R6, R6, #1

ExitPop
; restoring data
;LD R0, BACKUP_R0_4400
LD R1, BACKUP_R1_4400
LD R2, BACKUP_R2_4400
LD R3, BACKUP_R3_4400
LD R4, BACKUP_R4_4400
LD R5, BACKUP_R5_4400
;LD R6, BACKUP_R6_4400
LD R7, BACKUP_R7_4400
; returning
RET
BACKUP_R0_4400 .BLKW	#1
BACKUP_R1_4400 .BLKW	#1
BACKUP_R2_4400 .BLKW	#1
BACKUP_R3_4400 .BLKW	#1
BACKUP_R4_4400 .BLKW	#1
BACKUP_R5_4400 .BLKW	#1
BACKUP_R6_4400 .BLKW	#1
BACKUP_R7_4400 .BLKW	#1
;--------------------------------
;Data for subroutine
;--------------------------------
STACK_FOR_4400 .Fill xA000
underflow_error	.STRINGZ	"Stack UNDERFLOW! Can no longer POP!\n"


.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* Stack Menu *\n**********************\n1. Push the number onto the stack\n2. Pop the number from the stack\n3. [Empty]\n4. Quit\n"

.ORIG xA000



