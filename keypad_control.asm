#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Hex	; external LCD subroutines
	extern  ADC_Read, ADC_Setup, LCD_Send_Byte_D	; external ADC routines
	extern	LCD_delay_ms
	extern	position_check, pluck_motor, motor_setup
	extern	note_D1, note_E1, note_F1, note_G1, note_A1, note_B1, note_C1 
	extern  note_D2, note_E2, note_F2, note_G2, note_A2, note_B2, note_C2
	extern	note_D3
	extern	staff

main	code	0
	banksel PADCFG1
	goto	setup

setup	call	LCD_Setup	; setup LCD
	call	motor_setup
	bsf	PADCFG1, RJPU, BANKED   ;Set the pull-ups to on for PORTE
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	ADC_Setup	; setup ADC

start	movlw	.200
	call	LCD_delay_ms
	clrf	TRISD
	clrf	LATJ		    ;Write 0s to the LATE register
	movlw	0x0F
	movwf	TRISJ		    ;PORTE 4-7 outputs and PORTE 0-3 inputs
	movlw	.10
	call	LCD_delay_ms
	movff	PORTJ, PORTD	    ;output column to PORTD
	movlw	0xF0
	movwf	TRISJ		    ;PORTE 0-3 outputs and PORTE 4-7 inputs
	movlw	.10
	call	LCD_delay_ms
	movf	PORTJ, W	    ;output row to W
	addwf	PORTD		    ;add W to column and output to PORTD

checkA	movlw	0x7E
	CPFSEQ	PORTD
	goto	checkB
	movlw	"A"
	call	LCD_Send_Byte_D
	call	note_B2
	goto	start
checkB	movlw	0x7B
	CPFSEQ	PORTD
	goto	checkC
	movlw	"B"
	call	LCD_Send_Byte_D
	call	note_C2
	goto	start
checkC	movlw	0x77
	CPFSEQ	PORTD
	goto	checkD
	movlw	"C"
	call	LCD_Send_Byte_D
	call	staff
	goto	start
checkD	movlw	0xB7
	CPFSEQ	PORTD
	goto	checkE
	movlw	"D"
	call	LCD_Send_Byte_D
	call	note_A2
	goto	start
checkE	movlw	0xD7
	CPFSEQ	PORTD
	goto	checkF
	movlw	"E"
	call	LCD_Send_Byte_D
	call	note_D2
	goto	start
checkF	movlw	0xE7
	CPFSEQ	PORTD
	goto	check1
	movlw	"F"
	call	LCD_Send_Byte_D
	call	note_G1
	goto	start
check1	movlw	0xEE
	CPFSEQ	PORTD
	goto	check2
	movlw	"E"
	call	LCD_Send_Byte_D
	call	note_D1
	goto	start
check2	movlw	0xED
	CPFSEQ	PORTD
	goto	check3
	movlw	"D"
	call	LCD_Send_Byte_D
	call	note_E1
	goto	start
check3	movlw	0xEB
	CPFSEQ	PORTD
	goto	check4
	movlw	"G"
	call	LCD_Send_Byte_D
	call	note_F1
	goto	start
check4	movlw	0xDE
	CPFSEQ	PORTD
	goto	check5
	movlw	"F"
	call	LCD_Send_Byte_D
	call	note_A1
	goto	start
check5	movlw	0xDD
	CPFSEQ	PORTD
	goto	check6
	movlw	"A"
	call	LCD_Send_Byte_D
	call	note_B1
	goto	start
check6	movlw	0xDB
	CPFSEQ	PORTD
	goto	check7
	movlw	"B"
	call	LCD_Send_Byte_D
	call	note_C1
	goto	start
check7	movlw	0xBE
	CPFSEQ	PORTD
	goto	check8
	movlw	"G"
	call	LCD_Send_Byte_D
	call	note_E2
	goto	start
check8	movlw	0xBD
	CPFSEQ	PORTD
	goto	check9
	movlw	"C"
	call	LCD_Send_Byte_D
	call	note_F2
	goto	start
check9	movlw	0xBB
	CPFSEQ	PORTD
	goto	check0
	movlw	"D"
	call	LCD_Send_Byte_D
	call	note_G2
	goto	start
check0	movlw	0x7D
	CPFSEQ	PORTD
	goto	start
	movlw	"0"
	call	LCD_Send_Byte_D
	call	note_C2
	goto	start
	
	end



