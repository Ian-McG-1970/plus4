
* = $1001

SCR_ADR     = 61*1024
SCR_COL_ADR = 60*1024
CHAR_SET_ADR = 58*1024
SCR_BUF_ADR = 57*1024
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

BB_V0H0LO = SN_V2H0HI +1
BB_V0H0HI = BB_V0H0LO +1
BB_V1H0LO = BB_V0H0HI +1
BB_V1H0HI = BB_V1H0LO +1
BB_V2H0LO = BB_V1H0HI +1
BB_V2H0HI = BB_V2H0LO +1

VPIX = BB_V2H0HI +1
HPIX = VPIX +1

TED_SCR_BDR_FF19 = $FF19
TED_SCR_COL0_FF15 = $FF15
TED_SCR_COL1_FF16 = $FF16
TED_SCR_COL2_FF17 = $FF17

TED_RASTER_LINE_FF08 = $FF0B
TED_INT_FFFE = $FFFE
TED_SCR_ADR_FF14 = $FF14
TED_CHARSET_ADR_FF13 = $FF13

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
    LDA VIC_CHAR_TAB_LO,X
    STA SCN_LO 
    LDA VIC_CHAR_TAB_HI,X
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

 LDX #32
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

    LDA #255
    SBX #16
    BMI .EXIT

   TYA
   SBC #24 ; next screen line to the left
   TAY
   JMP .LOOP

.EXIT
}

init: !WORD $100B,0
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

      LDA #(SCR_COL_ADR >>8) ; ((address /1024) *4) / colour addr = (ptr) / screen addr = (ptr +1024)
      STA TED_SCR_ADR_FF14
      LDA #(CHAR_SET_ADR >>8)
      STA TED_CHARSET_ADR_FF13

;      LDA $FF06
;      ORA #%10010000 0000000016 ; FULL 256 CHARS + MCM MODE
;      STA $FF06

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

 LDA #0 ; screen
 LDX #<SCR_ADR
 LDY #>SCR_ADR
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
 
  LDX #<2048
  LDY #>2048
  STX MEM_FROM+0
  STY MEM_FROM+1
  LDX #<CHAR_SET_ADR
  LDY #>CHAR_SET_ADR
  STX MEM_TO+0
  STY MEM_TO+1
  LDY #<2048
  LDX #>2048
;  JSR MEMCPY

  JSR FILL_CHARS

;      LDX #7
;      LDA #0  lda #0 ; %11000110
;-       STA CHAR_SET_ADR,X
;        DEX
;        BPL -

 LDA #2; 7 ; 1; 7 ; 0 ; -1
 STA SPR_CNT

      CLI
      
MLOOP JMP MLOOP

!ZONE IRQ
IRQ:  STA .REGA +1
      STX .REGX +1
      STY .REGY +1

      LDA $FF09 ; clear interrupt bit
      STA $FF09

      INC $FF19 ; change BORDER and
      INC $FF15 ; background color
      DEC $FF19
      DEC $FF15
      INC $FF19
      INC $FF15
      DEC $FF19
      DEC $FF15
      INC $FF19
      INC $FF15
      DEC $FF19
      DEC $FF15
      INC $FF19
      INC $FF15
      DEC $FF19
      DEC $FF15
      INC $FF19
      INC $FF15
      DEC $FF19
      DEC $FF15

.REGA LDA #0
.REGX LDX #0
.REGY LDY #0

      RTI   ; Return from Interrupt

; FROM = source start address
;   TO = destination start address
; SIZE = number of bytes to move
  
!ZONE MEMCPY
MEMCPY
    STY .LSB +1
    LDY #0
    TXA
    BEQ .LSB
.LOOPHI LDA (MEM_FROM),Y ; move a page at a time
        STA (MEM_TO),Y
        INY
        BNE .LOOPHI
      INC MEM_FROM+1
      INC MEM_TO+1
      DEX
      BNE .LOOPHI
.LSB    LDX #0
        BEQ .EXIT
.LOOPLO   LDA (MEM_FROM),Y ; move the remaining bytes
          STA (MEM_TO),Y
          INY
          DEX
          BNE .LOOPLO
.EXIT  RTS

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

FILL_CHAR
      LDY TED_CHAR_TAB_LO,X
      STY .SCN+1
      LDY TED_CHAR_TAB_HI,X  
      STY .SCN+2
      LDX #7
.SCN    STA $ABCD,X
        DEX
        BPL .SCN
      RTS

FILL_CHARS
      LDX #0
-       TXA
        PHA
        JSR FILL_CHAR
        PLA
        TAX
        DEX
        BNE -
      RTS

!align 255,0
TED_CHAR_TAB_HI
!for I = 0 TO 255
!BYTE >(CHAR_SET_ADR+(I*8))
!end
  
TED_CHAR_TAB_LO
!for I = 0 TO 255
!BYTE <(CHAR_SET_ADR+(I*8))
!end

; Locating Screen and Color Memory A character is placed on the screen by placing its screen code into a location of screen memory.
; The screen code (multiplied by 8) is used by the graphics chip to look up the character's pattern in the character set.
; The color and luminance associated with a particular screen location are stored in the corresponding location in color memory. 

; These two sections of memory are each IK (1000 locations for the 25 rows of 40 columns and 24 unused locations).
; They are treated as a single 2K block.
; Color memory is located by setting the high 5 bits of $FF14 to the high 5 bits of the desired color memory location.
; Screen memory is always located in the IK immediately following color memory.
; Color memory must be located on a 2K boundary.
; Normally, color memory is located at $0800 (2048) and screen memory at SOCOO (3072). 



