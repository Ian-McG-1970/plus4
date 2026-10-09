
* = $1001

SCR_ADR     = 61*1024
SCR_COL_ADR = 60*1024
CHAR_SET_ADR = 58*1024
BB_SCN = SCR_ADR +1024

SCN = 2
SCN_LO = SCN
SCN_HI = SCN_LO +1
MEM_FROM = SCN +2
MEM_TO = MEM_FROM +2
MEM_SIZE = MEM_TO +2
MEM_SIZE_LO = MEM_SIZE
MEM_SIZE_HI = MEM_SIZE +1

REGA = MEM_SIZE +2
REGX = REGA +1
REGY = REGX +1
PLAYER_H = REGY +1
PLAYER_V = PLAYER_H +1

SPR_CNT = PLAYER_V +1

SN_V0H0LO = SPR_CNT +1
SN_V0H0HI = SN_V0H0LO +1
SN_V1H0LO = SN_V0H0HI +1
SN_V1H0HI = SN_V1H0LO +1
SN_V2H0LO = SN_V1H0HI +1
SN_V2H0HI = SN_V2H0LO +1

SN_V3H0LO = SN_V2H0HI +1 ; 24
SN_V3H0HI = SN_V3H0LO +1 ; 24

BB_V0H0LO = SN_V3H0HI +1 ; 24
BB_V0H0HI = BB_V0H0LO +1
BB_V1H0LO = BB_V0H0HI +1
BB_V1H0HI = BB_V1H0LO +1
BB_V2H0LO = BB_V1H0HI +1
BB_V2H0HI = BB_V2H0LO +1

BB_V3H0LO = BB_V2H0HI +1 ; 24
BB_V3H0HI = BB_V3H0LO +1 ; 24

VPIX = BB_V3H0HI +1 ; 24
HPIX = VPIX +1

TED_SCR_BDR_FF19 = $FF19
TED_SCR_COL0_FF15 = $FF15
TED_SCR_COL1_FF16 = $FF16
TED_SCR_COL2_FF17 = $FF17

TED_RASTER_LINE_FF08 = $FF0B
TED_INT_FFFE = $FFFE
TED_SCR_ADR_FF14 = $FF14
TED_CHARSET_ADR_FF13 = $FF13
TED_CHARSET_ROM_FF12 = $FF12

INT_RASTER_POS = 206-6

!ZONE CLR_CHR
!MACRO CLR_CHR R1 {
  STA R1+0
  STA R1+1
  STA R1+2
  STA R1+3
  STA R1+4
  STA R1+5
  STA R1+6
  STA R1+7
}

!ZONE DRW_CHR
!MACRO DRW_CHR R1 {
    LDA TED_CHAR_TAB_LO,X
    STA SCN_LO 
    LDA TED_CHAR_TAB_HI,X
    STA SCN_HI
    STY REGY
    LDY #0
    LDA (SCN),Y
    STA R1+0
    INY
    LDA (SCN),Y
    STA R1+1
    INY
    LDA (SCN),Y
    STA R1+2
    INY
    LDA (SCN),Y
    STA R1+3
    INY
    LDA (SCN),Y
    STA R1+4
    INY
    LDA (SCN),Y
    STA R1+5
    INY
    LDA (SCN),Y
    STA R1+6
    INY
    LDA (SCN),Y
    STA R1+7
    LDY REGY
}

