; RECURSIVE CHAR COUNT PROGRAM
;
; Assumptions:
;   - the input string will be no longer than 19 characters
;   - the search char will occur less than 10 times
;
; R0 - I/O, temp results
; R1 - temp results
; R2 - temp results
; R3 - word length
; R5 - frame pointer
; R6 - stack pointer

	.orig x3000
	
; *************** MAIN SETUP ******************************

	; init stack and frame pointers
	LD	R6, STACK
	LD	R5, STACK

	; make room for local vars on the stack (need 22 locations - 20 for word, 1 for search, 1 for result)
	;    char word[20], search, result;
	ADD 	R5, R5, #-1	; set frame pointer
	ADD	R6, R6, #-16	; set stack pointer
	ADD	R6, R6, #-6	; set stack pointer


; *************** MAIN CODE ******************************

	; prompt for word
LOOP	LEA	R0, PROMPT1
	PUTS                                                       

	; scan the word
	AND	R3, R3, #0   	; initialize word length to 0
	ADD	R1, R5, #-15
        ADD	R1, R1, #-4	; set R1 to point to word[0]

SCAN	GETC
	OUT
	ADD	R2, R0, x-0A	; check for <enter> key
        BRz 	EXIT_SCAN
	ADD	R3, R3, #1	; increment word length
        STR	R0, R1, #0	; store the character
	ADD	R1, R1, #1	; increment word ptr
 	BRnzp	SCAN
EXIT_SCAN
	ADD	R3, R3, #0	; load word length
	BRz	DONE		; end if word length is 0
        AND     R0, R0, #0      ; append null char
        STR     R0, R1, #0

        ; prompt for the search char
	LEA	R0, PROMPT2
	PUTS

	; scan the search char
	GETC
        OUT
	STR	R0, R5, #-20	; store value in search variable

; *************** FUNCTION CALL ******************************

	; result = charCount(word, search);

	; push second parameter
	LDR     R0, R5, #-20	; get search into R0
	ADD	R6, R6, #-1
	STR	R0, R6, #0	; push search onto the stack

	; push first parameter
        ADD	R0, R5, #-15
        ADD	R0, R0, #-4	; address of word[0] now in R0
	ADD	R6, R6, #-1
	STR	R0, R6, #0	; push &word[0] onto the stack

        ; call function
	LD      R0, CHAR_COUNT
	JSRR    R0

; *************** RETURN FROM CALL ******************************

	; store return value in result
	LDR R0, R6, #0
	STR R0, R5, #-21

	; pop return value and params
	ADD R6, R6, #3

; *************** RESUME MAIN CODE *****************************

	; print "Occurs "
	LEA 	R0, OCCURS
	PUTS

        ; print result
	LD	R1, ASCII
	LDR 	R0, R5, #-21
	ADD	R0, R0, R1
	OUT

	; print " times!"
	LEA	R0, TIMES
	PUTS
	
	BRnzp LOOP
DONE	HALT	

STACK	.FILL	x3000
ASCII   .FILL   x30
PROMPT1	.STRINGZ "Enter a word (Enter to quit): "
PROMPT2 .STRINGZ "Enter a char to search for: "
OCCURS  .STRINGZ "\nOccurs "
TIMES   .STRINGZ " times!\n"
CHAR_COUNT .FILL   x3300

        .END


