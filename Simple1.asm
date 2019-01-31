	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message, LCD_delay_ms, LCD_Send_Byte_D	    ; external LCD subroutines

main	code
	org 0x0
	banksel PADCFG1
	goto	setup

setup	call	LCD_Setup	; setup LCD
	bsf PADCFG1, REPU, BANKED   ;Set the pull-ups to on for PORTE
	goto start

start	movlw .200
	call LCD_delay_ms
	clrf LATE		    ;Write 0s to the LATE register 
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

checkA	movlw 0x6E
	CPFSEQ PORTD
	goto checkB
	movlw "A"
	call LCD_Send_Byte_D
	goto start
checkB	movlw 0x6A
	CPFSEQ PORTD
	goto checkC
	movlw "B"
	call LCD_Send_Byte_D
	goto start
checkC	movlw 0x66
	CPFSEQ PORTD
	goto checkD
	movlw "C"
	call LCD_Send_Byte_D
	goto start
checkD	movlw 0xA6
	CPFSEQ PORTD
	goto checkE
	movlw "D"
	call LCD_Send_Byte_D
	goto start
checkE	movlw 0xC6
	CPFSEQ PORTD
	goto checkF
	movlw "E"
	call LCD_Send_Byte_D
	goto start
checkF	movlw 0xE6
	CPFSEQ PORTD
	goto check1
	movlw "F"
	call LCD_Send_Byte_D
	goto start
check1	movlw 0xEE
	CPFSEQ PORTD
	goto check2
	movlw "1"
	call LCD_Send_Byte_D
	goto start
check2	movlw 0xED
	CPFSEQ PORTD
	goto check3
	movlw "2"
	call LCD_Send_Byte_D
	goto start
check3	movlw 0xEB
	CPFSEQ PORTD
	goto checkad
	movlw "3"
	call LCD_Send_Byte_D
	goto start
checkad	movlw 0xE7
	CPFSEQ PORTD
	goto check4
	movlw "+"
	call LCD_Send_Byte_D
	goto start
check4	movlw 0xDE
	CPFSEQ PORTD
	goto check5
	movlw "4"
	call LCD_Send_Byte_D
	goto start
check5	movlw 0xDD
	CPFSEQ PORTD
	goto check6
	movlw "5"
	call LCD_Send_Byte_D
	goto start
check6	movlw 0xDB
	CPFSEQ PORTD
	goto checksu
	movlw "6"
	call LCD_Send_Byte_D
	goto start
checksu	movlw 0xD7
	CPFSEQ PORTD
	goto check7
	movlw "-"
	call LCD_Send_Byte_D
	goto start
check7	movlw 0xBE
	CPFSEQ PORTD
	goto check8
	movlw "7"
	call LCD_Send_Byte_D
	goto start
check8	movlw 0xBD
	CPFSEQ PORTD
	goto check9
	movlw "8"
	call LCD_Send_Byte_D
	goto start
check9	movlw 0xBB
	CPFSEQ PORTD
	goto checkmu
	movlw "9"
	call LCD_Send_Byte_D
	goto start
checkmu	movlw 0xB7
	CPFSEQ PORTD
	goto checkcl
	movlw "*"
	call LCD_Send_Byte_D
	goto start
checkcl	movlw 0x7E
	CPFSEQ PORTD
	goto check0
	;movlw "A"
	;call LCD_Send_Byte_D
	goto setup
check0	movlw 0x7D
	CPFSEQ PORTD
	goto checkeq
	movlw "0"
	call LCD_Send_Byte_D
	goto start
checkeq	movlw 0x7B
	CPFSEQ PORTD
	goto checkdi
	movlw "="
	call LCD_Send_Byte_D
	goto start
checkdi	movlw 0x77
	CPFSEQ PORTD
	goto start
	movlw "/"
	call LCD_Send_Byte_D
	goto start
	
	end
