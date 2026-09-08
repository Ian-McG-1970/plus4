; Target assembler: 64tass v1.56.2625 [--ascii --case-sensitive -Wall]
; 6502bench SourceGen v1.8.3
        .cpu    "6502"
SETLFS  =       $FFBA      ;set logical file parameters
SETNAM  =       $FFBD      ;set filename
OPEN    =       $FFC0      ;($031A/iopen) open logical file
CLOSE   =       $FFC3      ;($031C/iclose) close logical file


*       =       $1010
        lda     $FF02      ;4
        sta     $FA49      ;4
        sei                ;2
        sta     $FF3F      ;4
        jsr     L14B7      ;6
L101D   sei                ;2
        sta     $FF3F      ;4
        jsr     LCA9A      ;6
        jsr     $FB59      ;6
        lda     #$00       ;2
        sta     L60E6      ;4
        lda     #$00       ;2
        jsr     $0200      ;6
        jsr     LCB91      ;6
        jsr     LCB16      ;6
        lda     #$08       ;2
        sta     $FF12      ;4
        lda     #$E8       ;2
        sta     $FF13      ;4
        lda     $FF07      ;4
        and     #$40       ;2
        ora     #$98       ;2
        sta     $FF07      ;4
        lda     #$51       ;2
        sta     $FF15      ;4
        lda     #$F1       ;2
        sta     $FF17      ;4
        lda     #$00       ;2
        sta     $FF16      ;4
        lda     #$00       ;2
        sta     $FF19      ;4
        lda     #$0C       ;2
        sec                ;2
        sbc     #$04       ;2
        sta     $FF14      ;4
        lda     L1376      ;4
        sta     $FFFE      ;4
        lda     L1377      ;4
        sta     $FFFF      ;4
        lda     #$D0       ;2
        sta     $FF0B      ;4
        lda     $FF0A      ;4
        and     #$FE       ;2
        sta     $FF0A      ;4
        ldx     #$00       ;2
_L1082  lda     LE800,x    ;4+
        sta     $F000,x    ;5
        lda     LE900,x    ;4+
        sta     $F100,x    ;5
        lda     LEA00,x    ;4+
        sta     $F200,x    ;5
        lda     LEB00,x    ;4+
        sta     $F300,x    ;5
        lda     LEC00,x    ;4+
        sta     $F400,x    ;5
        lda     LED00,x    ;4+
        sta     $F500,x    ;5
        lda     LEE00,x    ;4+
        sta     $F600,x    ;5
        lda     LEF00,x    ;4+
        sta     $F700,x    ;5
        inx                ;2
        bne     _L1082     ;2+
        jsr     LCADC      ;6
        jsr     $FA2D      ;6
        lda     #$00       ;2
        sta     LD769      ;4
        jsr     $F9FF      ;6
        lda     #$01       ;2
        sta     LD761      ;4
        lda     #$04       ;2
        sta     LD762      ;4
        ldx     #$00       ;2
        txa                ;2
_L10D0  sta     LBDB8,x    ;5
        inx                ;2
        cpx     #$14       ;2
        bne     _L10D0     ;2+
        lda     #$01       ;2
        sta     LBDB8      ;4
        sta     LBDB9      ;4
        jsr     LC573      ;6
        ldx     #$00       ;2
        lda     #$01       ;2
_L10E7  sta     LBD5E,x    ;5
        inx                ;2
        cpx     #$5A       ;2
        bne     _L10E7     ;2+
        lda     #$FF       ;2
        sta     LAD9C      ;4
        lda     #$CD       ;2
        sta     LADBC      ;4
        lda     #$EE       ;2
        sta     LADDC      ;4
        lda     #$00       ;2
        sta     LBB40      ;4
        lda     #$00       ;2
        sta     L60DE      ;4
        sta     L60DF      ;4
        lda     #$00       ;2
        sta     L60E4      ;4
        lda     #$01       ;2
        sta     LCBFA+1    ;4
        lda     #$22       ;2
        sta     LCBFC      ;4
        lda     #$BB       ;2
        sta     LCBFC+1    ;4
        lda     #$01       ;2
        sta     L70EA      ;4
        lda     #$01       ;2
        jsr     L6798      ;6
        lda     #$1B       ;2
        jsr     LDD20      ;6
        cli                ;2
_L112F  lda     #$01       ;2
        sta     L1247      ;4
        lda     #$E4       ;2
        sta     L1248      ;4
        lda     #$02       ;2
        jsr     LA346      ;6
        lda     #$00       ;2
        jsr     LA346      ;6
        lda     #$01       ;2
        jsr     LA346      ;6
        jsr     L1440      ;6
        jsr     L124A      ;6
        lda     #$01       ;2
        jsr     LA76E      ;6
        lda     #$00       ;2
        jsr     LA76E      ;6
        lda     #$02       ;2
        jsr     LA76E      ;6
_L115D  lda     L1375      ;4
        cmp     #$01       ;2
        beq     _L115D     ;2+
        bcc     _L115D     ;2+
        clc                ;2
        adc     #$01       ;2
        sta     L1373      ;4
_L116C  lda     $FF1D      ;4
        cmp     #$12       ;2
        bcc     _L116C     ;2+
        lda     #$00       ;2
        sta     L1375      ;4
        lda     #$E4       ;2
        sec                ;2
        sbc     #$04       ;2
        sta     $FF14      ;4
        lda     #$F0       ;2
        sta     $FF13      ;4
        sta     L137E      ;4
        lda     #$00       ;2
        sta     L1247      ;4
        lda     #$0C       ;2
        sta     L1248      ;4
        lda     #$02       ;2
        jsr     LA2F4      ;6
        lda     #$00       ;2
        jsr     LA2F4      ;6
        lda     #$01       ;2
        jsr     LA2F4      ;6
        jsr     L1440      ;6
        jsr     L124A      ;6
        lda     #$01       ;2
        jsr     LA398      ;6
        lda     #$00       ;2
        jsr     LA398      ;6
        lda     #$02       ;2
        jsr     LA398      ;6
_L11B6  lda     L1375      ;4
        cmp     #$01       ;2
        beq     _L11B6     ;2+
        bcc     _L11B6     ;2+
        clc                ;2
        adc     #$01       ;2
        sta     L1373      ;4
_L11C5  lda     $FF1D      ;4
        cmp     #$12       ;2
        bcc     _L11C5     ;2+
        lda     #$00       ;2
        sta     L1375      ;4
        lda     #$0C       ;2
        sec                ;2
        sbc     #$04       ;2
        sta     $FF14      ;4
        lda     #$E8       ;2
        sta     $FF13      ;4
        sta     L137E      ;4
        lda     L60E6      ;4
        bne     _L120E     ;3+
        lda     #$BF       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        lda     $FF08      ;4
        cmp     #$EF       ;2
        beq     _L120E     ;3+
        lda     L60D9      ;4
        cmp     #$00       ;2
        bne     _L120B     ;3+
        lda     #$FE       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        lda     $FF08      ;4
        cmp     #$BF       ;2
        beq     _L120E     ;2+
_L120B  jmp     _L112F     ;3

_L120E  lda     L1249      ;4
        beq     _L1219     ;2+
        jsr     _L1224     ;6
        jmp     _L112F     ;3

_L1219  lda     #$0B       ;2
        jsr     LDD20      ;6
        jsr     LDE04      ;6
        jmp     L101D      ;3

_L1224  lda     #$00       ;2
        sta     L1249      ;4
        jsr     L122F      ;6
        jmp     LDE04      ;3

L122F   ldx     #$00       ;2
_L1231  lda     #$35       ;2
        sta     $0C28,x    ;5
        sta     LE428,x    ;5
        lda     #$88       ;2
        sta     $0828,x    ;5
        sta     LE028,x    ;5
        inx                ;2
        cpx     #$28       ;2
        bne     _L1231     ;2+
        rts                ;6

L1247   .byte   $00
L1248   .byte   $00
L1249   .byte   $01

L124A   lda     L1249      ;4
        bne     _L1250     ;2+
        rts                ;6

_L1250  ldx     #$01       ;2
        lda     L60DA      ;4
        beq     _L1259     ;2+
        ldx     #$02       ;2
_L1259  stx     _L1357     ;4
        ldx     #$01       ;2
        lda     L7DEF      ;4
        beq     _L1265     ;2+
        ldx     #$02       ;2
_L1265  stx     _L1358     ;4
        ldx     #$01       ;2
        lda     L7249      ;4
        beq     _L1271     ;2+
        ldx     #$02       ;2
_L1271  stx     _L1359     ;4
        lda     L60DC      ;4
        clc                ;2
        adc     #$01       ;2
        sta     _L135B     ;4
        lda     L7DF2      ;4
        clc                ;2
        adc     #$01       ;2
        sta     _L135C     ;4
        lda     L724C      ;4
        clc                ;2
        adc     #$01       ;2
        sta     _L135D     ;4
        lda     LBB3F      ;4
        sec                ;2
        sbc     LBB3E      ;4
        ldx     #$12       ;2
        jsr     _L1338     ;6
        lda     LAD84      ;4
        ldx     #$05       ;2
        jsr     _L1338     ;6
        lda     LAD85      ;4
        ldx     #$07       ;2
        jsr     _L1338     ;6
        lda     L60DF      ;4
        ldx     #$16       ;2
        jsr     _L1338     ;6
        lda     L60DE      ;4
        ldx     #$18       ;2
        jsr     _L1338     ;6
        ldx     #$00       ;2
_L12BD  lda     _L134D,x   ;4+
        sta     $0C28,x    ;5
        sta     LE428,x    ;5
        lda     #$00       ;2
        sta     $0828,x    ;5
        sta     LE028,x    ;5
        inx                ;2
        cpx     #$28       ;2
        bne     _L12BD     ;2+
        lda     #$FE       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        lda     $FF08      ;4
        tax                ;2
        and     #$10       ;2
        beq     _L12F8     ;2+
        txa                ;2
        and     #$20       ;2
        beq     _L12FD     ;2+
        txa                ;2
        and     #$40       ;2
        beq     _L1302     ;3+
        txa                ;2
        and     #$08       ;2
        beq     _L1307     ;3+
        txa                ;2
        and     #$01       ;2
        beq     _L130C     ;3+
        rts                ;6

_L12F8  lda     #$01       ;2
        jmp     L6798      ;3

_L12FD  lda     #$02       ;2
        jmp     L6798      ;3

_L1302  lda     #$03       ;2
        jmp     L6798      ;3

_L1307  lda     #$04       ;2
        jmp     L6798      ;3

_L130C  jmp     _L130F     ;3

_L130F  lda     LBC1E      ;4
        sta     $1C        ;3
        lda     LBC1F      ;4
        sta     $1D        ;3
        ldy     #$00       ;2
_L131B  lda     ($1C),y    ;5+
        cmp     #$FF       ;2
        beq     _L132C     ;2+
        tax                ;2
        lda     #$FC       ;2
        sta     LBD5E,x    ;5
        iny                ;2
        iny                ;2
        iny                ;2
        bne     _L131B     ;2+
_L132C  lda     #$00       ;2
        sta     L7DF0      ;4
        sta     L724A      ;4
        sta     LBB3E      ;4
        rts                ;6

_L1338  tay                ;2
        lsr     a          ;2
        lsr     a          ;2
        lsr     a          ;2
        lsr     a          ;2
        clc                ;2
        adc     #$01       ;2
        sta     _L134D,x   ;5
        tya                ;2
        and     #$0F       ;2
        clc                ;2
        adc     #$01       ;2
        sta     _L134E,x   ;5
        rts                ;6

_L134D  .byte   $00
_L134E  .byte   $13
        .byte   $12
        .byte   $15
        .fill   6,$00
_L1357  .byte   $00
_L1358  .byte   $00
_L1359  .byte   $00
        .byte   $00
_L135B  .byte   $00
_L135C  .byte   $00
_L135D  .fill   13,$00
L136A   .fill   9,$00
L1373   .byte   $00
        .byte   $00
L1375   .byte   $00
L1376   .byte   $7F
L1377   .byte   $13
        .byte   $AB
        .byte   $13
        .byte   $E3
        .byte   $13
        .byte   $17
        .byte   $14
L137E   .byte   $00
        .byte   $85
        .byte   $40
        .byte   $86
        .byte   $41
        .byte   $84
        .byte   $42
        .byte   $0E
        .byte   $09
        .byte   $FF
        .byte   $AD
        .byte   $13
        .byte   $FF
        .byte   $8D
        .byte   $7E
        .byte   $13
        .byte   $A9
        .byte   $D8
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $A9
        .byte   $12
        .byte   $8D
        .byte   $0B
        .byte   $FF
        .byte   $AD
        .byte   $78
        .byte   $13
        .byte   $8D
        .byte   $FE
        .byte   $FF
        .byte   $AD
        .byte   $79
        .byte   $13
        .byte   $8D
        .byte   $FF
        .byte   $FF
        .byte   $A5
        .byte   $40
        .byte   $A6
        .byte   $41
        .byte   $A4
        .byte   $42
        .byte   $40
        .byte   $85
        .byte   $40
        .byte   $86
        .byte   $41
        .byte   $84
        .byte   $42
        .byte   $0E
        .byte   $09
        .byte   $FF
        .fill   10,$EA
        .byte   $AD
        .byte   $F7
        .byte   $CB
        .byte   $8D
        .byte   $15
        .byte   $FF
        .byte   $AD
        .byte   $7E
        .byte   $13
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $AD
        .byte   $F6
        .byte   $CB
        .byte   $8D
        .byte   $0B
        .byte   $FF
        .byte   $AD
        .byte   $7A
        .byte   $13
        .byte   $8D
        .byte   $FE
        .byte   $FF
        .byte   $AD
        .byte   $7B
        .byte   $13
        .byte   $8D
        .byte   $FF
        .byte   $FF
        .byte   $A5
        .byte   $40
        .byte   $A6
        .byte   $41
        .byte   $A4
        .byte   $42
        .byte   $40
        .byte   $85
        .byte   $40
        .byte   $86
        .byte   $41
        .byte   $84
        .byte   $42
        .byte   $0E
        .byte   $09
        .byte   $FF
        .fill   10,$EA
        .byte   $AD
        .byte   $F8
        .byte   $CB
        .byte   $8D
        .byte   $15
        .byte   $FF
        .byte   $A9
        .byte   $D0
        .byte   $8D
        .byte   $0B
        .byte   $FF
        .byte   $AD
        .byte   $7C
        .byte   $13
        .byte   $8D
        .byte   $FE
        .byte   $FF
        .byte   $AD
        .byte   $7D
        .byte   $13
        .byte   $8D
        .byte   $FF
        .byte   $FF
        .byte   $20
        .byte   $42
        .byte   $02
        .byte   $A5
        .byte   $40
        .byte   $A6
        .byte   $41
        .byte   $A4
        .byte   $42
        .byte   $40
        .byte   $85
        .byte   $40
        .byte   $86
        .byte   $41
        .byte   $84
        .byte   $42
        .byte   $0E
        .byte   $09
        .byte   $FF
        .byte   $A9
        .byte   $51
        .byte   $8D
        .byte   $15
        .byte   $FF
        .byte   $EE
        .byte   $75
        .byte   $13
        .byte   $A9
        .byte   $02
        .byte   $8D
        .byte   $0B
        .byte   $FF
        .byte   $AD
        .byte   $76
        .byte   $13
        .byte   $8D
        .byte   $FE
        .byte   $FF
        .byte   $AD
        .byte   $77
        .byte   $13
        .byte   $8D
        .byte   $FF
        .byte   $FF
        .byte   $A5
        .byte   $40
        .byte   $A6
        .byte   $41
        .byte   $A4
        .byte   $42
        .byte   $40

L1440   lda     #$00       ;2
        sta     L60E5      ;4
        jsr     L60E7      ;6
        jsr     L7DF5      ;6
        jsr     L724F      ;6
        jsr     L1486      ;6
        jsr     L1466      ;6
L1454   jsr     $0000      ;6
        lda     L1484      ;4
        clc                ;2
        adc     #$01       ;2
        bcc     _L1462     ;2+
        inc     L1485      ;6
_L1462  sta     L1484      ;4
        rts                ;6

L1466   lda     L1484      ;4
        and     #$03       ;2
        beq     _L146E     ;2+
        rts                ;6

_L146E  inc     LBB3E      ;6
        lda     LBB3E      ;4
        cmp     LBB3F      ;4
        bcc     _L1481     ;2+
        lda     #$00       ;2
        sta     LBB3E      ;4
        jsr     LBB45      ;6
_L1481  rts                ;6

L1482   .byte   $00
L1483   .byte   $00
L1484   .byte   $00
L1485   .byte   $00

L1486   inc     L1482      ;6
        lda     L1482      ;4
        cmp     #$07       ;2
        bcc     _L1499     ;2+
        lda     L1483      ;4
        ldx     L1248      ;4
        jsr     LBC24      ;6
_L1499  lda     L1482      ;4
        cmp     #$08       ;2
        bne     _L14AB     ;2+
        jsr     $FA4A      ;6
        sta     L1483      ;4
        and     #$03       ;2
        sta     L1482      ;4
_L14AB  jsr     $F9A0      ;6
        rts                ;6

        .fill   8,$00

L14B7   ldx     #$00       ;2
_L14B9  lda     LDFFF+1,x  ;4+
        sta     $0200,x    ;5
        lda     LE100,x    ;4+
        sta     $0300,x    ;5
        lda     LE200,x    ;4+
        sta     $0400,x    ;5
        lda     LE300,x    ;4+
        sta     $0500,x    ;5
        lda     LE400,x    ;4+
        sta     $0600,x    ;5
        lda     LE500,x    ;4+
        sta     $0700,x    ;5
        inx                ;2
        bne     _L14B9     ;2+
        rts                ;6

        .byte   $60
        .byte   $A9
        .byte   $3A
        .byte   $8D
        .byte   $60
        .byte   $BF
        .byte   $20
        .byte   $E5
        .byte   $BE
        .byte   $20
        .byte   $EE
        .byte   $14
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $0C
        .byte   $E8
        .byte   $E0
        .byte   $16
        .byte   $D0
        .byte   $F4
        .byte   $A2
        .byte   $11
        .byte   $A0
        .byte   $16
        .byte   $4C
        .byte   $EB
        .byte   $BE
        .byte   $60
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $10
        .byte   $15
        .byte   $20
        .byte   $11
        .byte   $15
        .byte   $4C
        .byte   $11
        .byte   $15
        .byte   $00
        .byte   $AD
        .byte   $10
        .byte   $15
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $1B
        .byte   $CE
        .byte   $10
        .byte   $15
        .byte   $AD
        .byte   $86
        .byte   $BD
        .byte   $D0
        .byte   $13
        .byte   $A2
        .byte   $27
        .byte   $A0
        .byte   $12
        .byte   $A9
        .text   "& sI"
        .byte   $AD
        .byte   $10
        .byte   $15
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $10
        .byte   $15
        .byte   $60
        .byte   $00
        .byte   $C1
        .byte   $CD
        .byte   $0C
        .byte   $12
        .byte   $0C
        .byte   $20
        .byte   $16
        .byte   $CB
        .byte   $20
        .byte   $AE
        .byte   $C0
        .byte   $A9
        .byte   $3A
        .byte   $8D
        .byte   $60
        .byte   $BF
        .byte   $20
        .byte   $E5
        .byte   $BE
        .byte   $4C
        .byte   $4D
        .byte   $15
        .byte   $AD
        .byte   $74
        .byte   $BD
        .byte   $D0
        .byte   $0C
        .byte   $AD
        .byte   $75
        .byte   $BD
        .byte   $D0
        .byte   $07
        .byte   $A2
        .byte   $1D
        .byte   $A0
        .byte   $16
        .byte   $20
        .byte   $EB
        .byte   $BE
        .byte   $AD
        .byte   $36
        .byte   $15
        .byte   $29
        .byte   $01
        .byte   $AA
        .byte   $BD
        .byte   $39
        .byte   $15
        .byte   $8D
        .byte   $92
        .byte   $15
        .byte   $BD
        .byte   $3A
        .byte   $15
        .byte   $8D
        .byte   $96
        .byte   $15
        .byte   $AD
        .byte   $37
        .byte   $15
        .byte   $85
        .byte   $14
        .byte   $85
        .byte   $18
        .byte   $A9
        .byte   $01
        .byte   $18
        .byte   $6D
        .byte   $48
        .byte   $12
        .byte   $85
        .byte   $15
        .byte   $85
        .byte   $17
        .byte   $38
        .byte   $E9
        .byte   $04
        .byte   $85
        .byte   $19
        .byte   $85
        .byte   $1B
        .byte   $AD
        .byte   $38
        .byte   $15
        .byte   $85
        .byte   $16
        .byte   $85
        .byte   $1A
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $18
        .byte   $91
        .byte   $14
        .byte   $A9
        .byte   $00
        .byte   $91
        .byte   $16
        .byte   $A9
        .byte   $3A
        .byte   $91
        .byte   $18
        .byte   $91
        .byte   $1A
        .byte   $C8
        .byte   $C0
        .byte   $07
        .byte   $D0
        .byte   $ED
        .byte   $AD
        .byte   $84
        .byte   $14
        .byte   $18
        .byte   $69
        .byte   $02
        .byte   $29
        .byte   $0F
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $36
        .byte   $15
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $E7
        .byte   $15
        .byte   $8D
        .byte   $E8
        .byte   $15
        .byte   $8D
        .byte   $E9
        .byte   $15
        .byte   $AD
        .byte   $F1
        .byte   $15
        .byte   $8D
        .byte   $F0
        .byte   $15
        .byte   $A9
        .byte   $1E
        .byte   $8D
        .byte   $F9
        .byte   $15
        .byte   $A9
        .byte   $1A
        .byte   $8D
        .byte   $02
        .byte   $16
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $F2
        .byte   $15
        .byte   $8D
        .byte   $FB
        .byte   $15
        .byte   $8D
        .byte   $04
        .byte   $16
        .byte   $20
        .byte   $16
        .byte   $CB
        .byte   $20
        .byte   $AE
        .byte   $C0
        .byte   $20
        .byte   $A2
        .byte   $C1
        .byte   $20
        .byte   $05
        .byte   $16
        .byte   $4C
        .byte   $05
        .byte   $16
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $EC
        .byte   $15
        .byte   $27
        .byte   $08
        .byte   $05
        .byte   $EE
        .byte   $00
        .byte   $2D
        .byte   $01
        .byte   $F5
        .byte   $15
        .byte   $19
        .byte   $10
        .byte   $05
        .byte   $EE
        .byte   $00
        .byte   $3C
        .byte   $01
        .byte   $FE
        .byte   $15
        .byte   $19
        .byte   $12
        .byte   $05
        .byte   $EE
        .byte   $00
        .byte   $3C
        .byte   $01
        .byte   $20
        .byte   $B6
        .byte   $C7
        .byte   $AE
        .byte   $EA
        .byte   $15
        .byte   $AC
        .byte   $EB
        .byte   $15
        .byte   $20
        .byte   $B2
        .byte   $C1
        .byte   $AE
        .byte   $F3
        .byte   $15
        .byte   $AC
        .byte   $F4
        .byte   $15
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $FC
        .byte   $15
        .byte   $AC
        .byte   $FD
        .byte   $15
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AD
        .byte   $E7
        .byte   $15
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $25
        .byte   $CE
        .byte   $E7
        .byte   $15
        .byte   $AD
        .byte   $7E
        .byte   $BD
        .byte   $D0
        .byte   $1D
        .byte   $AD
        .byte   $7F
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $A2
        .byte   $19
        .byte   $A0
        .byte   $13
        .byte   $A9
        .text   $05," sI"
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $04
        .byte   $16
        .byte   $AD
        .byte   $E7
        .byte   $15
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $E7
        .byte   $15
        .byte   $AD
        .byte   $E8
        .byte   $15
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $20
        .byte   $CE
        .byte   $E8
        .byte   $15
        .byte   $AD
        .byte   $7C
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $AD
        .byte   $7D
        .byte   $BD
        .byte   $D0
        .byte   $13
        .byte   $A2
        .byte   $00
        .byte   $A0
        .byte   $13
        .byte   $A9
        .byte   $15
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $E8
        .byte   $15
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $E8
        .byte   $15
        .byte   $AD
        .byte   $E9
        .byte   $15
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $36
        .byte   $CE
        .byte   $E9
        .byte   $15
        .byte   $AD
        .byte   $86
        .byte   $BD
        .byte   $D0
        .byte   $2E
        .byte   $A2
        .byte   $1E
        .byte   $A0
        .byte   $04
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $A2
        .byte   $20
        .byte   $A0
        .byte   $0A
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $A2
        .byte   $22
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $80
        .byte   $C8
        .byte   $A2
        .byte   $22
        .byte   $A0
        .byte   $02
        .byte   $A9
        .text   "C sI"
        .byte   $AD
        .byte   $E9
        .byte   $15
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $E9
        .byte   $15
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $C8
        .byte   $16
        .byte   $20
        .byte   $91
        .byte   $CB
        .byte   $20
        .byte   $D0
        .byte   $16
        .byte   $4C
        .byte   $D0
        .byte   $16
        .byte   $00
        .byte   $CB
        .byte   $16
        .byte   $12
        .byte   $14
        .byte   $00
        .byte   $EE
        .byte   $00
        .byte   $AE
        .byte   $C9
        .byte   $16
        .byte   $AC
        .byte   $CA
        .byte   $16
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $20
        .byte   $B6
        .byte   $C7
        .byte   $AD
        .byte   $C8
        .byte   $16
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $24
        .byte   $CE
        .byte   $C8
        .byte   $16
        .byte   $A2
        .byte   $22
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $2A
        .byte   $D0
        .byte   $F4
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $09
        .byte   $A9
        .text   $05," sI"
        .byte   $AD
        .byte   $C8
        .byte   $16
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $C8
        .byte   $16
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $32
        .byte   $17
        .byte   $8D
        .byte   $33
        .byte   $17
        .byte   $A9
        .byte   $1E
        .byte   $8D
        .byte   $3A
        .byte   $17
        .byte   $A9
        .byte   $0F
        .byte   $8D
        .byte   $43
        .byte   $17
        .byte   $A9
        .byte   $1E
        .byte   $8D
        .byte   $4C
        .byte   $17
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $3C
        .byte   $17
        .byte   $8D
        .byte   $45
        .byte   $17
        .byte   $20
        .byte   $91
        .byte   $CB
        .byte   $20
        .byte   $4F
        .byte   $17
        .byte   $4C
        .byte   $4F
        .byte   $17
        .byte   $00
        .byte   $00
        .byte   $36
        .byte   $17
        .byte   $09
        .byte   $0C
        .byte   $05
        .byte   $EE
        .byte   $00
        .byte   $32
        .byte   $01
        .byte   $3F
        .byte   $17
        .byte   $18
        .byte   $0C
        .byte   $05
        .byte   $EE
        .byte   $00
        .byte   $32
        .byte   $01
        .byte   $48
        .byte   $17
        .byte   $27
        .byte   $14
        .byte   $06
        .byte   $EE
        .byte   $00
        .byte   $78
        .byte   $01
        .byte   $20
        .byte   $B6
        .byte   $C7
        .byte   $AE
        .byte   $34
        .byte   $17
        .byte   $AC
        .byte   $35
        .byte   $17
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $3D
        .byte   $17
        .byte   $AC
        .byte   $3E
        .byte   $17
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $46
        .byte   $17
        .byte   $AC
        .byte   $47
        .byte   $17
        .byte   $20
        .byte   $B2
        .byte   $C1
        .byte   $AD
        .byte   $32
        .byte   $17
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $20
        .byte   $CE
        .byte   $32
        .byte   $17
        .byte   $AD
        .byte   $88
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $A2
        .byte   $0B
        .byte   $A0
        .byte   $0F
        .byte   $A9
        .text   "c YI"
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $3C
        .byte   $17
        .byte   $AD
        .byte   $32
        .byte   $17
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $32
        .byte   $17
        .byte   $AD
        .byte   $33
        .byte   $17
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $20
        .byte   $CE
        .byte   $33
        .byte   $17
L17A2   .byte   $AD
        .byte   $89
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $A2
        .byte   $19
        .byte   $A0
        .byte   $0F
        .byte   $A9
        .text   "c YI"
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $45
        .byte   $17
        .byte   $AD
        .byte   $33
        .byte   $17
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $33
        .byte   $17
        .byte   $AD
        .byte   $84
        .byte   $14
        .text   "jjjjjj)"
        .byte   $01
        .byte   $8D
        .byte   $DC
        .byte   $17
        .byte   $49
        .byte   $01
        .byte   $8D
        .byte   $EA
        .byte   $17
        .byte   $AD
        .byte   $89
        .byte   $BD
        .byte   $F0
        .byte   $09
        .byte   $A2
        .byte   $1C
        .byte   $A0
        .byte   $06
        .byte   $A9
        .byte   $01
        .byte   $20
        .byte   $C1
        .byte   $C8
        .byte   $AD
        .byte   $88
        .byte   $BD
        .byte   $F0
        .byte   $09
        .byte   $A2
        .byte   $0B
        .byte   $A0
        .byte   $06
        .byte   $A9
        .byte   $01
        .byte   $20
        .byte   $C1
        .byte   $C8
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $21
        .byte   $18
        .byte   $8D
        .byte   $22
        .byte   $18
        .byte   $8D
        .byte   $23
        .byte   $18
        .byte   $8D
        .byte   $33
        .byte   $18
        .byte   $8D
        .byte   $32
        .byte   $18
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $3A
        .byte   $18
        .byte   $8D
        .byte   $41
        .byte   $18
        .byte   $8D
        .byte   $48
        .byte   $18
        .byte   $8D
        .byte   $4F
        .byte   $18
        .byte   $8D
        .byte   $56
        .byte   $18
        .byte   $A9
        .byte   $1E
        .byte   $8D
        .byte   $2A
        .byte   $18
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $2C
        .byte   $18
        .byte   $20
        .byte   $59
        .byte   $18
        .byte   $4C
        .byte   $59
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $26
        .byte   $18
        .byte   $20
        .byte   $08
        .byte   $06
        .byte   $AF
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $2F
        .byte   $18
        .byte   $03
        .byte   $14
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $01
        .byte   $38
        .byte   $18
        .byte   $07
        .byte   $06
        .byte   $00
        .byte   $9F
        .byte   $00
        .byte   $3F
        .byte   $18
        .byte   $1D
        .byte   $06
        .byte   $00
        .byte   $9F
        .byte   $00
        .byte   $46
        .byte   $18
        .byte   $03
        .byte   $0C
        .byte   $00
        .byte   $9F
        .byte   $00
        .byte   $4D
        .byte   $18
        .byte   $11
        .byte   $0C
        .byte   $00
        .byte   $9F
        .byte   $00
        .byte   $54
        .byte   $18
        .byte   $15
        .byte   $0C
        .byte   $00
        .byte   $9F
        .byte   $00
        .byte   $AE
        .byte   $36
        .byte   $18
        .byte   $AC
        .byte   $37
        .byte   $18
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $3D
        .byte   $18
        .byte   $AC
        .byte   $3E
        .byte   $18
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $44
        .byte   $18
        .byte   $AC
        .byte   $45
        .byte   $18
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $4B
        .byte   $18
        .byte   $AC
        .byte   $4C
        .byte   $18
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $52
        .byte   $18
        .byte   $AC
        .byte   $53
        .byte   $18
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $24
        .byte   $18
        .byte   $AC
        .byte   $25
        .byte   $18
        .byte   $20
        .byte   $B2
        .byte   $C1
        .byte   $AD
        .byte   $21
        .byte   $18
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2D
        .byte   $CE
        .byte   $21
        .byte   $18
        .byte   $A2
        .byte   $2C
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $21
        .byte   $E8
        .byte   $E0
        .byte   $31
        .byte   $D0
        .byte   $F4
        .byte   $A2
        .byte   $22
        .byte   $A0
        .byte   $03
        .byte   $A9
        .text   $22," YI"
        .byte   $A2
        .byte   $21
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $21
        .byte   $18
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $21
        .byte   $18
        .byte   $AD
        .byte   $22
        .byte   $18
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $24
        .byte   $CE
        .byte   $22
        .byte   $18
        .byte   $A2
        .byte   $31
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $37
        .byte   $D0
        .byte   $F4
        .byte   $A2
        .byte   $26
        .byte   $A0
        .byte   $08
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $22
        .byte   $18
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $22
        .byte   $18
        .byte   $AD
        .byte   $23
        .byte   $18
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $31
        .byte   $CE
        .byte   $23
        .byte   $18
        .byte   $AD
        .byte   $95
        .byte   $BD
        .byte   $D0
        .byte   $29
        .byte   $AD
        .byte   $96
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $32
        .byte   $18
        .byte   $AD
        .byte   $85
        .byte   $14
        .byte   $D0
        .byte   $10
        .byte   $AD
        .byte   $84
        .byte   $14
        .byte   $C9
        .byte   $05
        .byte   $B0
        .byte   $09
        .byte   $AD
        .byte   $34
        .byte   $18
        .byte   $38
        .byte   $E9
        .byte   $03
        .byte   $8D
        .byte   $33
        .byte   $18
        .byte   $AD
        .byte   $23
        .byte   $18
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $23
        .byte   $18
        .byte   $AE
        .byte   $2D
        .byte   $18
        .byte   $AC
        .byte   $2E
        .byte   $18
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $57
        .byte   $19
        .byte   $8D
        .byte   $58
        .byte   $19
        .byte   $8D
        .byte   $59
        .byte   $19
        .byte   $8D
        .byte   $5A
        .byte   $19
        .byte   $8D
        .byte   $5B
        .byte   $19
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $62
        .byte   $19
        .byte   $A9
        .byte   $24
        .byte   $8D
        .byte   $6B
        .byte   $19
        .byte   $20
        .byte   $6E
        .byte   $19
        .byte   $4C
        .byte   $6E
        .byte   $19
        .fill   5,$00
        .byte   $5E
        .byte   $19
        .byte   $04
        .byte   $08
        .byte   $09
        .byte   $AF
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $67
        .byte   $19
        .byte   $19
        .byte   $08
        .byte   $09
        .byte   $AF
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $20
        .byte   $B6
        .text   "G aH"
        .byte   $AE
        .byte   $5C
        .byte   $19
        .byte   $AC
        .byte   $5D
        .byte   $19
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $65
        .byte   $19
        .byte   $AC
        .byte   $66
        .byte   $19
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AD
        .byte   $57
        .byte   $19
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $27
        .byte   $CE
        .byte   $57
        .byte   $19
        .byte   $AD
        .byte   $99
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $12
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $70
L19A2   .byte   $0F
        .byte   $8D
        .byte   $71
        .byte   $0F
        .byte   $AD
        .byte   $70
        .byte   $E7
        .byte   $8D
        .byte   $71
        .byte   $E7
        .byte   $AD
        .byte   $57
        .byte   $19
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $57
        .byte   $19
        .byte   $AD
        .byte   $58
        .byte   $19
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2C
        .byte   $CE
        .byte   $58
        .byte   $19
        .byte   $AD
        .byte   $95
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $AD
        .byte   $96
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $0E
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $8D
        .byte   $0E
        .byte   $8D
        .byte   $8E
        .byte   $0E
        .byte   $AD
        .byte   $8D
        .byte   $E6
        .byte   $8D
        .byte   $8E
        .byte   $E6
        .byte   $AD
        .byte   $58
        .byte   $19
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $58
        .byte   $19
        .byte   $AD
        .byte   $59
        .byte   $19
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2C
        .byte   $CE
        .byte   $59
        .byte   $19
        .byte   $AD
        .byte   $97
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $AD
        .byte   $98
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $19
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $9A
        .byte   $0E
        .byte   $8D
        .byte   $99
        .byte   $0E
        .byte   $AD
        .byte   $9A
        .byte   $E6
        .byte   $8D
        .byte   $99
        .byte   $E6
        .byte   $AD
        .byte   $59
        .byte   $19
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $59
        .byte   $19
        .byte   $AD
        .byte   $5A
        .byte   $19
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $27
        .byte   $CE
        .byte   $5A
        .byte   $19
        .byte   $AD
        .byte   $9A
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $26
        .byte   $A0
        .byte   $12
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $97
        .byte   $0F
        .byte   $8D
        .byte   $96
        .byte   $0F
        .byte   $AD
        .byte   $97
        .byte   $E7
        .byte   $8D
        .byte   $96
        .byte   $E7
        .byte   $AD
        .byte   $5A
        .byte   $19
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $5A
        .byte   $19
        .byte   $AD
        .byte   $5B
        .byte   $19
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2C
        .byte   $CE
        .byte   $5B
        .byte   $19
        .byte   $AD
        .byte   $9D
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $AD
        .byte   $9E
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $26
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $3F
        .byte   $0D
        .byte   $8D
        .byte   $3E
        .byte   $0D
        .byte   $AD
        .byte   $3F
        .byte   $E5
        .byte   $8D
        .byte   $3E
        .byte   $E5
        .byte   $AD
        .byte   $5B
        .byte   $19
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $5B
        .byte   $19
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $A7
        .byte   $1A
        .byte   $8D
        .byte   $A8
        .byte   $1A
        .byte   $8D
        .byte   $A9
        .byte   $1A
        .byte   $8D
        .byte   $B0
        .byte   $1A
        .byte   $8D
        .byte   $AF
        .byte   $1A
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $B9
        .byte   $1A
        .byte   $A9
        .byte   $05
        .byte   $8D
        .byte   $C2
        .byte   $1A
        .byte   $20
        .byte   $C5
        .byte   $1A
        .byte   $4C
        .byte   $C5
        .byte   $1A
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $AC
        .byte   $1A
        .byte   $02
        .byte   $16
        .byte   $17
        .byte   $00
        .byte   $00
        .byte   $32
        .byte   $01
        .byte   $B5
        .byte   $1A
        .byte   $0E
        .byte   $09
        .byte   $08
        .byte   $9F
        .byte   $00
        .byte   $4B
        .byte   $01
        .byte   $BE
        .byte   $1A
        .byte   $0E
        .byte   $0B
        .byte   $08
        .byte   $9F
        .byte   $00
        .byte   $4B
        .byte   $01
        .byte   $20
        .byte   $B6
        .text   "G aH"
        .byte   $AE
        .byte   $B3
        .byte   $1A
        .byte   $AC
        .byte   $B4
        .byte   $1A
        .byte   $20
        .byte   $B2
        .byte   $C1
        .byte   $AE
        .byte   $BC
        .byte   $1A
        .byte   $AC
        .byte   $BD
        .byte   $1A
        .byte   $20
        .byte   $B2
        .byte   $C1
        .byte   $AD
        .byte   $A7
        .byte   $1A
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $27
        .byte   $CE
        .byte   $A7
        .byte   $1A
        .byte   $AD
        .byte   $9B
        .byte   $BD
        .byte   $D0
        .byte   $1F
        .byte   $A2
        .byte   $17
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .byte   $06
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $96
        .byte   $0E
        .byte   $8D
        .byte   $97
        .byte   $0E
        .byte   $AD
        .byte   $96
        .byte   $E6
        .byte   $8D
        .byte   $97
        .byte   $E6
        .byte   $AD
        .byte   $A7
        .byte   $1A
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $A7
        .byte   $1A
        .byte   $AD
        .byte   $A8
        .byte   $1A
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $24
        .byte   $CE
        .byte   $A8
        .byte   $1A
        .byte   $AD
        .byte   $9F
        .byte   $BD
        .byte   $D0
        .byte   $1C
        .byte   $A2
        .byte   $23
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $01
        .byte   $20
        .byte   $80
        .byte   $C8
        .byte   $A2
        .byte   $23
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $94
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $A8
        .byte   $1A
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $A8
        .byte   $1A
        .byte   $AD
        .byte   $A9
        .byte   $1A
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $31
        .byte   $CE
        .byte   $A9
        .byte   $1A
        .byte   $AD
        .byte   $9D
        .byte   $BD
        .byte   $D0
        .byte   $29
        .byte   $AD
        .byte   $9E
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $AF
        .byte   $1A
        .byte   $AD
        .byte   $85
        .byte   $14
        .byte   $D0
        .byte   $10
        .byte   $AD
        .byte   $84
        .byte   $14
        .byte   $C9
        .byte   $05
        .byte   $B0
        .byte   $09
        .byte   $AD
        .byte   $B1
        .byte   $1A
        .byte   $38
        .byte   $E9
        .byte   $03
        .byte   $8D
        .byte   $B0
        .byte   $1A
        .byte   $AD
        .byte   $A9
        .byte   $1A
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $A9
        .byte   $1A
        .byte   $AE
        .byte   $AA
        .byte   $1A
        .byte   $AC
        .byte   $AB
        .byte   $1A
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $92
        .byte   $1B
        .byte   $20
        .byte   $91
        .byte   $CB
        .byte   $20
        .byte   $01
        .byte   $CB
        .byte   $20
        .byte   $B9
        .byte   $C0
        .byte   $20
        .byte   $C4
        .byte   $1B
        .byte   $4C
        .byte   $C4
        .byte   $1B
        .byte   $00
        .byte   $95
        .byte   $1B
        .byte   $09
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $9C
        .byte   $1B
        .byte   $15
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $A3
        .byte   $1B
        .byte   $22
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $AA
        .byte   $1B
        .byte   $15
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $B1
        .byte   $1B
        .byte   $22
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $B8
        .byte   $1B
        .byte   $13
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $BF
        .byte   $1B
        .byte   $18
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $AE
        .byte   $93
        .byte   $1B
        .byte   $AC
        .byte   $94
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $9A
        .byte   $1B
        .byte   $AC
        .byte   $9B
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $A1
        .byte   $1B
        .byte   $AC
        .byte   $A2
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $A8
        .byte   $1B
        .byte   $AC
        .byte   $A9
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $AF
        .byte   $1B
        .byte   $AC
        .byte   $B0
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $B6
        .byte   $1B
        .byte   $AC
        .byte   $B7
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $BD
        .byte   $1B
        .byte   $AC
        .byte   $BE
        .byte   $1B
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AD
        .byte   $92
        .byte   $1B
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2B
        .byte   $CE
        .byte   $92
        .byte   $1B
        .byte   $AD
        .byte   $A0
        .byte   $BD
        .byte   $D0
        .byte   $23
        .byte   $AD
        .byte   $A1
        .byte   $BD
        .byte   $D0
        .byte   $1E
        .byte   $AD
        .byte   $A2
        .byte   $BD
        .byte   $D0
        .byte   $19
        .byte   $A9
        .byte   $21
        .byte   $85
        .byte   $D0
        .byte   $A2
        .byte   $25
        .byte   $A0
        .byte   $06
        .byte   $84
        .byte   $D1
        .byte   $A9
        .text   "$ $J"
        .byte   $AD
        .byte   $92
        .byte   $1B
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $92
        .byte   $1B
        .byte   $60
        .byte   $60
        .text   ";",$1C,$0A,$07
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $42
        .byte   $1C
        .byte   $1D
        .byte   $07
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $49
        .byte   $1C
        .byte   $0F
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $50
        .byte   $1C
        .byte   $18
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $20
        .byte   $B6
        .byte   $C7
        .byte   $20
        .byte   $8D
        .byte   $BE
        .byte   $AE
        .byte   $39
        .byte   $1C
        .byte   $AC
        .byte   $3A
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $40
        .byte   $1C
        .byte   $AC
        .byte   $41
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $47
        .byte   $1C
        .byte   $AC
        .byte   $48
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $4E
        .byte   $1C
        .byte   $AC
        .byte   $4F
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $94
        .byte   $1C
        .byte   $8D
        .byte   $95
        .byte   $1C
        .byte   $8D
        .byte   $96
        .byte   $1C
        .byte   $8D
        .text   "&",$1E," A",$1C,"lA",$1C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $99
        .byte   $1C
        .byte   $0F
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $A0
        .byte   $1C
        .byte   $13
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $A7
        .byte   $1C
        .byte   $0F
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $AE
        .byte   $1C
        .byte   $13
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $B5
        .byte   $1C
        .byte   $0F
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $BC
        .byte   $1C
        .byte   $13
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $AD
        .byte   $94
        .byte   $1C
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $21
        .byte   $CE
        .byte   $94
        .byte   $1C
        .byte   $AD
        .byte   $A7
        .byte   $BD
        .byte   $D0
        .byte   $19
        .byte   $A9
        .byte   $06
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $25
        .byte   $86
        .byte   $D0
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .text   "$ $J"
        .byte   $AD
        .byte   $94
        .byte   $1C
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $94
        .byte   $1C
        .byte   $AD
        .byte   $95
        .byte   $1C
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   "!N",$95,$1C
        .byte   $AD
        .byte   $A8
        .byte   $BD
        .byte   $D0
        .byte   $19
        .byte   $A9
        .byte   $06
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $25
        .byte   $86
        .byte   $D0
        .byte   $A0
        .byte   $12
        .byte   $A9
        .text   "$ $J"
        .byte   $AD
        .text   $95,$1C,"P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $95
        .byte   $1C
        .byte   $AE
        .byte   $97
        .byte   $1C
        .byte   $AC
        .byte   $98
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $9E
        .byte   $1C
        .byte   $AC
        .byte   $9F
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $A5
        .byte   $1C
        .byte   $AC
        .byte   $A6
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $AC
        .byte   $1C
        .byte   $AC
        .byte   $AD
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $B3
        .byte   $1C
        .byte   $AC
        .byte   $B4
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $BA
        .byte   $1C
        .byte   $AC
        .byte   $BB
        .byte   $1C
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AD
        .byte   $26
        .byte   $1E
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   $22,"N&",$1E
        .byte   $A2
        .byte   $48
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $52
        .byte   $D0
        .byte   $F6
        .byte   $A2
        .byte   $27
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .text   "d sI"
        .byte   $AD
        .text   "&",$1E,"P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $26
        .byte   $1E
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .text   "&",$1E," ",$9E
        .byte   $1D
        .byte   $4C
        .byte   $9E
        .byte   $1D
        .byte   $84
        .byte   $1D
        .byte   $0E
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $8B
        .byte   $1D
        .byte   $19
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $92
        .byte   $1D
        .byte   $0E
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $99
        .byte   $1D
        .byte   $19
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $AE
        .byte   $82
        .byte   $1D
        .byte   $AC
        .byte   $83
        .byte   $1D
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $89
        .byte   $1D
        .byte   $AC
        .byte   $8A
        .byte   $1D
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $90
        .byte   $1D
        .byte   $AC
        .byte   $91
        .byte   $1D
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $97
        .byte   $1D
        .byte   $AC
        .byte   $98
        .byte   $1D
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AD
        .byte   $26
        .byte   $1E
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   $22,"N&",$1E
        .byte   $A2
        .byte   $48
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $52
        .byte   $D0
        .byte   $F6
        .byte   $A2
        .byte   $27
        .byte   $A0
        .byte   $06
        .byte   $A9
        .text   "d sI"
        .byte   $AD
        .text   "&",$1E,"P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $26
        .byte   $1E
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $26
        .byte   $1E
        .byte   $8D
        .text   "'",$1E," (",$1E,"l(",$1E
        .byte   $FE
        .byte   $1D
        .byte   $0A
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $05
        .byte   $1E
        .byte   $1C
        .byte   $09
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $0C
        .byte   $1E
        .byte   $10
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $13
        .byte   $1E
        .byte   $19
        .byte   $0F
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $1A
        .byte   $1E
        .byte   $10
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $21
        .byte   $1E
        .byte   $19
        .byte   $15
        .byte   $00
        .byte   $DE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $AE
        .byte   $FC
        .byte   $1D
        .byte   $AC
        .byte   $FD
        .byte   $1D
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $03
        .byte   $1E
        .byte   $AC
        .byte   $04
        .byte   $1E
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $0A
        .byte   $1E
        .byte   $AC
        .byte   $0B
        .byte   $1E
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $11
        .byte   $1E
        .byte   $AC
        .byte   $12
        .byte   $1E
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $18
        .byte   $1E
        .byte   $AC
        .byte   $19
        .byte   $1E
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AE
        .byte   $1F
        .byte   $1E
        .byte   $AC
        .byte   $20
        .byte   $1E
        .byte   $20
        .byte   $6A
        .byte   $BF
        .byte   $AD
        .byte   $AF
        .byte   $BD
        .byte   $F0
        .byte   $19
        .byte   $AD
        .byte   $85
        .byte   $AD
        .byte   $C9
        .byte   $A8
        .byte   $90
        .byte   $1B
        .byte   $AD
        .byte   $84
        .byte   $AD
        .byte   $C9
        .byte   $9C
        .byte   $90
        .byte   $14
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $AF
        .byte   $BD
        .byte   $20
        .byte   $D9
        .byte   $66
        .byte   $20
        .byte   $CA
        .byte   $F9
        .byte   $A2
        .byte   $24
        .byte   $A0
        .byte   $12
        .byte   $A9
        .text   "$ YI"
        .byte   $AD
        .byte   $26
        .byte   $1E
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   $22,"N&",$1E
        .byte   $A2
        .byte   $48
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $52
        .byte   $D0
        .byte   $F6
        .byte   $A2
        .byte   $00
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .text   "d sI"
        .byte   $AD
        .text   "&",$1E,"P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $26
        .byte   $1E
        .byte   $60
        .byte   $20
        .byte   $96
        .byte   $C1
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $D9
        .byte   $1E
        .byte   $8D
        .byte   $EB
        .byte   $1E
        .byte   $8D
        .byte   $F4
        .byte   $1E
        .byte   $8D
        .byte   $FD
        .byte   $1E
        .byte   $8D
        .byte   $06
        .byte   $1F
        .byte   $8D
        .byte   $0F
        .byte   $1F
        .byte   $A9
        .byte   $28
        .byte   $8D
        .byte   $18
        .byte   $1F
        .byte   $A9
        .byte   $1F
        .byte   $8D
        .byte   $E2
        .byte   $1E
        .byte   $60
        .byte   $D5
        .byte   $1E
        .byte   $04
        .byte   $07
        .byte   $1E
        .byte   $00
        .byte   $00
        .byte   $41
        .byte   $01
        .byte   $DE
        .byte   $1E
        .byte   $04
        .byte   $07
        .byte   $1E
        .byte   $00
        .byte   $1F
        .byte   $41
        .byte   $01
        .byte   $E7
        .byte   $1E
        .byte   $04
        .byte   $0C
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $1E
        .byte   $01
        .byte   $F0
        .byte   $1E
        .byte   $12
        .byte   $0C
        .byte   $11
        .byte   $01
        .byte   $00
        .byte   $1F
        .byte   $01
        .byte   $F9
        .byte   $1E
        .byte   $04
        .byte   $11
        .byte   $11
        .byte   $01
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $02
        .byte   $1F
        .byte   $12
        .byte   $11
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $22
        .byte   $01
        .byte   $0B
        .byte   $1F
        .byte   $00
        .byte   $16
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $50
        .byte   $01
        .byte   $14
        .byte   $1F
        .byte   $00
        .byte   $16
        .byte   $22
        .byte   $01
        .byte   $28
        .byte   $50
        .byte   $01
        .byte   $AE
        .byte   $D3
        .byte   $1E
        .byte   $AC
        .byte   $D4
        .byte   $1E
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $DC
        .byte   $1E
        .byte   $AC
        .byte   $DD
        .byte   $1E
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $E5
        .byte   $1E
        .byte   $AC
        .byte   $E6
        .byte   $1E
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $EE
        .byte   $1E
        .byte   $AC
        .byte   $EF
        .byte   $1E
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $F7
        .byte   $1E
        .byte   $AC
        .byte   $F8
        .byte   $1E
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $00
        .byte   $1F
        .byte   $AC
        .byte   $01
        .byte   $1F
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $09
        .byte   $1F
        .byte   $AC
        .byte   $0A
        .byte   $1F
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $12
        .byte   $1F
        .byte   $AC
        .byte   $13
        .byte   $1F
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $75
        .byte   $1F
        .byte   $8D
        .byte   $76
        .byte   $1F
        .byte   $8D
        .byte   $77
        .byte   $1F
        .byte   $20
        .byte   $78
        .byte   $1F
        .byte   $4C
        .byte   $78
        .byte   $1F
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $AD
        .byte   $75
        .byte   $1F
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $2C
        .byte   $CE
        .byte   $75
        .byte   $1F
        .byte   $AD
        .byte   $B0
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $A9
        .byte   $0F
        .byte   $85
        .byte   $D0
        .byte   $A9
        .byte   $08
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $11
        .byte   $A0
        .byte   $04
        .byte   $A9
        .byte   $14
        .byte   $20
        .byte   $24
        .byte   $CA
        .byte   $AD
        .byte   $28
        .byte   $09
        .byte   $8D
        .byte   $29
        .byte   $09
        .byte   $8D
        .byte   $29
        .byte   $E1
        .byte   $AD
        .byte   $75
        .byte   $1F
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $75
        .byte   $1F
        .byte   $AD
        .byte   $76
        .byte   $1F
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $36
        .byte   $CE
        .byte   $76
        .byte   $1F
        .byte   $AD
        .byte   $B1
        .byte   $BD
        .byte   $D0
        .byte   $2E
        .byte   $AD
        .byte   $B2
        .byte   $BD
        .byte   $D0
        .byte   $29
        .byte   $AD
        .byte   $B4
        .byte   $BD
        .byte   $D0
        .byte   $24
        .byte   $A9
        .byte   $0F
        .byte   $85
        .byte   $D0
        .byte   $A9
        .byte   $08
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $17
        .byte   $A0
        .byte   $04
        .byte   $A9
        .byte   $14
        .byte   $20
        .byte   $24
        .byte   $CA
        .byte   $AD
        .byte   $30
        .byte   $09
        .byte   $8D
        .byte   $2F
        .byte   $09
        .byte   $8D
        .byte   $2F
        .byte   $E1
        .byte   $AD
        .byte   $76
        .byte   $1F
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $76
        .byte   $1F
        .byte   $AD
        .byte   $77
        .byte   $1F
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $22
        .byte   $CE
        .byte   $77
        .byte   $1F
        .byte   $A2
        .byte   $52
        .byte   $BD
        .byte   $5E
        .byte   $BD
        .byte   $D0
        .byte   $18
        .byte   $E8
        .byte   $E0
        .byte   $58
        .byte   $D0
        .byte   $F6
        .byte   $A2
        .byte   $27
        .byte   $A0
        .byte   $0C
        .byte   $A9
        .byte   $15
        .byte   $20
        .byte   $53
        .byte   $C9
        .byte   $AD
        .byte   $77
        .byte   $1F
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $77
        .byte   $1F
        .byte   $60
        .byte   $20
        .byte   $91
        .byte   $CB
        .byte   $20
        .byte   $01
        .byte   $CB
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $79
        .byte   $20
        .byte   $8D
        .byte   $55
        .byte   $20
        .byte   $8D
        .byte   $56
        .byte   $20
        .byte   $8D
        .byte   $57
        .byte   $20
        .byte   $8D
        .byte   $5E
        .byte   $20
        .byte   $8D
        .byte   $67
        .byte   $20
        .byte   $20
        .byte   $A2
        .byte   $C1
        .byte   $A9
        .byte   $23
        .byte   $8D
        .byte   $70
        .byte   $20
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $4D
        .byte   $20
        .byte   $9D
        .byte   $38
        .byte   $E8
        .byte   $9D
        .byte   $38
        .byte   $F0
        .byte   $E8
        .byte   $E0
        .byte   $08
        .byte   $D0
        .byte   $F2
        .byte   $4C
        .byte   $7C
        .byte   $20
        .byte   $AA
        .byte   $AA
        .byte   $04
        .byte   $04
        .byte   $FF
        .byte   $FF
        .fill   5,$00
        .byte   $5A
        .byte   $20
        .byte   $06
        .byte   $0C
        .byte   $21
        .byte   $2F
        .byte   $00
        .byte   $4B
        .byte   $01
        .byte   $63
        .byte   $20
        .byte   $06
        .byte   $04
        .byte   $1F
        .byte   $2F
        .byte   $00
        .byte   $55
        .byte   $01
        .byte   $6C
        .byte   $20
        .byte   $06
        .byte   $10
        .byte   $21
        .byte   $2F
        .byte   $00
        .byte   $4B
        .byte   $01
        .byte   $75
        .byte   $20
        .byte   $00
        .byte   $08
        .byte   $1D
        .byte   $00
        .byte   $00
        .byte   $46
        .byte   $01
        .byte   $AE
        .byte   $73
        .byte   $20
        .byte   $AC
        .byte   $74
        .byte   $20
        .byte   $20
        .byte   $C0
        .byte   $C0
        .byte   $AE
        .byte   $58
        .byte   $20
        .byte   $AC
        .byte   $59
        .byte   $20
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $61
        .byte   $20
        .byte   $AC
        .byte   $62
        .byte   $20
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AE
        .byte   $6A
        .byte   $20
        .byte   $AC
        .byte   $6B
        .byte   $20
        .byte   $20
        .byte   $A8
        .byte   $C2
        .byte   $AD
        .byte   $55
        .byte   $20
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   "0Nu "
        .byte   $AD
        .byte   $B6
        .byte   $BD
        .byte   $D0
        .byte   $28
        .byte   $A9
        .byte   $03
        .byte   $85
        .byte   $D0
        .byte   $A9
        .byte   $0A
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $18
        .byte   $A0
        .byte   $12
        .byte   $A9
        .text   "2 $J"
        .byte   $A9
        .byte   $0B
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $18
        .byte   $A0
        .byte   $0F
        .byte   $A9
        .text   "1 $J"
        .byte   $AD
        .text   "u P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $55
        .byte   $20
        .byte   $AD
        .byte   $57
        .byte   $20
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $01
        .byte   $F0
        .text   "(Nw "
        .byte   $AD
        .byte   $B7
        .byte   $BD
        .byte   $D0
        .byte   $20
        .byte   $AD
        .byte   $B8
        .byte   $BD
        .byte   $D0
        .byte   $1B
        .byte   $A9
        .byte   $03
        .byte   $85
        .byte   $D0
        .byte   $A9
        .byte   $0A
        .byte   $85
        .byte   $D1
        .byte   $A2
        .byte   $25
        .byte   $A0
        .byte   $12
        .byte   $A9
        .text   "! $J"
        .byte   $AD
        .text   "w P",$05
        .byte   $A2
        .byte   $03
        .byte   $8E
        .byte   $57
        .byte   $20
        .byte   $60
        .byte   $78
        .byte   $A9
        .byte   $0B
        .byte   $20
        .byte   $20
        .byte   $DD
        .byte   $20
        .byte   $D9
        .byte   $66
        .byte   $20
        .byte   $E1
        .byte   $DE
        .byte   $A2
        .byte   $00
        .byte   $A9
        .byte   $20
        .byte   $9D
        .byte   $00
        .byte   $0C
        .byte   $9D
        .byte   $00
        .byte   $E4
        .byte   $9D
        .byte   $00
        .byte   $0D
        .byte   $9D
        .byte   $00
        .byte   $E5
        .byte   $9D
        .byte   $00
        .byte   $0E
        .byte   $9D
        .byte   $00
        .byte   $E6
        .byte   $9D
        .byte   $00
        .byte   $0F
        .byte   $9D
        .byte   $00
        .byte   $E7
        .byte   $A9
        .byte   $71
        .byte   $9D
        .byte   $00
        .byte   $08
        .byte   $9D
        .byte   $00
        .byte   $E0
        .byte   $9D
        .byte   $00
        .byte   $09
        .byte   $9D
        .byte   $00
        .byte   $E1
        .byte   $E8
        .byte   $D0
        .byte   $D5
        .byte   $AD
        .byte   $13
        .byte   $FF
        .byte   $85
        .byte   $04
        .byte   $A9
        .byte   $C4
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $A9
        .byte   $D1
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $A9
        .byte   $AE
        .byte   $8D
        .byte   $15
        .byte   $FF
        .byte   $8D
        .byte   $19
        .byte   $FF
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $EC
        .byte   $21
        .byte   $9D
        .byte   $D4
        .byte   $0C
        .byte   $9D
        .byte   $D4
        .byte   $E4
        .byte   $E8
        .byte   $E0
        .byte   $0F
        .byte   $D0
        .byte   $F2
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $FB
        .byte   $21
        .byte   $9D
        .byte   $1D
        .byte   $0D
        .byte   $9D
        .byte   $1D
        .byte   $E5
        .byte   $E8
        .byte   $E0
        .byte   $1E
        .byte   $D0
        .byte   $F2
        .byte   $A9
        .byte   $1B
        .byte   $20
        .byte   $20
        .byte   $DD
        .byte   $A9
        .byte   $1F
        .byte   $20
        .byte   $7A
        .byte   $63
        .byte   $A9
        .byte   $0B
        .byte   $20
        .byte   $20
        .byte   $DD
        .byte   $20
        .byte   $A7
        .byte   $61
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $19
        .byte   $FF
        .byte   $A5
        .byte   $04
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $A9
        .byte   $08
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $AD
        .byte   $69
        .byte   $D7
        .byte   $20
        .byte   $FF
        .byte   $F9
        .byte   $A2
        .byte   $00
        .byte   $8A
        .byte   $9D
        .byte   $B8
        .byte   $BD
        .byte   $E8
        .byte   $E0
        .byte   $14
        .byte   $D0
        .byte   $F8
        .byte   $A2
        .byte   $00
        .byte   $A9
        .byte   $01
        .byte   $9D
        .byte   $5E
        .byte   $BD
        .byte   $E8
        .byte   $E0
        .byte   $5A
        .byte   $D0
        .byte   $F8
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $E4
        .byte   $60
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $B8
        .byte   $BD
        .byte   $8D
        .byte   $B9
        .byte   $BD
        .byte   $20
        .byte   $16
        .byte   $CB
        .byte   $20
        .byte   $DC
        .byte   $CA
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $FB
        .byte   $CB
        .byte   $A9
        .byte   $22
        .byte   $8D
        .byte   $FC
        .byte   $CB
        .byte   $A9
        .byte   $BB
        .byte   $8D
        .byte   $FD
        .byte   $CB
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $EA
        .byte   $70
        .byte   $A9
        .byte   $01
        .byte   $20
        .byte   $98
        .byte   $67
        .byte   $A9
        .byte   $1B
        .byte   $20
        .byte   $20
        .byte   $DD
        .byte   $58
        .byte   $60
        .byte   $03
        .byte   $0F
        .byte   $0E
        .byte   $07
        .byte   $12
        .byte   $01
        .byte   $14
        .byte   $15
        .byte   $0C
        .byte   $01
        .byte   $14
        .byte   $09
        .byte   $0F
        .byte   $0E
        .byte   $13
        .byte   $19
        .byte   $0F
        .byte   $15
        .byte   $20
        .byte   $04
        .byte   $05
        .byte   $06
        .byte   $05
        .byte   $01
        .byte   $14
        .byte   $05
        .byte   $04
        .byte   $20
        .byte   $14
        .byte   $08
        .byte   $05
        .byte   $20
        .byte   $05
        .byte   $16
        .byte   $09
        .byte   $0C
        .byte   $20
        .byte   $13
        .byte   $0F
        .byte   $12
        .byte   $03
        .text   $05,$12,$05,$12
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $05
        .byte   $17
        .byte   $1F
        .byte   $1D
        .byte   $1F
        .byte   $0F
        .byte   $0F
        .text   "??=5"
        .byte   $0F
        .byte   $05
        .byte   $05
        .fill   5,$04
        .byte   $14
        .byte   $54
        .fill   13,$00
        .byte   $40
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $F1
        .byte   $FD
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $50
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $14
        .byte   $15
        .fill   44,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .fill   8,$00
        .byte   $01
        .byte   $05
        .fill   11,$00
        .byte   $50
        .byte   $70
        .byte   $F4
        .byte   $DC
        .byte   $FC
        .byte   $FC
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $DF
        .byte   $5F
        .byte   $FC
        .text   "tteaaaaaa"
        .fill   20,$00
        .byte   $10
        .byte   $D0
        .fill   8,$00
        .byte   $40
        .byte   $50
        .fill   18,$00
        .text   "??33"
        .byte   $11
        .byte   $11
        .byte   $15
        .byte   $05
        .byte   $01
        .text   $05,"p@@"
        .fill   14,$00
        .byte   $15
        .byte   $5F
        .byte   $5D
        .byte   $5F
        .byte   $7F
        .byte   $FC
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $4D
        .byte   $41
        .byte   $40
        .byte   $10
        .byte   $14
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $05
        .fill   55,$00
        .byte   $01
        .fill   21,$00
        .byte   $01
        .text   $05,$05,$05,$07
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $3F
        .byte   $7F
        .byte   $5D
        .byte   $55
        .byte   $55
        .byte   $14
        .byte   $14
        .byte   $10
        .byte   $50
        .byte   $40
        .byte   $40
        .fill   13,$00
        .byte   $50
        .byte   $F0
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .fill   25,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $0F
        .byte   $3F
        .byte   $33
        .byte   $33
        .byte   $11
        .byte   $11
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $15
        .byte   $55
        .byte   $41
        .byte   $44
        .byte   $04
        .byte   $05
        .fill   11,$00
        .byte   $54
        .byte   $7C
        .byte   $74
        .byte   $7C
        .byte   $FC
        .byte   $FC
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   57,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $04
        .fill   13,$00
        .byte   $05
        .byte   $17
        .byte   $17
        .byte   $17
        .byte   $1F
        .byte   $0F
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $3F
        .byte   $1C
        .byte   $14
        .byte   $14
        .byte   $14
        .byte   $10
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $40
        .byte   $40
        .byte   $50
        .fill   11,$00
        .byte   $40
        .byte   $C0
        .byte   $40
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .fill   27,$00
        .byte   $01
        .text   $05,$05,$05,$07
        .byte   $0F
        .byte   $3F
        .byte   $0F
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $14
        .byte   $10
        .byte   $50
        .byte   $40
        .fill   12,$00
        .byte   $50
        .byte   $F0
        .byte   $D0
        .byte   $F4
        .byte   $F4
        .byte   $C0
        .byte   $D0
        .byte   $D0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $54
        .byte   $54
        .byte   $04
        .byte   $10
        .byte   $10
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   51,$00
        .byte   $03
        .fill   9,$00
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $04
        .fill   12,$00
        .byte   $15
        .byte   $5F
        .byte   $5D
        .byte   $5F
        .byte   $7F
        .byte   $FC
        .byte   $FD
        .byte   $FD
        .byte   $3C
        .byte   $3C
        .byte   $1C
        .byte   $15
        .byte   $15
        .text   "pqad"
        .byte   $04
        .byte   $04
        .fill   16,$00
        .byte   $40
        .byte   $40
        .fill   6,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   17,$00
        .byte   $14
        .byte   $5C
        .byte   $7D
        .byte   $77
        .byte   $7F
        .byte   $3F
        .byte   $3C
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $F7
        .byte   $37
        .byte   $15
        .byte   $15
        .byte   $11
        .byte   $05
        .byte   $04
        .byte   $01
        .byte   $01
        .fill   22,$00
        .byte   $C0
        .byte   $F0
        .byte   $34
        .byte   $04
        .byte   $00
        .byte   $00
        .text   "@@ptt"
        .byte   $10
        .fill   43,$00
        .byte   $01
        .text   $05,$07,$07,$07
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   17,$00
        .byte   $40
        .byte   $C0
        .byte   $D0
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $7F
        .byte   $73
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $54
        .byte   $44
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $01
        .fill   22,$00
        .byte   $40
        .byte   $40
        .fill   5,$00
        .byte   $40
        .byte   $40
        .fill   20,$00
        .byte   $05
        .byte   $5F
        .byte   $7D
        .byte   $77
        .byte   $3F
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $FF
        .byte   $F3
        .byte   $C3
        .byte   $C0
        .byte   $50
        .fill   22,$00
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $5F
        .byte   $7D
        .byte   $FD
        .byte   $F5
        .byte   $D5
        .byte   $55
        .fill   25,$00
        .text   "pppu",$05,$05,"u"
        .fill   31,$00
        .byte   $50
        .fill   51,$00
        .byte   $01
        .byte   $17
        .byte   $1F
        .byte   $1D
        .byte   $0F
        .byte   $03
        .byte   $0F
        .byte   $0F
        .text   "?<00"
        .byte   $14
        .fill   19,$00
        .byte   $40
        .byte   $C0
        .byte   $40
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $FF
        .byte   $D7
        .byte   $DF
        .byte   $FF
        .byte   $FD
        .byte   $35
        .byte   $15
        .fill   25,$00
        .byte   $14
        .text   "Ttuaau"
        .fill   28,$00
        .text   "@@@t"
        .fill   52,$00
        .byte   $05
        .byte   $07
        .byte   $07
        .byte   $03
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $0C
        .byte   $05
        .fill   19,$00
        .byte   $50
        .byte   $F0
        .byte   $D0
        .byte   $7C
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $F5
        .byte   $F7
        .text   "??",$0D,$05
        .fill   25,$00
        .byte   $C5
        .byte   $F5
        .text   "UUppu"
        .fill   28,$00
        .text   "pppu"
        .fill   52,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $01
        .fill   19,$00
        .byte   $14
        .byte   $7C
        .byte   $F4
        .byte   $DF
        .byte   $FF
        .byte   $3F
        .byte   $FF
        .byte   $FD
        .byte   $FD
        .byte   $CF
        .byte   $0F
        .byte   $03
        .byte   $41
        .fill   24,$00
        .byte   $C0
        .byte   $F1
        .byte   $7D
        .byte   $F5
        .byte   $F5
        .byte   $D4
        .byte   $54
        .byte   $55
        .fill   25,$00
        .text   "@@@t"
        .byte   $14
        .byte   $14
        .byte   $55
        .fill   31,$00
        .byte   $40
        .fill   10,$00
        .byte   $14
        .byte   $5F
        .byte   $7D
        .byte   $77
        .byte   $7F
        .byte   $3F
        .byte   $0F
        .text   "???331"
        .byte   $11
        .byte   $15
        .byte   $05
        .byte   $05
        .byte   $05
        .byte   $01
        .fill   15,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $FF
        .byte   $FF
        .byte   $F3
        .byte   $F1
        .byte   $F5
        .text   "Ptuue",$05
        .byte   $14
        .byte   $54
        .byte   $54
        .fill   27,$00
L28A9   .fill   18,$00
        .byte   $01
        .text   $05,$07,$07,$07
        .byte   $03
        .byte   $00
        .fill   6,$03
        .byte   $01
        .byte   $01
        .fill   17,$00
        .byte   $40
        .byte   $F0
        .byte   $DC
        .byte   $7C
        .byte   $FC
        .fill   5,$FF
        .byte   $3D
        .byte   $35
        .byte   $15
        .byte   $15
        .text   "tpqu"
        .byte   $15
        .fill   18,$00
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $10
        .byte   $50
        .byte   $00
        .text   "@pppp@@@"
        .fill   11,$00
        .byte   $01
        .byte   $17
        .byte   $1F
        .byte   $1D
        .byte   $1F
        .byte   $03
        .byte   $0F
        .text   "?<00"
        .byte   $14
        .byte   $14
        .fill   19,$00
        .byte   $40
        .byte   $C0
        .byte   $70
        .byte   $F0
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F5
        .byte   $F7
        .byte   $FD
        .byte   $35
        .byte   $15
        .byte   $14
        .byte   $14
        .byte   $14
        .byte   $15
        .byte   $15
        .fill   20,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $55
        .byte   $55
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $54
        .byte   $54
        .fill   24,$00
        .byte   $55
        .byte   $55
        .byte   $14
        .fill   53,$00
        .text   $05,$07,$07,$07
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $0C
        .byte   $05
        .byte   $05
        .fill   19,$00
        .byte   $50
        .byte   $F0
        .byte   $DC
        .byte   $7C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .text   "=?",$0D,$05,$05,$05,$05,$05,$05
        .fill   19,$00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $C0
        .byte   $55
        .byte   $55
        .byte   $50
        .byte   $00
        .byte   $00
        .byte   $10
        .byte   $55
        .byte   $55
        .fill   24,$00
        .byte   $55
        .byte   $55
        .byte   $05
        .fill   29,$00
        .byte   $40
        .byte   $40
        .fill   22,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .fill   19,$00
        .byte   $14
        .byte   $7C
        .byte   $F7
        .byte   $DF
        .byte   $FF
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $CF
        .byte   $0F
        .byte   $03
        .byte   $41
        .byte   $41
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   19,$00
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $5C
        .byte   $70
        .text   "Uut@@duu"
        .fill   24,$00
        .byte   $55
        .byte   $55
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .fill   24,$00
        .byte   $50
        .byte   $50
        .byte   $40
        .fill   52,$00
        .byte   $05
        .byte   $5F
        .byte   $7D
        .byte   $77
        .byte   $7F
        .byte   $0F
        .byte   $3F
        .byte   $FF
        .byte   $F3
        .byte   $C3
        .byte   $C0
        .byte   $50
        .byte   $50
        .fill   21,$00
        .byte   $C0
        .byte   $C0
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $D7
        .byte   $DC
        .byte   $F5
        .text   "Uuppquu"
        .fill   24,$00
        .byte   $55
        .byte   $55
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $50
        .byte   $50
        .fill   24,$00
        .byte   $54
        .byte   $54
        .byte   $50
        .fill   29,$00
        .byte   $03
        .byte   $0F
        .text   "???<",$05,$05,$05
        .byte   $15
        .byte   $15
        .byte   $11
        .byte   $11
        .byte   $41
        .byte   $41
        .fill   13,$00
        .byte   $14
        .byte   $15
        .byte   $5C
        .byte   $7C
        .byte   $FF
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $14
        .byte   $04
        .fill   8,$00
        .byte   $40
        .fill   17,$00
        .byte   $C5
        .byte   $01
        .fill   64,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $04
        .byte   $04
        .fill   13,$00
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $07
        .byte   $3F
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $F1
        .byte   $C0
        .text   "ppppp"
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $14
        .fill   13,$00
        .byte   $40
        .byte   $50
        .byte   $C0
        .byte   $C0
        .byte   $FC
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .fill   26,$00
        .byte   $50
        .byte   $10
        .fill   24,$00
        .text   "am]oOC"
        .byte   $FF
        .byte   $3F
        .byte   $0F
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $01
L2CA9   .byte   $04
        .byte   $04
        .byte   $14
        .byte   $14
        .fill   15,$00
        .text   "@pppp"
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FD
        .byte   $4D
        .byte   $40
        .byte   $40
        .fill   6,$10
        .byte   $14
        .byte   $14
        .fill   43,$00
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $04
        .byte   $0C
        .byte   $0C
        .byte   $0F
        .byte   $03
        .fill   7,$00
        .byte   $01
        .byte   $01
        .fill   15,$00
        .byte   $14
        .byte   $D5
        .byte   $D5
        .byte   $F5
        .byte   $F5
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $14
        .byte   $14
        .byte   $14
        .text   "aaaa"
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   18,$00
        .byte   $C0
        .byte   $C0
        .byte   $D0
        .byte   $D0
        .fill   8,$00
        .byte   $40
        .byte   $40
        .fill   11,$00
        .byte   $01
        .text   $05,$05,$05,$05
        .byte   $03
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $7F
        .byte   $71
        .byte   $01
        .byte   $01
        .fill   6,$04
        .byte   $14
        .byte   $14
        .fill   11,$00
        .byte   $41
        .byte   $71
        .byte   $75
        .byte   $F1
        .byte   $F3
        .byte   $C3
        .byte   $FF
        .byte   $FC
        .byte   $F0
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $10
        .byte   $10
        .byte   $14
        .byte   $14
        .fill   54,$00
        .byte   $03
        .byte   $03
        .byte   $07
        .byte   $07
        .fill   8,$00
        .byte   $01
        .byte   $01
        .fill   11,$00
        .byte   $14
        .byte   $57
        .byte   $57
        .byte   $5F
        .byte   $5F
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $14
        .byte   $14
        .byte   $14
        .text   "aaaa@@@@"
        .fill   11,$00
        .byte   $10
        .byte   $10
        .byte   $50
        .byte   $10
        .byte   $30
        .byte   $30
        .byte   $F0
        .byte   $C0
        .fill   7,$00
        .byte   $40
        .byte   $40
        .fill   15,$00
        .byte   $01
        .text   $05,$05,$07,$07,$07
        .byte   $03
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $3F
        .byte   $71
        .byte   $41
        .fill   6,$01
        .byte   $05
        .byte   $05
        .fill   11,$00
        .byte   $40
        .byte   $50
        .byte   $F0
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .text   "ma@@@@@@pp"
        .fill   51,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $07
        .byte   $04
        .fill   19,$00
        .byte   $14
        .byte   $55
        .byte   $5F
        .byte   $7D
        .byte   $7F
        .byte   $7F
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .fill   8,$14
        .byte   $55
        .byte   $55
        .fill   19,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $D0
        .byte   $10
        .fill   19,$00
        .byte   $01
        .byte   $05
        .byte   $0F
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $3F
        .byte   $71
        .byte   $41
        .fill   6,$01
        .byte   $05
        .byte   $05
        .fill   11,$00
        .text   "@ppPPP"
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .text   "ma@@@@@@pp"
        .fill   51,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $07
        .byte   $04
        .fill   19,$00
        .byte   $14
        .byte   $55
        .byte   $F5
        .byte   $7D
        .byte   $FD
        .byte   $FD
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .fill   8,$14
        .byte   $55
        .byte   $55
        .fill   19,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $D0
        .byte   $10
        .fill   22,$00
        .byte   $01
        .text   $05,$05,$05,$05
        .byte   $01
        .byte   $43
        .byte   $7F
        .byte   $7F
        .byte   $F3
        .byte   $C3
        .byte   $01
        .byte   $05
        .byte   $15
        .byte   $54
        .byte   $50
        .byte   $14
        .byte   $04
        .fill   14,$00
        .text   "@pppp@A"
        .byte   $FD
        .byte   $FD
        .text   "OC@pt"
        .byte   $15
        .byte   $05
        .byte   $14
        .byte   $10
        .fill   52,$00
        .byte   $04
        .byte   $07
        .byte   $07
        .byte   $0F
        .byte   $0C
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $01
        .fill   15,$00
        .byte   $14
        .text   "uuuu"
        .byte   $14
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $3C
        .byte   $3C
        .byte   $14
        .byte   $55
        .byte   $55
        .byte   $41
        .byte   $00
        .byte   $41
        .byte   $41
        .fill   20,$00
        .byte   $10
        .byte   $D0
        .byte   $D0
        .byte   $F0
        .byte   $30
        .byte   $00
        .byte   $00
        .text   "@pp@"
        .fill   12,$00
        .text   "aeueEA"
        .byte   $F3
        .byte   $3F
        .byte   $3F
        .byte   $0F
        .byte   $03
        .fill   7,$01
        .byte   $05
        .byte   $04
        .byte   $10
        .fill   11,$00
        .text   "aquqscO"
        .byte   $FC
        .byte   $FC
        .byte   $F0
        .byte   $C0
        .text   "@@@@@@@p"
        .byte   $10
        .byte   $04
        .fill   43,$00
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $04
        .byte   $0C
        .byte   $0C
        .byte   $0F
        .byte   $03
        .byte   $03
        .fill   11,$00
        .byte   $01
        .fill   11,$00
        .byte   $14
        .text   "uuuu"
        .byte   $14
        .byte   $3C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $3C
        .fill   7,$14
        .byte   $55
        .byte   $41
        .fill   12,$00
        .byte   $10
        .byte   $10
        .byte   $50
        .byte   $10
        .byte   $30
        .byte   $30
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .fill   11,$00
        .byte   $40
        .fill   13,$00
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $4F
        .byte   $7F
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $14
        .byte   $54
        .fill   11,$00
        .byte   $50
        .byte   $D4
        .byte   $F4
        .byte   $74
        .byte   $F4
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $7C
        .byte   $5C
        .byte   $F0
        .byte   $50
        .byte   $50
        .fill   5,$10
        .byte   $14
        .byte   $15
        .fill   52,$00
        .byte   $04
        .byte   $07
        .fill   8,$00
        .byte   $01
        .byte   $05
        .fill   11,$00
        .text   $05,$0D,$1F,"7??"
        .byte   $0F
        .byte   $0F
        .byte   $3F
        .byte   $F7
        .byte   $F5
        .byte   $3F
        .byte   $15
        .byte   $15
        .text   "qaaaaaa"
        .fill   12,$00
        .text   "@@@@"
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .fill   8,$00
        .byte   $40
        .byte   $50
        .fill   13,$00
        .byte   $54
        .byte   $F5
        .byte   $75
        .byte   $F5
        .byte   $FD
        .byte   $3F
        .byte   $0F
        .byte   $3F
        .byte   $3F
        .byte   $3F
        .byte   $71
        .byte   $41
        .byte   $01
        .byte   $04
        .byte   $14
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $50
        .fill   18,$00
        .byte   $FC
        .byte   $FC
        .text   "LLddtp@p",$05
        .byte   $01
        .byte   $01
        .fill   46,$00
        .byte   $05
        .byte   $0F
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $03
        .fill   26,$00
        .text   "@pppP"
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $FD
        .byte   $75
        .byte   $55
        .byte   $55
        .byte   $14
        .byte   $14
        .byte   $04
        .byte   $05
        .byte   $01
        .byte   $01
        .fill   23,$00
        .byte   $40
        .fill   19,$00
        .byte   $15
        .byte   $3D
        .byte   $1D
        .byte   $3D
        .byte   $3F
        .byte   $3F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   19,$00
        .text   "@@@@"
        .byte   $00
        .byte   $F0
        .byte   $FC
        .text   "LLdd@@@tua"
        .byte   $11
        .byte   $10
        .byte   $50
        .fill   43,$00
        .byte   $01
        .byte   $03
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .fill   26,$00
        .text   "pTTT"
        .byte   $F4
        .byte   $F0
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $FC
        .byte   $34
        .byte   $14
        .byte   $14
        .byte   $14
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $00
        .byte   $00
L3333   .fill   16,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $50
        .byte   $10
        .byte   $10
        .fill   14,$00
        .byte   $05
        .byte   $0F
        .byte   $07
        .byte   $1F
        .byte   $1F
        .byte   $03
        .byte   $07
        .byte   $07
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $15
        .byte   $15
        .byte   $10
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   13,$00
        .text   "@pppP"
        .byte   $F0
        .byte   $FC
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .text   "@@@pp"
        .byte   $10
        .byte   $14
        .byte   $04
        .byte   $05
        .byte   $01
        .fill   47,$00
        .byte   $01
        .byte   $01
        .fill   6,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
L33CC   .fill   17,$00
        .byte   $54
        .byte   $F5
        .byte   $75
        .byte   $F5
        .byte   $FD
        .byte   $3F
        .byte   $7F
        .byte   $7F
        .text   "<<4tt",$05,"ea"
        .byte   $11
        .byte   $10
        .byte   $10
        .fill   19,$00
        .byte   $C0
        .fill   9,$00
        .byte   $40
        .byte   $40
        .byte   $50
        .byte   $10
        .fill   12,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $FF
        .byte   $FF
        .byte   $CF
        .byte   $4F
        .byte   $5F
        .byte   $07
        .byte   $15
        .text   "uuqp"
        .byte   $14
        .byte   $15
        .byte   $15
        .fill   13,$00
        .byte   $14
        .byte   $F5
        .byte   $7D
        .byte   $DD
        .byte   $FD
        .byte   $FC
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .text   "LLldtppp@"
        .fill   50,$00
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $04
        .byte   $05
        .byte   $00
        .byte   $01
        .text   $05,$05,$05,$05
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   13,$00
        .byte   $01
        .byte   $0F
        .byte   $37
        .byte   $3D
        .byte   $3F
        .fill   5,$FF
        .byte   $7C
        .byte   $5C
        .byte   $54
        .byte   $54
        .byte   $15
        .text   $05,"eut"
        .fill   13,$00
        .text   "@pPPP"
        .byte   $C0
        .byte   $00
        .fill   6,$C0
        .byte   $40
        .byte   $40
        .fill   24,$00
        .byte   $55
        .byte   $55
        .byte   $14
        .fill   25,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $55
        .byte   $55
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $15
        .byte   $15
        .fill   15,$00
        .byte   $01
        .byte   $03
        .byte   $0D
        .byte   $0F
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $5F
        .byte   $DF
        .byte   $7F
        .byte   $5C
        .byte   $54
        .byte   $14
        .byte   $14
        .byte   $14
        .byte   $54
        .byte   $54
        .fill   15,$00
        .byte   $40
        .byte   $D4
        .byte   $F4
        .byte   $74
        .byte   $F4
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $3C
        .byte   $0C
        .byte   $0C
        .byte   $14
        .byte   $14
        .fill   60,$00
        .byte   $15
        .byte   $15
        .byte   $05
        .fill   29,$00
        .byte   $55
        .byte   $55
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $05
        .byte   $05
        .fill   17,$00
        .byte   $03
        .byte   $03
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $D7
        .byte   $37
        .byte   $5F
        .text   "wu",$05,$05,"euu"
        .fill   15,$00
        .byte   $50
        .byte   $F5
        .byte   $7D
        .byte   $DD
        .byte   $FD
        .byte   $F0
        .byte   $FC
        .byte   $FF
        .byte   $CF
        .byte   $C3
        .byte   $03
        .byte   $05
        .byte   $05
        .fill   60,$00
        .byte   $05
        .byte   $05
        .byte   $01
        .fill   29,$00
        .byte   $55
        .byte   $55
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .fill   19,$00
        .byte   $0F
        .text   "??5",$0D,"wu"
        .byte   $15
        .byte   $01
        .byte   $01
        .byte   $11
        .byte   $55
        .byte   $55
        .fill   15,$00
        .byte   $14
        .byte   $3D
        .byte   $DF
        .byte   $F7
        .byte   $FF
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $F3
        .byte   $F0
        .byte   $C0
        .text   "aa@@@@"
        .fill   16,$00
        .text   "@@@@"
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $40
        .byte   $40
        .fill   28,$00
        .byte   $01
        .byte   $01
        .fill   30,$00
        .byte   $55
        .byte   $55
        .byte   $50
        .fill   24,$00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0D
        .byte   $03
        .byte   $55
        .byte   $55
        .byte   $05
        .byte   $00
        .byte   $00
        .byte   $04
        .byte   $55
        .byte   $55
        .fill   15,$00
        .byte   $05
        .byte   $0F
        .byte   $37
        .byte   $3D
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7F
        .byte   $7C
        .byte   $FC
        .byte   $70
        .text   "pppppp"
        .fill   16,$00
        .text   "pPPP"
        .byte   $00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .text   "00pp"
        .fill   28,$00
        .byte   $53
        .byte   $40
        .fill   26,$00
        .byte   $14
        .byte   $54
        .byte   $35
        .byte   $3D
        .byte   $FF
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $14
        .byte   $10
        .fill   8,$00
        .byte   $01
        .fill   17,$00
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .text   "<pppttddaa"
        .fill   49,$00
        .byte   $05
        .byte   $04
        .fill   26,$00
        .byte   $01
        .byte   $05
        .byte   $03
        .byte   $03
        .byte   $3F
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .fill   22,$00
        .text   "@@pP"
        .byte   $FC
        .text   "???o"
        .byte   $03
        .text   $05,$05,$05,$05,$05
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $14
        .fill   19,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $00
        .text   "@@@@"
        .byte   $10
        .byte   $10
        .fill   13,$00
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $3F
        .byte   $73
        .byte   $41
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $15
        .byte   $55
        .byte   $54
        .byte   $10
        .fill   11,$00
        .byte   $50
        .byte   $D4
        .byte   $F4
        .byte   $74
        .byte   $F4
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $7C
        .byte   $70
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $40
        .byte   $40
        .fill   57,$00
        .byte   $03
        .byte   $07
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $01
        .fill   11,$00
        .text   $05,$0D,$1F,"7??"
        .byte   $0F
        .byte   $0F
        .byte   $3F
        .byte   $FF
        .byte   $F7
        .byte   $37
        .byte   $15
        .byte   $15
        .byte   $11
        .text   "tdpp@"
        .fill   13,$00
        .text   "@@@@"
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .fill   38,$00
        .text   $05,$05,$05,"u"
        .fill   25,$00
        .byte   $53
        .byte   $5F
        .text   "ww",$05,$05,"u"
        .fill   19,$00
        .byte   $05
        .byte   $0F
        .byte   $07
        .byte   $3D
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $5F
        .byte   $DF
        .byte   $FC
        .byte   $FC
        .byte   $70
        .byte   $50
        .fill   20,$00
        .byte   $50
        .byte   $D0
        .byte   $D0
        .byte   $C0
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $30
        .byte   $50
        .fill   60,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $15
        .fill   25,$00
        .byte   $14
        .byte   $17
        .byte   $15
        .text   "uaau"
        .fill   19,$00
        .byte   $01
        .byte   $03
        .byte   $01
        .byte   $0F
        .byte   $0F
        .byte   $3F
        .byte   $FF
        .byte   $D7
        .byte   $F7
        .byte   $FF
        .byte   $7F
        .byte   $5C
        .byte   $54
        .fill   19,$00
        .byte   $40
        .byte   $D4
        .byte   $F4
        .byte   $74
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $3C
        .byte   $0C
        .byte   $0C
        .byte   $14
        .fill   63,$00
        .byte   $05
        .fill   25,$00
        .text   $05,$05,$05,"uppu"
        .fill   22,$00
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $3F
        .byte   $F5
        .byte   $7D
        .byte   $7F
        .byte   $5F
        .byte   $57
        .byte   $55
        .fill   19,$00
        .byte   $50
        .byte   $F5
        .byte   $7D
        .byte   $DD
        .byte   $FC
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FF
        .byte   $CF
        .byte   $C3
        .byte   $03
        .byte   $05
        .fill   63,$00
        .byte   $01
        .fill   25,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $15
        .byte   $14
        .byte   $14
        .byte   $55
        .fill   24,$00
        .byte   $03
        .byte   $4F
        .byte   $7D
        .byte   $5F
        .byte   $5F
        .byte   $17
        .byte   $15
        .byte   $55
        .fill   19,$00
        .byte   $14
        .byte   $3D
        .byte   $1F
        .byte   $F7
        .byte   $FF
        .byte   $FC
        .byte   $FF
        .byte   $7F
        .byte   $7F
        .byte   $F3
        .byte   $F0
        .byte   $C0
        .byte   $41
        .fill   20,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $40
        .fill   26,$00
        .text   $05,$05,"uu",$05
        .fill   29,$00
        .byte   $05
        .byte   $55
        .byte   $55
        .fill   27,$00
        .byte   $05
        .byte   $07
        .byte   $07
        .byte   $7F
        .byte   $D7
        .byte   $C3
        .fill   25,$00
        .byte   $50
        .byte   $F0
        .byte   $D0
        .byte   $70
        .byte   $F0
        .byte   $F4
        .byte   $C0
        .fill   60,$00
        .byte   $05
        .byte   $05
        .fill   28,$00
        .text   "pppuu"
        .fill   29,$00
        .byte   $50
        .byte   $57
        .byte   $5D
        .byte   $0C
        .fill   25,$00
        .byte   $05
        .byte   $5F
        .byte   $7D
        .byte   $77
        .byte   $FF
        .byte   $7F
        .byte   $3C
        .fill   30,$00
        .byte   $40
        .fill   26,$00
        .byte   $14
        .text   "=",$1F,"7?"
        .byte   $7F
        .byte   $0F
        .fill   26,$00
        .byte   $40
        .byte   $40
        .byte   $41
        .byte   $F5
        .byte   $5D
        .byte   $0C
        .fill   26,$00
        .byte   $01
        .byte   $01
        .byte   $41
        .byte   $55
        .byte   $55
        .fill   27,$00
        .text   "@@tt@"
        .fill   58,$00
        .byte   $01
        .byte   $03
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $07
        .fill   26,$00
        .byte   $40
        .byte   $D4
        .byte   $F4
        .byte   $74
        .byte   $FF
        .byte   $F5
        .byte   $F0
        .fill   28,$00
        .byte   $14
        .byte   $55
        .byte   $D5
        .byte   $C0
        .fill   26,$00
        .byte   $14
        .byte   $14
        .byte   $15
        .byte   $55
        .byte   $54
        .fill   29,$00
        .byte   $40
        .byte   $40
        .fill   13,$00
        .byte   $55
        .byte   $00
        .byte   $05
        .byte   $05
        .byte   $00
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $15
        .byte   $15
        .byte   $55
        .byte   $55
        .byte   $45
        .byte   $01
        .byte   $05
        .byte   $15
        .byte   $14
        .byte   $10
        .byte   $15
        .byte   $15
        .byte   $01
        .fill   11,$00
        .byte   $55
        .byte   $14
        .byte   $04
        .text   "dddddttp@@"
        .byte   $00
        .text   "@@@p"
        .byte   $10
        .byte   $10
        .byte   $10
        .fill   43,$00
        .byte   $05
        .fill   7,$00
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $00
        .byte   $00
        .fill   5,$01
        .fill   12,$00
        .byte   $55
        .byte   $01
        .byte   $50
        .byte   $54
        .byte   $04
        .byte   $54
        .byte   $54
        .byte   $14
        .text   "uuutt"
        .byte   $10
        .text   "ttd",$05,"qq"
        .byte   $11
        .fill   11,$00
        .text   "p@@@@@@@@@"
        .fill   22,$00
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $14
        .byte   $15
        .byte   $05
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $45
        .byte   $45
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $01
        .fill   12,$00
        .byte   $40
        .byte   $10
        .byte   $04
        .byte   $01
        .byte   $05
        .byte   $14
        .text   "pp@@@p@pt"
        .byte   $04
        .byte   $04
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   47,$00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $04
        .byte   $04
        .fill   16,$00
        .byte   $04
        .byte   $01
        .byte   $00
        .byte   $00
        .text   "@pquuttttut"
        .byte   $14
        .byte   $14
        .byte   $15
        .byte   $05
        .byte   $01
        .byte   $05
        .fill   13,$00
        .byte   $40
        .byte   $10
        .byte   $10
        .byte   $40
        .byte   $40
        .fill   27,$00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $05
        .byte   $11
        .byte   $50
        .byte   $10
        .byte   $15
        .byte   $05
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $14
        .byte   $14
        .byte   $50
        .fill   14,$00
        .byte   $01
        .byte   $04
        .text   "pppptttttuu"
        .byte   $14
        .byte   $14
        .byte   $10
        .byte   $10
        .byte   $04
        .byte   $05
        .byte   $01
        .byte   $05
        .fill   49,$00
        .byte   $01
        .byte   $05
        .byte   $01
        .byte   $01
        .fill   5,$00
        .byte   $01
        .byte   $01
        .byte   $05
        .fill   16,$00
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $55
        .byte   $15
        .text   $05,$05,"uu",$05
        .byte   $15
        .text   "qaaa"
        .fill   15,$00
        .byte   $10
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .text   "@@@@@pp@@"
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $50
        .byte   $10
        .byte   $50
        .fill   25,$00
        .byte   $15
        .fill   25,$00
        .byte   $15
        .byte   $15
        .byte   $01
        .byte   $15
        .byte   $15
        .byte   $01
        .byte   $55
        .byte   $01
        .byte   $15
        .byte   $14
        .byte   $15
        .byte   $01
        .fill   23,$00
        .text   "@ttttt"
        .byte   $15
        .byte   $41
        .byte   $41
        .byte   $40
        .fill   28,$00
        .byte   $40
        .byte   $40
        .byte   $54
        .byte   $04
        .fill   57,$00
        .byte   $05
        .fill   25,$00
        .byte   $05
        .byte   $05
        .byte   $00
        .byte   $05
        .byte   $05
        .byte   $00
        .byte   $55
        .byte   $00
        .byte   $05
        .byte   $05
        .byte   $05
        .fill   21,$00
        .text   "@@@puuuuu",$05,"pp"
        .byte   $10
        .fill   28,$00
        .byte   $50
        .byte   $50
        .byte   $55
        .byte   $01
        .fill   57,$00
        .byte   $01
        .fill   25,$00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $55
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   21,$00
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $54
        .byte   $55
        .byte   $15
        .byte   $55
        .byte   $15
        .byte   $55
        .byte   $41
        .byte   $54
        .byte   $14
        .byte   $04
        .fill   23,$00
        .text   "@@@@@t"
        .byte   $14
        .byte   $15
        .fill   31,$00
        .byte   $40
        .byte   $40
        .fill   57,$00
        .byte   $55
        .fill   25,$00
        .byte   $54
        .byte   $54
        .byte   $04
        .text   "uu",$05,"u",$05,"upu",$05
        .byte   $01
        .fill   23,$00
        .text   "pppppu",$05,$05
        .fill   31,$00
        .byte   $50
        .byte   $10
        .fill   10,$00
        .byte   $01
        .byte   $01
        .byte   $04
        .byte   $05
        .byte   $11
        .byte   $50
        .byte   $41
        .byte   $41
        .byte   $10
        .byte   $05
        .byte   $01
        .byte   $10
        .byte   $15
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $14
        .fill   16,$00
        .text   "@ppptuutut"
        .byte   $14
        .byte   $54
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $40
        .byte   $40
        .fill   48,$00
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .fill   5,$00
        .byte   $01
        .fill   13,$00
        .byte   $10
        .byte   $10
        .byte   $40
        .byte   $54
        .byte   $15
        .byte   $05
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $55
        .byte   $15
        .byte   $05
        .byte   $55
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $15
        .byte   $11
        .byte   $44
        .byte   $04
        .fill   19,$00
        .text   "@pp@p@@@"
        .fill   30,$00
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $44
        .byte   $45
        .byte   $41
        .byte   $15
        .byte   $05
        .fill   24,$00
        .byte   $01
        .byte   $05
        .byte   $01
        .byte   $04
        .byte   $04
        .text   "auuu"
        .fill   24,$00
        .byte   $55
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $11
        .byte   $11
        .byte   $55
        .byte   $55
        .fill   55,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $01
        .fill   28,$00
        .byte   $40
        .byte   $50
        .byte   $14
        .byte   $55
        .byte   $55
        .byte   $05
        .fill   23,$00
        .byte   $10
        .byte   $55
        .byte   $10
        .byte   $40
        .byte   $40
        .byte   $11
        .byte   $51
        .byte   $55
        .byte   $55
        .fill   24,$00
        .byte   $50
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $10
        .byte   $10
        .byte   $50
        .byte   $50
        .fill   14,$00
        .byte   $05
        .byte   $05
        .byte   $00
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $05
        .byte   $15
        .byte   $15
        .byte   $15
        .text   "ea",$05,$05
        .byte   $14
        .byte   $10
        .byte   $10
        .byte   $50
        .fill   13,$00
        .byte   $01
        .byte   $01
        .text   "aaaaaqquuqaqp"
        .byte   $10
        .byte   $14
        .byte   $04
        .byte   $05
        .fill   53,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $04
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $05
        .fill   14,$00
        .byte   $50
        .byte   $54
        .byte   $04
        .byte   $54
        .byte   $54
        .byte   $14
        .text   "uuuuu"
        .byte   $14
        .byte   $55
        .byte   $55
        .byte   $41
        .byte   $01
        .fill   15,$00
        .fill   9,$10
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .byte   $50
        .fill   11,$00
        .byte   $55
        .byte   $14
        .byte   $10
        .fill   5,$11
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $04
        .byte   $04
        .fill   11,$00
        .byte   $55
        .byte   $00
        .byte   $50
        .byte   $50
        .byte   $00
        .text   "pp@ttuuq@pt"
        .byte   $14
        .byte   $04
        .byte   $54
        .byte   $54
        .byte   $40
        .fill   43,$00
        .byte   $05
        .fill   9,$01
        .fill   22,$00
        .byte   $55
        .byte   $40
        .byte   $05
        .byte   $15
        .byte   $10
        .byte   $15
        .byte   $15
        .byte   $14
        .byte   $55
        .byte   $55
        .byte   $55
        .byte   $15
        .byte   $15
        .byte   $04
        .byte   $15
        .byte   $15
        .byte   $11
        .text   "peed"
        .fill   11,$00
        .byte   $50
        .fill   7,$00
        .text   "@@pp"
        .byte   $10
        .byte   $00
        .byte   $00
        .text   "@@@@@"
        .fill   13,$00
        .byte   $01
        .byte   $04
        .byte   $10
        .byte   $40
        .byte   $50
        .byte   $14
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $01
        .byte   $05
        .byte   $15
        .byte   $10
        .byte   $10
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   11,$00
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $14
        .text   "tpttptttqq"
        .byte   $10
        .byte   $10
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $40
        .fill   45,$00
        .byte   $01
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $01
        .fill   25,$00
        .byte   $10
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $01
        .text   $05,"euu"
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $55
        .byte   $15
        .byte   $14
        .byte   $14
        .text   "tp@p"
        .fill   15,$00
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $40
        .byte   $40
        .byte   $00
        .text   "@@@@"
        .byte   $10
        .byte   $10
        .fill   16,$00
        .byte   $40
        .byte   $10
        .text   $05,$05,$05,$05
        .fill   5,$15
        .byte   $55
        .byte   $55
        .byte   $14
        .byte   $14
        .byte   $04
        .byte   $04
        .byte   $10
        .byte   $50
        .byte   $40
        .byte   $50
        .fill   13,$00
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $50
        .byte   $44
        .byte   $05
        .byte   $04
        .byte   $54
        .byte   $50
        .byte   $00
        .byte   $40
        .byte   $50
        .byte   $10
        .byte   $14
        .byte   $14
        .byte   $05
        .fill   46,$00
        .byte   $04
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .fill   5,$01
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $05
        .byte   $00
        .byte   $00
L4753   .fill   11,$00
        .text   "ttputppuupteaaa"
        .fill   21,$00
        .text   "@p@@"
        .fill   5,$00
        .byte   $40
        .byte   $40
        .byte   $50
        .fill   31,$00
        .byte   $01
        .byte   $01
        .byte   $15
        .byte   $10
        .fill   22,$00
        .byte   $01
        .fill   5,$15
        .byte   $54
        .byte   $41
        .byte   $41
        .byte   $01
        .fill   19,$00
        .text   "tt@tt@u@t"
        .byte   $14
        .byte   $54
        .byte   $40
        .fill   26,$00
        .byte   $54
        .fill   68,$00
        .byte   $05
        .byte   $04
        .fill   23,$00
        .text   $05,$05,$05,$05,$05,"upp"
        .fill   20,$00
        .byte   $15
        .byte   $15
        .byte   $10
        .text   "uupupu",$05,"up@"
        .fill   25,$00
        .byte   $55
        .fill   68,$00
        .byte   $01
        .byte   $01
        .fill   23,$00
        .fill   5,$01
        .byte   $15
        .byte   $14
        .byte   $54
        .fill   20,$00
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $15
        .text   "ututua"
        .byte   $15
        .byte   $14
        .byte   $10
        .fill   19,$00
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $55
        .byte   $00
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   27,$00
        .byte   $40
        .fill   66,$00
        .text   $05,$05,"u@"
        .fill   19,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .text   $05,"uuuuup",$05,$05
        .byte   $04
        .fill   19,$00
        .byte   $50
        .byte   $50
        .byte   $00
        .byte   $50
        .byte   $50
        .byte   $00
        .byte   $55
        .byte   $00
        .byte   $50
        .byte   $50
        .byte   $50
        .fill   27,$00
        .byte   $50
        .fill   19,$00
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $05
        .byte   $15
        .byte   $55
        .byte   $55
        .byte   $15
        .byte   $55
        .byte   $15
        .byte   $14
        .byte   $15
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $01
        .byte   $01
        .fill   12,$00
        .byte   $40
        .byte   $40
        .byte   $10
        .text   "pd",$05,"aa"
        .byte   $04
        .byte   $50
        .byte   $40
        .byte   $04
        .byte   $54
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .byte   $14
        .fill   52,$00
        .byte   $01
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   17,$00
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $15
        .text   "tpttputpu@pptd"
        .byte   $11
        .byte   $10
        .fill   16,$00
        .byte   $40
        .byte   $50
        .byte   $10
        .byte   $10
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .fill   5,$00
        .byte   $40
        .fill   27,$00
        .byte   $55
        .byte   $00
        .byte   $00
        .byte   $00
        .text   "dduu"
        .fill   23,$00
        .byte   $40
        .byte   $50
        .byte   $40
        .byte   $10
        .byte   $10
        .text   "auuu"
        .fill   23,$00
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $11
        .text   "qatp"
        .fill   57,$00
        .byte   $05
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $05
        .fill   23,$00
        .byte   $04
        .byte   $55
        .byte   $04
        .byte   $01
        .byte   $01
        .text   "deuu"
        .fill   26,$00
        .byte   $01
        .byte   $05
        .byte   $14
        .byte   $55
        .byte   $55
        .byte   $50
        .fill   23,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $40
        .fill   15,$00
        .text   "@@aaaaaeeuueae",$05
        .byte   $04
        .byte   $14
        .byte   $10
        .byte   $50
        .fill   14,$00
        .byte   $50
        .byte   $50
        .byte   $00
        .text   "pp@ptttqapp"
        .byte   $14
        .byte   $04
        .byte   $04
        .byte   $05
        .fill   45,$00
        .fill   9,$04
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $05
        .fill   14,$00
        .byte   $05
        .byte   $15
        .byte   $10
        .byte   $15
        .byte   $15
        .byte   $14
        .text   "uuuuu"
        .byte   $14
        .text   "uua@"
        .fill   23,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $10
        .byte   $10
        .byte   $00
        .byte   $00
        .text   "@@@p"
        .fill   13,$00
        .fill   5,$01
        .byte   $05
        .byte   $05
        .byte   $05
        .byte   $15
        .text   "qa",$05,$05
        .byte   $04
        .byte   $14
        .byte   $14
        .fill   14,$00
        .byte   $01
        .text   "qqqqqaquuqq@@p"
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $10
        .byte   $14
        .byte   $14
        .fill   53,$00
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .fill   15,$00
        .byte   $05
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $14
        .text   "uuuu"
        .byte   $15
        .byte   $14
        .text   "tuaaa"
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   11,$00
        .fill   8,$10
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $10
        .fill   7,$00
        .byte   $40
        .byte   $40
        .fill   12,$00
        .text   $05,$05,$05,$05,"eae"
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $14
        .byte   $14
        .fill   13,$00
        .text   "aaaaaqqqueaqp"
        .byte   $10
        .byte   $14
        .byte   $14
        .fill   51,$00
        .byte   $04
        .byte   $04
        .byte   $04
        .byte   $01
        .byte   $01
        .fill   9,$00
        .byte   $01
        .byte   $01
        .fill   12,$00
        .text   "ptttt"
        .byte   $14
        .text   "uuuut"
        .byte   $14
        .byte   $15
        .text   "uaaa@@@"
        .fill   13,$00
        .fill   8,$10
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $40
        .byte   $40
        .fill   14,$00
        .byte   $47
        .byte   $5F
        .byte   $5D
        .byte   $5F
        .byte   $1F
        .byte   $1D
        .byte   $3D
        .byte   $0D
        .byte   $3F
        .byte   $FF
        .byte   $F7
        .byte   $F5
        .byte   $35
        .byte   $3F
        .byte   $15
        .text   "5=<00<"
        .fill   11,$00
        .byte   $C0
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $F1
        .byte   $41
        .byte   $45
        .byte   $71
        .byte   $F3
        .byte   $C3
        .byte   $FF
        .byte   $FF
        .byte   $FC
L4E49   .byte   $F0
        .byte   $50
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $30
        .byte   $3C
        .fill   43,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $03
        .byte   $01
        .fill   6,$03
        .fill   11,$00
        .byte   $7C
        .byte   $FD
        .byte   $DF
        .byte   $FF
        .byte   $FF
        .byte   $D4
        .byte   $D4
        .byte   $D7
        .byte   $FF
        .byte   $FC
        .byte   $7F
        .byte   $5F
        .byte   $5F
        .byte   $FF
        .byte   $55
        .byte   $57
        .byte   $DF
        .byte   $CF
        .byte   $03
        .byte   $03
        .byte   $C3
        .fill   15,$00
        .byte   $10
        .byte   $10
        .byte   $50
        .byte   $10
        .byte   $30
        .byte   $30
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .fill   7,$00
        .byte   $C0
        .fill   11,$00
        .byte   $57
        .byte   $5F
        .byte   $1D
        .text   $1F,$1F,"???"
        .byte   $F7
        .byte   $F5
        .byte   $F5
        .byte   $35
        .byte   $3F
        .byte   $3F
        .byte   $15
        .text   "5=<00<"
        .fill   11,$00
        .byte   $C0
        .byte   $F0
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $50
        .byte   $F0
        .byte   $C1
        .byte   $FD
        .byte   $FD
        .byte   $FD
        .byte   $F0
        .byte   $F0
        .byte   $50
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $30
        .byte   $3C
        .fill   43,$00
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $01
        .fill   6,$03
        .fill   11,$00
        .byte   $7C
        .byte   $FF
        .byte   $DD
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F5
        .byte   $FF
        .byte   $7C
        .byte   $5F
        .byte   $5F
        .byte   $5F
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $57
        .byte   $DF
        .byte   $CF
        .byte   $03
        .byte   $03
        .byte   $C3
        .fill   19,$00
        .byte   $10
        .byte   $D0
        .byte   $D0
        .byte   $D0
        .fill   8,$00
        .byte   $C0
        .fill   11,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $3F
        .byte   $FF
        .text   "oo",$07,$05,$0D
        .byte   $0F
        .byte   $0F
        .byte   $FF
        .byte   $C0
        .byte   $C0
        .fill   13,$00
        .byte   $7C
        .byte   $FC
        .byte   $DF
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $F4
        .byte   $FC
        .byte   $FC
        .byte   $F0
        .byte   $FC
        .byte   $5F
        .byte   $53
        .byte   $51
        .byte   $71
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $3C
        .fill   55,$00
        .byte   $01
        .fill   5,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .fill   12,$00
        .byte   $57
        .byte   $5F
        .byte   $1D
        .text   $1F,$1F,"???"
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7F
        .byte   $57
        .byte   $D5
        .byte   $D5
        .byte   $F4
        .byte   $FC
        .byte   $C0
        .byte   $00
        .byte   $C0
        .fill   12,$00
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $C0
        .byte   $C0
        .fill   19,$00
        .byte   $4F
        .byte   $57
        .byte   $5F
        .byte   $1D
        .text   $1F,"?=",$0D,"?"
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .text   "Oemo"
        .byte   $0F
        .byte   $03
        .byte   $0F
        .byte   $00
        .byte   $03
        .fill   12,$00
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .byte   $7F
        .byte   $7F
        .byte   $F3
        .byte   $F1
        .byte   $F1
        .byte   $D0
        .byte   $5C
        .byte   $5F
        .byte   $7F
        .byte   $0F
        .byte   $3C
        .byte   $FC
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .fill   43,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $04
        .byte   $04
        .byte   $04
        .fill   16,$00
        .byte   $F0
        .byte   $7D
        .byte   $FF
        .byte   $DF
        .byte   $FC
        .byte   $FF
        .byte   $D7
        .byte   $D7
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .byte   $F5
        .byte   $55
        .byte   $D7
        .byte   $F0
        .byte   $F3
        .byte   $3F
        .byte   $FF
        .byte   $0F
        .byte   $3F
        .fill   17,$00
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $10
        .byte   $10
        .byte   $00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .fill   13,$00
        .byte   $13
        .byte   $15
        .byte   $17
        .text   $07,$07,$07,$07
        .byte   $0F
        .byte   $0F
        .text   "???75"
        .byte   $1D
        .byte   $1F
        .byte   $0F
        .byte   $03
        .byte   $03
        .byte   $03
        .fill   12,$00
        .byte   $C0
        .byte   $F4
        .byte   $7C
        .byte   $FC
        .byte   $FC
        .byte   $D0
        .byte   $50
        .byte   $5C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .text   "Twwp"
        .byte   $C0
        .byte   $C3
        .byte   $FF
        .byte   $FF
        .fill   20,$00
        .byte   $FD
        .byte   $FD
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .fill   20,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $FC
        .byte   $FC
        .byte   $C0
        .fill   48,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .text   $0D,$0D,$07,$07
        .byte   $03
        .fill   15,$00
        .byte   $F0
        .byte   $7D
        .byte   $DF
        .byte   $FF
        .byte   $FF
        .byte   $F4
        .byte   $D4
        .byte   $D7
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F5
        .byte   $55
        .byte   $55
        .byte   $D4
        .byte   $F0
        .byte   $F0
        .byte   $FF
        .byte   $FF
        .fill   20,$00
        .byte   $FF
        .byte   $FF
        .byte   $F0
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $FC
        .byte   $FC
        .fill   20,$00
        .byte   $50
        .byte   $50
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $30
        .fill   48,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   6,$00
        .fill   5,$03
        .byte   $01
        .byte   $01
        .fill   16,$00
        .byte   $3C
        .byte   $5F
        .byte   $77
        .byte   $7F
        .byte   $7F
        .byte   $7D
        .byte   $75
        .byte   $F5
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7D
        .byte   $55
        .byte   $D5
        .byte   $F5
        .byte   $FC
        .byte   $3C
        .byte   $3F
        .byte   $3F
        .fill   13,$00
        .byte   $40
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $C0
        .byte   $40
        .byte   $7F
        .byte   $7F
        .byte   $00
        .byte   $00
        .byte   $30
        .byte   $FF
        .byte   $FF
        .fill   20,$00
        .byte   $D4
        .byte   $D4
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $0C
        .fill   29,$00
        .byte   $C0
        .byte   $C0
        .fill   49,$00
        .text   "ow]",$1F,$1F,$1F
        .byte   $1D
        .byte   $3D
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $DF
        .byte   $D5
        .byte   $75
        .byte   $7D
        .byte   $3F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .fill   13,$00
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $40
        .byte   $40
        .byte   $70
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F0
        .byte   $50
        .byte   $5F
        .byte   $5F
        .byte   $40
        .byte   $00
        .byte   $0C
        .byte   $FF
        .byte   $FF
        .fill   20,$00
        .byte   $F5
        .byte   $F5
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $C0
        .fill   25,$00
        .byte   $F0
        .byte   $F0
        .fill   20,$00
        .byte   $40
        .byte   $57
        .byte   $5F
        .text   "]",$1F,$1F,"????"
        .byte   $FF
        .byte   $FF
        .byte   $D5
        .byte   $D5
        .byte   $F5
        .byte   $5D
        .byte   $7C
        .byte   $7C
        .byte   $0C
        .byte   $0F
        .byte   $0F
        .fill   12,$00
        .byte   $C0
        .byte   $F0
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $F0
        .byte   $C0
        .byte   $FC
        .byte   $FC
        .byte   $5C
        .byte   $5C
        .byte   $75
        .byte   $F4
        .byte   $F4
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .byte   $FC
        .fill   43,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0D
        .byte   $0D
        .byte   $0F
        .byte   $05
        .byte   $07
        .byte   $07
        .fill   15,$00
        .byte   $7C
        .byte   $FF
        .byte   $DD
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F7
        .byte   $FF
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $55
        .byte   $57
        .byte   $DF
        .byte   $CF
        .byte   $CF
        .byte   $CC
        .byte   $FF
        .byte   $FF
        .fill   21,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $50
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $C0
        .fill   15,$00
        .text   "ow]",$1F,$1F,$1F
        .byte   $1D
        .byte   $3D
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $DF
        .byte   $DF
        .byte   $F5
        .byte   $15
        .byte   $1F
        .fill   16,$00
        .byte   $D0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $40
        .byte   $40
        .byte   $70
        .byte   $F0
        .byte   $FF
        .byte   $FF
        .byte   $F7
        .byte   $F7
        .byte   $5F
        .byte   $5F
        .byte   $7F
        .byte   $F5
        .fill   28,$00
        .byte   $0C
        .byte   $0C
        .byte   $FC
        .byte   $FF
        .fill   47,$00
        .byte   $04
        .byte   $05
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0D
        .byte   $0D
        .byte   $0F
        .byte   $01
        .byte   $01
        .fill   15,$00
        .byte   $F0
        .byte   $7D
        .byte   $DF
        .byte   $FF
        .byte   $FF
        .byte   $F4
        .byte   $D4
        .byte   $D7
        .fill   5,$FF
        .byte   $F5
        .byte   $55
        .byte   $57
        .byte   $FF
        .fill   24,$00
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $FF
        .byte   $5F
        .fill   28,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .fill   11,$00
        .byte   $13
        .byte   $15
        .byte   $17
        .text   $07,$07,$07,$07
        .byte   $0F
        .byte   $0F
        .text   "???77"
        .byte   $1D
        .byte   $1D
        .byte   $0F
        .byte   $03
        .byte   $3F
        .byte   $F3
        .byte   $F3
        .fill   11,$00
        .byte   $C0
        .byte   $F4
        .byte   $7C
        .byte   $FC
        .byte   $FC
        .byte   $D0
        .byte   $50
        .byte   $5C
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $FC
        .byte   $54
        .byte   $54
        .byte   $50
        .byte   $00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .fill   19,$00
        .byte   $F5
        .byte   $F5
        .byte   $C1
        .fill   53,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .fill   6,$00
        .fill   5,$03
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .fill   11,$00
        .byte   $3C
        .byte   $5F
        .byte   $77
        .byte   $7F
        .byte   $7F
        .byte   $7D
        .byte   $75
        .byte   $F5
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7F
        .byte   $75
        .byte   $D5
        .byte   $D5
        .byte   $F0
        .byte   $3C
        .byte   $FC
        .byte   $3C
        .byte   $3F
        .fill   12,$00
        .byte   $40
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $FF
        .byte   $FF
        .byte   $FC
        .byte   $C0
        .byte   $C0
        .byte   $40
        .byte   $40
        .fill   25,$00
        .byte   $50
        .byte   $50
        .byte   $10
        .fill   21,$00
        .byte   $03
        .byte   $07
        .byte   $0F
        .byte   $0F
        .text   "oaqmOC"
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $0F
        .byte   $05
        .byte   $0D
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $0C
        .byte   $3C
        .fill   11,$00
        .byte   $D1
        .byte   $F5
        .byte   $75
        .byte   $F5
        .byte   $F4
        .byte   $74
        .byte   $7C
        .byte   $70
        .byte   $FC
        .byte   $FF
        .byte   $DF
        .byte   $5F
        .byte   $5C
        .byte   $FC
        .byte   $54
        .byte   $5C
        .byte   $7C
        .byte   $3C
        .byte   $0C
        .byte   $0C
        .byte   $3C
        .fill   47,$00
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $04
        .byte   $0C
        .byte   $0C
        .byte   $0F
        .byte   $0F
        .byte   $03
        .fill   7,$00
        .byte   $03
        .fill   11,$00
        .byte   $3D
        .byte   $7F
        .byte   $F7
        .byte   $FF
        .byte   $FF
        .byte   $17
        .byte   $17
        .byte   $D7
        .byte   $FF
        .byte   $3F
        .byte   $FD
        .byte   $F5
        .byte   $F5
        .byte   $FF
        .byte   $55
        .byte   $D5
        .byte   $F7
        .byte   $F3
        .byte   $C0
        .byte   $C0
        .byte   $C3
        .fill   11,$00
        .byte   $10
        .text   "ppp@@"
        .byte   $C0
        .byte   $00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .byte   $40
        .fill   6,$C0
        .fill   11,$00
        .byte   $03
        .byte   $0F
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $05
        .byte   $0F
        .byte   $43
        .byte   $7F
        .byte   $7F
        .byte   $7F
        .byte   $0F
        .byte   $0F
        .byte   $05
        .byte   $0D
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $0C
        .byte   $3C
        .fill   11,$00
        .byte   $D5
        .byte   $F5
        .byte   $74
        .byte   $F4
        .byte   $F4
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $DF
        .byte   $5F
        .byte   $5F
        .byte   $5C
        .byte   $FC
        .byte   $FC
        .byte   $54
        .byte   $5C
        .byte   $7C
        .byte   $3C
        .byte   $0C
        .byte   $0C
        .byte   $3C
        .fill   51,$00
        .byte   $04
        .byte   $07
        .byte   $07
        .byte   $07
        .fill   8,$00
        .byte   $03
        .fill   11,$00
        .byte   $3D
        .byte   $FF
        .byte   $77
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $5F
        .byte   $FF
        .byte   $3D
        .byte   $F5
        .byte   $F5
        .byte   $F5
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $D5
        .byte   $F7
        .byte   $F3
        .byte   $C0
        .byte   $C0
        .byte   $C3
        .fill   11,$00
        .text   "pp@@@"
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $40
        .fill   6,$C0
        .fill   12,$00
        .byte   $3D
        .byte   $3F
        .byte   $F7
        .byte   $FF
        .byte   $FF
        .text   "?",$1F,"??"
        .byte   $0F
        .byte   $3F
        .byte   $F5
        .byte   $C5
        .byte   $45
        .byte   $4D
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $3C
        .fill   11,$00
        .byte   $10
        .text   "pp@@@"
        .byte   $C0
        .byte   $C0
        .byte   $FC
        .byte   $FF
        .byte   $F1
        .byte   $F1
        .byte   $D0
        .byte   $50
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $FF
        .byte   $03
        .byte   $03
        .fill   45,$00
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .fill   22,$00
        .byte   $D5
        .byte   $F5
        .byte   $74
        .byte   $F4
        .byte   $F4
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .text   "Uww",$1F,"?"
        .byte   $03
        .byte   $00
        .byte   $03
        .fill   23,$00
        .byte   $40
        .fill   5,$00
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .fill   10,$00
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $0F
        .byte   $FD
        .byte   $FD
        .text   "Ooo",$07,"5"
        .byte   $F5
        .byte   $FD
        .byte   $F0
        .byte   $3C
        .byte   $3F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .fill   11,$00
        .byte   $F1
        .byte   $D5
        .byte   $F5
        .byte   $74
        .byte   $F4
        .byte   $FC
        .byte   $7C
        .byte   $70
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F3
        .byte   $51
        .byte   $71
        .byte   $F1
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .byte   $00
        .byte   $C0
        .fill   49,$00
        .byte   $0F
        .byte   $0F
        .byte   $0C
        .byte   $04
        .byte   $04
        .byte   $00
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $03
        .fill   14,$00
        .byte   $0F
        .byte   $7D
        .byte   $FF
        .byte   $F7
        .byte   $3F
        .byte   $FF
        .byte   $D7
        .byte   $D7
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7F
        .byte   $5F
        .byte   $55
        .byte   $D7
        .byte   $0F
        .byte   $CF
        .byte   $FC
        .byte   $FF
        .byte   $F0
        .byte   $FC
        .fill   11,$00
        .byte   $10
        .text   "pp@@"
        .byte   $C0
        .byte   $C0
        .byte   $00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $30
        .byte   $10
        .byte   $10
        .byte   $10
        .fill   23,$00
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $3F
        .byte   $3F
        .byte   $03
        .fill   24,$00
        .byte   $7F
        .byte   $7F
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $0F
        .fill   12,$00
        .byte   $03
        .text   $1F,"=??",$07,$05,"5"
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $17
        .byte   $D5
        .byte   $D5
        .byte   $05
        .byte   $03
        .byte   $C3
        .byte   $FF
        .byte   $FF
        .fill   12,$00
        .text   "DtTPPPP"
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $DC
        .byte   $5C
        .byte   $74
        .byte   $F4
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .fill   57,$00
        .byte   $0F
        .byte   $0F
        .fill   25,$00
        .byte   $5F
        .byte   $5F
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $C0
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $03
        .fill   13,$00
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $01
        .byte   $01
        .byte   $0D
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $0F
        .byte   $05
        .byte   $F5
        .byte   $F5
        .byte   $01
        .byte   $00
        .byte   $30
        .byte   $FF
        .byte   $FF
        .fill   12,$00
        .byte   $F1
        .byte   $D5
        .byte   $75
        .byte   $F4
        .byte   $F4
        .byte   $F4
        .byte   $74
        .byte   $7C
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F7
        .byte   $57
        .byte   $5D
        .byte   $7D
        .byte   $FC
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .fill   57,$00
        .byte   $03
        .byte   $03
        .fill   25,$00
        .byte   $17
        .byte   $17
        .byte   $10
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $30
        .fill   17,$00
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $03
        .byte   $01
        .byte   $FD
        .byte   $FD
        .byte   $00
        .byte   $00
        .byte   $0C
        .byte   $FF
        .byte   $FF
        .fill   12,$00
        .byte   $3C
        .byte   $F5
        .byte   $DD
        .byte   $FD
        .byte   $FD
        .byte   $7D
        .byte   $5D
        .byte   $5F
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $7D
        .byte   $55
        .byte   $57
        .byte   $5F
        .byte   $3F
        .byte   $3C
        .byte   $FC
        .byte   $FC
        .fill   12,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   6,$00
        .fill   5,$C0
        .byte   $40
        .byte   $40
        .fill   56,$00
        .byte   $05
        .byte   $05
        .byte   $04
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $0C
        .fill   24,$00
        .byte   $FF
        .byte   $FF
        .byte   $0F
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $3F
        .byte   $3F
        .fill   12,$00
        .byte   $0F
        .byte   $7D
        .byte   $F7
        .byte   $FF
        .byte   $FF
        .byte   $1F
        .byte   $17
        .byte   $D7
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $5F
        .byte   $55
        .byte   $55
        .byte   $17
        .byte   $0F
        .byte   $0F
        .byte   $FF
        .byte   $FF
        .fill   12,$00
        .byte   $10
        .text   "pp@@@@"
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $70
        .byte   $D0
        .byte   $D0
        .byte   $C0
        .fill   19,$00
        .byte   $03
        .byte   $0F
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0D
        .byte   $0F
        .byte   $03
        .text   "??55]",$1F,$1F
        .byte   $0F
        .byte   $03
        .byte   $0F
        .byte   $3F
        .fill   11,$00
        .byte   $01
        .byte   $D5
        .byte   $F5
        .byte   $75
        .byte   $F4
        .byte   $F4
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $57
        .byte   $57
        .byte   $5F
        .byte   $75
        .byte   $3D
        .byte   $3D
        .byte   $30
        .byte   $F0
        .byte   $F0
        .fill   53,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $05
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $03
        .fill   12,$00
        .byte   $3D
        .byte   $FF
        .byte   $77
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $DF
        .byte   $FF
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $55
        .byte   $D5
        .byte   $F7
        .byte   $F3
        .byte   $F3
        .byte   $33
        .byte   $FF
        .byte   $FF
        .fill   11,$00
        .byte   $10
        .text   "ppp@@"
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $70
        .byte   $F0
        .byte   $50
        .byte   $D0
        .byte   $D0
        .fill   31,$00
        .byte   $30
        .byte   $30
        .byte   $3F
        .byte   $FF
        .fill   16,$00
        .byte   $07
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $01
        .byte   $01
        .byte   $0D
        .byte   $0F
        .byte   $FF
        .byte   $FF
        .byte   $DF
        .byte   $DF
        .byte   $F5
        .byte   $F5
        .byte   $FD
        .byte   $5F
        .fill   15,$00
        .byte   $F1
        .byte   $D5
        .byte   $75
        .byte   $F4
        .byte   $F4
        .byte   $F4
        .byte   $74
        .byte   $7C
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $F7
        .byte   $F7
        .byte   $5F
        .byte   $54
        .byte   $F4
        .fill   60,$00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $0F
        .fill   24,$00
        .byte   $0F
        .byte   $0F
        .byte   $0D
        .byte   $0D
        .byte   $0F
        .byte   $0F
        .byte   $FF
        .byte   $F5
        .fill   15,$00
        .byte   $0F
        .byte   $7D
        .byte   $F7
        .byte   $FF
        .byte   $FF
        .byte   $1F
        .byte   $17
        .byte   $D7
        .fill   5,$FF
        .byte   $5F
        .byte   $55
        .byte   $D5
        .byte   $FF
        .fill   15,$00
        .byte   $10
        .text   "pp@@@@"
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $70
        .byte   $70
        .byte   $F0
        .byte   $40
        .byte   $40
        .fill   19,$00
        .byte   $5F
        .byte   $5F
        .byte   $43
        .fill   21,$00
        .byte   $03
        .text   $1F,"=??",$07,$05,"5"
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $3F
        .byte   $15
        .byte   $15
        .byte   $05
        .byte   $00
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $0F
        .fill   11,$00
        .text   "DtTPPPP"
        .byte   $F0
        .byte   $F0
        .byte   $FC
        .byte   $FC
        .byte   $FC
        .byte   $DC
        .byte   $DC
        .byte   $74
        .byte   $74
        .byte   $F0
        .byte   $C0
        .byte   $FC
        .byte   $CF
        .byte   $CF
        .fill   51,$00
        .byte   $05
        .byte   $05
        .byte   $04
        .fill   22,$00
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $03
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $FF
        .byte   $FF
        .byte   $3F
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .fill   17,$00
        .byte   $3C
        .byte   $F5
        .byte   $DD
        .byte   $FD
        .byte   $FD
        .byte   $7D
        .byte   $5D
        .byte   $5F
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .byte   $5D
        .byte   $57
        .byte   $57
        .byte   $0F
        .byte   $3C
        .byte   $3F
        .byte   $3C
        .byte   $FC
        .fill   11,$00
        .byte   $40
        .byte   $40
        .byte   $40
        .fill   6,$00
        .fill   5,$C0
        .byte   $40
        .byte   $40
        .byte   $00
        .byte   $00
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .fill   12,$00
        .byte   $03
        .text   "co]mMOO"
        .byte   $F3
        .byte   $FF
        .text   "?",$05,$05,$0D
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $03
        .byte   $0F
        .fill   11,$00
        .byte   $50
        .byte   $50
        .byte   $5C
        .byte   $5C
        .byte   $54
        .byte   $54
        .byte   $54
        .byte   $5C
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .byte   $55
        .byte   $55
        .byte   $5C
        .byte   $7C
        .byte   $3F
        .byte   $0F
        .byte   $3C
        .byte   $0F
        .fill   46,$00
        .byte   $04
        .byte   $04
        .byte   $05
        .byte   $04
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $0F
        .byte   $0F
        .byte   $03
        .fill   20,$00
        .byte   $05
        .byte   $35
        .byte   $35
        .byte   $F5
        .byte   $D5
        .byte   $D5
        .byte   $D5
        .byte   $F5
        .byte   $FF
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $55
        .byte   $D5
        .byte   $F7
        .byte   $F3
        .byte   $F0
        .byte   $33
        .byte   $30
        .byte   $F0
        .fill   13,$00
        .byte   $C0
        .byte   $C0
        .byte   $40
        .byte   $40
        .byte   $40
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $D0
        .byte   $50
        .byte   $50
        .byte   $C0
        .byte   $C0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $F0
        .fill   13,$00
        .text   $05,$05,"55"
        .byte   $15
        .byte   $15
        .byte   $15
        .byte   $35
        .byte   $3F
        .byte   $FF
        .byte   $FF
        .byte   $7F
        .text   "uu5="
        .byte   $FC
        .byte   $F0
        .byte   $3C
        .byte   $F0
        .fill   13,$00
        .byte   $C0
        .byte   $F1
        .byte   $F1
        .byte   $75
        .byte   $71
        .byte   $73
        .byte   $F3
        .byte   $F3
        .byte   $CF
        .byte   $FF
        .byte   $FC
        .byte   $50
        .byte   $50
        .byte   $70
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .byte   $C0
        .fill   46,$00
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $01
        .byte   $01
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $07
        .byte   $05
        .byte   $05
        .byte   $03
        .byte   $03
        .byte   $0F
        .byte   $0F
        .byte   $03
        .byte   $0F
        .fill   12,$00
        .byte   $50
        .byte   $5C
        .byte   $5F
        .byte   $5F
        .byte   $57
        .byte   $57
        .byte   $57
        .byte   $5F
        .byte   $FF
        .byte   $FC
        .byte   $FF
        .byte   $FF
        .byte   $55
        .byte   $55
        .byte   $57
        .byte   $DF
        .byte   $CF
        .byte   $0F
        .byte   $CC
        .byte   $0C
        .fill   14,$00
        .byte   $10
        .byte   $10
        .byte   $50
        .byte   $10
        .byte   $30
        .byte   $30
        .byte   $30
        .byte   $F0
        .byte   $F0
        .byte   $C0
        .fill   208,$00
L60D9   .byte   $02
L60DA   .byte   $00
L60DB   .byte   $00
L60DC   .byte   $00
L60DD   .byte   $00
L60DE   .byte   $00
L60DF   .byte   $00
L60E0   .byte   $00
L60E1   .byte   $00
L60E2   .byte   $00
L60E3   .byte   $00
L60E4   .byte   $00
L60E5   .byte   $00
L60E6   .byte   $00

L60E7   lda     L60DD      ;4
        beq     _L610F     ;3+
        cmp     #$01       ;2
        bne     _L610B     ;3+
        lda     L60D9      ;4
        cmp     #$00       ;2
        bne     _L60FD     ;2+
        lda     #$01       ;2
        sta     L60E6      ;4
        rts                ;6

_L60FD  jsr     _L61E3     ;6
        lda     #$00       ;2
        sta     L60DE      ;4
        sta     L60DF      ;4
        jmp     L67CD      ;3

_L610B  dec     L60DD      ;6
        rts                ;6

_L610F  lda     L60DF      ;4
        cmp     #$FF       ;2
        beq     _L6124     ;2+
        lda     L60DE      ;4
        clc                ;2
        adc     #$01       ;2
        bcc     _L6121     ;2+
        inc     L60DF      ;6
_L6121  sta     L60DE      ;4
_L6124  lda     L6923      ;4
        bne     _L6130     ;2+
        jsr     L6A63      ;6
        cmp     #$FF       ;2
        bne     _L6133     ;2+
_L6130  jsr     L6924      ;6
_L6133  jsr     _L647C     ;6
        lda     $E4        ;3
        tax                ;2
        and     #$10       ;2
        beq     _L6140     ;2+
        jmp     L66AA      ;3

_L6140  txa                ;2
        and     #$08       ;2
        beq     _L6148     ;2+
        jmp     _L6401     ;3

_L6148  txa                ;2
        and     #$02       ;2
        beq     _L6166     ;2+
        jsr     _L63C0     ;6
        lda     LAD85      ;4
        cmp     #$BF       ;2
        bcc     _L615D     ;2+
        jsr     L6DD8      ;6
        lda     $E4        ;3
        tax                ;2
_L615D  cmp     #$27       ;2
        bcs     _L6166     ;2+
        jsr     L6DE3      ;6
        ldx     $E4        ;3
_L6166  txa                ;2
        and     #$04       ;2
        beq     _L616E     ;2+
        jmp     _L6181     ;3

_L616E  lda     $E5        ;3
        tax                ;2
        and     #$04       ;2
        beq     _L6178     ;2+
        jmp     _L6181     ;3

_L6178  txa                ;2
        and     #$01       ;2
        beq     _L6180     ;2+
        jmp     _L619D     ;3

_L6180  rts                ;6

_L6181  lda     L60E3      ;4
        cmp     #$12       ;2
        bne     _L619A     ;2+
        lda     LAD85      ;4
        cmp     #$60       ;2
        bcc     _L619A     ;2+
        lda     LAD86      ;4
        cmp     #$13       ;2
        beq     _L61A6     ;2+
        cmp     #$12       ;2
        beq     _L61A6     ;2+
_L619A  jmp     _L63E5     ;3

_L619D  lda     L60E5      ;4
        ora     #$20       ;2
        sta     L60E5      ;4
        rts                ;6

_L61A6  rts                ;6

_L61A7  sta     $D0        ;3
        ldx     #$00       ;2
_L61AB  lda     #$00       ;2
        sta     $0C00,x    ;5
        sta     LE400,x    ;5
        sta     $0D00,x    ;5
        sta     LE500,x    ;5
        sta     $0E00,x    ;5
        sta     LE600,x    ;5
        sta     $0F00,x    ;5
        sta     LE700,x    ;5
        lda     $D0        ;3
        sta     $0800,x    ;5
        sta     LDFFF+1,x  ;5
        sta     $0900,x    ;5
        sta     LE100,x    ;5
        sta     $0A00,x    ;5
        sta     LE200,x    ;5
        sta     $0B00,x    ;5
        sta     LE300,x    ;5
        inx                ;2
        bne     _L61AB     ;2+
        rts                ;6

_L61E3  lda     #$00       ;2
        jsr     $0200      ;6
        sei                ;2
        jsr     LDEE1      ;6
        lda     #$00       ;2
        sta     $FF11      ;4
        lda     $FF13      ;4
        sta     $04        ;3
        lda     #$0B       ;2
        jsr     LDD20      ;6
        lda     #$D8       ;2
        sta     $FF13      ;4
        lda     #$AE       ;2
        sta     $FF15      ;4
        sta     $FF19      ;4
        lda     #$61       ;2
        jsr     _L61A7     ;6
        lda     LD769      ;4
        sta     $DF        ;3
        lda     LDDEA      ;4
        bne     _L621F     ;2+
        lda     #$00       ;2
        sta     LD769      ;4
        jmp     _L622A     ;3

_L621F  lda     LD769      ;4
        clc                ;2
        adc     #$01       ;2
        and     #$01       ;2
        sta     LD769      ;4
_L622A  lda     LD761      ;4
        cmp     #$01       ;2
        bne     _L623B     ;2+
        lda     LD762      ;4
        cmp     #$01       ;2
        bne     _L623B     ;2+
        jmp     _L627F     ;3

_L623B  lda     LD769      ;4
        bne     _L6252     ;2+
        lda     LD762      ;4
        cmp     #$01       ;2
        bne     _L624F     ;2+
        dec     LD761      ;6
        lda     #$0B       ;2
        sta     LD762      ;4
_L624F  dec     LD762      ;6
_L6252  lda     #$1B       ;2
        jsr     LDD20      ;6
        lda     LD769      ;4
        jsr     _L633B     ;6
        lda     #$0C       ;2
        jsr     _L637A     ;6
        jsr     _L61A7     ;6
        lda     #$1B       ;2
        jsr     LDD20      ;6
        lda     #$00       ;2
        sta     $FF19      ;4
        lda     $04        ;3
        sta     $FF13      ;4
        jsr     _L6391     ;6
        lda     LD769      ;4
        jsr     $F9FF      ;6
        cli                ;2
        rts                ;6

_L627F  lda     #$1B       ;2
        jsr     LDD20      ;6
        lda     $DF        ;3
        jsr     _L633B     ;6
        lda     $DF        ;3
        jsr     _L62CC     ;6
        lda     LDDEA      ;4
        bne     _L629B     ;2+
        lda     #$01       ;2
        sta     L60E6      ;4
        jmp     _L62A4     ;3

_L629B  lda     $DF        ;3
        beq     _L62A4     ;2+
        lda     #$01       ;2
        sta     L60E6      ;4
_L62A4  lda     #$12       ;2
        jsr     _L637A     ;6
        lda     L60E6      ;4
        bne     _L62C5     ;2+
        jsr     _L61A7     ;6
        lda     #$1B       ;2
        jsr     LDD20      ;6
        lda     #$00       ;2
        sta     $FF19      ;4
        lda     $04        ;3
        sta     $FF13      ;4
        jsr     _L6391     ;6
        cli                ;2
        rts                ;6

_L62C5  lda     #$0B       ;2
        jsr     LDD20      ;6
        cli                ;2
        rts                ;6

_L62CC  tay                ;2
        ldx     #$00       ;2
_L62CF  lda     _L6329,x   ;4+
        sta     $0C5C,x    ;5
        sta     LE45C,x    ;5
        beq     _L62DD     ;2+
        clc                ;2
        adc     #$02       ;2
_L62DD  sta     $0C84,x    ;5
        sta     LE484,x    ;5
        inx                ;2
        cpx     #$12       ;2
        bne     _L62CF     ;2+
        cpy     #$01       ;2
        beq     _L62F1     ;2+
        ldy     #$00       ;2
        jmp     _L62F3     ;3

_L62F1  ldy     #$06       ;2
_L62F3  ldx     #$00       ;2
_L62F5  lda     $FA3D,y    ;4+
        sec                ;2
        sbc     #$01       ;2
        asl     a          ;2
        asl     a          ;2
        clc                ;2
        adc     #$7C       ;2
        sta     $0D27,x    ;5
        sta     LE527,x    ;5
        clc                ;2
        adc     #$01       ;2
        sta     $0D28,x    ;5
        sta     LE528,x    ;5
        clc                ;2
        adc     #$01       ;2
        sta     $0D4F,x    ;5
        sta     LE54F,x    ;5
        clc                ;2
        adc     #$01       ;2
        sta     $0D50,x    ;5
        sta     LE550,x    ;5
        inx                ;2
        inx                ;2
        iny                ;2
        cpx     #$0C       ;2
        bne     _L62F5     ;3+
        rts                ;6

_L6329  .byte   $60
        .byte   $61
        .byte   $64
        .byte   $65
        .byte   $68
        .byte   $69
        .byte   $4C
        .byte   $4D
        .byte   $00
        .byte   $00
        .byte   $6C
        .byte   $6D
        .byte   $70
        .byte   $71
        .text   "lm@a"

_L633B  sta     $D0        ;3
        ldx     #$00       ;2
_L633F  lda     _L63B4,x   ;4+
        sta     $0CAD,x    ;5
        sta     LE4AD,x    ;5
        clc                ;2
        adc     #$02       ;2
        sta     $0CD5,x    ;5
        sta     LE4D5,x    ;5
        inx                ;2
        cpx     #$0C       ;2
        bne     _L633F     ;2+
        lda     $D0        ;3
        asl     a          ;2
        asl     a          ;2
        clc                ;2
        adc     #$80       ;2
        tax                ;2
        stx     $0CBB      ;4
        stx     LE4BB      ;4
        inx                ;2
        stx     $0CBC      ;4
        stx     LE4BC      ;4
        inx                ;2
        stx     $0CE3      ;4
        stx     LE4E3      ;4
        inx                ;2
        stx     $0CE4      ;4
        stx     LE4E4      ;4
        rts                ;6

_L637A  sta     _L638C+1   ;4
        lda     #$00       ;2
_L637F  ldx     #$00       ;2
_L6381  ldy     #$00       ;2
_L6383  iny                ;2
        bne     _L6383     ;2+
        inx                ;2
        bne     _L6381     ;2+
        clc                ;2
        adc     #$01       ;2
_L638C  cmp     #$0C       ;2
        bcc     _L637F     ;2+
        rts                ;6

_L6391  lda     L7248      ;4
        cmp     #$00       ;2
        bne     _L6399     ;2+
        rts                ;6

_L6399  lda     LD769      ;4
        bne     _L63A9     ;2+
        lda     #$02       ;2
        sta     L60D9      ;4
        lda     #$01       ;2
        sta     L7248      ;4
        rts                ;6

_L63A9  lda     #$01       ;2
        sta     L60D9      ;4
        lda     #$02       ;2
        sta     L7248      ;4
        rts                ;6

_L63B4  .byte   $74
        .byte   $75
        .byte   $50
        .byte   $51
        .byte   $64
        .byte   $65
        .byte   $78
        .byte   $79
        .text   "lm@a"

_L63C0  lda     LAD86      ;4
        cmp     #$14       ;2
        beq     _L63CC     ;2+
        cmp     #$15       ;2
        beq     _L63CC     ;2+
        rts                ;6

_L63CC  lda     LC7B5      ;4
        cmp     #$01       ;2
        beq     _L63D8     ;2+
        cmp     #$02       ;2
        beq     _L63DE     ;2+
        rts                ;6

_L63D8  jsr     L6DD8      ;6
        jmp     L6DD8      ;3

_L63DE  jsr     L6DE3      ;6
        jmp     L6DE3      ;3

        .byte   $60

_L63E5  lda     #$FF       ;2
        sta     L60DC      ;4
        lda     #$20       ;2
        sta     L60DD      ;4
        ldx     #$09       ;2
        lda     L70EA      ;4
        beq     _L63F8     ;2+
        ldx     #$08       ;2
_L63F8  stx     LAD86      ;4
        lda     #$05       ;2
        jsr     $0200      ;6
        rts                ;6

_L6401  lda     LBC1E      ;4
        sta     $1C        ;3
        lda     LBC1F      ;4
        sta     $1D        ;3
        lda     LAD84      ;4
        lsr     a          ;2
        lsr     a          ;2
        sec                ;2
        sbc     #$05       ;2
        sta     $D6        ;3
        lda     LAD85      ;4
        lsr     a          ;2
        lsr     a          ;2
        lsr     a          ;2
        sec                ;2
        sbc     #$03       ;2
        sta     $D7        ;3
        ldy     #$00       ;2
_L6422  sty     $D8        ;3
        lda     ($1C),y    ;5+
        cmp     #$FF       ;2
        beq     _L647B     ;2+
        tax                ;2
        lda     LBD5E,x    ;4+
        beq     _L6474     ;2+
        iny                ;2
        lda     ($1C),y    ;5+
        and     #$7F       ;2
        sta     $D4        ;3
        iny                ;2
        lda     ($1C),y    ;5+
        sta     $D5        ;3
        lda     $D6        ;3
        cmp     $D4        ;3
        bcs     _L6474     ;2+
        clc                ;2
        adc     #$03       ;2
        cmp     $D4        ;3
        bcc     _L6474     ;2+
        lda     $D7        ;3
        cmp     $D5        ;3
        bcs     _L6474     ;2+
        clc                ;2
        adc     #$03       ;2
        cmp     $D5        ;3
        bcc     _L6474     ;2+
        lda     LBD5E,x    ;4+
        cmp     #$01       ;2
        bne     _L646F     ;2+
        stx     $59        ;3
        sty     $5A        ;3
        lda     #$03       ;2
        jsr     $0200      ;6
        lda     #$03       ;2
        jsr     LD6F3      ;6
        ldx     $59        ;3
        ldy     $5A        ;3
_L646F  lda     #$FC       ;2
        sta     LBD5E,x    ;5
_L6474  ldy     $D8        ;3
        iny                ;2
        iny                ;2
        iny                ;2
        bne     _L6422     ;2+
_L647B  rts                ;6

_L647C  lda     L60DC      ;4
        beq     _L6499     ;2+
        cmp     #$14       ;2
        bcs     _L6495     ;2+
        lda     L60DB      ;4
        bne     _L6495     ;2+
        lda     #$FF       ;2
        sta     L60DC      ;4
        lda     #$01       ;2
        sta     L60DD      ;4
        rts                ;6

_L6495  dec     L60DC      ;6
        rts                ;6

_L6499  lda     L6923      ;4
        sta     $07        ;3
        lda     L7DEF      ;4
        clc                ;2
        adc     L7F85      ;4
        beq     _L64BA     ;2+
        ldx     #$00       ;2
        ldy     #$02       ;2
        lda     L7F85      ;4
        sta     $06        ;3
        lda     L86E2      ;4
        jsr     L658E      ;6
        and     #$7F       ;2
        bne     _L64D7     ;2+
_L64BA  lda     L7249      ;4
        clc                ;2
        adc     L73EC      ;4
        beq     _L64D6     ;2+
        ldx     #$00       ;2
        ldy     #$01       ;2
        lda     L73EC      ;4
        sta     $06        ;3
        lda     L7BC9      ;4
        jsr     L658E      ;6
        and     #$7F       ;2
        bne     _L64E5     ;2+
_L64D6  rts                ;6

_L64D7  tax                ;2
        lda     L7F85      ;4
        and     L6923      ;4
        beq     _L64E1     ;2+
        rts                ;6

_L64E1  txa                ;2
        jmp     _L64FE     ;3

_L64E5  tax                ;2
        lda     L6923      ;4
        and     L73EC      ;4
        beq     _L64EF     ;2+
        rts                ;6

_L64EF  txa                ;2
        sta     $AA        ;3
        lda     #$85       ;2
        jsr     $0200      ;6
        lda     $AA        ;3
        ldx     #$FF       ;2
        stx     L76A4      ;4
_L64FE  ldx     L1484      ;4
        stx     $FA49      ;4
        dec     L60DB      ;6
        ldx     #$28       ;2
        stx     L60DC      ;4
        cmp     #$01       ;2
        beq     _L6526     ;2+
        cmp     #$02       ;2
        beq     _L652B     ;2+
        cmp     #$05       ;2
        beq     _L6530     ;2+
        ldx     #$05       ;2
        stx     L60DC      ;4
        cmp     #$03       ;2
        beq     _L6544     ;2+
        cmp     #$04       ;2
        beq     _L654E     ;2+
        rts                ;6

_L6526  lda     #$0B       ;2
        jmp     L6C2C      ;3

_L652B  lda     #$0C       ;2
        jmp     L6C2C      ;3

_L6530  lda     #$85       ;2
        jsr     $0200      ;6
        lda     L70EA      ;4
        bne     _L653F     ;2+
        lda     #$0F       ;2
        jmp     L6C2C      ;3

_L653F  lda     #$10       ;2
        jmp     L6C2C      ;3

_L6544  lda     #$01       ;2
        jsr     $0200      ;6
        lda     #$0D       ;2
        jmp     L6C2C      ;3

_L654E  lda     #$01       ;2
        jsr     $0200      ;6
        lda     #$0E       ;2
        jmp     L6C2C      ;3

L6558   sta     $58        ;3
        lda     #$85       ;2
        jsr     $0200      ;6
        lda     $58        ;3
        cmp     #$05       ;2
        beq     _L656E     ;2+
        cmp     #$01       ;2
        beq     _L6576     ;2+
        cmp     #$02       ;2
        beq     _L6576     ;2+
        rts                ;6

_L656E  lda     #$00       ;2
        jsr     LD6F3      ;6
        lda     $58        ;3
        rts                ;6

_L6576  lda     $0F        ;3
        and     #$80       ;2
        bne     _L6584     ;2+
        lda     #$01       ;2
        jsr     LD6F3      ;6
        lda     $58        ;3
        rts                ;6

_L6584  lda     #$02       ;2
        jsr     LD6F3      ;6
        lda     $58        ;3
        rts                ;6

L658C   .byte   $00
        .byte   $0C

L658E   sta     $D4        ;3
        lda     $07        ;3
        bne     _L659B     ;2+
        lda     $06        ;3
        beq     _L659B     ;2+
        jmp     _L664A     ;3

_L659B  lda     $D4        ;3
        txa                ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        tax                ;2
        lda     LAD84,x    ;4+
        clc                ;2
        adc     #$02       ;2
        sta     $D0        ;3
        clc                ;2
        adc     #$04       ;2
        sta     $D2        ;3
        lda     LAD85,x    ;4+
        clc                ;2
        adc     #$03       ;2
        sta     $D1        ;3
        clc                ;2
        adc     #$0B       ;2
        sta     $D3        ;3
        lda     $D4        ;3
        and     #$01       ;2
        tax                ;2
        lda     L658C,x    ;4+
        sta     _L65D4+1   ;4
        tya                ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        tax                ;2
        lda     LAD84,x    ;4+
        clc                ;2
_L65D4  adc     #$02       ;2
        sta     $D8        ;3
        clc                ;2
        adc     #$02       ;2
        sta     $DA        ;3
        lda     LAD85,x    ;4+
        clc                ;2
        adc     #$04       ;2
        sta     $D9        ;3
        clc                ;2
        adc     #$0A       ;2
        sta     $DB        ;3
        lda     LAD86,x    ;4+
        sta     $D5        ;3
        lda     $DA        ;3
        cmp     $D0        ;3
        bcc     _L6647     ;3+
        lda     $DB        ;3
        cmp     $D1        ;3
        bcc     _L6647     ;3+
        lda     $D2        ;3
        cmp     $D8        ;3
        bcc     _L6647     ;3+
        lda     $D3        ;3
        cmp     $D9        ;3
        bcc     _L6647     ;2+
        lda     $D5        ;3
        cmp     #$0D       ;2
        beq     _L663D     ;2+
        cmp     #$0C       ;2
        beq     _L663D     ;2+
        cmp     #$0F       ;2
        beq     _L6633     ;2+
        cmp     #$11       ;2
        beq     _L6633     ;2+
        cmp     #$2D       ;2
        beq     _L6633     ;2+
        cmp     #$2E       ;2
        beq     _L6633     ;2+
        cmp     #$27       ;2
        beq     _L6633     ;2+
        cmp     #$28       ;2
        beq     _L6633     ;2+
        lda     $D4        ;3
        beq     _L6630     ;2+
        lda     #$03       ;2
        rts                ;6

_L6630  lda     #$04       ;2
        rts                ;6

_L6633  lda     $D4        ;3
        beq     _L663A     ;2+
        lda     #$01       ;2
        rts                ;6

_L663A  lda     #$02       ;2
        rts                ;6

_L663D  lda     $D4        ;3
        beq     _L6644     ;2+
        lda     #$81       ;2
        rts                ;6

_L6644  lda     #$82       ;2
        rts                ;6

_L6647  lda     #$00       ;2
        rts                ;6

_L664A  txa                ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        tax                ;2
        lda     LAD84,x    ;4+
        clc                ;2
        adc     #$03       ;2
        sta     $D0        ;3
        clc                ;2
        adc     #$04       ;2
        sta     $D2        ;3
        lda     LAD85,x    ;4+
        clc                ;2
        adc     #$04       ;2
        sta     $D1        ;3
        clc                ;2
        adc     #$08       ;2
        sta     $D3        ;3
        tya                ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        asl     a          ;2
        tax                ;2
        lda     LAD84,x    ;4+
        clc                ;2
        adc     #$02       ;2
        sta     $D8        ;3
        clc                ;2
        adc     #$06       ;2
        sta     $DA        ;3
        lda     LAD85,x    ;4+
        clc                ;2
        adc     #$16       ;2
        sta     $D9        ;3
        clc                ;2
        adc     #$02       ;2
        sta     $DB        ;3
        lda     $DA        ;3
        cmp     $D0        ;3
        bcc     _L66A7     ;2+
        lda     $DB        ;3
        cmp     $D1        ;3
        bcc     _L66A7     ;2+
        lda     $D2        ;3
        cmp     $D8        ;3
        bcc     _L66A7     ;2+
        lda     $D3        ;3
        cmp     $D9        ;3
        bcc     _L66A7     ;2+
        lda     #$05       ;2
        rts                ;6

_L66A7  lda     #$00       ;2
        rts                ;6

L66AA   ldx     #$00       ;2
L66AC   lda     LAA06,x    ;4+
        cmp     #$69       ;2
        bne     _L66B8     ;2+
        lda     #$01       ;2
        jmp     L6798      ;3

_L66B8  cmp     #$6A       ;2
        bne     _L66C1     ;2+
        lda     #$02       ;2
        jmp     L6798      ;3

_L66C1  cmp     #$6B       ;2
        bne     _L66CA     ;2+
        lda     #$03       ;2
        jmp     L6798      ;3

_L66CA  cmp     #$6C       ;2
L66CC   bne     _L66D3     ;2+
        lda     #$04       ;2
        jmp     L6798      ;3

_L66D3  inx                ;2
        cpx     #$14       ;2
        bne     L66AC      ;2+
        rts                ;6

        .byte   $AD
        .byte   $62
        .text   "WI",$0A,"P"
        .byte   $09
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $62
        .byte   $D7
        .byte   $EE
        .byte   $61
        .byte   $D7
        .byte   $60
        .byte   $EE
        .byte   $62
        .byte   $D7
        .byte   $60

L66ED   lda     #$05       ;2
        sta     L60DB      ;4
        jsr     L6C27      ;6
        jsr     L6959      ;6
        lda     #$00       ;2
        sta     LBB3E      ;4
        sta     $E4        ;3
        sta     $E5        ;3
        sta     L6A62      ;4
        sta     L750C      ;4
        sta     L80A3+2    ;4
        jsr     L8237      ;6
        jsr     L7FC2      ;6
        lda     #$00       ;2
        sta     $F4        ;3
        sta     $F5        ;3
        jsr     L76A6      ;6
        jsr     L7429      ;6
        lda     #$00       ;2
        sta     $F6        ;3
        sta     $F7        ;3
        sta     L60DA      ;4
        sta     L7DEF      ;4
        sta     L7249      ;4
        sta     L60DC      ;4
        sta     L60DD      ;4
        ldx     #$01       ;2
        lda     L70EA      ;4
        beq     _L673A     ;2+
        ldx     #$00       ;2
_L673A  stx     LAD86      ;4
        lda     #$00       ;2
        sta     LADA4      ;4
        sta     LADA5      ;4
        sta     LADC4      ;4
        sta     LADC5      ;4
        lda     #$16       ;2
        sta     LADA6      ;4
        sta     LADC6      ;4
        lda     #$00       ;2
        sta     L7DF0      ;4
        sta     L724A      ;4
        jsr     $FA4A      ;6
        and     #$0F       ;2
        sta     LBB3E      ;4
        ldx     #$00       ;2
_L6765  lda     LBD5E,x    ;4+
        cmp     #$F0       ;2
        bcc     _L6771     ;2+
        lda     #$00       ;2
        sta     LBD5E,x    ;5
_L6771  inx                ;2
        cpx     #$5A       ;2
        bne     _L6765     ;2+
        ldx     #$00       ;2
        txa                ;2
_L6779  sta     LB1A1,x    ;5
        sta     LB1DD,x    ;5
        inx                ;2
        cpx     #$3C       ;2
        bne     _L6779     ;2+
        lda     #$00       ;2
        sta     L1484      ;4
        sta     L1485      ;4
        ldx     #$00       ;2
        txa                ;2
_L678F  sta     LAA06,x    ;5
        inx                ;2
        cpx     #$14       ;2
        bne     _L678F     ;2+
        rts                ;6

L6798   tax                ;2
        dex                ;2
        txa                ;2
        and     #$03       ;2
        asl     a          ;2
        tax                ;2
        lda     L68FF,x    ;4+
        sta     $D0        ;3
        lda     L6900,x    ;4+
        sta     $D1        ;3
        ldy     #$00       ;2
        lda     ($D0),y    ;5+
        bne     _L67B0     ;2+
        rts                ;6

_L67B0  sta     L60E3      ;4
        sta     L67F8+1    ;4
        iny                ;2
        lda     ($D0),y    ;5+
        and     #$FE       ;2
        sta     L60E0      ;4
        iny                ;2
        lda     ($D0),y    ;5+
        sta     L60E1      ;4
        lda     L70EA      ;4
        sta     L60E2      ;4
        jsr     L68FB      ;6
L67CD   jsr     L66ED      ;6
        lda     L60E0      ;4
        sta     LAD84      ;4
        lda     L60E1      ;4
        sta     LAD85      ;4
        lda     L60E2      ;4
        sta     L70EA      ;4
        jsr     $FA4A      ;6
        sta     L1483      ;4
        lda     L1248      ;4
        sta     L68DD+1    ;4
        lda     L1247      ;4
        beq     L6869      ;3+
        lda     #$E4       ;2
        sta     L1248      ;4
L67F8   lda     #$01       ;2
        ldx     #$E4       ;2
        jsr     LB995      ;6
        jsr     L6907      ;6
        lda     #$00       ;2
        jsr     LA76E      ;6
        lda     #$00       ;2
        jsr     LA346      ;6
        lda     #$01       ;2
        jsr     LA76E      ;6
        lda     #$01       ;2
        jsr     LA346      ;6
        lda     #$02       ;2
        jsr     LA76E      ;6
        lda     #$02       ;2
        jsr     LA346      ;6
_L6820  lda     $FF1D      ;4
        cmp     #$D0       ;2
        bcc     _L6820     ;2+
        lda     #$E4       ;2
        sta     $FF14      ;4
        lda     #$0C       ;2
        sta     L1248      ;4
        lda     L67F8+1    ;4
        ldx     #$0C       ;2
        jsr     LB995      ;6
        jsr     L6907      ;6
        lda     #$00       ;2
        jsr     LA398      ;6
        lda     #$00       ;2
        jsr     LA2F4      ;6
        lda     #$01       ;2
        jsr     LA398      ;6
        lda     #$01       ;2
        jsr     LA2F4      ;6
        lda     #$02       ;2
        jsr     LA398      ;6
        lda     #$02       ;2
        jsr     LA2F4      ;6
_L685A  lda     $FF1D      ;4
        cmp     #$D0       ;2
        bcc     _L685A     ;2+
        lda     #$0C       ;2
        sta     $FF14      ;4
        jmp     L68DD      ;3

L6869   lda     #$0C       ;2
        sta     L1248      ;4
        lda     L67F8+1    ;4
        ldx     #$0C       ;2
        jsr     LB995      ;6
        jsr     L6907      ;6
        lda     #$00       ;2
        jsr     LA398      ;6
        lda     #$00       ;2
        jsr     LA2F4      ;6
        lda     #$01       ;2
        jsr     LA398      ;6
        lda     #$01       ;2
        jsr     LA2F4      ;6
        lda     #$02       ;2
        jsr     LA398      ;6
        lda     #$02       ;2
        jsr     LA2F4      ;6
_L6897  lda     $FF1D      ;4
        cmp     #$D0       ;2
        bcc     _L6897     ;2+
        lda     #$0C       ;2
        sta     $FF14      ;4
        lda     #$E4       ;2
        sta     L1248      ;4
        lda     L67F8+1    ;4
        ldx     #$E4       ;2
        jsr     LB995      ;6
        jsr     L6907      ;6
        lda     #$00       ;2
        jsr     LA76E      ;6
        lda     #$00       ;2
        jsr     LA346      ;6
        lda     #$01       ;2
        jsr     LA76E      ;6
        lda     #$01       ;2
        jsr     LA346      ;6
        lda     #$02       ;2
        jsr     LA76E      ;6
        lda     #$02       ;2
        jsr     LA346      ;6
_L68D1  lda     $FF1D      ;4
        cmp     #$D0       ;2
        bcc     _L68D1     ;2+
        lda     #$E4       ;2
        sta     $FF14      ;4
L68DD   lda     #$00       ;2
        sta     L1248      ;4
        lda     #$00       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $E4        ;3
        and     #$02       ;2
        beq     _L68F4     ;2+
        lda     #$14       ;2
        sta     LAD86      ;4
_L68F4  lda     L60E3      ;4
        jsr     LDF27      ;6
        rts                ;6

L68FB   jsr     L122F      ;6
        rts                ;6

L68FF   .byte   $FB
L6900   .byte   $CB
        .byte   $FE
        .byte   $CB
        .byte   $01
        .byte   $CC
        .byte   $04
        .byte   $CC

L6907   lda     LCC07+2    ;4
        sta     L1454+1    ;4
        lda     LCC0A      ;4
        sta     L1454+2    ;4
        lda     LCC07      ;4
        sta     _L691F+1   ;4
        lda     LCC07+1    ;4
        sta     L6923-2    ;4
_L691F  jsr     $0000      ;6
        rts                ;6

L6923   .byte   $00

L6924   lda     #$00       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $E4        ;3
        sta     $D1        ;3
        and     #$40       ;2
        beq     _L6936     ;2+
        jmp     L6959      ;3

_L6936  lda     #$00       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $E5        ;3
        and     #$C0       ;2
        bne     L6959      ;2+
        ldx     #$0B       ;2
        stx     LAD86      ;4
        jsr     L6DE3      ;6
        lda     #$01       ;2
        sta     L6923      ;4
        lda     LAD84      ;4
        and     #$FE       ;2
        sta     LAD84      ;4
        rts                ;6

L6959   lda     #$00       ;2
        sta     L6923      ;4
        rts                ;6

L695F   .byte   $00
L6960   .byte   $00
        .byte   $00

L6962   lda     L6960      ;4
        eor     #$01       ;2
        sta     L6960      ;4
        bne     _L6971     ;2+
        lda     #$14       ;2
        jmp     _L6973     ;3

_L6971  lda     #$15       ;2
_L6973  sta     LAD86      ;4
        rts                ;6

L6977   .byte   $01

L6978   lda     LAD85      ;4
        cmp     #$26       ;2
        bcs     _L6985     ;2+
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

_L6985  lda     L695F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     #$06       ;2
        bcc     _L69AB     ;2+
        jsr     L6DD8      ;6
        jsr     L6DD8      ;6
        jsr     L6DD8      ;6
        lda     #$00       ;2
        ldx     #$02       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L69AF     ;2+
        jsr     L6C11      ;6
        jsr     L6962      ;6
        lda     #$00       ;2
_L69AB  sta     L695F      ;4
        rts                ;6

_L69AF  jsr     L6DE3      ;6
        jsr     L6DE3      ;6
        jsr     L6DE3      ;6
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

L69BE   lda     LAD85      ;4
        cmp     #$C0       ;2
        bcc     _L69CB     ;2+
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

_L69CB  lda     L695F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     #$06       ;2
        bcc     _L69F3     ;2+
        jsr     L6DE3      ;6
        jsr     L6DE3      ;6
        jsr     L6DE3      ;6
        lda     #$00       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $E5        ;3
        and     #$20       ;2
        bne     _L69F7     ;2+
        jsr     L6C11      ;6
        jsr     L6962      ;6
        lda     #$00       ;2
_L69F3  sta     L695F      ;4
        rts                ;6

_L69F7  jsr     L6DD8      ;6
        jsr     L6DD8      ;6
        jsr     L6DD8      ;6
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

L6A06   lda     L695F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     L6977      ;4
        bcc     _L6A27     ;2+
        jsr     L6DB8      ;6
        lda     #$00       ;2
        ldx     #$03       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L6A2B     ;2+
        jsr     L6C11      ;6
        jsr     L6962      ;6
        lda     #$00       ;2
_L6A27  sta     L695F      ;4
        rts                ;6

_L6A2B  jsr     L6DC8      ;6
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

L6A34   lda     L695F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     L6977      ;4
        bcc     _L6A55     ;2+
        jsr     L6DC8      ;6
        lda     #$00       ;2
        ldx     #$04       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L6A59     ;2+
        jsr     L6C11      ;6
        jsr     L6962      ;6
        lda     #$00       ;2
_L6A55  sta     L695F      ;4
        rts                ;6

_L6A59  jsr     L6DB8      ;6
        lda     #$00       ;2
        sta     L695F      ;4
        rts                ;6

L6A62   .byte   $00

L6A63   jsr     L6C5B      ;6
        cmp     #$FF       ;2
        beq     _L6A6D     ;2+
        lda     #$00       ;2
        rts                ;6

_L6A6D  lda     L6A62      ;4
        beq     _L6A78     ;2+
        dec     L6A62      ;6
        jmp     _L6BE8     ;3

_L6A78  jsr     L70F0      ;6
        lda     #$00       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $E4        ;3
        tax                ;2
        and     #$40       ;2
        beq     _L6ACC     ;2+
        ldy     #$06       ;2
        txa                ;2
        and     #$02       ;2
        bne     _L6A92     ;2+
        ldy     #$02       ;2
_L6A92  sty     L6977      ;4
        jsr     L6C27      ;6
        lda     L70EC      ;4
        bne     _L6AA3     ;2+
        jsr     L69BE      ;6
        jmp     _L6C0E     ;3

_L6AA3  lda     L70EB      ;4
        bne     _L6AAE     ;2+
        jsr     L6978      ;6
        jmp     _L6C0E     ;3

_L6AAE  lda     L70ED      ;4
        bne     _L6AB9     ;2+
        jsr     L6A06      ;6
        jmp     _L6C0E     ;3

_L6AB9  lda     L70EE      ;4
        bne     _L6AC4     ;2+
        jsr     L6A34      ;6
        jmp     _L6C0E     ;3

_L6AC4  lda     #$00       ;2
        sta     L695F      ;4
        jmp     _L6C0E     ;3

_L6ACC  lda     L70EC      ;4
        bne     _L6AF8     ;2+
        lda     LAD84      ;4
        and     #$FE       ;2
        sta     LAD84      ;4
        lda     L70EA      ;4
        beq     _L6AEB     ;2+
        lda     #$09       ;2
        jsr     L6C2C      ;6
        lda     #$0C       ;2
        sta     L60DC      ;4
        jmp     _L6C0B     ;3

_L6AEB  lda     #$0A       ;2
        jsr     L6C2C      ;6
        lda     #$0C       ;2
        sta     L60DC      ;4
        jmp     _L6C0B     ;3

_L6AF8  lda     L70ED      ;4
        bne     _L6B55     ;3+
        lda     L70EB      ;4
        bne     _L6B0A     ;2+
        lda     #$01       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6B0A  lda     L70EF      ;4
        bne     _L6B2F     ;2+
        lda     #$00       ;2
        ldx     #$05       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L6B22     ;2+
        lda     #$06       ;2
        sta     L6A62      ;4
        jmp     _L6C0B     ;3

_L6B22  lda     #$07       ;2
        jsr     L6C2C      ;6
        lda     #$81       ;2
        jsr     $0200      ;6
        jmp     _L6C0B     ;3

_L6B2F  lda     #$00       ;2
        ldx     #$03       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L6B47     ;2+
        lda     #$06       ;2
        sta     L6A62      ;4
        lda     #$00       ;2
        sta     L70EA      ;4
        jmp     _L6C0B     ;3

_L6B47  lda     #$03       ;2
        sta     LAD86      ;4
        jsr     L6DB8      ;6
        jsr     L6C16      ;6
        jmp     _L6C0B     ;3

_L6B55  lda     L70EE      ;4
        bne     _L6BB2     ;2+
        lda     L70EB      ;4
        bne     _L6B67     ;2+
        lda     #$02       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6B67  lda     L70EF      ;4
        bne     _L6B8C     ;2+
        lda     #$00       ;2
        ldx     #$06       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L6B7F     ;2+
        lda     #$06       ;2
        sta     L6A62      ;4
        jmp     _L6C0B     ;3

_L6B7F  lda     #$08       ;2
        jsr     L6C2C      ;6
        lda     #$81       ;2
        jsr     $0200      ;6
        jmp     _L6C0B     ;3

_L6B8C  lda     #$00       ;2
        ldx     #$04       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L6BA4     ;2+
        lda     #$01       ;2
        sta     L70EA      ;4
        lda     #$06       ;2
        sta     L6A62      ;4
        jmp     _L6C0B     ;3

_L6BA4  lda     #$02       ;2
        sta     LAD86      ;4
        jsr     L6DC8      ;6
        jsr     L6C16      ;6
        jmp     _L6C0B     ;3

_L6BB2  lda     L70EB      ;4
        bne     _L6BCC     ;2+
        lda     L70EA      ;4
        bne     _L6BC4     ;2+
        lda     #$03       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6BC4  lda     #$04       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6BCC  lda     L70EF      ;4
        bne     _L6BE8     ;2+
        lda     L70EA      ;4
        cmp     #$00       ;2
        beq     _L6BE0     ;2+
        lda     #$06       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6BE0  lda     #$05       ;2
        jsr     L6C2C      ;6
        jmp     _L6C0B     ;3

_L6BE8  lda     $E4        ;3
        and     #$02       ;2
        bne     _L6C03     ;3+
        lda     L70EA      ;4
        bne     _L6BFB     ;2+
        lda     #$01       ;2
        sta     LAD86      ;4
        jmp     _L6C0B     ;3

_L6BFB  lda     #$00       ;2
        sta     LAD86      ;4
        jmp     _L6C0B     ;3

_L6C03  lda     #$14       ;2
        sta     LAD86      ;4
        jmp     _L6C0B     ;3

_L6C0B  lda     #$FF       ;2
        rts                ;6

_L6C0E  lda     #$00       ;2
        rts                ;6

L6C11   lda     #$84       ;2
        jmp     $0200      ;3

L6C16   lda     LAD84      ;4
        and     #$03       ;2
        bne     _L6C22     ;2+
        lda     #$83       ;2
        jsr     $0200      ;6
_L6C22  rts                ;6

L6C23   .byte   $00
L6C24   .byte   $00
L6C25   .byte   $00
L6C26   .byte   $00

L6C27   lda     #$00       ;2
        jmp     L6C2C      ;3

L6C2C   sta     L6C26      ;4
        asl     a          ;2
        tax                ;2
        lda     L6DFF,x    ;4+
        sta     L6C61+1    ;4
        sta     L6C86+1    ;4
        sta     L6C8C+1    ;4
        sta     L6C92+1    ;4
        lda     L6E00,x    ;4+
        sta     L6C61+2    ;4
        sta     L6C86+2    ;4
        sta     L6C8C+2    ;4
        sta     L6C92+2    ;4
        lda     #$00       ;2
        sta     L6C23      ;4
        sta     L6C24      ;4
        sta     L6C25      ;4
        rts                ;6

L6C5B   lda     L6C23      ;4
        asl     a          ;2
        asl     a          ;2
        tax                ;2
L6C61   lda     L6DFF,x    ;4+
        cmp     #$FE       ;2
        bne     _L6C79     ;2+
        lda     #$00       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $E4        ;3
        jsr     L6DEE      ;6
        inc     L6C23      ;6
        lda     #$FF       ;2
_L6C79  cmp     #$FF       ;2
        bne     _L6C83     ;2+
        ldx     #$00       ;2
        stx     L60DA      ;4
        rts                ;6

_L6C83  sta     $D2        ;3
        inx                ;2
L6C86   lda     L6DFF,x    ;4+
        sta     $D1        ;3
        inx                ;2
L6C8C   lda     L6DFF,x    ;4+
        sta     $D0        ;3
        inx                ;2
L6C92   lda     L6DFF,x    ;4+
        sta     $E3        ;3
        inc     L6C24      ;6
        ldy     L6C24      ;4
        cpy     #$02       ;2
        bcc     _L6CA9     ;2+
        inc     L6C23      ;6
        ldy     #$00       ;2
        sty     L6C24      ;4
_L6CA9  lda     $D0        ;3
        beq     _L6CB5     ;2+
        inc     L6C23      ;6
        ldy     #$00       ;2
        sty     L6C24      ;4
_L6CB5  lda     $D2        ;3
        sta     LAD86      ;4
        lda     $D1        ;3
        tay                ;2
        and     #$07       ;2
        sta     _L6D32+1   ;4
        tya                ;2
        and     #$08       ;2
        sta     L60DA      ;4
        tya                ;2
        sta     $E1        ;3
        ldx     #$00       ;2
_L6CCD  stx     $E0        ;3
        lda     #$00       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $E4        ;3
        and     #$40       ;2
        beq     _L6CF2     ;2+
        lda     L6C26      ;4
        cmp     #$0B       ;2
        beq     _L6CF2     ;2+
        cmp     #$0C       ;2
        beq     _L6CF2     ;2+
        cmp     #$0E       ;2
        beq     _L6CF2     ;2+
        cmp     #$0D       ;2
        beq     _L6CF2     ;2+
        jmp     _L6D93     ;3

_L6CF2  lda     $E1        ;3
        and     #$40       ;2
        beq     _L6D08     ;3+
        lda     #$00       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $E5        ;3
        and     #$C0       ;2
        bne     _L6D3E     ;2+
        jsr     L6DE3      ;6
_L6D08  lda     $E1        ;3
        and     #$80       ;2
        beq     _L6D11     ;2+
        jsr     L6DD8      ;6
_L6D11  lda     $E1        ;3
        and     #$20       ;2
        beq     _L6D20     ;2+
        lda     $E4        ;3
        and     #$20       ;2
        bne     _L6D65     ;2+
        jsr     _L6D9E     ;6
_L6D20  lda     $E1        ;3
        and     #$10       ;2
        beq     _L6D2F     ;2+
        lda     $E4        ;3
        and     #$20       ;2
        bne     _L6D7C     ;2+
        jsr     _L6DAB     ;6
_L6D2F  ldx     $E0        ;3
        inx                ;2
_L6D32  cpx     #$01       ;2
        bne     _L6CCD     ;3+
        lda     $E3        ;3
        sta     L70EA      ;4
        lda     #$00       ;2
        rts                ;6

_L6D3E  lda     L6C26      ;4
        cmp     #$0C       ;2
        beq     _L6D54     ;2+
        cmp     #$0B       ;2
        beq     _L6D54     ;2+
        lda     $E3        ;3
        sta     L70EA      ;4
        jsr     L6DEE      ;6
        lda     #$FF       ;2
        rts                ;6

_L6D54  jsr     L6DE3      ;6
        jmp     _L6D08     ;3

        .byte   $A5
        .byte   $E3
        .byte   $8D
        .byte   $EA
        .byte   $70
        .byte   $20
        .byte   $EE
        .byte   $6D
        .byte   $A9
        .byte   $FF
        .byte   $60

_L6D65  jsr     L6DC8      ;6
        jsr     L6DC8      ;6
        jsr     L6DC8      ;6
        jsr     L6C27      ;6
        lda     #$06       ;2
        sta     L6A62      ;4
        jsr     L6DEE      ;6
        lda     #$FF       ;2
        rts                ;6

_L6D7C  jsr     L6DB8      ;6
        jsr     L6DB8      ;6
        jsr     L6DB8      ;6
        jsr     L6C27      ;6
        lda     #$06       ;2
        sta     L6A62      ;4
        jsr     L6DEE      ;6
        lda     #$FF       ;2
        rts                ;6

_L6D93  lda     $E3        ;3
        sta     L70EA      ;4
        jsr     L6DEE      ;6
        lda     #$FF       ;2
        rts                ;6

_L6D9E  lda     L6C25      ;4
        beq     _L6DA8     ;2+
        lda     $D0        ;3
        bne     _L6DA8     ;2+
        rts                ;6

_L6DA8  jmp     L6DB8      ;3

_L6DAB  lda     L6C25      ;4
        beq     _L6DB5     ;2+
        lda     $D0        ;3
        bne     _L6DB5     ;2+
        rts                ;6

_L6DB5  jmp     L6DC8      ;3

L6DB8   ldx     #$00       ;2
        stx     L70EA      ;4
        lda     LAD84      ;4
        cmp     #$12       ;2
        bcc     _L6DC7     ;2+
        dec     LAD84      ;6
_L6DC7  rts                ;6

L6DC8   ldx     #$01       ;2
        stx     L70EA      ;4
        lda     LAD84      ;4
        cmp     #$A8       ;2
        bcs     _L6DD7     ;2+
        inc     LAD84      ;6
_L6DD7  rts                ;6

L6DD8   lda     LAD85      ;4
        cmp     #$21       ;2
        bcc     _L6DE2     ;2+
        dec     LAD85      ;6
_L6DE2  rts                ;6

L6DE3   lda     LAD85      ;4
        cmp     #$DF       ;2
        bcs     _L6DED     ;2+
        inc     LAD85      ;6
_L6DED  rts                ;6

L6DEE   lda     $E4        ;3
        and     #$40       ;2
        beq     _L6DFE     ;2+
        lda     #$14       ;2
        sta     LAD86      ;4
        lda     #$00       ;2
        sta     L6960      ;4
_L6DFE  rts                ;6

L6DFF   .byte   $21
L6E00   .byte   $6E
        .byte   $22
        .byte   $6E
        .byte   $5F
        .byte   $6E
        .byte   $9C
        .byte   $6E
        .byte   $E1
        .byte   $6E
        .byte   $26
        .byte   $6F
        .byte   $3B
        .byte   $6F
        .byte   $50
        .byte   $6F
        .byte   $81
        .byte   $6F
        .byte   $AA
        .byte   $6F
        .byte   $BB
        .byte   $6F
        .byte   $15
        .byte   $70
        .byte   $CC
        .byte   $6F
        .byte   $6F
        .byte   $70
        .byte   $62
        .byte   $70
        .byte   $B1
        .byte   $70
        .byte   $7C
        .byte   $70
        .byte   $FF
        .byte   $06
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $07
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $06
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $04
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $11
        .byte   $01
        .byte   $01
        .byte   $05
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $04
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $09
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0A
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $0A
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $09
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $08
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0A
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $0B
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $0A
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $08
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $0D
        .byte   $2C
        .byte   $01
        .byte   $00
        .byte   $0D
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $0D
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $14
        .byte   $01
        .byte   $00
        .byte   $FF
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $0C
        .byte   $09
        .byte   $00
        .byte   $01
        .byte   $0C
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $0C
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $0E
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $0E
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $0F
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $0E
        .byte   $14
        .byte   $01
        .byte   $00
        .byte   $0E
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $10
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $10
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $10
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $12
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $12
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $12
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $12
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $13
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $13
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $13
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $13
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $34
        .byte   $22
        .byte   $00
        .byte   $01
        .byte   $34
        .byte   $22
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $22
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $42
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $42
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $33
        .byte   $12
        .byte   $00
        .byte   $00
        .byte   $33
        .byte   $12
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $35
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $42
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $42
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $14
        .byte   $01
        .byte   $00
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $00
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $00
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $01
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $34
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $34
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $34
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $36
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $33
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $33
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $33
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $35
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $01
        .byte   $11
        .byte   $01
        .byte   $00
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
L70EA   .byte   $00
L70EB   .byte   $FF
L70EC   .byte   $FF
L70ED   .byte   $FF
L70EE   .byte   $FF
L70EF   .byte   $FF

L70F0   lda     L60D9      ;4
        cmp     #$01       ;2
        beq     _L7102     ;3+
        cmp     #$02       ;2
        beq     _L710D     ;3+
        cmp     #$03       ;2
        beq     _L7118     ;3+
        jmp     _L714F     ;3

_L7102  lda     #$FB       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        jmp     _L7120     ;3

_L710D  lda     #$FD       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        jmp     _L7120     ;3

_L7118  lda     #$F7       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
_L7120  lda     $FF08      ;4
        tax                ;2
        and     #$01       ;2
        sta     L70EB      ;4
        txa                ;2
        and     #$02       ;2
        sta     L70EC      ;4
        txa                ;2
        and     #$04       ;2
        sta     L70ED      ;4
        txa                ;2
        and     #$08       ;2
        sta     L70EE      ;4
        txa                ;2
        and     #$C0       ;2
        cmp     #$C0       ;2
        beq     _L7148     ;2+
        lda     #$00       ;2
        sta     L70EF      ;4
        rts                ;6

_L7148  sta     L70EF      ;4
        rts                ;6

_L714C  .byte   $00
_L714D  .byte   $00
_L714E  .byte   $00

_L714F  lda     #$FF       ;2
        sta     L70EC      ;4
        sta     L70EB      ;4
        sta     L70ED      ;4
        sta     L70EE      ;4
        sta     L70EF      ;4
        lda     LAD84      ;4
        ldx     #$00       ;2
        cmp     LADA4      ;4
        bcs     _L716C     ;2+
        ldx     #$01       ;2
_L716C  stx     L70EA      ;4
        lda     _L714C     ;4
        beq     _L7178     ;2+
        dec     _L714C     ;6
        rts                ;6

_L7178  lda     _L714D     ;4
        bne     _L71B1     ;2+
        lda     LAD84      ;4
        cmp     #$98       ;2
        bcc     _L7189     ;2+
        ldx     #$00       ;2
        stx     L70EA      ;4
_L7189  cmp     #$20       ;2
        bcs     _L7192     ;2+
        ldx     #$01       ;2
        stx     L70EA      ;4
_L7192  lda     L70EA      ;4
        sta     _L714E     ;4
        jsr     $FA4A      ;6
        tax                ;2
        and     #$1F       ;2
        clc                ;2
        adc     #$14       ;2
        sta     _L714D     ;4
        txa                ;2
        and     #$03       ;2
        bne     _L71AE     ;2+
        lda     #$00       ;2
        sta     L70EB      ;4
_L71AE  jmp     _L71B4     ;3

_L71B1  dec     _L714D     ;6
_L71B4  ldy     #$00       ;2
        ldx     _L714E     ;4
        beq     _L71CC     ;2+
        lda     LAD84      ;4
        cmp     #$A8       ;2
        bcs     _L71DA     ;2+
        sty     L70EE      ;4
        lda     #$01       ;2
        sta     $D0        ;3
        jmp     _L71DA     ;3

_L71CC  lda     LAD84      ;4
        cmp     #$10       ;2
        bcc     _L71DA     ;2+
        sty     L70ED      ;4
        lda     #$00       ;2
        sta     $D0        ;3
_L71DA  lda     $E4        ;3
        and     #$20       ;2
        beq     _L71E5     ;2+
        lda     #$00       ;2
        sta     _L714D     ;4
_L71E5  lda     LADA5      ;4
        sec                ;2
        sbc     LAD85      ;4
        cmp     #$14       ;2
        bcc     _L71F7     ;2+
        cmp     #$EB       ;2
        bcs     _L71F7     ;2+
        jmp     _L720A     ;3

_L71F7  lda     LAD84      ;4
        ldy     $D0        ;3
        ldx     LADA4      ;4
        jsr     L7DB4      ;6
        cmp     #$02       ;2
        beq     _L722E     ;2+
        cmp     #$01       ;2
        beq     _L7234     ;2+
_L720A  lda     LADC5      ;4
        sec                ;2
        sbc     LAD85      ;4
        cmp     #$14       ;2
        bcc     _L721A     ;2+
        cmp     #$EB       ;2
        bcs     _L721A     ;2+
        rts                ;6

_L721A  lda     LAD84      ;4
        ldy     $D0        ;3
        ldx     LADC4      ;4
        jsr     L7DB4      ;6
        cmp     #$02       ;2
        beq     _L722E     ;2+
        cmp     #$01       ;2
        beq     _L7234     ;2+
        rts                ;6

_L722E  lda     #$00       ;2
        sta     L70EF      ;4
        rts                ;6

_L7234  lda     #$00       ;2
        sta     L70EF      ;4
        lda     #$FF       ;2
        sta     L70ED      ;4
        sta     L70EE      ;4
        sta     L70EC      ;4
        sta     L70EB      ;4
        rts                ;6

L7248   .byte   $00
L7249   .byte   $00
L724A   .byte   $00
L724B   .byte   $00
L724C   .byte   $00
L724D   .byte   $00
L724E   .byte   $00

L724F   lda     L724A      ;4
        bne     _L7262     ;2+
        lda     #$16       ;2
        sta     LADA6      ;4
        lda     #$00       ;2
        sta     LADA4      ;4
        sta     LADA5      ;4
        rts                ;6

_L7262  lda     L724E      ;4
        cmp     #$FF       ;2
        beq     _L7277     ;2+
        lda     L724D      ;4
        clc                ;2
        adc     #$01       ;2
        bcc     _L7274     ;2+
        inc     L724E      ;6
_L7274  sta     L724D      ;4
_L7277  lda     L73EC      ;4
        bne     _L7283     ;2+
        jsr     L750D      ;6
        cmp     #$FF       ;2
        bne     _L7286     ;2+
_L7283  jsr     L73ED      ;6
_L7286  jsr     _L7313     ;6
        lda     L73EC      ;4
        beq     _L7298     ;2+
        lda     #$00       ;2
        sta     L7C2C      ;4
        lda     #$14       ;2
        sta     L7CAC+1    ;4
_L7298  lda     $F6        ;3
        tax                ;2
        and     #$04       ;2
        beq     _L72A2     ;2+
        jmp     _L72D3     ;3

_L72A2  txa                ;2
        and     #$02       ;2
        beq     _L72B8     ;2+
        jsr     _L72EF     ;6
        lda     LADA5      ;4
        cmp     #$C7       ;2
        bcs     _L72D8     ;2+
        cmp     #$21       ;2
        bcc     _L72D8     ;2+
        lda     $F6        ;3
        tax                ;2
_L72B8  txa                ;2
        and     #$10       ;2
        beq     _L72C0     ;2+
        jmp     _L72D8     ;3

_L72C0  lda     $F7        ;3
        tax                ;2
        and     #$04       ;2
        beq     _L72CA     ;2+
        jmp     _L72D3     ;3

_L72CA  txa                ;2
        and     #$01       ;2
        beq     _L72D2     ;2+
        jmp     _L72E6     ;3

_L72D2  rts                ;6

_L72D3  lda     #$04       ;2
        jsr     $0200      ;6
_L72D8  lda     #$00       ;2
        sta     L724A      ;4
        jsr     $FA4A      ;6
        and     #$03       ;2
        sta     LBB3E      ;4
        rts                ;6

_L72E6  lda     L60E5      ;4
        ora     #$80       ;2
        sta     L60E5      ;4
        rts                ;6

_L72EF  lda     LADA6      ;4
        cmp     #$2F       ;2
        beq     _L72FB     ;2+
        cmp     #$30       ;2
        beq     _L72FB     ;2+
        rts                ;6

_L72FB  lda     LC7B5      ;4
        cmp     #$01       ;2
        beq     _L7307     ;2+
        cmp     #$02       ;2
        beq     _L730D     ;2+
        rts                ;6

_L7307  jsr     L787C      ;6
        jmp     L787C      ;3

_L730D  jsr     L7887      ;6
        jmp     L7887      ;3

_L7313  lda     L724C      ;4
        beq     _L7328     ;2+
        cmp     #$0F       ;2
        bcs     _L7324     ;2+
        lda     L724B      ;4
        bne     _L7324     ;2+
        jmp     _L72D8     ;3

_L7324  dec     L724C      ;6
        rts                ;6

_L7328  lda     L73EC      ;4
        sta     $07        ;3
        lda     L7DEF      ;4
        clc                ;2
        adc     L7F85      ;4
        beq     _L7349     ;2+
        ldx     #$01       ;2
        ldy     #$02       ;2
        lda     L7F85      ;4
        sta     $06        ;3
        lda     L86E2      ;4
        jsr     L658E      ;6
        and     #$7F       ;2
        bne     _L7368     ;2+
_L7349  lda     L60DA      ;4
        clc                ;2
        adc     L6923      ;4
        beq     _L7367     ;2+
        ldx     #$01       ;2
        ldy     #$00       ;2
        lda     L6923      ;4
        sta     $06        ;3
        lda     L70EA      ;4
        jsr     L658E      ;6
        sta     $0F        ;3
        and     #$7F       ;2
        bne     _L737F     ;2+
_L7367  rts                ;6

_L7368  tax                ;2
        lda     L7F85      ;4
        and     L73EC      ;4
        beq     _L7372     ;2+
        rts                ;6

_L7372  txa                ;2
        sta     $AA        ;3
        lda     #$01       ;2
        jsr     $0200      ;6
        lda     $AA        ;3
        jmp     _L73A2     ;3

_L737F  tax                ;2
        lda     L6923      ;4
        and     L73EC      ;4
        beq     _L7389     ;2+
        rts                ;6

_L7389  txa                ;2
        ldx     #$FF       ;2
        stx     L6C25      ;4
        jsr     L6558      ;6
        ldx     L724B      ;4
        cpx     #$01       ;2
        bne     _L73A2     ;2+
        sta     $58        ;3
        lda     #$05       ;2
        jsr     LD6F3      ;6
        lda     $58        ;3
_L73A2  dec     L724B      ;6
        ldx     #$00       ;2
        stx     L7C2B      ;4
        ldx     #$23       ;2
        stx     L724C      ;4
        cmp     #$01       ;2
        beq     _L73C9     ;2+
        cmp     #$02       ;2
        beq     _L73CE     ;2+
        cmp     #$05       ;2
        beq     _L73DD     ;2+
        ldx     #$05       ;2
        stx     L724C      ;4
        cmp     #$03       ;2
        beq     _L73D3     ;2+
        cmp     #$04       ;2
        beq     _L73D8     ;2+
        rts                ;6

_L73C9  lda     #$0C       ;2
        jmp     L76AB      ;3

_L73CE  lda     #$0B       ;2
        jmp     L76AB      ;3

_L73D3  lda     #$0E       ;2
        jmp     L76AB      ;3

_L73D8  lda     #$0D       ;2
        jmp     L76AB      ;3

_L73DD  lda     L7BC9      ;4
        bne     _L73E7     ;2+
        lda     #$0F       ;2
        jmp     L76AB      ;3

_L73E7  lda     #$10       ;2
        jmp     L76AB      ;3

L73EC   .byte   $00

L73ED   lda     #$01       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $F6        ;3
        sta     $D1        ;3
        and     #$40       ;2
        beq     _L73FF     ;2+
        jmp     L7429      ;3

_L73FF  lda     #$01       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $F7        ;3
        and     #$C0       ;2
        bne     L7429      ;2+
        ldx     #$19       ;2
        lda     L7BC9      ;4
        beq     _L7415     ;2+
        ldx     #$1A       ;2
_L7415  stx     LADA6      ;4
        jsr     L7887      ;6
        lda     #$01       ;2
        sta     L73EC      ;4
        lda     LADA4      ;4
        and     #$FE       ;2
        sta     LADA4      ;4
        rts                ;6

L7429   lda     #$00       ;2
        sta     L73EC      ;4
        rts                ;6

L742F   .byte   $00
L7430   .byte   $00
        .byte   $00
L7432   .byte   $00

L7433   lda     L7430      ;4
        eor     #$01       ;2
        sta     L7430      ;4
        bne     _L7442     ;2+
        lda     #$2F       ;2
        jmp     _L7444     ;3

_L7442  lda     #$30       ;2
_L7444  sta     LADA6      ;4
        rts                ;6

L7448   lda     L742F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     #$06       ;2
        bcc     _L746B     ;2+
        jsr     L787C      ;6
        jsr     L787C      ;6
        jsr     L787C      ;6
        lda     #$01       ;2
        ldx     #$02       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L746F     ;2+
        jsr     L7433      ;6
        lda     #$00       ;2
_L746B  sta     L742F      ;4
        rts                ;6

_L746F  jsr     L7887      ;6
        jsr     L7887      ;6
        jsr     L7887      ;6
        lda     #$00       ;2
        sta     L742F      ;4
        rts                ;6

L747E   lda     L742F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     #$06       ;2
        bcc     _L74A3     ;2+
        jsr     L7887      ;6
        jsr     L7887      ;6
        jsr     L7887      ;6
        lda     #$01       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $F7        ;3
        and     #$20       ;2
        bne     _L74A7     ;2+
        jsr     L7433      ;6
        lda     #$00       ;2
_L74A3  sta     L742F      ;4
        rts                ;6

_L74A7  jsr     L787C      ;6
        jsr     L787C      ;6
        jsr     L787C      ;6
        lda     #$00       ;2
        sta     L742F      ;4
        rts                ;6

L74B6   lda     L742F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     L7432      ;4
        bcc     _L74D4     ;2+
        jsr     L785C      ;6
        lda     #$01       ;2
        ldx     #$03       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L74D8     ;2+
        jsr     L7433      ;6
        lda     #$00       ;2
_L74D4  sta     L742F      ;4
        rts                ;6

_L74D8  jsr     L786C      ;6
        lda     #$00       ;2
        sta     L742F      ;4
        rts                ;6

L74E1   lda     L742F      ;4
        clc                ;2
        adc     #$01       ;2
        cmp     L7432      ;4
        bcc     _L74FF     ;2+
        jsr     L786C      ;6
        lda     #$01       ;2
        ldx     #$04       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        bne     _L7503     ;3+
        jsr     L7433      ;6
        lda     #$00       ;2
_L74FF  sta     L742F      ;4
        rts                ;6

_L7503  jsr     L785C      ;6
        lda     #$00       ;2
        sta     L742F      ;4
        rts                ;6

L750C   .byte   $00

L750D   jsr     L76DA      ;6
        cmp     #$FF       ;2
        beq     _L7517     ;2+
        lda     #$00       ;2
        rts                ;6

_L7517  lda     L750C      ;4
        beq     _L7522     ;2+
        dec     L750C      ;6
        jmp     _L767F     ;3

_L7522  jsr     L7BCF      ;6
        lda     #$01       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $F6        ;3
        tax                ;2
        and     #$40       ;2
        beq     _L7576     ;2+
        ldy     #$06       ;2
        txa                ;2
        and     #$02       ;2
        bne     _L753C     ;2+
        ldy     #$02       ;2
_L753C  sty     L7432      ;4
        jsr     L76A6      ;6
        lda     L7BCB      ;4
        bne     _L754D     ;2+
        jsr     L747E      ;6
        jmp     _L769F     ;3

_L754D  lda     L7BCA      ;4
        bne     _L7558     ;2+
        jsr     L7448      ;6
        jmp     _L769F     ;3

_L7558  lda     L7BCC      ;4
        bne     _L7563     ;2+
        jsr     L74B6      ;6
        jmp     _L769F     ;3

_L7563  lda     L7BCD      ;4
        bne     _L756E     ;2+
        jsr     L74E1      ;6
        jmp     _L769F     ;3

_L756E  lda     #$00       ;2
        sta     L742F      ;4
        jmp     _L769F     ;3

_L7576  lda     L7BCB      ;4
        bne     _L75A2     ;2+
        lda     LADA4      ;4
        and     #$FE       ;2
        sta     LADA4      ;4
        lda     L7BC9      ;4
        beq     _L7595     ;2+
        lda     #$06       ;2
        jsr     L76AB      ;6
        lda     #$02       ;2
        jsr     $0200      ;6
        jmp     _L769C     ;3

_L7595  lda     #$05       ;2
        jsr     L76AB      ;6
        lda     #$02       ;2
        jsr     $0200      ;6
        jmp     _L769C     ;3

_L75A2  lda     L7BCC      ;4
        bne     _L75F7     ;2+
        lda     L7BCA      ;4
        bne     _L75AF     ;2+
        jmp     _L75B4     ;3

_L75AF  lda     L7BCE      ;4
        bne     _L75D4     ;2+
_L75B4  lda     #$01       ;2
        ldx     #$05       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L75C7     ;2+
        lda     #$06       ;2
        sta     L750C      ;4
        jmp     _L769C     ;3

_L75C7  lda     #$07       ;2
        jsr     L76AB      ;6
        lda     #$82       ;2
        jsr     $0200      ;6
        jmp     _L769C     ;3

_L75D4  lda     #$01       ;2
        ldx     #$07       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L75EC     ;2+
        lda     #$06       ;2
        sta     L750C      ;4
        lda     #$00       ;2
        sta     L7BC9      ;4
        jmp     _L769C     ;3

_L75EC  lda     #$1D       ;2
        sta     LADA6      ;4
        jsr     L785C      ;6
        jmp     _L769C     ;3

_L75F7  lda     L7BCD      ;4
        bne     _L764C     ;3+
        lda     L7BCA      ;4
        bne     _L7604     ;3+
        jmp     _L7609     ;3

_L7604  lda     L7BCE      ;4
        bne     _L7629     ;2+
_L7609  lda     #$01       ;2
        ldx     #$06       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L761C     ;2+
        lda     #$06       ;2
        sta     L750C      ;4
        jmp     _L769C     ;3

_L761C  lda     #$08       ;2
        jsr     L76AB      ;6
        lda     #$81       ;2
        jsr     $0200      ;6
        jmp     _L769C     ;3

_L7629  lda     #$01       ;2
        ldx     #$04       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L7641     ;2+
        lda     #$01       ;2
        sta     L7BC9      ;4
        lda     #$06       ;2
        sta     L750C      ;4
        jmp     _L769C     ;3

_L7641  lda     #$1E       ;2
        sta     LADA6      ;4
        jsr     L786C      ;6
        jmp     _L769C     ;3

_L764C  lda     L7BCA      ;4
        bne     _L7666     ;2+
        lda     L7BC9      ;4
        bne     _L765E     ;2+
        lda     #$03       ;2
        jsr     L76AB      ;6
        jmp     _L769C     ;3

_L765E  lda     #$04       ;2
        jsr     L76AB      ;6
        jmp     _L769C     ;3

_L7666  lda     L7BCE      ;4
        bne     _L767F     ;2+
        lda     L7BC9      ;4
        cmp     #$00       ;2
        beq     _L767A     ;2+
        lda     #$09       ;2
        jsr     L76AB      ;6
        jmp     _L769C     ;3

_L767A  lda     #$0A       ;2
        jsr     L76AB      ;6
_L767F  lda     LADA4      ;4
        and     #$FE       ;2
        sta     LADA4      ;4
        lda     L7BC9      ;4
        bne     _L7694     ;2+
        lda     #$21       ;2
        sta     LADA6      ;4
        jmp     _L769C     ;3

_L7694  lda     #$22       ;2
        sta     LADA6      ;4
        jmp     _L769C     ;3

_L769C  lda     #$FF       ;2
        rts                ;6

_L769F  lda     #$00       ;2
        rts                ;6

L76A2   .byte   $00
L76A3   .byte   $00
L76A4   .byte   $00
L76A5   .byte   $00

L76A6   lda     #$00       ;2
        jmp     L76AB      ;3

L76AB   sta     L76A5      ;4
        asl     a          ;2
        tax                ;2
        lda     L7892,x    ;4+
        sta     L76E0+1    ;4
        sta     L7705+1    ;4
        sta     L770B+1    ;4
        sta     L7711+1    ;4
        lda     L7893,x    ;4+
        sta     L76E0+2    ;4
        sta     L7705+2    ;4
        sta     L770B+2    ;4
        sta     L7711+2    ;4
        lda     #$00       ;2
        sta     L76A2      ;4
        sta     L76A3      ;4
        sta     L76A4      ;4
        rts                ;6

L76DA   lda     L76A2      ;4
        asl     a          ;2
        asl     a          ;2
        tax                ;2
L76E0   lda     L7892,x    ;4+
        cmp     #$FE       ;2
        bne     _L76F8     ;2+
        lda     #$01       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $F6        ;3
        jsr     L784B      ;6
        inc     L76A2      ;6
        lda     #$FF       ;2
_L76F8  cmp     #$FF       ;2
        bne     _L7702     ;3+
        ldx     #$00       ;2
        stx     L7249      ;4
        rts                ;6

_L7702  sta     $D2        ;3
        inx                ;2
L7705   lda     L7892,x    ;4+
        sta     $D1        ;3
        inx                ;2
L770B   lda     L7892,x    ;4+
        sta     $D0        ;3
        inx                ;2
L7711   lda     L7892,x    ;4+
        sta     $E3        ;3
        inc     L76A3      ;6
        ldy     L76A3      ;4
        cpy     #$02       ;2
        bcc     _L7728     ;2+
        inc     L76A2      ;6
        ldy     #$00       ;2
        sty     L76A3      ;4
_L7728  lda     $D0        ;3
        beq     _L7734     ;2+
        inc     L76A2      ;6
        ldy     #$00       ;2
        sty     L76A3      ;4
_L7734  lda     $D2        ;3
        sta     LADA6      ;4
        lda     $D1        ;3
        tay                ;2
        and     #$07       ;2
        sta     _L77BB+1   ;4
        tya                ;2
        and     #$08       ;2
        sta     L7249      ;4
        tya                ;2
        sta     $E1        ;3
        ldx     #$00       ;2
_L774C  stx     $E0        ;3
        lda     #$01       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $F6        ;3
        and     #$40       ;2
        beq     _L7771     ;2+
        lda     L76A5      ;4
        cmp     #$0C       ;2
        beq     _L7771     ;2+
        cmp     #$0B       ;2
        beq     _L7771     ;2+
        cmp     #$0D       ;2
        beq     _L7771     ;2+
        cmp     #$0E       ;2
        beq     _L7771     ;2+
        jmp     _L781F     ;3

_L7771  lda     $E1        ;3
        and     #$40       ;2
        beq     _L7787     ;2+
        lda     #$01       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $F7        ;3
        and     #$C0       ;2
        bne     _L77C7     ;2+
        jsr     L7887      ;6
_L7787  lda     $E1        ;3
        and     #$80       ;2
        beq     _L7790     ;2+
        jsr     L787C      ;6
_L7790  lda     $E1        ;3
        and     #$20       ;2
        beq     _L77A4     ;2+
        ldx     #$00       ;2
        stx     L7C2C      ;4
        lda     $F6        ;3
        and     #$20       ;2
        bne     _L77ED     ;2+
        jsr     _L7831     ;6
_L77A4  lda     $E1        ;3
        and     #$10       ;2
        beq     _L77B8     ;2+
        ldx     #$00       ;2
        stx     L7C2C      ;4
        lda     $F6        ;3
        and     #$20       ;2
        bne     _L7806     ;3+
        jsr     _L783E     ;6
_L77B8  ldx     $E0        ;3
        inx                ;2
_L77BB  cpx     #$01       ;2
        bne     _L774C     ;2+
        lda     $E3        ;3
        sta     L7BC9      ;4
        lda     #$00       ;2
        rts                ;6

_L77C7  lda     L76A5      ;4
        cmp     #$0B       ;2
        beq     _L77DA     ;2+
        cmp     #$0C       ;2
        beq     _L77DA     ;2+
        lda     $E3        ;3
        sta     L7BC9      ;4
        lda     #$FF       ;2
        rts                ;6

_L77DA  jsr     L7887      ;6
        jmp     _L7787     ;3

        .byte   $A5
        .byte   $E3
        .byte   $8D
        .byte   $C9
        .byte   $7B
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $2C
        .byte   $7C
        .byte   $A9
        .byte   $FF
        .byte   $60

_L77ED  jsr     L786C      ;6
        jsr     L786C      ;6
        jsr     L786C      ;6
        jsr     L76A6      ;6
        lda     #$06       ;2
        sta     L750C      ;4
        lda     #$00       ;2
        sta     L7C2C      ;4
        lda     #$FF       ;2
        rts                ;6

_L7806  jsr     L785C      ;6
        jsr     L785C      ;6
        jsr     L785C      ;6
        jsr     L76A6      ;6
        lda     #$06       ;2
        sta     L750C      ;4
        lda     #$00       ;2
        sta     L7C2C      ;4
        lda     #$FF       ;2
        rts                ;6

_L781F  lda     $E3        ;3
        sta     L7BC9      ;4
        lda     #$2F       ;2
        sta     LADA6      ;4
        lda     #$00       ;2
        sta     L7430      ;4
        lda     #$FF       ;2
        rts                ;6

_L7831  lda     L76A4      ;4
        beq     _L783B     ;2+
        lda     $D0        ;3
        bne     _L783B     ;2+
        rts                ;6

_L783B  jmp     L785C      ;3

_L783E  lda     L76A4      ;4
        beq     _L7848     ;2+
        lda     $D0        ;3
        bne     _L7848     ;2+
        rts                ;6

_L7848  jmp     L786C      ;3

L784B   lda     $F6        ;3
        and     #$40       ;2
        beq     _L785B     ;2+
        lda     #$2F       ;2
        sta     LADA6      ;4
        lda     #$00       ;2
        sta     L7430      ;4
_L785B  rts                ;6

L785C   ldx     #$00       ;2
        stx     L7BC9      ;4
        lda     LADA4      ;4
        cmp     #$08       ;2
        bcc     _L786B     ;2+
        dec     LADA4      ;6
_L786B  rts                ;6

L786C   ldx     #$01       ;2
        stx     L7BC9      ;4
        lda     LADA4      ;4
        cmp     #$AF       ;2
        bcs     _L787B     ;2+
        inc     LADA4      ;6
_L787B  rts                ;6

L787C   lda     LADA5      ;4
        cmp     #$08       ;2
        bcc     _L7886     ;2+
        dec     LADA5      ;6
_L7886  rts                ;6

L7887   lda     LADA5      ;4
        cmp     #$DF       ;2
        bcs     _L7891     ;2+
        inc     LADA5      ;6
_L7891  rts                ;6

L7892   .byte   $B4
L7893   .byte   $78
        .byte   $B5
        .byte   $78
        .byte   $F2
        .byte   $78
        .byte   $2F
        .byte   $79
        .byte   $74
        .byte   $79
        .byte   $B9
        .byte   $79
        .byte   $F6
        .byte   $79
        .byte   $33
        .byte   $7A
        .byte   $64
        .byte   $7A
        .byte   $AE
        .byte   $7A
        .byte   $8D
        .byte   $7A
        .byte   $CF
        .byte   $7A
        .byte   $0C
        .byte   $7B
        .byte   $49
        .byte   $7B
        .byte   $56
        .byte   $7B
        .byte   $94
        .byte   $7B
        .byte   $63
        .byte   $7B
        .byte   $FF
        .byte   $25
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $25
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $19
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $19
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $25
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $26
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $11
        .byte   $01
        .byte   $01
        .byte   $1A
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $1A
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $2F
        .byte   $41
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $81
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $30
        .byte   $41
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $23
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $25
        .byte   $A1
        .byte   $00
        .byte   $00
        .byte   $25
        .byte   $21
        .byte   $00
        .byte   $00
        .byte   $27
        .byte   $24
        .byte   $01
        .byte   $00
        .byte   $27
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $27
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $27
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $27
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $27
        .byte   $29
        .byte   $00
        .byte   $00
        .byte   $25
        .byte   $14
        .byte   $01
        .byte   $00
        .byte   $25
        .byte   $61
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $26
        .byte   $91
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $28
        .byte   $11
        .byte   $00
        .byte   $01
        .byte   $28
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $28
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $28
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $28
        .byte   $19
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $51
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $2D
        .byte   $2C
        .byte   $01
        .byte   $00
        .byte   $2D
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $2D
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $14
        .byte   $01
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $2E
        .byte   $09
        .byte   $00
        .byte   $01
        .byte   $2E
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $2E
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $26
        .byte   $22
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $61
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $26
        .byte   $12
        .byte   $00
        .byte   $00
        .byte   $26
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $51
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $22
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $22
        .byte   $21
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $21
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $11
        .byte   $00
        .byte   $00
        .byte   $FE
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $26
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $26
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $38
        .byte   $01
        .byte   $00
        .byte   $01
        .byte   $FF
        .byte   $25
        .byte   $21
        .byte   $01
        .byte   $00
        .byte   $25
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $25
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $37
        .byte   $01
        .byte   $00
        .byte   $00
        .byte   $21
        .byte   $11
        .byte   $01
        .byte   $00
        .byte   $FF
L7BC9   .byte   $00
L7BCA   .byte   $FF
L7BCB   .byte   $FF
L7BCC   .byte   $FF
L7BCD   .byte   $FF
L7BCE   .byte   $FF

L7BCF   lda     L7248      ;4
        cmp     #$01       ;2
        beq     _L7BE1     ;2+
        cmp     #$02       ;2
        beq     _L7BEC     ;2+
        cmp     #$03       ;2
        beq     _L7BF7     ;2+
        jmp     L7C2E      ;3

_L7BE1  lda     #$FB       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        jmp     _L7BFF     ;3

_L7BEC  lda     #$FD       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
        jmp     _L7BFF     ;3

_L7BF7  lda     #$F7       ;2
        sta     $FD30      ;4
        sta     $FF08      ;4
_L7BFF  lda     $FF08      ;4
        tax                ;2
        and     #$01       ;2
        sta     L7BCA      ;4
        txa                ;2
        and     #$02       ;2
        sta     L7BCB      ;4
        txa                ;2
        and     #$04       ;2
        sta     L7BCC      ;4
        txa                ;2
        and     #$08       ;2
        sta     L7BCD      ;4
        txa                ;2
        and     #$C0       ;2
        cmp     #$C0       ;2
        beq     _L7C27     ;2+
        lda     #$00       ;2
        sta     L7BCE      ;4
        rts                ;6

_L7C27  sta     L7BCE      ;4
        rts                ;6

L7C2B   .byte   $00
L7C2C   .byte   $00
L7C2D   .byte   $00

L7C2E   lda     #$FF       ;2
        sta     L7BCB      ;4
        sta     L7BCA      ;4
        sta     L7BCC      ;4
        sta     L7BCD      ;4
        sta     L7BCE      ;4
        lda     L724D      ;4
        cmp     #$18       ;2
        bne     _L7C50     ;2+
        lda     L724E      ;4
        bne     _L7C50     ;2+
        lda     #$00       ;2
        sta     L7BCB      ;4
_L7C50  lda     LADA4      ;4
        ldx     #$00       ;2
        cmp     LAD84      ;4
        bcs     _L7C5C     ;2+
        ldx     #$01       ;2
_L7C5C  stx     L7BC9      ;4
        lda     L7C2B      ;4
        beq     _L7C6A     ;2+
        dec     L7C2B      ;6
        jmp     L7D97      ;3

_L7C6A  lda     LAD85      ;4
        clc                ;2
        adc     #$0F       ;2
        cmp     LADA5      ;4
        bcs     _L7C85     ;2+
        lda     #$00       ;2
        sta     L7C2C      ;4
        jsr     L7D97      ;6
        lda     L7C2D      ;4
        sta     $D0        ;3
        jmp     L7D14      ;3

_L7C85  lda     L7C2C      ;4
        bne     L7CBE      ;2+
        lda     LADA4      ;4
        cmp     #$98       ;2
        bcc     _L7C96     ;2+
        ldx     #$00       ;2
        stx     L7BC9      ;4
_L7C96  cmp     #$20       ;2
        bcs     _L7C9F     ;2+
        ldx     #$01       ;2
        stx     L7BC9      ;4
_L7C9F  lda     L7BC9      ;4
        sta     L7C2D      ;4
        jsr     $FA4A      ;6
        tax                ;2
        and     #$1F       ;2
        clc                ;2
L7CAC   adc     #$14       ;2
        sta     L7C2C      ;4
        txa                ;2
        and     #$0F       ;2
        bne     _L7CBB     ;2+
        lda     #$00       ;2
        sta     L7BCB      ;4
_L7CBB  jmp     L7CC1      ;3

L7CBE   dec     L7C2C      ;6
L7CC1   ldy     #$00       ;2
        ldx     L7C2D      ;4
        beq     _L7CD2     ;2+
        sty     L7BCD      ;4
        lda     #$01       ;2
        sta     $D0        ;3
        jmp     _L7CD9     ;3

_L7CD2  sty     L7BCC      ;4
        lda     #$00       ;2
        sta     $D0        ;3
_L7CD9  lda     #$01       ;2
        ldx     #$07       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     _L7CF8     ;2+
        lda     #$01       ;2
        sta     L7C2D      ;4
        jsr     $FA4A      ;6
        and     #$0F       ;2
        clc                ;2
        adc     L7CAC+1    ;4
        sta     L7C2C      ;4
        jmp     L7D14      ;3

_L7CF8  lda     #$01       ;2
        ldx     #$04       ;2
        jsr     LA93E      ;6
        and     #$20       ;2
        beq     L7D14      ;2+
        lda     #$00       ;2
        sta     L7C2D      ;4
        jsr     $FA4A      ;6
        and     #$0F       ;2
        clc                ;2
        adc     L7CAC+1    ;4
        sta     L7C2C      ;4
L7D14   lda     LAD85      ;4
        sec                ;2
        sbc     LADA5      ;4
        cmp     #$14       ;2
        bcc     _L7D29     ;2+
        cmp     #$EB       ;2
        bcs     _L7D29     ;2+
        lda     #$E0       ;2
        sta     L7CAC+1    ;4
        rts                ;6

_L7D29  lda     #$14       ;2
        sta     L7CAC+1    ;4
        ldx     L60DF      ;4
        cpx     #$08       ;2
        bcc     _L7D37     ;2+
        ldx     #$08       ;2
_L7D37  jsr     $FA4A      ;6
        and     L7D8E,x    ;4+
        bne     _L7D83     ;2+
        lda     LADA4      ;4
        ldy     L7C2D      ;4
        ldx     LAD84      ;4
        jsr     L7DB4      ;6
        sta     L136A      ;4
        cmp     #$02       ;2
        beq     _L7D57     ;2+
        cmp     #$01       ;2
        beq     _L7D5D     ;2+
        rts                ;6

_L7D57  lda     #$00       ;2
        sta     L7BCE      ;4
        rts                ;6

_L7D5D  lda     LAD86      ;4
        cmp     #$13       ;2
        beq     _L7D83     ;2+
        cmp     #$12       ;2
        beq     _L7D83     ;2+
        jsr     $FA4A      ;6
        tax                ;2
        and     #$03       ;2
        beq     _L7D84     ;2+
        lda     #$00       ;2
        sta     L7BCE      ;4
        lda     #$FF       ;2
        sta     L7BCC      ;4
        sta     L7BCD      ;4
        sta     L7BCB      ;4
        sta     L7BCA      ;4
_L7D83  rts                ;6

_L7D84  txa                ;2
L7D85   and     #$0F       ;2
        clc                ;2
        adc     #$14       ;2
        sta     L7CAC+1    ;4
        rts                ;6

L7D8E   .byte   $0F
        .byte   $0F
        .byte   $07
        .byte   $07
        .byte   $03
        .byte   $03
        .byte   $01
        .byte   $00
        .byte   $00

L7D97   lda     $F6        ;3
        and     #$02       ;2
        beq     _L7DB3     ;2+
        lda     LADA5      ;4
        cmp     #$B8       ;2
        bcc     _L7DAA     ;2+
        lda     #$00       ;2
        sta     L7BCA      ;4
        rts                ;6

_L7DAA  cmp     #$30       ;2
        bcs     _L7DB3     ;2+
        lda     #$00       ;2
        sta     L7BCB      ;4
_L7DB3  rts                ;6

L7DB4   sty     $D3        ;3
        stx     $D0        ;3
        sta     $D1        ;3
        cmp     $D0        ;3
        bcs     _L7DCC     ;2+
        lda     $D3        ;3
        beq     _L7DE8     ;2+
        lda     $D0        ;3
        sec                ;2
        sbc     $D1        ;3
        sta     $D2        ;3
        jmp     _L7DD7     ;3

_L7DCC  lda     $D3        ;3
        bne     _L7DE8     ;2+
        lda     $D1        ;3
        sec                ;2
        sbc     $D0        ;3
        sta     $D2        ;3
_L7DD7  lda     $D2        ;3
        cmp     #$16       ;2
        bcs     _L7DE8     ;2+
        cmp     #$05       ;2
        bcc     _L7DE8     ;2+
        cmp     #$0A       ;2
        bcc     _L7DEB     ;2+
        lda     #$02       ;2
        rts                ;6

_L7DE8  lda     #$00       ;2
        rts                ;6

_L7DEB  lda     #$01       ;2
        rts                ;6

        .byte   $00
L7DEF   .byte   $00
L7DF0   .byte   $00
L7DF1   .byte   $00
L7DF2   .byte   $00
L7DF3   .byte   $00
L7DF4   .byte   $00

L7DF5   lda     L7DF0      ;4
        bne     _L7E08     ;3+
        lda     #$16       ;2
        sta     LADC6      ;4
        lda     #$00       ;2
        sta     LADC4      ;4
        sta     LADC5      ;4
        rts                ;6

_L7E08  lda     L7DF4      ;4
        cmp     #$FF       ;2
        beq     _L7E1D     ;2+
        lda     L7DF3      ;4
        clc                ;2
        adc     #$01       ;2
        bcc     _L7E1A     ;2+
        inc     L7DF4      ;6
_L7E1A  sta     L7DF3      ;4
_L7E1D  lda     L7F85      ;4
        bne     _L7E29     ;2+
        jsr     L80A6      ;6
        cmp     #$FF       ;2
        bne     _L7E2C     ;2+
_L7E29  jsr     L7F86      ;6
_L7E2C  jsr     _L7EB9     ;6
        lda     L7F85      ;4
        beq     _L7E3E     ;2+
        lda     #$00       ;2
        sta     L8745      ;4
        lda     #$14       ;2
        sta     L87B5      ;4
_L7E3E  lda     $F4        ;3
        tax                ;2
        and     #$10       ;2
        beq     _L7E48     ;2+
        jmp     _L7E7E     ;3

_L7E48  txa                ;2
        and     #$02       ;2
        beq     _L7E5E     ;2+
        jsr     _L7E95     ;6
        lda     LADC5      ;4
        cmp     #$C7       ;2
        bcs     _L7E7E     ;2+
        cmp     #$21       ;2
        bcc     _L7E7E     ;2+
        lda     $F4        ;3
        tax                ;2
_L7E5E  txa                ;2
        and     #$04       ;2
        beq     _L7E66     ;2+
        jmp     _L7E79     ;3

_L7E66  lda     $F5        ;3
        tax                ;2
        and     #$04       ;2
        beq     _L7E70     ;2+
        jmp     _L7E79     ;3

_L7E70  txa                ;2
        and     #$01       ;2
        beq     _L7E78     ;2+
        jmp     _L7E8C     ;3

_L7E78  rts                ;6

_L7E79  lda     #$04       ;2
        jsr     $0200      ;6
_L7E7E  lda     #$00       ;2
        sta     L7DF0      ;4
        jsr     $FA4A      ;6
        and     #$03       ;2
        sta     LBB3E      ;4
        rts                ;6

_L7E8C  lda     L60E5      ;4
        ora     #$40       ;2
        sta     L60E5      ;4
        rts                ;6

_L7E95  lda     LADC6      ;4
        cmp     #$31       ;2
        beq     _L7EA1     ;2+
        cmp     #$32       ;2
        beq     _L7EA1     ;2+
        rts                ;6

_L7EA1  lda     LC7B5      ;4
        cmp     #$01       ;2
        beq     _L7EAD     ;2+
        cmp     #$02       ;2
        beq     _L7EB3     ;2+
        rts                ;6

_L7EAD  jsr     L83CF      ;6
        jmp     L83CF      ;3

_L7EB3  jsr     L83DA      ;6
        jmp     L83DA      ;3

_L7EB9  lda     L7DF2      ;4
        beq     _L7ECE     ;2+
        cmp     #$0F       ;2
        bcs     _L7ECA     ;2+
        lda     L7DF1      ;4
        bne     _L7ECA     ;2+
        jmp     _L7E7E     ;3

_L7ECA  dec     L7DF2      ;6
        rts                ;6

_L7ECE  lda     L7F85      ;4
        sta     $07        ;3
        lda     L7249      ;4
        clc                ;2
        adc     L73EC      ;4
        beq     _L7EEF     ;2+
        ldx     #$02       ;2
        ldy     #$01       ;2
        lda     L73EC      ;4
        sta     $06        ;3
        lda     L7BC9      ;4
        jsr     L658E      ;6
        and     #$7F       ;2
        bne     _L7F0E     ;3+
_L7EEF  lda     L60DA      ;4
        clc                ;2
        adc     L6923      ;4
        beq     _L7F0D     ;3+
        ldx     #$02       ;2
        ldy     #$00       ;2
        lda     L6923      ;4
        sta     $06        ;3
        lda     L70EA      ;4
        jsr     L658E      ;6
        sta     $0F        ;3
        and     #$7F       ;2
        bne     _L7F21     ;2+
_L7F0D  rts                ;6

_L7F0E  tax                ;2
        lda     L7F85      ;4
        and     L73EC      ;4
        beq     _L7F18     ;2+
        rts                ;6

_L7F18  txa                ;2
        ldx     #$FF       ;2
        stx     L76A4      ;4
        jmp     _L7F44     ;3

_L7F21  tax                ;2
        lda     L7F85      ;4
        and     L6923      ;4
        beq     _L7F2B     ;2+
        rts                ;6

_L7F2B  txa                ;2
        ldx     #$FF       ;2
        stx     L6C25      ;4
        jsr     L6558      ;6
        ldx     L7DF1      ;4
        cpx     #$01       ;2
        bne     _L7F44     ;2+
        sta     $58        ;3
        lda     #$04       ;2
        jsr     LD6F3      ;6
        lda     $58        ;3
_L7F44  sta     $58        ;3
        lda     #$85       ;2
        jsr     $0200      ;6
        lda     $58        ;3
        dec     L7DF1      ;6
        ldx     #$00       ;2
        stx     L8744      ;4
        ldx     #$23       ;2
        stx     L7DF2      ;4
        cmp     #$01       ;2
        beq     _L7F6C     ;2+
        cmp     #$02       ;2
        beq     _L7F71     ;2+
        cmp     #$05       ;2
        beq     _L7F76     ;2+
        ldx     #$05       ;2
        stx     L7DF2      ;4
        rts                ;6

_L7F6C  lda     #$0B       ;2
        jmp     L823C      ;3

_L7F71  lda     #$0C       ;2
        jmp     L823C      ;3

_L7F76  lda     L86E2      ;4
        bne     _L7F80     ;2+
        lda     #$0D       ;2
        jmp     L823C      ;3

_L7F80  lda     #$0E       ;2
        jmp     L823C      ;3

L7F85   .byte   $00

L7F86   lda     #$02       ;2
        ldx     #$01       ;2
        jsr     LA93E      ;6
        sta     $F4        ;3
        sta     $D1        ;3
        and     #$40       ;2
        beq     _L7F98     ;2+
        jmp     L7FC2      ;3

_L7F98  lda     #$02       ;2
        ldx     #$00       ;2
        jsr     LA93E      ;6
        sta     $F5        ;3
        and     #$C0       ;2
        bne     L7FC2      ;2+
        ldx     #$17       ;2
        lda     L86E2      ;4
        beq     _L7FAE     ;2+
        ldx     #$18       ;2
_L7FAE  stx     LADC6      ;4
        jsr     L83DA      ;6
        lda     #$01       ;2
        sta     L7F85      ;4
        lda     LADC4      ;4
        and     #$FE       ;2
        sta     LADC4      ;4
        rts                ;6

L7FC2   lda     #$00       ;2
        sta     L7F85      ;4
        rts                ;6

        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $AD
        .byte   $C9
        .byte   $7F
        .byte   $49
        .byte   $01
        .byte   $8D
        .byte   $C9
        .byte   $7F
        .byte   $D0
        .byte   $05
        .byte   $A9
        .byte   $31
        .byte   $4C
        .byte   $DD
        .byte   $7F
        .byte   $A9
        .byte   $32
        .byte   $8D
        .byte   $C6
        .byte   $AD
        .byte   $60
        .byte   $AD
        .byte   $C8
        .byte   $7F
        .byte   $18
        .byte   $69
        .byte   $01
        .byte   $C9
        .byte   $06
        .byte   $90
        .byte   $19
        .byte   $20
        .byte   $CF
        .byte   $83
        .byte   $20
        .byte   $CF
        .byte   $83
        .byte   $20
        .byte   $CF
        .byte   $83
        .byte   $A9
        .byte   $02
        .byte   $A2
        .byte   $02
        .byte   $20
        .byte   $3E
        .byte   $A9
        .byte   $29
        .byte   $20
        .byte   $D0
        .byte   $09
        .byte   $20
        .byte   $4C
        .byte   $19
        .byte   $80
        .byte   $4C
        .byte   $0A
        .byte   $80
L8006   .byte   $00
        .text   "cbm L"
        .byte   $FF
        .byte   $20
        .byte   $D8
        .byte   $8A
        .byte   $85
        .byte   $13
        .text   " IGxl"
        .byte   $7E
        .byte   $86
        .byte   $20
        .byte   $17
        .byte   $81
        .byte   $20
        .byte   $2E
        .byte   $80
        .byte   $20
        .byte   $C2
        .byte   $80
        .byte   $20
        .byte   $F4
        .byte   $FC
        .byte   $A2
        .byte   $FB
        .byte   $9A
        .byte   $D0
        .byte   $EC
        .byte   $71
        .byte   $98
        .byte   $71
        .byte   $94
        .byte   $A9
        .byte   $4C
        .byte   $85
        .byte   $54
        .byte   $8D
        .byte   $00
        .byte   $05
        .byte   $A9
        .byte   $1C
        .byte   $A0
        .byte   $99
        .byte   $8D
        .byte   $01
        .byte   $05
        .byte   $8C
        .byte   $02
        .byte   $05
        .byte   $A2
        .byte   $03
        .byte   $BD
        .byte   $2A
        .byte   $80
        .byte   $9D
        .byte   $F2
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $A2
        .byte   $32
        .byte   $BD
        .byte   $22
        .byte   $81
        .byte   $9D
        .byte   $72
        .byte   $04
        .byte   $CA
        .byte   $D0
        .byte   $F7
        .byte   $86
        .byte   $68
        .byte   $86
        .byte   $13
        .byte   $86
        .byte   $18
        .byte   $8E
        .byte   $EB
        .byte   $02
        .byte   $8E
        .byte   $00
        .byte   $10
        .byte   $8A
        .byte   $A2
        .byte   $03
        .byte   $95
        .byte   $72
        .byte   $9D
        .byte   $E5
        .byte   $02
        .byte   $CA
        .byte   $D0
        .byte   $F8
        .byte   $EA
        .byte   $8E
        .byte   $03
        .byte   $05
        .byte   $E8
        .byte   $8E
        .byte   $FD
        .byte   $01
        .byte   $8E
        .byte   $FC
        .byte   $01
        .byte   $AE
        .byte   $3B
        .byte   $05
        .byte   $86
        .byte   $86
        .byte   $A2
        .byte   $36
        .byte   $86
        .byte   $85
        .byte   $A2
        .byte   $19
        .byte   $86
        .byte   $16
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $10
        .byte   $86
        .byte   $2B
        .byte   $84
        .byte   $2C
        .byte   $A2
        .byte   $05
        .byte   $86
        .byte   $22
        .byte   $A9
        .byte   $D0
        .byte   $8D
        .byte   $E4
        .byte   $02
        .byte   $A2
        .byte   $02
        .byte   $BD
        .text   "2",$05,$95,"6",$95,"2JP"
        .byte   $F6

L80A1   ldy     #$00       ;2
L80A3   lda     L8147,y    ;4+
L80A6   sta     $04A5,x    ;5
        inx                ;2
        iny                ;2
        cpy     #$0B       ;2
        bcc     L80A3      ;2+
        ldy     $22        ;3
        lda     _L80BC,y   ;4+
        sta     $049F,x    ;5
        dec     $22        ;5
        bpl     L80A1      ;2+
        rts                ;6

_L80BC  .byte   $64
        .byte   $5F
        .byte   $6F
        .byte   $24
        .byte   $22
        .byte   $3B
        .byte   $A5
        .byte   $2B
        .byte   $A4
        .byte   $2C
        .byte   $20
        .byte   $23
        .byte   $89
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   $93,$0D," commodore basic v3.5 "
        .byte   $00
        .byte   $A5
        .byte   $37
        .byte   $38
        .byte   $E5
        .byte   $2B
        .byte   $AA
        .byte   $A5
        .byte   $38
        .byte   $E5
        .byte   $2C
        .byte   $20
        .byte   $5F
        .byte   $A4
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   " bytes free",$0D
        .byte   $00
        .byte   $4C
        .byte   $7B
        .byte   $8A
        .byte   $86
        .byte   $86
        .byte   $12
        .byte   $87
        .byte   $56
        .byte   $89
        .byte   $6E
        .byte   $8B
        .byte   $D6
        .byte   $8B
        .byte   $17
        .byte   $94
        .byte   $6A
        .byte   $89
        .byte   $88
        .byte   $8B
        .byte   $8B
        .byte   $8C
        .byte   $A2
        .byte   $11
        .byte   $BD
        .byte   $05
        .byte   $81
        .byte   $9D
        .byte   $00
        .byte   $03
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $60
        .byte   $E6
        .byte   $3B
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $3C
        .byte   $78
        .byte   $8D
        .byte   $3F
        .byte   $FF
        .byte   $A0
        .byte   $00
        .byte   $B1
        .byte   $3B
        .byte   $8D
        .byte   $3E
        .byte   $FF
        .byte   $58
        .byte   $C9
        .byte   $3A
        .byte   $B0
        .byte   $0A
        .byte   $C9
        .byte   $20
        .byte   $F0
        .byte   $E6
        .byte   $38
        .byte   $E9
        .byte   $30
        .byte   $38
        .byte   $E9
        .byte   $D0
        .byte   $60
        .byte   $8D
        .byte   $9C
        .byte   $04
L8147   .byte   $78
        .byte   $8D
        .byte   $3F
        .byte   $FF
        .byte   $B1
        .byte   $00
        .byte   $8D
        .byte   $3E
        .byte   $FF
        .byte   $58
        .byte   $60
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $A9
        .byte   $43
        .byte   $D0
        .byte   $32
        .byte   $A9
        .byte   $4E
        .byte   $D0
        .byte   $2E
        .byte   $A9
        .byte   $14
        .byte   $D0
        .byte   $2A
        .byte   $A9
        .byte   $47
        .byte   $D0
        .byte   $26

L8165   lda     #$4E       ;2
        bne     _L818B     ;3

        .byte   $A9
        .byte   $5C
        .byte   $D0
        .byte   $1E
        .byte   $A9
        .byte   $5F
        .byte   $D0
        .byte   $1A
        .byte   $A9
        .byte   $3D
        .byte   $D0
        .byte   $16
        .byte   $A9
        .byte   $57
        .byte   $D0
        .byte   $12
        .byte   $A9
        .byte   $59
        .byte   $D0
        .byte   $0E
        .byte   $A9
        .byte   $62
        .byte   $D0
        .byte   $0A
        .byte   $A9
        .byte   $50
        .byte   $D0
        .byte   $06
        .byte   $A9
        .byte   $6C
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $5A

_L818B  jmp     $0494      ;3

        .text   "enDfoRnexTdatAinput"
        .byte   $A3
        .text   "inpuTdiMreaDleTgotOruNiFrestorEgosuBreturNreMstoPoNwaiTloaDsav"
        .text   "EverifYdeFpokEprint"
        .byte   $A3
        .text   "prinTconTlisTclRcmDsySopeNclosEgeTneWtab"
        .byte   $A8
        .text   "tOfNspc"
        .byte   $A8
        .text   "theNnoTsteP"
        .byte   $AB
        .byte   $AD
        .byte   $AA
        .byte   $AF
        .byte   $DE
        .byte   $41
        .byte   $4E

L8237   cpy     $4F        ;3
        .byte   $D2
        .byte   $BE
        .byte   $BD

L823C   ldy     L4753,x    ;4+
        dec     L4E49      ;6
        .text   "TabSusRfrEpoSsqRrnDloGexPcoSsiNtaNatNpeeKleNstr"
        .byte   $A4
        .text   "vaLasCchr"
        .byte   $A4
        .text   "left"
        .byte   $A4
        .text   "right"
        .byte   $A4
        .byte   $4D
        .byte   $49
        .byte   $44
        .byte   $A4
        .text   "gOrgRrclRrluMjoYrdoTdeChex"
        .byte   $A4
        .byte   $45
        .byte   $52
        .byte   $52
        .byte   $A4
        .text   "instRelsEresumEtraPtroNtrofFsounDvoLautOpudeFgraphiCpainTchaRb"
        .text   "oXcirclEgshapEsshapEdraWlocatEcoloRscnclRscalEhelPdOlooPexiTdi"
        .text   "rectorYdsavEdloaDheadeRscratcHcollecTcopYrenamEbackuPdeletEren"
        .text   "umbeRkeYmonitoRusinGuntiLwhilE"
        .byte   $00
        .byte   $D9
        .byte   $8C
        .byte   $C9
        .byte   $AD
        .byte   $93
        .byte   $92
        .byte   $AF
        .byte   $8D
        .byte   $ED
        .byte   $90
        .byte   $07
        .byte   $91
        .byte   $9A
        .byte   $96
        .byte   $4E
        .byte   $91
        .byte   $7B
        .byte   $8E
        .byte   $4C
        .byte   $8D
        .byte   $BB
        .byte   $8B
        .byte   $E0
        .byte   $8D
        .byte   $99
        .byte   $8C
        .byte   $2B
        .byte   $8D
        .byte   $82
        .byte   $8D
        .byte   $0A
        .byte   $8E
        .byte   $D7
        .byte   $8C
        .byte   $1A
        .byte   $8E
        .byte   $69
        .byte   $9E
        .byte   $F2
        .byte   $A7
        .byte   $DD
        .byte   $A7
        .byte   $EF
        .byte   $A7
        .byte   $9C
        .byte   $9A
        .byte   $11
        .byte   $9E
        .byte   $DF
        .byte   $8F
        .byte   $FF
        .byte   $8F
        .byte   $02
        .byte   $8D
        .byte   $FE
        .byte   $8A
        .byte   $97
        .byte   $8A
        .byte   $E5
        .byte   $8F
        .byte   $B4
        .byte   $A7
        .byte   $4C
        .byte   $A8
        .byte   $59
        .byte   $A8
        .byte   $B7
        .byte   $90
        .byte   $78
        .byte   $8A
        .byte   $0A
        .byte   $8E
        .byte   $3F
        .byte   $B4
        .byte   $2A
        .byte   $B4

L83CF   eor     ($B6),y    ;5+
        .byte   $54
        .byte   $B6
        .byte   $48
        .byte   $B8
        .byte   $BC
        .byte   $B8
        .byte   $CC
        .byte   $B6
        .byte   $43

L83DA   lda     $C2,x      ;4
        cmp     $D0        ;3
        clv                ;2
        .byte   $D3
        .byte   $B9
        .byte   $E1
        .byte   $BA
        .byte   $1D
        .byte   $C0
        .byte   $34
        .byte   $BD
        .byte   $28
        .byte   $BE
        .byte   $D8
        .byte   $C4
        .byte   $0E
        .byte   $C5
        .byte   $19
        .byte   $C5
        .byte   $66
        .byte   $C5
        .byte   $B7
        .byte   $C5
        .byte   $E7
        .byte   $B6
        .byte   $56
        .byte   $B5
        .byte   $02
        .byte   $B6
        .byte   $AB
        .byte   $B5
        .byte   $BB
        .text   "H@IpI"
        .byte   $67
        .text   "I",$9B,"IKIYI"
        .byte   $F3
        .byte   $C9
        .byte   $FF
        .byte   $C9
        .byte   $59
        .byte   $AE
        .byte   $8E
        .byte   $AB
        .byte   $28
        .byte   $B7
        .byte   $51
        .byte   $FF
        .byte   $BE
        .byte   $A2
        .byte   $58
        .byte   $A3
        .byte   $DD
        .byte   $A2
        .byte   $00
        .byte   $05
        .byte   $62
        .byte   $9A
        .byte   $7D
        .byte   $9A
        .byte   $E4
        .byte   $A5
        .byte   $07
        .byte   $A7
        .byte   $1E
        .byte   $A0
        .byte   $60
        .byte   $A6
        .byte   $70
        .byte   $AA
        .byte   $77
        .byte   $AA
        .byte   $C0
        .byte   $AA
        .byte   $1A
        .byte   $AB
        .byte   $FA
        .byte   $9D
        .byte   $61
        .byte   $9D
        .byte   $66
        .byte   $9B
        .byte   $93
        .byte   $9D
        .byte   $70
        .byte   $9D
        .byte   $BB
        .byte   $9C
        .byte   $CF
        .byte   $9C
        .byte   $03
        .byte   $9D
        .byte   $15
        .byte   $9D
        .byte   $79
        .byte   $BF
        .byte   $85
        .byte   $BF
        .byte   $87
        .byte   $BF
        .byte   $C1
        .byte   $BF
        .byte   $FD
        .byte   $BF
        .byte   $1B
        .byte   $9E
        .byte   $07
        .byte   $B5
        .byte   $BE
        .byte   $B4
L8453   .byte   $79
L8454   .byte   $9D
L8455   .byte   $9E
        .byte   $79
        .byte   $86
        .byte   $9E
        .byte   $7B
        .byte   $7A
        .byte   $A0
        .byte   $7B
        .byte   $96
        .byte   $A1
        .byte   $7F
        .byte   $ED
        .byte   $A5
        .byte   $50
        .byte   $FA
        .byte   $95
        .byte   $46
        .byte   $F7
        .byte   $95
        .byte   $7D
        .byte   $26
        .byte   $A6
        .byte   $5A
        .byte   $64
        .byte   $94
        .byte   $64
        .text   "'",$96,"too many fileSfile opeNfile not opeNfile not founDdevi"
        .text   "ce not presenTnot input filEnot output filEmissing file namEil"
        .text   "legal device numbeRnext without foRsyntaXreturn without gosuBo"
        .text   "ut of datAillegal quantitYoverfloWout of memorYundef'd stateme"
        .text   "nTbad subscripTredim'd arraYdivision by zerOillegal direcTtype"
        .text   " mismatcHstring too lonGfile datAformula too compleXcan't cont"
        .text   "inuEundef'd functioNverifYloaDbreak"
        .byte   $00
        .byte   $A0
        .text   "can't resumEloop not founDloop without dOdirect mode onlYno gr"
        .text   "aphics areAbad disK"
        .byte   $AA
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $71
        .byte   $85
        .byte   $24
        .byte   $A9
        .byte   $84
        .byte   $85
        .text   "%J0",$1C
        .byte   $B1
        .byte   $24
        .byte   $48
        .byte   $E6
        .byte   $24
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $25
        .byte   $68
        .byte   $10
        .byte   $F4
        .byte   $30
        .byte   $EF
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   $0D,$0A,"ready.",$0D,$0A
        .byte   $00
        .byte   $60
        .byte   $A2
        .byte   $80
        .byte   $2C

L8681   ldx     #$10       ;2
L8683   jmp     ($0300)    ;5

        .byte   $8A
        .byte   $30
        .byte   $7A
        .byte   $8E
        .byte   $EF
        .byte   $04
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $35
        .byte   $A0
        .byte   $01
        .byte   $B9
        .byte   $39
        .byte   $00
        .byte   $99
        .byte   $F0
        .byte   $04
        .byte   $B9
        .byte   $5B
        .byte   $02
        .byte   $99
        .byte   $F5
        .byte   $04
        .byte   $88
        .byte   $10
        .byte   $F1
        .byte   $E0
        .byte   $11
        .byte   $F0
        .byte   $20
        .byte   $AC
        .byte   $F3
        .byte   $04
        .byte   $C8
        .byte   $F0
        .byte   $1A
        .byte   $88
        .byte   $84
        .byte   $15
        .byte   $8C
        .byte   $F4
        .byte   $04
        .byte   $AC
        .byte   $F2
        .byte   $04
        .byte   $84
        .byte   $14
        .byte   $A2
        .byte   $FF
        .byte   $8E
        .byte   $F3
        .byte   $04
        .byte   $AE
        .byte   $F7
        .byte   $04
        .byte   $9A
        .byte   $20
        .byte   $69
        .byte   $8D
        .byte   $4C
        .byte   $DC
        .byte   $8B
        .byte   $CA
        .byte   $8A
        .byte   $48
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $83
        .byte   $20
        .byte   $C9
        .byte   $C7
        .byte   $68
        .byte   $20
        .byte   $53
        .byte   $86
        .byte   $20
        .byte   $CC
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $13
        .text   " >",$90," "
        .byte   $B0
        .byte   $90
        .byte   $A0
        .byte   $00
L86E2   .byte   $B1
        .byte   $24
        .byte   $48
        .byte   $29
        .byte   $7F
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $C8
        .byte   $68
        .byte   $10
        .byte   $F4
        .byte   $20
        .byte   $D8
        .byte   $8A
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   " error"
        .byte   $00
        .byte   $A4
        .byte   $3A
        .byte   $C8
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $53
        .byte   $A4
        .byte   $20
        .byte   $6F
        .byte   $86
        .byte   $A9
        .byte   $80
        .byte   $20
        .byte   $90
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $81
        .byte   $6C
        .byte   $02
        .byte   $03
        .byte   $A2
        .byte   $FF
        .byte   $86
        .byte   $3A
        .byte   $20
        .byte   $5A
        .byte   $88
        .byte   $86
        .byte   $3B
        .byte   $84
        .byte   $3C
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $AA
        .byte   $F0
        .byte   $EC
        .byte   $90
        .byte   $09
        .byte   $20
        .byte   $53
        .byte   $89
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $4C
        .byte   $D9
        .byte   $8B
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $20
        .byte   $53
        .byte   $89
        .byte   $84
        .byte   $0B
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $90
        .byte   $4A
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $23
        .byte   $A5
        .byte   $2D
L8744   .byte   $85
L8745   .byte   $22
        .byte   $A5
        .byte   $60
        .byte   $85
        .byte   $25
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $18
        .byte   $E5
        .byte   $5F
        .byte   $49
        .byte   $FF
        .byte   $18
        .byte   $65
        .byte   $2D
        .byte   $85
        .byte   $2D
        .byte   $85
        .byte   $24
        .byte   $A5
        .byte   $2E
        .byte   $69
        .byte   $FF
        .byte   $85
        .byte   $2E
        .byte   $E5
        .byte   $60
        .byte   $AA
        .byte   $38
        .byte   $A5
        .byte   $5F
        .byte   $E5
        .byte   $2D
        .byte   $A8
        .byte   $B0
        .byte   $03
        .byte   $E8
        .byte   $C6
        .byte   $25
        .byte   $18
        .byte   $65
        .byte   $22
        .byte   $90
        .byte   $03
        .byte   $C6
        .byte   $23
        .byte   $18
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $91
        .byte   $24
        .byte   $C8
        .byte   $D0
        .byte   $F8
        .byte   $E6
        .byte   $23
        .byte   $E6
        .byte   $25
        .byte   $CA
        .byte   $D0
        .byte   $F1
        .byte   $20
        .byte   $9A
        .byte   $8A
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $8F
        .byte   $18
        .byte   $A5
        .byte   $2D
        .byte   $A4
        .byte   $2E
        .byte   $85
        .byte   $5A
        .byte   $84
        .byte   $5B
        .byte   $65
        .byte   $0B
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $18
        .byte   $69
        .byte   $04
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $58
        .byte   $84
        .byte   $59
        .byte   $20
        .byte   $C0
        .byte   $88
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $01
        .byte   $91
        .byte   $5F
        .byte   $C8
        .byte   $91
L87B5   .byte   $5F
        .byte   $C8
        .byte   $A5
        .byte   $14
        .byte   $91
        .byte   $5F
        .byte   $A5
        .byte   $15
        .byte   $C8
        .byte   $91
        .byte   $5F
        .byte   $C8
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $5F
        .byte   $85
        .byte   $5F
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $60
        .byte   $A5
        .byte   $31
        .byte   $A4
        .byte   $32
        .byte   $85
        .byte   $2D
        .byte   $84
        .byte   $2E
        .byte   $A4
        .byte   $0B
        .byte   $88
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $91
        .byte   $5F
        .byte   $88
        .byte   $10
        .byte   $F8
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $20
        .byte   $93
        .byte   $8A
        .byte   $A5
        .byte   $73
        .byte   $05
        .byte   $74
        .byte   $F0
        .byte   $2B
        .byte   $A5
        .byte   $14
        .byte   $18
        .byte   $65
        .byte   $73
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $15
        .byte   $65
        .byte   $74
        .byte   $85
        .byte   $62
        .byte   $A2
        .text   $90,"8 N"
        .byte   $A2
        .byte   $20
        .byte   $6F
        .byte   $A4
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $01
        .byte   $01
        .byte   $F0
        .byte   $06
        .byte   $9D
        .byte   $27
        .byte   $05
        .byte   $E8
        .byte   $D0
        .byte   $F5
        .byte   $A9
        .byte   $1D
        .byte   $9D
        .byte   $27
        .byte   $05
        .byte   $E8
        .byte   $86
        .byte   $EF
        .byte   $4C
        .byte   $0F
        .byte   $87
        .byte   $A5
        .byte   $2B
        .byte   $A4
        .byte   $2C
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $18
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $D0
        .byte   $06
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $F0
        .byte   $2B
        .byte   $A0
        .byte   $04
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $D0
        .byte   $FA
        .byte   $C8
        .byte   $98
        .byte   $65
        .byte   $22
        .byte   $AA
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $22
        .byte   $98
        .byte   $65
        .byte   $23
        .byte   $C8
        .byte   $91
        .byte   $22
        .byte   $86
        .byte   $22
        .byte   $85
        .byte   $23
        .byte   $90
        .byte   $D6
        .byte   $18
        .byte   $A5
        .byte   $22
        .byte   $A4
        .byte   $23
        .byte   $69
        .byte   $02
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $2D
        .byte   $84
        .byte   $2E
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $91
        .byte   $A7
        .byte   $C9
        .byte   $0D
        .byte   $F0
        .byte   $0B
        .byte   $9D
        .byte   $00
        .byte   $02
        .byte   $E8
        .byte   $E0
        .byte   $59
        .byte   $90
        .byte   $F1
        .text   "llLl1",$90," "
        .byte   $60
        .byte   $A7
        .byte   $A5
        .byte   $3D
        .byte   $C9
        .byte   $B0
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $3E
        .byte   $C9
        .byte   $07
        .byte   $F0
        .byte   $3D
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $02
        .byte   $C9
        .byte   $81
        .byte   $D0
        .byte   $1B
        .text   "Q=P3"
        .byte   $A0
        .byte   $02
        .byte   $A5
        .byte   $4A
        .byte   $C9
        .byte   $FF
        .byte   $F0
        .text   "+Q=P",$07
        .byte   $88
        .byte   $A5
        .byte   $49
        .byte   $D1
        .byte   $3D
        .byte   $F0
        .byte   $20
        .byte   $A2
        .byte   $12
        .byte   $D0
        .byte   $0E
        .byte   $B1
        .byte   $3D
        .byte   $C5
        .byte   $02
        .byte   $F0
        .byte   $16
        .byte   $A2
        .byte   $12
        .byte   $C9
        .byte   $81
        .byte   $F0
        .byte   $02
        .byte   $A2
        .byte   $05
        .byte   $8A
        .byte   $18
        .byte   $65
        .byte   $3D
        .byte   $85
        .byte   $3D
        .byte   $90
        .byte   $BB
        .byte   $E6
        .byte   $3E
        .byte   $D0
        .byte   $B7
        .byte   $A0
        .byte   $01
        .byte   $60
        .byte   $20
        .byte   $23
        .byte   $89
        .byte   $85
        .byte   $31
        .byte   $84
        .byte   $32
        .byte   $38
        .byte   $A5
        .byte   $5A
        .byte   $E5
        .byte   $5F
        .byte   $85
        .byte   $22
        .byte   $A8
        .byte   $A5
        .byte   $5B
        .byte   $E5
        .byte   $60
        .byte   $AA
        .byte   $E8
        .byte   $98
        .byte   $F0
        .byte   $25
        .byte   $A5
        .byte   $5A
        .byte   $38
        .byte   $E5
        .byte   $22
        .byte   $85
        .byte   $5A
        .byte   $B0
        .byte   $03
        .byte   $C6
        .byte   $5B
        .byte   $38
        .byte   $A5
        .byte   $58
        .byte   $E5
        .byte   $22
        .byte   $85
        .byte   $58
        .byte   $B0
        .byte   $09
        .text   "Fy",$90,$05," "
        .byte   $89
        .byte   $81
        .byte   $91
        .byte   $58
        .byte   $88
        .byte   $D0
        .byte   $F8
        .byte   $20
        .byte   $89
        .byte   $81
        .byte   $91
        .text   "xF[FyJP"
        .byte   $F1
        .byte   $60
        .byte   $8C
        .byte   $F4
        .byte   $07
        .byte   $38
        .byte   $A5
        .byte   $7C
        .byte   $ED
        .byte   $F4
        .byte   $07
        .byte   $85
        .byte   $7C
        .byte   $A5
        .byte   $7D
        .byte   $E9
        .byte   $00
        .byte   $85
        .byte   $7D
        .byte   $C9
        .byte   $06
        .byte   $90
        .byte   $36
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $7C
        .byte   $C9
        .byte   $EC
        .byte   $90
        .byte   $2E
        .byte   $60
        .text   "D4",$90,"(P"
        .byte   $04
        .text   "E3",$90,$22,"h"
        .byte   $A2
        .byte   $09
        .byte   $98
        .byte   $48
        .byte   $B5
        .byte   $57
        .byte   $CA
        .byte   $10
        .byte   $FA
        .byte   $20
        .byte   $54
        .byte   $A9
        .byte   $A2
        .byte   $F7
        .byte   $68
        .byte   $95
        .byte   $61
        .byte   $E8
        .byte   $30
        .byte   $FA
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $C4
        .byte   $34
        .byte   $90
        .byte   $06
        .text   "P",$05,"E3"
        .byte   $B0
        .byte   $01
        .byte   $60
        .byte   $4C
        .byte   $81
        .byte   $86
        .byte   $6C
        .byte   $04
        .byte   $03
        .byte   $A5
        .byte   $3B
        .byte   $48
        .byte   $A5
        .byte   $3C
        .byte   $48
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $4C
        .byte   $65
        .byte   $89
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $90
        .byte   $FB
        .byte   $6C
        .byte   $0C
        .byte   $03
        .byte   $90
        .byte   $68
        .byte   $C9
        .byte   $00
        .byte   $F0
        .byte   $55
        .byte   $C9
        .byte   $3A
        .byte   $F0
        .byte   $EE
        .byte   $C9
        .byte   $3F
        .byte   $D0
        .byte   $04
        .byte   $A9
        .text   $99,"P.I"
        .byte   $80
        .byte   $90
        .byte   $0B
        .byte   $C9
        .byte   $FF
        .byte   $F0
        .byte   $DE
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $EA
        .byte   $89
        .byte   $F0
        .text   "QI",$22,"P",$0D," "
        .byte   $73
        .byte   $04
        .byte   $C9
        .byte   $00
        .byte   $F0
        .byte   $2F
        .byte   $C9
        .byte   $22
        .byte   $F0
        .byte   $C8
        .byte   $D0
        .byte   $F3
        .byte   $20
        .byte   $03
        .byte   $8A
        .byte   $90
        .byte   $C1
        .byte   $C0
        .byte   $00
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $EA
        .byte   $89
        .byte   $A5
        .byte   $0B
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $3B
        .byte   $C9
        .byte   $8F
        .byte   $F0
        .byte   $0D
        .byte   $C9
        .byte   $83
        .byte   $D0
        .byte   $AC
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $B0
        .byte   $8D
        .byte   $4C
        .byte   $5C
        .byte   $89
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $0B
        .byte   $8E
        .byte   $A6
        .byte   $3B
        .byte   $68
        .byte   $85
        .byte   $3C
        .byte   $68
        .byte   $85
        .byte   $3B
        .byte   $38
        .byte   $8A
        .byte   $E5
        .byte   $3B
        .byte   $A8
        .byte   $C8
        .byte   $60
        .byte   $48
        .byte   $88
        .byte   $88
        .byte   $20
        .byte   $EA
        .byte   $89
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $FE
        .byte   $91
        .byte   $3B
        .byte   $C8
        .byte   $68
        .byte   $91
        .byte   $3B
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $62
        .byte   $89
        .byte   $18
        .byte   $98
        .byte   $65
        .byte   $3B
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $3C
        .byte   $69
        .byte   $00
        .byte   $85
        .byte   $23
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $91
        .byte   $3B
        .byte   $C8
        .byte   $C9
        .byte   $00
        .byte   $D0
        .byte   $F6
        .byte   $60
        .byte   $A9
        .byte   $81
        .byte   $A0
        .byte   $8E
        .byte   $85
        .byte   $23
        .byte   $84
        .byte   $22
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $0B
        .byte   $88
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $38
        .byte   $F1
        .byte   $22
        .byte   $F0
        .byte   $F7
        .byte   $C9
        .byte   $80
        .byte   $F0
        .byte   $1B
        .byte   $B1
        .byte   $22
        .byte   $30
        .byte   $03
        .byte   $C8
        .byte   $D0
        .byte   $F9
        .byte   $C8
        .byte   $E6
        .byte   $0B
        .byte   $18
        .byte   $98
        .byte   $65
        .byte   $22
        .byte   $85
        .byte   $22
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $23
        .byte   $18
        .byte   $A0
        .byte   $00
        .byte   $B1
        .text   $22,"PY",$05
        .byte   $0B
        .byte   $85
        .byte   $0B
        .byte   $60
        .byte   $A5
        .byte   $2B
        .byte   $A6
        .byte   $2C
        .byte   $A0
        .byte   $01
        .byte   $85
        .byte   $5F
        .byte   $86
        .byte   $60
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $F0
        .text   "+HH Q"
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $15
        .byte   $C5
        .byte   $78
        .byte   $90
        .byte   $1F
        .byte   $F0
        .byte   $03
        .byte   $88
        .byte   $D0
        .byte   $0E
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $14
        .byte   $C5
        .byte   $78
        .byte   $90
        .byte   $0E
        .byte   $F0
        .byte   $0C
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $AA
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $B0
        .byte   $CA
        .byte   $18
        .byte   $60
        .byte   $D0
        .byte   $FD
        .byte   $A9
        .byte   $00
        .byte   $A8
        .byte   $91
        .byte   $2B
        .byte   $C8
        .byte   $91
        .byte   $2B
        .byte   $8D
        .byte   $EB
        .byte   $02
        .byte   $A5
        .byte   $2B
        .byte   $18
        .byte   $69
        .byte   $02
        .byte   $85
        .byte   $2D
        .byte   $A5
        .byte   $2C
        .byte   $69
        .byte   $00
        .byte   $85
        .byte   $2E
        .byte   $20
        .byte   $F1
        .byte   $8A
        .byte   $A9
        .byte   $00
        .byte   $D0
        .byte   $52
        .byte   $20
        .byte   $E7
        .byte   $FF
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $79
        .byte   $88
        .byte   $8C
        .byte   $F3
        .byte   $04
        .byte   $8C
        .byte   $F0
        .byte   $04
        .byte   $8C
        .byte   $F1
        .byte   $04
        .byte   $8C
        .byte   $EF
        .byte   $04
        .byte   $A5
        .byte   $37
        .byte   $A4
        .byte   $38
        .byte   $85
        .byte   $33
        .byte   $84
        .byte   $34
        .byte   $A9
        .byte   $B0
        .byte   $A0
        .byte   $07
        .byte   $85
        .byte   $7C
        .byte   $84
        .byte   $7D
        .byte   $A5
        .byte   $2D
        .byte   $A4
        .byte   $2E
        .byte   $85
        .byte   $2F
        .byte   $84
        .byte   $30
        .byte   $85
        .byte   $31
        .byte   $84
        .byte   $32
        .byte   $A2
        .byte   $03
        .byte   $BD
        .byte   $ED
        .byte   $8A
        .byte   $9D
        .byte   $E7
        .byte   $04
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $20
        .byte   $B1
        .byte   $8C
        .byte   $A2
        .byte   $19
        .byte   $86
        .byte   $16
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $A2
        .byte   $FA
        .text   $9A,"h",$98,"h"
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $5C
        .byte   $02
        .byte   $85
        .byte   $10
        .byte   $60
        .text   " ,.$"
        .byte   $18
        .byte   $A5
        .byte   $2B
        .byte   $69
        .byte   $FF
        .byte   $85
        .byte   $3B
        .byte   $A5
        .byte   $2C
        .byte   $69
        .byte   $FF
        .byte   $85
        .byte   $3C
        .byte   $60
        .byte   $20
        .byte   $CA
        .byte   $AE
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $D0
        .byte   $06
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $F0
        .byte   $2E
        .byte   $20
        .byte   $C0
        .byte   $8C
        .byte   $20
        .byte   $3E
        .byte   $90
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $AA
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $C5
        .byte   $15
        .byte   $D0
        .byte   $04
        .byte   $E4
        .byte   $14
        .byte   $F0
        .byte   $02
        .byte   $B0
        .byte   $14
        .byte   $20
        .byte   $40
        .byte   $8B
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $AA
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $86
        .byte   $5F
        .byte   $85
        .byte   $60
        .byte   $4C
        .byte   $02
        .byte   $8B
        .byte   $4C
        .byte   $3E
        .byte   $90
        .byte   $A0
        .byte   $03
        .byte   $84
        .byte   $49
        .byte   $84
        .byte   $0F
        .byte   $20
        .byte   $5F
        .byte   $A4
        .byte   $A9
        .byte   $20
        .byte   $A4
        .byte   $49
        .byte   $29
        .byte   $7F
        .byte   $20
        .byte   $B2
        .text   $90,"I",$22,"P"
        .byte   $06
        .byte   $A5
        .byte   $0F
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $0F
        .byte   $C8
        .byte   $F0
        .byte   $DE
        .byte   $24
        .byte   $53
        .byte   $10
        .byte   $03
        .byte   $20
        .byte   $0C
        .byte   $B7
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $F0
        .byte   $50
        .byte   $6C
        .byte   $06
        .byte   $03
        .byte   $10
        .byte   $DF
        .byte   $C9
        .byte   $FF
        .byte   $F0
        .byte   $DB
        .byte   $24
        .byte   $0F
        .byte   $30
        .byte   $D7
        .byte   $C9
        .byte   $FE
        .byte   $D0
        .byte   $17
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $F0
        .byte   $0C
        .byte   $84
        .byte   $49
        .byte   $38
        .byte   $6C
        .byte   $0E
        .byte   $03
        .byte   $B0
        .byte   $C5
        .byte   $A0
        .byte   $00
        .byte   $F0
        .byte   $24
        .byte   $88
        .byte   $A9
        .byte   $FE
        .byte   $D0
        .byte   $BC
        .byte   $AA
        .byte   $84
        .byte   $49
        .byte   $A0
        .byte   $81
        .byte   $84
        .byte   $23
        .byte   $A0
        .byte   $8E
        .byte   $84
        .byte   $22
        .byte   $A0
        .byte   $00
        .byte   $CA
        .byte   $10
        .byte   $0F
        .byte   $B1
        .byte   $22
        .byte   $48
        .byte   $E6
        .byte   $22
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $23
        .byte   $68
        .byte   $10
        .byte   $F4
        .byte   $30
        .byte   $EF
        .byte   $C8
        .byte   $B1
        .text   $22,"0",$95," "
        .byte   $B2
        .byte   $90
        .byte   $D0
        .byte   $F6
        .byte   $60
        .byte   $D0
        .byte   $06
        .byte   $20
        .byte   $20
        .byte   $8D
        .byte   $4C
        .byte   $93
        .byte   $8A
        .byte   $20
        .byte   $9A
        .byte   $8A
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $20
        .byte   $4D
        .byte   $8D
        .byte   $20
        .byte   $20
        .byte   $8D
        .byte   $4C
        .byte   $DC
        .byte   $8B
        .byte   $6C
        .byte   $08
        .byte   $03
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $25
        .byte   $8C
        .byte   $20
        .byte   $C0
        .byte   $8C
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $07
        .byte   $20
        .byte   $1A
        .byte   $8C
        .byte   $BA
        .byte   $8E
        .byte   $F7
        .byte   $04
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $93
        .byte   $8C
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $1F
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $18
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $39
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $3A
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $3B
        .byte   $85
        .byte   $3B
        .byte   $90
        .byte   $C0
        .byte   $E6
        .byte   $3C
        .byte   $D0
        .byte   $BC
        .byte   $4C
        .byte   $7E
        .byte   $86
        .byte   $A5
        .byte   $3B
        .byte   $A4
        .byte   $3C
        .byte   $8D
        .byte   $5B
        .byte   $02
        .byte   $8C
        .byte   $5C
        .byte   $02
        .byte   $60
        .byte   $F0
        .byte   $FD
        .byte   $2C
        .byte   $EB
        .byte   $02
        .byte   $10
        .byte   $13
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $0F
        .byte   $48
        .byte   $A9
        .byte   $5B
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $20
        .byte   $5B
        .byte   $A4
        .byte   $A9
        .byte   $5D
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $68
        .byte   $C9
        .byte   $FE
        .byte   $F0
        .byte   $3F
        .byte   $C9
        .byte   $CB
        .byte   $F0
        .byte   $2D
        .byte   $C9
        .byte   $CA
        .byte   $F0
        .byte   $20
        .byte   $C9
        .byte   $FB
        .byte   $B0
        .byte   $3E
        .byte   $C9
        .byte   $A3
        .byte   $90
        .byte   $06
        .text   "IU",$90,"6"
        .byte   $E9
        .byte   $32
        .byte   $38
        .byte   $E9
        .byte   $80
        .byte   $90
        .byte   $32
        .byte   $0A
        .byte   $A8
        .byte   $B9
        .byte   $84
        .byte   $83
        .byte   $48
        .byte   $B9
        .byte   $83
        .byte   $83
        .byte   $48
        .byte   $4C
        .byte   $73
        .byte   $04
        .byte   $A9
        .byte   $B6
        .byte   $48
        .byte   $A9
        .byte   $5A
        .byte   $48
        .byte   $4C
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $C9
        .byte   $A4
        .byte   $D0
        .byte   $12
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $4D
        .byte   $8D
        .byte   $00
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $F0
        .byte   $06
        .byte   $38
        .byte   $6C
        .byte   $10
        .byte   $03
        .byte   $90
        .byte   $E4
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $4C
        .byte   $7C
        .byte   $8E
        .byte   $C9
        .byte   $3A
        .byte   $D0
        .byte   $F6
        .byte   $4C
        .byte   $D3
        .byte   $8B
        .byte   $F0
        .byte   $15
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $84
        .byte   $14
        .byte   $85
        .byte   $15
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $B0
        .byte   $03
        .byte   $4C
        .byte   $8F
        .byte   $8D
        .byte   $A5
        .byte   $5F
        .byte   $A4
        .byte   $60
        .byte   $B0
        .byte   $05
        .byte   $38
        .byte   $A5
        .byte   $2B
        .byte   $A4
        .byte   $2C
        .byte   $E9
        .byte   $01
        .byte   $B0
        .byte   $01
        .byte   $88
        .byte   $85
        .byte   $41
        .byte   $84
        .byte   $42
        .byte   $60
        .byte   $20
        .byte   $E1
        .byte   $FF
        .byte   $D0
        .byte   $FA
        .byte   $08
        .byte   $AC
        .byte   $F3
        .byte   $04
        .byte   $C8
        .byte   $F0
        .byte   $0B
        .byte   $20
        .byte   $E1
        .byte   $FF
        .byte   $F0
        .byte   $FB
        .byte   $28
        .byte   $A2
        .byte   $1E
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $28
        .byte   $B0
        .byte   $01
        .byte   $18
        .byte   $D0
        .byte   $E2
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $0D
        .byte   $20
        .byte   $1A
        .byte   $8C
        .byte   $A5
        .byte   $39
        .byte   $A4
        .byte   $3A
        .byte   $8D
        .byte   $59
        .byte   $02
        .byte   $8C
        .byte   $5A
        .byte   $02
        .byte   $68
        .byte   $68
        .byte   $90
        .byte   $0E
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   $0D,$0A,"break"
        .byte   $00
        .byte   $4C
        .byte   $FB
        .byte   $86
        .byte   $4C
        .byte   $7E
        .byte   $86
        .byte   $D0
        .byte   $BA
        .byte   $A2
        .byte   $1A
        .byte   $AC
        .byte   $5C
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $AD
        .byte   $5B
        .byte   $02
        .byte   $85
        .byte   $3B
        .byte   $84
        .byte   $3C
        .byte   $AD
        .byte   $59
        .byte   $02
        .byte   $AC
        .byte   $5A
        .byte   $02
        .byte   $85
        .byte   $39
        .byte   $84
        .byte   $3A
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $81
        .byte   $0A
        .byte   $85
        .byte   $73
        .byte   $85
        .byte   $74
        .byte   $4C
        .byte   $90
        .byte   $FF
        .byte   $A0
        .byte   $05
        .byte   $20
        .byte   $05
        .byte   $89
        .byte   $88
        .byte   $A5
        .byte   $3C
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $A5
        .byte   $3B
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $A5
        .byte   $3A
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $A5
        .byte   $39
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $A9
        .byte   $8D
        .byte   $91
        .byte   $7C
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $20
        .byte   $C1
        .byte   $8D
        .byte   $38
        .byte   $A5
        .byte   $39
        .byte   $E5
        .byte   $14
        .byte   $A5
        .byte   $3A
        .byte   $E5
        .byte   $15
        .byte   $B0
        .byte   $0B
        .byte   $98
        .byte   $38
        .byte   $65
        .byte   $3B
        .byte   $A6
        .byte   $3C
        .byte   $90
        .byte   $07
        .byte   $E8
        .byte   $B0
        .byte   $04
        .byte   $A5
        .byte   $2B
        .byte   $A6
        .byte   $2C
        .byte   $20
        .byte   $41
        .byte   $8A
        .byte   $90
        .byte   $1D
        .byte   $A5
        .byte   $5F
        .byte   $E9
        .byte   $01
        .byte   $85
        .byte   $3B
        .byte   $A5
        .byte   $60
        .byte   $E9
        .byte   $00
        .byte   $85
        .byte   $3C
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $9E
        .byte   $60
        .byte   $A9
        .byte   $8D
        .byte   $85
        .byte   $02
        .byte   $20
        .byte   $71
        .byte   $88
        .byte   $F0
        .byte   $08
        .byte   $A2
        .byte   $0C
        .byte   $2C
        .byte   $A2
        .byte   $11
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $69
        .byte   $A7
        .byte   $A0
        .byte   $05
        .byte   $20
        .byte   $72
        .byte   $A7
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3C
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3B
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $20
        .byte   $7F
        .byte   $CD
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $39
        .byte   $20
        .byte   $BE
        .byte   $8D
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $3B
        .byte   $85
        .byte   $3B
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $3C
        .byte   $60
        .byte   $A2
        .byte   $3A
        .byte   $2C
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $07
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $08
        .byte   $A5
        .byte   $08
        .byte   $A6
        .byte   $07
        .byte   $85
        .byte   $07
        .byte   $86
        .byte   $08
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $E7
        .byte   $C5
        .byte   $08
        .byte   $F0
        .byte   $E3
        .text   "HI",$22,"P"
        .byte   $F2
        .byte   $F0
        .byte   $E8
        .text   " ,",$93," "
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $89
        .byte   $F0
        .byte   $05
        .byte   $A9
        .byte   $A7
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $A5
        .byte   $61
        .byte   $D0
        .byte   $1C
        .byte   $20
        .byte   $B0
        .byte   $8D
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $0D
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $C9
        .byte   $D5
        .byte   $D0
        .byte   $EF
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $10
        .byte   $8E
        .byte   $20
        .byte   $C1
        .byte   $8D
        .byte   $F0
        .byte   $A3
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $B0
        .byte   $03
        .byte   $4C
        .byte   $4D
        .byte   $8D
        .byte   $4C
        .byte   $25
        .byte   $8C
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $48
        .byte   $C9
        .byte   $8D
        .byte   $F0
        .byte   $07
        .byte   $C9
        .byte   $89
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $C6
        .byte   $65
        .byte   $D0
        .byte   $04
        .byte   $68
        .byte   $4C
        .byte   $3F
        .byte   $8C
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $EE
        .byte   $68
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $08
        .byte   $86
        .byte   $14
        .byte   $86
        .byte   $15
        .byte   $B0
        .byte   $F5
        .byte   $E6
        .byte   $08
        .byte   $E9
        .byte   $2F
        .byte   $85
        .byte   $07
        .byte   $A5
        .byte   $15
        .byte   $85
        .byte   $22
        .byte   $C9
        .byte   $19
        .byte   $B0
        .byte   $CD
        .byte   $A5
        .byte   $14
        .text   $0A,"&",$22,$0A,"&",$22
        .byte   $65
        .byte   $14
        .byte   $85
        .byte   $14
        .byte   $A5
        .byte   $22
        .byte   $65
        .byte   $15
        .byte   $85
        .byte   $15
        .byte   $06
        .byte   $14
        .byte   $26
        .byte   $15
        .byte   $A5
        .byte   $14
        .byte   $65
        .byte   $07
        .byte   $85
        .byte   $14
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $15
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $46
        .byte   $8E
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $85
        .byte   $49
        .byte   $84
        .byte   $4A
        .byte   $A9
        .byte   $B2
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $A5
        .byte   $0E
        .byte   $48
        .byte   $A5
        .text   $0D,"h ,",$93
        .byte   $68
        .byte   $2A
        .byte   $20
        .byte   $1B
        .byte   $93
        .byte   $D0
        .byte   $18
        .byte   $68
        .byte   $10
        .byte   $12
        .byte   $20
        .byte   $A0
        .byte   $A2
        .byte   $20
        .byte   $86
        .byte   $98
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $64
        .byte   $91
        .byte   $49
        .byte   $C8
        .byte   $A5
        .byte   $65
        .byte   $91
        .byte   $49
        .byte   $60
        .byte   $4C
        .byte   $55
        .byte   $A2
        .byte   $68
        .byte   $A4
        .byte   $4A
        .byte   $C0
        .byte   $04
        .byte   $D0
        .byte   $72
        .text   " n",$9C,"I"
        .byte   $06
        .byte   $D0
        .byte   $3E
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $61
        .byte   $84
        .byte   $66
        .byte   $84
        .byte   $71
        .byte   $20
        .byte   $F4
        .byte   $8E
        .byte   $20
        .byte   $62
        .byte   $A1
        .byte   $E6
        .byte   $71
        .byte   $A4
        .byte   $71
        .byte   $20
        .byte   $F4
        .byte   $8E
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $AA
        .byte   $F0
        .byte   $05
        .byte   $E8
        .byte   $8A
        .byte   $20
        .byte   $6D
        .byte   $A1
        .byte   $A4
        .byte   $71
        .byte   $C8
        .byte   $C0
        .byte   $06
        .byte   $D0
        .byte   $DF
        .byte   $20
        .byte   $62
        .byte   $A1
        .byte   $20
        .byte   $27
        .byte   $A3
        .byte   $A6
        .byte   $64
        .byte   $A4
        .byte   $63
        .byte   $A5
        .byte   $65
        .byte   $4C
        .byte   $DB
        .byte   $FF
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $20
        .byte   $85
        .byte   $04
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $E9
        .byte   $2F
        .byte   $4C
        .byte   $0A
        .byte   $A4
        .byte   $68
        .text   "HE4",$90
        .byte   $18
        .byte   $D0
        .byte   $08
        .byte   $88
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $C5
        .byte   $33
        .byte   $90
        .byte   $0E
        .byte   $A4
        .byte   $65
        .byte   $C4
        .byte   $2E
        .byte   $90
        .byte   $08
        .byte   $D0
        .byte   $24
        .byte   $A5
        .byte   $64
        .byte   $C5
        .byte   $2D
        .byte   $B0
        .byte   $1E
        .byte   $A5
        .byte   $64
        .byte   $A4
        .byte   $65
        .byte   $4C
        .byte   $5E
        .byte   $8F
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $C5
        .byte   $7B
        .byte   $D0
        .byte   $D4
        .byte   $48
        .byte   $88
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $C5
        .byte   $7A
        .byte   $D0
        .byte   $C9
        .byte   $A5
        .byte   $79
        .byte   $F0
        .byte   $C5
        .byte   $68
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $20
        .byte   $54
        .byte   $9B
        .byte   $A5
        .byte   $50
        .byte   $A4
        .byte   $51
        .byte   $85
        .byte   $6F
        .byte   $84
        .byte   $70
        .byte   $20
        .byte   $1B
        .byte   $9C
        .byte   $A5
        .byte   $6F
        .byte   $A4
        .byte   $70
        .byte   $20
        .byte   $AA
        .byte   $9C
        .byte   $A9
        .byte   $61
        .byte   $A0
        .byte   $00
        .byte   $85
        .byte   $50
        .byte   $84
        .byte   $51
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $20
        .byte   $AA
        .byte   $9C
        .byte   $20
        .byte   $9C
        .byte   $8F
        .byte   $90
        .byte   $0B
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $49
        .byte   $91
        .byte   $22
        .byte   $C8
        .byte   $A5
        .byte   $4A
        .byte   $91
        .byte   $22
        .byte   $A5
        .byte   $49
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $4A
        .byte   $85
        .byte   $23
        .byte   $20
        .byte   $9C
        .byte   $8F
        .byte   $90
        .byte   $09
        .byte   $88
        .byte   $A9
        .byte   $FF
        .byte   $91
        .byte   $22
        .byte   $88
        .byte   $8A
        .byte   $91
        .byte   $22
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $50
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $91
        .byte   $49
        .byte   $88
        .byte   $10
        .byte   $F6
        .byte   $60

L8F9C   ldy     #$00       ;2
        jsr     $04B0      ;6
        pha                ;3
        beq     _L8FDD     ;2+
        iny                ;2
        jsr     $04B0      ;6
        tax                ;2
        iny                ;2
        jsr     $04B0      ;6
        cmp     $38        ;3
        bcc     _L8FB7     ;2+
        bne     _L8FDD     ;2+
        cpx     $37        ;3
        bcs     _L8FDD     ;2+
_L8FB7  jsr     $04B0      ;6
        cmp     $34        ;3
        bcc     _L8FDD     ;2+
        bne     _L8FC4     ;2+
        cpx     $33        ;3
        bcc     _L8FDD     ;2+
_L8FC4  cmp     $7B        ;3
        bne     _L8FCC     ;2+
        cpx     $7A        ;3
        beq     _L8FDD     ;2+
_L8FCC  stx     $22        ;3
        sta     $23        ;3
        pla                ;4
        tax                ;2
        clc                ;2
        adc     $22        ;3
        sta     $22        ;3
        bcc     _L8FDB     ;2+
        inc     $23        ;5
_L8FDB  sec                ;2
        rts                ;6

_L8FDD  pla                ;4
        clc                ;2
        rts                ;6

        .byte   $20
        .byte   $E6
        .byte   $8F
        .byte   $4C
        .byte   $FE
        .byte   $90
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $F0
        .byte   $05
        .byte   $A9
        .byte   $2C
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $08
        .byte   $86
        .byte   $13
        .byte   $20
        .byte   $97
        .byte   $A7
        .byte   $28
        .byte   $4C
        .byte   $00
        .byte   $90
        .byte   $20
        .byte   $8B
        .byte   $90
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $3C
        .byte   $C9
        .byte   $FB
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $F7
        .byte   $AE
        .byte   $F0
        .byte   $43
        .byte   $C9
        .byte   $A3
        .byte   $F0
        .byte   $50
        .byte   $C9
        .byte   $A6
        .byte   $18
        .byte   $F0
        .byte   $4B
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $37
        .byte   $C9
        .byte   $3B
        .byte   $F0
        .byte   $5E
        .text   " ,",$93,"$",$0D,"0W "
        .byte   $6F
        .byte   $A4
        .byte   $20
        .byte   $74
        .byte   $9B
        .byte   $20
        .byte   $8B
        .byte   $90
        .byte   $20
        .byte   $A6
        .byte   $90
        .byte   $D0
        .byte   $CC
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $00
        .byte   $02
        .byte   $A2
        .byte   $FF
        .byte   $A0
        .byte   $01
        .byte   $A5
        .byte   $13
        .byte   $D0
        .byte   $10
        .byte   $A9
        .byte   $0D
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $24
        .byte   $13
        .byte   $10
        .byte   $05
        .byte   $A9
        .byte   $0A
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $49
        .byte   $FF
        .byte   $60
        .byte   $38
        .byte   $20
        .byte   $F0
        .byte   $FF
        .byte   $98
        .byte   $38
        .byte   $E9
        .byte   $0A
        .byte   $B0
        .byte   $FC
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $01
        .byte   $D0
        .byte   $16
        .byte   $08
        .byte   $38
        .byte   $20
        .byte   $F0
        .byte   $FF
        .byte   $84
        .byte   $09
        .byte   $20
        .byte   $81
        .byte   $9D
        .byte   $C9
        .byte   $29
        .byte   $D0
        .byte   $13
        .byte   $28
        .byte   $90
        .byte   $06
        .byte   $8A
        .byte   $E5
        .byte   $09
        .byte   $90
        .byte   $05
        .byte   $AA
        .byte   $E8
        .byte   $CA
        .byte   $D0
        .byte   $09
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $09
        .byte   $90
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $A6
        .byte   $90
        .byte   $D0
        .byte   $EF
        .byte   $20
        .byte   $74
        .text   $9B," n",$9C
        .byte   $AA
        .byte   $A0
        .byte   $00
        .byte   $E8
        .byte   $CA
        .byte   $F0
        .byte   $B9
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $20
        .byte   $B2
        .text   $90,"HI",$0D,"P"
        .byte   $F2
        .text   " l",$90,"l",$92,$90
        .byte   $A5
        .byte   $13
        .byte   $F0
        .byte   $03
        .byte   $A9
        .byte   $20
        .byte   $2C
        .byte   $A9
        .byte   $1D
        .byte   $2C
        .byte   $A9
        .byte   $3F
        .byte   $20
        .byte   $8B
        .byte   $A7
        .byte   $29
        .byte   $FF
        .byte   $60
        .byte   $20
        .byte   $86
        .byte   $9A
        .byte   $85
        .byte   $80
        .byte   $C9
        .byte   $23
        .byte   $F0
        .byte   $0A
        .byte   $C9
        .byte   $F9
        .byte   $D0
        .byte   $16
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $DB
        .byte   $90
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $A9
        .byte   $2C
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $86
        .byte   $13
        .byte   $20
        .byte   $A6
        .byte   $A7
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $01
        .byte   $02
        .byte   $A9
        .byte   $40
        .byte   $20
        .byte   $58
        .byte   $91
        .byte   $A6
        .byte   $13
        .byte   $D0
        .byte   $13
        .byte   $60
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $A9
        .byte   $2C
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $86
        .byte   $13
        .byte   $20
        .byte   $A6
        .byte   $A7
        .byte   $20
        .byte   $17
        .byte   $91
        .byte   $A5
        .byte   $13
        .byte   $20
        .byte   $CC
        .byte   $FF
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $13
        .byte   $60
        .byte   $C9
        .byte   $22
        .byte   $D0
        .byte   $0B
        .byte   $20
        .byte   $4E
        .byte   $94
        .byte   $A9
        .byte   $3B
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $20
        .byte   $8B
        .byte   $90
        .byte   $20
        .byte   $86
        .byte   $9A
        .byte   $A9
        .byte   $2C
        .byte   $8D
        .byte   $FF
        .byte   $01
        .byte   $20
        .byte   $42
        .byte   $91
        .byte   $A5
        .byte   $13
        .byte   $F0
        .byte   $0D
        .byte   $20
        .byte   $B7
        .byte   $FF
        .byte   $29
        .byte   $02
        .byte   $F0
        .byte   $06
        .byte   $20
        .byte   $FE
        .byte   $90
        .byte   $4C
        .byte   $B0
        .byte   $8D
        .byte   $AD
        .byte   $00
        .byte   $02
        .byte   $D0
        .byte   $1E
        .byte   $A5
        .byte   $13
        .byte   $D0
        .byte   $E3
        .byte   $20
        .byte   $BE
        .byte   $8D
        .byte   $4C
        .byte   $B3
        .byte   $8D
        .byte   $A5
        .byte   $13
        .byte   $D0
        .byte   $06
        .byte   $20
        .byte   $B0
        .byte   $90
        .byte   $20
        .byte   $AA
        .byte   $90
        .byte   $4C
        .byte   $5A
        .byte   $88
        .byte   $A6
        .byte   $41
        .byte   $A4
        .byte   $42
        .byte   $A9
        .byte   $98
        .byte   $2C
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $11
        .byte   $86
        .byte   $43
        .byte   $84
        .byte   $44
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $85
        .byte   $49
        .byte   $84
        .byte   $4A
        .byte   $A2
        .byte   $01
        .byte   $B5
        .byte   $3B
        .byte   $95
        .byte   $4B
        .byte   $B5
        .text   "c",$95,";J"
        .byte   $10
        .byte   $F5
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $D0
        .byte   $31
        .byte   $24
        .byte   $11
        .byte   $50
        .byte   $1A
        .byte   $A5
        .byte   $80
        .byte   $C9
        .byte   $F9
        .byte   $D0
        .byte   $08
        .byte   $20
        .byte   $AF
        .byte   $A7
        .byte   $AA
        .byte   $F0
        .byte   $FA
        .byte   $D0
        .byte   $03
        .byte   $20
        .byte   $AF
        .byte   $A7
        .byte   $8D
        .byte   $00
        .byte   $02
        .byte   $A2
        .byte   $FF
        .byte   $A0
        .byte   $01
        .byte   $D0
        .byte   $0F
        .byte   $10
        .byte   $03
        .byte   $4C
        .byte   $40
        .byte   $92
        .byte   $A5
        .byte   $13
        .byte   $D0
        .byte   $03
        .byte   $20
        .byte   $B0
        .byte   $90
        .byte   $20
        .byte   $42
        .byte   $91
        .byte   $86
        .byte   $3B
        .byte   $84
        .byte   $3C
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $24
        .byte   $0D
        .byte   $10
        .byte   $31
        .byte   $24
        .byte   $11
        .byte   $50
        .byte   $09
        .byte   $E8
        .byte   $86
        .byte   $3B
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $07
        .byte   $F0
        .byte   $0C
        .byte   $85
        .byte   $07
        .byte   $C9
        .byte   $22
        .byte   $F0
        .byte   $07
        .byte   $A9
        .byte   $3A
        .byte   $85
        .byte   $07
        .byte   $A9
        .byte   $2C
        .byte   $18
        .byte   $85
        .byte   $08
        .byte   $A5
        .byte   $3B
        .byte   $A4
        .byte   $3C
        .byte   $69
        .byte   $00
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $20
        .byte   $7A
        .byte   $9B
        .byte   $20
        .byte   $C6
        .byte   $9D
        .byte   $20
        .byte   $B1
        .byte   $8E
        .byte   $4C
        .byte   $E8
        .byte   $91
        .byte   $20
        .byte   $7F
        .byte   $A3
        .byte   $A5
        .byte   $0E
        .byte   $20
        .byte   $99
        .byte   $8E
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $3B
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $37
        .byte   $A5
        .byte   $11
        .byte   $F0
        .byte   $0A
        .byte   $30
        .byte   $04
        .byte   $A6
        .byte   $13
        .byte   $D0
        .byte   $08
        .byte   $A2
        .byte   $16
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $13
        .byte   $F0
        .byte   $05
        .byte   $A2
        .byte   $18
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   "?redo from start",$0D
        .byte   $00
        .byte   $AD
        .byte   $5B
        .byte   $02
        .byte   $AC
        .byte   $5C
        .byte   $02
        .byte   $85
        .byte   $3B
        .byte   $84
        .byte   $3C
        .byte   $60
        .byte   $A2
        .byte   $01
        .byte   $B5
        .byte   $3B
        .byte   $95
        .byte   $43
        .byte   $B5
        .text   "k",$95,";J"
        .byte   $10
        .byte   $F5
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $30
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $4C
        .byte   $5E
        .byte   $91
        .byte   $20
        .byte   $BE
        .byte   $8D
        .byte   $C8
        .byte   $AA
        .byte   $D0
        .byte   $15
        .byte   $A2
        .byte   $0D
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $6C
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $3F
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $C8
        .byte   $85
        .byte   $40
        .byte   $20
        .byte   $B3
        .byte   $8D
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $AA
        .byte   $E0
        .byte   $83
        .byte   $D0
        .byte   $D9
        .byte   $4C
        .byte   $A8
        .byte   $91
        .byte   $A5
        .byte   $43
        .byte   $A4
        .byte   $44
        .byte   $A6
        .byte   $11
        .byte   $10
        .byte   $03
        .byte   $4C
        .byte   $BB
        .byte   $8C
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $55
        .byte   $81
        .byte   $F0
        .byte   $17
        .byte   $A5
        .byte   $13
        .byte   $D0
        .byte   $13
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   "?extra ignored",$0D
        .byte   $00
        .byte   $60
        .byte   $D0
        .byte   $13
        .byte   $A0
        .byte   $FF
        .byte   $D0
        .byte   $14
        .byte   $A0
        .byte   $12
        .byte   $20
        .byte   $72
        .byte   $A7
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $2C
        .byte   $D0
        .byte   $6D
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $85
        .byte   $49
        .byte   $84
        .byte   $4A
        .byte   $A0
        .byte   $81
        .byte   $84
        .byte   $02
        .byte   $20
        .byte   $71
        .byte   $88
        .byte   $F0
        .byte   $05
        .byte   $A2
        .byte   $0A
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $69
        .byte   $A7
        .byte   $A5
        .byte   $3D
        .byte   $18
        .byte   $69
        .byte   $03
        .byte   $A4
        .byte   $3E
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $20
        .byte   $1F
        .byte   $A2
        .byte   $A0
        .byte   $08
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $66
        .byte   $A0
        .byte   $01
        .byte   $B1
        .byte   $3D
        .byte   $48
        .byte   $AA
        .byte   $C8
        .byte   $B1
        .byte   $3D
        .byte   $48
        .byte   $A8
        .byte   $8A
        .byte   $20
        .byte   $9B
        .byte   $9E
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $AA
        .byte   $20
        .byte   $59
        .byte   $A2
        .byte   $A5
        .byte   $3D
        .byte   $18
        .byte   $69
        .byte   $09
        .byte   $A4
        .byte   $3E
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $20
        .byte   $E0
        .byte   $A2
        .byte   $A0
        .byte   $08
        .byte   $38
        .byte   $F1
        .byte   $3D
        .byte   $F0
        .byte   $9C
        .byte   $A0
        .byte   $11
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3B
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3C
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3A
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $39
        .byte   $60

L9314   jsr     L932C      ;6
L9317   clc                ;2
        bcc     L931B      ;3

L931A   sec                ;2
L931B   bit     $0D        ;3
        bmi     _L9322     ;2+
        bcs     _L9324     ;2+
_L9321  rts                ;6

_L9322  bcs     _L9321     ;2+
_L9324  ldx     #$16       ;2
        .byte   $2C        ;4
L9327   ldx     #$19       ;2
        jmp     L8683      ;3

L932C   ldx     $3B        ;3
        bne     _L9332     ;2+
        dec     $3C        ;5
_L9332  dec     $3B        ;5
        ldx     #$00       ;2
        .byte   $24        ;3
L9337   pha                ;3
        txa                ;2
        pha                ;3
        tsx                ;2
        cpx     #$28       ;2
        bcc     L9327      ;2+
        jsr     L9414      ;6
        lda     #$00       ;2
        sta     $4D        ;3
L9346   jsr     $0479      ;6
_L9349  sec                ;2
        sbc     #$B1       ;2
        bcc     _L9365     ;2+
        cmp     #$03       ;2
        bcs     _L9365     ;2+
        cmp     #$01       ;2
        rol     a          ;2
        eor     #$01       ;2
        eor     $4D        ;3
        cmp     $4D        ;3
        bcc     _L93BE     ;2+
        sta     $4D        ;3
        jsr     $0473      ;6
        jmp     _L9349     ;3

_L9365  ldx     $4D        ;3
        bne     _L9395     ;2+
        bcs     _L93E9     ;2+
        adc     #$07       ;2
        bcc     _L93E9     ;2+
        adc     $0D        ;3
        bne     _L9376     ;2+
        jmp     L9BDA      ;3

_L9376  adc     #$FF       ;2
        sta     $22        ;3
        asl     a          ;2
        adc     $22        ;3
        tay                ;2
_L937E  pla                ;4
        cmp     L8453,y    ;4+
        bcs     _L93EE     ;2+
        jsr     L9317      ;6
_L9387  pha                ;3
        jsr     _L93AE     ;6
        pla                ;4
        ldy     $4B        ;3
        bpl     _L93A7     ;2+
        tax                ;2
        beq     _L93EC     ;2+
        bne     _L93F7     ;3

_L9395  lsr     $0D        ;5
        txa                ;2
        rol     a          ;2
        ldx     $3B        ;3
        bne     _L939F     ;2+
        dec     $3C        ;5
_L939F  dec     $3B        ;5
        ldy     #$1B       ;2
        sta     $4D        ;3
        bne     _L937E     ;3

_L93A7  cmp     L8453,y    ;4+
        bcs     _L93F7     ;2+
        bcc     _L9387     ;3

_L93AE  lda     L8455,y    ;4+
        pha                ;3
        lda     L8454,y    ;4+
        pha                ;3
        jsr     _L93C1     ;6
        lda     $4D        ;3
        jmp     L9337      ;3

_L93BE  jmp     L94A1      ;3

_L93C1  lda     $66        ;3
        ldx     L8453,y    ;4+
        tay                ;2
        clc                ;2
        pla                ;4
        adc     #$01       ;2
        sta     $22        ;3
        pla                ;4
        adc     #$00       ;2
        sta     $23        ;3
        tya                ;2
        pha                ;3
        jsr     LA2A0      ;6
        lda     $65        ;3
        pha                ;3
        lda     $64        ;3
        pha                ;3
        lda     $63        ;3
        pha                ;3
        lda     $62        ;3
        pha                ;3
        lda     $61        ;3
        pha                ;3
        jmp     ($0022)    ;5

_L93E9  ldy     #$FF       ;2
        pla                ;4
_L93EC  beq     _L9411     ;3+
_L93EE  cmp     #$64       ;2
        beq     _L93F5     ;2+
        jsr     L9317      ;6
_L93F5  sty     $4B        ;3
_L93F7  pla                ;4
        lsr     a          ;2
        sta     $12        ;3
        pla                ;4
        sta     $69        ;3
        pla                ;4
        sta     $6A        ;3
        pla                ;4
        sta     $6B        ;3
        pla                ;4
        sta     $6C        ;3
        pla                ;4
        sta     $6D        ;3
        pla                ;4
        sta     $6E        ;3
        eor     $66        ;3
        sta     $6F        ;3
_L9411  lda     $61        ;3
        rts                ;6

L9414   jmp     ($030A)    ;5

        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $0D
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $B0
        .byte   $03
        .byte   $4C
        .byte   $7F
        .byte   $A3
        .text   " :",$97,$90
        .byte   $03
        .byte   $4C
        .byte   $AD
        .byte   $94
        .byte   $C9
        .byte   $FF
        .byte   $D0
        .byte   $0F
        .byte   $A9
        .byte   $39
        .byte   $A0
        .byte   $94
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $4C
        .byte   $73
        .byte   $04
        .byte   $82
        .byte   $49
        .byte   $0F
        .byte   $DA
        .byte   $A1
        .byte   $C9
        .byte   $2E
        .byte   $F0
        .byte   $DE
        .byte   $C9
        .byte   $AB
        .byte   $F0
        .byte   $60
        .byte   $C9
        .byte   $AA
        .byte   $F0
        .text   "QI",$22,"P"
        .byte   $0F
        .byte   $A5
        .byte   $3B
        .byte   $A4
        .byte   $3C
        .byte   $69
        .byte   $00
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $20
        .byte   $74
        .byte   $9B
        .byte   $4C
        .byte   $C6
        .byte   $9D
        .byte   $C9
        .byte   $A8
        .byte   $D0
        .byte   $16
        .byte   $A0
        .byte   $18
        .byte   $D0
        .byte   $43
        .byte   $20
        .byte   $86
        .byte   $98
        .byte   $A5
        .byte   $65
        .byte   $49
        .byte   $FF
        .byte   $A8
        .byte   $A5
        .byte   $64
        .byte   $49
        .byte   $FF
        .text   " ",$92,$9A,"lI"
        .byte   $A2
        .byte   $C9
        .byte   $A5
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $DE
        .byte   $9A
        .byte   $C9
        .byte   $B4
        .byte   $90
        .byte   $03
        .text   "l",$99,$95," "
        .byte   $8E
        .byte   $94
        .byte   $20
        .byte   $2C
        .byte   $93

L948B   lda     #$29       ;2
        .byte   $2C        ;4
L948E   lda     #$28       ;2
        bit     L2CA9      ;4
        ldy     #$00       ;2
        sta     $78        ;3
        jsr     $04A5      ;6
        cmp     $78        ;3
        bne     L94A1      ;2+
        jmp     $0473      ;3

L94A1   ldx     #$0B       ;2
        jmp     L8683      ;3

        .byte   $A0
        .byte   $15
        .byte   $68
        .byte   $68
        .byte   $4C
        .byte   $88
        .byte   $93
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $85
        .byte   $64
        .byte   $84
        .byte   $65
        .byte   $A6
        .byte   $45
        .byte   $A4
        .byte   $46
        .byte   $A5
        .byte   $0D
        .byte   $F0
        .byte   $45
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $70
        .byte   $E0
        .byte   $54
        .byte   $D0
        .byte   $24
        .byte   $C0
        .byte   $C9
        .byte   $D0
        .byte   $76
        .byte   $A5
        .byte   $64
        .byte   $C9
        .byte   $A2
        .byte   $D0
        .byte   $70
        .byte   $A5
        .byte   $65
        .byte   $C9
        .byte   $04
        .byte   $D0
        .byte   $6A
        .byte   $20
        .byte   $31
        .byte   $95
        .byte   $84
        .byte   $5E
        .byte   $88
        .byte   $84
        .byte   $71
        .byte   $A0
        .byte   $06
        .byte   $84
        .byte   $5D
        .byte   $A0
        .byte   $24
        .byte   $20
        .byte   $FA
        .byte   $A4
        .byte   $4C
        .byte   $70
        .byte   $9B
        .byte   $E0
        .byte   $44
        .byte   $D0
        .byte   $52
        .byte   $C0
        .text   "SPn "
        .byte   $FA
        .byte   $94
        .byte   $A5
        .byte   $7A
        .byte   $A4
        .byte   $7B
        .byte   $4C
        .byte   $74
        .byte   $9B
        .byte   $A5
        .byte   $79
        .text   "P@lOL$"
        .byte   $0E
        .byte   $10
        .byte   $0F
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $AA
        .byte   $C8
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $A8
        .byte   $8A
        .byte   $4C
        .byte   $71
        .byte   $94
        .byte   $A5
        .byte   $65
        .byte   $C9
        .byte   $04
        .byte   $D0
        .byte   $78
        .byte   $A5
        .byte   $64
        .byte   $C9
        .byte   $A2
        .byte   $D0
        .byte   $72
        .byte   $E0
        .byte   $54
        .byte   $D0
        .byte   $1B
        .byte   $C0
        .byte   $49
        .byte   $D0
        .byte   $6A
        .text   " 1",$95,$98
        .byte   $A2
        .byte   $A0
        .byte   $4C
        .byte   $D4
        .byte   $A2
        .byte   $20
        .byte   $DE
        .byte   $FF
        .byte   $86
        .byte   $64
        .byte   $84
        .byte   $63
        .byte   $85
        .byte   $65
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $62
        .byte   $60
        .byte   $E0
        .byte   $53
        .byte   $D0
        .byte   $0A
        .byte   $C0
        .text   "tPk "
        .byte   $B7
        .byte   $FF
        .byte   $4C
        .byte   $C1
        .byte   $A2
        .byte   $E0
        .byte   $44
        .byte   $D0
        .byte   $26
        .byte   $C0
        .text   "sP= "
        .byte   $FA
        .byte   $94
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $7A
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $29
        .byte   $0F
        .byte   $0A
        .byte   $85
        .byte   $0F
        .byte   $0A
        .byte   $0A
        .byte   $65
        .byte   $0F
        .byte   $85
        .byte   $0F
        .byte   $C8
        .byte   $A9
        .byte   $7A
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $29
        .byte   $0F
        .byte   $65
        .byte   $0F
        .byte   $4C
        .byte   $C1
        .byte   $A2
        .byte   $E0
        .byte   $45
        .byte   $D0
        .byte   $17
        .byte   $C0
        .byte   $52
        .byte   $F0
        .byte   $0D
        .byte   $C0
        .byte   $4C
        .byte   $D0
        .byte   $0F
        .byte   $AD
        .byte   $F1
        .byte   $04
        .byte   $AC
        .byte   $F0
        .byte   $04
        .byte   $4C
        .byte   $76
        .byte   $9A
        .byte   $AD
        .byte   $EF
        .byte   $04
        .byte   $4C
        .byte   $C1
        .byte   $A2
        .byte   $A5
        .byte   $64
        .byte   $A4
        .byte   $65
        .byte   $4C
        .byte   $1F
        .byte   $A2
        .byte   $C9
        .byte   $D5
        .byte   $B0
        .text   "xIK",$90
        .byte   $02
        .byte   $E9
        .byte   $01
        .byte   $48
        .byte   $AA
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $E0
        .byte   $D3
        .byte   $F0
        .byte   $08
        .byte   $E0
        .byte   $CB
        .byte   $B0
        .byte   $29
        .byte   $E0
        .text   "H",$90,"% "
        .byte   $8E
        .byte   $94
        .text   " ,",$93," "
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $1A
        .byte   $93
        .byte   $68
        .byte   $C9
        .byte   $D3
        .byte   $F0
        .byte   $2D
        .byte   $AA
        .byte   $A5
        .byte   $65
        .byte   $48
        .byte   $A5
        .byte   $64
        .byte   $48
        .byte   $8A
        .byte   $48
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $68
        .byte   $A8
        .byte   $8A
        .byte   $48
        .byte   $98
        .byte   $4C
        .byte   $DD
        .byte   $95
        .byte   $20
        .byte   $85
        .byte   $94
        .byte   $68
        .byte   $38
        .byte   $E9
        .byte   $B4
        .byte   $0A
        .byte   $A8
        .byte   $B9
        .byte   $16
        .byte   $84
        .byte   $85
        .byte   $56
        .byte   $B9
        .byte   $15
        .byte   $84
        .byte   $85
        .byte   $55
        .byte   $20
        .byte   $54
        .byte   $00
        .byte   $4C
        .byte   $17
        .byte   $93
        .byte   $4C
        .byte   $86
        .byte   $B3
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A0
        .byte   $FF
        .byte   $2C
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $0B
        .byte   $20
        .byte   $86
        .byte   $98
        .byte   $A5
        .byte   $64
        .byte   $45
        .byte   $0B
        .byte   $85
        .byte   $07
        .byte   $A5
        .byte   $65
        .byte   $45
        .byte   $0B
        .byte   $85
        .byte   $08
        .byte   $20
        .byte   $81
        .byte   $A2
        .byte   $20
        .byte   $86
        .byte   $98
        .byte   $A5
        .byte   $65
        .byte   $45
        .byte   $0B
        .byte   $25
        .byte   $08
        .byte   $45
        .byte   $0B
        .byte   $A8
        .byte   $A5
        .byte   $64
        .byte   $45
        .byte   $0B
        .byte   $25
        .byte   $07
        .byte   $45
        .byte   $0B
        .byte   $4C
        .byte   $71
        .byte   $94
        .byte   $20
        .byte   $1B
        .byte   $93
        .byte   $B0
        .byte   $13
        .byte   $A5
        .byte   $6E
        .byte   $09
        .byte   $7F
        .byte   $25
        .byte   $6A
        .byte   $85
        .byte   $6A
        .byte   $A9
        .byte   $69
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $E0
        .byte   $A2
        .byte   $AA
        .byte   $4C
        .byte   $73
        .byte   $96
        .byte   $A9
        .byte   $00
        .byte   $85
        .text   $0D,"Fm n",$9C
        .byte   $85
        .byte   $61
        .byte   $86
        .byte   $62
        .byte   $84
        .byte   $63
        .byte   $A5
        .byte   $6C
        .byte   $A4
        .byte   $6D
        .byte   $20
        .byte   $52
        .byte   $9C
        .byte   $86
        .byte   $6C
        .byte   $84
        .byte   $6D
        .byte   $AA
        .byte   $38
        .byte   $E5
        .byte   $61
        .byte   $F0
        .byte   $08
        .byte   $A9
        .byte   $01
        .byte   $90
        .byte   $04
        .byte   $A6
        .byte   $61
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $66
        .byte   $A0
        .byte   $FF
        .byte   $E8
        .text   "HJP",$07
        .byte   $A6
        .byte   $66
        .byte   $30
        .byte   $17
        .byte   $18
        .byte   $90
        .byte   $14
        .byte   $20
        .byte   $85
        .byte   $81
        .byte   $48
        .byte   $20
        .byte   $7D
        .byte   $81
        .byte   $85
        .byte   $78
        .byte   $68
        .byte   $C5
        .byte   $78
        .byte   $F0
        .byte   $E7
        .byte   $A2
        .byte   $FF
        .byte   $B0
        .byte   $02
        .byte   $A2
        .byte   $01
        .byte   $E8
        .byte   $8A
        .byte   $2A
        .byte   $25
        .byte   $12
        .byte   $F0
        .byte   $02
        .byte   $A9
        .byte   $FF
        .byte   $4C
        .byte   $C1
        .byte   $A2
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $AA
        .byte   $20
        .byte   $AA
        .byte   $96
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $D0
        .byte   $F4
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $86
        .byte   $0C
        .byte   $85
        .byte   $45
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $20
        .byte   $3A
        .byte   $97
        .byte   $B0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $0D
        .byte   $86
        .byte   $0E
        .byte   $20
        .byte   $73
        .byte   $04
        .text   $90,$05," :",$97,$90
        .byte   $0B
        .byte   $AA
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $90
        .byte   $FB
        .byte   $20
        .byte   $3A
        .byte   $97
        .byte   $B0
        .byte   $F6
        .byte   $C9
        .byte   $24
        .byte   $D0
        .byte   $06
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $0D
        .byte   $D0
        .byte   $10
        .byte   $C9
        .byte   $25
        .byte   $D0
        .byte   $13
        .byte   $A5
        .byte   $10
        .byte   $D0
        .byte   $D0
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $0E
        .byte   $05
        .byte   $45
        .byte   $85
        .byte   $45
        .byte   $8A
        .byte   $09
        .byte   $80
        .byte   $AA
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $86
        .byte   $46
        .byte   $38
        .byte   $05
        .byte   $10
        .byte   $E9
        .byte   $28
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $9B
        .byte   $98
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $10
        .byte   $A5
        .byte   $2D
        .byte   $A6
        .byte   $2E
        .byte   $86
        .byte   $60
        .byte   $85
        .byte   $5F
        .byte   $E4
        .byte   $30
        .byte   $D0
        .byte   $04
        .byte   $C5
        .byte   $2F
        .byte   $F0
        .byte   $2F
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $45
        .byte   $C5
        .byte   $78
        .byte   $D0
        .byte   $10
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $46
        .byte   $C5
        .byte   $78
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $4C
        .byte   $98
        .byte   $88
        .byte   $18
        .byte   $A5
        .byte   $5F
        .byte   $69
        .byte   $07
        .byte   $90
        .byte   $D4
        .byte   $E8
        .text   "POIa",$90,$05
        .byte   $E9
        .byte   $5B
        .byte   $38
        .byte   $E9
        .byte   $A5
        .byte   $60
        .byte   $68
        .byte   $48
        .byte   $C9
        .byte   $AF
        .byte   $D0
        .byte   $2A
        .byte   $A9
        .byte   $A2
        .byte   $A0
        .byte   $04
        .byte   $60
        .byte   $C0
        .byte   $C9
        .byte   $F0
        .byte   $F7
        .byte   $C0
        .byte   $49
        .byte   $D0
        .byte   $31
        .byte   $F0
        .byte   $18
        .byte   $C0
        .byte   $D3
        .byte   $F0
        .byte   $14
        .byte   $C0
        .byte   $53
        .byte   $D0
        .byte   $27
        .byte   $F0
        .byte   $0E
        .byte   $C0
        .byte   $54
        .byte   $D0
        .byte   $21
        .byte   $F0
        .byte   $08
        .byte   $C0
        .byte   $52
        .byte   $F0
        .byte   $04
        .byte   $C0
        .byte   $4C
        .byte   $D0
        .byte   $17
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A5
        .byte   $45
        .byte   $A4
        .byte   $46
        .byte   $C9
        .byte   $54
        .byte   $F0
        .byte   $D3
        .byte   $C9
        .byte   $53
        .byte   $F0
        .byte   $E3
        .byte   $C9
        .byte   $45
        .byte   $F0
        .byte   $E5
        .byte   $C9
        .byte   $44
        .byte   $F0
        .byte   $D1
        .byte   $A5
        .byte   $2F
        .byte   $A4
        .byte   $30
        .byte   $85
        .byte   $5F
        .byte   $84
        .byte   $60
        .byte   $A5
        .byte   $31
        .byte   $A4
        .byte   $32
        .byte   $85
        .byte   $5A
        .byte   $84
        .byte   $5B
        .byte   $18
        .byte   $69
        .byte   $07
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $58
        .byte   $84
        .byte   $59
        .byte   $20
        .byte   $C0
        .byte   $88
        .byte   $A5
        .byte   $58
        .byte   $A4
        .byte   $59
        .byte   $C8
        .byte   $85
        .byte   $2F
        .byte   $84
        .byte   $30
        .byte   $85
        .byte   $58
        .byte   $84
        .byte   $59
        .byte   $A5
        .byte   $58
        .byte   $A6
        .byte   $59
        .byte   $E4
        .byte   $32
        .byte   $D0
        .byte   $06
        .byte   $C5
        .byte   $31
        .byte   $D0
        .byte   $02
        .byte   $F0
        .byte   $78
        .byte   $85
        .byte   $22
        .byte   $86
        .byte   $23
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $AA
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $08
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $65
        .byte   $58
        .byte   $85
        .byte   $58
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $65
        .byte   $59
        .byte   $85
        .byte   $59
        .byte   $28
        .byte   $10
        .byte   $D0
        .byte   $8A
        .text   "0MH "
        .byte   $B0
        .byte   $04
        .byte   $A0
        .byte   $00
        .byte   $0A
        .byte   $69
        .byte   $05
        .byte   $65
        .byte   $22
        .byte   $85
        .byte   $22
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $23
        .byte   $A6
        .byte   $23
        .byte   $E4
        .byte   $59
        .byte   $D0
        .byte   $04
        .byte   $C5
        .byte   $58
        .byte   $F0
        .byte   $B6
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $F0
        .byte   $24
        .byte   $85
        .byte   $78
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $18
        .byte   $65
        .byte   $78
        .byte   $85
        .byte   $5A
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $69
        .byte   $00
        .byte   $85
        .byte   $5B
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $89
        .byte   $81
        .byte   $69
        .byte   $07
        .byte   $91
        .byte   $5A
        .byte   $C8
        .byte   $20
        .byte   $89
        .byte   $81
        .byte   $69
        .byte   $00
        .byte   $91
        .byte   $5A
        .byte   $A9
        .byte   $03
        .byte   $18
        .byte   $65
        .byte   $22
        .byte   $85
        .byte   $22
        .byte   $90
        .byte   $C2
        .byte   $E6
        .byte   $23
        .byte   $D0
        .byte   $BE
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $45
        .byte   $91
        .byte   $5F
        .byte   $C8
        .byte   $A5
        .byte   $46
        .byte   $91
        .byte   $5F
        .byte   $A9
        .byte   $00
        .byte   $C8
        .byte   $91
        .byte   $5F
        .byte   $C0
        .byte   $06
        .byte   $D0
        .byte   $F9
        .byte   $A5
        .byte   $5F
        .byte   $18
        .byte   $69
        .byte   $02
        .byte   $A4
        .byte   $60
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $47
        .byte   $84
        .byte   $48
        .byte   $60
        .byte   $A5
        .byte   $0B
        .byte   $0A
        .byte   $69
        .byte   $05
        .byte   $65
        .byte   $5F
        .byte   $A4
        .byte   $60
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $58
        .byte   $84
        .byte   $59
        .byte   $60
        .byte   $90
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $20
        .byte   $86
        .byte   $98
        .byte   $A5
        .byte   $64
        .byte   $A4
        .byte   $65
        .byte   $60
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $2C
        .byte   $93

L987F   jsr     L9317      ;6
        lda     $66        ;3
        bmi     _L9893     ;2+
        lda     $61        ;3
        cmp     #$90       ;2
        bcc     _L9898     ;2+
        lda     #$6C       ;2
        ldy     #$98       ;2
        jsr     LA2E0      ;6
_L9893  bne     _L9898     ;2+
        jmp     L991C      ;3

_L9898  jmp     LA327      ;3

        .byte   $A5
        .byte   $0C
        .byte   $05
        .byte   $0E
        .byte   $48
        .byte   $A5
        .byte   $0D
        .byte   $48
        .byte   $A0
        .byte   $00
        .byte   $98
        .byte   $48
        .byte   $A5
        .byte   $46
        .byte   $48
        .byte   $A5
        .byte   $45
        .byte   $48
        .byte   $20
        .byte   $79
        .byte   $98
        .byte   $68
        .byte   $85
        .byte   $45
        .byte   $68
        .byte   $85
        .byte   $46
        .byte   $68
        .byte   $A8
        .byte   $BA
        .byte   $BD
        .byte   $02
        .byte   $01
        .byte   $48
        .byte   $BD
        .byte   $01
        .byte   $01
        .byte   $48
        .byte   $A5
        .byte   $64
        .byte   $9D
        .byte   $02
        .byte   $01
        .byte   $A5
        .byte   $65
        .byte   $9D
        .byte   $01
        .byte   $01
        .byte   $C8
        .byte   $84
        .byte   $0B
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $A4
        .byte   $0B
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $CE
        .byte   $20
        .byte   $8B
        .byte   $94
        .byte   $68
        .byte   $85
        .byte   $0D
        .byte   $68
        .byte   $85
        .byte   $0E
        .byte   $29
        .byte   $7F
        .byte   $85
        .byte   $0C
        .byte   $A6
        .byte   $2F
        .byte   $A5
        .byte   $30
        .byte   $86
        .byte   $5F
        .byte   $85
        .byte   $60
        .byte   $C5
        .byte   $32
        .byte   $D0
        .byte   $04
        .byte   $E4
        .byte   $31
        .byte   $F0
        .byte   $46
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $D1
        .byte   $04
        .text   "HEeP"
        .byte   $0B
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $46
        .byte   $C5
        .byte   $78
        .byte   $F0
        .byte   $18
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $18
        .byte   $65
        .byte   $5F
        .byte   $AA
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $65
        .byte   $60
        .byte   $90
        .byte   $CF
        .byte   $A2
        .byte   $12
        .byte   $2C

L991C   ldx     #$0E       ;2
        jmp     L8683      ;3

        .byte   $A2
        .byte   $13
        .byte   $A5
        .byte   $0C
        .byte   $D0
        .byte   $F7
        .byte   $20
        .byte   $5B
        .byte   $98
        .byte   $A0
        .byte   $04
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $A5
        .byte   $0B
        .byte   $C5
        .byte   $78
        .byte   $D0
        .byte   $E2
        .text   "lC",$99," [",$98," #"
        .byte   $89
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $72
        .byte   $A2
        .byte   $05
        .byte   $A5
        .byte   $45
        .byte   $91
        .byte   $5F
        .byte   $10
        .byte   $01
        .byte   $CA
        .byte   $C8
        .byte   $A5
        .byte   $46
        .byte   $91
        .byte   $5F
        .byte   $10
        .byte   $02
        .byte   $CA
        .byte   $CA
        .byte   $86
        .byte   $71
        .byte   $A5
        .byte   $0B
        .byte   $C8
        .byte   $C8
        .byte   $C8
        .byte   $91
        .byte   $5F
        .byte   $A2
        .byte   $0B
        .byte   $A9
        .byte   $00
        .byte   $24
        .byte   $0C
        .byte   $50
        .byte   $08
        .byte   $68
        .byte   $18
        .byte   $69
        .byte   $01
        .byte   $AA
        .byte   $68
        .byte   $69
        .byte   $00
        .byte   $C8
        .byte   $91
        .byte   $5F
        .byte   $C8
        .byte   $8A
        .byte   $91
        .byte   $5F
        .byte   $20
        .byte   $2F
        .byte   $9A
        .byte   $86
        .byte   $71
        .byte   $85
        .byte   $72
        .byte   $A4
        .byte   $22
        .byte   $C6
        .byte   $0B
        .byte   $D0
        .byte   $DC
        .byte   $65
        .byte   $59
        .byte   $B0
        .byte   $67
        .byte   $85
        .byte   $59
        .byte   $A8
        .byte   $8A
        .byte   $65
        .byte   $58
        .byte   $90
        .byte   $03
        .byte   $C8
        .byte   $F0
        .byte   $5C
        .byte   $20
        .byte   $23
        .byte   $89
        .byte   $85
        .byte   $31
        .byte   $84
        .byte   $32
        .byte   $A9
        .byte   $00
        .byte   $E6
        .byte   $72
        .byte   $A4
        .byte   $71
        .byte   $F0
        .byte   $05
        .byte   $88
        .byte   $91
        .byte   $58
        .byte   $D0
        .byte   $FB
        .byte   $C6
        .byte   $59
        .byte   $C6
        .byte   $72
        .byte   $D0
        .byte   $F5
        .byte   $E6
        .byte   $59
        .byte   $38
        .byte   $A5
        .byte   $31
        .byte   $E5
        .byte   $5F
        .byte   $A0
        .byte   $02
        .byte   $91
        .byte   $5F
        .byte   $A5
        .byte   $32
        .byte   $C8
        .byte   $E5
        .byte   $60
        .byte   $91
        .byte   $5F
        .byte   $A5
        .byte   $0C
        .byte   $D0
        .byte   $6C
        .byte   $C8
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $0B
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $71
        .byte   $85
        .byte   $72
        .byte   $C8
        .byte   $68
        .byte   $AA
        .byte   $85
        .byte   $64
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $68
        .byte   $85
        .byte   $65
        .byte   $C5
        .byte   $78
        .text   $90,$12,"P",$0A,"H Q"
        .byte   $04
        .byte   $85
        .byte   $78
        .byte   $E4
        .byte   $78
        .byte   $90
        .byte   $07
        .byte   $4C
        .byte   $19
        .byte   $99
        .byte   $4C
        .byte   $81
        .byte   $86
        .byte   $C8
        .byte   $A5
        .byte   $72
        .byte   $05
        .byte   $71
        .byte   $18
        .byte   $F0
        .text   $0A," /",$9A
        .byte   $8A
        .byte   $65
        .byte   $64
        .byte   $AA
        .byte   $98
        .byte   $A4
        .byte   $22
        .byte   $65
        .byte   $65
        .byte   $86
        .byte   $71
        .byte   $C6
        .byte   $0B
        .byte   $D0
        .byte   $C1
        .byte   $85
        .byte   $72
        .byte   $A2
        .byte   $05
        .byte   $A5
        .byte   $45
        .byte   $10
        .byte   $01
        .byte   $CA
        .byte   $A5
        .byte   $46
        .byte   $10
        .byte   $02
        .byte   $CA
        .byte   $CA
        .byte   $86
        .byte   $28
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $3A
        .byte   $9A
        .byte   $8A
        .byte   $65
        .byte   $58
        .byte   $85
        .byte   $47
        .byte   $98
        .byte   $65
        .byte   $59
        .byte   $85
        .byte   $48
        .byte   $A8
        .byte   $A5
        .byte   $47
        .byte   $60
        .byte   $84
        .byte   $22
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $28
        .byte   $88
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $29
        .byte   $A9
        .byte   $10
        .byte   $85
        .byte   $5D
        .byte   $A2
        .byte   $00
        .byte   $A0
        .byte   $00
        .byte   $8A
        .byte   $0A
        .byte   $AA
        .byte   $98
        .byte   $2A
        .byte   $A8
        .byte   $B0
        .byte   $A2
        .byte   $06
        .byte   $71
        .byte   $26
        .byte   $72
        .byte   $90
        .byte   $0B
        .byte   $18
        .byte   $8A
        .byte   $65
        .byte   $28
        .byte   $AA
        .byte   $98
        .byte   $65
        .byte   $29
        .byte   $A8
        .byte   $B0
        .byte   $91
        .byte   $C6
        .byte   $5D
        .byte   $D0
        .byte   $E3
        .byte   $60
        .byte   $A5
        .byte   $0D
        .byte   $F0
        .byte   $03
        .text   " n",$9C," t"
        .byte   $A9
        .byte   $38
        .byte   $A5
        .byte   $33
        .byte   $E5
        .byte   $31
        .byte   $A8
        .byte   $A5
        .byte   $34
        .byte   $E5
        .text   "2 ",$92,$9A,"8lN"
        .byte   $A2
        .byte   $38
        .byte   $20
        .byte   $F0
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $4C
        .byte   $71
        .byte   $94
        .byte   $24
        .byte   $81
        .byte   $30
        .byte   $A4
        .byte   $A2
        .byte   $15
        .byte   $2C
        .byte   $A2
        .byte   $1B
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $0D
        .byte   $85
        .byte   $62
        .byte   $84
        .byte   $63
        .byte   $A2
        .byte   $90
        .byte   $60
        .text   " K",$9A," "
        .byte   $86
        .byte   $9A
        .byte   $20
        .byte   $8E
        .byte   $94
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $10
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $20
        .byte   $17
        .byte   $93
        .byte   $20
        .byte   $8B
        .byte   $94
        .byte   $A9
        .byte   $B2
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $48
        .byte   $A5
        .byte   $48
        .byte   $48
        .byte   $A5
        .byte   $47
        .byte   $48
        .byte   $A5
        .byte   $3C
        .byte   $48
        .byte   $A5
        .byte   $3B
        .byte   $48
        .byte   $20
        .byte   $B0
        .byte   $8D
        .byte   $4C
        .byte   $3E
        .byte   $9B
        .byte   $A9
        .byte   $A5
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $09
        .byte   $80
        .byte   $85
        .byte   $10
        .byte   $20
        .byte   $AC
        .byte   $96
        .byte   $85
        .byte   $4E
        .byte   $84
        .byte   $4F
        .byte   $4C
        .byte   $17
        .text   $93," K",$9A
        .byte   $A5
        .byte   $4F
        .byte   $48
        .byte   $A5
        .byte   $4E
        .byte   $48
        .byte   $20
        .byte   $85
        .byte   $94
        .byte   $20
        .byte   $17
        .byte   $93
        .byte   $68
        .byte   $85
        .byte   $4E
        .byte   $68
        .byte   $85
        .byte   $4F
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $59
        .byte   $81
        .byte   $85
        .byte   $47
        .byte   $AA
        .text   "H y",$81
        .byte   $F0
        .byte   $8C
        .byte   $85
        .byte   $48
        .byte   $C8
        .byte   $20
        .byte   $61
        .byte   $81
        .byte   $48
        .byte   $88
        .byte   $10
        .byte   $F9
        .byte   $A4
        .byte   $48
        .byte   $20
        .byte   $59
        .byte   $A2
        .byte   $A5
        .byte   $3C
        .byte   $48
        .byte   $A5
        .text   ";h y",$81
        .byte   $85
        .text   ";H y",$81
        .byte   $85
        .byte   $3C
        .byte   $A5
        .byte   $48
        .byte   $48
        .byte   $A5
        .byte   $47
        .byte   $48
        .byte   $20
        .byte   $14
        .byte   $93
        .byte   $68
        .byte   $85
        .byte   $4E
        .byte   $68
        .byte   $85
        .byte   $4F
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $68
        .byte   $85
        .byte   $3B
        .byte   $68
        .byte   $85
        .byte   $3C
        .byte   $A0
        .byte   $00
        .byte   $68
        .byte   $91
        .byte   $4E
        .byte   $68
        .byte   $C8
        .byte   $91
        .byte   $4E
        .byte   $68
        .byte   $C8
        .byte   $91
        .byte   $4E
        .byte   $68
        .byte   $C8
        .byte   $91
        .byte   $4E
        .byte   $68
        .byte   $C8
        .byte   $91
        .byte   $4E
        .byte   $60

L9B54   ldx     $64        ;3
        ldy     $65        ;3
        stx     $50        ;3
        sty     $51        ;3
        jsr     LA906      ;6
        stx     $62        ;3
        sty     $63        ;3
        sta     $61        ;3
        rts                ;6

        .byte   $20
        .byte   $17
        .byte   $93
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $71
        .byte   $A4
        .byte   $68
        .byte   $68
        .byte   $A9
        .byte   $FF
        .byte   $A0
        .byte   $00
        .byte   $A2
        .byte   $22
        .byte   $86
        .byte   $07
        .byte   $86
        .byte   $08
        .byte   $85
        .byte   $6F
        .byte   $84
        .byte   $70
        .byte   $85
        .byte   $62
        .byte   $84
        .byte   $63
        .byte   $A0
        .byte   $FF
        .byte   $C8
        .byte   $20
        .byte   $C6
        .byte   $04
        .byte   $F0
        .byte   $0C
        .byte   $C5
        .byte   $07
        .byte   $F0
        .byte   $04
        .byte   $C5
        .byte   $08
        .byte   $D0
        .byte   $F2
        .byte   $C9
        .byte   $22
        .byte   $F0
        .byte   $01
        .byte   $18
        .byte   $84
        .byte   $61
        .byte   $98
        .byte   $65
        .byte   $6F
        .byte   $85
        .byte   $71
        .byte   $A6
        .byte   $70
        .byte   $90
        .byte   $01
        .byte   $E8
        .byte   $86
        .byte   $72
        .text   $98," t",$9B
        .byte   $A6
        .byte   $6F
        .byte   $A4
        .byte   $70
        .byte   $20
        .byte   $2C
        .byte   $9C

L9BB0   ldx     $16        ;3
        cpx     #$22       ;2
        bne     _L9BBB     ;2+
        ldx     #$19       ;2
        jmp     L8683      ;3

_L9BBB  lda     $61        ;3
        sta     $00,x      ;4
        lda     $62        ;3
        sta     $01,x      ;4
        lda     $63        ;3
        sta     $02,x      ;4
        ldy     #$00       ;2
        stx     $64        ;3
        sty     $65        ;3
        sty     $70        ;3
        dey                ;2
        sty     $0D        ;3
        stx     $17        ;3
        inx                ;2
        inx                ;2
        inx                ;2
        stx     $16        ;3
        rts                ;6

L9BDA   lda     $65        ;3
        pha                ;3
        lda     $64        ;3
        pha                ;3
        jsr     L9414      ;6
        jsr     L931A      ;6
        pla                ;4
        sta     $6F        ;3
        pla                ;4
        sta     $70        ;3
        ldy     #$00       ;2
        jsr     $04C6      ;6
        sta     $78        ;3
        jsr     $04DC      ;6
        clc                ;2
        adc     $78        ;3
        bcc     _L9BFE     ;2+
        jmp     LCC4C      ;3

_L9BFE  jsr     L9B54      ;6
        jsr     _L9C1B     ;6
        lda     $50        ;3
        ldy     $51        ;3
        jsr     L9C52      ;6
        jsr     _L9C30     ;6
        lda     $6F        ;3
        ldy     $70        ;3
        jsr     L9C52      ;6
        jsr     L9BB0      ;6
        jmp     L9346      ;3

_L9C1B  ldy     #$00       ;2
        jsr     $04C6      ;6
        pha                ;3
        iny                ;2
        jsr     $04C6      ;6
        tax                ;2
        iny                ;2
        jsr     $04C6      ;6
        tay                ;2
        pla                ;4
        stx     $22        ;3
        sty     $23        ;3
_L9C30  tay                ;2
        beq     _L9C3E     ;2+
        pha                ;3
_L9C34  dey                ;2
        jsr     $04B0      ;6
        sta     ($35),y    ;6
        tya                ;2
        bne     _L9C34     ;2+
        pla                ;4
_L9C3E  clc                ;2
        adc     $35        ;3
        sta     $35        ;3
        bcc     _L9C47     ;2+
        inc     $36        ;5
_L9C47  rts                ;6

L9C48   jsr     L932C      ;6
        jsr     L931A      ;6
        lda     $64        ;3
        ldy     $65        ;3
L9C52   sta     $22        ;3
        sty     $23        ;3
        jsr     _L9CAA     ;6
        bne     _L9C94     ;2+
        jsr     L8F9C      ;6
        bcc     _L9C94     ;2+
        dey                ;2
        lda     #$FF       ;2
        sta     ($22),y    ;6
        dey                ;2
        txa                ;2
        sta     ($22),y    ;6
        pha                ;3
        eor     #$FF       ;2
        sec                ;2
        adc     $22        ;3
        ldy     $23        ;3
        bcs     _L9C74     ;2+
        dey                ;2
_L9C74  sta     $22        ;3
        sty     $23        ;3
        tax                ;2
        pla                ;4
        cpy     $34        ;3
        bne     _L9CBA     ;2+
        cpx     $33        ;3
        bne     _L9CBA     ;2+
        pha                ;3
        sec                ;2
        adc     $33        ;3
        sta     $33        ;3
        bcc     _L9C8C     ;2+
        inc     $34        ;5
_L9C8C  inc     $33        ;5
        bne     _L9C92     ;2+
        inc     $34        ;5
_L9C92  pla                ;4
        rts                ;6

_L9C94  ldy     #$00       ;2
        jsr     $04B0      ;6
        pha                ;3
        iny                ;2
        jsr     $04B0      ;6
        tax                ;2
        iny                ;2
        jsr     $04B0      ;6
        tay                ;2
        stx     $22        ;3
        sty     $23        ;3
        pla                ;4
        rts                ;6

_L9CAA  cpy     $18        ;3
        bne     _L9CBA     ;2+
        cmp     $17        ;3
        bne     _L9CBA     ;2+
        sta     $16        ;3
        sbc     #$03       ;2
        sta     $17        ;3
        ldy     #$00       ;2
_L9CBA  rts                ;6

        .byte   $20
        .byte   $87
        .byte   $9D
        .byte   $8A
        .byte   $48
        .byte   $A9
        .byte   $01
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $68
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $62
        .byte   $68
        .byte   $68
        .byte   $4C
        .byte   $B0
        .byte   $9B
        .byte   $20
        .byte   $46
        .byte   $9D
        .text   "h ",$81,$81
        .byte   $85
        .byte   $78
        .byte   $68
        .byte   $C5
        .byte   $78
        .text   $98,$90,$05," ",$81,$81
        .byte   $AA
        .byte   $98
        .byte   $48
        .byte   $8A
        .byte   $48
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $A5
        .byte   $50
        .byte   $A4
        .text   "q r",$9C
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $18
        .byte   $65
        .byte   $22
        .byte   $85
        .byte   $22
        .byte   $90
        .byte   $02
        .byte   $E6
        .text   "#",$98," 0",$9C,"l"
        .byte   $B0
        .byte   $9B
        .byte   $20
        .byte   $46
        .byte   $9D
        .text   "h ",$81,$81
        .byte   $85
        .byte   $78
        .byte   $68
        .byte   $18
        .byte   $E5
        .byte   $78
        .byte   $49
        .byte   $FF
        .byte   $4C
        .byte   $DC
        .byte   $9C
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $65
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $29
        .byte   $F0
        .byte   $06
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $20
        .byte   $46
        .byte   $9D
        .byte   $F0
        .byte   $53
        .byte   $CA
        .byte   $8A
        .byte   $48
        .byte   $A2
        .byte   $00
        .text   "h ",$81,$81
        .byte   $85
        .byte   $78
        .byte   $68
        .byte   $18
        .byte   $E5
        .byte   $78
        .byte   $B0
        .byte   $A8
        .byte   $49
        .byte   $FF
        .byte   $C5
        .byte   $65
        .byte   $90
        .byte   $A3
        .byte   $A5
        .byte   $65
        .byte   $B0
        .byte   $9F
        .byte   $20
        .byte   $8B
        .byte   $94
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $85
        .byte   $55
        .byte   $68
        .byte   $68
        .byte   $68
        .byte   $AA
        .byte   $68
        .byte   $85
        .byte   $50
        .byte   $68
        .byte   $85
        .byte   $51
        .byte   $A5
        .text   "uh",$98,"h"
        .byte   $A0
        .byte   $00
        .byte   $8A
        .byte   $60
        .byte   $20
        .byte   $67
        .byte   $9D
        .text   "l",$81,$9A," k",$9C
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $0D
        .byte   $A8
        .byte   $60
        .byte   $20
        .byte   $67
        .byte   $9D
        .byte   $F0
        .byte   $06
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $A8
        .byte   $4C
        .byte   $81
        .byte   $9A

L9D7E   jmp     L991C      ;3

        .byte   $20
        .byte   $73
        .byte   $04

L9D84   jsr     L9314      ;6
        jsr     L987F      ;6
        ldx     $64        ;3
        bne     L9D7E      ;2+
        ldx     $65        ;3
        jmp     $0479      ;3

        .byte   $20
        .byte   $67
        .byte   $9D
        .byte   $F0
        .byte   $37
        .byte   $A6
        .byte   $3B
        .byte   $A4
        .byte   $3C
        .byte   $86
        .byte   $71
        .byte   $84
        .byte   $72
        .byte   $A6
        .byte   $22
        .byte   $86
        .byte   $3B
        .byte   $18
        .byte   $65
        .byte   $22
        .byte   $85
        .byte   $24
        .byte   $A6
        .byte   $23
        .byte   $86
        .byte   $3C
        .byte   $90
        .byte   $01
        .byte   $E8
        .byte   $86
        .byte   $25
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $48
        .byte   $98
        .byte   $91
        .byte   $24
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $20
        .byte   $7F
        .byte   $A3
        .byte   $68
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $24
        .byte   $A6
        .byte   $71
        .byte   $A4
        .byte   $72
        .byte   $86
        .byte   $3B
        .byte   $84
        .byte   $3C
        .byte   $60
        .text   "l+",$9F," "
        .byte   $14
        .byte   $93
        .byte   $20
        .byte   $E4
        .byte   $9D
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $4C
        .byte   $84
        .byte   $9D
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $14
        .byte   $93
        .byte   $A5
        .byte   $66
        .byte   $30
        .byte   $96
        .byte   $A5
        .byte   $61
        .byte   $C9
        .byte   $91
        .byte   $B0
        .byte   $90
        .byte   $20
        .byte   $27
        .byte   $A3
        .byte   $A5
        .byte   $64
        .byte   $A4
        .byte   $65
        .byte   $84
        .byte   $14
        .byte   $85
        .byte   $15
        .byte   $60
        .byte   $A5
        .byte   $15
        .byte   $48
        .byte   $A5
        .byte   $14
        .byte   $48
        .byte   $20
        .byte   $E4
        .byte   $9D
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $5D
        .byte   $81
        .byte   $A8
        .byte   $68
        .byte   $85
        .byte   $14
        .byte   $68
        .byte   $85
        .byte   $15
        .text   "l",$81,$9A," R"
        .byte   $9D
        .byte   $8A
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $14
        .byte   $60
        .byte   $20
        .byte   $67
        .byte   $9D
        .byte   $85
        .byte   $24
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $25
        .byte   $84
        .byte   $71
        .byte   $84
        .byte   $72
        .byte   $C4
        .byte   $24
        .byte   $F0
        .byte   $34
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $C8
        .byte   $C9
        .byte   $20
        .byte   $F0
        .byte   $F4
        .byte   $E6
        .byte   $25
        .byte   $A6
        .byte   $25
        .byte   $E0
        .byte   $05
        .byte   $F0
        .text   "+I0",$90,"'I:",$90,$0A,"Ia",$90,$1F,"Ig"
        .byte   $B0
        .byte   $1B
        .byte   $E9
        .byte   $07
        .byte   $E9
        .text   "/",$0A,$0A,$0A,$0A
        .byte   $A2
        .byte   $04
        .byte   $0A
        .byte   $26
        .byte   $71
        .byte   $26
        .byte   $72
        .byte   $CA
        .byte   $D0
        .byte   $F8
        .byte   $F0
        .byte   $C8
        .byte   $A4
        .byte   $71
        .byte   $A5
        .byte   $72
        .byte   $4C
        .byte   $76
        .text   $9A,"l",$1C,$99," R"
        .byte   $9D
        .byte   $86
        .byte   $49
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $86
        .byte   $4A
        .byte   $A0
        .byte   $00
        .text   " ]",$81,"ej%i"
        .byte   $F0
        .byte   $F7
        .byte   $60
        .byte   $A5
        .byte   $66
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $66
        .byte   $45
        .byte   $6E
        .byte   $85
        .byte   $6F
        .byte   $A5
        .byte   $61
        .text   "l",$9E,$9E," M",$9F,$90,"< ",$07
        .byte   $A1
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $81
        .byte   $A2
        .byte   $A6
        .byte   $70
        .byte   $86
        .byte   $56
        .byte   $A2
        .byte   $69
        .byte   $A5
        .byte   $69
        .byte   $A8
        .byte   $F0
        .byte   $D8
        .byte   $38
        .byte   $E5
        .byte   $61
        .byte   $F0
        .byte   $24
        .byte   $90
        .byte   $12
        .byte   $84
        .byte   $61
        .byte   $A4
        .byte   $6E
        .byte   $84
        .byte   $66
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $00
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $56
        .byte   $A2
        .byte   $61
        .byte   $D0
        .byte   $04
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $70
        .byte   $C9
        .byte   $F9
        .byte   $30
        .byte   $C7
        .byte   $A8
        .byte   $A5
        .byte   $70
        .byte   $56
        .byte   $01
        .byte   $20
        .byte   $E4
        .byte   $9F
        .byte   $24
        .byte   $6F
        .byte   $10
        .byte   $57
        .byte   $A0
        .byte   $61
        .byte   $E0
        .byte   $69
        .byte   $F0
        .byte   $02
        .byte   $A0
        .byte   $69
        .byte   $38
        .byte   $49
        .byte   $FF
        .byte   $65
        .byte   $56
        .byte   $85
        .byte   $70
        .byte   $B9
        .byte   $04
        .byte   $00
        .byte   $F5
        .byte   $04
        .byte   $85
        .byte   $65
        .byte   $B9
        .byte   $03
        .byte   $00
        .byte   $F5
        .byte   $03
        .byte   $85
        .byte   $64
        .byte   $B9
        .byte   $02
        .byte   $00
        .byte   $F5
        .byte   $02
        .byte   $85
        .byte   $63
        .byte   $B9
        .byte   $01
        .byte   $00
        .byte   $F5
        .byte   $01
        .byte   $85
        .byte   $62
        .byte   $B0
        .byte   $03
        .byte   $20
        .byte   $7B
        .byte   $9F
        .byte   $A0
        .byte   $00
        .byte   $98
        .byte   $18
        .byte   $A6
        .byte   $62
        .byte   $D0
        .byte   $4A
        .byte   $A6
        .byte   $63
        .byte   $86
        .byte   $62
        .byte   $A6
        .byte   $64
        .byte   $86
        .byte   $63
        .byte   $A6
        .byte   $65
        .byte   $86
        .byte   $64
        .byte   $A6
        .byte   $70
        .byte   $86
        .byte   $65
        .byte   $84
        .byte   $70
        .byte   $69
        .byte   $08
        .byte   $C9
        .byte   $20
        .byte   $D0
        .byte   $E4
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $61
        .byte   $85
        .byte   $66
        .byte   $60
        .byte   $65
        .byte   $56
        .byte   $85
        .byte   $70
        .byte   $A5
        .byte   $65
        .byte   $65
        .byte   $6D
        .byte   $85
        .byte   $65
        .byte   $A5
        .byte   $64
        .byte   $65
        .byte   $6C
        .byte   $85
        .byte   $64
        .byte   $A5
        .byte   $63
        .byte   $65
        .byte   $6B
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $62
        .byte   $65
        .byte   $6A
        .byte   $85
        .byte   $62
        .byte   $4C
        .byte   $6A
        .byte   $9F
        .byte   $69
        .byte   $01
        .byte   $06
        .byte   $70
        .byte   $26
        .byte   $65
        .byte   $26
        .byte   $64
        .byte   $26
        .byte   $63
        .byte   $26
        .byte   $62
        .byte   $10
        .byte   $F2
        .byte   $38
        .byte   $E5
        .byte   $61
        .byte   $B0
        .byte   $C7
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $01
        .byte   $85
        .byte   $61
        .byte   $90
        .byte   $0E

L9F6C   inc     $61        ;5
        beq     L9FB2      ;2+
        ror     $62        ;5
        ror     $63        ;5
        ror     $64        ;5
        ror     $65        ;5
        ror     $70        ;5
        rts                ;6

        .byte   $A5
        .byte   $66
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $66

L9F81   lda     $62        ;3
        eor     #$FF       ;2
        sta     $62        ;3
        lda     $63        ;3
        eor     #$FF       ;2
        sta     $63        ;3
        lda     $64        ;3
        eor     #$FF       ;2
        sta     $64        ;3
        lda     $65        ;3
        eor     #$FF       ;2
        sta     $65        ;3
        lda     $70        ;3
        eor     #$FF       ;2
        sta     $70        ;3
        inc     $70        ;5
        bne     L9FB1      ;2+
L9FA3   inc     $65        ;5
        bne     L9FB1      ;2+
        inc     $64        ;5
        bne     L9FB1      ;2+
        inc     $63        ;5
        bne     L9FB1      ;2+
        inc     $62        ;5
L9FB1   rts                ;6

L9FB2   ldx     #$0F       ;2
        jmp     L8683      ;3

        .byte   $A2
        .byte   $25

L9FB9   ldy     $04,x      ;4
        sty     $70        ;3
        ldy     $03,x      ;4
        sty     $04,x      ;4
        ldy     $02,x      ;4
        sty     $03,x      ;4
        ldy     $01,x      ;4
        sty     $02,x      ;4
        ldy     $68        ;3
        sty     $01,x      ;4
L9FCD   adc     #$08       ;2
        bmi     L9FB9      ;2+
        beq     L9FB9      ;2+
        sbc     #$08       ;2
        tay                ;2
        lda     $70        ;3
        bcs     L9FEE      ;2+
L9FDA   asl     $01,x      ;6
        bcc     _L9FE0     ;2+
        inc     $01,x      ;6
_L9FE0  ror     $01,x      ;6
        ror     $01,x      ;6
L9FE4   ror     $02,x      ;6
        ror     $03,x      ;6
        ror     $04,x      ;6
        ror     a          ;2
        iny                ;2
        bne     L9FDA      ;2+
L9FEE   clc                ;2
        rts                ;6

        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $7F
        .byte   $5E
        .byte   $56
        .byte   $CB
        .byte   $79
        .byte   $80
        .byte   $13
        .byte   $9B
        .byte   $0B
        .byte   $64
        .byte   $80
        .byte   $76
        .byte   $38
        .byte   $93
        .byte   $16
        .byte   $82
        .byte   $38
        .byte   $AA
        .byte   $3B
        .byte   $20
        .byte   $80
        .byte   $35
        .byte   $04
        .byte   $F3
        .byte   $34
        .byte   $81
        .byte   $35
        .byte   $04
        .byte   $F3
        .byte   $34
        .byte   $80
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $80
        .byte   $31
        .byte   $72
        .byte   $17
        .byte   $F8
        .byte   $20
        .byte   $B0
        .byte   $A2
        .byte   $F0
        .byte   $02
        .byte   $10
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $A5
        .byte   $61
        .byte   $E9
        .byte   $7F
        .byte   $48
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $61
        .byte   $A9
        .byte   $0A
        .byte   $A0
        .byte   $A0
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $A9
        .byte   $0F
        .byte   $A0
        .byte   $A0
        .byte   $20
        .byte   $72
        .byte   $A0
        .byte   $A9
        .byte   $F0
        .byte   $A0
        .byte   $9F
        .byte   $20
        .byte   $6C
        .byte   $A0
        .byte   $A9
        .byte   $F5
        .byte   $A0
        .byte   $9F
        .byte   $20
        .byte   $B3
        .byte   $A6
        .byte   $A9
        .byte   $14
        .byte   $A0
        .byte   $A0
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $68
        .byte   $20
        .byte   $0A
        .byte   $A4
        .byte   $A9
        .byte   $19
        .byte   $A0
        .byte   $A0
        .byte   $20
        .byte   $DC
        .byte   $A0
        .byte   $4C
        .byte   $7B
        .byte   $A0
        .byte   $A9
        .byte   $A3
        .byte   $A0
        .byte   $A5
        .byte   $20
        .byte   $DC
        .byte   $A0
        .text   "l",$9E,$9E," "
        .byte   $DC
        .byte   $A0
        .byte   $4C
        .byte   $87
        .byte   $9E
        .byte   $20
        .byte   $DC
        .byte   $A0
        .byte   $4C
        .byte   $97
        .byte   $A1
        .byte   $20
        .byte   $07
        .byte   $A1
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $DB
        .byte   $A0
        .byte   $20
        .byte   $37
        .byte   $A1
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $26
        .byte   $85
        .byte   $27
        .byte   $85
        .byte   $28
        .byte   $85
        .byte   $29
        .byte   $A5
        .byte   $70
        .byte   $20
        .byte   $A9
        .byte   $A0
        .byte   $A5
        .byte   $65
        .byte   $20
        .byte   $A9
        .byte   $A0
        .byte   $A5
        .byte   $64
        .byte   $20
        .byte   $A9
        .byte   $A0
        .byte   $A5
        .byte   $63
        .byte   $20
        .byte   $A9
        .byte   $A0
        .byte   $A5
        .byte   $62
        .byte   $20
        .byte   $AE
        .byte   $A0
        .byte   $4C
        .byte   $0C
        .byte   $A2
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $B7
        .byte   $9F
        .byte   $4A
        .byte   $09
        .byte   $80
        .byte   $A8
        .byte   $90
        .byte   $19
        .byte   $18
        .byte   $A5
        .byte   $29
        .byte   $65
        .byte   $6D
        .byte   $85
        .byte   $29
        .byte   $A5
        .byte   $28
        .byte   $65
        .byte   $6C
        .byte   $85
        .byte   $28
        .byte   $A5
        .byte   $27
        .byte   $65
        .byte   $6B
        .byte   $85
        .byte   $27
        .byte   $A5
        .byte   $26
        .byte   $65
        .byte   $6A
        .byte   $85
        .byte   $26
        .byte   $66
        .byte   $26
        .byte   $66
        .byte   $27
        .byte   $66
        .byte   $28
        .byte   $66
        .byte   $29
        .byte   $66
        .byte   $70
        .text   $98,"jPV"
        .byte   $60
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $A0
        .byte   $04
        .byte   $B1
        .byte   $22
        .byte   $85
        .byte   $6D
        .byte   $88
        .byte   $B1
        .byte   $22
        .byte   $85
        .byte   $6C
        .byte   $88
        .byte   $B1
        .byte   $22
        .byte   $85
        .byte   $6B
        .byte   $88
        .byte   $B1
        .byte   $22
        .byte   $85
        .byte   $6E
        .byte   $45
        .byte   $66
        .byte   $85
        .byte   $6F
        .byte   $A5
        .byte   $6E
        .byte   $09
        .byte   $80
        .byte   $85
        .byte   $6A
        .byte   $88
        .byte   $B1
        .byte   $22
        .byte   $85
        .byte   $69
        .byte   $A5
        .byte   $61
        .byte   $60
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $A0
        .byte   $04
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $85
        .byte   $6D
        .byte   $88
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $85
        .byte   $6C
        .byte   $88
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $85
        .byte   $6B
        .byte   $88
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $85
        .byte   $6E
        .byte   $45
        .byte   $66
        .byte   $85
        .byte   $6F
        .byte   $A5
        .byte   $6E
        .byte   $09
        .byte   $80
        .byte   $85
        .byte   $6A
        .byte   $88
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $85
        .byte   $69
        .byte   $A5
        .byte   $61
        .byte   $60
        .byte   $A5
        .byte   $69
        .byte   $F0
        .byte   $1F
        .byte   $18
        .byte   $65
        .byte   $61
        .byte   $90
        .byte   $04
        .byte   $30
        .byte   $1D
        .byte   $18
        .byte   $2C
        .byte   $10
        .byte   $14
        .byte   $69
        .byte   $80
        .byte   $85
        .byte   $61
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $2F
        .byte   $9F
        .byte   $A5
        .byte   $6F
        .byte   $85
        .byte   $66
        .byte   $60
        .byte   $A5
        .byte   $66
        .byte   $49
        .byte   $FF
        .byte   $30
        .byte   $05
        .byte   $68
        .byte   $68
        .text   "l+",$9F,"l"
        .byte   $B2
        .byte   $9F
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $AA
        .byte   $F0
        .byte   $10
        .byte   $18
        .byte   $69
        .byte   $02
        .byte   $B0
        .byte   $F2
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $6F
        .byte   $20
        .byte   $AB
        .byte   $9E
        .byte   $E6
        .byte   $61
        .byte   $F0
        .byte   $E7
        .byte   $60
        .byte   $84
        .byte   $20
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $A2
        .byte   $14
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $A9
        .byte   $79
        .byte   $A0
        .byte   $A1
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $6F
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $4C
        .byte   $97
        .byte   $A1
        .byte   $20
        .byte   $07
        .byte   $A1
        .byte   $F0
        .byte   $E5
        .byte   $20
        .byte   $A0
        .byte   $A2
        .byte   $A9
        .byte   $00
        .byte   $38
        .byte   $E5
        .byte   $61
        .byte   $85
        .byte   $61
        .byte   $20
        .byte   $37
        .byte   $A1
        .byte   $E6
        .byte   $61
        .byte   $F0
        .byte   $B5
        .byte   $A2
        .byte   $FC
        .byte   $A9
        .byte   $01
        .byte   $A4
        .byte   $6A
        .byte   $C4
        .byte   $62
        .byte   $D0
        .byte   $10
        .byte   $A4
        .byte   $6B
        .byte   $C4
        .byte   $63
        .byte   $D0
        .byte   $0A
        .byte   $A4
        .byte   $6C
        .byte   $C4
        .byte   $64
        .byte   $D0
        .byte   $04
        .byte   $A4
        .byte   $6D
        .byte   $C4
        .byte   $65
        .byte   $08
        .byte   $2A
        .byte   $90
        .byte   $09
        .byte   $E8
        .byte   $95
        .byte   $29
        .byte   $F0
        .byte   $32
        .byte   $10
        .byte   $34
        .byte   $A9
        .byte   $01
        .byte   $28
        .byte   $B0
        .byte   $0E
        .byte   $06
        .byte   $6D
        .byte   $26
        .byte   $6C
        .byte   $26
        .byte   $6B
        .byte   $26
        .byte   $6A
        .byte   $B0
        .byte   $E6
        .byte   $30
        .byte   $CE
        .byte   $10
        .byte   $E2
        .byte   $A8
        .byte   $A5
        .byte   $6D
        .byte   $E5
        .byte   $65
        .byte   $85
        .byte   $6D
        .byte   $A5
        .byte   $6C
        .byte   $E5
        .byte   $64
        .byte   $85
        .byte   $6C
        .byte   $A5
        .byte   $6B
        .byte   $E5
        .byte   $63
        .byte   $85
        .byte   $6B
        .byte   $A5
        .byte   $6A
        .byte   $E5
        .byte   $62
        .byte   $85
        .byte   $6A
        .byte   $98
        .byte   $4C
        .byte   $D4
        .byte   $A1
        .byte   $A9
        .text   "@PN",$0A,$0A,$0A,$0A,$0A,$0A
        .byte   $85
        .byte   $70
        .byte   $28
        .byte   $A5
        .byte   $26
        .byte   $85
        .byte   $62
        .byte   $A5
        .byte   $27
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $28
        .byte   $85
        .byte   $64
        .byte   $A5
        .byte   $29
        .byte   $85
        .byte   $65
        .byte   $4C
        .byte   $0B
        .byte   $9F
        .byte   $18
        .byte   $24
        .byte   $38
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $A0
        .byte   $04
        .byte   $20
        .byte   $20
        .byte   $A3
        .byte   $85
        .byte   $65
        .byte   $88
        .byte   $20
        .byte   $20
        .byte   $A3
        .byte   $85
        .byte   $64
        .byte   $88
        .byte   $20
        .byte   $20
        .byte   $A3
        .byte   $85
        .byte   $63
        .byte   $88
        .byte   $20
        .byte   $20
        .byte   $A3
        .byte   $85
        .byte   $66
        .byte   $09
        .byte   $80
        .byte   $85
        .byte   $62
        .byte   $88
        .byte   $20
        .byte   $20
        .byte   $A3
        .byte   $85
        .byte   $61
        .byte   $84
        .byte   $70
        .byte   $60
        .byte   $A2
        .byte   $5C
        .byte   $2C
        .byte   $A2
        .byte   $57
        .byte   $A0
        .byte   $00
        .byte   $F0
        .byte   $04
        .byte   $A6
        .byte   $49
        .byte   $A4
        .byte   $4A
        .byte   $20
        .byte   $A0
        .byte   $A2
        .byte   $86
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $A0
        .byte   $04
        .byte   $A5
        .byte   $65
        .byte   $91
        .byte   $22
        .byte   $88
        .byte   $A5
        .byte   $64
        .byte   $91
        .byte   $22
        .byte   $88
        .byte   $A5
        .byte   $63
        .byte   $91
        .byte   $22
        .byte   $88
        .byte   $A5
        .byte   $66
        .byte   $09
        .byte   $7F
        .byte   $25
        .byte   $62
        .byte   $91
        .byte   $22
        .byte   $88
        .byte   $A5
        .byte   $61
        .byte   $91
        .byte   $22
        .byte   $84
        .byte   $70
        .byte   $60
        .byte   $A5
        .byte   $6E
        .byte   $85
        .byte   $66
        .byte   $A2
        .byte   $05
        .byte   $B5
        .byte   $68
        .byte   $95
        .byte   $60
        .byte   $CA
        .byte   $D0
        .byte   $F9
        .byte   $86
        .byte   $70
        .byte   $60
        .byte   $20
        .byte   $A0
        .byte   $A2
        .byte   $A2
        .byte   $06
        .byte   $B5
        .byte   $60
        .byte   $95
        .byte   $68
        .byte   $CA
        .byte   $D0
        .byte   $F9
        .byte   $86
        .byte   $70

LA29F   rts                ;6

LA2A0   lda     $61        ;3
        beq     LA29F      ;2+
        asl     $70        ;5
        bcc     LA29F      ;2+
        jsr     L9FA3      ;6
        bne     LA29F      ;2+
        jmp     L9F6C      ;3

LA2B0   lda     $61        ;3
        beq     LA2BD      ;2+
LA2B4   lda     $66        ;3
LA2B6   rol     a          ;2
        lda     #$FF       ;2
        bcs     LA2BD      ;2+
        lda     #$01       ;2
LA2BD   rts                ;6

        .byte   $20
        .byte   $B0
        .byte   $A2
        .byte   $85
        .byte   $62
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $63
        .byte   $A2
        .byte   $88
        .byte   $A5
        .byte   $62
        .byte   $49
        .byte   $FF
        .byte   $2A
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $65
        .byte   $85
        .byte   $64
        .byte   $86
        .byte   $61
        .byte   $85
        .byte   $70
        .byte   $85
        .byte   $66
        .byte   $4C
        .byte   $06
        .byte   $9F
        .byte   $46
        .byte   $66
        .byte   $60

LA2E0   sta     $24        ;3
        sty     $25        ;3
        ldy     #$00       ;2
        lda     ($24),y    ;5+
        iny                ;2
        tax                ;2
        beq     LA2B0      ;2+
        lda     ($24),y    ;5+
        eor     $66        ;3
        bmi     LA2B4      ;2+
        cpx     $61        ;3
LA2F4   bne     _LA317     ;3+
        lda     ($24),y    ;5+
        ora     #$80       ;2
        cmp     $62        ;3
        bne     _LA317     ;3+
        iny                ;2
        lda     ($24),y    ;5+
        cmp     $63        ;3
        bne     _LA317     ;2+
        iny                ;2
        lda     ($24),y    ;5+
        cmp     $64        ;3
        bne     _LA317     ;2+
        iny                ;2
        lda     #$7F       ;2
        cmp     $70        ;3
        lda     ($24),y    ;5+
        sbc     $65        ;3
        beq     LA346      ;2+
_LA317  lda     $66        ;3
        bcc     _LA31D     ;2+
        eor     #$FF       ;2
_LA31D  jmp     LA2B6      ;3

        .byte   $B1
        .byte   $22
        .byte   $B0
        .byte   $22
        .byte   $4C
        .byte   $B0
        .byte   $04

LA327   lda     $61        ;3
        beq     LA375      ;2+
        sec                ;2
        sbc     #$A0       ;2
        bit     $66        ;3
        bpl     _LA33B     ;2+
        tax                ;2
        lda     #$FF       ;2
        sta     $68        ;3
        jsr     L9F81      ;6
        txa                ;2
_LA33B  ldx     #$61       ;2
        cmp     #$F9       ;2
        bpl     LA347      ;2+
        jsr     L9FCD      ;6
        sty     $68        ;3
LA346   rts                ;6

LA347   tay                ;2
        lda     $66        ;3
        and     #$80       ;2
        lsr     $62        ;5
        ora     $62        ;3
        sta     $62        ;3
        jsr     L9FE4      ;6
        sty     $68        ;3
        rts                ;6

        .byte   $A5
        .byte   $61
        .byte   $C9
        .byte   $A0
        .byte   $B0
        .byte   $20
        .byte   $20
        .byte   $27
        .byte   $A3
        .byte   $84
        .byte   $70
        .byte   $A5
        .byte   $66
        .byte   $84
        .byte   $66
        .byte   $49
        .byte   $80
        .byte   $2A
        .byte   $A9
        .byte   $A0
        .byte   $85
        .byte   $61
        .byte   $A5
        .byte   $65
        .byte   $85
        .byte   $07
        .byte   $4C
        .byte   $06
        .byte   $9F

LA375   sta     $62        ;3
        sta     $63        ;3
        sta     $64        ;3
        sta     $65        ;3
        tay                ;2
        rts                ;6

        .byte   $A0
        .byte   $00
        .byte   $A2
        .byte   $0A
        .byte   $94
        .byte   $5D
        .byte   $CA
        .byte   $10
        .byte   $FB
        .byte   $90
        .byte   $0F
        .byte   $C9
        .byte   $2D
        .byte   $D0
        .byte   $04
        .byte   $86
        .byte   $67
        .byte   $F0
        .byte   $04
        .text   "I+P",$05," "
        .byte   $73
LA398   .byte   $04
        .text   $90,"[I."
        .byte   $F0
        .text   ".IeP0 "
        .byte   $73
        .byte   $04
        .byte   $90
        .byte   $17
        .byte   $C9
        .byte   $AB
        .byte   $F0
        .byte   $0E
        .byte   $C9
        .byte   $2D
        .byte   $F0
        .byte   $0A
        .byte   $C9
        .byte   $AA
        .byte   $F0
        .byte   $08
        .byte   $C9
        .byte   $2B
        .byte   $F0
        .byte   $04
        .byte   $D0
        .byte   $07
        .byte   $66
        .byte   $60
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $90
        .byte   $5C
        .byte   $24
        .byte   $60
        .byte   $10
        .byte   $0E
        .byte   $A9
        .byte   $00
        .byte   $38
        .byte   $E5
        .byte   $5E
        .byte   $4C
        .byte   $D5
        .byte   $A3
        .byte   $66
        .byte   $5F
        .byte   $24
        .byte   $5F
        .byte   $50
        .byte   $C3
        .byte   $A5
        .byte   $5E
        .byte   $38
        .byte   $E5
        .byte   $5D
        .byte   $85
        .byte   $5E
        .byte   $F0
        .byte   $12
        .byte   $10
        .byte   $09
        .byte   $20
        .byte   $83
        .byte   $A1
        .byte   $E6
        .byte   $5E
        .byte   $D0
        .byte   $F9
        .byte   $F0
        .byte   $07
        .byte   $20
        .byte   $62
        .byte   $A1
        .byte   $C6
        .byte   $5E
        .byte   $D0
        .byte   $F9
        .byte   $A5
        .byte   $67
        .byte   $30
        .byte   $01
        .byte   $60
        .byte   $4C
        .byte   $27
        .byte   $A6
        .byte   $48
        .byte   $24
        .byte   $5F
        .byte   $10
        .byte   $02
        .byte   $E6
        .byte   $5D
        .byte   $20
        .byte   $62
        .byte   $A1
        .byte   $68
        .byte   $38
        .byte   $E9
        .byte   $30
        .byte   $20
        .byte   $0A
        .byte   $A4
        .byte   $4C
        .byte   $96
        .byte   $A3
        .byte   $48
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $68
        .byte   $20
        .byte   $C1
        .byte   $A2
        .byte   $A5
        .byte   $6E
        .byte   $45
        .byte   $66
        .byte   $85
        .byte   $6F
        .byte   $A6
        .byte   $61
        .byte   $4C
        .byte   $9E
        .byte   $9E
        .byte   $A5
        .byte   $5E
        .byte   $C9
        .byte   $0A
        .byte   $90
        .byte   $09
        .byte   $A9
        .byte   $64
        .byte   $24
        .byte   $60
        .byte   $30
        .byte   $16
        .byte   $4C
        .byte   $B2
        .byte   $9F
        .byte   $0A
        .byte   $0A
        .byte   $18
        .byte   $65
        .byte   $5E
        .byte   $0A
        .byte   $18
        .byte   $A0
        .byte   $00
        .byte   $85
        .byte   $78
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $65
        .byte   $78
        .byte   $38
        .byte   $E9
        .byte   $30
        .byte   $85
        .byte   $5E
        .byte   $4C
        .byte   $BC
        .byte   $A3
        .byte   $9B
        .byte   $3E
        .byte   $BC
        .byte   $1F
        .byte   $FD
        .byte   $9E
        .byte   $6E
        .byte   $6B
        .byte   $27
        .byte   $FD
        .byte   $9E
        .byte   $6E
        .byte   $6B
        .byte   $28
        .byte   $00
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   " in "
        .byte   $00
        .byte   $A5
        .byte   $3A
        .byte   $A6
        .byte   $39
        .byte   $85
        .byte   $62
        .byte   $86
        .byte   $63
        .byte   $A2
        .text   $90,"8 N"
        .byte   $A2
        .byte   $20
        .byte   $71
        .byte   $A4
        .byte   $4C
        .byte   $88
        .byte   $90
        .byte   $A0
        .byte   $01
        .byte   $A9
        .byte   $20
        .byte   $24
        .byte   $66
        .byte   $10
        .byte   $02
        .byte   $A9
        .byte   $2D
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $85
        .byte   $66
        .byte   $84
        .byte   $71
        .byte   $C8
        .byte   $A9
        .byte   $30
        .byte   $A6
        .byte   $61
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $96
        .byte   $A5
        .byte   $A9
        .byte   $00
        .byte   $E0
        .byte   $80
        .byte   $F0
        .byte   $02
        .byte   $B0
        .byte   $09
        .byte   $A9
        .byte   $4E
        .byte   $A0
        .byte   $A4
        .byte   $20
        .byte   $5C
        .byte   $A0
        .byte   $A9
        .byte   $F7
        .byte   $85
        .byte   $5D
        .byte   $A9
        .byte   $49
        .byte   $A0
        .byte   $A4
        .byte   $20
        .byte   $E0
        .byte   $A2
        .byte   $F0
        .byte   $1E
        .byte   $10
        .byte   $12
        .byte   $A9
        .byte   $44
        .byte   $A0
        .byte   $A4
        .byte   $20
        .byte   $E0
        .byte   $A2
        .byte   $F0
        .byte   $02
        .byte   $10
        .byte   $0E
        .byte   $20
        .byte   $62
        .byte   $A1
        .byte   $C6
        .byte   $5D
        .byte   $D0
        .byte   $EE
        .byte   $20
        .byte   $83
        .byte   $A1
        .byte   $E6
        .byte   $5D
        .byte   $D0
        .byte   $DC
        .byte   $20
        .byte   $62
        .byte   $A0
        .byte   $20
        .byte   $27
        .byte   $A3
        .byte   $A2
        .byte   $01
        .byte   $A5
        .byte   $5D
        .byte   $18
        .byte   $69
        .byte   $0A
        .byte   $30
        .byte   $09
        .byte   $C9
        .byte   $0B
        .byte   $B0
        .byte   $06
        .byte   $69
        .byte   $FF
        .byte   $AA
        .byte   $A9
        .byte   $02
        .byte   $38
        .byte   $E9
        .byte   $02
        .byte   $85
        .byte   $5E
        .byte   $86
        .byte   $5D
        .byte   $8A
        .byte   $F0
        .byte   $02
        .byte   $10
        .byte   $13
        .byte   $A4
        .byte   $71
        .byte   $A9
        .byte   $2E
        .byte   $C8
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $8A
        .byte   $F0
        .byte   $06
        .byte   $A9
        .byte   $30
        .byte   $C8
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $84
        .byte   $71
        .byte   $A0
        .byte   $00
        .byte   $A2
        .byte   $80
        .byte   $A5
        .byte   $65
        .byte   $18
        .byte   $79
        .byte   $AB
        .byte   $A5
        .byte   $85
        .byte   $65
        .byte   $A5
        .byte   $64
        .byte   $79
        .byte   $AA
        .byte   $A5
        .byte   $85
        .byte   $64
        .byte   $A5
        .byte   $63
        .byte   $79
        .byte   $A9
        .byte   $A5
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $62
        .byte   $79
        .byte   $A8
        .byte   $A5
        .byte   $85
        .byte   $62
        .byte   $E8
        .byte   $B0
        .byte   $04
        .byte   $10
        .byte   $DE
        .byte   $30
        .byte   $02
        .byte   $30
        .byte   $DA
        .byte   $8A
        .byte   $90
        .byte   $04
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $0A
        .byte   $69
        .text   "/HHHH"
        .byte   $84
        .byte   $47
        .byte   $A4
        .byte   $71
        .byte   $C8
        .byte   $AA
        .byte   $29
        .byte   $7F
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $C6
        .byte   $5D
        .byte   $D0
        .byte   $06
        .byte   $A9
        .byte   $2E
        .byte   $C8
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $84
        .byte   $71
        .byte   $A4
        .byte   $47
        .byte   $8A
        .byte   $49
        .byte   $FF
        .byte   $29
        .byte   $80
        .byte   $AA
        .byte   $C0
        .byte   $24
        .byte   $F0
        .byte   $04
        .byte   $C0
        .byte   $3C
        .byte   $D0
        .byte   $A6
        .byte   $A4
        .byte   $71
        .byte   $B9
        .byte   $FF
        .byte   $00
        .byte   $88
        .byte   $C9
        .byte   $30
        .byte   $F0
        .byte   $F8
        .byte   $C9
        .byte   $2E
        .byte   $F0
        .byte   $01
        .byte   $C8
        .byte   $A9
        .byte   $2B
        .byte   $A6
        .byte   $5E
        .byte   $F0
        .byte   $2E
        .byte   $10
        .byte   $08
        .byte   $A9
        .byte   $00
        .byte   $38
        .byte   $E5
        .byte   $5E
        .byte   $AA
        .byte   $A9
        .byte   $2D
        .byte   $99
        .byte   $01
        .byte   $01
        .byte   $A9
        .byte   $45
        .byte   $99
        .byte   $00
        .byte   $01
        .byte   $8A
        .byte   $A2
        .byte   $2F
        .byte   $38
        .byte   $E8
        .byte   $E9
        .byte   $0A
        .byte   $B0
        .byte   $FB
        .byte   $69
        .byte   $3A
        .byte   $99
        .byte   $03
        .byte   $01
        .byte   $8A
        .byte   $99
        .byte   $02
        .byte   $01
        .byte   $A9
        .byte   $00
        .byte   $99
        .byte   $04
        .byte   $01
        .byte   $F0
        .byte   $08
        .byte   $99
        .byte   $FF
        .byte   $00
        .byte   $A9
        .byte   $00
        .byte   $99
        .byte   $00
        .byte   $01
        .byte   $A9
        .byte   $00
        .byte   $A0
        .byte   $01
        .byte   $60
        .byte   $80
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FA
        .byte   $0A
        .byte   $1F
        .byte   $00
        .byte   $00
        .byte   $98
        .byte   $96
        .byte   $80
        .byte   $FF
        .byte   $F0
        .byte   $BD
        .byte   $C0
        .byte   $00
        .byte   $01
        .byte   $86
        .byte   $A0
        .byte   $FF
        .byte   $FF
        .byte   $D8
        .byte   $F0
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $E8
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $9C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $0A
        .fill   5,$FF
        .byte   $DF
        .byte   $0A
        .byte   $80
        .byte   $00
        .byte   $03
        .byte   $4B
        .byte   $C0
        .byte   $FF
        .byte   $FF
        .byte   $73
        .byte   $60
        .byte   $00
        .byte   $00
        .byte   $0E
        .byte   $10
        .byte   $FF
        .byte   $FF
        .byte   $FD
        .byte   $A8
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $A9
        .byte   $A3
        .byte   $A0
        .byte   $A5
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $F0
        .byte   $70
        .byte   $A5
        .byte   $69
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $2D
        .byte   $9F
        .byte   $A2
        .byte   $4E
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $59
        .byte   $A2
        .byte   $A5
        .byte   $6E
        .byte   $10
        .byte   $0F
        .byte   $20
        .byte   $58
        .byte   $A3
        .byte   $A9
        .byte   $4E
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $E0
        .byte   $A2
        .byte   $D0
        .byte   $03
        .byte   $98
        .byte   $A4
        .byte   $07
        .byte   $20
        .byte   $83
        .byte   $A2
        .text   $98,"h ",$1E
        .byte   $A0
        .byte   $A9
        .byte   $4E
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $78
        .byte   $A0
        .byte   $20
        .byte   $60
        .byte   $A6
        .byte   $68
        .byte   $4A
        .byte   $90
        .byte   $0A
        .byte   $A5
        .byte   $61
        .byte   $F0
        .byte   $06
        .byte   $A5
        .byte   $66
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $66
        .byte   $60
        .byte   $81
        .byte   $38
        .byte   $AA
        .byte   $3B
        .byte   $29
        .byte   $07
        .byte   $71
        .text   "4x>v"
        .byte   $74
        .byte   $16
        .byte   $7E
        .byte   $B3
        .byte   $1B
        .byte   $77
        .byte   $2F
        .byte   $EE
        .byte   $E3
        .byte   $85
        .byte   $7A
        .byte   $1D
        .byte   $84
        .byte   $1C
        .byte   $2A
        .byte   $7C
        .byte   $63
        .byte   $59
        .byte   $58
        .byte   $0A
        .byte   $7E
        .byte   $75
        .byte   $FD
        .byte   $E7
        .byte   $C6
        .byte   $80
        .byte   $31
        .byte   $72
        .byte   $18
        .byte   $10
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $A9
        .byte   $32
        .byte   $A0
        .byte   $A6
        .byte   $20
        .byte   $5C
        .byte   $A0
        .byte   $A5
        .byte   $70
        .byte   $69
        .byte   $50
        .byte   $90
        .byte   $03
        .byte   $20
        .byte   $A8
        .byte   $A2
        .byte   $85
        .byte   $56
        .byte   $20
        .byte   $94
        .byte   $A2
        .byte   $A5
        .byte   $61
        .byte   $C9
        .byte   $88
        .byte   $90
        .byte   $03
        .byte   $20
        .byte   $54
        .byte   $A1
        .byte   $20
        .byte   $58
        .byte   $A3
        .byte   $A5
        .byte   $07
        .byte   $18
        .byte   $69
        .byte   $81
        .byte   $F0
        .byte   $F3
        .byte   $38
        .byte   $E9
        .byte   $01
        .byte   $48
        .byte   $A2
        .byte   $05
        .byte   $B5
        .byte   $69
        .byte   $B4
        .byte   $61
        .byte   $95
        .byte   $61
        .byte   $94
        .byte   $69
        .byte   $CA
        .byte   $10
        .byte   $F5
        .byte   $A5
        .byte   $56
        .byte   $85
        .byte   $70
        .byte   $20
        .byte   $87
        .byte   $9E
        .byte   $20
        .byte   $27
        .byte   $A6
        .byte   $A9
        .byte   $37
        .byte   $A0
        .byte   $A6
        .byte   $20
        .byte   $C9
        .byte   $A6
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $6F
        .byte   $68
        .byte   $20
        .byte   $39
        .byte   $A1
        .byte   $60
        .byte   $85
        .byte   $71
        .byte   $84
        .byte   $72
        .byte   $20
        .byte   $4F
        .byte   $A2
        .byte   $A9
        .byte   $57
        .byte   $20
        .byte   $78
        .byte   $A0
        .byte   $20
        .byte   $CD
        .byte   $A6
        .byte   $A9
        .byte   $57
        .byte   $A0
        .byte   $00
        .byte   $4C
        .byte   $78
        .byte   $A0
        .byte   $85
        .byte   $71
        .byte   $84
        .byte   $72
        .byte   $20
        .byte   $4C
        .byte   $A2
        .byte   $B1
        .byte   $71
        .byte   $85
        .byte   $67
        .byte   $A4
        .byte   $71
        .byte   $C8
        .byte   $98
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $72
        .byte   $85
        .byte   $71
        .byte   $A4
        .byte   $72
        .byte   $20
        .byte   $5C
        .byte   $A0
        .byte   $A5
        .byte   $71
        .byte   $A4
        .byte   $72
        .byte   $18
        .byte   $69
        .byte   $05
        .byte   $90
        .byte   $01
        .byte   $C8
        .byte   $85
        .byte   $71
        .byte   $84
        .byte   $72
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $A9
        .byte   $5C
        .byte   $A0
        .byte   $00
        .byte   $C6
        .byte   $67
        .byte   $D0
        .byte   $E4
        .byte   $60
        .byte   $98
        .byte   $35
        .byte   $44
        .byte   $7A
        .byte   $00
        .byte   $68
        .byte   $28
        .byte   $B1
        .byte   $46
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $A2
        .byte   $30
        .byte   $2E
        .byte   $D0
        .byte   $17
        .byte   $AD
        .byte   $00
        .byte   $FF
        .byte   $85
        .byte   $62
        .byte   $AD
        .byte   $01
        .byte   $FF
        .byte   $85
        .byte   $64
        .byte   $AD
        .byte   $02
        .byte   $FF
        .byte   $85
        .byte   $63
        .byte   $AD
        .byte   $03
        .byte   $FF
        .byte   $85
        .byte   $65
        .byte   $4C
        .byte   $4A
        .byte   $A7
        .byte   $A9
        .byte   $03
        .byte   $A0
        .byte   $05
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $A9
        .byte   $FD
        .byte   $A0
        .byte   $A6
        .byte   $20
        .byte   $5C
        .byte   $A0
        .byte   $A9
        .byte   $02
        .byte   $A0
        .byte   $A7
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $A6
        .byte   $65
        .byte   $A5
        .byte   $62
        .byte   $85
        .byte   $65
        .byte   $86
        .byte   $62
        .byte   $A6
        .byte   $63
        .byte   $A5
        .byte   $64
        .byte   $85
        .byte   $63
        .byte   $86
        .byte   $64
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $66
        .byte   $A5
        .byte   $61
        .byte   $85
        .byte   $70
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $61
        .byte   $20
        .byte   $0B
        .byte   $9F
        .byte   $A2
        .byte   $03
        .byte   $A0
        .byte   $05
        .byte   $4C
        .byte   $59
        .byte   $A2
        .byte   $A5
        .byte   $7C
        .byte   $85
        .byte   $3D
        .byte   $A5
        .byte   $7D
        .byte   $85
        .byte   $3E
        .byte   $60
        .byte   $A5
        .byte   $3D
        .byte   $85
        .byte   $7C
        .byte   $A5

LA76E   rol     L7D85,x    ;7
        rts                ;6

        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $7C
        .byte   $85
        .byte   $7C
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $7D
        .byte   $60
        .byte   $AA
        .byte   $D0
        .byte   $02
        .byte   $A2
        .byte   $1E
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $C0
        .byte   $FF
        .byte   $B0
        .byte   $F3
        .byte   $60
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $B0
        .byte   $ED
        .byte   $60
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $B0
        .byte   $E7
        .byte   $60
        .byte   $48
        .byte   $20
        .byte   $C9
        .byte   $FF
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $AA
        .byte   $68
        .byte   $90
        .byte   $03
        .byte   $8A
        .byte   $B0
        .byte   $D8
        .byte   $60
        .byte   $20
        .byte   $C6
        .byte   $FF
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $B0
        .byte   $CF
        .byte   $60
        .byte   $20
        .byte   $E4
        .byte   $FF
        .byte   $B0
        .byte   $C9
        .byte   $60
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $A9
        .byte   $A7
        .byte   $48
        .byte   $A9
        .byte   $CE
        .byte   $48
        .byte   $AD
        .byte   $F5
        .byte   $07
        .byte   $48
        .byte   $AD
        .byte   $F2
        .byte   $07
        .byte   $AE
        .byte   $F3
        .byte   $07
        .byte   $AC
        .byte   $F4
        .byte   $07
        .byte   $28
        .byte   $6C
        .byte   $14
        .byte   $00
        .byte   $08
        .byte   $8D
        .byte   $F2
        .byte   $07
        .byte   $8E
        .byte   $F3
        .byte   $07
        .byte   $8C
        .byte   $F4
        .byte   $07
        .byte   $68
        .byte   $8D
        .byte   $F5
        .byte   $07
        .byte   $60
        .byte   $20
        .byte   $6B
        .byte   $A8
        .byte   $A6
        .byte   $2D
        .byte   $A4
        .byte   $2E
        .byte   $A9
        .byte   $2B
        .byte   $20
        .byte   $D8
        .byte   $FF
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $B0
        .byte   $8E
        .byte   $60
        .byte   $A9
        .byte   $01
        .byte   $2C
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $0A
        .byte   $20
        .byte   $6B
        .byte   $A8
        .byte   $A5
        .byte   $0A
        .byte   $A6
        .byte   $2B
        .byte   $A4
        .byte   $2C
        .byte   $20
        .byte   $D5
        .byte   $FF
        .byte   $08
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $28
        .byte   $B0
        .byte   $5E
        .byte   $A5
        .byte   $0A
        .byte   $F0
        .byte   $16
        .byte   $A2
        .byte   $1C
        .byte   $20
        .byte   $B7
        .byte   $FF
        .byte   $29
        .byte   $10
        .byte   $D0
        .byte   $16
        .byte   $24
        .byte   $81
        .byte   $30
        .byte   $08
        .byte   $20
        .byte   $4F
        .byte   $FF
        .text   $0D,"ok",$0D
        .byte   $00
        .byte   $60
        .byte   $20
        .byte   $B7
        .byte   $FF
        .byte   $29
        .byte   $BF
        .byte   $F0
        .byte   $05
        .byte   $A2
        .byte   $1D
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $24
        .byte   $81
        .byte   $30
        .byte   $10
        .byte   $86
        .byte   $2D
        .byte   $84
        .byte   $2E
        .byte   $20
        .byte   $6F
        .byte   $86
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $20
        .byte   $93
        .byte   $8A
        .byte   $4C
        .byte   $0F
        .byte   $87
        .byte   $20
        .byte   $F1
        .byte   $8A
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $4C
        .byte   $D5
        .byte   $8A
        .byte   $20
        .byte   $B0
        .byte   $A8
        .byte   $18
        .byte   $20
        .byte   $85
        .byte   $A7
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $B0
        .byte   $0F
        .byte   $60
        .byte   $20
        .byte   $B0
        .byte   $A8
        .byte   $A5
        .byte   $49
        .byte   $18
        .byte   $20
        .byte   $C3
        .byte   $FF
        .byte   $20
        .byte   $F8
        .byte   $A8
        .byte   $90
        .byte   $BB
        .byte   $4C
        .byte   $7D
        .byte   $A7
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $BD
        .byte   $FF
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $EE
        .byte   $A8
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $97
        .byte   $A8
        .byte   $A0
        .byte   $00
        .byte   $86
        .byte   $49
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $97
        .byte   $A8
        .byte   $8A
        .byte   $A8
        .byte   $A6
        .byte   $49
        .byte   $4C
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $A5
        .byte   $A8
        .byte   $4C
        .byte   $84
        .byte   $9D
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $D0
        .byte   $02
        .byte   $68
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $D0
        .byte   $F7
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $BD
        .byte   $FF
        .byte   $20
        .byte   $A8
        .byte   $A8
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $86
        .byte   $49
        .byte   $8A
        .byte   $A2
        .byte   $01
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $97
        .byte   $A8
        .byte   $86
        .byte   $4A
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $49
        .byte   $E0
        .byte   $03
        .byte   $90
        .byte   $01
        .byte   $88
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $97
        .byte   $A8
        .byte   $8A
        .byte   $A8
        .byte   $A6
        .byte   $4A
        .byte   $A5
        .byte   $49
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $20
        .byte   $9D
        .byte   $A8
        .byte   $20
        .byte   $A5
        .byte   $A8
        .byte   $20
        .byte   $48
        .byte   $9C
        .byte   $A6
        .byte   $22
        .byte   $A4
        .byte   $23
        .byte   $4C
        .byte   $BD
        .byte   $FF
        .byte   $08
        .byte   $48
        .byte   $A5
        .byte   $AE
        .byte   $C9
        .byte   $04
        .byte   $90
        .byte   $03
        .byte   $20
        .byte   $57
        .byte   $CD
        .byte   $68
        .byte   $28
        .byte   $60

LA906   lsr     $0F        ;5
LA908   tax                ;2
        beq     LA943      ;2+
        pha                ;3
        lda     $33        ;3
        sec                ;2
        sbc     #$02       ;2
        ldy     $34        ;3
        bcs     _LA916     ;2+
        dey                ;2
_LA916  sta     $22        ;3
        sty     $23        ;3
        txa                ;2
        eor     #$FF       ;2
        sec                ;2
        adc     $22        ;3
        bcs     _LA923     ;2+
        dey                ;2
_LA923  cpy     $32        ;3
        bcc     LA944      ;2+
        bne     _LA92D     ;2+
        cmp     $31        ;3
        bcc     LA944      ;2+
_LA92D  sta     $35        ;3
        sty     $36        ;3
        ldy     #$01       ;2
        lda     #$FF       ;2
        sta     ($22),y    ;6
        dey                ;2
        pla                ;4
        sta     ($22),y    ;6
        ldx     $35        ;3
        .byte   $A4        ;3
LA93E   .byte   $36        ;6
        stx     $33        ;3
        sty     $34        ;3
LA943   rts                ;6

LA944   lda     $0F        ;3
        bmi     _LA951     ;2+
        jsr     _LA954     ;6
        sec                ;2
        ror     $0F        ;5
        pla                ;4
        bne     LA908      ;2+
_LA951  jmp     L8681      ;3

_LA954  ldx     $16        ;3
_LA956  cpx     #$19       ;2
        beq     _LA96A     ;2+
        jsr     LAA57      ;6
        beq     _LA956     ;2+
        txa                ;2
        ldy     #$00       ;2
        sta     ($5C),y    ;6
        tya                ;2
        iny                ;2
        sta     ($5C),y    ;6
        bne     _LA956     ;2+
_LA96A  ldy     #$00       ;2
        sty     $58        ;3
        ldx     $37        ;3
        ldy     $38        ;3
        stx     $5F        ;3
        stx     $4E        ;3
        stx     $35        ;3
        sty     $60        ;3
        sty     $4F        ;3
        sty     $36        ;3
        txa                ;2
_LA97F  jsr     _LA9EA     ;6
        bne     _LA990     ;2+
_LA984  dey                ;2
        jsr     L8165      ;6
        jsr     LAA39      ;6
        sec                ;2
        ror     $58        ;5
        bne     _LA97F     ;3

_LA990  bit     $58        ;3
        bpl     _LA9D6     ;2+
        ldx     #$00       ;2
        stx     $58        ;3
        lda     #$02       ;2
_LA99A  ldy     #$01       ;2
        jsr     L8165      ;6
        sta     ($5F),y    ;6
        dey                ;2
        jsr     L8165      ;6
        sta     ($5F),y    ;6
        jsr     $04B0      ;6
        tax                ;2
        jsr     LAA48      ;6
        sta     $35        ;3
        sty     $36        ;3
        txa                ;2
        jsr     LAA39      ;6
        txa                ;2
        tay                ;2
_LA9B8  dey                ;2
        jsr     L8165      ;6
        sta     ($5F),y    ;6
        dex                ;2
        bne     _LA9B8     ;2+
        ldy     #$02       ;2
_LA9C3  lda     $005E,y    ;4+
        sta     ($22),y    ;6
        dey                ;2
        bne     _LA9C3     ;2+
        lda     $4E        ;3
        ldy     $4F        ;3
        jsr     _LA9EA     ;6
        beq     _LA984     ;2+
        bne     _LA99A     ;3

_LA9D6  ldy     #$00       ;2
        jsr     $04B0      ;6
        tax                ;2
        jsr     LAA48      ;6
        sta     $35        ;3
        sty     $36        ;3
        txa                ;2
        jsr     LAA39      ;6
        jmp     _LA97F     ;3

_LA9EA  cpy     $34        ;3
        bcc     LAA18      ;3+
        bne     _LA9F6     ;2+
        cmp     $33        ;3
        beq     LAA18      ;3+
        bcc     LAA18      ;3+
_LA9F6  bit     $58        ;3
        bmi     _LA9FF     ;2+
        lda     #$02       ;2
        jsr     LAA48      ;6
_LA9FF  lda     #$02       ;2
        jsr     LAA39      ;6
        ldy     #$01       ;2
LAA06   jsr     L8165      ;6
        cmp     #$FF       ;2
        bne     _LAA0E     ;2+
        rts                ;6

_LAA0E  jsr     L8165      ;6
        sta     $0022,y    ;5
        dey                ;2
        bpl     _LAA0E     ;2+
        rts                ;6

LAA18   ldx     $16        ;3
_LAA1A  cpx     #$19       ;2
        beq     _LAA2E     ;2+
        jsr     LAA57      ;6
        beq     _LAA1A     ;2+
        ldy     #$00       ;2
        sta     ($5C),y    ;6
        iny                ;2
        lda     #$FF       ;2
        sta     ($5C),y    ;6
        bne     _LAA1A     ;3

_LAA2E  pla                ;4
        pla                ;4
        lda     $35        ;3
        ldy     $36        ;3
        sta     $33        ;3
        sty     $34        ;3
        rts                ;6

LAA39   eor     #$FF       ;2
        sec                ;2
        adc     $4E        ;3
        ldy     $4F        ;3
        bcs     _LAA43     ;2+
        dey                ;2
_LAA43  sta     $4E        ;3
        sty     $4F        ;3
        rts                ;6

LAA48   eor     #$FF       ;2
        sec                ;2
        adc     $5F        ;3
        ldy     $60        ;3
        bcs     _LAA52     ;2+
        dey                ;2
_LAA52  sta     $5F        ;3
        sty     $60        ;3
        rts                ;6

LAA57   dex                ;2
        lda     $00,x      ;4
        sta     $5D        ;3
        dex                ;2
        lda     $00,x      ;4
        sta     $5C        ;3
        dex                ;2
        lda     $00,x      ;4
        pha                ;3
        clc                ;2
        adc     $5C        ;3
        sta     $5C        ;3
        bcc     _LAA6E     ;2+
        inc     $5D        ;5
_LAA6E  pla                ;4
        rts                ;6

        .byte   $A9
        .byte   $EC
        .byte   $A0
        .byte   $AA
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $A9
        .byte   $F1
        .byte   $A0
        .byte   $AA
        .byte   $A6
        .byte   $6E
        .byte   $20
        .byte   $8C
        .byte   $A1
        .byte   $20
        .byte   $91
        .byte   $A2
        .byte   $20
        .byte   $58
        .byte   $A3
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $6F
        .byte   $20
        .byte   $87
        .byte   $9E
        .byte   $A9
        .byte   $F6
        .byte   $A0
        .byte   $AA
        .byte   $20
        .byte   $6C
        .byte   $A0
        .byte   $A5
        .byte   $66
        .byte   $48
        .byte   $10
        .byte   $0D
        .byte   $20
        .byte   $62
        .byte   $A0
        .byte   $A5
        .byte   $66
        .byte   $30
        .byte   $09
        .byte   $A5
        .byte   $12
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $12
        .byte   $20
        .byte   $27
        .byte   $A6
        .byte   $A9
        .byte   $F6
        .byte   $A0
        .byte   $AA
        .byte   $20
        .byte   $66
        .byte   $A0
        .byte   $68
        .byte   $10
        .byte   $03
        .byte   $20
        .byte   $27
        .byte   $A6
        .byte   $A9
        .byte   $FB
        .byte   $A0
        .byte   $AA
        .byte   $4C
        .byte   $B3
        .byte   $A6
        .byte   $20
        .byte   $4F
        .byte   $A2
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $12
        .byte   $20
        .byte   $77
        .byte   $AA
        .byte   $A2
        .byte   $4E
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $5D
        .byte   $A7
        .byte   $A9
        .byte   $57
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $66
        .byte   $A5
        .byte   $12
        .byte   $20
        .byte   $E8
        .byte   $AA
        .byte   $A9
        .byte   $4E
        .byte   $A0
        .byte   $00
        .byte   $4C
        .byte   $94
        .byte   $A1
        .byte   $48
        .byte   $4C
        .byte   $A9
        .byte   $AA
        .byte   $81
        .byte   $49
        .byte   $0F
        .byte   $DA
        .byte   $A2
        .byte   $83
        .byte   $49
        .byte   $0F
        .byte   $DA
        .byte   $A2
        .byte   $7F
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $05
        .byte   $84
        .byte   $E6
        .byte   $1A
        .byte   $2D
        .byte   $1B
        .byte   $86
        .byte   $28
        .byte   $07
        .byte   $FB
        .byte   $F8
        .byte   $87
        .byte   $99
        .byte   $68
        .byte   $89
        .byte   $01
        .byte   $87
        .byte   $23
        .byte   $35
        .byte   $DF
        .byte   $E1
        .byte   $86
        .byte   $A5
        .byte   $5D
        .byte   $E7
        .byte   $28
        .byte   $83
        .byte   $49
        .byte   $0F
        .byte   $DA
        .byte   $A2
        .byte   $A5
        .byte   $66
        .byte   $48
        .byte   $10
        .byte   $03
        .byte   $20
        .byte   $27
        .byte   $A6
        .byte   $A5
        .byte   $61
        .text   "hI",$81,$90,$07
        .byte   $A9
        .byte   $F0
        .byte   $A0
        .byte   $9F
        .byte   $20
        .byte   $72
        .byte   $A0
        .byte   $A9
        .byte   $4A
        .byte   $A0
        .byte   $AB
        .byte   $20
        .byte   $B3
        .byte   $A6
        .byte   $68
        .text   "I",$81,$90,$07
        .byte   $A9
        .byte   $EC
        .byte   $A0
        .byte   $AA
        .byte   $20
        .byte   $6C
        .byte   $A0
        .byte   $68
        .byte   $10
        .byte   $03
        .byte   $4C
        .byte   $27
        .byte   $A6
        .byte   $60
        .byte   $0B
        .byte   $76
        .byte   $B3
        .byte   $83
        .byte   $BD
        .byte   $D3
        .byte   $79
        .byte   $1E
        .byte   $F4
        .byte   $A6
        .byte   $F5
        .byte   $7B
        .byte   $83
        .byte   $FC
        .byte   $B0
        .byte   $10
        .byte   $7C
        .byte   $0C
        .byte   $1F
        .byte   $67
        .byte   $CA
        .byte   $7C
        .byte   $DE
        .byte   $53
        .byte   $CB
        .byte   $C1
        .byte   $7D
        .byte   $14
        .byte   $64
        .byte   $70
        .byte   $4C
        .byte   $7D
        .byte   $B7
        .byte   $EA
        .byte   $51
        .byte   $7A
        .byte   $7D
        .byte   $63
        .byte   $30
        .byte   $88
        .byte   $7E
        .byte   $7E
        .text   $92,"d",$99,":"
        .byte   $7E
        .byte   $4C
        .byte   $CC
        .byte   $91
        .byte   $C7
        .byte   $7F
        .byte   $AA
        .byte   $AA
        .byte   $AA
        .byte   $13
        .byte   $81
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $89
        .byte   $8A
        .byte   $8D
        .byte   $A7
        .byte   $8C
        .text   "VWU "
        .byte   $DE
        .byte   $B6
        .byte   $A9
        .byte   $00
        .byte   $A2
        .byte   $0A
        .byte   $86
        .byte   $03
        .byte   $85
        .byte   $04
        .byte   $86
        .byte   $05
        .byte   $85
        .byte   $06
        .byte   $85
        .byte   $5A
        .byte   $85
        .byte   $5B
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $66
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $A5
        .byte   $08
        .byte   $F0
        .byte   $08
        .byte   $A5
        .byte   $14
        .byte   $A6
        .byte   $15
        .byte   $85
        .byte   $03
        .byte   $86
        .byte   $04
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $52
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $A5
        .byte   $08
        .byte   $F0
        .byte   $10
        .byte   $A5
        .byte   $14
        .byte   $A6
        .byte   $15
        .byte   $85
        .byte   $05
        .byte   $86
        .byte   $06
        .byte   $D0
        .byte   $06
        .byte   $AA
        .byte   $D0
        .byte   $03
        .text   "l",$1C,$99," "
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $33
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $A5
        .byte   $14
        .byte   $A6
        .byte   $15
        .byte   $85
        .byte   $5A
        .byte   $86
        .byte   $5B
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $A5
        .byte   $5F
        .byte   $A6
        .byte   $60
        .byte   $85
        .byte   $58
        .byte   $86
        .byte   $59
        .byte   $A5
        .byte   $03
        .byte   $A6
        .byte   $04
        .byte   $85
        .byte   $14
        .byte   $86
        .byte   $15
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $A5
        .byte   $60
        .byte   $38
        .byte   $E5
        .text   "y",$90,"MP"
        .byte   $06
        .byte   $A5
        .byte   $5F
        .byte   $E5
        .text   "x",$90,"E "
        .byte   $F1
        .byte   $8A
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .text   "P= y"
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $B3
        .byte   $AE
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $85
        .byte   $14
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $38
        .byte   $E5
        .byte   $5B
        .byte   $90
        .byte   $19
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $14
        .byte   $E5
        .byte   $5A
        .byte   $90
        .byte   $11
        .byte   $A5
        .byte   $62
        .byte   $91
        .byte   $3B
        .byte   $88
        .byte   $A5
        .byte   $63
        .byte   $91
        .byte   $3B
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $73
        .byte   $AD
        .byte   $F0
        .byte   $CE
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $80
        .byte   $AD
        .byte   $F0
        .byte   $C6
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $C9
        .byte   $22
        .byte   $D0
        .byte   $0B
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $F0
        .byte   $A9
        .byte   $C9
        .byte   $22
        .byte   $D0
        .byte   $F7
        .byte   $F0
        .byte   $EE
        .byte   $AA
        .byte   $F0
        .byte   $A0
        .byte   $10
        .byte   $E9
        .byte   $A2
        .byte   $08
        .byte   $DD
        .byte   $86
        .byte   $AB
        .byte   $F0
        .byte   $10
        .byte   $CA
        .byte   $D0
        .byte   $F8
        .byte   $C9
        .byte   $CB
        .byte   $D0
        .byte   $DB
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $F0
        .byte   $8B
        .byte   $C9
        .byte   $A4
        .byte   $D0
        .byte   $D2
        .byte   $A5
        .byte   $3B
        .byte   $8D
        .byte   $59
        .byte   $02
        .byte   $A5
        .byte   $3C
        .byte   $8D
        .byte   $5A
        .byte   $02
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $B0
        .byte   $C6
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $20
        .byte   $EE
        .byte   $AC
        .byte   $AD
        .byte   $59
        .byte   $02
        .byte   $85
        .byte   $3B
        .byte   $AD
        .byte   $5A
        .byte   $02
        .byte   $85
        .byte   $3C
        .byte   $A0
        .byte   $00
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $01
        .byte   $01
        .byte   $F0
        .byte   $1C
        .byte   $48
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $90
        .byte   $0E
        .byte   $20
        .byte   $42
        .byte   $AD
        .byte   $E6
        .byte   $6C
        .byte   $20
        .byte   $BB
        .byte   $AD
        .byte   $E6
        .byte   $2D
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $2E
        .byte   $68
        .byte   $A0
        .byte   $00
        .byte   $91
        .byte   $3B
        .byte   $E8
        .byte   $D0
        .byte   $DF
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $B0
        .byte   $15
        .byte   $20
        .byte   $42
        .byte   $AD
        .byte   $C6
        .byte   $6C
        .byte   $20
        .byte   $A2
        .byte   $AD
        .byte   $A5
        .byte   $2D
        .byte   $D0
        .byte   $02
        .text   "F.F- "
        .byte   $79
        .byte   $04
        .byte   $90
        .byte   $EB
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $9E
        .byte   $4C
        .byte   $5E
        .byte   $AC
        .byte   $20
        .byte   $59
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $D0
        .byte   $0D
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $D0
        .byte   $0B
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $62
        .byte   $85
        .byte   $63
        .byte   $30
        .byte   $2A
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $85
        .byte   $58
        .byte   $C5
        .byte   $14
        .byte   $D0
        .byte   $27
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $85
        .byte   $59
        .byte   $C5
        .byte   $15
        .byte   $D0
        .byte   $23
        .byte   $38
        .byte   $E5
        .byte   $5B
        .byte   $90
        .byte   $08
        .byte   $D0
        .byte   $0E
        .byte   $A5
        .byte   $14
        .byte   $E5
        .byte   $5A
        .byte   $B0
        .byte   $08
        .byte   $A5
        .byte   $14
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $15
        .byte   $85
        .byte   $62
        .byte   $A2
        .text   $90,"8 N"
        .byte   $A2
        .byte   $4C
        .byte   $6F
        .byte   $A4
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $85
        .byte   $59
        .byte   $20
        .byte   $64
        .byte   $AD
        .byte   $F0
        .byte   $B1
        .byte   $D9
        .byte   $EA
        .byte   $A5
        .byte   $3B
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $3C
        .byte   $85
        .byte   $23
        .byte   $A5
        .byte   $2D
        .byte   $85
        .byte   $24
        .byte   $A5
        .byte   $2E
        .byte   $85
        .byte   $25
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $0B
        .byte   $84
        .byte   $6C
        .byte   $60
        .byte   $A5
        .byte   $03
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $62
        .byte   $4C
        .byte   $F1
        .byte   $8A
        .byte   $A5
        .byte   $59
        .byte   $38
        .byte   $E5
        .byte   $5B
        .byte   $90
        .byte   $15
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $58
        .byte   $E5
        .byte   $5A
        .byte   $90
        .byte   $0D
        .byte   $A5
        .byte   $63
        .byte   $18
        .byte   $65
        .byte   $05
        .byte   $85
        .byte   $63
        .byte   $A5
        .byte   $62
        .byte   $65
        .byte   $06
        .byte   $85
        .byte   $62
        .byte   $20
        .byte   $86
        .byte   $AD
        .byte   $D0
LAD84   .byte   $FB
LAD85   .byte   $60
LAD86   .byte   $A0
        .byte   $00
        .byte   $E6
        .byte   $3B
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $3C
        .byte   $4C
        .byte   $A5
        .byte   $04
        .byte   $A5
        .text   $22,"E$P"
        .byte   $04
        .byte   $A5
        .byte   $23
        .byte   $C5
        .byte   $25
        .byte   $60
LAD9C   .byte   $E6
        .byte   $22
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $23
        .byte   $A4
        .byte   $0B
LADA4   .byte   $C8
LADA5   .byte   $20
LADA6   .byte   $B0
        .byte   $04
        .byte   $A4
        .byte   $6C
        .byte   $C8
        .byte   $91
        .byte   $22
        .byte   $20
        .byte   $91
        .byte   $AD
        .byte   $D0
        .byte   $EA
        .byte   $60
        .byte   $A5
        .byte   $24
        .byte   $D0
        .byte   $02
        .text   "F%F$"
        .byte   $A4
LADBC   .byte   $0B
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $A4
        .byte   $6C
        .byte   $91
        .byte   $24
LADC4   .byte   $20
LADC5   .byte   $91
LADC6   .byte   $AD
        .byte   $D0
        .byte   $EA
        .byte   $60
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $10
        .byte   $20
        .byte   $7C
        .byte   $8E
        .byte   $A9
        .byte   $81
        .byte   $85
        .byte   $02
        .byte   $20
        .byte   $71
        .byte   $88
        .byte   $F0
        .byte   $08
        .byte   $A0
        .byte   $12
LADDC   .byte   $20
        .byte   $05
        .byte   $89
        .byte   $20
        .byte   $60
        .byte   $A7
        .byte   $20
        .byte   $69
        .byte   $A7
        .byte   $20
        .byte   $BE
        .byte   $8D
        .byte   $98
        .byte   $A0
        .byte   $11
        .byte   $18
        .byte   $65
        .byte   $3B
        .byte   $91
        .byte   $7C
        .byte   $A5
        .byte   $3C
        .byte   $69
        .byte   $00
        .byte   $88
        .byte   $91
        .byte   $7C
        .byte   $A5
        .byte   $3A
        .byte   $88
        .byte   $91
        .byte   $7C
        .byte   $A5
        .byte   $39
        .byte   $88
        .byte   $91
        .byte   $7C
        .byte   $A9
        .byte   $A4
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $20
        .byte   $17
        .byte   $93
        .byte   $20
        .byte   $14
        .byte   $93
        .byte   $A5
        .byte   $66
        .byte   $09
        .byte   $7F
        .byte   $25
        .byte   $62
        .byte   $85
        .byte   $62
        .byte   $A2
        .byte   $04
        .byte   $A0
        .byte   $0D
        .byte   $B5
        .byte   $61
        .byte   $91
        .byte   $7C
        .byte   $CA
        .byte   $88
        .byte   $10
        .byte   $F8
        .byte   $A9
        .byte   $F0
        .byte   $A0
        .byte   $9F
        .byte   $20
        .byte   $21
        .byte   $A2
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $A9
        .byte   $D0
        .byte   $06
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $14
        .byte   $93
        .byte   $20
        .byte   $B0
        .byte   $A2
        .byte   $48
        .byte   $20
        .byte   $A0
        .byte   $A2
        .byte   $68
        .byte   $A0
        .byte   $08
        .byte   $A2
        .byte   $05
        .byte   $91
        .byte   $7C
        .byte   $B5
        .byte   $60
        .byte   $88
        .byte   $CA
        .byte   $10
        .byte   $F8
        .byte   $A5
        .byte   $4A
        .byte   $91
        .byte   $7C
        .byte   $A5
        .byte   $49
        .byte   $88
        .byte   $91
        .byte   $7C
        .byte   $A9
        .byte   $81
        .byte   $88
        .byte   $91
        .byte   $7C
        .byte   $60
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $DE
        .byte   $B6
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $F5
        .byte   $20
        .byte   $CA
        .byte   $AE
        .byte   $A5
        .byte   $5F
        .byte   $A6
        .byte   $60
        .byte   $85
        .byte   $24
        .byte   $86
        .byte   $25
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $90
        .byte   $15
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $88
        .byte   $AA
        .text   "P",$05," Q"
        .byte   $04
        .byte   $F0
        .byte   $07
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $85
        .byte   $5F
        .byte   $86
        .byte   $60
        .byte   $A5
        .byte   $24
        .byte   $38
        .byte   $E5
        .byte   $5F
        .byte   $AA
        .byte   $A5
        .byte   $25
        .byte   $E5
        .byte   $60
        .byte   $A8
        .byte   $B0
        .byte   $1F
        .byte   $8A
        .byte   $18
        .byte   $65
        .byte   $2D
        .byte   $85
        .byte   $2D
        .byte   $98
        .byte   $65
        .byte   $2E
        .byte   $85
        .byte   $2E
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $D1
        .byte   $04
        .byte   $91
        .byte   $24
        .byte   $C8
        .byte   $D0
        .byte   $F8
        .byte   $E6
        .byte   $60
        .byte   $E6
        .byte   $25
        .byte   $A5
        .byte   $2E
        .byte   $C5
        .byte   $25
        .byte   $B0
        .byte   $EE
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $A5
        .byte   $22
        .byte   $A6
        .byte   $23
        .byte   $18
        .byte   $69
        .byte   $02
        .byte   $85
        .byte   $2D
        .byte   $90
        .byte   $01
        .byte   $E8
        .byte   $86
        .byte   $2E
        .byte   $20
        .byte   $93
        .byte   $8A
        .byte   $4C
        .byte   $7E
        .byte   $86
        .byte   $F0
        .byte   $06
        .byte   $90
        .byte   $04
        .byte   $C9
        .byte   $AB
        .text   "P",$22," >"
        .byte   $8E
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $0C
        .byte   $C9
        .byte   $AB
        .byte   $D0
        .byte   $13
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $D0
        .byte   $0B
        .byte   $A5
        .byte   $08
        .byte   $D0
        .byte   $06
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $14
        .byte   $85
        .byte   $15
        .byte   $60
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A2
        .byte   $FF
        .byte   $8E
        .byte   $E0
        .byte   $02
        .byte   $20
        .byte   $73
        .byte   $04
        .text   " ,",$93," "
        .byte   $1A
        .byte   $93
        .byte   $A5
        .byte   $64
        .byte   $48
        .byte   $A5
        .byte   $65
        .byte   $48
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $88
        .byte   $99
        .byte   $3D
        .byte   $00
        .byte   $D0
        .byte   $F7
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $8D
        .byte   $DF
        .byte   $02
        .byte   $A8
        .byte   $F0
        .byte   $0B
        .byte   $88
        .byte   $20
        .byte   $71
        .byte   $81
        .byte   $C9
        .byte   $23
        .byte   $F0
        .byte   $06
        .byte   $98
        .byte   $D0
        .byte   $F5
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A9
        .byte   $3B
        .byte   $20
        .byte   $93
        .byte   $94
        .byte   $84
        .byte   $76
        .byte   $8C
        .byte   $CD
        .byte   $02
        .text   " ,",$93,"$",$0D
        .byte   $10
        .byte   $39
        .byte   $20
        .byte   $70
        .byte   $B1
        .byte   $20
        .byte   $B7
        .byte   $B2
        .byte   $AE
        .byte   $D5
        .byte   $02
        .byte   $F0
        .byte   $15
        .byte   $A2
        .byte   $00
        .byte   $38
        .byte   $AD
        .byte   $DB
        .byte   $02
        .byte   $E5
        .byte   $77
        .byte   $90
        .byte   $0B
        .byte   $A2
        .byte   $3D
        .byte   $EC
        .byte   $D5
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $4A
        .byte   $69
        .byte   $00
        .byte   $AA
        .byte   $A0
        .byte   $00
        .byte   $8A
        .byte   $F0
        .byte   $05
        .byte   $CA
        .byte   $A9
        .byte   $20
        .byte   $D0
        .byte   $08
        .byte   $C4
        .byte   $77
        .byte   $B0
        .byte   $F8
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $C8
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $D0
        .byte   $EB
        .byte   $F0
        .byte   $24
        .byte   $20
        .byte   $6F
        .byte   $A4
        .byte   $A0
        .byte   $FF
        .byte   $C8
        .byte   $B9
        .byte   $00
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $98
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $A0
        .byte   $00
        .byte   $B9
        .byte   $00
        .byte   $01
        .byte   $F0
        .byte   $05
        .byte   $91
        .byte   $62
        .byte   $C8
        .byte   $D0
        .byte   $F6
        .byte   $20
        .byte   $B0
        .byte   $9B
        .byte   $20
        .byte   $70
        .byte   $B1
        .byte   $20
        .byte   $BB
        .byte   $AF
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $8D
        .byte   $38
        .byte   $66
        .byte   $76
        .byte   $20
        .byte   $B7
        .byte   $B2
        .byte   $68
        .byte   $A8
        .byte   $68
        .text   " r",$9C," "
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $3B
        .byte   $F0
        .byte   $03
        .text   "l>",$90,"l"
        .byte   $73
        .byte   $04
        .byte   $AD
        .byte   $E7
        .byte   $04
        .byte   $8D
        .byte   $DD
        .byte   $02
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $DC
        .byte   $02
        .byte   $4C
        .byte   $CB
        .byte   $AF
        .byte   $86
        .byte   $82
        .byte   $C4
        .byte   $77
        .byte   $F0
        .byte   $33
        .byte   $B9
        .byte   $00
        .byte   $01
        .byte   $C8
        .byte   $C9
        .byte   $20
        .byte   $F0
        .byte   $F4
        .byte   $C9
        .byte   $2D
        .byte   $F0
        .byte   $E8
        .byte   $C9
        .byte   $2E
        .byte   $F0
        .byte   $EA
        .byte   $C9
        .byte   $45
        .byte   $F0
        .byte   $11
        .byte   $9D
        .byte   $00
        .byte   $01
        .byte   $8E
        .byte   $CE
        .byte   $02
        .byte   $E8
        .byte   $24
        .byte   $82
        .byte   $10
        .byte   $DD
        .byte   $EE
        .byte   $D4
        .byte   $02
        .byte   $4C
        .byte   $CB
        .byte   $AF
        .byte   $B9
        .byte   $00
        .byte   $01
        .byte   $C9
        .byte   $2D
        .byte   $D0
        .byte   $03
        .byte   $6E
        .byte   $D2
        .byte   $02
        .byte   $C8
        .byte   $8C
        .byte   $D3
        .byte   $02
        .byte   $A5
        .byte   $82
        .byte   $10
        .byte   $02
        .byte   $86
        .byte   $82
        .byte   $20
        .byte   $B7
        .byte   $B2
        .byte   $AD
        .byte   $D6
        .byte   $02
        .byte   $C9
        .byte   $FF
        .byte   $F0
        .byte   $29
        .byte   $AD
        .byte   $D9
        .byte   $02
        .byte   $F0
        .byte   $3F
        .byte   $AD
        .byte   $D3
        .byte   $02
        .byte   $D0
        .byte   $12
        .byte   $AE
        .byte   $CE
        .byte   $02
        .byte   $20
        .byte   $45
        .byte   $B1
        .byte   $DE
        .byte   $02
        .byte   $01
        .byte   $E8
        .byte   $8E
        .byte   $D3
        .byte   $02
        .byte   $20
        .byte   $CC
        .byte   $B1
        .byte   $F0
        .byte   $25
        .byte   $AC
        .byte   $D8
        .byte   $02
        .byte   $D0
        .byte   $17
        .byte   $AC
        .byte   $DC
        .byte   $02
        .byte   $30
        .byte   $12
        .byte   $AD
        .byte   $D6
        .byte   $02
        .byte   $F0
        .byte   $6A
        .byte   $CE
        .byte   $D6
        .byte   $02
        .byte   $D0
        .byte   $05
        .byte   $AD
        .byte   $D7
        .byte   $02
        .byte   $F0
        .byte   $60
        .byte   $EE
        .byte   $D1
        .byte   $02
        .byte   $20
        .byte   $BF
        .byte   $B0
        .byte   $20
        .byte   $8A
        .byte   $B1
        .byte   $20
        .byte   $BF
        .byte   $B0
        .byte   $4C
        .byte   $ED
        .byte   $B1
        .byte   $AC
        .byte   $D3
        .byte   $02
        .byte   $F0
        .byte   $16
        .byte   $85
        .byte   $77
        .byte   $38
        .byte   $6E
        .byte   $DA
        .byte   $02
        .byte   $A4
        .byte   $82
        .byte   $AD
        .byte   $D2
        .byte   $02
        .byte   $10
        .byte   $06
        .byte   $20
        .byte   $F8
        .byte   $B0
        .byte   $4C
        .byte   $7A
        .byte   $B0
        .byte   $20
        .byte   $D9
        .byte   $B0
        .byte   $A4
        .byte   $82
        .byte   $F0
        .byte   $05
        .byte   $20
        .byte   $D0
        .byte   $B1
        .byte   $F0
        .byte   $06
        .byte   $20
        .byte   $8A
        .byte   $B1
        .byte   $4C
        .byte   $83
        .byte   $B0
        .byte   $CE
        .byte   $D4
        .byte   $02
        .byte   $38
        .byte   $AD
        .byte   $D6
        .byte   $02
        .byte   $ED
        .byte   $D4
        .byte   $02
        .byte   $90
        .byte   $1B
        .byte   $8D
        .byte   $D1
        .byte   $02
        .byte   $AC
        .byte   $D8
        .byte   $02
        .byte   $D0
        .byte   $1B
        .byte   $AC
        .byte   $DC
        .byte   $02
        .byte   $30
        .byte   $16
        .byte   $A8
        .byte   $F0
        .byte   $0B
        .byte   $88
        .byte   $D0
        .byte   $13
        .byte   $AD
        .byte   $D7
        .byte   $02
        .byte   $0D
        .byte   $D4
        .byte   $02
        .byte   $D0
        .byte   $AC
        .byte   $A9
        .byte   $2A
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $D0
        .byte   $FB
        .byte   $60
        .byte   $A8
        .byte   $F0
        .byte   $A1
        .byte   $AD
        .byte   $D4
        .byte   $02
        .text   "P",$9C,"NQ"
        .byte   $02
        .byte   $E6
        .byte   $76
        .byte   $4C
        .byte   $53
        .byte   $B0
        .byte   $38
        .byte   $AD
        .byte   $D6
        .byte   $02
        .byte   $ED
        .byte   $D4
        .byte   $02
        .byte   $F0
        .byte   $39
        .byte   $A4
        .byte   $82
        .byte   $90
        .byte   $16
        .byte   $85
        .byte   $77
        .byte   $CC
        .byte   $CE
        .byte   $02
        .byte   $F0
        .byte   $02
        .byte   $B0
        .byte   $01
        .byte   $C8
        .byte   $EE
        .byte   $D4
        .byte   $02
        .byte   $20
        .byte   $0E
        .byte   $B1
        .byte   $C6
        .byte   $77
        .byte   $D0
        .byte   $EE
        .byte   $F0
        .byte   $1D
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $01
        .byte   $85
        .byte   $77
        .byte   $CC
        .byte   $CD
        .byte   $02
        .byte   $F0
        .byte   $07
        .byte   $88
        .byte   $CE
        .byte   $D4
        .byte   $02
        .byte   $4C
        .byte   $F6
        .byte   $B0
        .byte   $E6
        .byte   $76
        .byte   $A9
        .byte   $80
        .byte   $20
        .byte   $10
        .byte   $B1
        .byte   $C6
        .byte   $77
        .byte   $D0
        .byte   $E9
        .byte   $84
        .byte   $82
        .byte   $60
        .byte   $D0
        .byte   $39
        .byte   $49
        .byte   $09
        .byte   $9D
        .byte   $00
        .byte   $01
        .byte   $CA
        .byte   $EC
        .byte   $D3
        .byte   $02
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $AE
        .byte   $D3
        .byte   $02
        .byte   $E8
        .byte   $2C
        .byte   $DA
        .byte   $02
        .byte   $30
        .byte   $10
        .byte   $4D
        .byte   $D2
        .byte   $02
        .byte   $F0
        .byte   $0B
        .byte   $20
        .byte   $53
        .byte   $B1
        .byte   $20
        .byte   $02
        .byte   $B1
        .byte   $B0
        .byte   $F8
        .byte   $4C
        .byte   $B2
        .byte   $9F
        .byte   $BD
        .byte   $00
        .byte   $01
        .byte   $DE
        .byte   $00
        .byte   $01
        .byte   $C9
        .byte   $30
        .byte   $20
        .byte   $02
        .byte   $B1
        .byte   $B0
        .byte   $F3
        .byte   $2C
        .byte   $DA
        .byte   $02
        .byte   $10
        .byte   $05
        .byte   $84
        .byte   $82
        .byte   $68
        .byte   $68
        .byte   $60
        .byte   $AD
        .byte   $D2
        .byte   $02
        .byte   $49
        .byte   $80
        .byte   $8D
        .byte   $D2
        .byte   $02
        .byte   $A9
        .byte   $30
        .byte   $9D
        .byte   $01
        .byte   $01
        .byte   $A9
        .byte   $31
        .byte   $9D
        .byte   $02
        .byte   $01
        .byte   $60
        .byte   $BD
        .byte   $00
        .byte   $01
        .byte   $FE
        .byte   $00
        .byte   $01
        .byte   $C9
        .byte   $39
        .byte   $60
        .byte   $18
        .byte   $C8
        .byte   $F0
        .byte   $05
        .byte   $CC
        .byte   $DF
        .byte   $02
        .byte   $90
        .byte   $04
        .byte   $A4
        .byte   $76
        .byte   $D0
        .byte   $D4
        .byte   $20
        .byte   $71
        .byte   $81
        .byte   $EE
        .byte   $DB
        .byte   $02
        .byte   $60
        .byte   $20
        .byte   $4E
        .byte   $9C
        .byte   $85
        .byte   $77
        .byte   $A2
        .byte   $0A
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $D1
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $FA
        .byte   $8E
        .byte   $D0
        .byte   $02
        .byte   $86
        .byte   $82
        .byte   $8E
        .byte   $CF
        .byte   $02
        .byte   $AA
        .byte   $A8
        .byte   $60
        .byte   $18
        .byte   $A5
        .byte   $82
        .byte   $6D
        .byte   $D7
        .byte   $02
        .byte   $B0
        .byte   $39
        .byte   $38
        .byte   $E5
        .byte   $76
        .text   $90,"4MN"
        .byte   $02
        .byte   $F0
        .byte   $02
        .byte   $B0
        .byte   $2D
        .byte   $CD
        .byte   $CD
        .byte   $02
LB1A1   .byte   $90
        .byte   $28
        .byte   $AA
        .byte   $BD
        .byte   $00
        .byte   $01
        .text   "I5",$90," "
        .byte   $EC
        .byte   $CD
        .byte   $02
        .byte   $F0
        .text   $0A,"J s"
        .byte   $B1
        .byte   $8E
        .byte   $CE
        .byte   $02
        .byte   $F0
        .byte   $F2
        .byte   $60
        .byte   $A9
        .byte   $31
        .byte   $9D
        .byte   $00
        .byte   $01
        .byte   $E8
        .byte   $86
        .byte   $82
        .byte   $C6
        .byte   $76
        .byte   $10
        .byte   $05
        .byte   $E6
        .byte   $76
        .byte   $EE
        .byte   $D4
        .byte   $02
        .byte   $60
        .byte   $A4
        .byte   $82
        .byte   $F0
        .byte   $17
        .byte   $AC
        .byte   $CD
        .byte   $02
        .byte   $B9
        .byte   $00
        .byte   $01
        .byte   $C9
        .byte   $30
        .byte   $60
        .byte   $E6
        .byte   $82
        .byte   $20
        .byte   $0E
LB1DD   .byte   $B1
        .byte   $EE
        .byte   $CD
        .byte   $02
        .byte   $CC
        .byte   $CE
        .byte   $02
        .byte   $F0
        .byte   $E5
        .byte   $C8
        .byte   $20
        .byte   $D3
        .byte   $B1
        .byte   $F0
        .byte   $ED
        .byte   $60
        .byte   $AD
        .byte   $CF
        .byte   $02
        .byte   $30
        .byte   $02
        .byte   $E6
        .byte   $76
        .byte   $AE
        .byte   $CD
        .byte   $02
        .byte   $CA
        .byte   $AC
        .byte   $DE
        .byte   $02
        .byte   $20
        .byte   $71
        .text   $81,"HI,P"
        .byte   $11
        .byte   $2C
        .byte   $D0
        .byte   $02
        .byte   $30
        .byte   $06
        .byte   $AD
        .byte   $E8
        .byte   $04
        .byte   $4C
        .byte   $76
        .byte   $B2
        .byte   $AD
        .byte   $DD
        .byte   $02
        .byte   $4C
        .byte   $76
        .byte   $B2
        .byte   $C9
        .byte   $2E
        .byte   $D0
        .byte   $06
        .byte   $AD
        .byte   $E9
        .byte   $04
        .byte   $4C
        .byte   $76
        .byte   $B2
        .byte   $C9
        .byte   $2B
        .byte   $F0
        .byte   $3B
        .byte   $C9
        .byte   $2D
        .byte   $F0
        .byte   $32
        .byte   $C9
        .byte   $5E
        .byte   $D0
        .byte   $63
        .byte   $A9
        .byte   $45
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $AC
        .byte   $D3
        .byte   $02
        .byte   $20
        .byte   $D3
        .byte   $B1
        .byte   $D0
        .byte   $06
        .byte   $C8
        .byte   $20
        .byte   $D3
        .byte   $B1
        .byte   $F0
        .byte   $07
        .byte   $A9
        .byte   $2D
        .byte   $2C
        .byte   $D2
        .byte   $02
        .byte   $30
        .byte   $02
        .byte   $A9
        .byte   $2B
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $AE
        .byte   $D3
        .byte   $02
        .byte   $BD
        .byte   $00
        .byte   $01
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $AC
        .byte   $E0
        .byte   $02
        .byte   $4C
        .byte   $6C
        .byte   $B2
        .byte   $AD
        .byte   $DC
        .byte   $02
        .byte   $30
        .byte   $B1
        .byte   $AD
        .byte   $DC
        .byte   $02
        .byte   $4C
        .byte   $76
        .byte   $B2
        .byte   $A5
        .byte   $76
        .byte   $D0
        .byte   $15
        .byte   $EC
        .byte   $CE
        .byte   $02
        .byte   $F0
        .byte   $05
        .byte   $E8
        .byte   $BD
        .byte   $00
        .byte   $01
        .byte   $2C
        .byte   $A9
        .byte   $30
        .byte   $4E
        .byte   $D0
        .byte   $02
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $D0
        .byte   $80
        .byte   $60
        .byte   $C6
        .byte   $76
        .byte   $AD
        .byte   $CF
        .byte   $02
        .byte   $30
        .byte   $EE
        .byte   $38
        .byte   $6E
        .byte   $CF
        .byte   $02
        .byte   $AD
        .byte   $EA
        .byte   $04
        .byte   $4C
        .byte   $73
        .byte   $B2
        .byte   $AD
        .byte   $D1
        .byte   $02
        .byte   $F0
        .byte   $D1
        .byte   $CE
        .byte   $D1
        .byte   $02
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $0E
        .byte   $B2
        .byte   $AD
        .byte   $D8
        .byte   $02
        .byte   $30
        .byte   $F6
        .byte   $20
        .byte   $71
        .text   $81,"I,P"
        .byte   $B2
        .byte   $AD
        .byte   $DD
        .byte   $02
        .byte   $20
        .byte   $B0
        .byte   $B2
        .byte   $C8
        .byte   $4C
        .byte   $9F
        .byte   $B2
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $CE
        .byte   $DB
        .byte   $02
        .byte   $60
        .byte   $AC
        .byte   $E0
        .byte   $02
        .byte   $20
        .byte   $5C
        .byte   $B1
        .byte   $20
        .byte   $6C
        .byte   $B3
        .byte   $D0
        .byte   $14
        .byte   $8C
        .byte   $DE
        .byte   $02
        .byte   $90
        .byte   $1A
        .byte   $AA
        .byte   $20
        .byte   $5C
        .byte   $B1
        .byte   $B0
        .byte   $05
        .byte   $20
        .byte   $74
        .byte   $B3
        .byte   $F0
        .byte   $0A
        .byte   $AC
        .byte   $DE
        .byte   $02
        .byte   $8A
        .byte   $20
        .byte   $B2
        .byte   $90
        .byte   $4C
        .byte   $BA
        .byte   $B2
        .byte   $B0
        .byte   $EA
        .byte   $AC
        .byte   $DE
        .byte   $02
        .byte   $A6
        .byte   $76
        .byte   $D0
        .byte   $7A
        .byte   $8E
        .byte   $DB
        .byte   $02
        .byte   $88
        .byte   $CE
        .byte   $DB
        .byte   $02
        .byte   $20
        .byte   $5C
        .byte   $B1
        .byte   $B0
        .byte   $74
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $F7
        .byte   $20
        .byte   $43
        .byte   $B3
        .byte   $90
        .byte   $EF
        .byte   $C9
        .byte   $2E
        .byte   $D0
        .byte   $08
        .byte   $E8
        .byte   $E0
        .byte   $02
        .byte   $90
        .byte   $E9
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $78
        .byte   $B3
        .byte   $D0
        .byte   $0B
        .byte   $90
        .byte   $03
        .byte   $8D
        .byte   $D5
        .byte   $02
        .byte   $FE
        .byte   $D6
        .byte   $02
        .byte   $4C
        .byte   $EC
        .byte   $B2
        .byte   $C9
        .byte   $24
        .byte   $D0
        .byte   $0F
        .byte   $2C
        .byte   $CF
        .byte   $02
        .byte   $10
        .byte   $F1
        .byte   $18
        .byte   $6E
        .byte   $CF
        .byte   $02
        .byte   $CE
        .byte   $D6
        .byte   $02
        .byte   $4C
        .byte   $10
        .byte   $B3
        .byte   $C9
        .byte   $5E
        .byte   $D0
        .byte   $16
        .byte   $A2
        .byte   $02
        .byte   $20
        .byte   $5C
        .byte   $B1
        .byte   $B0
        .byte   $CF
        .byte   $C9
        .byte   $5E
        .byte   $D0
        .byte   $CB
        .byte   $CA
        .byte   $10
        .byte   $F4
        .byte   $EE
        .byte   $D9
        .byte   $02
        .byte   $20
        .byte   $5C
        .byte   $B1
        .byte   $B0
        .text   $22,"I+P"
        .byte   $19
        .byte   $AD
        .byte   $DC
        .byte   $02
        .byte   $10
        .byte   $05
        .byte   $A9
        .byte   $2B
        .byte   $8D
        .byte   $DC
        .byte   $02
        .byte   $AD
        .byte   $D8
        .byte   $02
        .byte   $D0
        .byte   $AD
        .byte   $6E
        .byte   $D8
        .byte   $02
        .byte   $8C
        .byte   $E0
        .byte   $02
        .byte   $EE
        .byte   $DB
        .byte   $02
        .byte   $60
        .byte   $C9
        .byte   $2D
        .byte   $F0
        .byte   $ED
        .byte   $38
        .byte   $8C
        .byte   $E0
        .byte   $02
        .byte   $CE
        .byte   $E0
        .byte   $02
        .byte   $60
        .byte   $C9
        .byte   $2B
        .byte   $F0
        .byte   $15
        .byte   $C9
        .byte   $2D
        .byte   $F0
        .byte   $11
        .byte   $C9
        .byte   $2E
        .byte   $F0
        .byte   $0D
        .byte   $C9
        .byte   $3D
        .byte   $F0
        .byte   $09
        .byte   $C9
        .byte   $3E
        .byte   $F0
        .text   $05,"I#P"
        .byte   $01
        .byte   $18
        .byte   $60
        .byte   $A5
        .byte   $64
        .byte   $8D
        .byte   $EB
        .byte   $04
        .byte   $A5
        .byte   $65
        .byte   $8D
        .byte   $EC
        .byte   $04
        .text   " ,",$93," "
        .byte   $1A
        .byte   $93
        .byte   $A5
        .byte   $64
        .byte   $8D
        .byte   $ED
        .byte   $04
        .byte   $A5
        .byte   $65
        .byte   $8D
        .byte   $EE
        .byte   $04
        .byte   $A2
        .byte   $01
        .byte   $86
        .byte   $65
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $29
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $20
        .byte   $8B
        .byte   $94
        .byte   $A6
        .byte   $65
        .byte   $D0
        .byte   $03
        .text   "l",$1C,$99,"J"
        .byte   $86
        .byte   $61
        .byte   $A2
        .byte   $03
        .byte   $BD
        .byte   $EB
        .byte   $04
        .byte   $95
        .byte   $57
        .byte   $CA
        .byte   $10
        .byte   $F8
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $75
        .byte   $81
        .byte   $99
        .byte   $5B
        .byte   $00
        .byte   $20
        .byte   $79
        .byte   $81
        .byte   $99
        .byte   $5E
        .byte   $00
        .byte   $88
        .byte   $10
        .byte   $F1
        .byte   $A5
        .byte   $5E
        .byte   $F0
        .byte   $37
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $62
        .byte   $18
        .byte   $A5
        .byte   $5E
        .byte   $65
        .byte   $61
        .byte   $B0
        .text   ",E[",$90
        .byte   $02
        .byte   $D0
        .byte   $26
        .byte   $A4
        .byte   $62
        .byte   $C4
        .byte   $5E
        .byte   $F0
        .byte   $1B
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $61
        .byte   $A8
        .byte   $20
        .byte   $69
        .byte   $81
        .byte   $85
        .byte   $78
        .byte   $A4
        .byte   $62
        .byte   $20
        .byte   $6D
        .byte   $81
        .byte   $C5
        .byte   $78
        .byte   $F0
        .byte   $04
        .byte   $E6
        .byte   $61
        .byte   $D0
        .byte   $D2
        .byte   $E6
        .byte   $62
        .byte   $D0
        .byte   $DF
        .byte   $E6
        .byte   $61
        .byte   $A5
        .byte   $61
        .byte   $2C
        .byte   $A9
        .byte   $00
        .byte   $48
        .byte   $AD
        .byte   $ED
        .byte   $04
        .byte   $AC
        .byte   $EE
        .byte   $04
        .byte   $20
        .byte   $52
        .byte   $9C
        .byte   $AD
        .byte   $EB
        .byte   $04
        .byte   $AC
        .byte   $EC
        .byte   $04
        .byte   $20
        .byte   $52
        .byte   $9C
        .byte   $68
        .byte   $A8
        .text   "l",$81,$9A," "
        .byte   $86
        .byte   $9A
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $07
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $8C
        .byte   $F2
        .byte   $04
        .byte   $2C
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $F3
        .byte   $04
        .byte   $60
        .byte   $20
        .byte   $86
        .byte   $9A
        .byte   $AE
        .byte   $F1
        .byte   $04
        .byte   $E8
        .byte   $F0
        .byte   $70
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .text   "g",$90,":I"
        .byte   $82
        .byte   $D0
        .byte   $62
        .byte   $20
        .byte   $95
        .byte   $B4
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $A5
        .byte   $04
        .text   "P&H "
        .byte   $A5
        .byte   $04
        .byte   $D0
        .byte   $09
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $7E
        .byte   $86
        .byte   $A0
        .byte   $03
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $39
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $3A
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $3B
        .byte   $85
        .byte   $3B
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $3C
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $B0
        .byte   $8D
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $85
        .byte   $15
        .byte   $20
        .byte   $A4
        .byte   $B4
        .byte   $4C
        .byte   $69
        .byte   $8D
        .byte   $A2
        .byte   $01
        .byte   $BD
        .byte   $F0
        .byte   $04
        .byte   $95
        .byte   $39
        .byte   $BD
        .byte   $F5
        .byte   $04
        .byte   $95
        .byte   $3B
        .byte   $CA
        .byte   $10
        .byte   $F3
        .byte   $A2
        .byte   $FF
        .byte   $8E
        .byte   $EF
        .byte   $04
        .byte   $8E
        .byte   $F0
        .byte   $04
        .byte   $8E
        .byte   $F1
        .byte   $04
        .byte   $AE
        .byte   $F4
        .byte   $04
        .byte   $8E
        .byte   $F3
        .byte   $04
        .byte   $60
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A2
        .byte   $1F
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $87
        .byte   $9D
        .byte   $CA
        .byte   $8A
        .byte   $C9
        .byte   $24
        .byte   $B0
        .byte   $34
        .byte   $20
        .byte   $53
        .byte   $86
        .byte   $A0
        .byte   $FF
        .byte   $A2
        .byte   $00
        .byte   $E8
        .byte   $C8
        .byte   $B1
        .byte   $24
        .byte   $30
        .byte   $06
        .byte   $C9
        .byte   $20
        .byte   $90
        .byte   $F7
        .byte   $B0
        .byte   $F4
        .byte   $8A
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $A2
        .byte   $00
        .byte   $A0
        .byte   $FF
        .byte   $C8
        .byte   $B1
        .text   "$I ",$90
        .byte   $F9
        .byte   $20
        .byte   $FE
        .byte   $B4
        .byte   $48
        .byte   $29
        .byte   $7F
        .byte   $91
        .byte   $62
        .byte   $20
        .byte   $FE
        .byte   $B4
        .byte   $E8
        .byte   $68
        .byte   $10
        .byte   $EA
        .text   "lJ",$9C,"l",$1C,$99,"h"
        .byte   $8A
        .byte   $48
        .byte   $98
        .byte   $AA
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $17
        .byte   $93
        .byte   $A5
        .byte   $14
        .byte   $48
        .byte   $A5
        .byte   $15
        .byte   $48
        .byte   $20
        .byte   $E4
        .byte   $9D
        .byte   $A9
        .byte   $04
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $15
        .byte   $20
        .byte   $2D
        .byte   $B5
        .byte   $A5
        .byte   $14
        .byte   $20
        .byte   $2D
        .byte   $B5
        .byte   $68
        .byte   $85
        .byte   $15
        .byte   $68
        .byte   $85
        .byte   $14
        .text   "lJ",$9C,"hjjjj 6"
        .byte   $B5
        .byte   $68
        .byte   $29
        .byte   $0F
        .byte   $C9
        .byte   $0A
        .byte   $90
        .byte   $02
        .byte   $69
        .byte   $06
        .byte   $69
        .byte   $30
        .byte   $91
        .byte   $62
        .byte   $C8
        .byte   $60
        .byte   $20
        .byte   $48
        .byte   $9C
        .byte   $A8
        .byte   $88
        .byte   $C0
        .byte   $04
        .byte   $B0
        .byte   $AE
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $99
        .byte   $E7
        .byte   $04
        .byte   $88
        .byte   $10
        .byte   $F7
        .byte   $60
        .byte   $A0
        .byte   $01
        .byte   $B9
        .byte   $3B
        .byte   $00
        .byte   $99
        .byte   $F8
        .byte   $04
        .byte   $B9
        .byte   $39
        .byte   $00
        .byte   $99
        .byte   $FA
        .byte   $04
        .byte   $88
        .byte   $10
        .byte   $F1
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $1C
        .byte   $C9
        .byte   $FC
        .byte   $F0
        .byte   $11
        .byte   $C9
        .byte   $FD
        .text   "P? l"
        .byte   $B6
        .byte   $A5
        .byte   $61
        .byte   $D0
        .byte   $0D
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $4C
        .byte   $BA
        .byte   $B5
        .byte   $20
        .byte   $4C
        .byte   $B6
        .byte   $A5
        .byte   $61
        .byte   $D0
        .byte   $F3
        .byte   $A0
        .byte   $05
        .byte   $20
        .byte   $05
        .byte   $89
        .byte   $88
        .byte   $AD
        .byte   $F9
        .byte   $04
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $AD
        .byte   $F8
        .byte   $04
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $AD
        .byte   $FB
        .byte   $04
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $AD
        .byte   $FA
        .byte   $04
        .byte   $91
        .byte   $7C
        .byte   $88
        .byte   $A9
        .byte   $EB
        .byte   $91
        .byte   $7C
        .byte   $60
        .byte   $20
        .byte   $14
        .byte   $B6
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $06
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $F0
        .byte   $1D
        .byte   $C9
        .byte   $EC
        .byte   $F0
        .byte   $40
        .byte   $C9
        .byte   $22
        .byte   $F0
        .byte   $0A
        .byte   $C9
        .byte   $EB
        .byte   $D0
        .byte   $EF
        .byte   $20
        .byte   $B7
        .byte   $B5
        .byte   $4C
        .byte   $7C
        .byte   $B5
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $F0
        .byte   $06
        .byte   $C9
        .byte   $22
        .byte   $D0
        .byte   $F7
        .byte   $F0
        .byte   $DE
        .byte   $C9
        .byte   $3A
        .byte   $F0
        .byte   $DA
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $44
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $F0
        .byte   $3D
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $39
        .byte   $C8
        .byte   $20
        .byte   $A5
        .byte   $04
        .byte   $85
        .byte   $3A
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $3B
        .byte   $85
        .byte   $3B
        .byte   $90
        .byte   $BB
        .byte   $E6
        .byte   $3C
        .byte   $D0
        .byte   $B7
        .byte   $4C
        .byte   $B0
        .byte   $8D
        .byte   $F0
        .byte   $2D
        .byte   $C9
        .byte   $FD
        .byte   $F0
        .byte   $24
        .byte   $C9
        .byte   $FC
        .byte   $D0
        .byte   $A7
        .byte   $20
        .byte   $4C
        .byte   $B6
        .byte   $A5
        .byte   $61
        .byte   $F0
        .byte   $1E
        .byte   $A9
        .byte   $EB
        .byte   $85
        .byte   $02
        .byte   $20
        .byte   $71
        .byte   $88
        .byte   $D0
        .byte   $0B
        .byte   $20
        .byte   $69
        .byte   $A7
        .byte   $A0
        .byte   $05
        .byte   $4C
        .byte   $72
        .byte   $A7
        .byte   $A2
        .byte   $20
        .byte   $2C
        .byte   $A2
        .byte   $21
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $20
        .byte   $4C
        .byte   $B6
        .byte   $F0
        .byte   $E2
        .byte   $20
        .byte   $14
        .byte   $B6
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3C
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $3B
        .byte   $88
        .byte   $B1
        .byte   $3D
        .byte   $20
        .byte   $7F
        .byte   $CD
        .byte   $B1
        .byte   $3D
        .byte   $85
        .byte   $39
        .byte   $4C
        .byte   $57
        .byte   $B5
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $4C
        .byte   $2C
        .byte   $93
        .byte   $A9
        .byte   $FF
        .byte   $2C
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $EB
        .byte   $02
        .byte   $60
        .byte   $20
        .byte   $8E
        .byte   $94
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $85
        .byte   $49
        .byte   $84
        .byte   $4A
        .byte   $20
        .byte   $1A
        .byte   $93
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $CA
        .byte   $86
        .byte   $77
        .byte   $C9
        .byte   $29
        .byte   $F0
        .byte   $04
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $2C
        .byte   $A2
        .byte   $FF
        .byte   $86
        .byte   $78
        .byte   $20
        .byte   $8B
        .byte   $94
        .byte   $A9
        .byte   $B2
        .byte   $20
        .byte   $93
        .byte   $94
        .text   " ,",$93," "
        .byte   $1A
        .byte   $93
        .byte   $A0
        .byte   $02
        .byte   $A9
        .byte   $49
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $99
        .byte   $5B
        .byte   $00
        .byte   $20
        .byte   $DC
        .byte   $04
        .byte   $99
        .byte   $5E
        .byte   $00
        .byte   $88
        .byte   $10
        .byte   $EF
        .byte   $38
        .byte   $A5
        .byte   $5F
        .byte   $E5
        .byte   $77
        .byte   $85
        .byte   $5F
        .byte   $B0
        .byte   $02
        .byte   $C6
        .byte   $60
        .byte   $A5
        .byte   $78
        .byte   $C5
        .byte   $5E
        .byte   $90
        .byte   $02
        .byte   $A5
        .byte   $5E
        .byte   $AA
        .byte   $F0
        .byte   $16
        .byte   $18
        .byte   $65
        .byte   $77
        .byte   $B0
        .byte   $14
        .byte   $C5
        .byte   $5B
        .byte   $90
        .byte   $02
        .byte   $D0
        .byte   $0E
        .byte   $A4
        .byte   $77
        .byte   $20
        .byte   $6D
        .byte   $81
        .byte   $91
        .byte   $5C
        .byte   $C8
        .byte   $CA
        .byte   $D0
        .byte   $F7
        .text   "ln",$9C,"l",$1C,$99," "
        .byte   $DE
        .byte   $B6
        .byte   $20
        .byte   $3E
        .byte   $8E
        .byte   $A5
        .byte   $14
        .byte   $85
        .byte   $73
        .byte   $A5
        .byte   $15
        .byte   $85
        .byte   $74
        .byte   $4C
        .byte   $7E
        .byte   $86
        .byte   $24
        .byte   $81
        .byte   $30
        .byte   $01
        .byte   $60
        .byte   $A2
        .byte   $22
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $AE
        .byte   $EF
        .byte   $04
        .byte   $E8
        .byte   $F0
        .byte   $1B
        .byte   $AD
        .byte   $F0
        .byte   $04
        .byte   $AC
        .byte   $F1
        .byte   $04
        .byte   $85
        .byte   $14
        .byte   $84
        .byte   $15
        .byte   $20
        .byte   $3D
        .byte   $8A
        .byte   $90
        .byte   $0C
        .byte   $66
        .text   "s >",$90
        .byte   $A6
        .byte   $14
        .byte   $A5
        .byte   $15
        .byte   $20
        .byte   $40
        .byte   $8B
        .byte   $4C
        .byte   $3E
        .byte   $90
        .byte   $A6
        .byte   $60
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $5F
        .byte   $90
        .byte   $01
        .byte   $E8
        .byte   $EC
        .byte   $F6
        .byte   $04
        .byte   $D0
        .byte   $0E
        .byte   $CD
        .byte   $F5
        .byte   $04
        .byte   $90
        .byte   $09
        .byte   $F0
        .byte   $07
        .byte   $46
        .byte   $53
        .byte   $A9
        .byte   $82
        .byte   $4C
        .byte   $B2
        .byte   $90
        .byte   $60
        .byte   $D0
        .byte   $7C
        .byte   $A2
        .byte   $00
        .byte   $A0
        .byte   $00
        .byte   $E8
        .byte   $BD
        .byte   $5E
        .byte   $05
        .byte   $F0
        .byte   $53
        .byte   $85
        .byte   $77
        .byte   $86
        .byte   $76
        .byte   $A2
        .byte   $05
        .byte   $BD
        .byte   $6E
        .byte   $CD
        .byte   $CA
        .byte   $D0
        .byte   $02
        .byte   $05
        .byte   $76
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $8A
        .byte   $10
        .byte   $F2
        .byte   $A2
        .byte   $07
        .byte   $B9
        .byte   $67
        .byte   $05
        .byte   $C8
        .byte   $48
        .byte   $86
        .byte   $80
        .byte   $A2
        .byte   $04
        .byte   $DD
        .byte   $39
        .byte   $B8
        .byte   $F0
        .byte   $34
        .byte   $CA
        .byte   $D0
        .byte   $F8
        .byte   $A6
        .byte   $80
        .byte   $E0
        .byte   $08
        .text   $90,$07,"P",$0A
        .byte   $A9
        .byte   $2B
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A9
        .byte   $22
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $68
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A2
        .byte   $09
        .byte   $C6
        .byte   $77
        .byte   $D0
        .byte   $D3
        .byte   $E0
        .byte   $09
        .byte   $90
        .byte   $05
        .byte   $A9
        .byte   $22
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A9
        .byte   $8D
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A6
        .byte   $76
        .byte   $E0
        .byte   $08
        .byte   $D0
        .byte   $A3
        .byte   $60
        .byte   $A6
        .byte   $80
        .byte   $BD
        .byte   $30
        .byte   $B8
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $CA
        .byte   $E0
        .byte   $03
        .byte   $B0
        .byte   $F5
        .byte   $68
        .byte   $20
        .byte   $74
        .byte   $CD
        .byte   $A9
        .byte   $29
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A2
        .byte   $08
        .byte   $D0
        .byte   $CD
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $CA
        .byte   $E0
        .byte   $08
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $86
        .byte   $76
        .byte   $20
        .byte   $91
        .byte   $94
        .text   " h",$9C," B"
        .byte   $B7
        .byte   $90
        .byte   $72
        .byte   $4C
        .byte   $81
        .byte   $86
        .byte   $85
        .byte   $77
        .byte   $A2
        .byte   $08
        .byte   $20
        .byte   $3E
        .byte   $B8
        .byte   $8D
        .byte   $CD
        .byte   $02
        .byte   $A6
        .byte   $76
        .byte   $E8
        .byte   $20
        .byte   $3E
        .byte   $B8
        .byte   $8D
        .byte   $CE
        .byte   $02
        .byte   $A6
        .byte   $76
        .byte   $A5
        .byte   $77
        .byte   $38
        .byte   $FD
        .byte   $5F
        .byte   $05
        .byte   $F0
        .byte   $35
        .byte   $90
        .byte   $1D
        .byte   $18
        .byte   $6D
        .byte   $CD
        .byte   $02
        .byte   $B0
        .byte   $4B
        .byte   $C9
        .byte   $81
        .byte   $B0
        .byte   $47
        .byte   $AA
        .byte   $AC
        .byte   $CD
        .byte   $02
        .byte   $CC
        .byte   $CE
        .byte   $02
        .byte   $F0
        .byte   $20
        .byte   $88
        .byte   $CA
        .byte   $B9
        .byte   $67
        .byte   $05
        .byte   $9D
        .byte   $67
        .byte   $05
        .byte   $B0
        .byte   $F1
        .byte   $6D
        .byte   $CE
        .byte   $02
        .byte   $AA
        .byte   $AC
        .byte   $CE
        .byte   $02
        .byte   $CC
        .byte   $CD
        .byte   $02
        .byte   $B0
        .byte   $0A
        .byte   $B9
        .byte   $67
        .byte   $05
        .byte   $9D
        .byte   $67
        .byte   $05
        .byte   $C8
        .byte   $E8
        .byte   $90
        .byte   $F1
        .byte   $A6
        .byte   $76
        .byte   $20
        .byte   $3E
        .byte   $B8
        .byte   $AA
        .byte   $A4
        .byte   $76
        .byte   $A5
        .byte   $77
        .byte   $99
        .byte   $5F
        .byte   $05
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $C6
        .byte   $77
        .byte   $30
        .byte   $07
        .byte   $9D
        .byte   $67
        .byte   $05
        .byte   $E8
        .byte   $C8
        .byte   $D0
        .byte   $F2
        .byte   $18
        .byte   $60
        .text   "($rhc+",$22,$0D
        .byte   $8D
        .byte   $22
        .byte   $1B
        .byte   $A9
        .byte   $00
        .byte   $18
        .byte   $CA
        .byte   $30
        .byte   $EE
        .byte   $7D
        .byte   $5F
        .byte   $05
        .byte   $90
        .byte   $F8
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $CA
        .byte   $E0
        .byte   $03
        .byte   $B0
        .byte   $64
        .byte   $86
        .byte   $80
        .byte   $20
        .byte   $DE
        .byte   $9D
        .byte   $C9
        .byte   $04
        .byte   $B0
        .byte   $5B
        .byte   $84
        .byte   $7E
        .byte   $85
        .byte   $7F
        .byte   $20
        .byte   $DE
        .byte   $9D
        .byte   $A6
        .byte   $80
        .byte   $E0
        .byte   $02
        .byte   $D0
        .byte   $01
        .byte   $CA
        .byte   $48
        .byte   $C0
        .byte   $00
        .byte   $D0
        .byte   $07
        .byte   $C9
        .byte   $00
        .byte   $D0
        .byte   $03
        .byte   $C8
        .byte   $D0
        .byte   $0F
        .byte   $98
        .byte   $48
        .byte   $20
        .byte   $C0
        .byte   $8C
        .byte   $BD
        .byte   $FE
        .byte   $04
        .byte   $1D
        .byte   $FC
        .byte   $04
        .byte   $D0
        .byte   $F5
        .byte   $68
        .byte   $A8
        .byte   $98
        .byte   $49
        .byte   $FF
        .byte   $18
        .byte   $69
        .byte   $01
        .byte   $78
        .byte   $9D
        .byte   $FC
        .byte   $04
        .byte   $68
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $00
        .byte   $9D
        .byte   $FE
        .byte   $04
        .byte   $A5
        .byte   $7E
        .byte   $9D
        .byte   $0E
        .byte   $FF
        .byte   $BD
        .byte   $B8
        .byte   $B8
        .byte   $AA
        .byte   $BD
        .byte   $10
        .byte   $FF
        .byte   $29
        .byte   $FC
        .byte   $05
        .byte   $7F
        .byte   $9D
        .byte   $10
        .byte   $FF
        .byte   $A6
        .byte   $80
        .byte   $BD
        .byte   $BA
        .byte   $B8
        .byte   $0D
        .byte   $11
        .byte   $FF
        .byte   $8D
        .byte   $11
        .byte   $FF
        .byte   $58
        .byte   $60
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $02
        .byte   $00
        .byte   $10
        .byte   $20
        .byte   $40
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $E0
        .byte   $09
        .byte   $B0
        .byte   $F1
        .byte   $86
        .byte   $80
        .byte   $AD
        .byte   $11
        .byte   $FF
        .byte   $29
        .byte   $F0
        .byte   $05
        .byte   $80
        .byte   $8D
        .byte   $11
        .byte   $FF
        .byte   $60
        .byte   $20
        .byte   $B6
        .byte   $C3
        .byte   $A2
        .byte   $04
        .text   " YC "
        .byte   $7B
        .byte   $C3
        .byte   $20
        .byte   $A5
        .byte   $C3
        .byte   $E0
        .byte   $02
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $8A
        .byte   $4A
        .byte   $6A
        .byte   $85
        .byte   $8B
        .byte   $10
        .byte   $04
        .byte   $A5
        .byte   $84
        .byte   $F0
        .byte   $07
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $B0
        .byte   $02
        .byte   $D0
        .byte   $01
        .byte   $60
        .byte   $20
        .byte   $54
        .byte   $A9
        .byte   $A5
        .byte   $31
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $32
        .byte   $85
        .byte   $23
        .byte   $38
        .byte   $A5
        .byte   $33
        .byte   $E9
        .byte   $03
        .byte   $85
        .byte   $19
        .byte   $A5
        .byte   $34
        .byte   $E9
        .byte   $00
        .byte   $85
        .byte   $1A
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $89
        .byte   $86
        .byte   $8A
        .byte   $AE
        .byte   $AF
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $CE
        .byte   $B0
        .byte   $02
        .byte   $CE
        .byte   $AF
        .byte   $02
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $B0
        .byte   $02
        .byte   $D0
        .byte   $EE
        .byte   $EE
        .byte   $AF
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $B0
        .byte   $02
        .byte   $20
        .byte   $C3
        .byte   $C1
        .byte   $AE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $CE
        .byte   $AE
        .byte   $02
        .byte   $CE
        .byte   $AD
        .byte   $02
        .byte   $A5
        .byte   $89
        .byte   $20
        .byte   $9F
        .byte   $B9
        .byte   $85
        .byte   $89
        .byte   $18
        .byte   $AD
        .byte   $AD
        .byte   $02
        .byte   $69
        .byte   $02
        .byte   $8D
        .byte   $AD
        .byte   $02
        .byte   $90
        .byte   $03
        .byte   $EE
        .byte   $AE
        .byte   $02
        .byte   $A5
        .byte   $8A
        .byte   $20
        .byte   $9F
        .byte   $B9
        .byte   $85
        .byte   $8A
        .byte   $AE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $CE
        .byte   $AE
        .byte   $02
        .byte   $CE
        .byte   $AD
        .byte   $02
        .byte   $EE
        .byte   $AF
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $B0
        .byte   $02
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $B0
        .byte   $02
        .byte   $D0
        .byte   $BC
        .byte   $A2
        .byte   $03
        .byte   $A0
        .byte   $00
        .byte   $A5
        .text   "#E2P"
        .byte   $06
        .byte   $A5
        .byte   $22
        .byte   $C5
        .byte   $31
        .byte   $F0
        .byte   $17
        .byte   $A5
        .byte   $22
        .byte   $D0
        .byte   $02
        .text   "F#F",$22," "
        .byte   $B0
        .byte   $04
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $CA
        .byte   $10
LB995   .byte   $EF
        .byte   $20
        .byte   $C0
        .byte   $8C
        .byte   $4C
        .byte   $11
        .byte   $B9
        .byte   $4C
        .byte   $7B
        .byte   $C3
        .byte   $48
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $B0
        .byte   $2B
        .byte   $F0
        .byte   $29
        .byte   $68
        .byte   $D0
        .byte   $29
        .byte   $AA
        .byte   $A8
        .byte   $A5
        .byte   $23
        .byte   $C5
        .byte   $1A
        .byte   $90
        .byte   $0B
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $22
        .byte   $C5
        .byte   $19
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $81
        .byte   $86
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $91
        .byte   $22
        .byte   $E6
        .byte   $22
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $23
        .byte   $E8
        .byte   $E0
        .byte   $04
        .byte   $D0
        .byte   $F0
        .byte   $A9
        .byte   $80
        .byte   $60
        .byte   $68
        .byte   $A9
        .byte   $00
        .byte   $60
        .byte   $20
        .byte   $B9
        .byte   $C3
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $E0
        .byte   $28
        .byte   $B0
        .byte   $0A
        .byte   $8E
        .byte   $DA
        .byte   $02
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $E0
        .byte   $19
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $8E
        .byte   $DB
        .byte   $02
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $20
        .byte   $48
        .byte   $9C
        .byte   $8D
        .byte   $EA
        .byte   $02
        .byte   $98
        .byte   $48
        .byte   $8A
        .byte   $48
        .byte   $20
        .byte   $A5
        .byte   $C3
        .byte   $8A
        .byte   $6A
        .byte   $6E
        .byte   $B9
        .byte   $02
        .byte   $68
        .byte   $85
        .byte   $22
        .byte   $68
        .byte   $85
        .byte   $23
        .byte   $A5
        .byte   $83
        .byte   $D0
        .byte   $1B
        .byte   $AE
        .byte   $DB
        .byte   $02
        .byte   $AC
        .byte   $DA
        .byte   $02
        .byte   $18
        .byte   $20
        .byte   $F0
        .byte   $FF
        .byte   $A0
        .byte   $00
        .byte   $CC
        .byte   $EA
        .byte   $02
        .byte   $F0
        .byte   $09
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $20
        .byte   $4C
        .byte   $FF
        .byte   $C8
        .byte   $D0
        .byte   $F2
        .byte   $60
        .byte   $20
        .byte   $BF
        .byte   $C7
        .byte   $A5
        .byte   $86
        .byte   $48
        .byte   $A5
        .byte   $84
        .byte   $48
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $0F
        .byte   $68
        .byte   $F0
        .byte   $12
        .byte   $4A
        .byte   $F0
        .byte   $0F
        .byte   $A6
        .byte   $85
        .byte   $90
        .byte   $0D
        .byte   $AE
        .byte   $16
        .byte   $FF
        .byte   $B0
        .byte   $08
        .byte   $AE
        .byte   $15
        .byte   $FF
        .byte   $68
        .byte   $F0
        .byte   $02
        .byte   $A6
        .byte   $86
        .byte   $86
        .byte   $86
        .byte   $AE
        .byte   $DB
        .byte   $02
        .byte   $A0
        .byte   $00
        .byte   $8C
        .byte   $DC
        .byte   $02
        .byte   $AC
        .byte   $DC
        .byte   $02
        .byte   $EE
        .byte   $DC
        .byte   $02
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $CE
        .byte   $EA
        .byte   $02
        .byte   $30
        .byte   $17
        .byte   $AC
        .byte   $DA
        .byte   $02
        .byte   $20
        .byte   $7F
        .byte   $BA
        .byte   $EE
        .byte   $DA
        .byte   $02
        .byte   $C0
        .byte   $27
        .byte   $90
        .byte   $E5
        .byte   $A0
        .byte   $00
        .byte   $8C
        .byte   $DA
        .byte   $02
        .byte   $E8
        .byte   $E0
        .byte   $18
        .byte   $90
        .byte   $DB
        .byte   $68
        .byte   $85
        .byte   $86
        .byte   $60
        .byte   $48
        .byte   $20
        .byte   $1A
        .byte   $C2
        .byte   $20
        .byte   $91
        .byte   $C2
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $7E
        .byte   $68
        .byte   $48
        .byte   $0A
        .byte   $26
        .byte   $7E
        .byte   $0A
        .byte   $0A
        .byte   $26
        .byte   $7E
        .byte   $85
        .byte   $24
        .byte   $A5
        .byte   $7E
        .byte   $6D
        .byte   $E4
        .byte   $02
        .byte   $85
        .byte   $25
        .byte   $98
        .byte   $48
        .byte   $A0
        .byte   $07
        .byte   $AD
        .byte   $B9
        .byte   $02
        .byte   $0A
        .byte   $B1
        .byte   $24
        .byte   $90
        .byte   $02
        .byte   $49
        .byte   $FF
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $2B
        .byte   $29
        .byte   $AA
        .byte   $85
        .byte   $7E
        .byte   $A5
        .byte   $84
        .byte   $D0
        .byte   $0F
        .byte   $A5
        .byte   $7E
        .byte   $B0
        .byte   $07
        .byte   $4A
        .byte   $45
        .byte   $7E
        .byte   $49
        .byte   $AA
        .byte   $D0
        .byte   $18
        .byte   $09
        .byte   $55
        .byte   $D0
        .byte   $14
        .byte   $C9
        .byte   $02
        .byte   $D0
        .byte   $04
        .byte   $A5
        .byte   $7E
        .byte   $B0
        .byte   $0C
        .byte   $90
        .byte   $07
        .byte   $A5
        .byte   $7E
        .byte   $4A
        .byte   $45
        .byte   $7E
        .byte   $90
        .byte   $03
        .byte   $A5
        .byte   $7E
        .byte   $4A
        .byte   $91
        .byte   $8C
        .byte   $88
        .byte   $10
        .byte   $C2
        .byte   $68
        .byte   $A8
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $B6
        .byte   $C3
        .byte   $A2
        .byte   $1F
        .byte   $20
        .byte   $F4
        .byte   $C3
        .byte   $A2
        .text   "+ YC "
        .byte   $8F
        .byte   $C3
        .byte   $8C
        .byte   $D0
        .byte   $02
        .byte   $8D
        .byte   $D1
        .byte   $02
        .byte   $20
        .byte   $A5
        .byte   $C3
        .byte   $E0
        .byte   $02
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $8E
        .byte   $E8
        .byte   $02
        .byte   $8A
        .byte   $48
        .byte   $20
        .byte   $B4
        .byte   $BB
        .byte   $68
        .byte   $D0
        .byte   $1C
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $36
        .byte   $BC
        .byte   $20
        .byte   $DA
        .byte   $C0
        .byte   $AD
        .byte   $CA
        .byte   $02
        .byte   $D0
        .byte   $F5
        .byte   $A2
        .byte   $04
        .byte   $BD
        .byte   $D7
        .byte   $02
        .byte   $9D
        .byte   $AC
        .byte   $02
        .byte   $CA
        .byte   $D0
        .byte   $F7
        .byte   $8E
        .byte   $E8
        .byte   $02
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $AD
        .byte   $C5
        .byte   $02
        .byte   $4A
        .byte   $90
        .byte   $02
        .byte   $A2
        .byte   $02
        .byte   $BD
        .byte   $DC
        .byte   $02
        .byte   $8D
        .byte   $D6
        .byte   $02
        .byte   $BD
        .byte   $DD
        .byte   $02
        .byte   $8D
        .byte   $D7
LBB3E   .byte   $02
LBB3F   .byte   $A9
LBB40   .byte   $00
        .byte   $A2
        .byte   $03
        .byte   $9D
        .byte   $D2
LBB45   .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $FA
        .byte   $A2
        .byte   $07
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $48
        .byte   $CA
        .byte   $10
        .byte   $F9
        .byte   $20
        .byte   $DA
        .byte   $C0
        .byte   $A2
        .byte   $00
        .byte   $68
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $E8
        .byte   $E0
        .byte   $08
        .byte   $D0
        .byte   $F7
        .byte   $AD
        .byte   $D6
        .byte   $02
        .text   "P",$05,"NW"
        .byte   $02
        .byte   $30
        .byte   $B0
        .byte   $CE
        .byte   $D6
        .byte   $02
        .byte   $A2
        .byte   $25
        .byte   $A0
        .byte   $1B
        .byte   $AD
        .byte   $C5
        .byte   $02
        .byte   $4A
        .byte   $90
        .byte   $02
        .byte   $A0
        .byte   $19
        .byte   $A9
        .byte   $00
        .byte   $4A
        .byte   $48
        .byte   $20
        .byte   $F6
        .byte   $C2
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $68
        .byte   $90
        .byte   $02
        .byte   $09
        .byte   $A0
        .byte   $E8
        .byte   $E8
        .byte   $A0
        .byte   $19
        .byte   $4E
        .byte   $C5
        .byte   $02
        .byte   $90
        .byte   $02
        .byte   $A0
        .byte   $1B
        .byte   $2E
        .byte   $C5
        .byte   $02
        .byte   $E0
        .byte   $27
        .byte   $F0
        .byte   $DD
        .byte   $A2
        .byte   $06
        .byte   $0A
        .byte   $F0
        .byte   $BD
        .byte   $90
        .byte   $08
        .byte   $FE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $FE
        .byte   $AE
        .byte   $02
        .byte   $0A
        .byte   $CA
        .byte   $CA
        .byte   $10
        .byte   $F1
        .byte   $30
        .byte   $95
        .byte   $A0
        .byte   $23
        .byte   $20
        .byte   $56
        .byte   $BC
        .byte   $A2
        .byte   $1F
        .byte   $A0
        .text   "+",$98,"h ",$22,"C"
        .byte   $9D
        .byte   $B1
        .byte   $02
        .byte   $9D
        .byte   $B5
        .byte   $02
        .byte   $9D
        .byte   $BD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $B2
        .byte   $02
        .byte   $9D
        .byte   $B6
        .byte   $02
        .byte   $9D
        .byte   $BE
        .byte   $02
        .byte   $68
        .byte   $A8
        .byte   $20
        .byte   $F6
        .byte   $C2
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $A0
        .byte   $2D
        .byte   $E8
        .byte   $E8
        .byte   $E0
        .byte   $21
        .byte   $F0
        .byte   $D4
        .byte   $A9
        .byte   $90
        .byte   $20
        .byte   $D5
        .byte   $BC
        .byte   $AD
        .byte   $C5
        .byte   $02
        .byte   $29
        .byte   $03
        .byte   $8D
        .byte   $C5
        .byte   $02
        .byte   $AA
        .byte   $BD
        .byte   $18
        .byte   $BC
        .byte   $20
        .byte   $36
        .byte   $BC
        .byte   $20
        .byte   $7B
        .byte   $C3
        .byte   $AD
        .byte   $CA
        .byte   $02
        .byte   $20
        .byte   $36
        .byte   $BC
        .byte   $AE
        .byte   $C5
        .byte   $02
        .byte   $BD
        .byte   $18
        .byte   $BC
        .byte   $29
        .byte   $F0
        .byte   $8D
        .byte   $CB
        .byte   $02
        .byte   $BD
        .byte   $1C
        .byte   $BC
        .byte   $8D
        .byte   $CA
        .byte   $02
        .byte   $60
        .byte   $BE
        .byte   $E4
        .byte   $41
        .byte   $1B
        .byte   $41
        .byte   $1B
LBC1E   .byte   $BE
LBC1F   .byte   $E4
        .text   "fred"

LBC24   jsr     $0D42      ;6
        .text   "terry r",$0D,"mike i",$0D," ",$05
        .byte   $BD
        .byte   $A2
        .byte   $04
        .byte   $BD
        .byte   $AE
        .byte   $02
        .byte   $0A
        .byte   $7E
        .byte   $AE
        .byte   $02
        .byte   $7E
        .byte   $AD
        .byte   $02
        .byte   $90
        .byte   $08
        .byte   $FE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $FE
        .byte   $AE
        .byte   $02
        .byte   $E8
        .byte   $E8
        .byte   $E0
        .byte   $06
        .byte   $F0
        .byte   $E6
        .byte   $60
        .byte   $20
        .byte   $18
        .byte   $C3
        .byte   $A2
        .byte   $00
        .byte   $E8
        .byte   $38
        .byte   $E9
        .byte   $5A
        .byte   $B0
        .byte   $FA
        .byte   $88
        .byte   $10
        .byte   $F7
        .byte   $8E
        .byte   $C5
        .byte   $02
        .byte   $48
        .byte   $69
        .byte   $5A
        .byte   $20
        .byte   $76
        .byte   $BC
        .byte   $68
        .byte   $18
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $01
        .byte   $CE
        .byte   $C5
        .byte   $02
        .byte   $A2
        .byte   $FF
        .byte   $E8
        .byte   $38
        .byte   $E9
        .byte   $0A
        .byte   $B0
        .byte   $FA
        .byte   $69
        .byte   $0A
        .byte   $85
        .byte   $8E
        .byte   $8A
        .byte   $0A
        .byte   $AA
        .byte   $BD
        .byte   $B4
        .byte   $C4
        .byte   $BC
        .byte   $B3
        .byte   $C4
        .byte   $18
        .byte   $C6
        .byte   $8E
        .byte   $30
        .byte   $0C
        .byte   $7D
        .text   "HDh",$98
        .byte   $7D
        .byte   $C7
        .byte   $C4
        .byte   $A8
        .byte   $68
        .byte   $90
        .byte   $EF
        .byte   $48
        .byte   $A2
        .byte   $00
        .byte   $AD
        .byte   $C5
        .byte   $02
        .byte   $4A
        .byte   $B0
        .byte   $02
        .byte   $A2
        .byte   $02
        .byte   $68
        .byte   $9D
        .byte   $C6
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $C7
        .byte   $02
        .byte   $60
        .byte   $A0
        .byte   $19
        .byte   $90
        .byte   $02
        .byte   $A0
        .byte   $1B
        .byte   $AD
        .byte   $C5
        .byte   $02
        .byte   $69
        .byte   $02
        .byte   $4A
        .byte   $4A
        .byte   $08
        .byte   $20
        .byte   $18
        .byte   $C3
        .byte   $C0
        .byte   $FF
        .byte   $90
        .byte   $07
        .byte   $8A
        .byte   $A8
        .byte   $20
        .byte   $18
        .byte   $C3
        .byte   $B0
        .byte   $03
        .text   " 7C("
        .byte   $B0
        .byte   $1B
        .byte   $4C
        .byte   $27
        .byte   $C3
        .byte   $8D
        .byte   $CA
        .byte   $02
        .byte   $A2
        .byte   $23
        .byte   $0E
        .byte   $CA
        .byte   $02
        .byte   $20
        .byte   $B0
        .byte   $BC
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $E8
        .byte   $E8
        .byte   $E0
        .byte   $2B
        .byte   $90
        .byte   $ED
        .byte   $60
        .byte   $A0
        .byte   $2B
        .byte   $20
        .byte   $56
        .byte   $BC
        .byte   $A2
        .byte   $07
        .byte   $BD
        .byte   $DC
        .byte   $02
        .byte   $9D
        .byte   $D0
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $A9
        .byte   $50
        .byte   $20
        .byte   $D5
        .byte   $BC
        .byte   $A9
        .byte   $10
        .byte   $8D
        .byte   $CA
        .byte   $02
        .byte   $A0
        .byte   $1F
        .byte   $A2
        .byte   $23
        .byte   $0E
        .byte   $CB
        .byte   $02
        .byte   $2E
        .byte   $CA
        .byte   $02
        .byte   $20
        .byte   $F4
        .byte   $C2
        .byte   $E8
        .byte   $E8
        .byte   $0E
        .byte   $CB
        .byte   $02
        .byte   $2E
        .byte   $CA
        .byte   $02
        .byte   $20
        .byte   $F0
        .text   "Bh",$98,"h"
        .byte   $A0
        .byte   $21
        .byte   $E8
        .byte   $E8
        .byte   $E0
        .byte   $27
        .byte   $F0
        .byte   $E1
        .byte   $A2
        .byte   $03
        .byte   $68
        .byte   $9D
        .byte   $B1
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F9
        .byte   $60
        .byte   $20
        .byte   $BF
        .text   "G h",$9C
        .byte   $8D
        .byte   $CF
        .byte   $02
        .byte   $86
        .byte   $24
        .byte   $84
        .byte   $25
        .byte   $A2
        .byte   $04
        .text   " YC "
        .byte   $A5
        .byte   $C3
        .byte   $E0
        .byte   $05
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $8E
        .byte   $D0
        .byte   $02
        .byte   $A2
        .byte   $03
        .byte   $AC
        .byte   $CF
        .byte   $02
        .byte   $C0
        .byte   $05
        .byte   $B0
        .byte   $01
        .byte   $60
LBD5E   .byte   $88
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $9D
        .byte   $D5
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F6
        .byte   $8E
        .byte   $D1
        .byte   $02
        .byte   $20
        .byte   $7B
        .byte   $C3
        .byte   $AD
        .byte   $D5
        .byte   $02
        .byte   $8D
        .byte   $D9
        .byte   $02
        .byte   $AD
        .byte   $D6
        .byte   $02
        .byte   $8D
        .byte   $DA
        .byte   $02
        .byte   $A9
        .byte   $08
        .byte   $8D
        .byte   $E5
        .byte   $02
        .byte   $EE
        .byte   $D1
        .byte   $02
        .byte   $AC
        .byte   $D1
        .byte   $02
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $8D
        .byte   $D3
        .byte   $02
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $8D
        .byte   $D2
        .byte   $02
        .byte   $0E
        .byte   $D3
        .byte   $02
        .byte   $2A
        .byte   $CE
        .byte   $E5
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $07
        .byte   $0E
        .byte   $D3
        .byte   $02
        .byte   $2A
        .byte   $CE
        .byte   $E5
        .byte   $02
        .byte   $AE
        .byte   $D0
        .byte   $02
        .byte   $E0
        .byte   $03
        .byte   $90
        .byte   $0C
        .byte   $F0
        .byte   $05
        .byte   $4D
        .byte   $D2
        .byte   $02
        .byte   $B0
        .byte   $11
        .byte   $2D
        .byte   $D2
        .byte   $02
        .byte   $B0
        .byte   $0C
        .byte   $E0
        .byte   $01
LBDB8   .byte   $90
LBDB9   .byte   $08
        .byte   $F0
        .byte   $04
        .byte   $0D
        .byte   $D2
        .byte   $02
        .byte   $2C
        .byte   $49
        .byte   $FF
        .byte   $29
        .byte   $03
        .byte   $24
        .byte   $83
        .byte   $30
        .byte   $02
        .byte   $29
        .byte   $01
        .byte   $85
        .byte   $84
        .byte   $20
        .byte   $C3
        .byte   $C1
        .byte   $EE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $AE
        .byte   $02
        .byte   $38
        .byte   $AD
        .byte   $D9
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $03
        .byte   $E9
        .byte   $02
        .byte   $2C
        .byte   $E9
        .byte   $01
        .byte   $8D
        .byte   $D9
        .byte   $02
        .byte   $AD
        .byte   $DA
        .byte   $02
        .byte   $E9
        .byte   $00
        .byte   $8D
        .byte   $DA
        .byte   $02
        .byte   $B0
        .byte   $2D
        .byte   $A2
        .byte   $01
        .byte   $BD
        .byte   $D5
        .byte   $02
        .byte   $9D
        .byte   $D9
        .byte   $02
        .byte   $BD
        .byte   $B1
        .byte   $02
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F1
        .byte   $EE
        .byte   $AF
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $B0
        .byte   $02
        .byte   $38
        .byte   $AD
        .byte   $D7
        .byte   $02
        .byte   $E9
        .byte   $01
        .byte   $8D
        .byte   $D7
        .byte   $02
        .byte   $AD
        .byte   $D8
        .byte   $02
        .byte   $E9
        .byte   $00
        .byte   $8D
        .byte   $D8
        .byte   $02
        .byte   $B0
        .byte   $09
        .byte   $60
        .byte   $AD
        .byte   $E5
        .byte   $02
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $8B
        .byte   $BD
        .byte   $4C
        .byte   $7A
        .byte   $BD
        .byte   $20
        .byte   $BF
        .byte   $C7
        .byte   $20
        .byte   $A5
        .byte   $96
        .byte   $8D
        .byte   $DB
        .byte   $02
        .byte   $8C
        .byte   $DC
        .byte   $02
        .byte   $24
        .byte   $0D
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $24
        .byte   $93
        .byte   $A2
        .byte   $28
        .byte   $20
        .byte   $F4
        .byte   $C3
        .byte   $A2
        .byte   $04
        .byte   $20
        .byte   $D9
        .byte   $C3
        .byte   $A2
        .byte   $2A
        .byte   $A0
        .byte   $06
        .byte   $A9
        .byte   $02
        .byte   $85
        .byte   $8E
        .byte   $20
        .byte   $22
        .byte   $C3
        .byte   $AA
        .byte   $98
        .byte   $48
        .byte   $A4
        .byte   $8E
        .byte   $20
        .byte   $82
        .byte   $C3
        .byte   $90
        .byte   $0C
        .byte   $B9
        .byte   $D5
        .byte   $02
        .byte   $99
        .byte   $AD
        .byte   $02
        .byte   $B9
        .byte   $D6
        .byte   $02
        .byte   $99
        .byte   $AE
        .byte   $02
        .byte   $8A
        .byte   $99
        .byte   $D5
        .byte   $02
        .byte   $99
        .byte   $DE
        .byte   $02
        .byte   $68
        .byte   $99
        .byte   $D6
        .byte   $02
        .byte   $99
        .byte   $DF
        .byte   $02
        .byte   $A2
        .byte   $28
        .byte   $A0
        .byte   $04
        .byte   $C6
        .byte   $8E
        .byte   $C6
        .byte   $8E
        .byte   $F0
        .byte   $CF
        .byte   $A0
        .byte   $FF
        .byte   $8C
        .byte   $D1
        .byte   $02
        .byte   $AD
        .byte   $AD
        .byte   $02
        .byte   $8D
        .byte   $D9
        .byte   $02
        .byte   $AD
        .byte   $AE
        .byte   $02
        .byte   $8D
        .byte   $DA
        .byte   $02
        .byte   $98
        .byte   $20
        .byte   $5C
        .byte   $9B
        .byte   $20
        .byte   $64
        .byte   $C2
        .byte   $B1
        .byte   $8C
        .byte   $90
        .byte   $0E
        .byte   $AD
        .byte   $AD
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $02
        .text   "8*)",$07
        .byte   $AA
        .byte   $A9
        .byte   $00
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $01
        .byte   $CA
        .byte   $8E
        .byte   $DD
        .byte   $02
        .byte   $0A
        .byte   $CA
        .byte   $10
        .byte   $FC
        .byte   $6A
        .byte   $85
        .byte   $8E
        .byte   $A9
        .byte   $08
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $01
        .byte   $4A
        .byte   $18
        .byte   $6D
        .byte   $AD
        .byte   $02
        .byte   $8D
        .byte   $AD
        .byte   $02
        .byte   $90
        .byte   $03
        .byte   $EE
        .byte   $AE
        .byte   $02
        .byte   $20
        .byte   $64
        .byte   $C2
        .byte   $A9
        .byte   $00
        .byte   $B0
        .byte   $02
        .byte   $B1
        .byte   $8C
        .byte   $85
        .byte   $8F
        .byte   $AE
        .byte   $DD
        .byte   $02
        .byte   $4A
        .byte   $E8
        .byte   $E0
        .byte   $08
        .byte   $D0
        .byte   $FA
        .byte   $05
        .byte   $8E
        .byte   $EE
        .byte   $D1
        .byte   $02
        .byte   $AC
        .byte   $D1
        .byte   $02
        .byte   $C0
        .byte   $FC
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $4C
        .byte   $CC
        .byte   $91
        .byte   $62
        .byte   $AE
        .byte   $DD
        .byte   $02
        .byte   $AD
        .byte   $D5
        .byte   $02
        .byte   $38
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $03
        .byte   $E9
        .byte   $04
        .byte   $2C
        .byte   $E9
        .byte   $08
        .byte   $8D
        .byte   $D5
        .byte   $02
        .byte   $A5
        .byte   $8F
        .byte   $B0
        .byte   $AA
        .byte   $CE
        .byte   $D6
        .byte   $02
        .byte   $10
        .byte   $A5
        .byte   $AE
        .byte   $D7
        .byte   $02
        .text   "PbNX"
        .byte   $02
        .byte   $10
        .byte   $3D
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $06
        .byte   $0E
        .byte   $DE
        .byte   $02
        .byte   $2E
        .byte   $DF
        .byte   $02
        .byte   $A2
        .byte   $00
        .byte   $BD
        .byte   $DE
        .byte   $02
        .byte   $C8
        .byte   $91
        .byte   $62
        .byte   $E8
        .byte   $E0
        .byte   $04
        .byte   $D0
        .byte   $F5
        .byte   $C8
        .byte   $8C
        .byte   $DE
        .byte   $02
        .byte   $A5
        .byte   $62
        .byte   $8D
        .byte   $DF
        .byte   $02
        .byte   $A5
        .byte   $63
        .byte   $8D
        .byte   $E0
        .byte   $02
        .byte   $A9
        .byte   $DE
        .byte   $85
        .byte   $64
        .byte   $A9
        .byte   $02
        .byte   $85
        .byte   $65
        .byte   $AD
        .byte   $DB
        .byte   $02
        .byte   $85
        .byte   $49
        .byte   $AD
        .byte   $DC
        .byte   $02
        .byte   $85
        .byte   $4A
        .byte   $20
        .byte   $40
        .byte   $8F
        .byte   $4C
        .byte   $7B
        .byte   $C3
        .byte   $CE
        .byte   $D7
        .byte   $02
        .byte   $EE
        .byte   $AF
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $B0
        .byte   $02
        .byte   $AD
        .byte   $D9
        .byte   $02
        .byte   $8D
        .byte   $AD
        .byte   $02
        .byte   $AD
        .byte   $DA
        .byte   $02
        .byte   $8D
        .byte   $AE
        .byte   $02
        .byte   $AD
        .byte   $DE
        .byte   $02
        .byte   $8D
        .byte   $D5
        .byte   $02
        .byte   $AD
        .byte   $DF
        .byte   $02
        .byte   $8D
        .byte   $D6
        .byte   $02
        .byte   $4C
        .byte   $94
        .byte   $BE
        .byte   $A5
        .byte   $83
        .byte   $18
        .byte   $2A
        .byte   $2A
        .byte   $2A
        .byte   $69
        .byte   $00
        .byte   $A8
        .text   "l",$81,$9A,"8$"
        .byte   $18
        .byte   $08
        .byte   $20
        .byte   $87
        .byte   $9D
        .byte   $AD
        .byte   $19
        .byte   $FF
        .byte   $29
        .byte   $7F
        .byte   $E0
        .byte   $04
        .byte   $F0
        .byte   $19
        .byte   $B0
        .byte   $27
        .byte   $AD
        .byte   $15
        .byte   $FF
        .byte   $29
        .byte   $7F
        .byte   $CA
        .byte   $30
        .byte   $0F
        .byte   $A5
        .byte   $86
        .byte   $CA
        .byte   $30
        .byte   $0A
        .byte   $A5
        .byte   $85
        .byte   $CA
        .byte   $30
        .byte   $05
        .byte   $AD
        .byte   $16
        .byte   $FF
        .byte   $29
        .byte   $7F
        .byte   $28
        .byte   $B0
        .text   $05,"jjjj"
        .byte   $18
        .byte   $69
        .byte   $00
        .byte   $29
        .byte   $0F
        .byte   $A8
        .text   "l",$81,$9A,"l",$1C,$99," "
        .byte   $87
        .byte   $9D
        .byte   $CA
        .byte   $E0
        .byte   $02
        .byte   $B0
        .byte   $F5
        .byte   $BD
        .byte   $FB
        .byte   $BF
        .byte   $AA
        .byte   $78
        .byte   $8E
        .byte   $08
        .byte   $FF
        .byte   $AD
        .byte   $08
        .byte   $FF
        .byte   $8E
        .byte   $08
        .byte   $FF
        .byte   $CD
        .byte   $08
        .byte   $FF
        .byte   $D0
        .byte   $F2
        .byte   $58
        .byte   $49
        .byte   $FF
        .byte   $A8
        .byte   $29
        .byte   $0F
        .byte   $AA
        .byte   $BD
        .byte   $F0
        .byte   $BF
        .byte   $C0
        .byte   $0F
        .byte   $90
        .byte   $02
        .byte   $09
        .byte   $80
        .byte   $A8
        .byte   $4C
        .byte   $81
        .byte   $9A
        .byte   $00
        .byte   $01
        .byte   $05
        .byte   $00
        .byte   $07
        .byte   $08
        .byte   $06
        .byte   $00
        .byte   $03
        .byte   $02
        .byte   $04
        .byte   $FA
        .byte   $FD
        .byte   $20
        .byte   $87
        .byte   $9D
        .byte   $E0
        .byte   $02
        .byte   $90
        .byte   $0D
        .byte   $D0
        .byte   $B8
        .byte   $20
        .byte   $F3
        .byte   $C1
        .byte   $A8
        .byte   $90
        .byte   $02
        .byte   $A0
        .byte   $00
        .byte   $4C
        .byte   $81
        .byte   $9A
        .byte   $8A
        .byte   $0A
        .byte   $AA
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $A8
        .byte   $BD
        .byte   $AE
        .byte   $02
        .byte   $4C
        .byte   $71
        .byte   $94
        .byte   $20
        .byte   $B6
        .byte   $C3
        .byte   $A2
        .text   $1F," YC "
        .byte   $8F
        .byte   $C3
        .byte   $8C
        .byte   $D0
        .byte   $02
        .byte   $8D
        .byte   $D1
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C3
        .byte   $8C
        .byte   $D2
        .byte   $02
        .byte   $8D
        .byte   $D3
        .byte   $02
        .byte   $08
        .byte   $A2
        .text   "# SB("
        .byte   $B0
        .byte   $11
        .byte   $AD
        .byte   $D0
        .byte   $02
        .byte   $8D
        .byte   $D2
        .byte   $02
        .byte   $AD
        .byte   $D1
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $04
        .byte   $0E
        .byte   $D2
        .byte   $02
        .byte   $2A
        .byte   $8D
        .byte   $D3
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C3
        .byte   $8C
        .byte   $D8
        .byte   $02
        .byte   $8D
        .byte   $D9
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C3
        .byte   $8C
        .byte   $DA
        .byte   $02
        .byte   $8D
        .byte   $DB
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C3
        .byte   $85
        .byte   $80
        .byte   $98
        .byte   $A4
        .byte   $80
        .byte   $20
        .byte   $59
        .byte   $BC
        .byte   $A2
        .byte   $2D
        .byte   $A0
        .text   "+ ",$05,"C",$90
        .byte   $0E
        .byte   $A9
        .byte   $68
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $F9
        .byte   $C2
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $A2
        .byte   $03
        .byte   $BD
        .byte   $D0
        .byte   $02
        .byte   $9D
        .byte   $D4
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $A9
        .byte   $90
        .byte   $20
        .byte   $D5
        .byte   $BC
        .byte   $A2
        .byte   $07
        .byte   $BD
        .byte   $D0
        .byte   $02
        .byte   $9D
        .byte   $DC
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $20
        .byte   $EE
        .byte   $BC
        .byte   $20
        .byte   $7B
        .byte   $C3
        .byte   $A2
        .byte   $02
        .byte   $20
        .byte   $A7
        .byte   $C3
        .byte   $86
        .byte   $E9
        .byte   $18
        .byte   $A5
        .byte   $E9
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $6D
        .byte   $D8
        .byte   $02
        .byte   $8D
        .byte   $D8
        .byte   $02
        .byte   $90
        .byte   $03
        .byte   $EE
        .byte   $D9
        .byte   $02
        .byte   $A2
        .byte   $2D
        .byte   $A0
        .text   "+ ",$05,"C"
        .byte   $B0
        .byte   $08
        .byte   $20
        .byte   $EE
        .byte   $BC
        .byte   $20
        .byte   $DA
        .byte   $C0
        .byte   $90
        .byte   $DD
        .byte   $A0
        .byte   $2D
        .byte   $20
        .byte   $F0
        .byte   $BC
        .byte   $A2
        .byte   $02
        .byte   $A0
        .byte   $06
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $B9
        .byte   $02
        .byte   $9D
        .byte   $BA
        .byte   $02
        .byte   $20
        .byte   $22
        .byte   $C3
        .byte   $10
        .byte   $08
        .byte   $DE
        .byte   $B9
        .byte   $02
        .byte   $DE
        .byte   $BA
        .byte   $02
        .byte   $D0
        .byte   $0B
        .byte   $C9
        .byte   $00
        .byte   $D0
        .byte   $04
        .byte   $C0
        .byte   $00
        .byte   $F0
        .byte   $03
        .byte   $FE
        .byte   $B9
        .byte   $02
        .byte   $9D
        .byte   $B5
        .byte   $02
        .byte   $0A
        .byte   $9D
        .byte   $BD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $B6
        .byte   $02
        .byte   $2A
        .byte   $9D
        .byte   $BE
        .byte   $02
        .byte   $CA
        .byte   $CA
        .byte   $A0
        .byte   $04
        .byte   $E0
        .byte   $00
        .byte   $F0
        .byte   $C9
        .byte   $A2
        .byte   $0A
        .byte   $A0
        .byte   $08
        .byte   $20
        .byte   $05
        .byte   $C3
        .byte   $A9
        .byte   $00
        .byte   $2A
        .byte   $2A
        .byte   $8D
        .byte   $C3
        .byte   $02
        .byte   $49
        .byte   $02
        .byte   $8D
        .byte   $C4
        .byte   $02
        .byte   $18
        .byte   $A9
        .byte   $10
        .byte   $6D
        .byte   $C3
        .byte   $02
        .byte   $A8
        .byte   $48
        .byte   $49
        .byte   $02
        .byte   $AA
        .byte   $20
        .byte   $05
        .byte   $C3
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $68
        .byte   $A8
        .byte   $18
        .byte   $A9
        .byte   $08
        .byte   $6D
        .byte   $C4
        .byte   $02
        .byte   $AA
        .byte   $20
        .byte   $05
        .byte   $C3
        .byte   $8D
        .byte   $C1
        .byte   $02
        .byte   $8C
        .byte   $C2
        .byte   $02
        .byte   $20
        .byte   $A5
        .byte   $C1
        .byte   $AC
        .byte   $C4
        .byte   $02
        .byte   $38
        .byte   $B9
        .byte   $B5
        .byte   $02
        .byte   $E9
        .byte   $01
        .byte   $99
        .byte   $B5
        .byte   $02
        .byte   $B0
        .byte   $0B
        .byte   $B9
        .byte   $B6
        .byte   $02
        .byte   $E9
        .byte   $00
        .byte   $99
        .byte   $B6
        .byte   $02
        .byte   $B0
        .byte   $01
        .byte   $60
        .byte   $AE
        .byte   $C3
        .byte   $02
        .byte   $AD
        .byte   $C2
        .byte   $02
        .byte   $30
        .byte   $06
        .byte   $20
        .byte   $94
        .byte   $C1
        .byte   $AE
        .byte   $C4
        .byte   $02
        .byte   $18
        .byte   $AD
        .byte   $C1
        .byte   $02
        .byte   $7D
        .byte   $BD
        .byte   $02
        .byte   $8D
        .byte   $C1
        .byte   $02
        .byte   $AD
        .byte   $C2
        .byte   $02
        .byte   $7D
        .byte   $BE
        .byte   $02
        .byte   $8D
        .byte   $C2
        .byte   $02
        .byte   $AE
        .byte   $C4
        .byte   $02
        .byte   $20
        .byte   $94
        .byte   $C1
        .byte   $F0
        .byte   $BB
        .byte   $A0
        .byte   $02
        .byte   $18
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $7D
        .byte   $B9
        .byte   $02
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $E8
        .byte   $88
        .byte   $D0
        .byte   $F3
        .byte   $60
        .byte   $AD
        .byte   $E8
        .byte   $02
        .byte   $0D
        .byte   $E7
        .byte   $02
        .byte   $F0
        .byte   $16
        .byte   $EE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $EE
        .byte   $AE
        .byte   $02
        .byte   $20
        .byte   $C3
        .byte   $C1
        .byte   $AE
        .byte   $AD
        .byte   $02
        .byte   $D0
        .byte   $03
        .byte   $CE
        .byte   $AE
        .byte   $02
        .byte   $CE
        .byte   $AD
        .byte   $02
        .byte   $20
        .byte   $AD
        .byte   $C2
        .byte   $B0
        .byte   $24
        .byte   $20
        .byte   $1A
        .byte   $C2
        .byte   $20
        .byte   $69
        .byte   $C2
        .byte   $8D
        .byte   $E9
        .byte   $02
        .byte   $B1
        .byte   $8C
        .byte   $0D
        .byte   $E9
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $13
        .byte   $48
        .byte   $A6
        .byte   $84
        .byte   $AD
        .byte   $E9
        .byte   $02
        .byte   $3D
        .byte   $AF
        .byte   $C4
        .byte   $8D
        .byte   $E9
        .byte   $02
        .byte   $68
        .byte   $4D
        .byte   $E9
        .byte   $02
        .byte   $91
        .byte   $8C
        .byte   $60
        .byte   $A6
        .byte   $84
        .byte   $D0
        .byte   $F9
        .byte   $F0
        .byte   $F4
        .byte   $20
        .byte   $64
        .byte   $C2
        .byte   $B0
        .byte   $21
        .byte   $8D
        .byte   $E9
        .byte   $02
        .byte   $B1
        .byte   $8C
        .byte   $2D
        .byte   $E9
        .byte   $02
        .byte   $2A
        .byte   $CA
        .byte   $10
        .byte   $FC
        .byte   $2A
        .byte   $24
        .byte   $8B
        .byte   $30
        .byte   $06
        .byte   $29
        .byte   $03
        .byte   $C5
        .byte   $84
        .byte   $18
        .byte   $60
        .byte   $18
        .byte   $29
        .byte   $03
        .byte   $F0
        .byte   $03
        .byte   $A2
        .byte   $00
        .byte   $60
        .byte   $A2
        .byte   $FF
        .byte   $60
        .byte   $BD
        .byte   $02
        .byte   $D8
        .byte   $85
        .byte   $8C
        .byte   $BD
        .byte   $1B
        .byte   $D8
        .byte   $29
        .byte   $03
        .byte   $48
        .byte   $09
        .byte   $1C
        .byte   $85
        .byte   $8D
        .byte   $20
        .byte   $38
        .byte   $C2
        .byte   $91
        .byte   $8C
        .byte   $68
        .byte   $09
        .byte   $18
        .byte   $85
        .byte   $8D
        .byte   $20
        .byte   $4E
        .byte   $C2
        .byte   $91
        .byte   $8C
        .byte   $A5
        .byte   $86
        .text   $0A,$0A,$0A,$0A
        .byte   $85
        .byte   $7E
        .byte   $AD
        .byte   $15
        .byte   $FF
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $02
        .byte   $A5
        .byte   $85
        .byte   $29
        .byte   $0F
        .byte   $05
        .byte   $7E
        .byte   $60
        .byte   $A5
        .byte   $86
        .text   "jjjj"
        .byte   $85
        .byte   $7E
        .byte   $AD
        .byte   $15
        .byte   $FF
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $02
        .byte   $A5
        .byte   $85
        .byte   $29
        .byte   $F0
        .byte   $05
        .byte   $7E
        .byte   $60
        .byte   $20
        .byte   $AD
        .byte   $C2
        .byte   $B0
        .byte   $1F
        .byte   $20
        .byte   $91
        .byte   $C2
        .byte   $AD
        .byte   $AF
        .byte   $02
        .byte   $29
        .byte   $07
        .byte   $A8
        .byte   $AD
        .byte   $AD
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $08
        .byte   $10
        .byte   $01
        .byte   $0A
        .byte   $29
        .byte   $07
        .byte   $AA
        .byte   $BD
        .byte   $89
        .byte   $C2
        .byte   $28
        .byte   $10
        .byte   $04
        .byte   $E8
        .byte   $1D
        .byte   $89
        .byte   $C2
        .byte   $60
        .byte   $80
        .byte   $40
        .byte   $20
        .byte   $10
        .byte   $08
        .byte   $04
        .byte   $02
        .byte   $01
        .byte   $98
        .byte   $18
        .byte   $7D
        .byte   $02
        .byte   $D8
        .byte   $85
        .byte   $8C
        .byte   $BD
        .byte   $1B
        .byte   $D8
        .byte   $29
        .byte   $03
        .byte   $69
        .byte   $00
        .byte   $06
        .byte   $8C
        .byte   $2A
        .byte   $06
        .byte   $8C
        .byte   $2A
        .byte   $06
        .byte   $8C
        .byte   $2A
        .byte   $09
        .byte   $20
        .byte   $85
        .byte   $8D
        .byte   $60
        .byte   $AD
        .byte   $AE
        .byte   $02
        .byte   $4A
        .byte   $D0
        .byte   $1E
        .byte   $AD
        .byte   $AD
        .byte   $02
        .byte   $6A
        .byte   $4A
        .byte   $24
        .byte   $83
        .byte   $30
        .byte   $01
        .byte   $4A
        .byte   $A8
        .byte   $C0
        .byte   $28
        .byte   $B0
        .byte   $0F
        .byte   $AD
        .byte   $B0
        .byte   $02
        .byte   $D0
        .byte   $0A
        .byte   $AD
        .byte   $AF
        .byte   $02
        .byte   $4A
        .byte   $4A
        .byte   $4A
        .byte   $AA
        .byte   $C5
        .byte   $88
        .byte   $60
        .byte   $38
        .byte   $60
        .byte   $AD
        .byte   $E6
        .byte   $02
        .byte   $F0
        .byte   $17
        .byte   $A5
        .byte   $87
        .byte   $20
        .byte   $DF
        .byte   $C2
        .byte   $A5
        .byte   $88
        .byte   $0A
        .byte   $A8
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $37
        .byte   $C3
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $E8
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $E8
        .byte   $60
        .byte   $90
        .byte   $07
        .byte   $B0
        .byte   $14
        .byte   $B0
        .byte   $0F
        .byte   $20
        .byte   $18
        .byte   $C3
        .byte   $18
        .byte   $7D
        .byte   $AD
        .byte   $02
        .byte   $48
        .byte   $98
        .byte   $7D
        .byte   $AE
        .byte   $02
        .byte   $A8
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $18
        .byte   $C3
        .byte   $38
        .byte   $FD
        .byte   $AD
        .byte   $02
        .byte   $85
        .byte   $57
        .byte   $98
        .byte   $FD
        .byte   $AE
        .byte   $02
        .byte   $A8
        .byte   $08
        .byte   $A5
        .byte   $57
        .byte   $28
        .byte   $60
        .byte   $B9
        .byte   $AD
        .byte   $02
        .byte   $48
        .byte   $B9
        .byte   $AE
        .byte   $02
        .byte   $A8
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $05
        .byte   $C3
        .byte   $10
        .byte   $0F
        .byte   $08
        .byte   $18
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $01
        .byte   $48
        .byte   $98
        .byte   $49
        .byte   $FF
        .byte   $69
        .byte   $00
        .byte   $A8
        .byte   $68
        .byte   $28
        .byte   $60
        .byte   $84
        .byte   $8E
        .byte   $85
        .byte   $8F
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $BC
        .byte   $AE
        .byte   $02
        .byte   $08
        .byte   $20
        .byte   $25
        .byte   $C3
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $EF
        .byte   $02
        .byte   $A0
        .byte   $10
        .byte   $46
        .byte   $8E
        .byte   $66
        .byte   $8F
        .byte   $90
        .byte   $0F
        .byte   $18
        .byte   $7D
        .byte   $AD
        .byte   $02
        .byte   $48
        .byte   $AD
        .byte   $EF
        .byte   $02
        .byte   $7D
        .byte   $AE
        .byte   $02
        .byte   $8D
        .byte   $EF
        .byte   $02
        .byte   $68
        .byte   $4E
        .byte   $EF
        .byte   $02
        .byte   $6A
        .byte   $88
        .byte   $D0
        .byte   $E4
        .byte   $69
        .byte   $00
        .byte   $AC
        .byte   $EF
        .byte   $02
        .byte   $90
        .byte   $01
        .text   "H(l%C"
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $82
        .byte   $C3
        .byte   $A0
        .byte   $02
        .byte   $B9
        .byte   $B1
        .byte   $02
        .byte   $99
        .byte   $AD
        .byte   $02
        .byte   $B9
        .byte   $B2
        .byte   $02
        .byte   $99
        .byte   $AE
        .byte   $02
        .byte   $60
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $0C
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $05
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $38
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $A8
        .byte   $18
        .byte   $60
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $F8
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $F1
        .byte   $4C
        .byte   $84
        .byte   $9D
        .byte   $20
        .byte   $BF
        .byte   $C7
        .byte   $A2
        .byte   $01
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $13
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $0F
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $E0
        .byte   $04
        .byte   $B0
        .byte   $0B
        .byte   $E0
        .byte   $02
        .byte   $24
        .byte   $83
        .byte   $30
        .byte   $02
        .byte   $B0
        .byte   $03
        .byte   $86
        .byte   $84
        .byte   $60
        .text   "l",$1C,$99," "
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $07
        .byte   $20
        .byte   $91
        .byte   $94
        .text   "I,P",$12
        .byte   $A0
        .byte   $00
        .byte   $B9
        .byte   $AD
        .byte   $02
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $E8
        .byte   $C8
        .byte   $C0
        .byte   $04
        .byte   $D0
        .byte   $F4
        .byte   $60
        .byte   $20
        .byte   $91
        .byte   $94
        .byte   $8E
        .byte   $F0
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C4
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $56
        .byte   $C9
        .byte   $3B
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $20
        .byte   $E1
        .byte   $9D
        .byte   $85
        .byte   $80
        .byte   $98
        .byte   $A4
        .byte   $80
        .byte   $20
        .byte   $59
        .byte   $BC
        .byte   $AE
        .byte   $F0
        .byte   $02
        .byte   $BD
        .byte   $AD
        .byte   $02
        .byte   $9D
        .byte   $AF
        .byte   $02
        .byte   $BD
        .byte   $AE
        .byte   $02
        .byte   $9D
        .byte   $B0
        .byte   $02
        .byte   $20
        .byte   $D3
        .byte   $C2
        .byte   $A9
        .byte   $0E
        .byte   $8D
        .byte   $F1
        .byte   $02
        .byte   $18
        .byte   $AE
        .byte   $F0
        .byte   $02
        .byte   $20
        .byte   $B0
        .byte   $BC
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $A0
        .byte   $00
        .byte   $4E
        .byte   $F1
        .byte   $02
        .byte   $90
        .byte   $02
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $F4
        .byte   $C2
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $E8
        .byte   $E8
        .byte   $4E
        .byte   $F1
        .byte   $02
        .byte   $D0
        .byte   $DC
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $EE
        .byte   $F0
        .byte   $02
        .byte   $EE
        .byte   $F0
        .byte   $02
        .byte   $20
        .byte   $8F
        .byte   $C4
        .byte   $AE
        .byte   $F0
        .byte   $02
        .text   "JJ SB"
        .byte   $A0
        .byte   $02
        .byte   $AE
        .byte   $F0
        .byte   $02
        .byte   $E8
        .byte   $E8
        .byte   $CA
        .byte   $CA
        .byte   $4E
        .byte   $F1
        .byte   $02
        .byte   $90
        .byte   $0A
        .byte   $20
        .byte   $F6
        .byte   $C2
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $A0
        .byte   $00
        .byte   $EC
        .byte   $F0
        .byte   $02
        .byte   $F0
        .byte   $E8
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $AA
        .byte   $F0
        .byte   $05
        .byte   $C9
        .byte   $AB
        .byte   $F0
        .byte   $01
        .byte   $18
        .byte   $2E
        .byte   $F1
        .byte   $02
        .byte   $20
        .byte   $14
        .byte   $93
        .byte   $20
        .byte   $E8
        .byte   $9D
        .byte   $AE
        .byte   $F0
        .byte   $02
        .byte   $9D
        .byte   $AE
        .byte   $02
        .byte   $98
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $60
        .byte   $FF
        .byte   $AA
        .byte   $55
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $2C
        .byte   $71
        .byte   $57
        .byte   $8D
        .byte   $80
        .byte   $00
        .byte   $A4
        .byte   $8F
        .byte   $C4
        .byte   $19
        .byte   $DD
        .byte   $B2
        .byte   $F0
        .byte   $90
        .byte   $FC
        .byte   $1C
        .byte   $FF
        .byte   $FF
        .byte   $04
        .byte   $72
        .byte   $04
        .byte   $50
        .byte   $04
        .byte   $0B
        .byte   $03
        .byte   $A8
        .byte   $03
        .byte   $28
        .byte   $02
        .byte   $90
        .byte   $01
        .byte   $E3
        .byte   $01
        .byte   $28
        .byte   $00
        .byte   $63
        .byte   $20
        .byte   $BF
        .byte   $C7
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $F0
        .byte   $12
        .byte   $A2
        .byte   $01
        .byte   $C9
        .byte   $A4
        .byte   $20
        .byte   $BE
        .byte   $C3
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $C9
        .byte   $2C
        .byte   $F0
        .byte   $05
        .byte   $C9
        .byte   $A4
        .byte   $F0
        .byte   $01
        .byte   $60
        .byte   $48
        .byte   $20
        .byte   $73
        .byte   $04
        .byte   $A2
        .byte   $04
        .byte   $20
        .byte   $F7
        .byte   $C3
        .byte   $68
        .byte   $10
        .byte   $06
        .byte   $20
        .byte   $DA
        .byte   $C0
        .byte   $4C
        .byte   $E8
        .byte   $C4
        .byte   $20
        .byte   $7B
        .byte   $C3
        .byte   $20
        .byte   $A5
        .byte   $C1
        .byte   $4C
        .byte   $E8
        .byte   $C4
        .byte   $20
        .byte   $BF
        .byte   $C7
        .byte   $A2
        .byte   $04
        .byte   $20
        .byte   $F7
        .byte   $C3
        .byte   $4C
        .byte   $7B
        .byte   $C3
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $E0
        .byte   $05
        .byte   $B0
        .byte   $43
        .byte   $86
        .byte   $7E
        .byte   $20
        .byte   $D8
        .byte   $9D
        .byte   $CA
        .byte   $E0
        .byte   $10
        .byte   $B0
        .byte   $39
        .byte   $86
        .byte   $7F
        .byte   $A2
        .byte   $07
        .byte   $20
        .byte   $A7
        .byte   $C3
        .byte   $E0
        .byte   $08
        .byte   $B0
        .byte   $2E
        .byte   $8A
        .text   $0A,$0A,$0A,$0A,$05
        .byte   $7F
        .byte   $A6
        .byte   $7E
        .byte   $E0
        .byte   $01
        .byte   $F0
        .byte   $07
        .byte   $B0
        .byte   $0C
        .byte   $8D
        .byte   $15
        .byte   $FF
        .byte   $D0
        .byte   $19
        .byte   $85
        .byte   $86
        .byte   $8D
        .byte   $3B
        .byte   $05
        .byte   $F0
        .byte   $12
        .byte   $E0
        .byte   $03
        .byte   $F0
        .byte   $06
        .byte   $B0
        .byte   $09
        .byte   $85
        .byte   $85
        .byte   $D0
        .byte   $08
        .byte   $8D
        .byte   $16
        .byte   $FF
        .byte   $F0
        .byte   $03
        .byte   $8D
        .byte   $19
        .byte   $FF
        .byte   $60
        .byte   $4C
        .byte   $1C
        .byte   $99
        .byte   $A5
        .byte   $83
        .byte   $D0
        .byte   $05
        .byte   $A9
        .byte   $93
        .byte   $4C
        .byte   $D2
        .byte   $FF
        .byte   $29
        .byte   $40
        .byte   $F0
LC573   .byte   $0B
        .byte   $20
        .byte   $6B
        .byte   $C5
        .byte   $A2
        .byte   $14
        .byte   $A0
        .byte   $00
        .byte   $18
        .byte   $20
        .byte   $F0
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $A0
        .byte   $20
        .byte   $A2
        .byte   $20
        .byte   $20
        .byte   $A7
        .text   "E 8B"
        .byte   $A0
        .byte   $1C
        .byte   $A2
        .byte   $04
        .byte   $20
        .byte   $A7
        .text   "E nB"
        .byte   $A0
        .byte   $18
        .byte   $A2
        .byte   $04
        .byte   $20
        .byte   $A7
        .byte   $C5
        .byte   $A9
        .byte   $00
        .byte   $A2
        .byte   $03
        .byte   $9D
        .byte   $AD
        .byte   $02
        .byte   $CA
        .byte   $10
        .byte   $FA
        .byte   $60
        .byte   $84
        .byte   $8D
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $8C
        .byte   $91
        .byte   $8C
        .byte   $88
        .byte   $D0
        .byte   $FB
        .byte   $E6
        .byte   $8D
        .byte   $CA
        .byte   $D0
        .byte   $F6
        .byte   $60
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $E0
        .byte   $02
        .byte   $B0
        .byte   $A5
        .byte   $8E
        .byte   $E6
        .byte   $02
        .byte   $60
        .text   "I",$9C,"P",$0A," 8G "
        .byte   $73
        .byte   $04
        .byte   $A9
        .byte   $00
        .byte   $F0
        .byte   $0A
        .byte   $20
        .byte   $84
        .byte   $9D
        .byte   $E0
        .byte   $05
        .byte   $B0
        .byte   $15
        .byte   $BD
        .byte   $37
        .byte   $C6
        .byte   $C5
        .byte   $83
        .byte   $F0
        .byte   $4B
        .byte   $85
        .byte   $83
        .byte   $AA
        .byte   $D0
        .byte   $0C
        .byte   $20
        .byte   $C9
        .byte   $C7
        .byte   $A9
        .byte   $28
        .byte   $A2
        .byte   $19
        .text   "P9l",$1C,$99," <F"
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $09
        .byte   $20
        .byte   $8D
        .byte   $06
        .byte   $FF
        .byte   $AD
        .byte   $07
        .byte   $FF
        .byte   $29
        .byte   $EF
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $02
        .byte   $09
        .byte   $10
        .byte   $8D
        .byte   $07
        .byte   $FF
        .byte   $AD
        .byte   $12
        .byte   $FF
        .byte   $29
        .byte   $C3
        .byte   $09
        .byte   $08
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $AD
        .byte   $14
        .byte   $FF
        .byte   $29
        .byte   $03
        .byte   $09
        .byte   $18
        .byte   $8D
        .byte   $14
        .byte   $FF
        .byte   $A9
        .byte   $28
        .byte   $A2
        .byte   $19
        .byte   $24
        .byte   $83
        .byte   $10
        .byte   $01
        .byte   $4A
        .byte   $85
        .byte   $87
        .byte   $86
        .byte   $88
        .byte   $20
        .byte   $A5
        .byte   $C3
        .byte   $8A
        .byte   $4A
        .byte   $D0
        .byte   $BC
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $67
        .byte   $C5
        .byte   $60
        .byte   $00
        .byte   $20
        .byte   $60
        .byte   $A0
        .byte   $E0
        .byte   $A5
        .byte   $75
        .byte   $F0
        .byte   $01
        .byte   $60
        .byte   $A5
        .byte   $38
        .byte   $C9
        .byte   $40
        .byte   $B0
        .byte   $34
        .byte   $20
        .byte   $54
        .byte   $A9
        .byte   $20
        .byte   $6B
        .byte   $C8
        .byte   $8A
        .byte   $18
        .byte   $65
        .byte   $31
        .byte   $98
        .byte   $65
        .byte   $32
        .byte   $C9
        .byte   $18
        .byte   $B0
        .byte   $20
        .byte   $C6
        .byte   $75
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $22
        .byte   $A9
        .byte   $18
        .byte   $85
        .byte   $23
        .byte   $20
        .byte   $F0
        .byte   $C7
        .byte   $A5
        .byte   $22
        .byte   $85
        .byte   $33
        .byte   $A5
        .byte   $23
        .byte   $85
        .byte   $34
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $37
        .byte   $A9
        .byte   $18
        .byte   $85
        .text   "8l%Hl",$81
        .byte   $86
        .byte   $20
        .byte   $54
        .byte   $A9
        .byte   $A4
        .byte   $31
        .byte   $84
        .byte   $5F
        .byte   $A5
        .byte   $32
        .byte   $18
        .byte   $69
        .byte   $30
        .byte   $B0
        .byte   $EF
        .byte   $85
        .byte   $60
        .byte   $C5
        .byte   $34
        .byte   $90
        .byte   $06
        .byte   $D0
        .byte   $E7
        .byte   $C4
        .byte   $33
        .byte   $B0
        .byte   $E3
        .byte   $C6
        .byte   $75
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $4E
        .byte   $A9
        .byte   $30
        .byte   $85
        .byte   $4F
        .byte   $20
        .byte   $77
        .byte   $C8
        .byte   $A5
        .byte   $5F
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $60
        .byte   $85
        .byte   $23
        .byte   $A6
        .byte   $31
        .byte   $86
        .byte   $24
        .byte   $A5
        .byte   $32
        .byte   $85
        .byte   $25
        .byte   $38
        .byte   $E9
        .byte   $10
        .byte   $A8
        .byte   $20
        .byte   $F8
        .byte   $C7
        .byte   $18
        .byte   $A5
        .byte   $32
        .byte   $69
        .byte   $30
        .byte   $85
        .byte   $32
        .byte   $A5
        .byte   $30
        .byte   $69
        .byte   $30
        .byte   $85
        .byte   $30
        .byte   $A5
        .byte   $2E
        .byte   $69
        .byte   $30
        .byte   $85
        .byte   $2E
        .byte   $A5
        .byte   $2C
        .byte   $69
        .byte   $30
        .byte   $85
        .byte   $2C
        .byte   $A5
        .byte   $42
        .byte   $69
        .byte   $30
        .byte   $85
        .byte   $42
        .byte   $20
        .byte   $18
        .byte   $88
        .byte   $20
        .byte   $4B
        .byte   $88
        .byte   $24
        .byte   $81
        .byte   $10
        .byte   $2D
        .byte   $A2
        .byte   $30
        .byte   $24
        .byte   $75
        .byte   $30
        .byte   $02
        .byte   $A2
        .byte   $D0
        .byte   $8A
        .byte   $18
        .byte   $65
        .byte   $3C
        .byte   $85
        .byte   $3C
        .byte   $8A
        .byte   $18
        .byte   $6D
        .byte   $5C
        .byte   $02
        .byte   $8D
        .byte   $5C
        .byte   $02
        .byte   $8A
        .byte   $18
        .byte   $6D
        .byte   $F6
        .byte   $04
        .byte   $8D
        .byte   $F6
        .byte   $04
        .byte   $20
        .byte   $60
        .byte   $A7
        .byte   $A5
        .byte   $3D
        .byte   $C9
        .byte   $B0
        .byte   $D0
        .byte   $07
        .byte   $A5
        .text   ">I",$07,"P"
        .byte   $01
        .byte   $60
        .byte   $A0
        .byte   $00
        .byte   $B1
        .text   "=I",$81,"P"
        .byte   $0E
        .byte   $A0
        .byte   $02
        .byte   $20
        .byte   $AD
        .byte   $C7
        .byte   $A0
        .byte   $10
        .byte   $20
        .byte   $AD
        .byte   $C7
        .byte   $A9
        .byte   $12
        .byte   $D0
        .byte   $07
        .byte   $A0
        .byte   $04
        .byte   $20
        .byte   $AD
        .byte   $C7
        .byte   $A9
        .byte   $05
        .byte   $18
        .byte   $65
        .byte   $3D
        .byte   $85
        .byte   $3D
        .byte   $90
        .byte   $CF
        .byte   $E6
        .byte   $3E
        .byte   $D0
        .byte   $CB
        .byte   $A5
        .byte   $75
        .byte   $D0
        .byte   $01
        .byte   $60
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $75
        .byte   $A5
        .text   "80$ t"
        .byte   $A9
        .byte   $20
        .byte   $6B
        .byte   $C8
        .byte   $AD
        .byte   $33
        .byte   $05
        .byte   $85
        .byte   $22
        .byte   $AD
        .byte   $34
        .byte   $05
        .byte   $85
        .byte   $23
        .byte   $20
        .byte   $F0
        .byte   $C7
        .byte   $A2
        .byte   $01
        .byte   $BD
        .text   "3",$05,$95,"7"
        .byte   $B5
        .text   $22,$95,"3J"
        .byte   $10
        .byte   $F4
        .byte   $4C
        .byte   $25
        .byte   $C8
        .byte   $A0
        .byte   $00
        .byte   $84
        .byte   $75
        .byte   $84
        .byte   $22
        .byte   $84
        .byte   $24
        .byte   $A9
        .byte   $10
        .byte   $85
        .byte   $23
        .byte   $A9
        .byte   $40
        .byte   $85
        .byte   $25
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $91
        .byte   $22
        .byte   $C8
        .byte   $D0
        .byte   $F8
        .byte   $E6
        .byte   $23
        .byte   $E6
        .byte   $25
        .byte   $A5
        .byte   $32
        .byte   $C5
        .byte   $25
        .byte   $B0
        .byte   $EE
        .byte   $A5
        .byte   $32
        .byte   $38
        .byte   $E9
        .byte   $30
        .byte   $85
        .byte   $32
        .byte   $A5
        .byte   $2C
        .byte   $E9
        .byte   $30
        .byte   $85
        .byte   $2C
        .byte   $A5
        .byte   $2E
        .byte   $E9
        .byte   $30
        .byte   $85
        .byte   $2E
        .byte   $A5
        .byte   $30
        .byte   $E9
        .byte   $30
        .byte   $85
        .byte   $30
        .byte   $A5
        .byte   $42
        .byte   $E9
        .byte   $30
        .byte   $85
        .text   "blXF"
        .byte   $B1
        .byte   $3D
        .byte   $24
        .byte   $75
        .byte   $D0
        .byte   $06
        .byte   $38
        .byte   $E9
LC7B5   .byte   $30
        .byte   $91
        .byte   $3D
        .byte   $60
        .byte   $18
        .byte   $69
        .byte   $30
        .byte   $91
        .byte   $3D
        .byte   $60
        .byte   $A5
        .byte   $75
        .byte   $F0
        .byte   $01
        .byte   $60
        .byte   $A2
        .byte   $23
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $29
        .byte   $DF
        .byte   $8D
        .byte   $06
        .byte   $FF
        .byte   $AD
        .byte   $07
        .byte   $FF
        .byte   $29
        .byte   $EF
        .byte   $8D
        .byte   $07
        .byte   $FF
        .byte   $AD
        .byte   $14
        .byte   $FF
        .byte   $29
        .byte   $07
        .byte   $09
        .byte   $08
        .byte   $8D
        .byte   $14
        .byte   $FF
        .byte   $AD
        .byte   $12
        .byte   $FF
        .byte   $09
        .byte   $04
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $83
        .byte   $60
        .byte   $A5
        .byte   $37
        .byte   $85
        .byte   $24
        .byte   $A5
        .byte   $38
        .byte   $85
        .byte   $25
        .byte   $8A
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $4E
        .byte   $98
        .byte   $49
        .byte   $FF
        .byte   $85
        .byte   $4F
        .byte   $A0
        .byte   $00
        .byte   $E6
        .byte   $4E
        .byte   $D0
        .byte   $04
        .byte   $E6
        .byte   $4F
        .byte   $F0
        .byte   $18
        .byte   $A5
        .byte   $22
        .byte   $D0
        .byte   $02
        .text   "F#F",$22
        .byte   $A5
        .byte   $24
        .byte   $D0
        .byte   $02
        .text   "F%F$ "
        .byte   $BB
        .byte   $04
        .byte   $91
        .byte   $22
        .byte   $4C
        .byte   $04
        .byte   $C8
        .byte   $60
        .byte   $A5
        .byte   $37
        .byte   $A4
        .byte   $38
        .byte   $85
        .byte   $22
        .byte   $84
        .byte   $23
        .byte   $38
        .byte   $A5
        .byte   $33
        .byte   $E5
        .byte   $22
        .byte   $A5
        .byte   $34
        .byte   $E5
        .byte   $23
        .byte   $B0
        .byte   $EC
        .byte   $38
        .byte   $A5
        .byte   $22
        .byte   $E9
        .byte   $02
        .byte   $85
        .byte   $22
        .byte   $B0
        .byte   $02
        .byte   $C6
        .byte   $23
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $99
        .byte   $24
        .byte   $00
        .byte   $88
        .byte   $10
        .byte   $F7
        .byte   $C8
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $85
        .byte   $80
        .byte   $A5
        .byte   $22
        .byte   $38
        .byte   $E5
        .byte   $80
        .byte   $85
        .byte   $22
        .byte   $B0
        .byte   $02
        .byte   $C6
        .byte   $23
        .byte   $A0
        .byte   $02
        .byte   $B9
        .byte   $21
        .byte   $00
        .byte   $91
        .byte   $24
        .byte   $88
        .byte   $D0
        .byte   $F8
        .byte   $F0
        .byte   $C2
        .byte   $38
        .byte   $A5
        .byte   $37
        .byte   $E5
        .byte   $33
        .byte   $AA
        .byte   $A5
        .byte   $38
        .byte   $E5
        .byte   $34
        .byte   $A8
        .byte   $60
        .byte   $A5
        .byte   $37
        .byte   $85
        .byte   $22
        .byte   $A5
        .byte   $38
        .byte   $85
        .byte   $23
        .byte   $38
        .byte   $A5
        .byte   $33
        .byte   $E5
        .byte   $22
        .byte   $A5
        .byte   $34
        .byte   $E5
        .byte   $23
        .byte   $B0
        .byte   $31
        .byte   $38
        .byte   $A5
        .byte   $22
        .byte   $E9
        .byte   $02
        .byte   $85
        .byte   $22
        .byte   $B0
        .byte   $02
        .byte   $C6
        .byte   $23
        .byte   $18
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $B0
        .byte   $04
        .byte   $99
        .byte   $24
        .byte   $00
        .byte   $79
        .byte   $4E
        .byte   $00
        .byte   $91
        .byte   $22
        .byte   $C8
        .byte   $C0
        .byte   $01
        .byte   $D0
        .byte   $F0
        .byte   $88
        .byte   $20
        .byte   $BB
        .byte   $04
        .byte   $85
        .byte   $80
        .byte   $A5
        .byte   $22
        .byte   $38
        .byte   $E5
        .byte   $80
        .byte   $85
        .byte   $22
        .byte   $B0
        .text   "HF#",$90,"D"
        .byte   $60
        .text   " ",$1F,"K)"
        .byte   $E6
        .byte   $D0
        .byte   $7B
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $3F
        .byte   $CA
        .byte   $A9
        .byte   $00
        .byte   $AE
        .byte   $77
        .byte   $02
        .byte   $A0
        .byte   $60
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $38
        .byte   $20
        .byte   $C0
        .byte   $FF
        .byte   $90
        .byte   $09
        .text   "h 5I"
        .byte   $68
        .byte   $AA
        .byte   $4C
        .byte   $83
        .byte   $86
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $C6
        .byte   $FF
        .byte   $A0
        .byte   $03
        .byte   $8C
        .byte   $EC
        .byte   $02
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $8D
        .byte   $ED
        .byte   $02
        .byte   $20
        .byte   $B7
        .byte   $FF
        .text   "P? O"
        .byte   $FF
        .byte   $8D
        .byte   $EE
        .byte   $02
        .byte   $20
        .byte   $B7
        .byte   $FF
        .byte   $D0
        .byte   $34
        .byte   $CE
        .byte   $EC
        .byte   $02
        .byte   $D0
        .byte   $E5
        .byte   $AE
        .byte   $ED
        .byte   $02
        .byte   $AD
        .byte   $EE
        .byte   $02
        .byte   $20
        .byte   $5F
        .byte   $A4
        .byte   $A9
        .byte   $20
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $48
        .byte   $20
        .byte   $B7
        .byte   $FF
        .byte   $D0
        .byte   $17
        .byte   $68
        .byte   $F0
        .byte   $06
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $4C
        .byte   $14
        .byte   $C9
        .byte   $A9
        .byte   $0D
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $20
        .byte   $E1
        .byte   $FF
        .byte   $F0
        .byte   $05
        .byte   $A0
        .byte   $02
        .byte   $D0
        .byte   $B4
        .byte   $68
        .byte   $20
        .byte   $CC
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $18
        .byte   $4C
        .byte   $C3
        .byte   $FF
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $A9
        .byte   $66
        .text   " !K "
        .byte   $B5
        .byte   $CC
        .byte   $A0
        .byte   $04
        .text   " ?Jl"
        .byte   $E1
        .byte   $A7
        .byte   $A9
        .byte   $E6
        .text   " !K "
        .byte   $B5
        .byte   $CC
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $78
        .byte   $02
        .byte   $85
        .byte   $0A
        .byte   $A0
        .text   $05," ?Jl"
        .byte   $FA
        .byte   $A7
        .text   " ",$1F,"K "
        .byte   $AF
        .byte   $CC
        .byte   $29
        .byte   $11
        .byte   $C9
        .byte   $11
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $E7
        .byte   $FF
        .text   " +MP"
        .byte   $17
        .byte   $A0
        .byte   $09
        .text   " ?J OL$",$81,"0"
        .byte   $0B
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $7A
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $C9
        .byte   $32
        .byte   $B0
        .byte   $01
        .byte   $60
        .byte   $A2
        .byte   $24
        .byte   $4C
        .byte   $83
        .byte   $86
        .text   " ",$1F,"K "
        .byte   $AF
        .text   "L +MP"
        .byte   $EF
        .byte   $A0
        .byte   $0F
        .text   " ?J OL$",$81,"0"
        .byte   $E3
        .byte   $A9
        .byte   $0D
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $7A
        .byte   $20
        .byte   $94
        .byte   $04
        .byte   $F0
        .byte   $06
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $C8
        .byte   $D0
        .byte   $F3
        .byte   $A9
        .byte   $0D
        .byte   $4C
        .byte   $D2
        .byte   $FF
        .text   " ",$1F,"K)"
        .byte   $E7
        .byte   $D0
        .byte   $A1
        .byte   $20
        .byte   $E7
        .byte   $FF
        .byte   $A0
        .byte   $14
        .byte   $D0
        .byte   $65
        .text   " ",$1F,"K)0I0P"
        .byte   $06
        .byte   $A5
        .byte   $82
        .byte   $29
        .byte   $C7
        .byte   $F0
        .byte   $07
        .byte   $A5
        .byte   $82
        .byte   $20
        .byte   $C0
        .byte   $CC
        .byte   $A5
        .byte   $82
        .byte   $A0
        .byte   $17
        .byte   $D0
        .byte   $4B
        .byte   $A9
        .byte   $E4
        .text   " !K FL"
        .byte   $A0
        .byte   $1E
        .byte   $D0
        .byte   $3F
        .byte   $A9
        .text   "G !K)0I0"
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $A1
        .byte   $94
        .byte   $20
        .byte   $E7
        .byte   $FF
        .byte   $A0
        .text   "%l?J"

LCA16   pha                ;3
        lda     $025D      ;4
        ldx     #$7C       ;2
        ldy     #$02       ;2
        jsr     SETNAM     ;6
        lda     $0276      ;4
        ldx     $0277      ;4
        ldy     $0278      ;4
        jsr     SETLFS     ;6
        pla                ;4
        beq     _LCA3E     ;2+
        ldx     $025D      ;4
        sec                ;2
        jsr     OPEN       ;6
        lda     $0276      ;4
        sec                ;2
        jmp     CLOSE      ;3

_LCA3E  rts                ;6

        .byte   $20
        .byte   $57
        .byte   $CD
        .byte   $A2
        .byte   $00
        .byte   $8E
        .byte   $5D
        .byte   $02

LCA47   lda     LCAF5,y    ;4+
        beq     LCA16      ;2+
        cmp     #$80       ;2
        beq     LCA16      ;2+
        tax                ;2
        dex                ;2
        beq     LCA72      ;2+
        dex                ;2
        beq     LCA78      ;2+
        dex                ;2
        beq     LCA7E      ;2+
        dex                ;2
        beq     LCA85      ;2+
        dex                ;2
        beq     LCA8D      ;2+
        dex                ;2
        beq     LCA97      ;2+
        dex                ;2
        beq     LCAA5      ;2+
        dex                ;2
        beq     LCAAF      ;2+
        dex                ;2
        beq     LCAD2      ;2+
LCA6C   jsr     LCAEB      ;6
LCA6F   iny                ;2
        bne     LCA47      ;2+
LCA72   lda     $82        ;3
        and     #$10       ;2
        beq     LCA6F      ;2+
LCA78   lda     $026F      ;4
        jmp     LCA81      ;3

LCA7E   lda     $0273      ;4
LCA81   ora     #$30       ;2
        bne     LCA6C      ;3

LCA85   lda     #$40       ;2
        bit     $82        ;3
        bmi     LCA6C      ;2+
        bpl     LCA6F      ;3

LCA8D   lda     $026E      ;4
        beq     LCA6F      ;2+
        lda     #$3A       ;2
        jsr     LCAEB      ;6
LCA97   tya                ;2
        pha                ;3
        .byte   $AD        ;4
LCA9A   bvs     _LCA9C+2   ;2+
_LCA9C  ldy     $0271      ;4
        ldx     $026E      ;4
        jmp     LCABA      ;3

LCAA5   lda     $0272      ;4
        beq     LCA6F      ;2+
        lda     #$3A       ;2
        jsr     LCAEB      ;6
LCAAF   tya                ;2
        pha                ;3
        lda     $0274      ;4
        ldy     $0275      ;4
        ldx     $0272      ;4
LCABA   sta     $22        ;3
        sty     $23        ;3
        stx     $80        ;3
        ldy     #$00       ;2
_LCAC2  jsr     $04B0      ;6
        jsr     LCAEB      ;6
        iny                ;2
        cpy     $80        ;3
        bne     _LCAC2     ;2+
        pla                ;4
        tay                ;2
        jmp     LCA6F      ;3

LCAD2   lda     $0279      ;4
        beq     LCA6F      ;2+
        lda     #$2C       ;2
        jsr     LCAEB      ;6
LCADC   lda     $0279      ;4
        jsr     LCAEB      ;6
        lda     $027A      ;4
        jsr     LCAEB      ;6
        jmp     LCA6F      ;3

LCAEB   ldx     $025D      ;4
        sta     $027C,x    ;5
        inc     $025D      ;6
        rts                ;6

LCAF5   .byte   $24
        .byte   $07
        .byte   $05
        .byte   $00
        .byte   $04
        .byte   $02
        .byte   $3A
        .byte   $06
        .byte   $00
        .byte   $4E
        .byte   $02
        .byte   $3A
        .byte   $06
        .byte   $09
        .byte   $80
        .byte   $53
        .byte   $02
        .byte   $3A
        .byte   $06
        .byte   $80
        .byte   $56
        .byte   $02
        .byte   $80
        .byte   $43
        .byte   $03
        .byte   $07
        .byte   $3D
        .byte   $02
        .byte   $05
        .byte   $80
        .byte   $52
        .byte   $02
        .byte   $3A

LCB16   php                ;3
        and     L8006,x    ;4+
        .byte   $44
        .byte   $03
        .byte   $3D
        .byte   $02
        .byte   $80
        .byte   $A9
        .byte   $00
        .byte   $48
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $82
        .byte   $A2
        .byte   $1E
        .byte   $9D
        .byte   $5E
        .byte   $02
        .byte   $CA
        .byte   $D0
        .byte   $FA
        .byte   $A2
        .byte   $08
        .byte   $8E
        .byte   $77
        .byte   $02
        .byte   $A2
        .byte   $6F
        .byte   $8E
        .byte   $78
        .byte   $02
        .byte   $A2
        .byte   $00
        .byte   $8E
        .byte   $76
        .byte   $02
        .byte   $20
        .byte   $79
        .byte   $04
        .byte   $D0
        .byte   $07

LCB42   pla                ;4
        jsr     LCCAA      ;6
        lda     $82        ;3
        rts                ;6

LCB49   cmp     #$44       ;2
        beq     _LCB6A     ;2+
        cmp     #$91       ;2
        beq     LCB9F      ;2+
        cmp     #$55       ;2
        beq     _LCB64     ;2+
        cmp     #$49       ;2
        beq     _LCB83     ;2+
        cmp     #$22       ;2
        beq     LCBA5      ;2+
        cmp     #$28       ;2
        beq     LCBA5      ;2+
_LCB61  jmp     L94A1      ;3

_LCB64  jsr     LCC58      ;6
        jmp     LCBCD      ;3

_LCB6A  lda     #$10       ;2
        jsr     LCCAA      ;6
        jsr     LCC97      ;6
        cpx     #$02       ;2
        bcs     _LCB80     ;2+
        stx     $026F      ;4
        stx     $0273      ;4
        lda     #$10       ;2
        bne     LCBCD      ;3

_LCB80  jmp     LCC49      ;3

_LCB83  lda     $027B      ;4
        bne     _LCB61     ;2+
        jsr     $0473      ;6
        sta     $0279      ;4
        jsr     $0473      ;6
LCB91   sta     $027A      ;4
        lda     #$FF       ;2
        sta     $027B      ;4
        jsr     $0473      ;6
        jmp     LCBD1      ;3

LCB9F   jsr     LCC51      ;6
        jmp     LCBCD      ;3

LCBA5   lda     #$01       ;2
        jsr     LCC69      ;6
        sta     $026E      ;4
        sta     $025D      ;4
        lda     #$5E       ;2
        sta     $0270      ;4
        sta     $24        ;3
        lda     #$02       ;2
        sta     $0271      ;4
        sta     $25        ;3
        ldy     #$00       ;2
_LCBC0  jsr     $04B0      ;6
        sta     ($24),y    ;6
        iny                ;2
        cpy     $025D      ;4
        bcc     _LCBC0     ;2+
        lda     #$01       ;2
LCBCD   ora     $82        ;3
        sta     $82        ;3
LCBD1   jsr     $0479      ;6
        bne     LCBD9      ;2+
LCBD6   jmp     LCB42      ;3

LCBD9   cmp     #$2C       ;2
        bne     _LCBE3     ;2+
        jsr     $0473      ;6
        jmp     LCB49      ;3

_LCBE3  cmp     #$91       ;2
        beq     LCB9F      ;2+
        cmp     #$A4       ;2
        bne     LCC46      ;3+
LCBEB   jsr     $0473      ;6
        cmp     #$44       ;2
        beq     LCC02      ;3+
        cmp     #$91       ;2
        beq     LCC15      ;3+
        cmp     #$55       ;2
        beq     LCC1B      ;3+
LCBFA   cmp     #$22       ;2
LCBFC   beq     LCC21      ;3+
        cmp     #$28       ;2
        beq     LCC21      ;2+
LCC02   lda     #$20       ;2
        jsr     LCCAA      ;6
LCC07   jsr     LCC97      ;6
LCC0A   cpx     #$02       ;2
        bcs     LCC49      ;2+
        stx     $0273      ;4
        lda     #$20       ;2
        bne     LCC31      ;3

LCC15   jsr     LCC51      ;6
        jmp     LCC31      ;3

LCC1B   jsr     LCC58      ;6
        jmp     LCC31      ;3

LCC21   lda     #$02       ;2
        jsr     LCC69      ;6
        sta     $0272      ;4
        stx     $0274      ;4
        sty     $0275      ;4
        lda     #$02       ;2
LCC31   ora     $82        ;3
        sta     $82        ;3
        jsr     $0479      ;6
        beq     LCBD6      ;3+
        cmp     #$2C       ;2
        beq     LCBEB      ;3+
        cmp     #$91       ;2
        beq     LCC15      ;2+
        cmp     #$55       ;2
        beq     LCC1B      ;2+
LCC46   ldx     #$0B       ;2
        .byte   $2C        ;4
LCC49   ldx     #$0E       ;2
        .byte   $2C        ;4
LCC4C   ldx     #$17       ;2
        jmp     L8683      ;3

LCC51   jsr     $0473      ;6
        cmp     #$55       ;2
        bne     LCC46      ;2+
LCC58   jsr     LCC97      ;6
        cpx     #$20       ;2
        bcs     LCC49      ;2+
        cpx     #$03       ;2
        bcc     LCC49      ;2+
        stx     $0277      ;4
        lda     #$08       ;2
        rts                ;6

LCC69   jsr     LCCAA      ;6
        jsr     L9C48      ;6
        tax                ;2
        beq     LCC49      ;2+
        ldy     #$00       ;2
        jsr     $04B0      ;6
        cmp     #$40       ;2
        bne     _LCC8D     ;2+
        lda     #$80       ;2
        jsr     LCCAA      ;6
        lda     $82        ;3
        ora     #$80       ;2
        sta     $82        ;3
        dex                ;2
        inc     $22        ;5
        bne     _LCC8D     ;2+
        inc     $23        ;5
_LCC8D  txa                ;2
        cmp     #$11       ;2
        bcs     LCC4C      ;2+
        ldx     $22        ;3
        ldy     $23        ;3
        rts                ;6

LCC97   jsr     $0473      ;6
        beq     LCC46      ;2+
        bcc     _LCCA7     ;2+
        jsr     L948E      ;6
        jsr     L9D84      ;6
        jmp     L948B      ;3

_LCCA7  jmp     L9D84      ;3

LCCAA   and     $82        ;3
        bne     LCC46      ;2+
        rts                ;6

        .byte   $29
        .byte   $E6
        .byte   $F0
        .byte   $02
        .byte   $D0
        .byte   $91
        .byte   $A5
        .byte   $82
        .byte   $29
        .byte   $01
        .byte   $C9
        .byte   $01
        .byte   $D0
        .byte   $F6
        .byte   $A5
        .byte   $82
        .byte   $60
        .byte   $29
        .byte   $C4
        .byte   $D0
        .byte   $EF
        .byte   $A5
        .byte   $82
        .byte   $29
        .byte   $03
        .byte   $C9
        .byte   $03
        .byte   $D0
        .byte   $E7
        .byte   $A5
        .byte   $82
        .byte   $60
        .byte   $A5
        .byte   $79
        .byte   $D0
        .byte   $11
        .byte   $A9
        .byte   $28
        .byte   $85
        .byte   $79
        .byte   $20
        .byte   $06
        .byte   $A9
        .byte   $86
        .byte   $7A
        .byte   $84
        .byte   $7B
        .byte   $A0
        .byte   $28
        .byte   $20
        .byte   $BA
        .byte   $CD
        .byte   $EA
        .byte   $AE
        .byte   $77
        .byte   $02
        .byte   $D0
        .byte   $05
        .byte   $A2
        .byte   $08
        .byte   $8E
        .byte   $77
        .byte   $02
        .byte   $A9
        .byte   $00
        .byte   $A0
        .byte   $6F
        .byte   $20
        .byte   $BA
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $BD
        .byte   $FF
        .byte   $20
        .byte   $C0
        .byte   $FF
        .byte   $A2
        .byte   $00
        .byte   $20
        .byte   $C6
        .byte   $FF
        .byte   $B0
        .byte   $1B
        .byte   $A0
        .byte   $FF
        .byte   $C8
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $C9
        .byte   $0D
        .byte   $F0
        .byte   $04
        .byte   $91
        .byte   $7A
        .byte   $D0
        .byte   $F4
        .byte   $A9
        .byte   $00
        .byte   $91
        .byte   $7A
        .byte   $20
        .byte   $CC
        .byte   $FF
        .byte   $A9
        .byte   $00
        .byte   $38
        .byte   $4C
        .byte   $C3
        .byte   $FF
        .text   "h ",$12,"M wM"
        .byte   $68
        .byte   $AA
        .byte   $4C
        .byte   $83
        .byte   $86
        .text   "$",$81,"0% o"
        .byte   $FF
        .text   "are you sure?"
        .byte   $00
        .byte   $20
        .byte   $CC
        .byte   $FF
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $48
        .byte   $C9
        .byte   $0D
        .byte   $F0
        .byte   $05
        .byte   $20
        .byte   $CF
        .byte   $FF
        .byte   $D0
        .byte   $F7
        .byte   $68
        .byte   $C9
        .byte   $59
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $60
        .byte   $98
        .byte   $48
        .byte   $A5
        .byte   $79
        .byte   $F0
        .byte   $0A
        .byte   $A0
        .byte   $28
        .byte   $98
        .byte   $91
        .byte   $7A
        .byte   $C8
        .byte   $A9
        .byte   $FF
        .byte   $91
        .byte   $7A
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $79
        .byte   $68
        .byte   $A8
        .byte   $60
        .text   ",0 yek"
        .byte   $AA
        .byte   $98
        .byte   $48
        .byte   $A9
        .byte   $00
        .byte   $20
        .byte   $5F
        .byte   $A4
        .byte   $68
        .byte   $A8
        .byte   $60
        .byte   $85
        .byte   $3A
        .byte   $88
        .byte   $AA
        .byte   $E8
        .byte   $D0
        .byte   $02
        .byte   $86
        .byte   $81
        .byte   $60
        .byte   $D8
        .byte   $1B
        .byte   $14
        .byte   $0C
        .byte   $07
        .byte   $7B
        .byte   $01
        .byte   $D7
        .byte   $D8
        .byte   $11
        .byte   $07
        .byte   $10
        .byte   $1D
        .byte   $7B
        .byte   $17
        .byte   $D8
        .byte   $07
        .byte   $10
        .byte   $05
        .byte   $1A
        .byte   $1A
        .byte   $16
        .byte   $7B
        .byte   $1F
        .byte   $D8
        .byte   $1B
        .byte   $10
        .byte   $02
        .byte   $1A
        .byte   $17
        .byte   $7B
        .byte   $13
        .byte   $47
        .byte   $D8
        .byte   $A0
        .byte   $21
        .byte   $B9
        .byte   $89
        .text   "Miu R"
        .byte   $FF
        .byte   $88
        .byte   $10
        .byte   $F5
        .byte   $60
        .byte   $00
        .byte   $A9
        .byte   $79
        .byte   $91
        .byte   $7A
        .byte   $A9
        .byte   $00
        .byte   $C8
        .byte   $91
        .byte   $7A
        .byte   $60
        .fill   60,$FF
        .byte   $BA
        .byte   $BD
        .byte   $04
        .byte   $01
        .byte   $29
        .byte   $10
        .byte   $D0
        .byte   $03
        .byte   $6C
        .byte   $14
        .byte   $03
        .byte   $6C
        .byte   $16
        .byte   $03
        .byte   $AD
        .byte   $09
        .byte   $FF
        .byte   $29
        .byte   $02
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $60
        .text   "N,X",$07
        .byte   $10
        .byte   $0E
        .byte   $AD
        .byte   $01
        .byte   $FD
        .byte   $8D
        .byte   $D4
        .byte   $07
        .byte   $10
        .byte   $06
        .byte   $20
        .byte   $95
        .byte   $EA
        .byte   $20
        .byte   $5B
        .byte   $EA
        .byte   $20
        .byte   $E4
        .byte   $E3
        .byte   $AD
        .byte   $09
        .byte   $FF
        .byte   $29
        .byte   $02
        .byte   $F0
        .byte   $28
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $2C
        .byte   $0B
        .byte   $FF
        .byte   $A9
        .byte   $CC
        .byte   $50
        .byte   $1B
        .byte   $6C
        .byte   $12
        .byte   $03
        .byte   $20
        .byte   $BF
        .text   "O MN"
        .byte   $A5
        .byte   $FB
        .byte   $48
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $FB
        .byte   $08
        .byte   $58
        .byte   $20
        .byte   $11
        .byte   $DB
        .byte   $28
        .byte   $68
        .byte   $85
        .byte   $FB
        .byte   $A9
        .byte   $A1
        .byte   $8D
        .byte   $0B
        .byte   $FF
        .byte   $4C
        .byte   $BE
        .byte   $FC
        .byte   $AD
        .byte   $1C
        .byte   $FF
        .byte   $29
        .byte   $01
        .byte   $D0
        .byte   $39
        .byte   $AD
        .byte   $1D
        .byte   $FF
        .byte   $C9
        .byte   $A3
        .byte   $B0
        .byte   $2E
        .byte   $24
        .byte   $83
        .byte   $50
        .byte   $52
        .byte   $A9
        .byte   $08
        .byte   $8D
        .byte   $14
        .byte   $FF
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $29
        .byte   $DF
        .byte   $A8
        .byte   $AD
        .byte   $07
        .byte   $FF
        .byte   $29
        .byte   $EF
        .byte   $AA
        .byte   $AD
        .byte   $12
        .byte   $FF
        .byte   $0D
        .byte   $FA
        .byte   $07
        .byte   $48
        .byte   $AD
        .byte   $1D
        .byte   $FF
        .byte   $C9
        .byte   $A3
        .byte   $90
        .byte   $F9
        .byte   $68
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $8C
        .byte   $06
        .byte   $FF
        .byte   $8E
        .byte   $07
        .byte   $FF
        .byte   $60
        .text   "IL",$90,"$"
        .byte   $A6
        .byte   $83
        .byte   $F0
        .byte   $20
        .byte   $10
        .byte   $08
        .byte   $AD
        .byte   $07
        .byte   $FF
        .byte   $09
        .byte   $10
        .byte   $8D
        .byte   $07
        .byte   $FF
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $09
        .byte   $20
        .byte   $8D
        .byte   $06
        .byte   $FF
        .byte   $AD
        .byte   $12
        .byte   $FF
        .byte   $29
        .byte   $FB
        .byte   $8D
        .byte   $12
        .byte   $FF
        .byte   $AD
        .byte   $FB
        .byte   $07
        .byte   $8D
        .byte   $14
        .byte   $FF
        .byte   $60
        .fill   8,$EA
        .byte   $A2
        .byte   $01
        .byte   $BD
        .byte   $FC
        .byte   $04
        .byte   $1D
        .byte   $FE
        .byte   $04
        .byte   $F0
        .byte   $13
        .byte   $FE
        .byte   $FC
        .byte   $04
        .byte   $D0
        .byte   $0E
        .byte   $FE
        .byte   $FE
        .byte   $04
        .byte   $D0
        .byte   $09
        .byte   $BD
        .byte   $EE
        .byte   $CE
        .byte   $2D
        .byte   $11
        .byte   $FF
        .byte   $8D
        .byte   $11
        .byte   $FF
        .byte   $CA
        .byte   $10
        .byte   $E2
        .byte   $60
        .byte   $EF
        .byte   $9F
        .byte   $E6
        .byte   $A5
        .byte   $D0
        .byte   $06
        .byte   $E6
        .byte   $A4
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $A3
        .byte   $38
        .byte   $A5
        .byte   $A5
        .byte   $E9
        .byte   $01
        .byte   $A5
        .byte   $A4
        .byte   $E9
        .byte   $1A
        .byte   $A5
        .byte   $A3
        .byte   $E9
        .byte   $4F
        .byte   $90
        .byte   $08
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $A3
        .byte   $86
        .byte   $A4
        .byte   $86
        .byte   $A5
        .byte   $A9
        .byte   $7F
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $85
        .byte   $EE
        .byte   $A9
        .byte   $7F
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $C5
        .byte   $EE
        .byte   $D0
        .byte   $F0
        .byte   $09
        .byte   $7F
        .byte   $85
        .byte   $91
        .byte   $60
        .byte   $78
        .byte   $A5
        .byte   $A5
        .byte   $A6
        .byte   $A4
        .byte   $A4
        .byte   $A3
        .byte   $78
        .byte   $85
        .byte   $A5
        .byte   $86
        .byte   $A4
        .byte   $84
        .byte   $A3
        .byte   $58
        .byte   $60
        .text   $0D,"monitor"
        .byte   $8D
        .text   $0D,"breaK",$0D,"   pc  sr ac xr yr sp",$0D,";"
        .byte   $A0
        .byte   $41
        .byte   $A0
        .text   " erroR"
        .byte   $BD
        .byte   $36
        .byte   $CF
        .byte   $08
        .byte   $29
        .byte   $7F
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $E8
        .byte   $28
        .byte   $10
        .byte   $F3
        .byte   $60
        .byte   $A9
        .byte   $0D
        .byte   $A6
        .byte   $98
        .byte   $E0
        .byte   $03
        .byte   $F0
        .byte   $06
        .byte   $A6
        .byte   $99
        .byte   $E0
        .byte   $03
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $49
        .byte   $DC
        .byte   $A9
        .byte   $0D
        .byte   $4C
        .byte   $B0
        .byte   $D9
        .byte   $BD
        .byte   $13
        .byte   $01
        .byte   $2C
        .byte   $F9
        .byte   $07
        .byte   $10
        .byte   $03
        .byte   $BD
        .byte   $43
        .byte   $E1
        .byte   $60
        .byte   $2C
        .byte   $F8
        .byte   $07
        .byte   $30
        .byte   $03
        .byte   $B1
        .byte   $A1
        .byte   $60
        .byte   $A9
        .byte   $A1
        .byte   $8D
        .byte   $DF
        .text   $07,"lY",$07
        .byte   $A9
        .byte   $09
        .byte   $8D
        .byte   $20
        .byte   $FD
        .byte   $09
        .byte   $80
        .byte   $8D
        .byte   $20
        .byte   $FD
        .byte   $4C
        .byte   $1E
        .byte   $FC
        .byte   $08
        .byte   $78
        .byte   $8D
        .byte   $3F
        .byte   $FF
        .byte   $B1
        .byte   $00
        .byte   $8D
        .byte   $3E
        .byte   $FF
        .byte   $28
        .byte   $60
        .byte   $AD
        .byte   $10
        .byte   $FD
        .byte   $29
        .byte   $04
        .byte   $D0
        .byte   $1B
        .byte   $2C
        .byte   $FC
        .byte   $07
        .byte   $30
        .byte   $06
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $F7
        .byte   $85
        .byte   $01
        .byte   $CE
        .byte   $FD
        .byte   $07
        .byte   $10
        .byte   $08
        .byte   $A9
        .byte   $04
        .byte   $8D
        .byte   $FD
        .byte   $07
        .byte   $20
        .byte   $F0
        .byte   $CE
        .byte   $4C
        .byte   $F0
        .byte   $CE
        .byte   $8D
        .byte   $FC
        .byte   $07
        .byte   $20
        .byte   $B0
        .byte   $E3
        .byte   $4C
        .byte   $D1
        .byte   $CF
        .byte   $E8
        .byte   $8E
        .byte   $C4
        .byte   $FE
        .byte   $8E
        .byte   $C0
        .byte   $FE
        .byte   $A9
        .byte   $80
        .byte   $8D
        .byte   $11
        .byte   $FF
        .byte   $60
        .fill   9,$FF
        .byte   $3C
        .byte   $66
        .byte   $6E
        .byte   $6E
        .byte   $60
        .byte   $62
        .byte   $3C
        .byte   $00
        .byte   $18
        .byte   $3C
        .byte   $66
        .byte   $7E
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $6C
        .byte   $78
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $60
        .byte   $78
        .byte   $60
        .byte   $60
        .byte   $7E
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $60
        .byte   $78
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $6E
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $7E
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $3C
        .fill   5,$18
        .byte   $3C
        .byte   $00
        .byte   $1E
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $6C
        .byte   $38
        .byte   $00
        .byte   $66
        .byte   $6C
        .byte   $78
        .byte   $70
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $00
        .fill   6,$60
        .byte   $7E
        .byte   $00
        .byte   $63
        .byte   $77
        .byte   $7F
        .byte   $6B
        .byte   $63
        .byte   $63
        .byte   $63
        .byte   $00
        .byte   $66
        .byte   $76
        .byte   $7E
        .byte   $7E
        .byte   $6E
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $3C
        .fill   5,$66
        .byte   $3C
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $0E
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $3C
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $7E
        .fill   6,$18
        .byte   $00
        .fill   6,$66
        .byte   $3C
        .byte   $00
        .fill   5,$66
        .byte   $3C
        .byte   $18
        .byte   $00
        .byte   $63
        .byte   $63
        .byte   $63
        .byte   $6B
        .byte   $7F
        .byte   $77
        .byte   $63
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $7E
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $7E
        .byte   $00
        .text   "<00000<"
        .byte   $00
        .byte   $0C
        .byte   $12
        .byte   $30
        .byte   $7C
        .byte   $30
        .byte   $62
        .byte   $FC
        .byte   $00
        .byte   $3C
        .fill   5,$0C
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $3C
        .byte   $7E
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $10
        .byte   $30
        .byte   $7F
        .byte   $7F
        .byte   $30
        .byte   $10
        .fill   9,$00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .fill   5,$00
        .byte   $66
        .byte   $66
        .byte   $FF
        .byte   $66
        .byte   $FF
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $18
        .byte   $3E
        .byte   $60
        .byte   $3C
        .byte   $06
        .byte   $7C
        .byte   $18
        .byte   $00
        .byte   $62
        .byte   $66
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $66
        .byte   $46
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $3C
        .byte   $38
        .byte   $67
        .byte   $66
        .byte   $3F
        .byte   $00
        .byte   $06
        .byte   $0C
        .byte   $18
        .fill   5,$00
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $30
        .byte   $30
        .byte   $18
        .byte   $0C
        .byte   $00
        .byte   $30
        .byte   $18
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $3C
        .byte   $FF
        .byte   $3C
        .byte   $66
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $7E
        .byte   $18
        .byte   $18
        .fill   7,$00
        .byte   $18
        .byte   $18
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7E
        .fill   9,$00
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $6E
        .byte   $76
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $38
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $7E
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $0C
        .byte   $30
        .byte   $60
        .byte   $7E
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $1C
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $06
        .byte   $0E
        .byte   $1E
        .byte   $66
        .byte   $7F
        .byte   $06
        .byte   $06
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $7C
        .byte   $06
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $7E
        .byte   $66
        .byte   $0C
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $30
        .byte   $0E
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $30
        .byte   $18
        .byte   $0E
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7E
        .byte   $00
        .byte   $7E
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $70
        .byte   $18
        .byte   $0C
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $70
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $08
        .byte   $1C
        .byte   $3E
        .byte   $7F
        .byte   $7F
        .byte   $1C
        .byte   $3E
        .byte   $00
        .fill   8,$18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .fill   5,$00
        .byte   $FF
        .byte   $FF
        .fill   5,$00
        .byte   $FF
        .byte   $FF
        .fill   9,$00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .text   "00000000"
        .fill   8,$0C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $E0
        .byte   $F0
        .byte   $38
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $1C
        .byte   $0F
        .byte   $07
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $38
        .byte   $F0
        .byte   $E0
        .byte   $00
        .byte   $00
        .byte   $00
        .fill   6,$C0
        .byte   $FF
        .byte   $FF
        .byte   $C0
        .byte   $E0
        .byte   $70
        .byte   $38
        .byte   $1C
        .byte   $0E
        .byte   $07
        .byte   $03
        .byte   $03
        .byte   $07
        .byte   $0E
        .byte   $1C
        .byte   $38
        .byte   $70
        .byte   $E0
        .byte   $C0
        .byte   $FF
        .byte   $FF
        .fill   6,$C0
        .byte   $FF
        .byte   $FF
        .fill   6,$03
        .byte   $00
        .byte   $3C
        .byte   $7E
        .byte   $7E
        .byte   $7E
        .byte   $7E
        .byte   $3C
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $36
        .byte   $7F
        .byte   $7F
        .byte   $7F
        .byte   $3E
        .byte   $1C
        .byte   $08
        .byte   $00
        .fill   8,$60
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $07
        .byte   $0F
        .byte   $1C
        .byte   $18
        .byte   $18
        .byte   $C3
        .byte   $E7
        .byte   $7E
        .byte   $3C
        .byte   $3C
        .byte   $7E
        .byte   $E7
        .byte   $C3
        .byte   $00
        .byte   $3C
        .byte   $7E
        .byte   $66
        .byte   $66
        .byte   $7E
        .byte   $3C
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $66
        .byte   $66
        .byte   $18
        .byte   $18
        .byte   $3C
        .byte   $00
        .fill   8,$06
        .byte   $08
        .byte   $1C
        .byte   $3E
        .byte   $7F
        .byte   $3E
        .byte   $1C
        .byte   $08
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $FF
        .byte   $FF
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $C0
        .byte   $C0
        .byte   $30
        .byte   $30
        .byte   $C0
        .byte   $C0
        .byte   $30
        .byte   $30
        .fill   8,$18
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $3E
        .byte   $76
        .byte   $36
        .byte   $36
        .byte   $00
        .byte   $FF
        .byte   $7F
        .byte   $3F
        .byte   $1F
        .byte   $0F
        .byte   $07
        .byte   $03
        .byte   $01
        .fill   8,$00
        .fill   8,$F0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .fill   5,$FF
        .fill   14,$00
        .byte   $FF
        .fill   8,$C0
        .text   "LL33LL33"
        .fill   8,$03
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .text   "LL33"
        .byte   $FF
        .byte   $FE
        .byte   $FC
        .byte   $F8
        .byte   $F0
        .byte   $E0
        .byte   $C0
        .byte   $80
        .fill   8,$03
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $1F
        .byte   $1F
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $1F
        .byte   $1F
        .fill   6,$00
        .byte   $F8
        .byte   $F8
        .byte   $18
        .byte   $18
        .byte   $18
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $1F
        .byte   $1F
        .fill   6,$18
        .byte   $FF
        .byte   $FF
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .fill   6,$18
        .byte   $F8
        .byte   $F8
        .byte   $18
        .byte   $18
        .byte   $18
        .fill   8,$C0
        .fill   8,$E0
        .text   $07,$07,$07,$07,$07,$07,$07,$07
        .byte   $FF
        .byte   $FF
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .fill   10,$00
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .fill   6,$03
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $F8
        .byte   $F8
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $3C
        .byte   $66
        .byte   $6E
        .byte   $6E
        .byte   $60
        .byte   $62
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $06
        .byte   $3E
        .byte   $66
        .byte   $3E
        .byte   $00
        .byte   $60
        .byte   $60
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $06
        .byte   $06
        .byte   $3E
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $7E
        .byte   $60
        .byte   $3E
        .byte   $00
        .byte   $1C
        .byte   $36
        .byte   $30
        .byte   $78
        .byte   $30
        .byte   $30
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3E
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $06
        .byte   $7C
        .byte   $60
        .byte   $60
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $18
        .byte   $00
        .fill   5,$18
        .byte   $00
        .byte   $06
        .byte   $00
        .byte   $06
        .byte   $06
        .byte   $06
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $60
        .byte   $60
        .byte   $66
        .byte   $6C
        .byte   $78
        .byte   $7C
        .byte   $66
        .byte   $00
        .byte   $38
        .fill   5,$18
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $6B
        .byte   $7F
        .byte   $7F
        .byte   $63
        .byte   $63
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $00
        .byte   $3E
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $06
        .byte   $06
        .byte   $00
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $3C
        .byte   $60
        .byte   $3C
        .byte   $06
        .byte   $7C
        .byte   $00
        .byte   $30
        .byte   $30
        .byte   $FC
        .text   "006",$1C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $63
        .byte   $6B
        .byte   $7F
        .byte   $36
        .byte   $22
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $3C
        .byte   $66
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $06
        .byte   $7C
        .byte   $00
        .byte   $00
        .byte   $7E
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $7E
        .byte   $00
        .text   "<00000<"
        .byte   $00
        .byte   $0C
        .byte   $12
        .byte   $30
        .byte   $7C
        .byte   $30
        .byte   $62
        .byte   $FC
        .byte   $00
        .byte   $3C
        .fill   5,$0C
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $3C
        .byte   $7E
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $10
        .byte   $30
        .byte   $7F
        .byte   $7F
        .byte   $30
        .byte   $10
        .fill   9,$00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .fill   5,$00
        .byte   $66
        .byte   $66
        .byte   $FF
        .byte   $66
        .byte   $FF
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $18
        .byte   $3E
        .byte   $60
        .byte   $3C
        .byte   $06
        .byte   $7C
        .byte   $18
        .byte   $00
        .byte   $62
        .byte   $66
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $66
        .byte   $46
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $3C
        .byte   $38
        .byte   $67
        .byte   $66
        .byte   $3F
        .byte   $00
        .byte   $06
        .byte   $0C
        .byte   $18
        .fill   5,$00
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $30
        .byte   $30
        .byte   $18
        .byte   $0C
        .byte   $00
        .byte   $30
        .byte   $18
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $66
        .byte   $3C
        .byte   $FF
        .byte   $3C
        .byte   $66
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $7E
        .byte   $18
        .byte   $18
        .fill   7,$00
        .byte   $18
        .byte   $18
        .byte   $30
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7E
        .fill   9,$00
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $03
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $6E
        .byte   $76
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $38
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $7E
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $0C
        .byte   $30
        .byte   $60
        .byte   $7E
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $1C
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $06
        .byte   $0E
        .byte   $1E
        .byte   $66
        .byte   $7F
        .byte   $06
        .byte   $06
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $7C
        .byte   $06
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $7E
        .byte   $66
        .byte   $0C
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $3E
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $30
        .byte   $0E
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $30
        .byte   $18
        .byte   $0E
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $7E
        .byte   $00
        .byte   $7E
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $70
        .byte   $18
        .byte   $0C
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $70
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $00
        .byte   $18
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $3C
        .byte   $66
        .byte   $7E
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $6C
        .byte   $78
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $60
        .byte   $78
        .byte   $60
        .byte   $60
        .byte   $7E
        .byte   $00
        .byte   $7E
        .byte   $60
        .byte   $60
        .byte   $78
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $6E
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $7E
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $3C
        .fill   5,$18
        .byte   $3C
        .byte   $00
        .byte   $1E
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $0C
        .byte   $6C
        .byte   $38
        .byte   $00
        .byte   $66
        .byte   $6C
        .byte   $78
        .byte   $70
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $00
        .fill   6,$60
        .byte   $7E
        .byte   $00
        .byte   $63
        .byte   $77
        .byte   $7F
        .byte   $6B
        .byte   $63
        .byte   $63
        .byte   $63
        .byte   $00
        .byte   $66
        .byte   $76
        .byte   $7E
        .byte   $7E
        .byte   $6E
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $3C
        .fill   5,$66
        .byte   $3C
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $60
        .byte   $60
        .byte   $60
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $0E
        .byte   $00
        .byte   $7C
        .byte   $66
        .byte   $66
        .byte   $7C
        .byte   $78
        .byte   $6C
        .byte   $66
        .byte   $00
        .byte   $3C
        .byte   $66
        .byte   $60
        .byte   $3C
        .byte   $06
        .byte   $66
        .byte   $3C
        .byte   $00
        .byte   $7E
        .fill   6,$18
        .byte   $00
        .fill   6,$66
        .byte   $3C
        .byte   $00
        .fill   5,$66
        .byte   $3C
        .byte   $18
        .byte   $00
        .byte   $63
        .byte   $63
        .byte   $63
        .byte   $6B
        .byte   $7F
        .byte   $77
        .byte   $63
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $3C
        .byte   $66
        .byte   $66
        .byte   $00
        .byte   $66
        .byte   $66
        .byte   $66
        .byte   $3C
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
        .byte   $7E
        .byte   $06
        .byte   $0C
        .byte   $18
        .byte   $30
        .byte   $60
        .byte   $7E
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $FF
        .byte   $FF
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $C0
        .byte   $C0
        .byte   $30
        .byte   $30
        .byte   $C0
        .byte   $C0
        .byte   $30
        .byte   $30
        .fill   8,$18
        .byte   $33
        .byte   $33
        .byte   $CC

LD6F3   cpy     L3333      ;4
        cpy     L33CC      ;4
        sta     L66CC,y    ;5
        .byte   $33
        .byte   $99
        .byte   $CC
        .byte   $66
        .fill   8,$00
        .fill   8,$F0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .fill   5,$FF
        .fill   14,$00
        .byte   $FF
        .fill   8,$C0
        .text   "LL33LL33"
        .fill   8,$03
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .text   "LL33L",$99,"3"
        .byte   $66
        .byte   $CC
        .byte   $99
        .byte   $33
        .byte   $66
        .fill   8,$03
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $1F
        .byte   $1F
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $00
LD761   .byte   $00
LD762   .byte   $00
        .byte   $00
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $18
LD769   .byte   $18
        .byte   $18
        .byte   $1F
        .byte   $1F
        .fill   6,$00
        .byte   $F8
        .byte   $F8
        .byte   $18
        .byte   $18
        .byte   $18
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $1F
        .byte   $1F
        .fill   6,$18
        .byte   $FF
        .byte   $FF
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .fill   6,$18
        .byte   $F8
        .byte   $F8
        .byte   $18
        .byte   $18
        .byte   $18
        .fill   8,$C0
        .fill   8,$E0
        .text   $07,$07,$07,$07,$07,$07,$07,$07
        .byte   $FF
        .byte   $FF
        .fill   6,$00
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .fill   10,$00
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $01
        .byte   $03
        .byte   $06
        .byte   $6C
        .byte   $78
        .byte   $70
        .byte   $60
        .fill   5,$00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $18
        .byte   $18
        .byte   $18
        .byte   $F8
        .byte   $F8
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $00
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $F0
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $0F
        .byte   $08
        .byte   $09
LD802   .byte   $00
        .byte   $28
        .byte   $50
        .byte   $78
        .byte   $A0
        .byte   $C8
        .byte   $F0
        .byte   $18
        .byte   $40
        .byte   $68
        .byte   $90
        .byte   $B8
        .byte   $E0
        .byte   $08
        .byte   $30
        .byte   $58
        .byte   $80
        .byte   $A8
        .byte   $D0
        .byte   $F8
        .byte   $20
        .byte   $48
        .byte   $70
        .byte   $98
        .byte   $C0
LD81B   .fill   7,$0C
        .text   $0D,$0D,$0D,$0D,$0D,$0D
        .fill   7,$0E
        .fill   5,$0F
        .byte   $A2
        .byte   $28
        .byte   $A0
        .byte   $19
        .byte   $60
        .byte   $B0
        .byte   $0E
        .byte   $86
        .byte   $CD
        .byte   $86
        .byte   $C4
        .byte   $84
        .byte   $CA
        .byte   $84
        .byte   $C5
        .byte   $20
        .byte   $70
        .byte   $DE
        .byte   $20
        .byte   $A8
        .byte   $D8
        .byte   $A6
        .byte   $CD
        .byte   $A4
        .byte   $CA
        .byte   $60
        .byte   $A9
        .byte   $0C
        .byte   $8D
        .byte   $3E
        .byte   $05
        .byte   $A9
        .byte   $03
        .byte   $85
        .byte   $99
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $98
        .byte   $8D
        .byte   $47
        .byte   $05
        .byte   $85
        .byte   $83
        .byte   $85
        .byte   $EF
        .byte   $85
        .byte   $F0
        .byte   $A9
        .byte   $7A
        .byte   $8D
        .byte   $45
        .byte   $05
        .byte   $A9
        .byte   $DB
        .byte   $8D
        .byte   $46
        .byte   $05
        .byte   $A9
        .byte   $0A
        .byte   $8D
        .byte   $3F
        .byte   $05
        .byte   $8D
        .byte   $4A
        .byte   $05
        .byte   $8D
        .byte   $42
        .byte   $05
        .byte   $A9
        .byte   $80
        .byte   $8D
        .byte   $40
        .byte   $05
        .byte   $A9
        .byte   $10
        .byte   $8D
        .byte   $3B
        .byte   $05
        .byte   $A9
        .byte   $04
        .byte   $8D
        .byte   $41
        .byte   $05
        .byte   $20
        .byte   $70
        .byte   $DE
        .text   " ",$9A,"X "
        .byte   $AA
        .byte   $D8
        .byte   $20
        .byte   $F7
        .byte   $DA
        .byte   $EC
        .byte   $E5
        .byte   $07
        .byte   $E8
        .byte   $90
        .byte   $F4
        .byte   $AE
        .byte   $E6
        .byte   $07
        .byte   $86
        .byte   $CD
        .byte   $86
        .byte   $C4
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $84
        .byte   $CA
        .byte   $84
        .byte   $C5

LD8A8   ldx     $CD        ;3
LD8AA   lda     LD802,x    ;4+
        sta     $C8        ;3
        lda     LD81B,x    ;4+
        sta     $C9        ;3
LD8B4   lda     $C8        ;3
        sta     $EA        ;3
        lda     $C9        ;3
        and     #$03       ;2
        ora     #$08       ;2
        sta     $EB        ;3
        rts                ;6

        .byte   $AE
        .byte   $5D
        .byte   $05
        .byte   $F0
        .byte   $0F
        .byte   $AC
        .byte   $5E
        .byte   $05
        .byte   $B9
        .byte   $67
        .text   $05,"N]",$05
        .byte   $EE
        .byte   $5E
        .byte   $05
        .byte   $58
        .byte   $18
        .byte   $60
        .byte   $AC
        .byte   $27
        .byte   $05
        .byte   $EA
        .byte   $BD
        .byte   $28
        .byte   $05
        .byte   $9D
        .byte   $27
        .byte   $05
        .byte   $E8
        .byte   $E4
        .byte   $EF
        .byte   $D0
        .byte   $F5
        .byte   $C6
        .byte   $EF
        .byte   $98
        .byte   $58
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $49
        .byte   $DC
        .byte   $20
        .byte   $B4
        .byte   $D8
        .byte   $A4
        .byte   $CA
        .byte   $B1
        .byte   $EA
        .byte   $48
        .byte   $AD
        .byte   $3B
        .byte   $05
        .byte   $91
        .byte   $EA
        .byte   $98
        .byte   $18
        .byte   $65
        .byte   $C8
        .byte   $8D
        .byte   $0D
        .byte   $FF
        .byte   $A5
        .byte   $C9
        .byte   $69
        .byte   $00
        .byte   $E9
        .byte   $0B
        .byte   $8D
        .byte   $0C
        .byte   $FF
        .byte   $A5
        .byte   $EF
        .byte   $0D
        .byte   $5D
        .byte   $05
        .byte   $F0
        .byte   $F9
        .byte   $68
        .byte   $91
        .byte   $EA
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $0C
        .byte   $FF
        .byte   $8D
        .byte   $0D
        .byte   $FF
        .text   " AXI"
        .byte   $83
        .byte   $D0
        .byte   $10
        .byte   $A2
        .byte   $09
        .byte   $78
        .byte   $86
        .byte   $EF
        .byte   $BD
        .byte   $29
        .byte   $E1
        .byte   $9D
        .text   "&",$05,"JP"
        .byte   $F7
        .byte   $F0
        .byte   $BA
        .byte   $C9
        .byte   $0D
        .byte   $D0
        .byte   $B3
        .byte   $85
        .byte   $C7
        .byte   $20
        .byte   $95
        .byte   $DF
        .byte   $8E
        .byte   $49
        .byte   $05
        .byte   $20
        .byte   $87
        .byte   $DF
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $CB
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $A5
        .byte   $C4
        .byte   $30
        .byte   $13
        .byte   $C5
        .byte   $CD
        .byte   $90
        .byte   $0F
        .byte   $A4
        .text   "EMi",$05,"P"
        .byte   $04
        .byte   $C4
        .byte   $C3
        .byte   $F0
        .byte   $02
        .byte   $B0
        .byte   $11
        .byte   $85
        .byte   $CD
        .byte   $84
        .byte   $CA
        .byte   $4C
        .byte   $77
        .byte   $D9
        .byte   $98
        .byte   $48
        .byte   $8A
        .byte   $48
        .byte   $A5
        .byte   $C7
        .byte   $F0
        .byte   $C4
        .byte   $10
        .byte   $08
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $C7
        .byte   $4C
        .byte   $74
        .byte   $CF
        .byte   $EA
        .byte   $20
        .byte   $A8
        .byte   $D8
        .byte   $20
        .byte   $2F
        .byte   $DF
        .byte   $85
        .byte   $CE
        .byte   $29
        .byte   $3F
        .byte   $06
        .byte   $CE
        .byte   $24
        .byte   $CE
        .byte   $10
        .byte   $02
        .byte   $09
        .byte   $80
        .byte   $90
        .byte   $04
        .byte   $A6
        .byte   $CB
        .byte   $D0
        .byte   $04
        .byte   $70
        .byte   $02
        .byte   $09
        .byte   $40
        .byte   $20
        .byte   $BA
        .byte   $D9
        .byte   $A4
        .text   "MLi",$05,$90,$0A
        .byte   $A4
        .text   "JDC",$90
        .byte   $04
        .byte   $66
        .byte   $C7
        .byte   $30
        .byte   $03
        .byte   $20
        .byte   $BF
        .byte   $DF
        .byte   $C9
        .byte   $DE
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $FF
        .byte   $85
        .byte   $CE
        .byte   $68
        .byte   $AA
        .byte   $68
        .byte   $A8
        .byte   $A5
        .byte   $CE
        .byte   $18
        .byte   $60
        .byte   $C9
        .byte   $22
        .byte   $D0
        .byte   $08
        .byte   $A5
        .byte   $CB
        .byte   $49
        .byte   $01
        .byte   $85
        .byte   $CB
        .byte   $A9
        .byte   $22
        .byte   $60
        .byte   $A5
        .byte   $CE
        .byte   $8D
        .byte   $EB
        .byte   $07
        .byte   $68
        .byte   $A8
        .byte   $A5
        .byte   $CF
        .byte   $F0
        .byte   $02
        .byte   $46
        .byte   $CB
        .byte   $68
        .byte   $AA
        .byte   $68
        .byte   $18
        .byte   $60
        .byte   $09
        .byte   $40
        .byte   $A6
        .byte   $C2
        .byte   $F0
        .byte   $02
        .byte   $09
        .byte   $80
        .byte   $A6
        .byte   $CF
        .byte   $F0
        .byte   $02
        .byte   $C6
        .byte   $CF
        .byte   $2C
        .byte   $EA
        .byte   $07
        .byte   $10
        .byte   $09
        .byte   $48
        .byte   $20
        .byte   $CE
        .byte   $DD
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $CF
        .byte   $68
        .byte   $20
        .byte   $01
        .byte   $E0
        .byte   $CC
        .byte   $E8
        .byte   $07
        .byte   $90
        .byte   $0C
        .byte   $A6
        .byte   $CD
        .byte   $EC
        .byte   $E5
        .text   $07,$90,$05,","
        .byte   $E9
        .byte   $07
        .byte   $30
        .byte   $17
        .byte   $20
        .byte   $A8
        .byte   $D8
        .byte   $20
        .byte   $BF
        .byte   $DF
        .byte   $90
        .byte   $0F
        .byte   $20
        .byte   $39
        .byte   $DF
        .byte   $B0
        .byte   $09
        .byte   $38
        .byte   $2C
        .byte   $E9
        .byte   $07
        .byte   $70
        .byte   $04
        .byte   $20
        .byte   $5E
        .byte   $DA
        .byte   $18
        .byte   $60
        .byte   $A6
        .byte   $CD
        .byte   $EC
        .byte   $E5
        .byte   $07
        .byte   $90
        .byte   $10
        .byte   $2C
        .byte   $E9
        .byte   $07
        .byte   $10
        .byte   $07
        .byte   $AD
        .byte   $E6
        .byte   $07
        .byte   $85
        .byte   $CD
        .byte   $B0
        .byte   $06
        .byte   $20
        .byte   $89
        .byte   $DA
        .byte   $18
        .byte   $E6
        .byte   $CD
        .byte   $4C
        .byte   $A8
        .byte   $D8

LDA3D   lda     LD802,x    ;4+
        sta     $A9        ;3
        sta     $C0        ;3
        lda     LD81B,x    ;4+
        sta     $C1        ;3
        and     #$03       ;2
        ora     #$08       ;2
        sta     $AA        ;3
_LDA4F  lda     ($C0),y    ;5+
        sta     ($C8),y    ;6
        lda     ($A9),y    ;5+
        sta     ($EA),y    ;6
        cpy     $07E8      ;4
        iny                ;2
        bcc     _LDA4F     ;2+
        rts                ;6

        .byte   $A6
        .byte   $C4
        .byte   $30
        .byte   $06
        .byte   $E4
        .byte   $CD
        .byte   $90
        .byte   $02
        .byte   $E6
        .byte   $C4
        .byte   $AE
        .byte   $E5
        .byte   $07
        .byte   $20
        .byte   $AA
        .byte   $D8
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $E4
        .byte   $CD
        .byte   $F0
        .byte   $0E
        .byte   $CA
        .byte   $20
        .byte   $3B
        .byte   $DF
        .byte   $E8
        .byte   $20
        .byte   $48
        .byte   $DF
        .text   "J =Z"
        .byte   $B0
        .byte   $E8
        .byte   $20
        .byte   $F7
        .byte   $DA
        .byte   $4C
        .byte   $59
        .byte   $DF

LDA89   ldx     $07E6      ;4
_LDA8C  inx                ;2
        jsr     LDF3B      ;6
        bcc     _LDA9E     ;2+
        cpx     $07E5      ;4
        bcc     _LDA8C     ;2+
        ldx     $07E6      ;4
        inx                ;2
        jsr     LDF4A      ;6
_LDA9E  dec     $CD        ;5
        bit     $C4        ;3
        bmi     _LDAA6     ;2+
        dec     $C4        ;5
_LDAA6  ldx     $07E6      ;4
        cpx     $FE        ;3
        bcs     _LDAAF     ;2+
        dec     $FE        ;5
_LDAAF  jsr     _LDAC5     ;6
        ldx     $07E6      ;4
        jsr     LDF3B      ;6
        php                ;3
        jsr     LDF4A      ;6
        plp                ;4
        bcc     _LDAC4     ;2+
        bit     $07EC      ;4
        bmi     LDA89      ;2+
_LDAC4  rts                ;6

_LDAC5  jsr     LD8AA      ;6
        ldy     $07E7      ;4
        cpx     $07E5      ;4
        bcs     _LDADE     ;2+
        inx                ;2
        jsr     LDF3B      ;6
        dex                ;2
        jsr     LDF48      ;6
        inx                ;2
        jsr     LDA3D      ;6
        bcs     _LDAC5     ;2+
_LDADE  jsr     _LDAF7     ;6
        lda     #$7F       ;2
        jsr     _LDB70     ;6
        cmp     #$DF       ;2
        bne     _LDAF3     ;2+
        ldy     #$00       ;2
_LDAEC  nop                ;2
        dex                ;2
        bne     _LDAEC     ;2+
        dey                ;2
        bne     _LDAEC     ;2+
_LDAF3  rts                ;6

        .byte   $EA
        .byte   $EA
        .byte   $EA

_LDAF7  ldy     $07E7      ;4
        jsr     LDF4A      ;6
        jsr     LD8AA      ;6
        dey                ;2
_LDB01  iny                ;2
        lda     #$20       ;2
        sta     ($C8),y    ;6
        lda     $053B      ;4
        sta     ($EA),y    ;6
        cpy     $07E8      ;4
        bne     _LDB01     ;2+
        rts                ;6

        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $43
        .byte   $05
        .byte   $A0
        .byte   $40
        .byte   $84
        .byte   $C6
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $AA
        .byte   $E0
        .byte   $FF
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $01
        .byte   $DC
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $26
        .byte   $85
        .byte   $EC
        .byte   $A9
        .byte   $E0
        .byte   $85
        .byte   $ED
        .byte   $A9
        .byte   $FE
        .byte   $A2
        .byte   $08
        .byte   $48
        .byte   $68
        .byte   $48
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $85
        .byte   $EE
        .byte   $68
        .byte   $48
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $C5
        .byte   $EE
        .byte   $D0
        .byte   $F0
        .byte   $4A
        .byte   $B0
        .byte   $16
        .byte   $48
        .byte   $B1
        .byte   $EC
        .byte   $C9
        .byte   $05
        .byte   $B0
        .byte   $0C
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $08
        .byte   $0D
        .byte   $43
        .byte   $05
        .byte   $8D
        .byte   $43
        .byte   $05
        .byte   $10
        .byte   $02
        .byte   $84
        .byte   $C6
        .byte   $68
        .byte   $C8
        .byte   $C0
        .byte   $41
        .byte   $B0
        .byte   $08
        .byte   $CA
        .byte   $D0
        .byte   $DF
        .byte   $38
        .byte   $68
        .byte   $2A
        .byte   $D0
        .byte   $C7
        .byte   $68
        .byte   $A5
        .byte   $C6
        .byte   $6C
        .byte   $45
        .byte   $05

_LDB70  sta     $FD30      ;4
        sta     $FF08      ;4
        lda     $FF08      ;4
        rts                ;6

        .byte   $AD
        .byte   $43
        .byte   $05
        .byte   $C9
        .byte   $03
        .byte   $D0
        .byte   $19
        .byte   $AD
        .text   "g",$05,"04"
        .byte   $AD
        .text   "d",$05,"P/"
        .byte   $AD
        .byte   $13
        .byte   $FF
        .byte   $49
        .byte   $04
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $A9
        .byte   $08
        .byte   $8D
        .text   "d",$05,"P ",$0A,"I"
        .byte   $08
        .byte   $90
        .byte   $10
        .byte   $A9
        .byte   $06
        .byte   $AE
        .byte   $F7
        .byte   $07
        .byte   $D0
        .byte   $09
        .byte   $A6
        .byte   $C6
        .byte   $E0
        .byte   $0D
        .byte   $D0
        .byte   $03
        .byte   $86
        .byte   $F0
        .byte   $60
        .byte   $AA
        .byte   $BD
        .byte   $1E
        .byte   $E0
        .byte   $85
        .byte   $EC
        .byte   $BD
        .byte   $1F
        .byte   $E0
        .byte   $85
        .byte   $ED
        .byte   $A4
        .byte   $C6
        .byte   $B1
        .byte   $EC
        .byte   $AA
        .byte   $CC
        .byte   $F6
        .byte   $07
        .byte   $F0
        .byte   $07
        .byte   $A0
        .byte   $10
        .byte   $8C
        .text   "b",$05,"P6)"
        .byte   $7F
        .text   ",@",$05,"0"
        .byte   $16
        .byte   $70
        .byte   $57
        .byte   $C9
        .byte   $7F
        .byte   $F0
        .byte   $29
        .byte   $C9
        .byte   $14
        .byte   $F0
        .byte   $0C
        .byte   $C9
        .byte   $20
        .byte   $F0
        .byte   $08
        .byte   $C9
        .byte   $1D
        .byte   $F0
        .byte   $04
        .byte   $C9
        .byte   $11
        .byte   $D0
        .byte   $43
        .byte   $AC
        .byte   $42
        .byte   $05
        .byte   $F0
        .text   $05,"Nb",$05,"P9Na",$05,"P4"
        .byte   $A0
        .byte   $04
        .byte   $8C
        .byte   $41
        .byte   $05
        .byte   $A4
        .byte   $EF
        .byte   $88
        .byte   $10
        .byte   $2A
        .byte   $EA
        .byte   $EA
        .byte   $4E
        .byte   $44
        .byte   $05
        .byte   $A4
        .byte   $C6
        .byte   $8C
        .byte   $F6
        .byte   $07
        .byte   $E0
        .byte   $FF
        .byte   $F0
        .byte   $1C
        .byte   $8A
        .byte   $A2
        .byte   $00
        .byte   $86
        .byte   $F0
        .byte   $A2
        .byte   $07
        .byte   $DD
        .byte   $41
        .byte   $DC
        .byte   $F0
        .byte   $11
        .byte   $CA
        .byte   $10
        .byte   $F8
        .byte   $A6
        .byte   $EF
        .byte   $EC
        .byte   $3F
        .byte   $05
        .byte   $B0
        .byte   $06
        .byte   $9D
        .byte   $27
        .byte   $05
        .byte   $E8
        .byte   $86
        .byte   $EF
        .byte   $60
        .byte   $BD
        .byte   $5F
        .byte   $05
        .byte   $8D
        .byte   $5D
        .byte   $05
        .byte   $A9
        .byte   $00
        .byte   $CA
        .byte   $30
        .byte   $06
        .byte   $18
        .byte   $7D
        .byte   $5F
        .byte   $05
        .byte   $90
        .byte   $F7
        .byte   $8D
        .byte   $5E
        .byte   $05
        .byte   $60
        .byte   $85
        .byte   $89
        .byte   $86
        .byte   $8A
        .byte   $87
        .byte   $8B
        .byte   $88
        .byte   $8C
        .byte   $85
        .byte   $CE
        .byte   $48
        .byte   $8A
        .byte   $48
        .byte   $98
        .byte   $48
        .byte   $A5
        .byte   $F0
        .byte   $D0
        .byte   $FC
        .byte   $85
        .byte   $C7
        .byte   $A9
        .byte   $D9
        .byte   $48
        .byte   $A9
        .byte   $C6
        .byte   $48
        .byte   $A4
        .byte   $CA
        .byte   $A5
        .byte   $CE
        .byte   $C9
        .byte   $0D
        .byte   $F0
        .byte   $28
        .byte   $C9
        .byte   $8D
        .byte   $F0
        .byte   $24
        .byte   $AE
        .byte   $EB
        .byte   $07
        .byte   $E0
        .byte   $1B
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $06
        .byte   $DE
        .byte   $AA
        .byte   $30
        .byte   $14
        .text   "I ",$90,".I"
        .byte   $60
        .byte   $90
        .byte   $04
        .byte   $29
        .byte   $DF
        .byte   $D0
        .byte   $02
        .byte   $29
        .byte   $3F
        .byte   $20
        .byte   $BA
        .byte   $D9
        .byte   $4C
        .byte   $DB
        .byte   $D9
        .byte   $4C
        .byte   $47
        .byte   $DD
        .byte   $20
        .byte   $95
        .byte   $DF
        .byte   $E8
        .byte   $20
        .byte   $4A
        .byte   $DF
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $84
        .text   "J !Z"
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $CF
        .byte   $85
        .byte   $C2
        .byte   $85
        .byte   $CB
        .byte   $8D
        .byte   $3C
        .byte   $05
        .byte   $60
        .byte   $C9
        .byte   $1B
        .byte   $F0
        .byte   $4E
        .byte   $A6
        .byte   $CF
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $DF
        .byte   $D9
        .byte   $C9
        .byte   $14
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $99
        .byte   $DD
        .byte   $A6
        .byte   $CB
        .byte   $D0
        .byte   $F2
        .byte   $C9
        .byte   $12
        .byte   $D0
        .byte   $02
        .byte   $85
        .byte   $C2
        .byte   $C9
        .byte   $13
        .byte   $D0
        .byte   $0B
        .byte   $CD
        .byte   $EB
        .byte   $07
        .byte   $D0
        .byte   $03
        .byte   $20
        .byte   $70
        .byte   $DE
        .text   "l",$9A,"XI"
        .byte   $1D
        .byte   $F0
        .byte   $24
        .byte   $C9
        .byte   $11
        .byte   $F0
        .byte   $26
        .byte   $C9
        .byte   $0E
        .byte   $F0
        .byte   $49
        .byte   $C9
        .byte   $08
        .byte   $F0
        .byte   $4C
        .byte   $C9
        .byte   $09
        .byte   $F0
        .byte   $4F
        .byte   $A2
        .byte   $0F
        .byte   $DD
        .byte   $33
        .byte   $E1
        .byte   $F0
        .byte   $04
        .byte   $CA
        .byte   $10
        .byte   $F8
        .byte   $60
        .byte   $48
        .byte   $20
        .byte   $8A
        .byte   $CF
        .byte   $8D
        .byte   $3B
        .byte   $05
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $BF
        .byte   $DF
        .byte   $B0
        .byte   $04
        .byte   $60
        .text   " !Z 9"
        .byte   $DF
        .byte   $B0
        .byte   $03
        .byte   $38
        .byte   $66
        .byte   $C4
        .byte   $18
        .byte   $60
        .byte   $AE
        .byte   $E6
        .byte   $07
        .byte   $E4
        .byte   $CD
        .byte   $B0
        .byte   $F8
        .byte   $20
        .byte   $03
        .byte   $DD
        .byte   $C6
        .byte   $CD
        .byte   $4C
        .byte   $A8
        .byte   $D8
        .byte   $20
        .byte   $D4
        .byte   $DF
        .byte   $B0
LDD20   .byte   $EB
        .byte   $D0
        .byte   $E8
        .byte   $E6
        .byte   $CD
        .byte   $D0
        .byte   $ED
        .byte   $AD
        .byte   $13
        .byte   $FF
        .byte   $09
        .byte   $04
        .byte   $D0
        .byte   $15
        .byte   $A9
        .byte   $80
        .text   $0D,"g",$05,"0",$05
        .byte   $A9
        .byte   $7F
        .byte   $2D
        .byte   $47
        .byte   $05
        .byte   $8D
        .byte   $47
        .byte   $05
        .byte   $60
        .byte   $AD
        .byte   $13
        .byte   $FF
        .byte   $29
        .byte   $FB
        .byte   $8D
        .byte   $13
        .byte   $FF
        .byte   $60
        .byte   $29
        .byte   $7F
        .byte   $C9
        .byte   $7F
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $5E
        .byte   $C9
        .byte   $20
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $D9
        .byte   $D9
        .byte   $A6
        .byte   $CB
        .byte   $F0
        .byte   $05
        .byte   $09
        .byte   $40
        .byte   $4C
        .byte   $DF
        .byte   $D9
        .byte   $C9
        .byte   $14
        .byte   $F0
        .byte   $6B
        .byte   $A6
        .byte   $CF
        .byte   $D0
        .byte   $F3
        .byte   $C9
        .byte   $11
        .byte   $F0
        .byte   $A2
        .byte   $C9
        .byte   $12
        .byte   $D0
        .byte   $04
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $C2
        .byte   $C9
        .byte   $1D
        .byte   $F0
        .byte   $A5
        .byte   $C9
        .byte   $13
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $8B
        .byte   $D8
        .byte   $C9
        .byte   $02
        .byte   $D0
        .byte   $05
        .byte   $A9
        .byte   $80
        .byte   $8D
        .byte   $3C
        .byte   $05
        .byte   $C9
        .byte   $04
        .byte   $D0
        .byte   $05
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $3C
        .byte   $05
        .byte   $C9
        .byte   $0E
        .byte   $F0
        .byte   $AA
        .byte   $09
        .byte   $80
        .byte   $4C
        .byte   $E6
        .byte   $DC
        .byte   $20
        .byte   $1C
        .byte   $DD
        .byte   $20
        .byte   $F6
        .byte   $DF
        .byte   $B0
        .byte   $10
        .byte   $CC
        .byte   $E8
        .byte   $07
        .byte   $90
        .byte   $16
        .byte   $A6
        .byte   $CD
        .byte   $E8
        .byte   $20
        .byte   $3B
        .byte   $DF
        .byte   $B0
        .byte   $0E
        .byte   $20
        .byte   $FF
        .byte   $DF

LDDB1   lda     $CC        ;3
        sta     $CA        ;3
        lda     $FE        ;3
        sta     $CD        ;3
        jmp     LD8A8      ;3

        .byte   $20
        .byte   $BF
        .byte   $DF
        .byte   $20
        .byte   $2F
        .byte   $DF
        .byte   $20
        .byte   $D4
        .byte   $DF
        .byte   $20
        .byte   $11
        .byte   $E0
        .byte   $20
        .byte   $BF
        .byte   $DF
        .byte   $4C
        .byte   $A1
        .byte   $DD
        .byte   $20
        .byte   $F6
        .byte   $DF
        .byte   $20
        .byte   $95
        .byte   $DF
        .byte   $E4
        .byte   $FE
        .byte   $D0
        .byte   $02
        .text   "DL",$90,"! "
        .byte   $F8
        .byte   $D9
        .byte   $B0
        .byte   $22
        .byte   $20
        .byte   $D4
        .byte   $DF
        .byte   $20
        .byte   $2F
        .byte   $DF
        .byte   $20
        .byte   $BF
        .byte   $DF
LDDEA   .byte   $20
        .byte   $11
        .byte   $E0
        .byte   $20
        .byte   $D4
        .byte   $DF
        .byte   $A6
        .byte   $CD
        .byte   $E4
        .byte   $FE
        .byte   $D0
        .byte   $EB
        .byte   $C4
        .byte   $CC
        .byte   $D0
        .byte   $E7
        .byte   $20
        .byte   $FF
        .byte   $DF
        .byte   $E6
        .byte   $CF
        .byte   $D0
        .byte   $02
        .byte   $C6
        .byte   $CF
        .byte   $4C

LDE04   lda     ($DD),y    ;5+
        and     #$7F       ;2
        sec                ;2
        sbc     #$41       ;2
        cmp     #$17       ;2
        bcs     _LDE19     ;2+
        asl     a          ;2
        tax                ;2
        lda     _LDE1B,x   ;4+
        pha                ;3
        lda     _LDE1A,x   ;4+
        pha                ;3
_LDE19  rts                ;6

_LDE1A  .byte   $28
_LDE1B  .byte   $DF
        .byte   $5F
        .byte   $DE
        .byte   $25
        .byte   $DF
        .byte   $9F
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $8A
        .byte   $DE
        .byte   $81
        .byte   $DF
        .byte   $94
        .byte   $DF
        .byte   $1C
        .byte   $DF
        .byte   $1F
        .byte   $DF
        .byte   $87
        .byte   $D8
        .byte   $9A
        .byte   $DC
        .byte   $E0
        .byte   $DE
        .byte   $CA
        .byte   $DE
        .byte   $47
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $5D
        .byte   $DE
        .byte   $18
        .byte   $DE
        .byte   $F5
        .byte   $DE
        .byte   $03
        .byte   $DF
        .byte   $20
        .byte   $70
        .byte   $DE
        .byte   $20
        .byte   $8B
        .byte   $D8
        .byte   $A9
        .byte   $01
        .byte   $AA
        .byte   $20
        .byte   $7A
        .byte   $DE
        .byte   $A9
        .byte   $17
        .byte   $A2
        .byte   $26
        .byte   $20
        .byte   $67
        .byte   $DE
        .byte   $4C
        .byte   $9A
        .byte   $D8
        .byte   $18
        .byte   $24
        .byte   $38
        .byte   $A6
        .byte   $CA
        .byte   $A5
        .byte   $CD
        .byte   $90
        .byte   $13
        .byte   $8D
        .byte   $E5
        .byte   $07
        .byte   $8E
        .byte   $E8
        .byte   $07
        .byte   $4C
        .byte   $80
        .byte   $DE
        .byte   $A9
        .byte   $18
        .byte   $A2
        .byte   $27
        .byte   $20
        .byte   $67
        .byte   $DE
        .byte   $A9
        .byte   $00
        .byte   $AA
        .byte   $8D
        .byte   $E6
        .byte   $07
        .byte   $8E
        .byte   $E7
        .byte   $07
        .byte   $A9
        .byte   $00
        .byte   $A2
        .byte   $04
        .byte   $9D
        .byte   $ED
        .byte   $07
        .byte   $CA
        .byte   $D0
        .byte   $FA
        .byte   $60
        .byte   $20
        .byte   $5E
        .byte   $DA
        .byte   $20
        .byte   $A1
        .byte   $D8
        .byte   $E8
        .byte   $20
        .byte   $3B
        .byte   $DF
        .byte   $08
        .byte   $20
        .byte   $46
        .byte   $DF
        .byte   $28
        .byte   $B0
        .byte   $03
        .byte   $38
        .byte   $66
        .byte   $C4
        .byte   $60
        .byte   $20
        .byte   $87
        .byte   $DF
        .byte   $AD
        .byte   $E6
        .byte   $07
        .byte   $48
        .byte   $A5
        .byte   $CD
        .byte   $8D
        .byte   $E6
        .byte   $07
        .byte   $AD
        .byte   $EC
        .byte   $07
        .byte   $48
        .byte   $A9
        .byte   $80
        .byte   $8D
        .byte   $EC
        .text   $07," ",$9E,"Z"
        .byte   $68
        .byte   $8D
        .byte   $EC
        .byte   $07
        .byte   $AD
        .byte   $E6
        .byte   $07
        .byte   $85
        .byte   $CD
        .byte   $68
        .byte   $8D
        .byte   $E6
        .byte   $07
        .byte   $38
        .byte   $66
        .byte   $C4
        .byte   $4C
        .byte   $A1
        .byte   $D8
        .byte   $20
        .byte   $F6
        .byte   $DF
        .byte   $20
        .byte   $FD
        .byte   $DA
        .byte   $E6
        .byte   $CD
        .byte   $20
        .byte   $A8
        .byte   $D8
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $20
        .byte   $39
        .byte   $DF
        .byte   $B0
        .byte   $F0

LDEDE   jmp     LDDB1      ;3

LDEE1   jsr     LDFF6      ;6
_LDEE4  jsr     LDFFF      ;6
        cpy     $07E7      ;4
        bne     _LDEF1     ;2+
        jsr     LDF39      ;6
        bcc     LDEDE      ;2+
_LDEF1  jsr     LDFD4      ;6
        bcc     _LDEE4     ;2+
        jsr     LDFF6      ;6
        txa                ;2
        pha                ;3
        jsr     LDA89      ;6
        pla                ;4
        sta     $FE        ;3
        jmp     LDEDE      ;3

        .byte   $20
        .byte   $F6
        .byte   $DF
        .byte   $20
        .byte   $39
        .byte   $DF
        .byte   $B0
        .byte   $03
        .byte   $38
        .byte   $66
        .byte   $C4
        .byte   $AD
        .byte   $E6
        .byte   $07
        .byte   $85
        .byte   $CD
        .byte   $20
        .byte   $5E
        .byte   $DA
        .byte   $20
        .byte   $4A
        .byte   $DF
        .byte   $4C
        .byte   $DE
        .byte   $DE
        .byte   $A9
        .byte   $00
        .byte   $2C
        .byte   $A9
        .byte   $80
        .byte   $8D
        .byte   $E9
        .byte   $07
        .byte   $60
        .byte   $A9

LDF27   brk                ;7

        .byte   $2C
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $EA
        .byte   $07
        .byte   $60
        .byte   $A4
        .byte   $CA
        .byte   $B1
        .byte   $EA
        .byte   $8D
        .byte   $ED
        .byte   $07
        .byte   $B1
        .byte   $C8
        .byte   $60

LDF39   ldx     $CD        ;3
LDF3B   jsr     LDF66      ;6
        and     $07EE,x    ;4+
        cmp     #$01       ;2
        jmp     LDF55      ;3

        .byte   $A6
        .byte   $CD

LDF48   bcs     LDF59      ;2+
LDF4A   jsr     LDF66      ;6
        eor     #$FF       ;2
        and     $07EE,x    ;4+
LDF52   sta     $07EE,x    ;5
LDF55   ldx     $02E9      ;4
        rts                ;6

LDF59   bit     $07E9      ;4
        bvs     LDF3B      ;2+
        jsr     LDF66      ;6
        ora     $07EE,x    ;4+
        bne     LDF52      ;2+
LDF66   stx     $02E9      ;4
        txa                ;2
        and     #$07       ;2
        tax                ;2
        lda     _LDF7A,x   ;4+
        pha                ;3
        lda     $02E9      ;4
        lsr     a          ;2
        lsr     a          ;2
        lsr     a          ;2
        tax                ;2
        pla                ;4
        rts                ;6

_LDF7A  .byte   $80
        .byte   $40
        .byte   $20
        .byte   $10
        .byte   $08
        .byte   $04
        .byte   $02
        .byte   $01
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $84
        .byte   $CA
        .byte   $20
        .byte   $39
        .byte   $DF
        .byte   $90
        .byte   $06
        .byte   $C6
        .byte   $CD
        .byte   $10
        .byte   $F7
        .byte   $E6
        .byte   $CD
        .byte   $4C
        .byte   $A8
        .byte   $D8
        .byte   $E6
        .byte   $CD
        .byte   $20
        .byte   $39
        .byte   $DF
        .byte   $B0
        .byte   $F9
        .byte   $C6
        .byte   $CD
        .byte   $20
        .byte   $A8
        .byte   $D8
        .byte   $AC
        .byte   $E8
        .byte   $07
        .byte   $84
        .byte   $CA
        .byte   $20
        .byte   $2F
        .byte   $DF
        .byte   $C9
        .byte   $20
        .byte   $D0
        .byte   $0F
        .byte   $CC
        .byte   $E7
        .text   $07,"P",$05," 9"
        .byte   $DF
        .text   $90,$05," T"
        .byte   $DF
        .byte   $90
        .byte   $EA
        .byte   $84
        .byte   $C3
        .byte   $60
        .byte   $48
        .byte   $A4
        .byte   $CA
        .byte   $CC
        .byte   $E8
        .byte   $07
        .byte   $90
        .byte   $08
        .byte   $20
        .byte   $21
        .byte   $DA
        .byte   $AC
        .byte   $E7
        .byte   $07
        .byte   $88
        .byte   $38
        .byte   $C8
        .byte   $84
        .byte   $CA
        .byte   $68
        .byte   $60

LDFD4   ldy     $CA        ;3
        dey                ;2
        bmi     _LDFDE     ;2+
        cpy     $07E7      ;4
        bcs     _LDFEF     ;2+
_LDFDE  ldy     $07E6      ;4
        cpy     $CD        ;3
        bcs     _LDFF5     ;2+
        dec     $CD        ;5
        pha                ;3
        jsr     LD8A8      ;6
        pla                ;4
        ldy     $07E8      ;4
_LDFEF  sty     $CA        ;3
        cpy     $07E8      ;4
        clc                ;2
_LDFF5  rts                ;6

LDFF6   ldy     $CA        ;3
        sty     $CC        ;3
        ldx     $CD        ;3
        stx     $FE        ;3
        rts                ;6

LDFFF   lda     #$20       ;2
        ldy     $CA        ;3
        sta     ($C8),y    ;6
        jsr     LD8B4      ;6
        lda     $053B      ;4
        ora     $053C      ;4
        sta     ($EA),y    ;6
        rts                ;6

        .byte   $A4
        .byte   $CA
        .byte   $91
        .byte   $C8
        .byte   $20
        .byte   $B4
        .byte   $D8
        .byte   $AD
        .byte   $ED
        .byte   $07
        .byte   $91
        .byte   $EA
        .byte   $60
        .byte   $26
        .byte   $E0
        .byte   $67
        .byte   $E0
        .byte   $A8
        .byte   $E0
        .byte   $E9
        .byte   $E0
        .byte   $14
        .byte   $0D
LE028   .byte   $5C
        .byte   $8C
        .byte   $85
        .byte   $89
        .byte   $86
        .text   "@3wa4zse"
        .byte   $01
        .text   "5rd6cftx7yg8bhuv9ij0mkon"
        .byte   $11
        .byte   $50
        .byte   $4C
        .byte   $91
        .text   ".:-,"
        .byte   $9D
        .byte   $2A
        .byte   $3B
        .byte   $1D
        .byte   $1B
        .text   "=+/1"
        .byte   $13
        .byte   $04
        .byte   $32
        .byte   $20
        .byte   $02
        .byte   $51
        .byte   $03
        .byte   $FF
        .byte   $94
        .byte   $8D
        .byte   $A9
        .byte   $88
        .byte   $8A
        .byte   $87
        .byte   $8B
        .byte   $BA
        .text   "#WA$ZSE"
        .byte   $01
        .text   "%RD&CFTX'YG(BHUV)IJ"
        .byte   $5E
        .text   "MKON"
        .byte   $11
        .byte   $D0
        .byte   $CC
        .byte   $91
        .byte   $3E
        .byte   $5B
        .byte   $DD
        .byte   $3C
        .byte   $9D
        .byte   $C0
        .byte   $5D
        .byte   $1D
        .byte   $1B
        .byte   $5F
        .byte   $DB
        .byte   $3F
        .byte   $21
        .byte   $93
        .byte   $04
        .byte   $22
        .byte   $A0
        .byte   $02
        .byte   $D1
        .byte   $83
        .byte   $FF
        .byte   $94
        .byte   $8D
        .byte   $A8
        .byte   $88
        .byte   $8A
        .byte   $87
        .byte   $8B
        .byte   $A4
        .byte   $96
        .byte   $B3
        .byte   $B0
        .byte   $97
        .byte   $AD
        .byte   $AE
        .byte   $B1
        .byte   $01
        .byte   $98
        .byte   $B2
        .byte   $AC
        .byte   $99
        .byte   $BC
        .byte   $BB
        .byte   $A3
        .byte   $BD
        .byte   $9A
        .byte   $B7
        .byte   $A5
        .byte   $9B
        .byte   $BF
        .byte   $B4
        .byte   $B8
        .byte   $BE
        .byte   $29
        .byte   $A2
        .byte   $B5
        .byte   $30
        .byte   $A7
        .byte   $A1
        .byte   $B9
        .byte   $AA
        .byte   $11
        .byte   $AF
        .byte   $B6
        .byte   $91
        .byte   $3E
        .byte   $5B
        .byte   $DC
        .byte   $3C
        .byte   $9D
        .byte   $DF
        .byte   $5D
        .byte   $1D
        .byte   $1B
        .byte   $DE
        .byte   $A6
        .byte   $3F
        .byte   $81
        .byte   $93
        .byte   $04
        .byte   $95
        .byte   $A0
        .byte   $02
        .byte   $AB
        .byte   $83
        .byte   $FF
        .byte   $FF
        .byte   $FF
        .byte   $1C
        .fill   5,$FF
        .byte   $1C
        .byte   $17
        .byte   $01
        .byte   $9F
        .byte   $1A
        .byte   $13
        .byte   $05
        .byte   $FF
        .byte   $9C
        .byte   $12
        .byte   $04
        .byte   $1E
        .byte   $03
        .byte   $06
        .byte   $14
LE100   .byte   $18
        .byte   $1F
        .byte   $19
        .byte   $07
        .byte   $9E
        .byte   $02
        .byte   $08
        .byte   $15
        .byte   $16
        .byte   $12
        .byte   $09
        .byte   $0A
        .byte   $92
        .byte   $0D
        .byte   $0B
        .byte   $0F
        .byte   $0E
        .byte   $FF
        .byte   $10
        .byte   $0C
        .byte   $FF
        .byte   $84
        .byte   $1B
        .byte   $FF
        .byte   $82
        .byte   $FF
        .byte   $FF
        .byte   $1D
        .byte   $FF
        .byte   $1B
        .byte   $06
        .byte   $FF
        .byte   $FF
        .byte   $90
        .byte   $FF
        .byte   $FF
        .byte   $05
        .byte   $FF
        .byte   $FF
        .byte   $11
        .byte   $FF
        .byte   $FF
        .text   "dL",$22,"*",$0D,"run",$0D,$90,$05,$1C,$9F,$9C,$1E,$1F,$9E,$81
        .text   $95,$96,$97,$98,$99,$9A,$9B
        .byte   $00
        .byte   $71
        .byte   $32
        .byte   $63
        .byte   $44
        .byte   $35
        .byte   $46
        .byte   $77
        .byte   $48
        .byte   $29
        .byte   $5A
        .byte   $6B
        .byte   $5C
        .byte   $6D
        .byte   $2E
        .byte   $5F
        .byte   $09
        .byte   $40
        .byte   $2C
        .byte   $09
        .byte   $20
        .byte   $48
        .byte   $24
        .byte   $94
        .byte   $10
        .byte   $0A
        .byte   $38
        .byte   $66
        .byte   $A6
        .byte   $20
        .byte   $81
        .byte   $E1
        .byte   $46
        .byte   $94
        .byte   $46
        .byte   $A6
        .byte   $68
        .byte   $85
        .byte   $95
        .byte   $78
        .byte   $20
        .byte   $C6
        .byte   $E2
        .byte   $20
        .byte   $BF
        .byte   $E2
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $04
        .byte   $85
        .byte   $01
        .byte   $78
        .byte   $20
        .byte   $BF
        .byte   $E2
        .byte   $20
        .byte   $C6
        .byte   $E2
        .byte   $20
        .byte   $DC
        .byte   $E2
        .byte   $78
        .byte   $20
        .byte   $C6
        .byte   $E2
        .byte   $20
        .byte   $D4
        .byte   $E2
        .byte   $B0
        .byte   $5F
        .byte   $20
        .byte   $B8
        .byte   $E2
        .byte   $24
        .byte   $A6
        .byte   $10
        .byte   $0E
        .byte   $20
        .byte   $D4
        .byte   $E2
        .byte   $90
        .byte   $FB
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $0A
        .byte   $B0
        .byte   $F7
        .byte   $20
        .byte   $D4
        .byte   $E2
        .byte   $90
        .byte   $FB
        .byte   $20
        .byte   $BF
        .byte   $E2
        .byte   $A9
        .byte   $08
        .byte   $85
        .byte   $AA
        .byte   $20
        .byte   $D4
        .byte   $E2
        .byte   $90
        .byte   $3E
        .byte   $66
        .byte   $95
        .byte   $B0
        .byte   $05
        .byte   $20
        .byte   $CD
        .byte   $E2
        .byte   $D0
        .byte   $03
        .byte   $20
        .byte   $C6
        .byte   $E2
        .byte   $20
        .byte   $11
        .byte   $E3
        .byte   $20
        .byte   $B8
        .byte   $E2
        .byte   $20
        .byte   $11
        .byte   $E3
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $FE
        .byte   $09
        .byte   $02
        .byte   $85
        .byte   $01
        .byte   $C6
        .byte   $AA
        .byte   $D0
        .byte   $DA
        .byte   $8A
        .byte   $48
        .byte   $A2
        .byte   $78
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .text   $0A,$90,$07,"JP"
        .byte   $F4
        .byte   $68
        .byte   $AA
        .byte   $B0
        .byte   $09
        .byte   $68
        .byte   $AA
        .byte   $58
        .byte   $60
        .byte   $A9
        .byte   $80
        .byte   $4C
        .byte   $F0
        .byte   $E1
        .byte   $A9
        .byte   $03
        .byte   $20
        .byte   $1E
        .byte   $F4
        .byte   $58
        .byte   $18
        .byte   $90
        .byte   $4B
        .byte   $85
        .byte   $95
        .byte   $20
        .byte   $77
        .byte   $E1
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $FB
LE200   .byte   $85
        .byte   $01
        .byte   $60
        .byte   $85
        .byte   $95
        .byte   $20
        .byte   $77
        .byte   $E1
        .text   "$",$90,"06"
        .byte   $78
        .byte   $20
        .byte   $CD
        .byte   $E2
        .byte   $20
        .byte   $FC
        .byte   $E1
        .byte   $20
        .byte   $B8
        .byte   $E2
        .byte   $24
        .byte   $01
        .byte   $70
        .byte   $FC
        .byte   $58
        .byte   $60
        .byte   $FF
        .byte   $24
        .byte   $94
        .byte   $30
        .byte   $05
        .byte   $38
        .byte   $66
        .byte   $94
        .text   "P",$05,"h ",$81
        .byte   $E1
        .byte   $68
        .byte   $85
        .byte   $95
        .byte   $18
        .byte   $60
        .byte   $78
        .byte   $20
        .byte   $BF
        .byte   $E2
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $04
        .byte   $85
        .byte   $01
        .byte   $A9
        .byte   $5F
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $3F
        .byte   $20
        .byte   $58
        .byte   $E1
        .byte   $20
        .byte   $FC
        .byte   $E1
        .byte   $8A
        .byte   $A2
        .byte   $14
        .byte   $CA
        .byte   $D0
        .byte   $FD
        .byte   $AA
        .byte   $20
        .byte   $B8
        .byte   $E2
        .byte   $4C
        .byte   $C6
        .byte   $E2
        .byte   $78
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $AA
        .byte   $20
        .byte   $B8
        .byte   $E2
        .byte   $8A
        .byte   $48
        .byte   $20
        .byte   $D4
        .byte   $E2
        .byte   $10
        .byte   $FB
        .byte   $A2
        .byte   $20
        .byte   $20
        .byte   $C6
        .byte   $E2
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $0A
        .byte   $10
        .byte   $1F
        .byte   $CA
        .byte   $D0
        .byte   $F4
        .byte   $A5
        .byte   $AA
        .byte   $F0
        .byte   $07
        .byte   $68
        .byte   $AA
        .byte   $A9
        .byte   $02
        .byte   $4C
        .byte   $F0
        .byte   $E1
        .byte   $20
        .byte   $CD
        .byte   $E2
        .byte   $A2
        .byte   $40
        .byte   $CA
        .byte   $D0
        .byte   $FD
        .byte   $A9
        .byte   $40
        .byte   $20
        .byte   $1E
        .byte   $F4
        .byte   $E6
        .byte   $AA
        .byte   $D0
        .byte   $D3
        .byte   $A2
        .byte   $08
        .byte   $A5
        .byte   $01
        .byte   $0A
        .byte   $10
        .byte   $FB
        .byte   $66
        .byte   $A8
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $0A
        .byte   $30
        .byte   $F7
        .byte   $CA
        .byte   $D0
        .byte   $ED
        .byte   $86
        .byte   $AA
        .byte   $68
        .byte   $AA
        .byte   $20
        .byte   $CD
        .byte   $E2
        .byte   $A9
        .text   "@$",$90,"p"
        .byte   $03
        .byte   $20
        .byte   $45
        .byte   $E2
        .byte   $A5
        .byte   $A8
        .byte   $58
        .byte   $18
        .byte   $60
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $FD
        .byte   $85
        .byte   $01
        .byte   $60
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $02
        .byte   $85
        .byte   $01
        .byte   $60
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $FE
        .byte   $85
        .byte   $01
        .byte   $60
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $01
        .byte   $85
        .byte   $01
        .byte   $60
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $0A
        .byte   $60
        .byte   $20
        .byte   $F8
        .byte   $E2
        .byte   $A9
        .byte   $10
        .byte   $2C
        .byte   $09
        .byte   $FF
        .byte   $F0
        .byte   $FB
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $60
        .byte   $20
        .byte   $FC
        .byte   $E2
        .byte   $A9
        .byte   $10
        .byte   $2C
        .byte   $09
        .byte   $FF
        .byte   $F0
        .byte   $FB
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $60
        .byte   $A9
        .byte   $04
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $40
        .byte   $08
        .byte   $48
LE300   .byte   $78
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $02
        .byte   $FF
        .byte   $68
        .byte   $8D
        .byte   $03
        .byte   $FF
        .byte   $A9
        .byte   $10
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $28
        .byte   $60
        .byte   $8A
        .byte   $A2
        .byte   $05
        .byte   $CA
        .byte   $D0
        .byte   $FD
        .byte   $AA
        .byte   $60
        .byte   $38
        .byte   $24
        .byte   $18
        .byte   $AD
        .byte   $10
        .byte   $FD
        .byte   $29
        .byte   $04
        .byte   $F0
        .byte   $3F
        .byte   $08
        .byte   $20
        .byte   $D8
        .byte   $FB
        .text   $0D,"press play "
        .byte   $00
        .text   "(",$90,$0D," X"
        .byte   $FB
        .text   "& record "
        .byte   $00
        .byte   $20
        .byte   $D8
        .byte   $FB
        .text   "on tape"
        .byte   $00
        .byte   $20
        .byte   $CB
        .byte   $FB
        .byte   $B0
        .byte   $0F
        .byte   $AD
        .byte   $10
        .byte   $FD
        .byte   $29
        .byte   $04
        .byte   $D0
        .byte   $F4
        .byte   $20
        .byte   $D8
        .byte   $FB
        .byte   $0D
        .byte   $4F
        .byte   $4B
        .byte   $00
        .byte   $18
        .byte   $60
        .byte   $78
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $29
        .byte   $EF
        .byte   $8D
        .byte   $06
        .byte   $FF
        .byte   $AD
        .byte   $0A
        .byte   $FF
        .byte   $29
        .byte   $FD
        .byte   $09
        .byte   $08
        .byte   $8D
        .byte   $0A
        .byte   $FF
        .byte   $60
        .byte   $78
        .byte   $AD
        .byte   $06
        .byte   $FF
        .byte   $09
        .byte   $10
        .byte   $8D
        .byte   $06
        .byte   $FF
        .byte   $AD
        .byte   $0A
        .byte   $FF
        .byte   $29
        .byte   $F7
        .byte   $09
        .byte   $02
        .byte   $8D
        .byte   $0A
        .byte   $FF
        .byte   $58
        .byte   $60
        .byte   $08
        .byte   $38
        .byte   $6E
        .byte   $FC
        .byte   $07
        .byte   $A5
        .byte   $01
        .byte   $29
        .byte   $F5
        .byte   $85
        .byte   $01
        .byte   $A2
        .byte   $1E
        .byte   $20
        .byte   $EA
        .byte   $E2
        .byte   $CA
        .byte   $D0
        .byte   $FA
        .byte   $28
        .byte   $60
        .text   "c1984commodore"
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $08
        .byte   $85
        .byte   $01
        .byte   $60
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $20
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $C0
        .byte   $C0
        .byte   $D0
        .byte   $F9
        .byte   $60
        .byte   $48
        .byte   $A9
        .byte   $33
        .byte   $85
        .byte   $B6
        .byte   $A9
        .byte   $03
        .byte   $85
        .byte   $B7
        .byte   $68
        .byte   $60
        .byte   $20
        .byte   $CB
        .byte   $FB
        .byte   $90
        .byte   $10
        .byte   $20
        .byte   $B0
        .byte   $E3
        .byte   $20
        .byte   $78
        .byte   $E3
        .byte   $AE
        .byte   $BE
        .byte   $07
        .byte   $9A
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $BE
        .byte   $07
        .byte   $38
        .byte   $60
        .byte   $AD
        .byte   $09
        .byte   $FF
        .byte   $2D
        .byte   $0A
        .byte   $FF
        .byte   $29
        .byte   $08
        .byte   $D0
        .byte   $01
        .byte   $60
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $78
        .byte   $A9
        .byte   $90
        .byte   $8D
        .byte   $00
        .byte   $FF
        .byte   $A9
        .byte   $33
        .byte   $8D
        .byte   $01
        .byte   $FF
        .byte   $AE
        .byte   $BF
        .byte   $07
LE400   .byte   $9A
        .byte   $38
        .byte   $60
        .byte   $A9
        .byte   $A8
        .byte   $8D
        .byte   $00
        .byte   $FF
        .byte   $A9
        .byte   $48
        .byte   $8D
        .byte   $01
        .byte   $FF
        .byte   $A9
        .byte   $08
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $60
        .byte   $38
        .byte   $B0
        .byte   $01
        .byte   $18
        .byte   $8C
        .byte   $CA
        .byte   $07
        .byte   $8E
        .byte   $CB
        .byte   $07
        .byte   $AC
        .byte   $C8
        .byte   $07
        .byte   $AE
        .byte   $C9
        .byte   $07
        .byte   $A9
        .byte   $10
        .byte   $2C
        .byte   $09
        .byte   $FF
LE428   .byte   $F0
        .byte   $FB
        .byte   $8C
        .byte   $02
        .byte   $FF
        .byte   $8E
        .byte   $03
        .byte   $FF
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $A5
        .byte   $01
        .byte   $49
        .byte   $02
        .byte   $85
        .byte   $01
        .byte   $08
        .byte   $20
        .byte   $CE
        .byte   $E3
        .byte   $28
        .byte   $AC
        .byte   $CA
        .byte   $07
        .byte   $AE
        .byte   $CB
        .byte   $07
        .byte   $B0
        .byte   $D0
        .byte   $60
        .byte   $A9
        .byte   $4E
        .byte   $8D
        .byte   $C8
        .byte   $07
        .byte   $A9
        .byte   $03
        .byte   $8D
        .byte   $C9
        .byte   $07
        .byte   $60
        .byte   $A9
        .byte   $D0
        .byte   $8D
        .byte   $C8
        .byte   $07
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $C9
        .byte   $07
LE45C   .byte   $60
        .byte   $A9
        .byte   $A4
        .byte   $8D
        .byte   $C8
        .byte   $07
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $C9
        .byte   $07
        .byte   $60
        .byte   $20
        .byte   $52
        .byte   $E4
        .byte   $20
        .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $5D
        .byte   $E4
        .byte   $4C
        .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $5D
        .byte   $E4
        .byte   $20
        .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $52
        .byte   $E4
        .byte   $4C
        .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $47
        .byte   $E4
        .byte   $20
LE484   .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $5D
        .byte   $E4
        .byte   $4C
        .byte   $13
        .byte   $E4
        .byte   $85
        .byte   $A7
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $B1
        .byte   $07
        .byte   $20
        .byte   $80
        .byte   $E4
        .byte   $A2
        .byte   $08
        .byte   $66
        .byte   $A7
        .byte   $B0
        .byte   $09
        .byte   $EE
        .byte   $B1
        .byte   $07
        .byte   $20
        .byte   $68
        .byte   $E4
        .byte   $4C
        .byte   $A8
        .byte   $E4
        .byte   $20
        .byte   $74
        .byte   $E4
        .byte   $CA
        .byte   $D0
        .byte   $ED
        .byte   $6E
        .byte   $B1
LE4AD   .byte   $07
        .byte   $B0
        .byte   $06
        .byte   $20
        .byte   $68
        .byte   $E4
        .byte   $4C
        .byte   $B9
        .byte   $E4
        .byte   $20
        .byte   $74
        .byte   $E4
        .byte   $60
        .byte   $BA
LE4BB   .byte   $8E
LE4BC   .byte   $BE
        .byte   $07
        .byte   $A5
        .byte   $01
        .byte   $09
        .byte   $02
        .byte   $85
        .byte   $01
        .byte   $20
        .byte   $52
        .byte   $E4
        .byte   $A0
        .byte   $01
        .byte   $8C
        .byte   $03
        .byte   $FF
        .byte   $A9
        .byte   $10
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $24
        .byte   $F7
        .byte   $10
        .byte   $04
LE4D5   .byte   $A0
        .byte   $40
        .byte   $A2
        .byte   $FE
        .byte   $20
        .byte   $13
        .byte   $E4
        .byte   $CA
        .byte   $D0
        .byte   $FA
        .byte   $88
        .byte   $D0
        .byte   $F7
        .byte   $A0
LE4E3   .byte   $09
LE4E4   .byte   $98
        .byte   $05
        .byte   $F7
        .byte   $20
        .byte   $8C
        .byte   $E4
        .byte   $88
        .byte   $D0
        .byte   $F7
        .byte   $A5
        .byte   $F8
        .byte   $85
        .byte   $F5
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $8C
        .byte   $E4
        .byte   $A0
        .byte   $00
        .byte   $A9
        .byte   $BA
        .byte   $8D
        .byte   $DF
        .text   $07," Y",$07
LE500   .byte   $48
        .byte   $45
        .byte   $F5
        .byte   $85
        .byte   $F5
        .byte   $68
        .byte   $20
        .byte   $8C
        .byte   $E4
        .byte   $E6
        .byte   $BA
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $BB
        .byte   $EE
        .byte   $F3
        .byte   $03
        .byte   $D0
        .byte   $E2
        .byte   $EE
        .byte   $F4
        .byte   $03
        .byte   $D0
        .byte   $DD
        .byte   $A5
        .byte   $F5
        .byte   $20
        .byte   $8C
        .byte   $E4
        .byte   $20
        .byte   $5D
        .byte   $E4
        .byte   $20
        .byte   $13
        .byte   $E4
        .byte   $20
        .byte   $52
        .byte   $E4
LE527   .byte   $A0
LE528   .byte   $01
        .byte   $A2
        .byte   $C2
        .byte   $20
        .byte   $13
        .byte   $E4
        .byte   $CA
        .byte   $D0
        .byte   $FA
        .byte   $88
        .byte   $D0
        .byte   $F7
        .byte   $60
        .byte   $20
        .byte   $19
        .byte   $E3
        .byte   $20
        .byte   $64
        .byte   $E3
        .byte   $20
        .byte   $8D
        .byte   $E3
        .byte   $B0
        .byte   $26
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $F7
        .byte   $A5
        .byte   $B6
        .byte   $85
        .byte   $BA
        .byte   $A5
        .byte   $B7
        .byte   $85
        .byte   $BB
        .byte   $A9
        .byte   $41
        .byte   $8D
LE54F   .byte   $F3
LE550   .byte   $03
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $F4
        .byte   $03
        .byte   $20
        .byte   $BA
        .byte   $E4
        .byte   $B0
        .byte   $0B
        .byte   $A5
        .byte   $F7
        .byte   $10
        .byte   $06
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $F7
        .byte   $10
        .byte   $DF
        .byte   $18
        .byte   $20
        .byte   $B0
        .byte   $E3
        .byte   $4C
        .byte   $78
        .byte   $E3
        .byte   $20
        .byte   $C3
        .byte   $E3
        .byte   $20
        .byte   $B7
        .byte   $E3
        .byte   $A0
        .byte   $00
        .byte   $A5
        .byte   $B2
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $A5
        .byte   $B3
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $A5
        .byte   $9D
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $A5
        .byte   $9E
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $8C
        .byte   $B3
        .byte   $07
        .byte   $A0
        .byte   $00
        .byte   $8C
        .byte   $B2
        .byte   $07
        .byte   $AC
        .byte   $B2
        .byte   $07
        .byte   $C4
        .byte   $AB
        .byte   $F0
        .byte   $16
        .byte   $A9
        .byte   $AF
        .byte   $8D
        .byte   $DF
        .text   $07," Y",$07
        .byte   $AC
        .byte   $B3
        .byte   $07
        .byte   $91
        .byte   $B6
        .byte   $EE
        .byte   $B2
        .byte   $07
        .byte   $EE
        .byte   $B3
        .byte   $07
        .byte   $4C
        .byte   $90
        .byte   $E5
        .byte   $4C
        .byte   $35
        .byte   $E5
        .byte   $20
        .byte   $19
        .byte   $E3
        .byte   $20
        .byte   $64
        .byte   $E3
        .byte   $20
        .byte   $8D
        .byte   $E3
        .byte   $B0
        .byte   $2F
        .byte   $A9
        .byte   $80
        .byte   $85
        .byte   $F7
        .byte   $A5
        .byte   $B2
        .byte   $85
        .byte   $BA
        .byte   $A5
        .byte   $B3
        .byte   $85
        .byte   $BB
        .byte   $18
        .byte   $A5
        .byte   $9D
        .byte   $E5
        .byte   $B2
        .byte   $49
        .byte   $FF
        .byte   $8D
        .byte   $F3
        .byte   $03
        .byte   $A5
        .byte   $9E
        .byte   $E5
        .byte   $B3
        .byte   $49
        .byte   $FF
        .byte   $8D
        .byte   $F4
        .byte   $03
        .byte   $20
        .byte   $BA
        .byte   $E4
        .byte   $B0
        .byte   $0B
        .byte   $A5
        .byte   $F7
        .byte   $10
        .byte   $06
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $F7
        .byte   $10
        .byte   $D6
        .byte   $18
        .byte   $20
        .byte   $B0
        .byte   $E3
        .byte   $4C
        .byte   $78
        .byte   $E3
        .byte   $20
        .byte   $B7
        .byte   $E3
        .byte   $A9
        .byte   $05
        .byte   $85
        .byte   $F8
        .byte   $4C
        .byte   $35
        .byte   $E5
        .byte   $40
        .byte   $00
        .byte   $80
        .byte   $AE
        .byte   $B8
        .byte   $07
LE600   .byte   $AC
        .byte   $B9
        .byte   $07
        .byte   $AD
        .byte   $BB
        .byte   $07
        .byte   $48
        .byte   $AD
        .byte   $BA
        .byte   $07
        .byte   $48
        .byte   $A9
        .byte   $10
        .byte   $24
        .byte   $01
        .byte   $F0
        .byte   $FC
        .byte   $24
        .byte   $01
        .byte   $D0
        .byte   $FC
        .byte   $8E
        .byte   $02
        .byte   $FF
        .byte   $8C
        .byte   $03
        .byte   $FF
        .byte   $68
        .byte   $8D
        .byte   $04
        .byte   $FF
        .byte   $68
        .byte   $8D
        .byte   $05
        .byte   $FF
        .byte   $A9
        .byte   $50
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $29
        .byte   $10
        .text   "PQ N"
        .byte   $E3
        .byte   $A9
        .byte   $10
        .byte   $24
        .byte   $01
        .byte   $D0
        .byte   $47
        .byte   $2C
        .byte   $09
        .byte   $FF
        .byte   $F0
        .byte   $F7
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $29
        .byte   $10
        .byte   $D0
        .byte   $38
        .byte   $A9
        .byte   $40
        .byte   $2C
        .byte   $09
        .byte   $FF
        .byte   $F0
        .byte   $FB
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $29
        .byte   $10
        .byte   $D0
        .byte   $2C
        .byte   $AD
        .byte   $BC
        .byte   $07
        .byte   $8D
        .byte   $02
        .byte   $FF
        .byte   $AD
        .byte   $BD
        .byte   $07
        .byte   $8D
        .byte   $03
        .byte   $FF
        .byte   $A9
        .byte   $10
        .byte   $8D
        .byte   $09
        .byte   $FF
        .byte   $A9
        .byte   $10
        .byte   $2C
        .byte   $09
        .byte   $FF
        .byte   $F0
        .byte   $FB
        .byte   $A5
        .byte   $01
        .byte   $C5
        .byte   $01
        .byte   $D0
        .byte   $FA
        .byte   $29
        .byte   $10
        .byte   $F0
        .byte   $0F
        .byte   $2C
        .byte   $FC
        .byte   $E5
        .byte   $30
        .byte   $08
        .byte   $2C
        .byte   $FA
        .byte   $E5
        .byte   $70
        .byte   $03
        .byte   $2C
        .byte   $FB
        .byte   $E5
        .byte   $18
        .byte   $60
        .byte   $38
        .byte   $60
        .byte   $40
        .byte   $00
        .byte   $80
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $3D
        .byte   $70
        .byte   $12
        .byte   $10
        .byte   $02
        .byte   $30
        .byte   $27
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $32
        .byte   $70
        .byte   $02
        .byte   $50
        .byte   $2E
        .byte   $2C
        .byte   $8F
        .byte   $E6
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $70
        .byte   $04
        .byte   $10
        .text   $0D,"0  "
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $1B
        .byte   $70
        .byte   $F9
        .byte   $10
        .byte   $17
        .byte   $30
        .byte   $05
        .byte   $2C
        .byte   $8E
        .byte   $E6
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $0B
        .byte   $70
        .byte   $09
        .byte   $10
        .byte   $02
        .text   "0",$05,",",$90
        .byte   $E6
        .byte   $18
        .byte   $60
        .byte   $38
        .byte   $60
        .byte   $BA
        .byte   $8E
        .byte   $BF
        .byte   $07
        .byte   $18
        .byte   $6E
        .text   "L",$07,"x "
        .byte   $91
        .byte   $E6
        .byte   $B0
        .byte   $FB
        .byte   $70
        .byte   $F9
        .byte   $10
        .byte   $F7
        .byte   $20
        .byte   $03
        .byte   $E4
        .byte   $18
        .byte   $60
        .text   ",L",$07,"0q U"
        .byte   $E6
        .byte   $B0
        .byte   $4C
        .byte   $A9
        .byte   $01
        .byte   $8D
        .byte   $B1
        .byte   $07
        .byte   $A2
        .byte   $08
        .byte   $8E
        .byte   $B5
        .byte   $07
LE700   .byte   $38
        .byte   $6E
        .byte   $CC
        .byte   $07
        .byte   $20
        .byte   $91
        .byte   $E6
        .byte   $B0
        .byte   $39
        .byte   $70
        .byte   $04
        .byte   $10
        .byte   $0F
        .byte   $30
        .byte   $33
        .byte   $18
        .byte   $66
        .byte   $A7
        .byte   $EE
        .byte   $B1
        .byte   $07
        .byte   $CE
        .byte   $B5
        .byte   $07
        .byte   $D0
        .byte   $EA
        .byte   $F0
        .byte   $08
        .byte   $38
        .byte   $66
        .byte   $A7
        .byte   $CE
        .byte   $B5
        .byte   $07
        .byte   $D0
        .byte   $E0
        .byte   $20
        .byte   $91
        .byte   $E6
        .byte   $B0
        .byte   $19
        .byte   $70
        .byte   $04
        .byte   $10
        .byte   $0B
        .byte   $30
        .byte   $13
        .byte   $AD
        .byte   $B1
        .byte   $07
        .byte   $29
        .byte   $01
        .byte   $D0
        .byte   $0C
        .byte   $F0
        .byte   $07
        .byte   $AD
        .byte   $B1
        .byte   $07
        .byte   $29
        .byte   $01
        .byte   $F0
        .byte   $03
        .byte   $18
        .byte   $90
        .byte   $01
        .byte   $38
        .byte   $78
        .byte   $08
        .byte   $18
        .byte   $6E
        .byte   $CC
        .byte   $07
        .byte   $28
        .byte   $60
        .byte   $BA
        .byte   $8E
        .byte   $BE
        .byte   $07
        .byte   $A5
        .byte   $93
        .byte   $F0
        .byte   $03
        .byte   $38
        .byte   $66
        .byte   $93
        .byte   $20
        .byte   $8D
        .byte   $E3
        .byte   $20
        .byte   $64
        .byte   $E3
        .byte   $AD
        .byte   $C0
        .byte   $07
        .byte   $85
        .byte   $B6
        .byte   $AD
        .byte   $C1
        .byte   $07
        .byte   $85
        .byte   $B7
        .byte   $AD
        .byte   $C2
        .byte   $07
        .byte   $8D
        .byte   $F5
        .byte   $03
        .byte   $AD
        .byte   $C3
        .byte   $07
        .byte   $8D
        .byte   $F6
        .byte   $03
        .byte   $20
        .byte   $1D
        .byte   $E9
        .byte   $A0
        .byte   $00
        .byte   $8C
        .byte   $B6
        .byte   $07
        .byte   $8C
        .byte   $B7
        .byte   $07
        .byte   $84
        .byte   $F5
        .byte   $84
        .byte   $B1
        .byte   $84
        .byte   $F8
        .byte   $A9
        .byte   $B6
        .byte   $8D
        .byte   $DF
        .byte   $07
        .byte   $2C
        .byte   $B0
        .byte   $07
        .byte   $10
        .byte   $13
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $B0
        .byte   $0B
        .byte   $A5
        .byte   $A7
        .byte   $85
        .byte   $F8
        .byte   $45
        .byte   $F5
        .byte   $85
        .byte   $F5
        .byte   $4C
        .byte   $A0
        .byte   $E7
        .byte   $38
        .byte   $66
        .byte   $F8
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $B0
        .byte   $19
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $D9
        .byte   $07
        .byte   $EA
        .byte   $24
        .byte   $93
        .byte   $30
        .byte   $02
        .byte   $A5
        .byte   $A7
        .byte   $C5
        .byte   $A7
        .byte   $D0
        .byte   $09
        .byte   $91
        .byte   $B6
        .byte   $45
        .byte   $F5
        .byte   $85
        .byte   $F5
        .byte   $4C
        .byte   $DC
        .byte   $E7
        .byte   $AC
        .byte   $B6
        .byte   $07
        .byte   $C0
        .byte   $1E
        .byte   $B0
        .byte   $12
        .byte   $A5
        .byte   $B6
        .byte   $99
        .byte   $37
        .byte   $04
        .byte   $A5
        .byte   $B7
        .byte   $99
        .byte   $55
        .byte   $04
        .byte   $EE
        .byte   $B6
        .byte   $07
        .byte   $E6
        .byte   $B1
        .byte   $4C
        .byte   $DC
        .byte   $E7
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $B6
        .byte   $07
        .byte   $E6
        .byte   $B6
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $B7
        .byte   $EE
        .byte   $F5
        .byte   $03
        .byte   $D0
        .byte   $B9
        .byte   $EE
        .byte   $F6
        .byte   $03
        .byte   $D0
        .byte   $B4
        .byte   $AD
        .byte   $B6
        .byte   $07
        .byte   $8D
        .byte   $B7
        .byte   $07
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $AD
        .byte   $B7
        .byte   $07
        .byte   $D0
        .byte   $06
        .byte   $A5
        .byte   $A7
        .byte   $C5
        .byte   $F5
        .byte   $D0
        .byte   $03
LE800   .byte   $4C
        .byte   $0A
        .byte   $E8
        .byte   $A5
        .byte   $F7
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $B7
        .byte   $E8
        .byte   $A5
        .byte   $F7
        .byte   $30
        .byte   $0B
        .byte   $AD
        .byte   $B7
        .byte   $07
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $B7
        .byte   $E8
        .byte   $4C
        .byte   $C7
        .byte   $E8
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $B6
        .byte   $07
        .byte   $85
        .byte   $F5
        .byte   $AD
        .byte   $C0
        .byte   $07
        .byte   $85
        .byte   $B6
        .byte   $AD
        .byte   $C1
        .byte   $07
        .byte   $85
        .byte   $B7
        .byte   $AD
        .byte   $C2
        .byte   $07
        .byte   $8D
        .byte   $F5
        .byte   $03
        .byte   $AD
        .byte   $C3
        .byte   $07
        .byte   $8D
        .byte   $F6
        .byte   $03
        .byte   $20
        .byte   $1D
        .byte   $E9
        .byte   $2C
        .byte   $B0
        .byte   $07
        .byte   $10
        .byte   $15
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $24
        .byte   $F8
        .byte   $10
        .byte   $08
        .byte   $A5
        .byte   $A7
        .byte   $85
        .byte   $F8
        .byte   $90
        .byte   $02
        .byte   $66
        .byte   $F8
        .byte   $A5
        .byte   $F8
        .byte   $45
        .byte   $F5
        .byte   $85
        .byte   $F5
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $6E
        .byte   $C4
        .byte   $07
        .byte   $A5
        .byte   $A7
        .byte   $45
        .byte   $F5
        .byte   $85
        .byte   $F5
        .byte   $2C
        .byte   $B7
        .byte   $07
        .byte   $30
        .byte   $32
        .byte   $AC
        .byte   $B6
        .byte   $07
        .byte   $CC
        .byte   $B7
        .byte   $07
        .byte   $F0
        .byte   $2A
        .byte   $B9
        .byte   $37
        .byte   $04
        .byte   $C5
        .byte   $B6
        .byte   $D0
        .byte   $23
        .byte   $B9
        .byte   $55
        .byte   $04
        .byte   $C5
        .byte   $B7
        .byte   $D0
        .byte   $1C
        .byte   $EE
        .byte   $B6
        .byte   $07
        .byte   $AD
        .byte   $C4
        .byte   $07
        .byte   $30
        .byte   $14
        .byte   $A0
        .byte   $00
        .byte   $20
        .byte   $D9
        .byte   $07
        .byte   $EA
        .byte   $24
        .byte   $93
        .byte   $30
        .byte   $02
        .byte   $A5
        .byte   $A7
        .byte   $C5
        .byte   $A7
        .byte   $D0
        .byte   $04
        .byte   $C6
        .byte   $B1
        .byte   $91
        .byte   $B6
        .byte   $E6
        .byte   $B6
        .byte   $D0
        .byte   $02
        .byte   $E6
        .byte   $B7
        .byte   $EE
        .byte   $F5
        .byte   $03
        .byte   $D0
        .byte   $B2
        .byte   $EE
        .byte   $F6
        .byte   $03
        .byte   $D0
        .byte   $AD
        .byte   $20
        .byte   $EC
        .byte   $E6
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $90
        .byte   $A5
        .byte   $F8
        .byte   $A6
        .byte   $B1
        .byte   $F0
        .byte   $14
        .byte   $24
        .byte   $93
        .byte   $30
        .byte   $08
        .byte   $A9
        .byte   $60
        .byte   $85
        .text   $90,"8lH"
        .byte   $E8
        .byte   $A9
        .byte   $10
        .byte   $85
        .text   $90,"8lH"
        .byte   $E8
        .byte   $18
        .byte   $20
        .byte   $B0
        .byte   $E3
        .byte   $20
        .byte   $78
        .byte   $E3
        .byte   $60
        .byte   $33
        .byte   $03
        .byte   $41
        .byte   $FF
        .byte   $A0
        .byte   $03
        .byte   $B9
        .byte   $CF
        .byte   $E8
        .byte   $99
        .byte   $C0
        .byte   $07
        .byte   $88
        .byte   $10
        .byte   $F7
        .byte   $8C
        .byte   $B0
        .byte   $07
        .byte   $A5
        .byte   $93
        .byte   $48
        .byte   $C8
        .byte   $84
        .byte   $93
        .byte   $8C
        .text   "9",$05," k"
        .byte   $E7
        .byte   $68
        .byte   $85
        .byte   $93
        .byte   $4C
        .byte   $C3
        .byte   $E3
        .byte   $A5
        .byte   $B2
        .byte   $8D
        .byte   $C0
        .byte   $07
        .byte   $A5
        .byte   $B3
        .byte   $8D
        .byte   $C1
        .byte   $07
        .byte   $18
        .byte   $A5
        .byte   $9D
LE900   .byte   $E5
        .byte   $B2
        .byte   $49
        .byte   $FF
        .byte   $8D
        .byte   $C2
        .byte   $07
        .byte   $A5
        .byte   $9E
        .byte   $E5
        .byte   $B3
        .byte   $49
        .byte   $FF
        .byte   $8D
        .byte   $C3
        .byte   $07
        .byte   $18
        .byte   $6E
        .byte   $B0
        .byte   $07
        .byte   $4C
        .byte   $4B
        .byte   $E7
        .byte   $02
        .byte   $01
        .byte   $02
        .byte   $02
        .byte   $0D
        .byte   $02
        .byte   $A2
        .byte   $05
        .byte   $BD
        .byte   $17
        .byte   $E9
        .byte   $9D
        .byte   $B8
        .byte   $07
        .byte   $CA
        .byte   $10
        .byte   $F7
        .byte   $A9
        .byte   $0A
        .byte   $8D
        .byte   $C5
        .byte   $07
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $F6
        .byte   $50
        .byte   $F4
        .text   "NE",$07,"P"
        .byte   $F4
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $BA
        .byte   $85
        .byte   $BB
        .byte   $A0
        .byte   $10
        .byte   $A2
        .byte   $00
        .byte   $A9
        .byte   $10
        .byte   $24
        .byte   $01
        .byte   $F0
        .byte   $FC
        .byte   $24
        .byte   $01
        .byte   $D0
        .byte   $FC
        .byte   $E8
        .byte   $F0
        .byte   $E9
        .byte   $24
        .byte   $01
        .byte   $F0
        .byte   $F9
        .byte   $E8
        .byte   $F0
        .byte   $E2
        .byte   $24
        .byte   $01
        .byte   $D0
        .byte   $F9
        .byte   $8A
        .byte   $18
        .byte   $65
        .byte   $BA
        .byte   $85
        .byte   $BA
        .byte   $A9
        .byte   $00
        .byte   $65
        .byte   $BB
        .byte   $85
        .byte   $BB
        .byte   $88
        .byte   $D0
        .byte   $D7
        .byte   $46
        .byte   $BB
        .byte   $66
        .byte   $BA
        .byte   $46
        .byte   $BB
        .byte   $66
        .byte   $BA
        .byte   $A5
        .byte   $BA
        .byte   $8D
        .byte   $B8
        .byte   $07
        .byte   $0A
        .byte   $8D
        .byte   $BA
        .byte   $07
        .byte   $8D
        .byte   $BC
        .byte   $07
        .byte   $A5
        .byte   $BB
        .byte   $8D
        .byte   $B9
        .byte   $07
        .byte   $2A
        .byte   $8D
        .byte   $BB
        .byte   $07
        .byte   $8D
        .byte   $BD
        .byte   $07
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $FB
        .byte   $70
        .byte   $F9
        .byte   $10
        .byte   $F7
        .byte   $20
        .byte   $FD
        .byte   $E5
        .byte   $B0
        .byte   $F2
        .byte   $70
        .byte   $F0
        .byte   $30
        .byte   $EE
        .byte   $18
        .byte   $6E
        .byte   $CC
        .byte   $07
        .byte   $20
        .byte   $03
        .byte   $E4
        .byte   $A9
        .byte   $03
        .byte   $8D
        .byte   $C6
        .byte   $07
        .byte   $20
        .byte   $F6
        .byte   $E6
        .byte   $90
        .byte   $03
        .text   "NF",$07," "
        .byte   $EC
        .byte   $E6
        .byte   $90
        .byte   $08
        .text   "NF",$07,"P"
        .byte   $03
        .byte   $4C
        .byte   $1D
        .byte   $E9
        .byte   $A5
        .byte   $A7
        .byte   $29
        .byte   $0F
        .byte   $C9
        .byte   $01
        .byte   $D0
        .byte   $EB
        .byte   $A5
        .byte   $A7
        .byte   $29
        .byte   $80
        .byte   $85
        .byte   $F7
        .byte   $60
        .byte   $20
        .byte   $D3
        .byte   $E8
        .byte   $B0
        .byte   $4D
        .byte   $A5
        .byte   $F8
        .byte   $C9
        .byte   $05
        .byte   $F0
        .byte   $43
        .byte   $C9
        .byte   $01
        .byte   $F0
        .byte   $08
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $04
        .byte   $C9
        .byte   $04
        .byte   $D0
        .byte   $E9
        .byte   $AA
        .byte   $24
        .byte   $9A
        .byte   $10
        .byte   $2F
        .byte   $20
        .byte   $D8
        .byte   $FB
        .text   $0D,"found "
        .byte   $00
        .byte   $A0
        .byte   $04
        .byte   $B1
        .byte   $B6
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $C8
        .byte   $C0
        .byte   $15
        .byte   $D0
        .byte   $F6
        .byte   $A2
LEA00   .byte   $FF
        .byte   $20
        .byte   $EA
        .byte   $E2
        .byte   $20
        .byte   $EA
        .byte   $E2
        .byte   $CA
        .byte   $F0
        .byte   $0D
        .byte   $A9
        .byte   $7F
        .byte   $20
        .byte   $70
        .byte   $DB
        .byte   $C9
        .byte   $7F
        .byte   $F0
        .byte   $0B
        .byte   $C9
        .byte   $DF
        .byte   $D0
        .byte   $EA
        .byte   $18
        .byte   $A5
        .byte   $F8
        .byte   $60
        .byte   $EA
        .byte   $EA
        .byte   $EA
        .byte   $A9
        .byte   $00
        .byte   $60
        .byte   $20
        .byte   $CC
        .byte   $E9
        .byte   $B0
        .byte   $2D
        .byte   $C9
        .byte   $05
        .byte   $F0
        .byte   $2B
        .byte   $A0
        .byte   $FF
        .byte   $C8
        .byte   $C4
        .byte   $AB
        .byte   $F0
        .byte   $26
        .byte   $A9
        .byte   $AF
        .byte   $8D
        .byte   $DF
        .text   $07," Y",$07,"Y7"
        .byte   $03
        .byte   $F0
        .byte   $EE
        .byte   $46
        .byte   $F8
        .byte   $90
        .byte   $DF
        .byte   $A0
        .byte   $FF
        .byte   $8C
        .byte   $C3
        .byte   $07
        .byte   $88
        .byte   $8C
        .byte   $C2
        .byte   $07
        .byte   $A0
        .byte   $01
        .byte   $20
        .byte   $D5
        .byte   $E8
        .byte   $4C
        .byte   $21
        .byte   $EA
        .byte   $A9
        .byte   $00
        .byte   $38
        .byte   $60
        .byte   $18
        .byte   $A5
        .byte   $F8
        .byte   $60
        .byte   $AD
        .byte   $D4
        .byte   $07
        .byte   $29
        .byte   $10
        .byte   $F0
        .byte   $32
        .byte   $AD
        .byte   $10
        .byte   $FD
        .byte   $29
        .byte   $02
        .byte   $F0
        .byte   $2B
        .byte   $A2
        .byte   $00
        .byte   $2C
        .byte   $D0
        .byte   $07
        .byte   $10
        .byte   $09
        .byte   $AD
        .byte   $CF
        .byte   $07
        .byte   $8E
        .byte   $D0
        .byte   $07
        .byte   $4C
        .byte   $89
        .byte   $EA
        .byte   $2C
        .byte   $CE
        .byte   $07
        .byte   $10
        .byte   $16
        .text   ",V",$07,"0"
        .byte   $11
        .byte   $AD
        .byte   $CD
        .byte   $07
        .byte   $8E
        .byte   $CE
        .byte   $07
        .byte   $8D
        .byte   $00
        .byte   $FD
        .byte   $AD
        .byte   $D4
        .byte   $07
        .byte   $29
        .byte   $EF
        .byte   $8D
        .byte   $D4
        .byte   $07
        .byte   $60
        .byte   $AD
        .byte   $D4
        .byte   $07
        .byte   $29
        .byte   $08
        .byte   $F0
        .byte   $54
        .byte   $AD
        .byte   $D4
        .byte   $07
        .byte   $29
        .byte   $F7
        .byte   $8D
        .byte   $D4
        .byte   $07
        .byte   $AD
        .byte   $00
        .byte   $FD
        .byte   $F0
        .byte   $19
        .byte   $8D
        .byte   $D5
        .byte   $07
        .byte   $C5
        .byte   $FC
        .byte   $D0
        .byte   $07
        .byte   $A9
        .byte   $00
        .byte   $8D
        .byte   $D6
        .byte   $07
        .byte   $F0
        .byte   $39
        .byte   $C5
        .byte   $FD
        .byte   $D0
        .byte   $07
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .text   "V",$07,"P."
        .byte   $AD
        .text   "S",$07,"I?"
        .byte   $F0
        .text   "'I8P"
        .byte   $0F
        .byte   $A5
        .byte   $FD
        .byte   $F0
        .byte   $0B
        .byte   $8D
        .byte   $CF
        .byte   $07
        .byte   $A9
        .byte   $FF
        .byte   $8D
        .byte   $D0
        .byte   $07
        .byte   $8D
        .byte   $D7
        .byte   $07
        .byte   $AE
        .byte   $D1
        .byte   $07
        .byte   $E8
        .byte   $8A
        .byte   $29
        .byte   $3F
        .byte   $8D
        .byte   $D1
        .byte   $07
        .byte   $AA
        .byte   $AD
        .byte   $D5
        .byte   $07
        .byte   $9D
        .byte   $F7
        .byte   $03
        .byte   $EE
        .byte   $D3
        .byte   $07
        .byte   $60
        .byte   $AD
        .byte   $D3
        .byte   $07
        .byte   $F0
        .byte   $34
        .byte   $08
        .byte   $78
        .byte   $AE
        .byte   $D2
        .byte   $07
        .byte   $E8
        .byte   $8A
        .byte   $29
        .byte   $3F
        .byte   $8D
LEB00   .byte   $D2
        .byte   $07
        .byte   $28
        .byte   $AA
        .byte   $BD
        .byte   $F7
        .byte   $03
        .text   "hNS",$07
        .byte   $AD
        .byte   $D3
        .byte   $07
        .byte   $C9
        .byte   $08
        .byte   $D0
        .byte   $19
        .byte   $2C
        .byte   $D7
        .byte   $07
        .byte   $10
        .byte   $14
        .byte   $A5
        .byte   $FC
        .byte   $F0
        .byte   $10
        .byte   $8D
        .byte   $CF
        .byte   $07
        .byte   $38
        .byte   $6E
        .text   "P",$07,"nW",$07,",X",$07
        .byte   $10
        .byte   $0B
        .byte   $48
        .byte   $AD
        .text   "T",$07,")oi@"
        .byte   $85
        .byte   $90
        .byte   $68
        .byte   $18
        .byte   $60
        .text   ",N",$07,"0"
        .byte   $FB
        .byte   $8D
        .byte   $CD
        .byte   $07
        .byte   $38
        .byte   $6E
        .text   "N",$07,"l*"
        .byte   $EB
        .byte   $A9
        .byte   $00
        .byte   $A2
        .byte   $0B
        .byte   $9D
        .byte   $CD
        .byte   $07
        .byte   $CA
        .byte   $10
        .byte   $FA
        .byte   $8D
        .byte   $01
        .byte   $FD
        .byte   $85
        .byte   $FC
        .byte   $85
        .byte   $FD
        .byte   $60
        .text   $0D,"i/o error "
        .byte   $A3
        .text   $0D,"searching"
        .byte   $A0
        .byte   $46
        .byte   $4F
        .byte   $52
        .byte   $A0
        .text   $0D,"press play on tapEpress record & play on tapE",$0D,"loadin"
        .text   "G",$0D,"saving"
        .byte   $A0
        .text   $0D,"verifyinG",$0D,"found"
        .byte   $A0
        .byte   $0D
        .byte   $4F
        .byte   $4B
        .byte   $8D
        .byte   $24
        .byte   $9A
        .byte   $10
        .byte   $0D
        .byte   $B9
        .byte   $58
        .byte   $EB
        .byte   $08
        .byte   $29
        .byte   $7F
        .byte   $20
        .byte   $D2
        .byte   $FF
        .byte   $C8
        .byte   $28
        .byte   $10
        .byte   $F3
        .byte   $18
        .byte   $60
        .byte   $A5
        .byte   $98
        .byte   $D0
        .byte   $1A
        .byte   $A5
        .byte   $EF
        .byte   $0D
        .byte   $5D
        .byte   $05
        .byte   $F0
        .byte   $3E
        .byte   $78
        .byte   $4C
        .byte   $C1
        .byte   $D8
        .byte   $A5
        .byte   $98
        .byte   $D0
        .byte   $0B
        .byte   $A5
        .byte   $CA
        .byte   $85
        .byte   $C5
        .byte   $A5
        .byte   $CD
        .byte   $85
        .byte   $C4
        .byte   $4C
        .byte   $65
        .byte   $D9
        .byte   $C9
        .byte   $03
        .text   "P",$1F,$05,"G"
        .byte   $85
        .byte   $C7
        .byte   $AD
LEC00   .byte   $E8
        .byte   $07
        .byte   $85
        .byte   $C3
        .byte   $4C
        .byte   $65
        .byte   $D9
        .byte   $20
        .byte   $BA
        .byte   $FB
        .byte   $C9
        .byte   $01
        .byte   $D0
        .byte   $06
        .byte   $20
        .byte   $24
        .byte   $EC
        .byte   $4C
        .byte   $C4
        .byte   $FB
        .byte   $20
        .byte   $F1
        .byte   $EA
        .byte   $4C
        .byte   $C4
        .byte   $FB
        .byte   $90
        .byte   $EB
        .byte   $A5
        .byte   $90
        .byte   $F0
        .byte   $6B
        .byte   $A9
        .byte   $0D
        .byte   $18
        .byte   $60
        .byte   $AC
        .byte   $39
        .byte   $05
        .byte   $C0
        .byte   $BF
        .byte   $90
        .byte   $06
        .byte   $20
        .byte   $D3
        .byte   $E8
        .byte   $90
        .byte   $F4
        .byte   $60
        .byte   $AC
        .byte   $39
        .byte   $05
        .byte   $B1
        .byte   $B6
        .byte   $48
        .byte   $C8
        .byte   $C0
        .byte   $BF
        .byte   $B0
        .byte   $09
        .byte   $B1
        .byte   $B6
        .byte   $D0
        .byte   $05
        .byte   $A9
        .byte   $40
        .byte   $20
        .byte   $1E
        .byte   $F4
        .byte   $EE
        .byte   $39
        .byte   $05
        .byte   $68
        .byte   $18
        .byte   $60
        .byte   $48
        .byte   $A5
        .byte   $99
        .byte   $C9
        .byte   $03
        .byte   $D0
        .byte   $04
        .byte   $68
        .byte   $4C
        .byte   $49
        .byte   $DC
        .byte   $90
        .byte   $04
        .byte   $68
        .byte   $4C
        .byte   $DF
        .byte   $EC
        .byte   $20
        .byte   $B7
        .byte   $FB
        .byte   $C9
        .byte   $01
        .byte   $D0
        .byte   $21
        .byte   $AC
        .byte   $39
        .byte   $05
        .byte   $C0
        .byte   $BF
        .byte   $90
        .byte   $0B
        .byte   $20
        .byte   $35
        .byte   $E5
        .byte   $B0
        .byte   $0F
        .byte   $A9
        .byte   $02
        .byte   $85
        .byte   $F8
        .byte   $A0
        .byte   $00
        .byte   $68
        .byte   $91
        .byte   $B6
        .byte   $C8
        .byte   $8C
        .text   "9",$05,$90,$0A
        .byte   $68
        .byte   $A9
        .byte   $00
        .byte   $4C
        .byte   $C4
        .byte   $FB
        .byte   $68
        .byte   $20
        .byte   $37
        .byte   $EB
        .byte   $4C
        .byte   $C1
        .byte   $FB
        .byte   $86
        .byte   $BA
        .byte   $24
        .byte   $F9
        .byte   $70
        .byte   $05
        .byte   $A6
        .byte   $BA
        .byte   $4C
        .byte   $52
        .byte   $E2
        .byte   $A5
        .byte   $F9
        .byte   $29
        .byte   $30
        .byte   $AA
        .byte   $A9
        .byte   $84
        .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $30
        .byte   $FB
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $C3
        .byte   $FE
        .byte   $9D
        .byte   $C2
        .byte   $FE
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $10
        .byte   $FB
        .byte   $BD
        .byte   $C1
        .byte   $FE
        .byte   $29
        .byte   $03
        .byte   $C9
        .byte   $03
        .byte   $D0
        .byte   $02
        .byte   $A9
        .byte   $40
        .byte   $20
        .byte   $1E
        .byte   $F4
        .byte   $BD
        .byte   $C0
        .byte   $FE
        .byte   $48
        .byte   $A9
        .byte   $40
        .byte   $9D
        .byte   $C2
        .byte   $FE
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $30
        .byte   $FB
        .byte   $A9
        .byte   $FF
        .byte   $9D
        .byte   $C3
        .byte   $FE
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $9D
        .byte   $C2
        .byte   $FE
        .byte   $4C
        .byte   $D4
        .byte   $ED
        .byte   $EA
        .byte   $24
        .byte   $F9
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $1D
        .byte   $E2
        .byte   $48
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A9
        .byte   $83
        .byte   $86
        .byte   $BA
        .byte   $48
        .byte   $A5
        .byte   $F9
        .byte   $29
        .byte   $30
        .byte   $AA
        .byte   $68
        .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $30
        .byte   $FB
        .byte   $AD
        .byte   $E8
        .byte   $05
LED00   .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $C2
        .byte   $FE
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $10
        .byte   $FB
        .byte   $BD
        .byte   $C1
        .byte   $FE
        .byte   $29
        .byte   $03
        .byte   $20
        .byte   $1E
        .byte   $F4
        .byte   $4C
        .byte   $DB
        .byte   $ED
        .byte   $20
        .byte   $E8
        .byte   $EE
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $79
        .byte   $F2
        .byte   $20
        .byte   $F8
        .byte   $EE
        .byte   $F0
        .byte   $11
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $0D
        .byte   $B0
        .byte   $0F
        .byte   $C9
        .byte   $02
        .text   "P( %"
        .byte   $EB
        .byte   $B0
        .byte   $05
        .byte   $A5
        .byte   $AE
        .byte   $85
        .byte   $98
        .byte   $18
        .byte   $60
        .byte   $AA
        .byte   $20
        .byte   $FA
        .byte   $ED
        .text   "$",$90,"0",$12
        .byte   $A5
        .byte   $AD
        .byte   $10
        .byte   $06
        .byte   $20
        .byte   $13
        .byte   $EE
        .byte   $4C
        .byte   $4F
        .byte   $ED
        .byte   $20
        .byte   $1A
        .byte   $EE
        .byte   $8A
        .byte   $24
        .byte   $90
        .byte   $10
        .byte   $E2
        .byte   $4C
        .byte   $7F
        .byte   $F2
        .byte   $A6
        .byte   $AD
        .byte   $E0
        .byte   $60
        .byte   $F0
        .byte   $D9
        .byte   $4C
        .byte   $82
        .byte   $F2
        .byte   $20
        .byte   $E8
        .byte   $EE
        .byte   $F0
        .byte   $03
        .byte   $4C
        .byte   $79
        .byte   $F2
        .byte   $20
        .byte   $F8
        .byte   $EE
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $85
        .byte   $F2
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $0D
        .byte   $B0
        .byte   $0F
        .byte   $C9
        .byte   $02
        .text   "P' %"
        .byte   $EB
        .byte   $B0
        .byte   $05
        .byte   $A5
        .byte   $AE
        .byte   $85
        .byte   $99
        .byte   $18
        .byte   $60
        .byte   $AA
        .byte   $20
        .byte   $2C
        .byte   $EE
        .byte   $24
        .byte   $90
        .byte   $30
        .byte   $11
        .byte   $A5
        .byte   $AD
        .byte   $10
        .byte   $05
        .byte   $20
        .byte   $45
        .byte   $EE
        .byte   $D0
        .byte   $03
        .byte   $20
        .byte   $4D
        .byte   $EE
        .byte   $8A
        .byte   $24
        .byte   $90
        .byte   $10
        .byte   $E3
        .byte   $4C
        .byte   $7F
        .byte   $F2
        .byte   $A6
        .byte   $AD
        .byte   $E0
        .byte   $60
        .byte   $F0
        .text   "FPXh"
        .byte   $86
        .byte   $BA
        .byte   $A2
        .byte   $30
        .byte   $A5
        .byte   $AE
        .byte   $C9
        .byte   $08
        .byte   $F0
        .byte   $06
        .byte   $C9
        .byte   $09
        .byte   $D0
        .byte   $17
        .byte   $A2
        .byte   $00
        .byte   $A9
        .byte   $55
        .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $5D
        .byte   $C0
        .byte   $FE
        .byte   $D0
        .byte   $0B
        .byte   $BD
        .byte   $C1
        .byte   $FE
        .byte   $29
        .byte   $02
        .byte   $D0
        .byte   $04
        .byte   $86
        .byte   $F9
        .byte   $18
        .byte   $24
        .byte   $38
        .byte   $A6
        .byte   $BA
        .byte   $68
        .byte   $60
        .byte   $BD
        .byte   $C2
        .byte   $FE
        .byte   $10
        .byte   $FB
        .byte   $30
        .byte   $05
        .byte   $A9
        .byte   $00
        .byte   $9D
        .byte   $C0
        .byte   $FE
        .byte   $A9
        .byte   $40
        .byte   $9D
        .byte   $C2
        .byte   $FE
        .byte   $A6
        .byte   $BA
        .byte   $68
        .byte   $18
        .byte   $60
        .byte   $8D
        .byte   $F2
        .byte   $FE
        .byte   $8D
        .byte   $C5
        .byte   $FE
        .byte   $8D
        .byte   $C2
        .byte   $FE
        .byte   $CA
        .byte   $8E
        .byte   $C3
        .byte   $FE
        .byte   $4C
        .byte   $EA
        .byte   $CF
        .byte   $20
        .byte   $A9
        .byte   $ED
        .byte   $90
        .byte   $03
        .byte   $4C
LEE00   .byte   $53
        .byte   $E1
        .byte   $48
        .byte   $A9
        .byte   $40
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A5
        .byte   $F9
        .byte   $09
        .byte   $40
        .byte   $85
        .byte   $F9
        .byte   $A9
        .byte   $81
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $24
        .byte   $F9
        .byte   $70
        .byte   $35
        .byte   $4C
        .byte   $0C
        .byte   $E2
        .byte   $24
        .byte   $F9
        .byte   $70
        .byte   $03
        .byte   $4C
        .byte   $03
        .byte   $E2
        .byte   $48
        .byte   $EA
        .byte   $EA
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A9
        .byte   $82
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $20
        .byte   $A9
        .byte   $ED
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $56
        .byte   $E1
        .byte   $48
        .byte   $A9
        .byte   $20
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A5
        .byte   $F9
        .byte   $09
        .byte   $80
        .byte   $85
        .byte   $F9
        .byte   $A9
        .byte   $81
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $24
        .byte   $F9
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $FC
        .byte   $E1
        .byte   $60
        .byte   $24
        .byte   $F9
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $F7
        .byte   $E1
        .byte   $48
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A9
        .byte   $82
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $66
        .byte   $BA
        .byte   $20
        .byte   $ED
        .byte   $EE
        .byte   $F0
        .byte   $02
        .byte   $18
        .byte   $60
        .byte   $20
        .byte   $F8
        .byte   $EE
        .byte   $8A
        .byte   $48
        .byte   $A5
        .byte   $AE
        .byte   $F0
        .byte   $5B
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $57
        .byte   $B0
        .byte   $40
        .byte   $C9
        .byte   $02
        .byte   $D0
        .byte   $08
        .byte   $08
        .byte   $78
        .byte   $20
        .byte   $46
        .byte   $EB
        .byte   $28
        .byte   $F0
        .byte   $49
        .byte   $A5
        .byte   $AD
        .byte   $29
        .byte   $0F
        .byte   $F0
        .byte   $43
        .byte   $AC
        .byte   $39
        .byte   $05
        .byte   $C0
        .byte   $BF
        .byte   $90
        .byte   $0E
        .byte   $20
        .byte   $35
        .byte   $E5
        .byte   $B0
        .byte   $12
        .byte   $A9
        .byte   $02
        .byte   $85
        .byte   $F8
        .byte   $A0
        .byte   $00
        .byte   $8C
        .byte   $39
        .byte   $05
        .byte   $A9
        .byte   $00
        .byte   $91
        .byte   $B6
        .byte   $20
        .byte   $35
        .byte   $E5
        .byte   $90
        .byte   $04
        .byte   $68
        .byte   $A9
        .byte   $00
        .byte   $60
        .byte   $A5
        .byte   $AD
        .byte   $C9
        .byte   $62
        .byte   $D0
        .byte   $1B
        .byte   $20
        .byte   $F0
        .byte   $E5
        .byte   $4C
        .byte   $CA
        .byte   $EE
        .byte   $24
        .byte   $BA
        .byte   $10
        .byte   $0E
        .byte   $A5
        .byte   $AE
        .byte   $C9
        .byte   $08
        .byte   $90
        .byte   $08
        .byte   $A5
        .byte   $AD
        .byte   $29
        .byte   $0F
        .byte   $C9
        .byte   $0F
        .byte   $F0
        .byte   $03
        .byte   $20
        .byte   $11
        .byte   $F2
        .byte   $68
        .byte   $AA
        .byte   $C6
        .byte   $97
        .byte   $E4
        .byte   $97
        .byte   $F0
        .byte   $14
        .byte   $A4
        .byte   $97
        .byte   $B9
        .byte   $09
        .byte   $05
        .byte   $9D
        .byte   $09
        .byte   $05
        .byte   $B9
        .byte   $13
        .byte   $05
        .byte   $9D
        .byte   $13
        .byte   $05
        .byte   $B9
        .byte   $1D
        .byte   $05
        .byte   $9D
        .byte   $1D
        .byte   $05
        .byte   $18
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $90
        .byte   $8A
        .byte   $A6
        .byte   $97
        .byte   $CA
        .byte   $30
        .byte   $15
        .byte   $DD
        .byte   $09
        .byte   $05
        .byte   $D0
        .byte   $F8
        .byte   $60
        .byte   $BD
        .byte   $09
        .byte   $05
        .byte   $85
        .byte   $AC
        .byte   $BD
        .byte   $1D
        .byte   $05
LEF00   .byte   $85
        .byte   $AD
        .byte   $BD
        .byte   $13
        .byte   $05
        .byte   $85
        .byte   $AE
        .byte   $60
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $97
        .byte   $A2
        .byte   $03
        .byte   $E4
        .byte   $99
        .byte   $B0
        .byte   $03
        .byte   $20
        .byte   $23
        .byte   $EF
        .byte   $E4
        .byte   $98
        .byte   $B0
        .byte   $03
        .byte   $20
        .byte   $3B
        .byte   $EF
        .byte   $86
        .byte   $99
        .byte   $A9
        .byte   $00
        .byte   $85
        .byte   $98
        .byte   $60
        .byte   $24
        .byte   $F9
        .byte   $30
        .byte   $03
        .byte   $4C
        .byte   $3D
        .byte   $E2
        .byte   $48
        .byte   $A9
        .byte   $3F
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A5
        .byte   $F9
        .byte   $29
        .byte   $7F
        .byte   $85
        .byte   $F9
        .byte   $A9
        .byte   $81
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $24
        .byte   $F9
        .byte   $70
        .byte   $03
        .byte   $4C
        .byte   $2F
        .byte   $E2
        .byte   $48
        .byte   $A9
        .byte   $5F
        .byte   $8D
        .byte   $E8
        .byte   $05
        .byte   $A5
        .byte   $F9
        .byte   $29
        .byte   $BF
        .byte   $85
        .byte   $F9
        .byte   $A9
        .byte   $81
        .byte   $4C
        .byte   $EC
        .byte   $EC
        .byte   $A6
        .byte   $AC
        .byte   $20
        .byte   $E8
        .byte   $EE
        .byte   $D0
        .byte   $03
        .byte   $4C
        .byte   $76
        .byte   $F2
        .byte   $A6
        .byte   $97
        .byte   $E0
        .byte   $0A
        .byte   $90
        .byte   $03
        .byte   $4C
        .byte   $73
        .byte   $F2
        .byte   $E6
        .byte   $97
        .byte   $A5
        .byte   $AC
        .byte   $9D
        .byte   $09
        .byte   $05
        .byte   $A5
        .byte   $AD
        .byte   $09
        .byte   $60
        .byte   $85
        .byte   $AD
        .byte   $9D
        .byte   $1D
        .byte   $05
        .byte   $A5
        .byte   $AE
        .byte   $9D
        .byte   $13
        .byte   $05
        .byte   $F0
        .byte   $09
        .byte   $C9
        .byte   $03
        .byte   $F0
        .byte   $05
