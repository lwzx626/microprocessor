	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Hex	; external LCD subroutines
	extern  ADC_Read			; external ADC routines
	extern	LCD_delay_ms
	global	position_check, pluck_motor, motor_setup
	global	note_D1, note_E1, note_F1, note_G1, note_A1, note_B1, note_C1 
	global  note_D2, note_E2, note_F2, note_G2, note_A2, note_B2, note_C2
	global	note_D3

acs0    udata_acs   ; named variables in access ram
xtmp	res 1
postmp	res 1

notes	code

position_check
	call	LCD_Setup
	call	ADC_Read	;mearsure the feedback from potentiometer
	call	left_shift_high	;
	movlw	0xF0		; 
	andwf	ADRESL		;take the first 4 low bits
	call	right_shift_low ;
	iorwf	ADRESH, W	;Combine with high bits to make hhhhLLLL
	movwf	xtmp		;xtmp stores current reading 
	call	LCD_Write_Hex	;Convert bits stored in W to hex and send to LCD
	movlw	0x1		;buffer region 0xB6 - 0xBC
	subwf	postmp, W	;0xB5 to W
	cpfsgt	xtmp		;if current pos > 0x60, then check if it < 0x80
	goto	motor_for	;if current pos < 0x60, move towards buffer
	movlw	0x1		;
	addwf	postmp, W	;0xBB to W
	cpfslt	xtmp		;if 60< current pos < 0x80, then stop moving,
	goto	motor_back	;if current pos > 0x80, move towards buffer
	call	motor_stop	;stop and pluck
	return
	
motor_setup
	clrf	TRISE
	clrf	PORTE
	return

motor_for
	bcf	PORTE, 0	;
	nop
	bsf     PORTE, 1
	goto	position_check

motor_back
	bsf	PORTE, 0
	nop
	bsf     PORTE, 1
	goto	position_check

motor_stop
	bcf	PORTE, 1
	return

pluck_motor
	bsf	PORTE, 2
	movlw	0x2D
	call	LCD_delay_ms
	bcf	PORTE, 2
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

note_D1	movlw 0xD2
	movwf postmp
	call position_check
	call pluck_motor
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

	
	