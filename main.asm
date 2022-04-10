;.byte $00, $10
.byte $01, $08

CNT1 = $2a
CNT2 = $2b
#define CNT2_VAL #$b0

* = $0801

;.asc "sys 4096"

.dsb $1000 - *

main:
	lda	#$0
	sta	CNT1
	lda	CNT2_VAL
	sta	CNT2
loop:
	lda	$d020
	clc
	adc	#$1
	sta	$d020

	lda	CNT1
	clc
	adc	#$1
	sta	CNT1
	bcc	loop

	lda	CNT2
	clc
	adc	#$1
	sta	CNT2
	bcc	loop

	lda	CNT2_VAL
	sta	CNT2
	
	lda	$d021
	clc
	adc	#$1
	sta	$d021

	jmp	loop
