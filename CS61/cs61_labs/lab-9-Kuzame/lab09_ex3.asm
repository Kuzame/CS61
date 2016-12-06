;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu

; Lab: lab 9
; Lab section: 24
; TA: Bryan Marsh
;=================================================
; PS: User can only input single digit of 0-9, however the multiplication result may be 0-32K! (bc I reuse my print_number function from lab07)

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
	
	ADD R1, R0, #0	;store it to R1 for printing
	LEA R0, pop_menu
	PUTS
	
	LD R2, PRINT_NUMBER
	JSRR R2
	
	LEA R0, NEWLINE
	PUTS

	BRnzp Loop
IsThree
	ADD R2, R6, #0	; R2 will store the original value of R6
	NOT R2, R2
	ADD R2, R2, #1	; --in minus value
	LD R1, SUB_RPN_MULT
	JSRR R1

	LEA R0, NEWLINE
	PUTS
	
	ADD R2, R2, R6	; If R6 is equals to its old value
	BRz Loop	; means nothing has changed--go back to loop
	
	LEA R0, mult_menu
	PUTS
	
	LDR R1, R6, #0		;Fetching the value from R6 to pass it to print subroutine
	LD R2, PRINT_NUMBER
	JSRR R2
	
	LEA R0, NEWLINE
	PUTS
	BRnzp Loop
IsFour
	LEA R0, Exitting
	PUTS


HALT
;Subroutines address
MENU		.FILL	x3400
SUB_STACK_PUSH	.FILL	x4000
SUB_STACK_POP	.FILL	x4400
SUB_RPN_MULT	.FILL	x4800
STACK_ADDRESS	.FILL	xA000
PRINT_NUMBER	.FILL	x5800

;Data
CONVERT		.FILL	xFFD0
CONVERTBACK	.FILL	x30
max_data_stack	.FILL	#05

;Strings 
push_menu	.STRINGZ	"Enter a number to be push: "
pop_menu	.STRINGZ	"The popped value is: "
mult_menu	.STRINGZ	"The new value is: "
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

.ORIG x4800
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_MULT
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available 
;			address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		multiplied them together, and pushed the resulting value back 
;		onto the stack.
; Return Value: R6 <-- updated top value
;-----------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4800
ST R1, BACKUP_R1_4800
ST R2, BACKUP_R2_4800
ST R3, BACKUP_R3_4800
ST R4, BACKUP_R4_4800
ST R5, BACKUP_R5_4800
ST R6, BACKUP_R6_4800
ST R7, BACKUP_R7_4800

ADD R1, R6, #0
NOT R1, R1
ADD R1, R1, #1
ADD R1, R1, R5
BRz IsUnderflow2
ADD R1, R1, #-1		;If's only 0 or 1 value inside the stack, it's "underflow"
BRz IsUnderflow2
BRnp NotUnderflow2
IsUnderflow2
	LEA R0, mult_error
	PUTS
	BRnzp ExitMult
NotUnderflow2
	LD R1, CALL_POP
	JSRR R1
	ADD R2, R0, #0
	LD R1, CALL_POP
	JSRR R1
	ADD R3, R0, #0

	LD R1, CALL_MULT
	JSRR R1
	
	; ########### NEED TO MAKE SURE R0 IS THE MULT RESULT ####################
	ADD R0, R1, #0
	LD R1, CALL_PUSH
	JSRR R1

ExitMult
; restoring data
LD R0, BACKUP_R0_4800
LD R1, BACKUP_R1_4800
LD R2, BACKUP_R2_4800
LD R3, BACKUP_R3_4800
LD R4, BACKUP_R4_4800
LD R5, BACKUP_R5_4800
;LD R6, BACKUP_R6_4800
LD R7, BACKUP_R7_4800
; returning
RET
BACKUP_R0_4800 .BLKW	#1
BACKUP_R1_4800 .BLKW	#1
BACKUP_R2_4800 .BLKW	#1
BACKUP_R3_4800 .BLKW	#1
BACKUP_R4_4800 .BLKW	#1
BACKUP_R5_4800 .BLKW	#1
BACKUP_R6_4800 .BLKW	#1
BACKUP_R7_4800 .BLKW	#1
;--------------------------------
;Data for subroutine
;--------------------------------
CALL_PUSH	.FILL x4000
CALL_POP	.FILL x4400
CALL_MULT	.FILL x4C00
STACK_FOR_4800	.FILL xA000
mult_error	.STRINGZ "Insufficient amount of stack! (Minimum should be 2!)"


