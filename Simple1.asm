	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw 	0x0
	movwf	TRISD, ACCESS	    ; Port D all outputs
	movwf	TRISC, ACCESS	    ; Port C all outputs
	movwf	TRISH, ACCESS	    ; Port H all outputs
	movlw   0xF
	movwf   PORTD, ACCESS	    ; Set oe1, oe2 and cp1, cp2 to high
	clrf    TRISE		    ; Put port E on the bus
	movlw   0xCD
	movwf   LATE, ACCESS
	movlw   0xD
	movwf   PORTD, ACCESS	    ; Lower cp1
	movlw   0xF
	movwf   PORTD, ACCESS	    ; Raise cp1
	movlw   0xAA	    
	movwf   LATE, ACCESS	    ; Write data to memory
	movlw   0x7
	movwf   PORTD, ACCESS	    ; Lower cp2
	movlw   0xF
	movwf   PORTD, ACCESS	    ; Raise cp2
	setf    TRISE		    ; Take port E off the bus
	movlw   0xE
	movwf   PORTD, ACCESS	    ; Lower oe1
	movlw   0xC
	movwf   PORTD, ACCESS	    ; Lower cp1
	movff   PORTE, PORTC	    ; OUTPUT at PORTC
	movlw   0xE
	movwf   PORTD, ACCESS	    ; Raise cp1
	movlw   0xF
	movwf   PORTD, ACCESS	    ; Raise oe1
	movlw   0xB
	movwf   PORTD, ACCESS	    ; Lower oe2
	movlw   0x3
	movwf   PORTD, ACCESS	    ; Lower cp2
	movff   PORTE, PORTH	    ; Output at PORTH
	movlw   0xB
	movwf   PORTD, ACCESS	    ; Raise cp2
	movlw   0xF
	movwf   PORTD, ACCESS	    ; Raise oe2
	clrf    TRISE		    ; Take port E off the bus
	
	
	goto start

	end
