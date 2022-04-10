;.byte $00, $10
.byte $01, $08

* = $0801

;.asc "sys 4096"

.dsb $1000 - *

main:
	lda	#$0
	sta	$2a
loop:
	lda	$d020
	clc
	adc	#$1
	sta	$d020

	lda	$2a
	clc
	adc	#$1
	sta	$2a
	bcc	loop
	
	lda	$d021
	clc
	adc	#$1
	sta	$d021

	jmp	loop