!ZONE DRW_SPR
!MACRO DRW_SPR R1 {
 LDY HPIX

 LDA SPR_AND_TAB_HI,Y 
 STA .SPR_AND_00 +2
 STA .SPR_AND_01 +2
 STA .SPR_AND_02 +2
 STA .SPR_AND_03 +2
 STA .SPR_AND_04 +2
 STA .SPR_AND_05 +2
 STA .SPR_AND_06 +2
 STA .SPR_AND_07 +2
 STA .SPR_AND_08 +2
 STA .SPR_AND_09 +2
 STA .SPR_AND_10 +2
 STA .SPR_AND_11 +2
 STA .SPR_AND_12 +2
 STA .SPR_AND_13 +2
 STA .SPR_AND_14 +2
 STA .SPR_AND_15 +2
 STA .SPR_AND_16 +2
 STA .SPR_AND_17 +2
 STA .SPR_AND_18 +2
 STA .SPR_AND_19 +2
 STA .SPR_AND_20 +2

 LDA SPR_ORA_TAB_HI,Y 
 STA .SPR_ORA_00 +2
 STA .SPR_ORA_01 +2
 STA .SPR_ORA_02 +2
 STA .SPR_ORA_03 +2
 STA .SPR_ORA_04 +2
 STA .SPR_ORA_05 +2
 STA .SPR_ORA_06 +2
 STA .SPR_ORA_07 +2
 STA .SPR_ORA_08 +2
 STA .SPR_ORA_09 +2
 STA .SPR_ORA_10 +2
 STA .SPR_ORA_11 +2
 STA .SPR_ORA_12 +2
 STA .SPR_ORA_13 +2
 STA .SPR_ORA_14 +2
 STA .SPR_ORA_15 +2
 STA .SPR_ORA_16 +2
 STA .SPR_ORA_17 +2
 STA .SPR_ORA_18 +2
 STA .SPR_ORA_19 +2
 STA .SPR_ORA_20 +2

 LDX SPR_AND_TAB_LO,Y
 STX .SPR_AND_00 +1
 INX
 STX .SPR_AND_01 +1
 INX
 STX .SPR_AND_02 +1
 INX
 STX .SPR_AND_03 +1
 INX
 STX .SPR_AND_04 +1
 INX
 STX .SPR_AND_05 +1
 INX
 STX .SPR_AND_06 +1
 INX
 STX .SPR_AND_07 +1
 INX
 STX .SPR_AND_08 +1
 INX
 STX .SPR_AND_09 +1
 INX
 STX .SPR_AND_10 +1
 INX
 STX .SPR_AND_11 +1
 INX
 STX .SPR_AND_12 +1
 INX
 STX .SPR_AND_13 +1
 INX
 STX .SPR_AND_14 +1
 INX
 STX .SPR_AND_15 +1
 INX
 STX .SPR_AND_16 +1
 INX
 STX .SPR_AND_17 +1
 INX
 STX .SPR_AND_18 +1
 INX
 STX .SPR_AND_19 +1
 INX
 STX .SPR_AND_20 +1

 LDX SPR_ORA_TAB_LO,Y
 STX .SPR_ORA_00 +1
 INX
 STX .SPR_ORA_01 +1
 INX
 STX .SPR_ORA_02 +1
 INX
 STX .SPR_ORA_03 +1
 INX
 STX .SPR_ORA_04 +1
 INX
 STX .SPR_ORA_05 +1
 INX
 STX .SPR_ORA_06 +1
 INX
 STX .SPR_ORA_07 +1
 INX
 STX .SPR_ORA_08 +1
 INX
 STX .SPR_ORA_09 +1
 INX
 STX .SPR_ORA_10 +1
 INX
 STX .SPR_ORA_11 +1
 INX
 STX .SPR_ORA_12 +1
 INX
 STX .SPR_ORA_13 +1
 INX
 STX .SPR_ORA_14 +1
 INX
 STX .SPR_ORA_15 +1
 INX
 STX .SPR_ORA_16 +1
 INX
 STX .SPR_ORA_17 +1
 INX
 STX .SPR_ORA_18 +1
 INX
 STX .SPR_ORA_19 +1
 INX
 STX .SPR_ORA_20 +1

 LDX #42
 LDY VPIX
; SEC ; not needed?

.LOOP
            LDA R1+00,Y ; Y IS SET BETWEEN 0 AND 7 AND sub 24 each loop ?
.SPR_AND_00 AND $ABCD,X
.SPR_ORA_00 ORA $ABCD,X
            STA R1+00,Y

            LDA R1+01,Y
.SPR_AND_01 AND $ABCD,X
.SPR_ORA_01 ORA $ABCD,X
            STA R1+01,Y

            LDA R1+02,Y
.SPR_AND_02 AND $ABCD,X
.SPR_ORA_02 ORA $ABCD,X
            STA R1+02,Y

            LDA R1+03,Y
.SPR_AND_03 AND $ABCD,X
.SPR_ORA_03 ORA $ABCD,X
            STA R1+03,Y

            LDA R1+04,Y
.SPR_AND_04 AND $ABCD,X
.SPR_ORA_04 ORA $ABCD,X
            STA R1+04,Y

            LDA R1+05,Y
.SPR_AND_05 AND $ABCD,X
.SPR_ORA_05 ORA $ABCD,X
            STA R1+05,Y

            LDA R1+06,Y
.SPR_AND_06 AND $ABCD,X
.SPR_ORA_06 ORA $ABCD,X
            STA R1+06,Y

            LDA R1+07,Y
.SPR_AND_07 AND $ABCD,X
.SPR_ORA_07 ORA $ABCD,X
            STA R1+07,Y

            LDA R1+08,Y
.SPR_AND_08 AND $ABCD,X
.SPR_ORA_08 ORA $ABCD,X
            STA R1+08,Y

            LDA R1+09,Y
.SPR_AND_09 AND $ABCD,X
.SPR_ORA_09 ORA $ABCD,X
            STA R1+09,Y

            LDA R1+10,Y
.SPR_AND_10 AND $ABCD,X
.SPR_ORA_10 ORA $ABCD,X
            STA R1+10,Y

            LDA R1+11,Y
.SPR_AND_11 AND $ABCD,X
.SPR_ORA_11 ORA $ABCD,X
            STA R1+11,Y

            LDA R1+12,Y
.SPR_AND_12 AND $ABCD,X
.SPR_ORA_12 ORA $ABCD,X
            STA R1+12,Y

            LDA R1+13,Y
.SPR_AND_13 AND $ABCD,X
.SPR_ORA_13 ORA $ABCD,X
            STA R1+13,Y

            LDA R1+14,Y
.SPR_AND_14 AND $ABCD,X
.SPR_ORA_14 ORA $ABCD,X
            STA R1+14,Y

            LDA R1+15,Y
.SPR_AND_15 AND $ABCD,X
.SPR_ORA_15 ORA $ABCD,X
            STA R1+15,Y

            LDA R1+16,Y
.SPR_AND_16 AND $ABCD,X
.SPR_ORA_16 ORA $ABCD,X
            STA R1+16,Y

            LDA R1+17,Y
.SPR_AND_17 AND $ABCD,X
.SPR_ORA_17 ORA $ABCD,X
            STA R1+17,Y

            LDA R1+18,Y
.SPR_AND_18 AND $ABCD,X
.SPR_ORA_18 ORA $ABCD,X
            STA R1+18,Y

            LDA R1+19,Y
.SPR_AND_19 AND $ABCD,X
.SPR_ORA_19 ORA $ABCD,X
            STA R1+19,Y

            LDA R1+20,Y
.SPR_AND_20 AND $ABCD,X
.SPR_ORA_20 ORA $ABCD,X
            STA R1+20,Y
      
    LDA #255
    SBX #21
    BMI .EXIT

   TYA
   SBC #32 ; next screen line to the left
   TAY
   JMP .LOOP

.EXIT
}

INIT: !WORD $100B,0
      !BYTE $9E,"4","1","0","9",0,0,0   ; *** Produce one basic line ; SYS4107
  
      SEI       ; DISABLE INTERRUPTS
      STA $FF3F ; enable RAM
      
      CLV
      CLD
      LDX   #$FF   ; reset stack
      TXS

;main
;      LDX #<main  ; low byte
;      LDY #>main  ; and high byte of address
;      STX $FFFC   ; --- set up reset vector
;      STY $FFFD

      LDX #<IRQ   ; low byte
      LDY #>IRQ   ; and high byte of address
      STX TED_INT_FFFE ; --- set up nmi
      STY TED_INT_FFFE +1

      LDA #INT_RASTER_POS
      STA TED_RASTER_LINE_FF08 ; --- raster line

      LDA $FF0A
      AND #$FE
      STA $FF0A

      LDA #SCR_COL_ADR >>8 ; ((address /1024) *4) / colour addr = (ptr) / screen addr = (ptr +1024)
      STA TED_SCR_ADR_FF14
      LDA #CHAR_SET_ADR >>8
      STA TED_CHARSET_ADR_FF13

      LDA TED_CHARSET_ROM_FF12
      AND #%11111011 ; switch charset lookup from ROM to RAM
      STA TED_CHARSET_ROM_FF12

      LDA $FF07
      ORA #%10010000 ; FULL 256 CHARS + MCM
      STA $FF07

      LDA #1
      STA TED_SCR_COL0_FF15 ; Background color. Works/used in every video mode.
      LDA #2
      STA TED_SCR_COL1_FF16 ; Multicolor/Extended color #1. Works/used in multicolor and ECM modes, see $FF07 and $FF06.
      LDA #3
      STA TED_SCR_COL2_FF17 ; Multicolor/Extended color #2. Works/used in multicolor and ECM modes, see $FF07 and $FF06.
;      STA $FF18 ; Extended color #3. Works/used in ECM mode only, see $FF06.
      LDA #0
      STA TED_SCR_BDR_FF19 ; Border color. Works/used in every video mode. When the screen is turned off, (see $FF06), the whole screen is this color.

 LDA #10 ; colour 11
 LDX #<SCR_COL_ADR
 LDY #>SCR_COL_ADR
 STX MEM_TO+0
 STY MEM_TO+1
 LDX #>1000 
 LDY #<1000
 JSR MEMSET

 LDA #0;//%10011100 ; screen
 LDX #<BB_SCN
 LDY #>BB_SCN
 STX MEM_TO+0
 STY MEM_TO+1
 LDX #>1000 
 LDY #<1000
 JSR MEMSET

  JSR FILL_CHARS

  LDX #7
  LDA #0 ;  lda #0 ; %11000110
