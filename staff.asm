#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex			    ; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	LCD_delay_ms
	extern  position_check, motor_setup, motor_start, motor_for, motor_back
	extern 	motor_stop, pluck_motor,left_shift_high, right_shift_low
	extern	note_A, note_B, note_C, note_D, note_E, note_F, note_G, 
	extern  note_#A, note_#B, note_#C, note_#D, note_#E, note_#F, note_#G

acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
xtmp	    res 1
postmp	    res 1
ifplucked   res 1
   
rst	code	0    ; reset vector
	goto	setup	
main	code
	
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	motor_setup	

main	code
	
	call note_A
	;DELAY
	call note_B
	;delay
	call note_C

