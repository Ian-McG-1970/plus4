
* = $1001

SCR_BM_ADR = (48*1024)
;BB_BM_ADR = (40*1024)

SCR_COL_ADR = (56*1024) ;-(2*1024)
SCR_CHR_ADR = SCR_COL_ADR +(1024)

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
TED_CHARSET_ROM_FF12 = $FF12
TED_INT_MASK_REG_FF0A = $FF0A
TED_CONFIG_REG_1_FF06 = $FF06
TED_CONFIG_REG_2_FF07 = $FF07

INT_RASTER_POS = 206-6

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

      LDA TED_INT_MASK_REG_FF0A
      AND #$FE
      STA TED_INT_MASK_REG_FF0A

      LDA #SCR_COL_ADR >>8 ; ((address /1024) *4) / colour addr = (ptr) / screen addr = (ptr +1024)
      STA TED_SCR_ADR_FF14

      LDA TED_CHARSET_ROM_FF12
      AND #%11111011 ; switch charset lookup from ROM to RAM
      ORA #%00110000 ; switch bitmap to highest 8k
      STA TED_CHARSET_ROM_FF12

      LDA TED_CONFIG_REG_1_FF06
      AND #%11110000;111 ; switch on 24 columns
      ORA #%00110111;000 ; switch on bitmap mode
      STA TED_CONFIG_REG_1_FF06

      LDA TED_CONFIG_REG_2_FF07
      ORA #%00010000 ; multi colur mode
      STA TED_CONFIG_REG_2_FF07

      LDA #1
      STA TED_SCR_COL0_FF15 ; Background color. Works/used in every video mode.
      LDA #2
      STA TED_SCR_COL1_FF16 ; Multicolor/Extended color #1. Works/used in multicolor and ECM modes, see $FF07 and $FF06.
      LDA #3
      STA TED_SCR_COL2_FF17 ; Multicolor/Extended color #2. Works/used in multicolor and ECM modes, see $FF07 and $FF06.
;      STA $FF18 ; Extended color #3. Works/used in ECM mode only, see $FF06.
      LDA #0
      STA TED_SCR_BDR_FF19 ; Border color. Works/used in every video mode. When the screen is turned off, (see $FF06), the whole screen is this color.

 LDA #0;1 ; colour 11
 LDX #<SCR_BM_ADR
 LDY #>SCR_BM_ADR
 STX MEM_TO+0
 STY MEM_TO+1
 LDX #>(192*40)
 LDY #<(192*40)
 JSR MEMSET

 LDA #%010011100 ; screen
 LDX #<SCR_CHR_ADR
 LDY #>SCR_CHR_ADR
 STX MEM_TO+0
 STY MEM_TO+1
 LDX #>(24*40) 
 LDY #<(24*40)
 JSR MEMSET

 LDA #0;#%10011001 ; screen
 LDX #<SCR_COL_ADR
 LDY #>SCR_COL_ADR
 STX MEM_TO+0
 STY MEM_TO+1
 LDX #>(24*40)
 LDY #<(24*40)
 JSR MEMSET

  LDA #50
  STA PLAYER_H
  STA PLAYER_V
  
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

  LDY PLAYER_V
  LDX PLAYER_H
  JSR PLOT0
  
  JSR JOYSTICK1
  JSR MOVE_PLAYER ; move sprite
  
  LDY PLAYER_V
  LDX PLAYER_H
  JSR PLOT1

.REGA LDA #0
.REGX LDX #0
.REGY LDY #0

      RTI   ; Return from Interrupt

!ZONE PLOT0
PLOT0   BMI   +
        LDA   VER_TAB_0_LO,Y
        STA   SCN_LO 
        LDA   VER_TAB_0_HI,Y 
        STA   SCN_HI
        LDY   HOR_TAB,X
        LDA   (SCN),Y 
        AND   AND_00_TAB,X
        STA   (SCN),Y 
        RTS

