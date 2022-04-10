.byte $01, $08 ; .PRG header
* = $0801
; SYS 2061
.byte $0B, $08, $0A, $00, $9E, $32, $30, $36, $31, $00, $00, $00
* = $080d

CNT1 = $2a
CNT2 = $2b
#define CNT2_VAL #$b0

main:
	lda	#%10101000
	sta	$d018

	lda	#$00
	sta	$d020
	sta	$d021

	lda	#$13
	sta	$0286

	lda	#$0
	sta	CNT1
	lda	CNT2_VAL
	sta	CNT2
loop:
	; lda	$d020
	; clc
	; adc	#$1
	; sta	$d020

	; lda	CNT1
	; clc
	; adc	#$1
	; sta	CNT1
	; bcc	loop

	; lda	CNT2
	; clc
	; adc	#$1
	; sta	CNT2
	; bcc	loop

	; lda	CNT2_VAL
	; sta	CNT2

	; lda	$d021
	; clc
	; adc	#$1
	; sta	$d021

	; inc	$2000,x
	; inx

	jsr	WaitKeyRelease
	jsr	WaitKeyPress

	; Clear player
	clc
	lda	playerPos
	adc	#<MAP
	sta	$fc
	lda	playerPos+1
	adc	#>MAP
	sta	$fd
	ldx	#0
	lda	#0
	sta	($fc,x)

	; Up
	lda	#%0001
	bit	$dc01
	beq	GoUp
	; Down
	lda	#%0010
	bit	$dc01
	beq	GoDown
	; Left
	lda	#%0100
	bit	$dc01
	beq	GoLeft
	; Right
	lda	#%1000
	bit	$dc01
	beq	GoRight

GoUp:
	sec
	lda	playerPos
	sbc	#40
	sta	playerPos
	lda	playerPos+1
	sbc	#$00
	sta	playerPos+1
	jmp	GoAfter
GoDown:
	clc
	lda	playerPos
	adc	#40
	sta	playerPos
	lda	playerPos+1
	adc	#$00
	sta	playerPos+1
	jmp	GoAfter
GoLeft:
	sec
	lda	playerPos
	sbc	#$01
	sta	playerPos
	lda	playerPos+1
	sbc	#$00
	sta	playerPos+1
	jmp	GoAfter
GoRight:
	clc
	lda	playerPos
	adc	#$01
	sta	playerPos
	lda	playerPos+1
	adc	#$00
	sta	playerPos+1
	jmp	GoAfter
GoAfter:

	; Draw player
	clc
	lda	playerPos
	adc	#<MAP
	sta	$fc

	lda	playerPos+1
	adc	#>MAP
	sta	$fd

	ldx	#$0;playerPos
	lda	#4
	sta	($fc,x)
	; lda	($fc,x)
	; clc
	; adc	#$1
	; sta	($fc,x)

	jmp	loop

WaitKeyPress:
	lda	#$FF
	cmp	$DC01
	beq	WaitKeyPress
	rts
WaitKeyRelease:
	lda	#$FF
	cmp	$DC01
	bne	WaitKeyRelease
	rts

DATA:
	playerPos .word 41

#include"gfx.asm"