-   STA CHAR_SET_ADR,X
    DEX
    BPL -

  LDA #50
  STA PLAYER_H
  STA PLAYER_V
  
  LDA #4; 7 ; 1; 7 ; 0 ; -1
  STA SPR_CNT

      CLI
      
MLOOP JMP MLOOP
    
!ZONE IRQ
IRQ:  STA .REGA +1
      STX .REGX +1
      STY .REGY +1

      LDA $FF09 ; clear interrupt bit
      STA $FF09

; DEC BORDER
  JSR JOYSTICK1
  JSR MOVE_PLAYER ; move sprite
; INC BORDER
  
 DEC TED_SCR_BDR_FF19
 JSR CLEAR_SPRITES
 INC TED_SCR_BDR_FF19

  LDX PLAYER_V
  LDY PLAYER_H
  STX SPR_PXL_V
  STY SPR_PXL_H
 
 DEC TED_SCR_BDR_FF19
 JSR DRAW_SPRITES 
 INC TED_SCR_BDR_FF19

.REGA LDA #0
.REGX LDX #0
.REGY LDY #0

      RTI   ; Return from Interrupt

; FROM = source start address
;   TO = destination start address
; SIZE = number of bytes to move
  
;!ZONE MEMCPY
;MEMCPY
;    STY .LSB +1
;    LDY #0
;    TXA
;    BEQ .LSB
;.LOOPHI LDA (MEM_FROM),Y ; move a page at a time
;        STA (MEM_TO),Y
;        INY
;        BNE .LOOPHI
;      INC MEM_FROM+1
;      INC MEM_TO+1
;      DEX
;      BNE .LOOPHI
;.LSB    LDX #0
;        BEQ .EXIT
;.LOOPLO   LDA (MEM_FROM),Y ; move the remaining bytes
;          STA (MEM_TO),Y
;          INY
;          DEX
;          BNE .LOOPLO
;.EXIT  RTS

!ZONE MEMSET        
MEMSET       STY    .LSB_ONLY+1 ; store LSB count
             CPX    #0          ; MSB?     
             BEQ    .LSB_ONLY   ; no

             LDY    #0          ; yes so reset LSB
.MSB_LOOP  
.LSB_LOOP      STA    (MEM_TO),Y   ; clear whole MSB
               DEY 
               BNE    .LSB_LOOP

              INC    MEM_TO+1      ; inc MSB
              DEX               ; dec MSB count
              BNE    .MSB_LOOP

.LSB_ONLY    LDY    #0          ; LSB count 
             BEQ    .MS_END     ; not needed

.LAST_LSB_LOOP STA   (MEM_TO),Y
               DEY 
               BNE   .LAST_LSB_LOOP
                
              STA   (MEM_TO),Y     ; clear last Y (0)
 
.MS_END      RTS

!ZONE FILL_CHAR
FILL_CHAR LDY TED_CHAR_TAB_LO,X
          STY .SCN+1
          LDY TED_CHAR_TAB_HI,X  
          STY .SCN+2
          LDX #7
.SCN        STA $ABCD,X
            DEX
            BPL .SCN
          RTS

FILL_CHARS  LDX #0
-             TXA
              PHA
              JSR FILL_CHAR
              PLA
              TAX
              DEX
              BNE -
            RTS

!ZONE CLEAR_SPRITES
CLEAR_SPRITES
      LDX SPR_CNT
      BMI .EXIT
.LOOP   JSR CLEAR_SPRITE
        DEX
        BPL .LOOP
.EXIT RTS

;  LDY SPR_CHR_V,X
;  LDX SCN_ADR_HI,Y
;  LDA SCN_ADR_LO,Y
; sta .temp +1 ; get X into Y and add 4
; txa
; clc
; adc #4
; tay
;.temp lda #0 
;  STX SN_V0H0HI
;  STY BB_V0H0HI
;  STA SN_V0H0LO
;  STA BB_V0H0LO
;;  CLC
;  ADC #40
;  BCC +
;    CLC
;    INX
;    INY
;+ STX SN_V1H0HI
;  STY BB_V1H0HI
;  STA SN_V1H0LO
;  STA BB_V1H0LO
;  ADC #40
;  BCC +
;    CLC
;    INX
;    INY
;+ STX SN_V2H0HI
;  STY BB_V2H0HI
;  STA SN_V2H0LO
;  STA BB_V2H0LO
;  ADC #40
;  BCC +
;    INX
;    INY
;+ STX SN_V3H0HI
;  STY BB_V3H0HI
;  STA SN_V3H0LO
;  STA BB_V3H0LO
;  RTS

!ZONE CLEAR_SPRITE
CLEAR_SPRITE

  LDY SPR_CHR_V,X
  LDA SCN_ADR_HI,Y
  STA SN_V0H0HI ; screen hi
  CLC
  ADC #4
  STA BB_V0H0HI ; back buffer hi
  LDA SCN_ADR_HI+1,Y
  STA SN_V1H0HI
  ADC #4
  STA BB_V1H0HI
  LDA SCN_ADR_HI+2,Y
  STA SN_V2H0HI
  ADC #4
  STA BB_V2H0HI

  LDA SCN_ADR_HI+3,Y ; 24
  STA SN_V3H0HI ; 24
  ADC #4        ; 24
  STA BB_V3H0HI ; 24

  LDA SCN_ADR_LO,Y
  STA SN_V0H0LO
  STA BB_V0H0LO
;  CLC ; not needed due to adc above?
  ADC #40
  STA SN_V1H0LO
  STA BB_V1H0LO
  CLC
  ADC #40
  STA SN_V2H0LO
  STA BB_V2H0LO

  CLC           ; 24
  ADC #40       ; 24
  STA SN_V3H0LO ; 24
  STA BB_V3H0LO ; 24

  LDY SPR_CHR_H,X
  LDA (BB_V0H0LO),Y ; get back buffer
  STA (SN_V0H0LO),Y ; put screen
  LDA (BB_V1H0LO),Y
  STA (SN_V1H0LO),Y
  LDA (BB_V2H0LO),Y
  STA (SN_V2H0LO),Y

  LDA (BB_V3H0LO),Y ; 24
  STA (SN_V3H0LO),Y ; 24

  INY
  LDA (BB_V0H0LO),Y
  STA (SN_V0H0LO),Y
  LDA (BB_V1H0LO),Y
  STA (SN_V1H0LO),Y
  LDA (BB_V2H0LO),Y
  STA (SN_V2H0LO),Y

  LDA (BB_V3H0LO),Y ; 24
  STA (SN_V3H0LO),Y ; 24

  INY
  LDA (BB_V0H0LO),Y
  STA (SN_V0H0LO),Y
  LDA (BB_V1H0LO),Y
  STA (SN_V1H0LO),Y
  LDA (BB_V2H0LO),Y
  STA (SN_V2H0LO),Y

  LDA (BB_V3H0LO),Y ; 24
  STA (SN_V3H0LO),Y ; 24

  RTS