+       LDA   VER_TAB_0_LO,Y
        STA   SCN_LO 
        LDA   VER_TAB_1_HI,Y 
        STA   SCN_HI
        LDY   HOR_TAB,X
        LDA   (SCN),Y 
        AND   AND_00_TAB,X
        STA   (SCN),Y 
        RTS

!ZONE PLOT1
PLOT1   BMI   +
        LDA   VER_TAB_0_LO,Y
        STA   SCN_LO
        LDA   VER_TAB_0_HI,Y 
        STA   SCN_HI
        LDY   HOR_TAB,X
        LDA   (SCN),Y 
        ORA   OR_11_TAB,X
        STA   (SCN),Y 
        RTS

+       LDA   VER_TAB_0_LO,Y
        STA   SCN_LO 
        LDA   VER_TAB_1_HI,Y 
        STA   SCN_HI
        LDY   HOR_TAB,X
        LDA   (SCN),Y 
        ORA   OR_11_TAB,X
        STA   (SCN),Y 
        RTS

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

!align 255,0
HOR_TAB:
!FILL 4,00*8
!FILL 4,01*8
!FILL 4,02*8
!FILL 4,03*8
!FILL 4,04*8
!FILL 4,05*8
!FILL 4,06*8
!FILL 4,07*8
!FILL 4,08*8
!FILL 4,09*8
!FILL 4,10*8
!FILL 4,11*8
!FILL 4,12*8
!FILL 4,13*8
!FILL 4,14*8
!FILL 4,15*8
!FILL 4,16*8
!FILL 4,17*8
!FILL 4,18*8
!FILL 4,19*8
!FILL 4,20*8
!FILL 4,21*8
!FILL 4,22*8
!FILL 4,23*8
!FILL 4,24*8
!FILL 4,25*8
!FILL 4,26*8
!FILL 4,27*8
!FILL 4,28*8
!FILL 4,29*8
!FILL 4,30*8
!FILL 4,31*8
!FILL 4,00*8
!FILL 4,01*8
!FILL 4,02*8
!FILL 4,03*8
!FILL 4,04*8
!FILL 4,05*8
!FILL 4,06*8
!FILL 4,07*8

!align 255,0
AND_00_TAB:
!for I = 1 TO 40
!BYTE $3F,$CF,$F3,$FC
!end

!align 255,0
OR_11_TAB:
!for I = 1 TO 40
!BYTE $C0,$30,$0C,$03
!end

!align 255,0
VER_TAB_0_HI
!for I = 0 TO 24
!BYTE >(SCR_BM_ADR+(I*320)+0),>(SCR_BM_ADR+(I*320)+1),>(SCR_BM_ADR+(I*320)+2),>(SCR_BM_ADR+(I*320)+3),>(SCR_BM_ADR+(I*320)+4),>(SCR_BM_ADR+(I*320)+5),>(SCR_BM_ADR+(I*320)+6),>(SCR_BM_ADR+(I*320)+7)
!end

;!align 255,0
;VER_TAB_1_HI
;!for I = 0 TO 24
;!BYTE >((SCR_BM_ADR+256)+(I*320)+0),>((SCR_BM_ADR+256)+(I*320)+1),>((SCR_BM_ADR+256)+(I*320)+2),>((SCR_BM_ADR+256)+(I*320)+3),>((SCR_BM_ADR+256)+(I*320)+4),>((SCR_BM_ADR+256)+(I*320)+5),>((SCR_BM_ADR+256)+(I*320)+6),>((SCR_BM_ADR+256)+(I*320)+7)
;!end

!align 255,0
VER_TAB_0_LO
!for I = 0 TO 24
!BYTE <(SCR_BM_ADR+(I*320)+0),<(SCR_BM_ADR+(I*320)+1),<(SCR_BM_ADR+(I*320)+2),<(SCR_BM_ADR+(I*320)+3),<(SCR_BM_ADR+(I*320)+4),<(SCR_BM_ADR+(I*320)+5),<(SCR_BM_ADR+(I*320)+6),<(SCR_BM_ADR+(I*320)+7)
!end
