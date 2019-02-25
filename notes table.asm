	#include p18f87k22.inc

	extern	position_check, motor_setup, motor_start, motor_for, motor_back
	extern	motor_stop, pluck_motor,left_shift_high, right_shift_low
	global	note_A, note_B, note_C, note_D, note_E, note_F, note_G, 
	global  note_#A, note_#B, note_#C, note_#D, note_#E, note_#F, note_#G

notes	code
	
note_A	movlw 0xAC
	movwf postmp
	call position_check
	call pluck_motor
	
note_B  movlw 0xCA
	movwf postmp
	call position_check
	call pluck_motor

note_C  movlw 0xC1
	movwf postmp
	call position_check
	call pluck_motor
	
note_D  movlw 0xB2
	movwf postmp
	call position_check
	call pluck_motor
	
note_E  movlw 0xBF
	movwf postmp
	call position_check
	call pluck_motor
	
note_F  movlw 0x
	movwf postmp
	call position_check
	call pluck_motor
	
note_G  movlw 0x
	movwf postmp
	call position_check
	call pluck_motor

note_#A movlw 0x
	movwf postmp
	call position_check
	call pluck_motor
	
note_#B movlw 0x
	movwf postmp
	call position_check
	call pluck_motor

note_#C movlw 0x
	movwf postmp
	call position_check
	call pluck_motor

note_#D movlw 0x
	movwf postmp
	call position_check
	call pluck_motor
	
note_#E movlw 0x
	movwf postmp
	call position_check
	call pluck_motor

note_#G movlw 0x
	movwf postmp
	call position_check
	call pluck_motor