!ZONE DRAW_SPRITES
DRAW_SPRITES
      LAX SPR_CNT
      BMI .EXIT
.LOOP   JSR DRAW_SPRITE
        DEX
        BPL .LOOP
.EXIT RTS

; pass in v / h / sprite number to be used (0-12?) / sprite number to be drawn (0-255)
; get sprite x and y
; convert to char pos
; store in v and h char pos to be cleared
; get 9 chars from screen
; store in 9 chars for sprite
; 9 chars allocated for this sprite
; put them on screen

!ZONE DRAW_SPRITE
DRAW_SPRITE
; x=sprnum (0-12)

  STX REGX
  TXA
  ASL
  STA .JMP+1
  
  LDY SPR_PXL_V,X
  LDA V_PIXEL,Y
  STA VPIX
  
  LDA V_CHAR,Y
  STA SPR_CHR_V,X
  TAX

  LDA SCN_ADR_HI,X
  STA SN_V0H0HI
  LDA SCN_ADR_HI+1,X
  STA SN_V1H0HI
  LDA SCN_ADR_HI+2,X
  STA SN_V2H0HI
  LDA SCN_ADR_HI+3,X  ; 24
  STA SN_V3H0HI       ; 24

  LDA SCN_ADR_LO,X
  STA SN_V0H0LO
;  CLC ; not needed due to asl above?
  ADC #40
  STA SN_V1H0LO
  CLC
  ADC #40
  STA SN_V2H0LO
  CLC           ; 24
  ADC #40       ; 24
  STA SN_V3H0LO ; 24

  LDY REGX
  LDX SPR_PXL_H,Y
  LDA H_PIXEL,X
  STA HPIX
  LDA H_CHAR,X
  STA SPR_CHR_H,Y
  TAY

.JMP JMP (SPR_DRW_TAB)
  
!ZONE DRW_SPR_00
DRW_SPR_00

 DEC TED_SCR_BDR_FF19

          LAX (SN_V0H0LO),Y             ; get screen in X and A
          BNE .COPY_00                  ; if not zero it needs copied
.CLEAR_00   +CLR_CHR SPR_00_00_CHR_116  ; else it needs cleared
            BEQ .CONT_00
.COPY_00    +DRW_CHR SPR_00_00_CHR_116  ; if not zero copy char on screen to char
.CONT_00  LDA #116                      ; put char
          STA (SN_V0H0LO),Y             ; on screen

          LAX (SN_V1H0LO),Y
          BNE .COPY_10
.CLEAR_10   +CLR_CHR SPR_00_10_CHR_117
            BEQ .CONT_10
.COPY_10    +DRW_CHR SPR_00_10_CHR_117
.CONT_10  LDA #117
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_20
.CLEAR_20   +CLR_CHR SPR_00_20_CHR_118
            BEQ .CONT_20
.COPY_20    +DRW_CHR SPR_00_20_CHR_118
.CONT_20  LDA #118
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_30
.CLEAR_30   +CLR_CHR SPR_00_30_CHR_119
            BEQ .CONT_30
.COPY_30    +DRW_CHR SPR_00_30_CHR_119
.CONT_30  LDA #119
          STA (SN_V3H0LO),Y


          INY
          LAX (SN_V0H0LO),Y
          BNE .COPY_01
.CLEAR_01   +CLR_CHR SPR_00_01_CHR_120
            BEQ .CONT_01
.COPY_01    +DRW_CHR SPR_00_01_CHR_120
.CONT_01  LDA #120
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_11
.CLEAR_11   +CLR_CHR SPR_00_11_CHR_121
            BEQ .CONT_11
.COPY_11    +DRW_CHR SPR_00_11_CHR_121
.CONT_11  LDA #121
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_21
.CLEAR_21   +CLR_CHR SPR_00_21_CHR_122
            BEQ .CONT_21
.COPY_21    +DRW_CHR SPR_00_21_CHR_122
.CONT_21  LDA #122
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_31
.CLEAR_31   +CLR_CHR SPR_00_31_CHR_123
            BEQ .CONT_31
.COPY_31    +DRW_CHR SPR_00_31_CHR_123
.CONT_31  LDA #123
          STA (SN_V3H0LO),Y


          INY 
          LAX (SN_V0H0LO),Y
          BNE .COPY_02
.CLEAR_02   +CLR_CHR SPR_00_02_CHR_124
            BEQ .CONT_02
.COPY_02    +DRW_CHR SPR_00_02_CHR_124
.CONT_02  LDA #124
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_12
.CLEAR_12   +CLR_CHR SPR_00_12_CHR_125
            BEQ .CONT_12
.COPY_12    +DRW_CHR SPR_00_12_CHR_125
.CONT_12  LDA #125
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_22
.CLEAR_22   +CLR_CHR SPR_00_22_CHR_126
            BEQ .CONT_22
.COPY_22    +DRW_CHR SPR_00_22_CHR_126
.CONT_22  LDA #126
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_32
.CLEAR_32   +CLR_CHR SPR_00_32_CHR_127
            BEQ .CONT_32
.COPY_32    +DRW_CHR SPR_00_32_CHR_127
.CONT_32  LDA #127
          STA (SN_V3H0LO),Y

  +DRW_SPR SPR_00_00_CHR_116

 INC TED_SCR_BDR_FF19
  
  LAX REGX
  RTS

!ZONE DRW_SPR_01
DRW_SPR_01

 DEC TED_SCR_BDR_FF19

          LAX (SN_V0H0LO),Y             ; get screen in X and A
          BNE .COPY_00                  ; if not zero it needs copied
.CLEAR_00   +CLR_CHR SPR_01_00_CHR_104  ; else it needs cleared
            BEQ .CONT_00
.COPY_00    +DRW_CHR SPR_01_00_CHR_104  ; if not zero copy char on screen to char
.CONT_00  LDA #104                      ; put char
          STA (SN_V0H0LO),Y             ; on screen

          LAX (SN_V1H0LO),Y
          BNE .COPY_10
.CLEAR_10   +CLR_CHR SPR_01_10_CHR_105
            BEQ .CONT_10
.COPY_10    +DRW_CHR SPR_01_10_CHR_105
.CONT_10  LDA #105
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_20
.CLEAR_20   +CLR_CHR SPR_01_20_CHR_106
            BEQ .CONT_20
.COPY_20    +DRW_CHR SPR_01_20_CHR_106
.CONT_20  LDA #106
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_30
.CLEAR_30   +CLR_CHR SPR_01_30_CHR_107
            BEQ .CONT_30
.COPY_30    +DRW_CHR SPR_01_30_CHR_107
.CONT_30  LDA #107
          STA (SN_V3H0LO),Y


          INY
          LAX (SN_V0H0LO),Y
          BNE .COPY_01
