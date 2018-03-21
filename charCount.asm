; CHAR_COUNT FUNCTION
;
; R0 - hold search
; R1 - hold *str
; R2 
; R2 - hold result?
; R3 - 
; R4 - 
; R5 - frame pointer
; R6 - stack pointer
; R7 - ret addressi

; *************** CHAR_COUNT SETUP *****************************

        .ORIG   x3300

; maybe be fucking up main's registers haha

START   LDR     R1, R6, #1      ; store c
        LDR     R0, R6, #0      ; store pointer

        STR     R7, R6, #-2     ; push return address
        STR     R5, R6, #-3     ; push dynamic link(check)
        ADD     R6, R6, #-4     ; stack pointer at top (result)
        ADD     R5, R6, #0      ; frame pointer at top
        
        LDR     R7, R0, #0      ; store actual value from *str
        AND     R3, R3, #0
	
; *************** CHAR_COUNT CODE *****************************
;   if (*str == 0)
IF      ADD     R2, R7, R3      ; check str == 0
        BRnp    ELSE

;      result = 0;
        ;STR     R3, R5, #0      ; store in result
        STR     R3, R6, #3      ; store in ret val
        ADD     R6, R6, #3      ; pop top 3
        ADD     R5, R5, #6      ; frame p at previous activation period
        BRnzp   RETURN    

;   else { 
;      if (*str == c)

ELSE    NOT     R2, R7          
        ADD     R2, R2, #1      
        ADD     R2, R1, R2      ; subtract to see if str == c
        BRnp    ELSE2

;         result = 1;
        ADD     R3, R3, #1
        STR     R3, R5, #0
        BRnzp   DONE

;      else
;         result = 0;
ELSE2   STR     R3, R5, #0
        

;      result += charCount(str+1, c);

DONE    ADD     R0, R0, #1      ; increment str
       
        ; push second parameter 
	LDR     R1, R5, #5	; get search into R0
	ADD	R6, R6, #-1
	STR	R1, R6, #0	; push search onto the stack

	; push first parameter
        ADD     R6, R6, #-1
	STR	R0, R6, #0	

        JSR     START

; *************** CHAR_COUNT RETURN *****************************

	; return result;
RETURN  
        LDR     R0, R6, #0      ; get ret val
        ADD     R6, R6, #3      ; pop ret val and params
        LDR     R1, R6, #0      ; get result in r1
        ADD     R0, R1, R0      ; add old ret val and result
        STR     R0, R6, #3      ; store in new ret val
        
        LDR     R5, R6, #1      ; dynamic link into r5
        LDR     R7, R6, #2      ; ret addr to r7
        ADD     R6, R6, #3      ; adjust stack pointer

        RET

        .END	



