	#include p18f87k22.inc

	extern  LCD_Curser_1, LCD_Curser_2, LCD_Write_Hex	
	extern  ADC_Read			
	extern	LCD_delay_ms, LCD_Setup
	global	position_check, pluck_motor, motor_setup
	global	note_D1, note_E1, note_F1, note_G1, note_A1, note_B1, note_C1 
	global  note_D2, note_E2, note_F2, note_G2, note_A2, note_B2, note_C2
	global	note_D3
	
acs0    udata_acs   ; named variables in access ram
xtmp	res 1	    ; current position
postmp	res 1	    ; the destination's position

notes	code
;the core sub-routine which compares xtmp with postmp to determine the ruler's motion  
position_check			
	;call	LCD_Setup
	call	LCD_Curser_2	;write the feedback voltage to 2nd row of LCD
	call	ADC_Read	;mearsure the feedback from potentiometer
	call	left_shift_high	;at the bottom of the page
	movlw	0xF0		; 
	andwf	ADRESL		;take the first 4 low bits
	call	right_shift_low ;at the bottom of the page
	iorwf	ADRESH, W	;Combine with high bits to make hhhhLLLL
	movwf	xtmp		;stores current feedback voltage reading  
	call	LCD_Write_Hex	;Convert bits stored in W to hex and send to LCD
	movlw	0x1		;adding a buffer zone of +-1 to the destination
	subwf	postmp, W	;lower bound of the buffer zone
	cpfsgt	xtmp		;Check if ruler passes lower bound of buffer
	goto	motor_for	;if not then push the ruler longer 
	movlw	0x1		;if yes then check if it exceeds the upper bound
	addwf	postmp, W	;upper bound of the buffer zone
	cpfslt	xtmp		;Check if ruler exceeds the upper bound of buffer
	goto	motor_back	;if yes then pull the ruler shorter
	call	motor_stop	;stop if the ruler is within the buffer zone
	call	LCD_Curser_1	;Write the current note to 1st row of LCD
	return
	
motor_setup
	clrf	TRISE		;PORT E all output
	clrf	PORTE		;reset PORT E	
	return

motor_for
	bcf	PORTE, 0	;0th bit controls diretion
	nop			;need time for settling the data on PORT E 
	bsf     PORTE, 1	;1st bit controls the switch of the driving motor 
	goto	position_check	;recheck position

motor_back
	bsf	PORTE, 0	;similar as motor_for
	nop
	bsf     PORTE, 1
	goto	position_check

motor_stop
	bcf	PORTE, 1	;switch off the driving motor
	return

pluck_motor
	bsf	PORTE, 2	;2nd bit controls the switch of the plucking motor
	movlw	0x2D		;motor on for 45ms
	call	LCD_delay_ms	;
	bcf	PORTE, 2	;then switch off to prevent plucking several times
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

note_D1	movlw 0xD2		;Store note's position
	movwf postmp		;to postmp
	call position_check	;drive the ruler to the note's position	
	call pluck_motor	;then pluck
	return
	
note_E1 movlw 0xCE
	movwf postmp
	call position_check
	call pluck_motor
	return

note_F1 movlw 0xCC
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_G1 movlw 0xC7
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_A1 movlw 0xC3
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_B1 movlw 0xC0
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_C1 movlw 0xBE
	movwf postmp
	call position_check
	call pluck_motor
	return

note_D2 movlw 0xBA
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_E2 movlw 0xB7
	movwf postmp
	call position_check
	call pluck_motor
	return

note_F2 movlw 0xB6
	movwf postmp
	call position_check
	call pluck_motor
	return

note_G2 movlw 0xB4
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_A2 movlw 0xB2
	movwf postmp
	call position_check
	call pluck_motor
	return

note_B2 movlw 0xAF
	movwf postmp
	call position_check
	call pluck_motor
	return

note_C2 movlw 0xAD
	movwf postmp
	call position_check
	call pluck_motor
	return
	
note_D3	movlw 0xAC
	movwf postmp
	call position_check
	call pluck_motor
	return
	
	end

	
	