.CLEAR_01   +CLR_CHR SPR_01_01_CHR_108
            BEQ .CONT_01
.COPY_01    +DRW_CHR SPR_01_01_CHR_108
.CONT_01  LDA #108
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_11
.CLEAR_11   +CLR_CHR SPR_01_11_CHR_109
            BEQ .CONT_11
.COPY_11    +DRW_CHR SPR_01_11_CHR_109
.CONT_11  LDA #109
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_21
.CLEAR_21   +CLR_CHR SPR_01_21_CHR_110
            BEQ .CONT_21
.COPY_21    +DRW_CHR SPR_01_21_CHR_110
.CONT_21  LDA #110
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_31
.CLEAR_31   +CLR_CHR SPR_01_31_CHR_111
            BEQ .CONT_31
.COPY_31    +DRW_CHR SPR_01_31_CHR_111
.CONT_31  LDA #111
          STA (SN_V3H0LO),Y


          INY 
          LAX (SN_V0H0LO),Y
          BNE .COPY_02
.CLEAR_02   +CLR_CHR SPR_01_02_CHR_112
            BEQ .CONT_02
.COPY_02    +DRW_CHR SPR_01_02_CHR_112
.CONT_02  LDA #112
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_12
.CLEAR_12   +CLR_CHR SPR_01_12_CHR_113
            BEQ .CONT_12
.COPY_12    +DRW_CHR SPR_01_12_CHR_113
.CONT_12  LDA #113
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_22
.CLEAR_22   +CLR_CHR SPR_01_22_CHR_114
            BEQ .CONT_22
.COPY_22    +DRW_CHR SPR_01_22_CHR_114
.CONT_22  LDA #114
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_32
.CLEAR_32   +CLR_CHR SPR_01_32_CHR_115
            BEQ .CONT_32
.COPY_32    +DRW_CHR SPR_01_32_CHR_115
.CONT_32  LDA #115
          STA (SN_V3H0LO),Y

  +DRW_SPR SPR_01_00_CHR_104

 INC TED_SCR_BDR_FF19
  
  LAX REGX
  RTS

!ZONE DRW_SPR_02 ; todo
DRW_SPR_02

 DEC TED_SCR_BDR_FF19

          LAX (SN_V0H0LO),Y             ; get screen in X and A
          BNE .COPY_00                  ; if not zero it needs copied
.CLEAR_00   +CLR_CHR SPR_02_00_CHR_092  ; else it needs cleared
            BEQ .CONT_00
.COPY_00    +DRW_CHR SPR_02_00_CHR_092  ; if not zero copy char on screen to char
.CONT_00  LDA #092                      ; put char
          STA (SN_V0H0LO),Y             ; on screen

          LAX (SN_V1H0LO),Y
          BNE .COPY_10
.CLEAR_10   +CLR_CHR SPR_02_10_CHR_093
            BEQ .CONT_10
.COPY_10    +DRW_CHR SPR_02_10_CHR_093
.CONT_10  LDA #093
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_20
.CLEAR_20   +CLR_CHR SPR_02_20_CHR_094
            BEQ .CONT_20
.COPY_20    +DRW_CHR SPR_02_20_CHR_094
.CONT_20  LDA #094
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_30
.CLEAR_30   +CLR_CHR SPR_02_30_CHR_095
            BEQ .CONT_30
.COPY_30    +DRW_CHR SPR_02_30_CHR_095
.CONT_30  LDA #095
          STA (SN_V3H0LO),Y


          INY
          LAX (SN_V0H0LO),Y
          BNE .COPY_01
.CLEAR_01   +CLR_CHR SPR_02_01_CHR_096
            BEQ .CONT_01
.COPY_01    +DRW_CHR SPR_02_01_CHR_096
.CONT_01  LDA #096
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_11
.CLEAR_11   +CLR_CHR SPR_02_11_CHR_097
            BEQ .CONT_11
.COPY_11    +DRW_CHR SPR_02_11_CHR_097
.CONT_11  LDA #097
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_21
.CLEAR_21   +CLR_CHR SPR_02_21_CHR_098
            BEQ .CONT_21
.COPY_21    +DRW_CHR SPR_02_21_CHR_098
.CONT_21  LDA #098
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_31
.CLEAR_31   +CLR_CHR SPR_02_31_CHR_099
            BEQ .CONT_31
.COPY_31    +DRW_CHR SPR_02_31_CHR_099
.CONT_31  LDA #099
          STA (SN_V3H0LO),Y


          INY 
          LAX (SN_V0H0LO),Y
          BNE .COPY_02
.CLEAR_02   +CLR_CHR SPR_02_02_CHR_100
            BEQ .CONT_02
.COPY_02    +DRW_CHR SPR_02_02_CHR_100
.CONT_02  LDA #100
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_12
.CLEAR_12   +CLR_CHR SPR_02_12_CHR_101
            BEQ .CONT_12
.COPY_12    +DRW_CHR SPR_02_12_CHR_101
.CONT_12  LDA #101
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_22
.CLEAR_22   +CLR_CHR SPR_02_22_CHR_102
            BEQ .CONT_22
.COPY_22    +DRW_CHR SPR_02_22_CHR_102
.CONT_22  LDA #102
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_32
.CLEAR_32   +CLR_CHR SPR_02_32_CHR_103
            BEQ .CONT_32
.COPY_32    +DRW_CHR SPR_02_32_CHR_103
.CONT_32  LDA #103
          STA (SN_V3H0LO),Y

  +DRW_SPR SPR_02_00_CHR_092

 INC TED_SCR_BDR_FF19
  
  LAX REGX
  RTS

!ZONE DRW_SPR_03 ; todo
DRW_SPR_03

 DEC TED_SCR_BDR_FF19

          LAX (SN_V0H0LO),Y             ; get screen in X and A
          BNE .COPY_00                  ; if not zero it needs copied
.CLEAR_00   +CLR_CHR SPR_01_00_CHR_104  ; else it needs cleared
            BEQ .CONT_00
.COPY_00    +DRW_CHR SPR_01_00_CHR_104  ; if not zero copy char on screen to char
.CONT_00  LDA #104                      ; put char
          STA (SN_V0H0LO),Y             ; on screen

          LAX (SN_V1H0LO),Y
          BNE .COPY_10
.CLEAR_10   +CLR_CHR SPR_01_10_CHR_105
            BEQ .CONT_10
.COPY_10    +DRW_CHR SPR_01_10_CHR_105
.CONT_10  LDA #105
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_20
.CLEAR_20   +CLR_CHR SPR_01_20_CHR_106
            BEQ .CONT_20
.COPY_20    +DRW_CHR SPR_01_20_CHR_106
.CONT_20  LDA #106
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_30
.CLEAR_30   +CLR_CHR SPR_01_30_CHR_107
            BEQ .CONT_30