.ORIG x4C00
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_MULT
; Parameter (R2): Value1 (whatever's on the top)
; Parameter (R3): Value2 (2nd after top)
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available 
;			address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		multiplied them together, and pushed the resulting value back 
;		onto the stack.
; Return Value: R1 <-- New mult value
;-----------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4C00
ST R1, BACKUP_R1_4C00
ST R2, BACKUP_R2_4C00
ST R3, BACKUP_R3_4C00
ST R4, BACKUP_R4_4C00
ST R5, BACKUP_R5_4C00
ST R6, BACKUP_R6_4C00
ST R7, BACKUP_R7_4C00

;Check which R2 or R3 is smaller
ADD R1, R2, #0
NOT R1, R1
ADD R1, R1, #1
ADD R1, R1, R3
BRzp DoNothing
;Swap
	ADD R1, R2, #0
	ADD R2, R3, #0
	ADD R3, R1, #0
DoNothing
AND R1, R1, #0
LoopMult
	ADD R1, R1, R3
	ADD R2, R2, #-1
	BRp LoopMult

; restoring data
LD R0, BACKUP_R0_4C00
;LD R1, BACKUP_R1_4C00
LD R2, BACKUP_R2_4C00
LD R3, BACKUP_R3_4C00
LD R4, BACKUP_R4_4C00
LD R5, BACKUP_R5_4C00
LD R6, BACKUP_R6_4C00
LD R7, BACKUP_R7_4C00
; returning
RET
BACKUP_R0_4C00 .BLKW	#1
BACKUP_R1_4C00 .BLKW	#1
BACKUP_R2_4C00 .BLKW	#1
BACKUP_R3_4C00 .BLKW	#1
BACKUP_R4_4C00 .BLKW	#1
BACKUP_R5_4C00 .BLKW	#1
BACKUP_R6_4C00 .BLKW	#1
BACKUP_R7_4C00 .BLKW	#1

;-----------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUMBER (primarily to print number above 10)
; R1 = value
; R2 = place (-10000, -1000, ... , -10 )
; R3 = temp (value-place)
; R4 = counter
; R5 = flag (if it's leading 0: -1. If it's no longer leading 0: 0)
; [R6 = conversion from ascii to its character]
; Return: NONE
;-----------------------------------------------------------------------------------------------

.ORIG x5800
; backing up data
ST R1, BACKUP_R1_5800
ST R2, BACKUP_R2_5800
ST R3, BACKUP_R3_5800
ST R4, BACKUP_R4_5800
ST R5, BACKUP_R5_5800
ST R6, BACKUP_R6_5800
ST R7, BACKUP_R7_5800

; EXECUTE
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0

ADD R5, R5, #-1	;set flag to -1 by default
LD R6, convert3
LD R2, ten_thousand


;---- is it negative? ----
ADD R1, R1, #0
BRzp Not_Negative
LEA R0, neg_sign
PUTS
NOT R1, R1
ADD R1, R1, #1

Not_Negative	;otherwise print nothing

;--------- Begin Printing Process -----------
ADD R3, R3, R1
Loop4
ADD R3, R3, R2
BRn DoneLoop4	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop4

DoneLoop4
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, one_thousand	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop3	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0

Loop3
ADD R3, R3, R2
BRn DoneLoop3	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop3

DoneLoop3
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, one_hundred	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop2	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0

Loop2
ADD R3, R3, R2
BRn DoneLoop2	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop2

DoneLoop2
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, ten	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop1	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0


Loop1
ADD R3, R3, R2
BRn DoneLoop	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop1

DoneLoop
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
;LD R2, ten		;(doesn't matter)
ADD R5, R5, #0	;check if this is leading 0
BRn ExitLoop	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT

ExitLoop
AND R4, R4, #0
;--------- now below should be the 5th one
ADD R1, R1, R6
ST R1, result
LD R0, result
OUT

; ---------------

; restoring data
LD R1, BACKUP_R1_5800
LD R2, BACKUP_R2_5800
LD R3, BACKUP_R3_5800
LD R4, BACKUP_R4_5800
LD R5, BACKUP_R5_5800
LD R6, BACKUP_R6_5800
LD R7, BACKUP_R7_5800
; returning
RET

; Subroutine Data
neg_sign	.STRINGZ "-"
convert3		.FILL x30
ten_thousand	.FILL #-10000
one_thousand	.FILL #-1000
one_hundred		.FILL #-100
ten				.FILL #-10
result			.BLKW	#1
BACKUP_R1_5800 .BLKW	#1
BACKUP_R2_5800 .BLKW	#1
BACKUP_R3_5800 .BLKW	#1
BACKUP_R4_5800 .BLKW	#1
BACKUP_R5_5800 .BLKW	#1
BACKUP_R6_5800 .BLKW	#1
BACKUP_R7_5800 .BLKW	#1

.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* Stack Menu *\n**********************\n1. Push the number onto the stack\n2. Pop the number from the stack\n3. Multiply the top 2 values on stack\n4. Quit\n"

.ORIG xA000




