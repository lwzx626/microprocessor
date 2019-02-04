	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Dec			    ; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	
acs0	udata_acs   ; reserve data space in access ram
mul1	res 1	    ; reserve data space for all elements
mul2	res 1	    ; involved in the multiplication
mul3	res 1
mul4	res 1
mul11	res 1
mul12	res 1
mul22	res 1
mul23	res 1
mul32	res 1
mul33	res 1
mul34	res 1
mul43	res 1
mul44	res 1
carry	res 1

	code	0    ; reset vector
	goto	setup

	; ******* LCD and ADC setup ***********************
setup	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	
main	clrf	carry		; reset carry bit
	call	ADC_Read	; input voltage reading - 2bytes
	
	; long multiplication: hex reading * 0x418A
	movf	ADRESL,W	; low byte to W
	mullw	0x8A		; low byte * 8A
	movff	PRODL, mul1     ; product's low byte is the last byte of the result
	movff	PRODH, mul12	; product's high byte stores to mul 12
	movf	ADRESH,W	; high byte to W
	mullw	0x8A		; high byte * 8A
	movff	PRODL, mul22	; product's low byte stores to mul 22
	movff	PRODH, mul23    ; product's high byte stores to mul 23
	movf	ADRESL,W	; low byte to W
	mullw	0x41		; low byte * 41
	movff	PRODL, mul32	; product's low byte stores to mul 32
	movff	PRODH, mul33	; product's high byte stores to mul 33
	movf	ADRESH,W	; high byte to W
	mullw	0x41		; high byte * 41
	movff	PRODL, mul43	; product's low byte stores to mul 43
	movff	PRODH, mul44	; product's high byte stores to mul 44
	
	; multiplication ends, start adding each element
	movff	mul12, mul2	; sum up corresponding elements
	movf	mul2, W		; to calculate the 2nd byte in the result
	addwf	mul22, W        ; mul 12 + mul 22 + mul 32 to mul 2
	movwf	mul2
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movf	mul2, W 
	addwf	mul32, W
	movwf	mul2
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movff	carry, mul3	; add carry generated during mul 2 to mul 3
	clrf	carry		; clear carry
	movf	mul3, W		; calculate the 3rd byte in the result
	addwf	mul23, W	; carry + mul 23 + mul 33 + mul 43 to mul 3
	movwf	mul3	
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movf	mul3, W	
	addwf	mul33, W
	movwf	mul3
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movf	mul3, W
	addwf	mul43, W
	movwf	mul3
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movff	carry, mul4	; add carry generated during mul 3 to mul 4
	clrf	carry		; clear carry
	movf	mul4, W		; calculate the 4th byte in the result
	addwf	mul44, W	; carry + mul 44 to mul 4
	call	LCD_Write_Dec	; output the 1st digit (in mul 4) to LCD
	call	mult0A		; calculate and output the 2nd digit
	call	mult0A		; calculate and output the 3rd digit
	call	mult0A		; calculate and output the 4th digit
	goto	setup

carryb	movlw	0x1
	addwf	carry		; carry bit + 1
	return

	;step 2-4 of the algorithm, taking away mul 4, using the remaining 3 byte
	;hex number(mul 3 mul 2 mul 1) * 0x0A to output the next digit to LCD
mult0A	movf	mul1, W		
	mullw	0x0A		; mul 1 * 0x0A
	movff	PRODL, mul1	; product's low byte is the last byte of the result
	movff	PRODH, mul12	; product's high byte stores to mul 12
	movf	mul2, W
	mullw	0x0A		; mul 2 * 0x0A
	movff	PRODL, mul22	; product's low byte stores to mul 22
	movff	PRODH, mul23	; product's high byte stores to mul 23
	movf	mul3, W
	mullw	0x0A		; mul 3 * 0x0A
	movff	PRODL, mul33	; product's low byte stores to mul 33
	movff	PRODH, mul34	; product's high byte stores to mul 34
	movff	mul12, mul2	; sum up corresponding elements
	movf	mul2, W		; to calculate the 2nd byte in the result
	addwf	mul22, W	; mul 12 + mul 22 + mul 32 to mul 2
	movwf	mul2
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movff	carry, mul3	; calculate the 3rd byte in the result
	clrf	carry		; clear carry
	movf	mul3, W		; carry + mul 23 + mul 33 + mul 43 to mul 3
	addwf	mul23, W
	movwf	mul3
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movf	mul3, W
	addwf	mul33, W
	movwf	mul3
	btfsc	STATUS, C	; check for carry bit after addition
	call	carryb		; carry +1 if carry flag is 1
	movff	carry, mul4	; calculate the 4th byte in the result
	clrf	carry		; clear carry
	movf	mul4, W		; carry + mul 44 to mul 4
	addwf	mul34, W
	call	LCD_Write_Dec	; output the next digit (in mul 4) to LCD
	return
	
	end