.COPY_30    +DRW_CHR SPR_01_30_CHR_107
.CONT_30  LDA #107
          STA (SN_V3H0LO),Y


          INY
          LAX (SN_V0H0LO),Y
          BNE .COPY_01
.CLEAR_01   +CLR_CHR SPR_01_01_CHR_108
            BEQ .CONT_01
.COPY_01    +DRW_CHR SPR_01_01_CHR_108
.CONT_01  LDA #108
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_11
.CLEAR_11   +CLR_CHR SPR_01_11_CHR_109
            BEQ .CONT_11
.COPY_11    +DRW_CHR SPR_01_11_CHR_109
.CONT_11  LDA #109
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_21
.CLEAR_21   +CLR_CHR SPR_01_21_CHR_110
            BEQ .CONT_21
.COPY_21    +DRW_CHR SPR_01_21_CHR_110
.CONT_21  LDA #110
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_31
.CLEAR_31   +CLR_CHR SPR_01_31_CHR_111
            BEQ .CONT_31
.COPY_31    +DRW_CHR SPR_01_31_CHR_111
.CONT_31  LDA #111
          STA (SN_V3H0LO),Y


          INY 
          LAX (SN_V0H0LO),Y
          BNE .COPY_02
.CLEAR_02   +CLR_CHR SPR_01_02_CHR_112
            BEQ .CONT_02
.COPY_02    +DRW_CHR SPR_01_02_CHR_112
.CONT_02  LDA #112
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_12
.CLEAR_12   +CLR_CHR SPR_01_12_CHR_113
            BEQ .CONT_12
.COPY_12    +DRW_CHR SPR_01_12_CHR_113
.CONT_12  LDA #113
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_22
.CLEAR_22   +CLR_CHR SPR_01_22_CHR_114
            BEQ .CONT_22
.COPY_22    +DRW_CHR SPR_01_22_CHR_114
.CONT_22  LDA #114
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_32
.CLEAR_32   +CLR_CHR SPR_01_32_CHR_115
            BEQ .CONT_32
.COPY_32    +DRW_CHR SPR_01_32_CHR_115
.CONT_32  LDA #115
          STA (SN_V3H0LO),Y

  +DRW_SPR SPR_01_00_CHR_104

 INC TED_SCR_BDR_FF19
  
  LAX REGX
  RTS


!ZONE DRW_SPR_04 ; todo
DRW_SPR_04

 DEC TED_SCR_BDR_FF19

          LAX (SN_V0H0LO),Y             ; get screen in X and A
          BNE .COPY_00                  ; if not zero it needs copied
.CLEAR_00   +CLR_CHR SPR_01_00_CHR_104  ; else it needs cleared
            BEQ .CONT_00
.COPY_00    +DRW_CHR SPR_01_00_CHR_104  ; if not zero copy char on screen to char
.CONT_00  LDA #104                      ; put char
          STA (SN_V0H0LO),Y             ; on screen

          LAX (SN_V1H0LO),Y
          BNE .COPY_10
.CLEAR_10   +CLR_CHR SPR_01_10_CHR_105
            BEQ .CONT_10
.COPY_10    +DRW_CHR SPR_01_10_CHR_105
.CONT_10  LDA #105
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_20
.CLEAR_20   +CLR_CHR SPR_01_20_CHR_106
            BEQ .CONT_20
.COPY_20    +DRW_CHR SPR_01_20_CHR_106
.CONT_20  LDA #106
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_30
.CLEAR_30   +CLR_CHR SPR_01_30_CHR_107
            BEQ .CONT_30
.COPY_30    +DRW_CHR SPR_01_30_CHR_107
.CONT_30  LDA #107
          STA (SN_V3H0LO),Y


          INY
          LAX (SN_V0H0LO),Y
          BNE .COPY_01
.CLEAR_01   +CLR_CHR SPR_01_01_CHR_108
            BEQ .CONT_01
.COPY_01    +DRW_CHR SPR_01_01_CHR_108
.CONT_01  LDA #108
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_11
.CLEAR_11   +CLR_CHR SPR_01_11_CHR_109
            BEQ .CONT_11
.COPY_11    +DRW_CHR SPR_01_11_CHR_109
.CONT_11  LDA #109
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_21
.CLEAR_21   +CLR_CHR SPR_01_21_CHR_110
            BEQ .CONT_21
.COPY_21    +DRW_CHR SPR_01_21_CHR_110
.CONT_21  LDA #110
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_31
.CLEAR_31   +CLR_CHR SPR_01_31_CHR_111
            BEQ .CONT_31
.COPY_31    +DRW_CHR SPR_01_31_CHR_111
.CONT_31  LDA #111
          STA (SN_V3H0LO),Y


          INY 
          LAX (SN_V0H0LO),Y
          BNE .COPY_02
.CLEAR_02   +CLR_CHR SPR_01_02_CHR_112
            BEQ .CONT_02
.COPY_02    +DRW_CHR SPR_01_02_CHR_112
.CONT_02  LDA #112
          STA (SN_V0H0LO),Y

          LAX (SN_V1H0LO),Y
          BNE .COPY_12
.CLEAR_12   +CLR_CHR SPR_01_12_CHR_113
            BEQ .CONT_12
.COPY_12    +DRW_CHR SPR_01_12_CHR_113
.CONT_12  LDA #113
          STA (SN_V1H0LO),Y

          LAX (SN_V2H0LO),Y
          BNE .COPY_22
.CLEAR_22   +CLR_CHR SPR_01_22_CHR_114
            BEQ .CONT_22
.COPY_22    +DRW_CHR SPR_01_22_CHR_114
.CONT_22  LDA #114
          STA (SN_V2H0LO),Y

          LAX (SN_V3H0LO),Y
          BNE .COPY_32
.CLEAR_32   +CLR_CHR SPR_01_32_CHR_115
            BEQ .CONT_32
.COPY_32    +DRW_CHR SPR_01_32_CHR_115
.CONT_32  LDA #115
          STA (SN_V3H0LO),Y

  +DRW_SPR SPR_01_00_CHR_104

 INC TED_SCR_BDR_FF19
  
  LAX REGX
  RTS

JOYSTICK2 LDA #%00000100 ; ; JOYSTICKSELECT2
          JMP JOYSTICK
          
JOYSTICK1 LDA #%00000010 ; ; JOYSTICKSELECT1

!ZONE JOYSTICK
JOYSTICK  LDX #$FF
          STX $fd30
          STA $ff08
          LDA $ff08

          LDX #0 ; inx to save a byte?
          LDY #0
.UP       LSR
          BCS   .DOWN
            DEY
.DOWN     LSR
          BCS   .LEFT
            INY
.LEFT     LSR
          BCS   .RIGHT
            DEX
.RIGHT    LSR
          BCS   .FIRE
            INX
.FIRE     EOR   #1
          AND   #1
