	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex			    ; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	LCD_delay_ms

acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
xtmp	    res 1
postmp	    res 1
ifplucked   res 1

rst	code	0    ; reset vector
	goto	setup
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	motor_setup

position_check
	movlw	0xB8		;record- 
	movwf	postmp		;a note value
	call	ADC_Read	;mearsure the feedback from potentiometer
	call	left_shift_high	;
	movlw	0xF0		; 
	andwf	ADRESL		;take the first 4 low bits
	call	right_shift_low ;
	iorwf	ADRESH, W	;Combine with high bits to make hhhhLLLL
	movwf	xtmp		;xtmp stores current reading 
	;movf	xtmp, W		;
	call	LCD_Write_Hex	;Convert bits stored in W to hex and send to LCD
	movlw	0x1		;buffer region 0xB6 - 0xBC
	subwf	postmp, W	;0xB5 to W
	cpfsgt	xtmp		;if current pos > 0x60, then check if it < 0x80
	goto	motor_back	;if current pos < 0x60, move towards buffer
	movlw	0x1		;
	addwf	postmp, W	;0xBB to W
	cpfslt	xtmp		;if 60< current pos < 0x80, then stop moving,
	goto	motor_for	;if current pos > 0x80, move towards buffer
	call	motor_stop	;stop and pluck
	goto	setup
	
motor_setup
	clrf	TRISE
	clrf	PORTE
	return
motor_start
	bsf	PORTE, 1
	clrf	ifplucked
	return
motor_for
	bsf	PORTE, 0	;
	call	motor_start
	goto	setup
motor_back
	bcf	PORTE, 0
	call	motor_start
	goto	setup
motor_stop
	bcf	PORTE, 1
	btfss	ifplucked, 0
	call	pluck_motor
	return
pluck_motor
	bsf	PORTE, 2
	movlw	0x2F
	call	LCD_delay_ms
	bcf	PORTE, 2
	setf	ifplucked
	return
left_shift_high
	rlcf	ADRESH		;Left shift high bits for 4 positions
	rlcf	ADRESH		;
	rlcf	ADRESH		;   
	rlcf	ADRESH		;so hight bits are hhhh 0000   
	return
right_shift_low
	rrcf	ADRESL		;right shift for 4 positions
	rrcf	ADRESL		;so low bits are 0000LLLL,ignoring the last four
	rrcf	ADRESL		;because we don't need such high accuracy
	rrcf	ADRESL, W	;store low bits to W
	return
	end
