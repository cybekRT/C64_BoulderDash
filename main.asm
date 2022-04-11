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
loop:
	jsr	WaitKeyRelease
	jsr	WaitKeyPress

	jsr	PlayerMove

	; Clear old player
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

	jsr	PlayerCanMove

	; Draw player
	clc
	lda	playerPos
	adc	#<MAP
	sta	$fc

	lda	playerPos+1
	adc	#>MAP
	sta	$fd

	ldx	#$0
	lda	#4
	sta	($fc,x)
	; lda	($fc,x)
	; clc
	; adc	#$1
	; sta	($fc,x)

	; Draw score
	clc
	lda	#$b0
	adc	score
	sta	MAP+(24 * 40 + 9)

	jmp	loop

PlayerMove:
.(
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
	sta	playerPosNew
	lda	playerPos+1
	sbc	#$00
	sta	playerPosNew+1
	jmp	GoAfter
GoDown:
	clc
	lda	playerPos
	adc	#40
	sta	playerPosNew
	lda	playerPos+1
	adc	#$00
	sta	playerPosNew+1
	jmp	GoAfter
GoLeft:
	sec
	lda	playerPos
	sbc	#$01
	sta	playerPosNew
	lda	playerPos+1
	sbc	#$00
	sta	playerPosNew+1
	jmp	GoAfter
GoRight:
	clc
	lda	playerPos
	adc	#$01
	sta	playerPosNew
	lda	playerPos+1
	adc	#$00
	sta	playerPosNew+1
	jmp	GoAfter
GoAfter:
	rts
.)

PlayerCanMove:
.(
	lda	playerPosNew
	adc	#<MAP
	sta	$fc
	lda	playerPosNew+1
	adc	#>MAP
	sta	$fd
	ldx	#0
	lda	($fc,x)

	cmp	#$20
	beq	Ret
	cmp	#$10
	bpl	CannotMove
	cmp	#3
	beq	Diamond
	cmp	#5
	beq	Door
	jmp	Ret

Diamond:
	inc	score
	jmp	Ret
Door:
	lda	score
	cmp	#9
	beq	FinishGame
	jmp	CannotMove
CannotMove:
	lda	playerPos
	sta	playerPosNew
	lda	playerPos+1
	sta	playerPosNew+1
	jmp	Ret
Ret:
	lda	playerPosNew
	sta	playerPos
	lda	playerPosNew+1
	sta	playerPos+1
	rts
.)

FinishGame:
	lda	#$86
	sta	MAP+(24 * 40 + 7)
	lda	#$89
	sta	MAP+(24 * 40 + 8)
	lda	#$8E
	sta	MAP+(24 * 40 + 9)
	jmp	*

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
	playerPosNew .word 41
	score .byte 0

#include"gfx.asm"