;          STA   JOYF
;          STX   JOYX
;          STY   JOYY
          LSR
          RTS

!ZONE MOVE_PLAYER
MOVE_PLAYER TXA
            BEQ   .VER
            BPL   .RIGHT
.LEFT         DEC   PLAYER_H
              JMP   .VER
.RIGHT      INC   PLAYER_H
.VER        TYA
            BEQ   .EXIT
            BPL   .DOWN
.UP           DEC   PLAYER_V
              RTS
.DOWN       INC   PLAYER_V
.EXIT       RTS

H_CHAR:
!FILL 4,00
!FILL 4,01
!FILL 4,02
!FILL 4,03
!FILL 4,04
!FILL 4,05
!FILL 4,06
!FILL 4,07
!FILL 4,08
!FILL 4,09
!FILL 4,10
!FILL 4,11
!FILL 4,12
!FILL 4,13
!FILL 4,14
!FILL 4,15
!FILL 4,16
!FILL 4,17
!FILL 4,18
!FILL 4,19
!FILL 4,20
!FILL 4,21
!FILL 4,22
!FILL 4,23
!FILL 4,24
!FILL 4,25
!FILL 4,26
!FILL 4,27
!FILL 4,28
!FILL 4,29
!FILL 4,30
!FILL 4,31
!FILL 4,32
!FILL 4,33
!FILL 4,34
!FILL 4,35
!FILL 4,36
!FILL 4,37
!FILL 4,38
!FILL 4,39

V_CHAR:
!FILL 8,00
!FILL 8,01
!FILL 8,02
!FILL 8,03
!FILL 8,04
!FILL 8,05
!FILL 8,06
!FILL 8,07
!FILL 8,08
!FILL 8,09
!FILL 8,10
!FILL 8,11
!FILL 8,12
!FILL 8,13
!FILL 8,14
!FILL 8,15
!FILL 8,16
!FILL 8,17
!FILL 8,18
!FILL 8,19
!FILL 8,20
!FILL 8,21
!FILL 8,22
!FILL 8,23
!FILL 8,24

!align 255,0
TED_CHAR_TAB_HI
!for I = 0 TO 255
!BYTE >(CHAR_SET_ADR+(I*8))
!end
  
TED_CHAR_TAB_LO
!for I = 0 TO 255
!BYTE <(CHAR_SET_ADR+(I*8))
!end

;V_PIXEL:
;!for I = 0 TO 24
;!BYTE 0+48,1+48,2+48,3+48,4+48,5+48,6+48,7+48
;!end

!align 255,0
SPR_DRW_TAB !WORD DRW_SPR_00,DRW_SPR_01,DRW_SPR_02,DRW_SPR_03,DRW_SPR_04

H_PIXEL:
!for I = 0 TO 39
!BYTE 0,1,2,3
!end

!align 255,0
V_PIXEL:
!for I = 0 TO 24
!BYTE 0+64,1+64,2+64,3+64,4+64,5+64,6+64,7+64
;!BYTE 0+63,1+63,2+63,3+63,4+63,5+63,6+63,7+63
;!BYTE 0+48,1+48,2+48,3+48,4+48,5+48,6+48,7+48
!end

; software sprites chars are from 128 backward = blocks of 12 chars
; #1 = 128 to 136
; #2 = 137 to 145
; #3 = 146 to 154
; #4 = 160 to 168 
; #5 = 169 to 177
; #5 = 178 to 186
; #6 = 192 to 200
; #7 = 201 to 209
; #8 = 210 to 218
; #9 = 224 to 232
; #10 = 233 to 241
; #11 = 242 to 250
; there are 20 spare chars between 128 and 255 (155 to 159 / 187 to 191 / 219 to 223 / 251 to 255)
; if these are reused between 1 and 128 this releases 20 chars in that range (reuse chars 96 to 113 for sprites)
; #12 = 96 to 104
; #13 = 105 to 113

SPR_00_00_CHR_116 = CHAR_SET_ADR + (116*8)
SPR_00_10_CHR_117 = SPR_00_00_CHR_116 +8
SPR_00_20_CHR_118 = SPR_00_10_CHR_117 +8
SPR_00_30_CHR_119 = SPR_00_20_CHR_118 +8
SPR_00_01_CHR_120 = SPR_00_30_CHR_119 +8
SPR_00_11_CHR_121 = SPR_00_01_CHR_120 +8
SPR_00_21_CHR_122 = SPR_00_11_CHR_121 +8
SPR_00_31_CHR_123 = SPR_00_21_CHR_122 +8
SPR_00_02_CHR_124 = SPR_00_31_CHR_123 +8
SPR_00_12_CHR_125 = SPR_00_02_CHR_124 +8
SPR_00_22_CHR_126 = SPR_00_12_CHR_125 +8
SPR_00_32_CHR_127 = SPR_00_22_CHR_126 +8

SPR_01_00_CHR_104 = CHAR_SET_ADR + (104*8)
SPR_01_10_CHR_105 = SPR_01_00_CHR_104 +8
SPR_01_20_CHR_106 = SPR_01_10_CHR_105 +8
SPR_01_30_CHR_107 = SPR_01_20_CHR_106 +8
SPR_01_01_CHR_108 = SPR_01_30_CHR_107 +8
SPR_01_11_CHR_109 = SPR_01_01_CHR_108 +8
SPR_01_21_CHR_110 = SPR_01_11_CHR_109 +8
SPR_01_31_CHR_111 = SPR_01_21_CHR_110 +8
SPR_01_02_CHR_112 = SPR_01_31_CHR_111 +8
SPR_01_12_CHR_113 = SPR_01_02_CHR_112 +8
SPR_01_22_CHR_114 = SPR_01_12_CHR_113 +8
SPR_01_32_CHR_115 = SPR_01_22_CHR_114 +8

SPR_02_00_CHR_092 = CHAR_SET_ADR + (092*8)
SPR_02_10_CHR_093 = SPR_02_00_CHR_092 +8
SPR_02_20_CHR_094 = SPR_02_10_CHR_093 +8
SPR_02_30_CHR_095 = SPR_02_20_CHR_094 +8
SPR_02_01_CHR_096 = SPR_02_30_CHR_095 +8
SPR_02_11_CHR_097 = SPR_02_01_CHR_096 +8
SPR_02_21_CHR_098 = SPR_02_11_CHR_097 +8
SPR_02_31_CHR_099 = SPR_02_21_CHR_098 +8
SPR_02_02_CHR_100 = SPR_02_31_CHR_099 +8
SPR_02_12_CHR_101 = SPR_02_02_CHR_100 +8
SPR_02_22_CHR_102 = SPR_02_12_CHR_101 +8
SPR_02_32_CHR_103 = SPR_02_22_CHR_102 +8

