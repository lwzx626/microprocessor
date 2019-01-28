	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_delay_ms	    ; external LCD subroutines

	code
	org 0x0
	banksel PADCFG1
	goto	setup

setup	bsf PADCFG1, REPU, BANKED   ;Set the pull-ups to on for PORTE
	goto start

start	clrf LATE		    ;Write 0s to the LATE register 
	movlw 0x0F
	movwf TRISE		    ;PORTE 4-7 outputs and PORTE 0-3 inputs
	movlw 0x00
	movwf TRISD		    ;PORTD all outputs
	movlw .10
	call LCD_delay_ms
	movff PORTE, PORTD	    ;output column to PORTD
	movlw 0xF0
	movwf TRISE		    ;PORTE 0-3 outputs and PORTE 4-7 inputs
	movlw .10
	call LCD_delay_ms
	movf PORTE, 0		    ;output row to W
	addwf PORTD		    ;add W to column and output to PORTD 
	goto start

	end