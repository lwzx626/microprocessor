#include p18f87k22.inc

;	extern  LCD_Setup, LCD_delay_ms	; external LCD subroutines
;	extern  ADC_Setup		; external ADC routines
;	extern  motor_setup
;	extern	note_D1, note_E1, note_F1, note_G1, note_A1, note_B1, note_C1 
;	extern  note_D2, note_E2, note_F2, note_G2, note_A2, note_B2, note_C2
;	extern	note_D3

;rst	code	0    ; reset vector
;	goto	setup

start	code	

;setup	bcf	EECON1, CFGS	; point to Flash program memory  
;	bsf	EECON1, EEPGD 	; access Flash program memory
;	call	LCD_Setup	; setup LCD
;	call	ADC_Setup	; setup ADC
;	call	motor_setup	

;main	movlw	0xAB
;	call	note_C1
;	movlw	0xFF
;	call	LCD_delay_ms
;	call	note_C1
;	movlw	0xFF
;	call	LCD_delay_ms
;	goto	main
	end