;SPR_03_00_CHR_210 = CHAR_SET_ADR + (210*8)
;SPR_03_10_CHR_211 = SPR_03_00_CHR_210 +8
;SPR_03_20_CHR_212 = SPR_03_10_CHR_211 +8
;SPR_03_01_CHR_213 = SPR_03_20_CHR_212 +8
;SPR_03_11_CHR_214 = SPR_03_01_CHR_213 +8
;SPR_03_21_CHR_215 = SPR_03_11_CHR_214 +8
;SPR_03_02_CHR_216 = SPR_03_21_CHR_215 +8
;SPR_03_12_CHR_217 = SPR_03_02_CHR_216 +8
;SPR_03_22_CHR_218 = SPR_03_12_CHR_217 +8

;SPR_04_00_CHR_201 = CHAR_SET_ADR + (201*8)
;SPR_04_10_CHR_202 = SPR_04_00_CHR_201 +8
;SPR_04_20_CHR_203 = SPR_04_10_CHR_202 +8
;SPR_04_01_CHR_204 = SPR_04_20_CHR_203 +8
;PR_04_11_CHR_205 = SPR_04_01_CHR_204 +8
;SPR_04_21_CHR_206 = SPR_04_11_CHR_205 +8
;SPR_04_02_CHR_207 = SPR_04_21_CHR_206 +8
;SPR_04_12_CHR_208 = SPR_04_02_CHR_207 +8
;SPR_04_22_CHR_209 = SPR_04_12_CHR_208 +8

;SPR_05_00_CHR_192 = CHAR_SET_ADR + (192*8)
;SPR_05_10_CHR_193 = SPR_05_00_CHR_192 +8
;SPR_05_20_CHR_194 = SPR_05_10_CHR_193 +8
;SPR_05_01_CHR_195 = SPR_05_20_CHR_194 +8
;SPR_05_11_CHR_196 = SPR_05_01_CHR_195 +8
;SPR_05_21_CHR_197 = SPR_05_11_CHR_196 +8
;SPR_05_02_CHR_198 = SPR_05_21_CHR_197 +8
;SPR_05_12_CHR_199 = SPR_05_02_CHR_198 +8
;SPR_05_22_CHR_200 = SPR_05_12_CHR_199 +8

;SPR_06_00_CHR_178 = CHAR_SET_ADR + (178*8)
;SPR_06_10_CHR_179 = SPR_06_00_CHR_178 +8
;SPR_06_20_CHR_180 = SPR_06_10_CHR_179 +8
;SPR_06_01_CHR_181 = SPR_06_20_CHR_180 +8
;SPR_06_11_CHR_182 = SPR_06_01_CHR_181 +8
;SPR_06_21_CHR_183 = SPR_06_11_CHR_182 +8
;SPR_06_02_CHR_184 = SPR_06_21_CHR_183 +8
;SPR_06_12_CHR_185 = SPR_06_02_CHR_184 +8
;SPR_06_22_CHR_186 = SPR_06_12_CHR_185 +8

;SPR_07_00_CHR_169 = CHAR_SET_ADR + (169*8)
;SPR_07_10_CHR_170 = SPR_07_00_CHR_169 +8
;SPR_07_20_CHR_171 = SPR_07_10_CHR_170 +8
;SPR_07_01_CHR_172 = SPR_07_20_CHR_171 +8
;SPR_07_11_CHR_173 = SPR_07_01_CHR_172 +8
;SPR_07_21_CHR_174 = SPR_07_11_CHR_173 +8
;SPR_07_02_CHR_175 = SPR_07_21_CHR_174 +8
;SPR_07_12_CHR_176 = SPR_07_02_CHR_175 +8
;SPR_07_22_CHR_177 = SPR_07_12_CHR_176 +8

SPR_AND_TAB_LO !BYTE <SPR_AND_000_00,<SPR_AND_000_01,<SPR_AND_000_02,<SPR_AND_000_03
SPR_AND_TAB_HI !BYTE >SPR_AND_000_00,>SPR_AND_000_01,>SPR_AND_000_02,>SPR_AND_000_03
SPR_ORA_TAB_LO !BYTE <SPR_ORA_000_00,<SPR_ORA_000_01,<SPR_ORA_000_02,<SPR_ORA_000_03
SPR_ORA_TAB_HI !BYTE >SPR_ORA_000_00,>SPR_ORA_000_01,>SPR_ORA_000_02,>SPR_ORA_000_03

SCN_ADR_HI
!for I = 0 TO 24
!BYTE >(SCR_ADR+(I*40))
!end

SCN_ADR_LO
!for I = 0 TO 24
!BYTE <(SCR_ADR+(I*40))
!end

;BB_SCN_HI
;!for I = 0 TO 24
;!BYTE >(BB_SCN+(I*40))
;!end

;BB_SCN_LO
;!for I = 0 TO 24
;!BYTE <(BB_SCN+(I*40))
;!end

SPR_PXL_V !BYTE 35,100,130,70,50,100,50,25,0,0,0,0,0,0,0,0 ; pixel pos
SPR_PXL_H !BYTE 45,100,130,50,70,50,100,25,0,0,0,0,0,0,0,0
SPR_CHR_V !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; char pos
SPR_CHR_H !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

!align 63,0
SPR_AND_000_00:
!for I = 0 TO 20
!BYTE %00000000
!end
!for I = 0 TO 20
!BYTE %00000000
!end
!for I = 0 TO 20
!BYTE %11111111
!end

!align 63,0
SPR_AND_000_01:
!for I = 0 TO 20
!BYTE %11000000
!end
!for I = 0 TO 20
!BYTE %00000000
!end
!for I = 0 TO 20
!BYTE %00111111
!end

!align 63,0
SPR_AND_000_02:
!for I = 0 TO 20
!BYTE %11110000
!end
!for I = 0 TO 20
!BYTE %00000000
!end
!for I = 0 TO 20
!BYTE %00001111
!end

!align 63,0
SPR_AND_000_03:
!for I = 0 TO 20
!BYTE %11111100
!end
!for I = 0 TO 20
!BYTE %00000000
!end
!for I = 0 TO 20
!BYTE %00000011
!end

!align 63,0
SPR_ORA_000_00:
!for I = 0 TO 20
!BYTE %11111111
!end
!for I = 0 TO 20
!BYTE %11111111
!end
!for I = 0 TO 20
!BYTE %00000000
!end

!align 63,0
SPR_ORA_000_01:
!for I = 0 TO 20
!BYTE %00111111
!end
!for I = 0 TO 20
!BYTE %11111111
!end
!for I = 0 TO 20
!BYTE %11000000
!end

!align 63,0
SPR_ORA_000_02:
!for I = 0 TO 20
!BYTE %00001111
!end
!for I = 0 TO 20
!BYTE %11111111
!end
!for I = 0 TO 20
!BYTE %11110000
!end

!align 63,0
SPR_ORA_000_03:
!for I = 0 TO 20
!BYTE %00000011
!end
!for I = 0 TO 20
!BYTE %11111111
!end
!for I = 0 TO 20
!BYTE %11111100
!end
