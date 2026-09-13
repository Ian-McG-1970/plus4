*= 4112

character_set_mem_buffer2 = $f000
character_set_mem_buffer1 = $e800

screen_mem_buffer1      = $0c00
screen_mem_buffer2      = $e400
double_buffer_screen_cycles = 1

last_body_character_behavior = $e4
last_feet_character_behavior = $e5
last_ninja_body_character_behavior = $f4
last_ninja_feet_character_behavior = $f5
last_sumo_body_character_behavior = $f6
last_sumo_feet_character_behavior = $f7

base = $a0
VOLTAB_CNT  = base + $00
NOISE   = base + $01

PCH   = base + $02  ; pattern data pointers (2)

CH1_LO    = base + $04  ; channel data pointers
CH2_LO    = base + $05
CH1_HI    = base + $06
CH2_HI    = base + $07

CH_TEMP   = base + $08  ; 16 bit

NOTE1   = base + $0A  ; note counters
NOTE2   = base + $0B
NOTELEN1  = base + $0C  ; current note lengths
NOTELEN2  = base + $0D

INS_TYPE1 = base + $0E
INS_TYPE2 = base + $0F
TONE1   = base + $10
TONE2   = base + $11
VIB_ADD   = base + $12

*= 4112

start:
    lda   $ff02
    sta   next_random_pointer
    sei
    sta   $ff3f
    jsr   init_music_memory

    ; graphic mode on

back_to_main_menu
    sei
    sta   $ff3f
    jsr   init_surface_world_charset_buffer
    jsr   title_screen
    lda   #$00
    sta   return_to_main_menu
    lda   #SND_OFF
    jsr   (sound_set - music_data_start) + music_target_memory
    jsr   copy_underground_chars_to_charset
    jsr   copy_surface_world_chars_to_charset
    
    lda   #$08
    sta   $ff12
    lda   #character_set_mem_buffer1 >> 8
    sta   $ff13
    lda   $ff07
    and   #$40
    ora   #$98
    sta   $ff07
    lda   #$51
    sta   $ff15
    lda   #$f1
    sta   $ff17
    lda   #$00
    sta   $ff16
    lda   #$00
    sta   $ff19
    lda   #screen_mem_buffer1 >> 8
    sec
    sbc   #$04
    sta   $ff14
    lda   irq_mem
    sta   $fffe
    lda   irq_mem + 1
    sta   $ffff
    lda   #$d0
    sta   $ff0b
    lda   $ff0a
    and   #$fe
    sta   $ff0a
    
    ; copy chars to charset of both buffers
    ldx     #$00
-       lda   character_set_start,x
    sta   character_set_mem_buffer2,x
        lda   character_set_start + $100,x
    sta   character_set_mem_buffer2 + $100,x
        lda   character_set_start + $200,x
    sta   character_set_mem_buffer2 + $200,x
        lda   character_set_start + $300,x
    sta   character_set_mem_buffer2 + $300,x
        lda   character_set_start + $400,x
    sta   character_set_mem_buffer2 + $400,x
        lda   character_set_start + $500,x
    sta   character_set_mem_buffer2 + $500,x
        lda   character_set_start + $600,x
    sta   character_set_mem_buffer2 + $600,x
        lda   character_set_start + $700,x
    sta   character_set_mem_buffer2 + $700,x
    inx
    bne   -

    jsr   init_warp_chars_for_dev_mode

    jsr   reset_player_scores
    lda   #$00;starts with player 1
    sta   current_player
    jsr   show_player_score
    lda   #digit_zero_INDEX
    sta   falls_counter
    lda   #digit_3_INDEX
    sta   falls_counter + 1
    
    ldx   #$00
    txa
-   sta   room_visit_check_for_scoring,x
    inx
    cpx   #number_of_rooms
    bne   -
    
    lda   #$01  ;set the first level to "visited" to avoid scoring
    sta   room_visit_check_for_scoring
    sta   room_visit_check_for_scoring + 1
    
+
    ;prepare/pre-render
    jsr   init_conveyor
    
    ; set all lamp status to "on_screen"
    ldx   #$00
    lda   #$01

-   sta   lamp_status_flags,x
    inx
    cpx   #number_of_lamps
    bne   -
    
    lda   #$ff      ;yellow
    sta   sprite1_data_color
    ; init player x and y and warp target to first screen

    lda   #$cd      ;green
    sta   sprite2_data_color

    lda   #$ee    ;doesn't matter, ninja is multi1 black
    sta   sprite3_data_color

    lda   #00     ;increase this number to make the game harder (0-50). Global spawn interval reduction
    sta   spawn_interval_reduction
    
    lda   #$00
    sta   player_alive_timer
    sta   player_alive_timer + 1
    
    lda   #$00
    sta   game_is_in_hard_mode    
    
    ; init player x and y and warp target to first screen
    
    lda   #1    ;start on screen index
    sta   current_screen_warp1_target
    lda   #$22
    sta   current_screen_warp1_target_initial_x
    lda   #$bb
    sta   current_screen_warp1_target_initial_y
    lda   #$01
    sta   last_player_direction
    lda   #$01  ; warp target 1
    jsr   player_warped
    
    lda   #$1b
    jsr   show_hide_screen

    cli
    
    ; main loop start
main_loop_start:
    
    ;prepare screen in buffer 2
    lda   #$01
    sta   buffer_drawing
    lda   #screen_mem_buffer2 >> 8
    sta   draw_to_screen_buffer
    
    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer2
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer2
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer2
    
    jsr   main_game_logic
    jsr   DEVELOPER_FUNCTIONS

    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$02    ;//sprite index
    jsr   render_sprite_buffer2

    ; wait for vertical sync
-   lda   screen_vsync_counter
    cmp   #double_buffer_screen_cycles
    beq   -
    bcc   -
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 38
-   lda   $ff1d
    cmp   #18
    bcc   -

    lda   #$00
    sta   screen_vsync_counter
    
    ;show buffer 2  ********* buffer swith ************
  ;inc  $ff19
    lda   #screen_mem_buffer2 >> 8
    sec
    sbc   #$04
    sta   $ff14
    lda   #character_set_mem_buffer2 >> 8
    sta   $ff13
    sta   ff13_backup
  ;dec  $ff19

    ;prepare screen in buffer 1
    
    lda   #$00
    sta   buffer_drawing
    lda   #screen_mem_buffer1 >> 8
    sta   draw_to_screen_buffer

    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer1
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer1
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer1


    jsr   main_game_logic
    jsr   DEVELOPER_FUNCTIONS
    
    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$02    ;//sprite index

    jsr   render_sprite_buffer1

    ; wait for vertical sync
-   lda   screen_vsync_counter
    cmp   #double_buffer_screen_cycles
    beq   -
    bcc   -
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 38
-   lda   $ff1d
    cmp   #18
    bcc   -

    
    lda   #$00
    sta   screen_vsync_counter

  ;inc  $ff19
    ;show buffer 1   ********* buffer swith ************
    lda   #screen_mem_buffer1 >> 8
    sec
    sbc   #$04
    sta   $ff14
    lda   #character_set_mem_buffer1 >> 8
    sta   $ff13
    sta   ff13_backup
  ;dec $ff19

    lda   return_to_main_menu
    bne   death_in_demo_mode
    
    ;check esc key
    lda   #$bf    
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ef
    beq   esc_pressed

    lda   player_control_method
    cmp   #control_method_ai
    bne   +
    ;check f3 key in demo mode
    lda   #$fe
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$bf
    beq   demo_f3_pressed
+   
    jmp   main_loop_start
esc_pressed
demo_f3_pressed
death_in_demo_mode
    
    ;on ESC key, turn off dev mode first
    lda   DEVELOPER_MODE
    beq   +
    jsr   turn_off_dev_mode_during_play

    jmp   main_loop_start 
+   
    lda   #$0b
    jsr   show_hide_screen
    jsr   wait_for_key_release
    jmp   back_to_main_menu

turn_off_dev_mode_during_play
    lda   #$00
    sta   DEVELOPER_MODE
    jsr   draw_black_bar_below_info
    jmp   wait_for_key_release

draw_black_bar_below_info
    ldx   #$00
-
    lda   #$35
    sta   screen_mem_buffer1 + 40,x 
    sta   screen_mem_buffer2 + 40,x 
    lda   #$88
    sta   screen_mem_buffer1 - $400 + 40,x 
    sta   screen_mem_buffer2 - $400 + 40,x 
    inx
    cpx   #$28
    bne   -
    rts 
    
buffer_drawing
    !BYTE   0
draw_to_screen_buffer
    !BYTE   0
    
DEVELOPER_MODE      
    !BYTE   1

;-----------------------------------------------------------------------------------------
;       DEVELOPER FUNCTIONS
;-----------------------------------------------------------------------------------------
DEVELOPER_FUNCTIONS

    lda   DEVELOPER_MODE
    bne   +
    rts
+
    ;mark dev mode on screen
    
    ldx   #digit_zero_INDEX
    lda   is_player_attacking
    beq   +
    ldx   #digit_1_INDEX
+   stx   dev_mode_info_bar + 10

    ldx   #digit_zero_INDEX
    lda   is_ninja_attacking
    beq   +
    ldx   #digit_1_INDEX
+   stx   dev_mode_info_bar + 11

    ldx   #digit_zero_INDEX
    lda   is_sumo_attacking
    beq   +

    ldx   #digit_1_INDEX
+   stx   dev_mode_info_bar + 12

    lda   player_invulnerability_timer
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 14

    lda   ninja_invulnerability_timer
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 15

    lda   sumo_invulnerability_timer
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 16
    
    lda   spawn_interval
    sec
    sbc   spawn_timer
    ldx   #18
    jsr   put_hex_to_dev_bar
    
    lda   sprite1_data_x
    ldx   #5
    jsr   put_hex_to_dev_bar
    lda   sprite1_data_y
    ldx   #7
    jsr   put_hex_to_dev_bar

    lda   player_alive_timer + 1
    ldx   #22
    jsr   put_hex_to_dev_bar
    lda   player_alive_timer
    ldx   #24
    jsr   put_hex_to_dev_bar

    
    ldx   #$00
-
    lda   dev_mode_info_bar, x
    sta   screen_mem_buffer1 + 40,x
    sta   screen_mem_buffer2 + 40,x
    lda   #$00
    sta   screen_mem_buffer1 - 1024 + 40,x
    sta   screen_mem_buffer2 - 1024 + 40,x
    
    inx
    cpx   #40
    bne   -
    
; Check jump keys
    lda   #$fe    
    sta   $fd30
    sta   $ff08
    lda   $ff08
    tax

    and   #$10
    beq   devmode_one_pressed
    txa
    and   #$20
    beq   devmode_two_pressed
    txa
    and   #$40
    beq   devmode_three_pressed
    txa
    and   #$08
    beq   devmode_four_pressed
    txa
    and   #$01
    beq   devmode_insdel_pressed

    rts
    
devmode_one_pressed
    lda   #$01
    jmp   player_warped ; warp to 1
devmode_two_pressed
    lda   #$02
    jmp   player_warped ; warp to 2
devmode_three_pressed
    lda   #$03
    jmp   player_warped ; warp to 3
devmode_four_pressed
    lda   #$04
    jmp   player_warped ; warp to 4
devmode_insdel_pressed
    jmp   devmode_pick_all_level_lamps

devmode_pick_all_level_lamps
    lda   pointer_to_current_level_lamps    ;1c-1d pointer to lamps on current level
    sta   $1c
    lda   pointer_to_current_level_lamps + 1
    sta   $1d
    
    ldy   #$00
-
    lda   ($1c),y
    cmp   #$ff
    beq   +
    tax
    lda   #$fc    ;pick-up mode for lamps
    sta   lamp_status_flags,x
    iny
    iny
    iny
    bne   -

+   

    lda   #$00    ;clear screen from enemies
    sta   is_ninja_active
    sta   is_sumo_active
    sta   spawn_timer
    
    rts
    
put_hex_to_dev_bar
    tay
    lsr
    lsr
    lsr
    lsr
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar, x
    tya
    and   #$0f
    clc
    adc   #digit_zero_INDEX
    sta   dev_mode_info_bar + 1, x
    rts
dev_mode_info_bar
    !BYTE 00, letter_p_INDEX,letter_o_INDEX,letter_s_INDEX,00
    !BYTE 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00

;-------------------------------------------------------------------------------
;         IRQ
;-------------------------------------------------------------------------------
screen_vsync_counter:
    !BYTE 00
irq_mem:
    !WORD main_irq
    !WORD main_irq_upper
    !WORD main_irq_lower
    !WORD main_irq_bottom

ff13_backup:
    !BYTE 00

main_irq
    sta   $40
    stx   $41
    sty   $42
    asl   $ff09
    
    lda   $ff13
    sta   ff13_backup
    lda   #$d8
    sta   $ff13
    
    ;init upper screen part of bg IRQ
    lda   #18
    sta   $ff0b
    lda   irq_mem + 2 ;main_irq_upper
    sta   $fffe
    lda   irq_mem + 3
    sta   $ffff

    lda   $40
    ldx   $41
    ldy   $42
    rti

main_irq_upper
    sta   $40
    stx   $41
    sty   $42
    asl   $ff09
    
    nop   ;sync stabilizer
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
    lda   current_screen_bg_color_top
    sta   $ff15

    lda   ff13_backup
    sta   $ff13

    ;inc  $ff19
    ;dec  $ff19
    
    ;init upper part of bg IRQ
    lda   current_screen_bg_color_split_line        ;split line between upper and lower color
    sta   $ff0b
    lda   irq_mem + 4   ;main_irq_lower
    sta   $fffe
    lda   irq_mem + 5
    sta   $ffff

    lda   $40
    ldx   $41
    ldy   $42
    rti

main_irq_lower
    sta   $40
    stx   $41
    sty   $42
    asl   $ff09

    nop   ;sync stabilizer
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
    lda   current_screen_bg_color_bottom
    sta   $ff15
    ;inc  $ff19
    ;dec  $ff19
    
    ;init upper pard of bg IRQ
    lda   #$d0
    sta   $ff0b
    lda   irq_mem + 6
    sta   $fffe
    lda   irq_mem + 7
    sta   $ffff

    jsr   (sound_call - music_data_start) + music_target_memory

    lda   $40
    ldx   $41
    ldy   $42
    rti

main_irq_bottom
    sta   $40
    stx   $41
    sty   $42
    asl   $ff09

info_bar_bg_color
    lda   #$51      ; info bar background
    sta   $ff15
    ;inc  $ff19
    inc   screen_vsync_counter
  
    ;init upper pard of bg IRQ
    lda   #$02
    sta   $ff0b
    lda   irq_mem
    sta   $fffe
    lda   irq_mem + 1
    sta   $ffff

    lda   $40
    ldx   $41
    ldy   $42
    rti

;------------------------------------------------------------------------- MAIN LOGIC -------------------------------------
main_game_logic:

    lda   #$00
    sta   any_bush_touched
    jsr   player_activity_main_entry_point
    jsr   ninja_activity_main_entry_point
    jsr   sumo_activity_main_entry_point
    jsr   screen_maintenance
    jsr   schedule_enemy_spawn

screen_exec_logic_ptr   
    jsr   $0000
    
    ;increase level time
    lda   level_time
    clc
    adc   #$01
    bcc   +
    inc   level_time + 1
+   sta   level_time
    rts

;--------------------------------------------------------------------------------------------------------
;     Make the enemies appear on the screen regularly
;--------------------------------------------------------------------------------------------------------
schedule_enemy_spawn
    lda   level_time
    and   #$03
    beq   +
    rts
+
    ;increase spawn timer
    inc   spawn_timer
    lda   spawn_timer
    cmp   spawn_interval
    bcc   +
    lda   #$00
    sta   spawn_timer
    jsr   spawn_enemy
+
    rts

;--------------------------------------------------------------------------------------------------------
;     Makes animations, flashes lamps, etc related to screens
;--------------------------------------------------------------------------------------------------------
lamp_flash_timer
    !BYTE 00
lamp_flash_random
    !BYTE 00
lamp_flash_speed = 8    

level_time
    !BYTE 0,0
    
screen_maintenance
    
    inc   lamp_flash_timer
    lda   lamp_flash_timer
    cmp   #lamp_flash_speed - 1
    bcc   after_lamp
    
    lda   lamp_flash_random
    ldx   draw_to_screen_buffer
    jsr   render_current_level_lamps

after_lamp
    lda   lamp_flash_timer
    cmp   #lamp_flash_speed 
    bne   +
    jsr   get_next_random_number
    sta   lamp_flash_random
    and   #$03
    sta   lamp_flash_timer
+
    jsr   show_player_id    

    rts 

;---additional registers
REG_A:
    !BYTE   0
REG_B:
    !BYTE   0
REG_C:
    !BYTE   0
REG_D:
    !BYTE   0
REG_E:
    !BYTE   0
REG_F:
    !BYTE   0
REG_G:
    !BYTE   0
REG_H:
    !BYTE   0

music_target_memory   = $200
init_music_memory
    ldx   #$00
-   lda   music_data_start,x
    sta   music_target_memory,x
    lda   music_data_start + $100,x
    sta   music_target_memory + $100,x
    lda   music_data_start + $200,x
    sta   music_target_memory + $200,x
    lda   music_data_start + $300,x
    sta   music_target_memory + $300,x
    lda   music_data_start + $400,x
    sta   music_target_memory + $400,x
    lda   music_data_start + $500,x
    sta   music_target_memory + $500,x
    inx
    bne   -
    ;byt    $f2
    rts

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 2
;--------------------------------------------------------
screen_does_nothing
    rts

;------------------------------------------------------------------------------
screen2_actions_init
    lda   #$3a    ; lid color
    sta   lid_color_for_level + 1
    jsr   reset_lid_animation
    jsr   screen2_actions
    rts
    
screen2_actions
    ldx   #$00
-   lda   lamp_status_flags,x
    cmp   #$01      ;lamp is still hanging
    beq   +       ;do not handle lid, still lamps there to collect
    inx
    cpx   #22       ; 22 lamps to collect for screen 2 lid open
    bne   -
    ;needs to handle lid
    ldx   #17
    ldy   #22
    ;byt  $f2
    jmp   handle_lid

+   ;not all required lamps are collected   
    rts
    
    rts 

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 3
;--------------------------------------------------------
screen3_actions_init
    lda   #$00    
    sta   screen3_door1_handled
    jsr   screen3_actions
    jmp   screen3_actions

screen3_door1_handled   
    !BYTE 00
    
screen3_actions
    lda   screen3_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen3_door1_handled
+   
    lda   lamp_status_flags + 40    ;one of the lamps on screen 6
    bne   ++
    ;   all required lamps gathered, open door
    
    ldx   #39
    ldy   #18
    lda   #(6 + DOOR_TO_WARP_2)
    jsr   open_dynamic_door
    lda   screen3_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen3_door1_handled
++   

    rts

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 4
;--------------------------------------------------------
screen4_platform_placement
    !BYTE 0 
screen4_platform_placement_lo
    !BYTE $c1,$cd
screen4_platform_chars  
    !BYTE 12,18,12
    
screen4_actions_init
    jsr   copy_surface_world_chars_to_charset
    jsr   set_bush_root_1
    lda   #$3a    ; lid color
    sta   lid_color_for_level + 1
    jsr   reset_lid_animation
    jmp   screen4_actions
    
screen4_actions
    lda   lamp_status_flags + 22
    bne   +
    lda   lamp_status_flags + 23
    bne   +
    ;needs to handle lid
    ldx   #29
    ldy   #22
    ;byt  $f2
    jsr   handle_lid

+   ;not all required lamps are collected   
    ; handle moving platform
    
    lda   screen4_platform_placement
    and   #$01
    tax
    lda   screen4_platform_chars,x
    sta   screen4_pla_char1 + 1
    lda   screen4_platform_chars + 1,x
    sta   screen4_pla_char2 + 1

    lda   screen4_platform_placement_lo
    sta   $14
    sta   $18
    lda   #$01
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sta   $17
    sec
    sbc   #$04
    sta   $19
    sta   $1b

    lda   screen4_platform_placement_lo + 1
    sta   $16
    sta   $1a

    ldy   #$00
-
screen4_pla_char1
    lda   #$18
    sta   ($14),y
screen4_pla_char2   
    lda   #$00
    sta   ($16),y
    lda   #$3a    ;platform color
    sta   ($18),y
    sta   ($1a),y
    iny
    cpy   #$07
    bne   -
    
    lda   level_time
    clc
    adc   #$02
    and   #$0f
    bne   +
    inc   screen4_platform_placement
+
    rts

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 5
;--------------------------------------------------------    
screen5_actions_init
    lda   #$00
    sta   screen5_door1_handled
    sta   screen5_door2_handled
    sta   screen5_door3_handled
    
    lda   screen5_laser_current_step + 1
    sta   screen5_laser_current_step
    lda   #30
    sta   screen5_laser2_current_step
    lda   #26
    sta   screen5_laser3_current_step
    
    lda   #$01
    sta   screen5_laser_current_step + 2  ;enabled
    sta   screen5_laser2_current_step + 2  ;enabled
    sta   screen5_laser3_current_step + 2  ;enabled
    
    jsr   copy_surface_world_chars_to_charset
    jsr   set_bush_root_1
    
    jsr   speed_up_zapper

    
    jsr   screen5_actions
    jmp   screen5_actions

screen5_door1_handled
    !BYTE 00
screen5_door2_handled
    !BYTE 00
screen5_door3_handled
    !BYTE 00
open_door_screen_steps    = 3

screen5_laser
    !WORD screen5_laser + 2
    !BYTE 39,8,5, $ee ; x,y, width, color
screen5_laser_current_step
    !BYTE 0,45,1 ;current step, max step, enabled

screen5_laser2
    !WORD screen5_laser2 + 2
    !BYTE 25,16,5, $ee ; x,y, width, color
screen5_laser2_current_step
    !BYTE 0,60, 1 ;current step, max step, enabled

screen5_laser3
    !WORD screen5_laser3 + 2
    !BYTE 25,18,5, $ee ; x,y, width, color
screen5_laser3_current_step
    !BYTE 0,60,1 ;current step, max step, enabled

!ZONE screen5_actions
screen5_actions

    jsr   move_conveyor

    ldx   screen5_laser
    ldy   screen5_laser + 1
    jsr   move_laser

    ldx   screen5_laser2
    ldy   screen5_laser2 + 1
    jsr   move_laser_rocket

    ldx   screen5_laser3
    ldy   screen5_laser3 + 1
    jsr   move_laser_rocket
    
    lda   screen5_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen5_door1_handled
+  
    lda   lamp_status_flags + 32
    bne   ++ ;;; +
    lda   lamp_status_flags + 33
    bne   ++ ;;; +
    ldx   #25
    ldy   #19
    lda   #5
    jsr   open_dynamic_door
    
    ;rocket 2 is turned off with door
    lda   #$00
    sta   screen5_laser3_current_step + 2  ;set enabled flag to 0

    lda   screen5_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen5_door1_handled

++ ;;; +
    lda   screen5_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen5_door2_handled
+   
    lda   lamp_status_flags + 30
    bne   ++ ;;;+
    lda   lamp_status_flags + 31
    bne   ++ ;;;+
    ldx   #0 
    ldy   #19
    lda   #(5 + DOOR_TO_WARP_1)
    jsr   open_dynamic_door
    
    lda   screen5_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen5_door2_handled

++ ;;; +  
    lda   screen5_door3_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen5_door3_handled
+   
    lda   lamp_status_flags + 40    ;one of the lamps on screen 6
    bne   ++ ;;;+
    ;   all required lamps gathered, open door
    ldx   #30 
    ldy   #4
    lda   #6 
    jsr   open_dynamic_door
    ldx   #32
    ldy   #10
    lda   #6 
    jsr   open_dynamic_door
    ;remove sword from conveyor
    ldx   #34
    ldy   #2
    lda   #$00 ;narrow conveyor
    jsr   restore_conveyor_block
    ldx   #34
    ldy   #2
    lda   #(3 + DOOR_TO_WARP_4 + DOOR_IS_HORIZONTAL)
    jsr   open_dynamic_door
    
    lda   screen5_door3_handled
    bne   ++ ;;; +; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen5_door3_handled
++ ;;; +   

    rts

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 6
;--------------------------------------------------------
!ZONE screen6_actions_init
screen6_actions_init
    lda   #$00
    sta   screen6_door1_handled
    ;sta    screen6_bush1 + 4
    
    jsr   copy_underground_chars_to_charset
    
    jsr   screen6_actions
    jmp   screen6_actions

screen6_door1_handled
    !BYTE 00

screen6_bush1
    !WORD screen6_bush1 + 2
    !BYTE 18,20,0, $ee, 0 ;x,y, phase, color, internal counter

!ZONE screen6_actions    
screen6_actions

    ldx   screen6_bush1
    ldy   screen6_bush1 + 1
    jsr   handle_bush
    
    jsr   move_conveyor

    lda   screen6_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen6_door1_handled
+   
    ldx   #34
-   lda   lamp_status_flags,x
    cmp   #$01      ;lamp is still hanging
    beq   ++       ;do not handle lid, still lamps there to collect
    inx
    cpx   #42       ; 34-41 lamps to collect for screen 5 left wall open
    bne   -
    
    ldx   #1
    ldy   #9
    lda   #5
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen6_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen6_door1_handled
++   
    rts

    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 7
;--------------------------------------------------------
screen7_actions_init
    lda   #$00
    sta   screen7_door1_handled
    sta   screen7_door2_handled

    lda   #30
    sta   screen7_laser1_current_step
    lda   #15
    sta   screen7_laser2_current_step
    lda   #30
    sta   screen7_laser3_current_step
    
    lda   #$01
    sta   screen7_laser1_current_step + 2  ;enabled
    sta   screen7_laser2_current_step + 2  ;enabled
    
    jsr   copy_underground_chars_to_charset
    
    jsr   screen7_actions
    jmp   screen7_actions

screen7_door1_handled
    !BYTE 00

screen7_door2_handled
    !BYTE 00

screen7_laser1
    !WORD screen7_laser1 + 2
    !BYTE 9,12,5, $ee ; x,y, width, color
screen7_laser1_current_step
    !BYTE 0,50, 1 ;current step, max step, enabled

screen7_laser2
    !WORD screen7_laser2 + 2
    !BYTE 24,12,5, $ee ; x,y, width, color
screen7_laser2_current_step
    !BYTE 0,50,1 ;current step, max step, enabled

screen7_laser3
    !WORD screen7_laser3 + 2
    !BYTE 39,20,6, $ee ; x,y, width, color
screen7_laser3_current_step
    !BYTE 0,120,1 ;current step, max step, enabled

!ZONE screen7_actions
screen7_actions

    jsr   move_conveyor

    ldx   screen7_laser1
    ldy   screen7_laser1 + 1
    jsr   move_laser_rocket

    ldx   screen7_laser2
    ldy   screen7_laser2 + 1
    jsr   move_laser_rocket

    ldx   screen7_laser3
    ldy   screen7_laser3 + 1
    jsr   move_laser
    
    ;door 1
    lda   screen7_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen7_door1_handled
+   
    lda   lamp_status_flags + 42
    bne   ++       
    
    ldx   #11
    ldy   #15
    lda   #$43
    jsr   clear_screen_area
    ;byt    $f2
    
    ;rocket 1 is turned off with door
    lda   #$00
    sta   screen7_laser1_current_step + 2  ;set enabled flag to 0
    
    lda   screen7_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen7_door1_handled
++
    ; door 2
    lda   screen7_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen7_door2_handled
+   
    lda   lamp_status_flags + 43
    bne   ++       
    
    ldx   #25
    ldy   #15
    lda   #$43
    jsr   clear_screen_area
    ;byt    $f2

    ;rocket 2 is turned off with door
    lda   #$00
    sta   screen7_laser2_current_step + 2  ;set enabled flag to 0
    
    lda   screen7_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen7_door2_handled
++   
    lda   level_time
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    and   #$01
    sta   bad_lamp1 + 1
    eor   #$01
    sta   bad_lamp2 + 1
    
    ; switching lamps as good/bad
    lda   lamp_status_flags + 43
    beq   +
    ldx   #28
    ldy   #6
bad_lamp1
    lda   #1
    jsr   set_lamp_as_bad
+
    lda   lamp_status_flags + 42
    beq   +

    ldx   #11
    ldy   #6
bad_lamp2
    lda   #1
    jsr   set_lamp_as_bad
+
    rts
    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 8
;--------------------------------------------------------
screen8_actions_init
    lda   #$00
    sta   screen8_door1_handled
    sta   screen8_door2_handled
    sta   screen8_zapper_handled
    sta   screen8_zapper1_current_step
    sta   screen8_zapper1_direction
    
    lda   #$00
    sta   screen8_bush1 + 4 ; reset bush counter
    sta   screen8_bush2 + 4 ; reset bush counter
    sta   screen8_bush3 + 4 ; reset bush counter
    sta   screen8_bush4 + 4 ; reset bush counter
    sta   screen8_bush5 + 4 ; reset bush counter

    lda   #30
    sta   screen8_laser1_current_step
    
    lda   #$01
    sta   screen8_laser1_current_step + 2  ;enabled
    
    jsr   screen8_actions
    jmp   screen8_actions

screen8_door1_handled
    !BYTE 00

screen8_door2_handled
    !BYTE 00

screen8_zapper_handled
    !BYTE 00
    
screen8_laser1
    !WORD screen8_laser1 + 2
    !BYTE 32,8,6, $af ; x,y, width, color
screen8_laser1_current_step
    !BYTE 0,55, 1 ;current step, max step, enabled

screen8_zapper1
    !WORD screen8_zapper1 + 2
    !BYTE 3,20,33 ;x,y, width
screen8_zapper1_direction
    !BYTE 0
screen8_zapper1_current_step
    !BYTE 0,80, 1 ;current step, max step, enabled

screen8_bush1
    !WORD screen8_bush1 + 2
    !BYTE 7,6,0, $9f, 0 ;x,y, phase, color, internal counter

screen8_bush2
    !WORD screen8_bush2 + 2
    !BYTE 29,6,0, $9f, 0 ;x,y, phase, color, internal counter

screen8_bush3
    !WORD screen8_bush3 + 2
    !BYTE 3,12,0, $9f, 0 ;x,y, phase, color, internal counter

screen8_bush4
    !WORD screen8_bush4 + 2
    !BYTE 17,12,0, $9f, 0 ;x,y, phase, color, internal counter

screen8_bush5
    !WORD screen8_bush5 + 2
    !BYTE 21,12,0, $9f, 0 ;x,y, phase, color, internal counter

screen8_actions

    ldx   screen8_bush1
    ldy   screen8_bush1 + 1
    jsr   handle_bush

    ldx   screen8_bush2
    ldy   screen8_bush2 + 1
    jsr   handle_bush

    ldx   screen8_bush3
    ldy   screen8_bush3 + 1
    jsr   handle_bush

    ldx   screen8_bush4
    ldy   screen8_bush4 + 1
    jsr   handle_bush

    ldx   screen8_bush5
    ldy   screen8_bush5 + 1
    jsr   handle_bush
    
    ldx   screen8_laser1
    ldy   screen8_laser1 + 1
    jsr   move_laser
    
    ;door 1
    lda   screen8_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen8_door1_handled
+   
    ldx   #44
-   lda   lamp_status_flags,x
    cmp   #$01      ;lamp is still hanging
    beq   ++       ;do not handle lid, still lamps there to collect
    inx
    cpx   #49       ; 44-49 lamps to collect 
    bne   - 
    
    ldx   #34
    ldy   #3
    lda   #$22
    jsr   clear_screen_area
    ldx   #33
    ldy   #2
    lda   #6
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen8_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen8_door1_handled
++

    ;door 2
    lda   screen8_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen8_door2_handled
+   
    ldx   #49
-   lda   lamp_status_flags,x
    cmp   #$01      ;lamp is still hanging
    beq   ++       ;do not handle lid, still lamps there to collect
    inx
    cpx   #55       ; 49-54 lamps to collect
    bne   - 
    
    ldx   #38
    ldy   #8
    lda   #6
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen8_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen8_door2_handled
++

    ;zapper changes direction when lamps picked up

    lda   screen8_zapper_handled
    beq   + ;needs to check
    cmp   #$01
    beq   +++ ;needs to skip
    dec   screen8_zapper_handled
+   

    lda   lamp_status_flags + 55
    bne   +++
    lda   lamp_status_flags + 56
    bne   +++
    
    lda   #1
    sta   screen8_zapper1_direction
    lda   level_time + 1
    bne   ++   
    lda   level_time
    cmp   #5
    bcs   ++   
    lda   screen8_zapper1_current_step + 1
    sec
    sbc   #$03
    sta   screen8_zapper1_current_step
++
    lda   screen8_zapper_handled
    bne   +++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen8_zapper_handled
+++   
    ldx   screen8_zapper1
    ldy   screen8_zapper1 + 1
    jsr   move_zapper

    rts
    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 9
;--------------------------------------------------------
screen9_actions_init
    lda   #$00
    sta   screen9_door1_handled
    sta   screen9_door2_handled
    sta   screen9_door3_handled
    sta   screen9_door4_handled
    sta   screen9_door5_handled

    lda   #0
    sta   screen9_laser1_current_step
    lda   #36
    sta   screen9_laser2_current_step
    
  
    jsr   screen9_actions
    jmp   screen9_actions

screen9_door1_handled
    !BYTE 00
screen9_door2_handled
    !BYTE 00
screen9_door3_handled
    !BYTE 00
screen9_door4_handled
    !BYTE 00
screen9_door5_handled
    !BYTE 00
        
screen9_laser1
    !WORD screen9_laser1 + 2
    !BYTE 4,8,9, $af ; x,y, width, color
screen9_laser1_current_step
    !BYTE 0,55, 1 ;current step, max step, enabled

screen9_laser2
    !WORD screen9_laser2 + 2
    !BYTE 25,8,9, $af ; x,y, width, color
screen9_laser2_current_step
    !BYTE 0,55, 1 ;current step, max step, enabled

screen9_actions

    jsr   move_conveyor
    jsr   move_conveyor_wall
    
    ldx   screen9_laser1
    ldy   screen9_laser1 + 1
    jsr   move_laser_rocket

    ldx   screen9_laser2
    ldy   screen9_laser2 + 1
    jsr   move_laser_rocket
    
    ;door 1
    ;byt    $f2
    lda   screen9_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen9_door1_handled
+   
    lda   lamp_status_flags + 59
    bne   ++
    
    ldx   #1
    ldy   #18
    lda   #6
    jsr   open_dynamic_door
    
    ;fix door open platform char
    lda   screen_mem_buffer1 + $370
    sta   screen_mem_buffer1 + $371
    lda   screen_mem_buffer2 + $370
    sta   screen_mem_buffer2 + $371
    ;byt    $f2
    
    lda   screen9_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen9_door1_handled
++

    ;door 2
    lda   screen9_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen9_door2_handled
+   
    lda   lamp_status_flags + 55
    bne   ++
    lda   lamp_status_flags + 56
    bne   ++
    
    ldx   #14
    ldy   #12
    lda   #6
    jsr   open_dynamic_door
    ;fix door open platform char
    lda   screen_mem_buffer1 + $2b5 - 40
    sta   screen_mem_buffer1 + $2b6 - 40
    lda   screen_mem_buffer2 + $2b5 - 40
    sta   screen_mem_buffer2 + $2b6 - 40
    ;byt    $f2
    
    lda   screen9_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen9_door2_handled
++

    ;door 3
    lda   screen9_door3_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen9_door3_handled
+   
    lda   lamp_status_flags + 57
    bne   ++
    lda   lamp_status_flags + 58
    bne   ++
    
    ldx   #25
    ldy   #12
    lda   #6
    jsr   open_dynamic_door
    ;fix door open platform char
    lda   screen_mem_buffer1 + $2c2 - 40
    sta   screen_mem_buffer1 + $2c1 - 40
    lda   screen_mem_buffer2 + $2c2 - 40
    sta   screen_mem_buffer2 + $2c1 - 40
    ;byt    $f2
    
    lda   screen9_door3_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen9_door3_handled
++
    ;door 4
    lda   screen9_door4_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen9_door4_handled
+   
    lda   lamp_status_flags + 60
    bne   ++
    
    ldx   #38
    ldy   #18
    lda   #6
    jsr   open_dynamic_door
    ;fix door open platform char
    lda   screen_mem_buffer1 + $397
    sta   screen_mem_buffer1 + $396
    lda   screen_mem_buffer2 + $397
    sta   screen_mem_buffer2 + $396
    ;byt    $f2
    
    lda   screen9_door4_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen9_door4_handled
++

    ;door 5
    lda   screen9_door5_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen9_door5_handled
+   
    lda   lamp_status_flags + 63
    bne   ++
    lda   lamp_status_flags + 64
    bne   ++
    
    ldx   #38
    ldy   #2
    lda   #6
    jsr   open_dynamic_door
    ;fix door open platform char
    lda   screen_mem_buffer1 + $13f
    sta   screen_mem_buffer1 + $13e
    lda   screen_mem_buffer2 + $13f
    sta   screen_mem_buffer2 + $13e
    ;byt    $f2
    
    lda   screen9_door5_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen9_door5_handled
++
    rts
    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 10
;--------------------------------------------------------
screen10_actions_init
    lda   #$00
    sta   screen10_door1_handled
    sta   screen10_door2_handled
    sta   screen10_zapper_handled
    sta   screen10_zapper1_current_step
    sta   screen10_zapper1_direction
    
    lda   #0
    sta   screen10_laser1_current_step
    lda   #5
    sta   screen10_laser2_current_step
    
  
    jsr   screen10_actions
    jmp   screen10_actions

screen10_door1_handled
    !BYTE 00
screen10_door2_handled
    !BYTE 00
screen10_zapper_handled
    !BYTE 00
  
screen10_zapper1
    !WORD screen10_zapper1 + 2
    !BYTE 2,22,23 ;x,y, width
screen10_zapper1_direction
    !BYTE 0
screen10_zapper1_current_step
    !BYTE 0,50, 1 ;current step, max step, enabled
    
screen10_laser1
    !WORD screen10_laser1 + 2
    !BYTE 14,9,8, $9f ; x,y, width, color
screen10_laser1_current_step
    !BYTE 0,75, 1 ;current step, max step, enabled

screen10_laser2
    !WORD screen10_laser2 + 2
    !BYTE 14,11,8, $9f ; x,y, width, color
screen10_laser2_current_step
    !BYTE 0,75, 1 ;current step, max step, enabled

screen10_actions
    jsr   move_conveyor
    jsr   move_conveyor_wall
    
    ldx   screen10_laser1
    ldy   screen10_laser1 + 1
    jsr   move_laser

    ldx   screen10_laser2
    ldy   screen10_laser2 + 1
    jsr   move_laser
    
    ;door 1
    ;byt    $f2
    lda   screen10_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen10_door1_handled
+   
    lda   lamp_status_flags + 61
    bne   ++
    
    ldx   #23
    ldy   #12
    lda   #6
    jsr   open_dynamic_door
    ;fix door open platform char
    lda   screen_mem_buffer1 + $2be - 40
    sta   screen_mem_buffer1 + $2bf - 40
    lda   screen_mem_buffer2 + $2be - 40
    sta   screen_mem_buffer2 + $2bf - 40
    ;byt    $f2
    
    lda   screen10_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen10_door1_handled
++

    ;door 2
    ;byt    $f2
    lda   screen10_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen10_door2_handled
+   
    lda   lamp_status_flags + 65
    bne   ++
    
    ;remove sword from conveyor
    ldx   #35
    ldy   #2
    lda   #$01    ;wide conveyor
    jsr   restore_conveyor_block
    ldx   #35
    ldy   #2
    lda   #(4 + DOOR_TO_WARP_1 + DOOR_IS_HORIZONTAL)
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen10_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen10_door2_handled
++

    lda   screen10_zapper_handled
    beq   + ;needs to check
    cmp   #$01
    beq   +++ ;needs to skip
    dec   screen10_zapper_handled
+   

    lda   lamp_status_flags + 63
    bne   +++
    lda   lamp_status_flags + 64
    bne   +++
    
    ;byt    $f2
    lda   #1
    sta   screen10_zapper1_direction
    lda   level_time + 1
    bne   ++   
    lda   level_time
    cmp   #5
    bcs   ++   
    lda   screen10_zapper1_current_step + 1
    sec
    sbc   #$03
    sta   screen10_zapper1_current_step
++
    lda   screen10_zapper_handled
    bne   +++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen10_zapper_handled
+++   
    ; move zapper
    ldx   screen10_zapper1
    ldy   screen10_zapper1 + 1
    jsr   move_zapper
    rts
        
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 11
;--------------------------------------------------------
screen11_actions_init
  
    lda   #$00
    sta   screen11_door1_handled
    jsr   copy_underground_chars_to_charset
    jsr   init_warp_chars_for_shadow_doors
    
    jsr   set_bush_root_2
    jsr   screen11_actions
    jmp   screen11_actions

screen11_door1_handled
    !BYTE 00
    
screen11_bush1
    !WORD screen11_bush1 + 2
    !BYTE 9,21,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush2
    !WORD screen11_bush2 + 2
    !BYTE 21,21,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush3
    !WORD screen11_bush3 + 2
    !BYTE 34,21,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush4
    !WORD screen11_bush4 + 2
    !BYTE 21,15,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush5
    !WORD screen11_bush5 + 2
    !BYTE 34,15,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush6
    !WORD screen11_bush6 + 2
    !BYTE 19,9,0, $de, 0 ;x,y, phase, color, internal counter

screen11_bush7
    !WORD screen11_bush7 + 2
    !BYTE 24,9,0, $de, 0 ;x,y, phase, color, internal counter
    
screen11_actions

    ldx   screen11_bush1
    ldy   screen11_bush1 + 1
    jsr   handle_bush

    ldx   screen11_bush2
    ldy   screen11_bush2 + 1
    jsr   handle_bush

    ldx   screen11_bush3
    ldy   screen11_bush3 + 1
    jsr   handle_bush

    ldx   screen11_bush4
    ldy   screen11_bush4 + 1
    jsr   handle_bush

    ldx   screen11_bush5
    ldy   screen11_bush5 + 1
    jsr   handle_bush

    ldx   screen11_bush6
    ldy   screen11_bush6 + 1
    jsr   handle_bush

    ldx   screen11_bush7
    ldy   screen11_bush7 + 1
    jsr   handle_bush

;door 1
    ;byt    $f2
    lda   screen11_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen11_door1_handled
+   
    lda   lamp_status_flags + 66
    bne   ++
    lda   lamp_status_flags + 67
    bne   ++
    lda   lamp_status_flags + 68
    bne   ++
    
    lda   #33
    sta   $d0
    ldx   #37
    ldy   #6
    sty   $d1
    lda   #$24
    jsr   copy_screen_area
    ;byt    $f2
    
    lda   screen11_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen11_door1_handled
++    
    rts
      
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 12
;--------------------------------------------------------
screen12_actions_init
  
    ;jsr    copy_underground_chars_to_charset
    ;jsr    init_warp_chars_for_shadow_doors
    
    ;jsr    set_bush_root_2
    rts
    
    
screen12_bush1
    !WORD screen12_bush1 + 2
    !BYTE 10,7,0, $de, 0 ;x,y, phase, color, internal counter

screen12_bush2
    !WORD screen12_bush2 + 2
    !BYTE 29,7,0, $de, 0 ;x,y, phase, color, internal counter

screen12_bush3
    !WORD screen12_bush3 + 2
    !BYTE 15,21,0, $de, 0 ;x,y, phase, color, internal counter

screen12_bush4
    !WORD screen12_bush4 + 2
    !BYTE 24,21,0, $de, 0 ;x,y, phase, color, internal counter

screen12_actions

    jsr   move_conveyor
    jsr   handle_one_char_conveyors
    
    ldx   screen12_bush1
    ldy   screen12_bush1 + 1
    jsr   handle_bush

    ldx   screen12_bush2
    ldy   screen12_bush2 + 1
    jsr   handle_bush

    ldx   screen12_bush3
    ldy   screen12_bush3 + 1
    jsr   handle_bush

    ldx   screen12_bush4
    ldy   screen12_bush4 + 1
    jsr   handle_bush

    rts
      
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 13
;--------------------------------------------------------
screen13_actions_init
  
    lda   #$00
    sta   screen13_door1_handled
    sta   screen13_door2_handled
    sta   screen13_door3_handled
    sta   screen15_final_warp_handled

    jsr   screen13_actions
    jmp   screen13_actions

screen13_door1_handled
    !BYTE   0
screen13_door2_handled
    !BYTE   0
screen13_door3_handled
    !BYTE   0
    
screen13_bush1
    !WORD screen13_bush1 + 2
    !BYTE 15,9,0, $de, 0 ;x,y, phase, color, internal counter

screen13_bush2
    !WORD screen13_bush2 + 2
    !BYTE 19,9,0, $de, 0 ;x,y, phase, color, internal counter

screen13_bush3
    !WORD screen13_bush3 + 2
    !BYTE 15,15,0, $de, 0 ;x,y, phase, color, internal counter

screen13_bush4
    !WORD screen13_bush4 + 2
    !BYTE 19,15,0, $de, 0 ;x,y, phase, color, internal counter

screen13_bush5
    !WORD screen13_bush5 + 2
    !BYTE 15,21,0, $de, 0 ;x,y, phase, color, internal counter

screen13_bush6
    !WORD screen13_bush6 + 2
    !BYTE 19,21,0, $de, 0 ;x,y, phase, color, internal counter

    
screen13_actions

    ;door 1
    ;byt    $f2
    lda   screen13_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen13_door1_handled
+   
    lda   lamp_status_flags + 73
    bne   ++
    
    lda   #$06
    sta   $d1
    ldx   #37
    stx   $d0
    ldy   #12
    lda   #$24
    jsr   copy_screen_area
    ;byt    $f2
    
    lda   screen13_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen13_door1_handled
++

    ;door 2
    ;byt    $f2
    lda   screen13_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen13_door2_handled
+   
    lda   lamp_status_flags + 74
    bne   ++
    
    lda   #$06
    sta   $d1
    ldx   #37
    stx   $d0
    ldy   #18
    lda   #$24
    jsr   copy_screen_area
    ;byt    $f2
    
    lda   screen13_door2_handled
    bne   ++; no need to set counter again. already set

    ldx   #open_door_screen_steps
    stx   screen13_door2_handled
++ 

    ;handle bush
    ldx   screen13_bush1
    ldy   screen13_bush1 + 1
    jsr   handle_bush

    ldx   screen13_bush2
    ldy   screen13_bush2 + 1
    jsr   handle_bush

    ldx   screen13_bush3
    ldy   screen13_bush3 + 1
    jsr   handle_bush

    ldx   screen13_bush4
    ldy   screen13_bush4 + 1
    jsr   handle_bush

    ldx   screen13_bush5
    ldy   screen13_bush5 + 1
    jsr   handle_bush

    ldx   screen13_bush6
    ldy   screen13_bush6 + 1
    jsr   handle_bush

    ;final warp redirection
    ;byt    $f2
    lda   screen15_final_warp_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen15_final_warp_handled
+   
    ldx   #72
-   lda   lamp_status_flags, x
    bne   ++
    inx
    cpx   #82
    bne   -
    
    ldx   #39
    ldy   #12
    lda   #(4 + DOOR_TO_WARP_4)
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen15_final_warp_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen15_final_warp_handled
++
    rts
        
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 14
;--------------------------------------------------------
screen14_actions_init
    lda   #$00
    sta   screen15_final_warp_handled
  
    jsr   screen14_actions
    jmp   screen14_actions

    
screen14_bush1
    !WORD screen14_bush1 + 2
    !BYTE 14,15,0, $de, 0 ;x,y, phase, color, internal counter

screen14_bush2
    !WORD screen14_bush2 + 2
    !BYTE 25,15,0, $de, 0 ;x,y, phase, color, internal counter

screen14_bush3
    !WORD screen14_bush3 + 2
    !BYTE 14,21,0, $de, 0 ;x,y, phase, color, internal counter

screen14_bush4
    !WORD screen14_bush4 + 2
    !BYTE 25,21,0, $de, 0 ;x,y, phase, color, internal counter
  
screen14_actions

    ;handle bush
    ldx   screen14_bush1
    ldy   screen14_bush1 + 1
    jsr   handle_bush

    ldx   screen14_bush2
    ldy   screen14_bush2 + 1
    jsr   handle_bush

    ldx   screen14_bush3
    ldy   screen14_bush3 + 1
    jsr   handle_bush

    ldx   screen14_bush4
    ldy   screen14_bush4 + 1
    jsr   handle_bush

    ;final warp redirection
    ;byt    $f2
    lda   screen15_final_warp_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen15_final_warp_handled
+   
    ldx   #72
-   lda   lamp_status_flags, x
    bne   ++
    inx
    cpx   #82
    bne   -
    
    ldx   #39
    ldy   #6
    lda   #(4 + DOOR_TO_WARP_4)
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen15_final_warp_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen15_final_warp_handled
++
    rts 
      
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 15
;--------------------------------------------------------
screen15_actions_init
  
    lda   #$00
    sta   screen15_final_warp_handled
    sta   screen15_yinyang_pickup_handled
    jsr   screen15_actions
    jmp   screen15_actions

    
screen15_bush1
    !WORD screen15_bush1 + 2
    !BYTE 10,9,0, $de, 0 ;x,y, phase, color, internal counter

screen15_bush2
    !WORD screen15_bush2 + 2
    !BYTE 28,9,0, $de, 0 ;x,y, phase, color, internal counter

screen15_bush3
    !WORD screen15_bush3 + 2
    !BYTE 16,15,0, $de, 0 ;x,y, phase, color, internal counter

screen15_bush4
    !WORD screen15_bush4 + 2
    !BYTE 25,15,0, $de, 0 ;x,y, phase, color, internal counter

screen15_bush5
    !WORD screen15_bush5 + 2
    !BYTE 16,21,0, $de, 0 ;x,y, phase, color, internal counter

screen15_bush6
    !WORD screen15_bush6 + 2
    !BYTE 25,21,0, $de, 0 ;x,y, phase, color, internal counter

screen15_final_warp_handled
    !BYTE   00

screen15_yinyang_pickup_handled
    !BYTE   00
    
screen15_actions

    ;handle bush
    ldx   screen15_bush1
    ldy   screen15_bush1 + 1
    jsr   handle_bush

    ldx   screen15_bush2
    ldy   screen15_bush2 + 1
    jsr   handle_bush

    ldx   screen15_bush3
    ldy   screen15_bush3 + 1
    jsr   handle_bush

    ldx   screen15_bush4
    ldy   screen15_bush4 + 1
    jsr   handle_bush

    ldx   screen15_bush5
    ldy   screen15_bush5 + 1
    jsr   handle_bush

    ldx   screen15_bush6
    ldy   screen15_bush6 + 1
    jsr   handle_bush

    ;yinyang pickup handled
    ;byt    $f2
    ;handle yinyang pickup
    lda   lamp_status_flags + 81
    beq   +
    
    lda   sprite1_data_y
    cmp   #$a8
    bcc   ++
    lda   sprite1_data_x
    cmp   #$9c
    bcc   ++
    
    lda   #$00
    sta   lamp_status_flags + 81  ;yinyang sets a lamp pick
    jsr   add_one_life
    jsr   show_info_bar


+   ldx   #36   
    ldy   #18
    lda   #$24
    jsr   clear_screen_area
++ 

    ;final warp redirection
    ;byt    $f2
    lda   screen15_final_warp_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen15_final_warp_handled

+   
    ldx   #72
-   lda   lamp_status_flags, x
    bne   ++
    inx
    cpx   #82
    bne   -
    
    ldx   #0
    ldy   #12
    lda   #(4 + DOOR_TO_WARP_4)
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen15_final_warp_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen15_final_warp_handled
++
    rts 
  
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 16
;--------------------------------------------------------
screen16_actions_init

    ;slow down zapper
    jsr   slow_down_zapper
    lda   #$00
    sta   screen16_zapper1_current_step
    sta   screen16_zapper3_current_step
    sta   screen16_zapper4_current_step
    sta   screen16_zapper5_current_step
    sta   screen16_zapper6_current_step
    sta   screen16_zapper7_current_step
    lda   #40
    sta   screen16_zapper8_current_step
    lda   #31
    sta   screen16_zapper2_current_step
    rts
  
screen16_zapper1
    !WORD screen16_zapper1 + 2
    !BYTE 4,7,30 ;x,y, width
screen16_zapper1_direction
    !BYTE 0
screen16_zapper1_current_step
    !BYTE 0,65, 1 ;current step, max step, enabled

screen16_zapper2
    !WORD screen16_zapper2 + 2
    !BYTE 4,7,30 ;x,y, width
screen16_zapper2_direction
    !BYTE 0
screen16_zapper2_current_step
    !BYTE 31,65, 1 ;current step, max step, enabled
  
screen16_zapper3
    !WORD screen16_zapper3 + 2
    !BYTE 4,12,16 ;x,y, width
screen16_zapper3_direction
    !BYTE 0
screen16_zapper3_current_step
    !BYTE 0,30, 1 ;current step, max step, enabled

screen16_zapper4
    !WORD screen16_zapper4 + 2
    !BYTE 18,12,17 ;x,y, width
screen16_zapper4_direction
    !BYTE 1
screen16_zapper4_current_step
    !BYTE 0,31, 1 ;current step, max step, enabled
  
screen16_zapper5
    !WORD screen16_zapper5 + 2
    !BYTE 4,17,17 ;x,y, width
screen16_zapper5_direction
    !BYTE 1
screen16_zapper5_current_step
    !BYTE 0,35, 1 ;current step, max step, enabled

screen16_zapper6
    !WORD screen16_zapper6 + 2
    !BYTE 18,17,16 ;x,y, width
screen16_zapper6_direction
    !BYTE 0
screen16_zapper6_current_step
    !BYTE 0,34, 1 ;current step, max step, enabled
  
screen16_zapper7
    !WORD screen16_zapper7 + 2
    !BYTE 0,22,34 ;x,y, width
screen16_zapper7_direction
    !BYTE 1
screen16_zapper7_current_step
    !BYTE 0,80, 1 ;current step, max step, enabled

screen16_zapper8
    !WORD screen16_zapper8 + 2
    !BYTE 0,22,34 ;x,y, width
screen16_zapper8_direction
    !BYTE 1
screen16_zapper8_current_step
    !BYTE 40,80, 1 ;current step, max step, enabled 
    
screen16_actions

    ; move zapper
    ldx   screen16_zapper1
    ldy   screen16_zapper1 + 1
    jsr   move_zapper

    ldx   screen16_zapper2
    ldy   screen16_zapper2 + 1
    jsr   move_zapper

    ldx   screen16_zapper3
    ldy   screen16_zapper3 + 1
    jsr   move_zapper

    ldx   screen16_zapper4
    ldy   screen16_zapper4 + 1
    jsr   move_zapper

    ldx   screen16_zapper5
    ldy   screen16_zapper5 + 1
    jsr   move_zapper

    ldx   screen16_zapper6
    ldy   screen16_zapper6 + 1
    jsr   move_zapper

    ldx   screen16_zapper7
    ldy   screen16_zapper7 + 1
    jsr   move_zapper

    ldx   screen16_zapper8
    ldy   screen16_zapper8 + 1
    jsr   move_zapper

    rts
    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 17
;--------------------------------------------------------
screen17_actions_init
    lda   #$00
    sta   screen17_door1_handled
    sta   screen17_door2_handled
    sta   screen17_door3_handled
    jsr   screen17_actions
    jmp   screen17_actions

screen17_door1_handled
    !BYTE   0
screen17_door2_handled
    !BYTE   0
screen17_door3_handled
    !BYTE   0

screen17_actions

    ;door 1
    ;byt    $f2
    lda   screen17_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen17_door1_handled
+   
    
    lda   lamp_status_flags + 82
    bne   ++
    
    lda   #15
    sta   $d0
    lda   #8
    sta   $d1

    ldx   #17
    ldy   #4
    lda   #$14
    jsr   copy_screen_area
    ;byt    $f2
    lda   screen_mem_buffer1 + $128 - $400
    sta   screen_mem_buffer1 + $129 - $400
    sta   screen_mem_buffer2 + $129 - $400
    
    lda   screen17_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps 
    stx   screen17_door1_handled
++
    ;door 2
    ;byt    $f2
    lda   screen17_door2_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen17_door2_handled
+   
    
    lda   lamp_status_flags + 83
    bne   ++
    lda   lamp_status_flags + 84
    bne   ++
    lda   lamp_status_flags + 86
    bne   ++
    
    lda   #15
    sta   $d0
    lda   #8
    sta   $d1

    ldx   #23
    ldy   #4
    lda   #$14
    jsr   copy_screen_area
    lda   screen_mem_buffer1 + $130 - $400
    sta   screen_mem_buffer1 + $12f - $400
    sta   screen_mem_buffer2 + $12f - $400
    ;byt    $f2
    
    lda   screen17_door2_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen17_door2_handled    
++
    ;door 3
    ;byt    $f2
    lda   screen17_door3_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen17_door3_handled
+   
    ldx   #82
-   lda   lamp_status_flags, x
    bne   ++
    inx
    cpx   #88
    bne   -
    
    ldx   #39
    ldy   #12
    lda   #(5 + DOOR_TO_WARP_1)
    jsr   open_dynamic_door
    ;byt    $f2
    
    lda   screen17_door3_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps
    stx   screen17_door3_handled
++
    rts
    
;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 18
;--------------------------------------------------------
screen18_actions_init
    ;jsr    copy_surface_world_chars_to_charset
    jsr   copy_underground_chars_to_charset
    jsr   init_warp_chars_for_shadow_doors
    lda   #$00
    sta   screen18_zapper1_current_step
    sta   screen18_door1_handled
    sta   screen18_door2_handled
    sta   screen18_door3_handled
    sta   screen18_laser1_current_step
    sta   screen18_laser2_current_step
    jsr   speed_up_zapper
    lda   #35
    sta   screen18_laser3_current_step
    ;lda    #26
    ;sta    screen18_laser1_current_step - 2
    ;sta    screen18_laser3_current_step - 2
    
    ldx   #0
-   lda   grabber_char_data,x
    sta   character_set_mem_buffer1 + 7*8,x
    sta   character_set_mem_buffer2 + 7*8,x
    inx
    cpx   #8
    bne   -
    jmp   screen18_actions

grabber_char_data
    !BYTE   $aa,$aa,$04,$04,$ff,$ff,0,0
    
screen18_door1_handled
    !BYTE   0
screen18_door2_handled
    !BYTE   0
screen18_door3_handled
    !BYTE   0

screen18_laser1
    !WORD screen18_laser1 + 2
    !BYTE 6,12,33, $2f ; x,y, width, color
screen18_laser1_current_step
    !BYTE 0,75, 1 ;current step, max step, enabled

screen18_laser2
    !WORD screen18_laser2 + 2
    !BYTE 6,4,31, $2f ; x,y, width, color
screen18_laser2_current_step
    !BYTE 0,85, 1 ;current step, max step, enabled

screen18_laser3
    !WORD screen18_laser3 + 2
    !BYTE 6,16,33, $2f ; x,y, width, color
screen18_laser3_current_step
    !BYTE 0,75, 1 ;current step, max step, enabled

screen18_zapper1
    !WORD screen18_zapper1 + 2
    !BYTE 0,8,29 ;x,y, width
screen18_zapper1_direction
    !BYTE 0
screen18_zapper1_current_step
    !BYTE 0,70, 1 ;current step, max step, enabled  

screen18_actions

    ; move zapper
    ldx   screen18_zapper1
    ldy   screen18_zapper1 + 1
    jsr   move_zapper


    ldx   screen18_laser1
    ldy   screen18_laser1 + 1
    jsr   move_laser_rocket

    ldx   screen18_laser2
    ldy   screen18_laser2 + 1
    jsr   move_laser_rocket

    ldx   screen18_laser3
    ldy   screen18_laser3 + 1
    jsr   move_laser_rocket

    ;door 1
    ;byt    $f2
    lda   screen18_door1_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen18_door1_handled
+   
    
    lda   lamp_status_flags + 88
    bne   ++
    
    lda   #3
    sta   $d0
    lda   #10
    sta   $d1

    ldx   #24
    ldy   #18
    lda   #$32
    jsr   copy_screen_area

    ;lda    #14
    ;sta    $d0
    lda   #11
    sta   $d1
    ldx   #24
    ldy   #15
    lda   #$31
    jsr   copy_screen_area
    ;byt    $f2
    
    lda   screen18_door1_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps 
    stx   screen18_door1_handled
++

    ;door 3
    ;byt    $f2
    lda   screen18_door3_handled
    beq   + ;needs to check
    cmp   #$01
    beq   ++  ;needs to skip
    dec   screen18_door3_handled
+   

    lda   lamp_status_flags + 89
    bne   ++
    lda   lamp_status_flags + 90
    bne   ++
    ;make laser trajectory longer
    ;lda    #33
    ;sta    screen18_laser1_current_step - 2
    ;sta    screen18_laser3_current_step - 2
    lda   #3
    sta   $d0
    lda   #10
    sta   $d1

    ldx   #37
    ldy   #18
    lda   #$21
    jsr   copy_screen_area
    
    ;byt    $f2

    lda   screen18_door3_handled
    bne   ++; no need to set counter again. already set
    ldx   #open_door_screen_steps 
    stx   screen18_door3_handled
++       
    rts

;--------------------------------------------------------
;   EXECUTION LOGIC FOR THE SCREEN 19 (CONGRATS SCREEN)
;--------------------------------------------------------
congrats_screen
    sei
    lda   #$0b
    jsr   show_hide_screen
    jsr   add_one_life
    jsr   retain_player_score  ; get score from screen and store for later use
    
    ldx   #$00
-   lda   #$20
    sta   screen_mem_buffer1,x
    sta   screen_mem_buffer2,x
    sta   screen_mem_buffer1 + $100,x
    sta   screen_mem_buffer2 + $100,x
    sta   screen_mem_buffer1 + $200,x
    sta   screen_mem_buffer2 + $200,x
    sta   screen_mem_buffer1 + $300,x
    sta   screen_mem_buffer2 + $300,x
    lda   #$71
    sta   screen_mem_buffer1 - $400,x
    sta   screen_mem_buffer2 - $400,x
    sta   screen_mem_buffer1 - $300,x
    sta   screen_mem_buffer2 - $300,x
    
    inx
    bne   -
    
    
    lda   $ff13
    sta   $04
    lda   #$c4
    sta   $ff12
    lda   #$d1
    sta   $ff13
    lda   #title_scree_blue
    sta   $ff15
    sta   $ff19

grats_line1_pos = 5 * 40 + 12   
grats_line2_pos = 7 * 40 + 5    
        
    ldx   #$00
-   lda   grats_text,x
    sta   screen_mem_buffer1 + grats_line1_pos,x
    sta   screen_mem_buffer2 + grats_line1_pos,x
    inx
    cpx   #15
    bne   -

    ldx   #$00
-   lda   grats_text2,x
    sta   screen_mem_buffer1 + grats_line2_pos,x
    sta   screen_mem_buffer2 + grats_line2_pos,x
    inx
    cpx   #30
    bne   -


    lda   #$1b
    jsr   show_hide_screen
    
    lda   #$1f
    jsr   wait_a_little
    
    lda   #$0b
    jsr   show_hide_screen
    jsr   clear_screen
    lda   #$00
    sta   $ff19
    lda   $04
    sta   $ff13
    lda   #$08
    sta   $ff12
        
    lda   current_player
    jsr   show_player_score
    
    ;restart levels
    ldx   #$00
    txa
-   sta   room_visit_check_for_scoring,x
    inx
    cpx   #number_of_rooms
    bne   -

    ; set all lamp status to "on_screen"
    ldx   #$00
    lda   #$01
-   sta   lamp_status_flags,x
    inx
    cpx   #number_of_lamps
    bne   -
    
    lda   #$01
    sta   game_is_in_hard_mode    
    
    lda   #$01  ;set the first level to "visited" to avoid scoring
    sta   room_visit_check_for_scoring
    sta   room_visit_check_for_scoring + 1
    
    jsr   copy_surface_world_chars_to_charset
    jsr   init_warp_chars_for_dev_mode
    
    lda   #1    ;start on screen index
    sta   current_screen_warp1_target
    lda   #$22
    sta   current_screen_warp1_target_initial_x
    lda   #$bb
    sta   current_screen_warp1_target_initial_y
    lda   #$01
    sta   last_player_direction
    lda   #$01  ; warp target 1
    jsr   player_warped
    
    lda   #$1b
    jsr   show_hide_screen
    cli
    rts


grats_text    
    !BYTE   $3,$f,$e,$7,$12,$1,$14,$15,$0c,$01,$14,$9,$f,$e,$13
grats_text2   

    !BYTE   $19,$f,$15,$20,$4,$5,$6,$5,$1,$14,$5,$4,$20,$14,$8,$5,$20,$5,$16,$9,$c,$20,$13,$f,$12,$3,$5,$12,$5,$12
    
    
; ==================== Retro Sprite Workshop Project (I:\plus4\Microassembler\bruce lee\bruce lee sprites.inc) ========================
; Generated On:       2022. 03. 13. 8:29:59
; Project Name:       Bruce Lee
; Project Comments:   
; Target Platform:    Commodore 16/Plus4
; Project Created On: 2022.02.12 11:22:33

; ==================== Sprite 1 ========================
; Sprite ID:       bruce_standing_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=2; PosY=2
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_standing_right_WIDTH_PX    = 16
bruce_standing_right_HEIGHT_PX   = 32
bruce_standing_right_BIT_PER_PX  = 2
bruce_standing_right_INDEX       = 0
bruce_standing_right_NUM_FRAMES  = 2
bruce_standing_right_frame1:
                            !BYTE $00, $00, $00, $05, $17, $1f, $1d, $1f, $0f, $0f, $3f, $3f, $3d, $35, $0f, $05, $05, $04, $04, $04, $04, $04, $14, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $c0, $c0, $c0, $00, $00, $c0, $f1, $fd, $c0, $40, $40, $50, $10, $10, $10, $10, $14, $15, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_standing_right_frame2:
                            !BYTE $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $70, $f4, $dc, $fc, $fc, $f0, $f0, $fc, $df, $5f, $fc, $54, $54, $45, $41, $41, $41, $41, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $d0, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 2 ========================
; Sprite ID:       bruce_running_right_frame1
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=164; PosY=42
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

bruce_running_right_frame1_WIDTH_PX    = 24
bruce_running_right_frame1_HEIGHT_PX   = 32
bruce_running_right_frame1_BIT_PER_PX  = 2
bruce_running_right_frame1_INDEX       = 1
bruce_running_right_frame1_NUM_FRAMES  = 1
bruce_running_right_frame1:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $3f, $33, $33, $11, $11, $15, $05, $01, $05, $50, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $5f, $5d, $5f, $7f, $fc, $f0, $fc, $fc, $fc, $4d, $41, $40, $10, $14, $04, $04, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 3 ========================
; Sprite ID:       bruce_running_right_frame2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=192; PosY=41
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

bruce_running_right_frame2_WIDTH_PX    = 24
bruce_running_right_frame2_HEIGHT_PX   = 32
bruce_running_right_frame2_BIT_PER_PX  = 2
bruce_running_right_frame2_INDEX       = 2
bruce_running_right_frame2_NUM_FRAMES  = 1
bruce_running_right_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $05, $05, $07, $0f, $3f, $3f, $3f, $7f, $5d, $55, $55, $14, $14, $10, $50, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $50, $f0, $d0, $f0, $f0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 4 ========================
; Sprite ID:       bruce_jumping1_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=106; PosY=7
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jumping1_right_WIDTH_PX    = 16
bruce_jumping1_right_HEIGHT_PX   = 32
bruce_jumping1_right_BIT_PER_PX  = 2
bruce_jumping1_right_INDEX       = 3
bruce_jumping1_right_NUM_FRAMES  = 2
bruce_jumping1_right_frame1:
                            !BYTE $00, $00, $00, $00, $01, $01, $01, $01, $00, $0f, $3f, $33, $33, $11, $11, $01, $01, $01, $15, $55, $41, $44, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $7c, $74, $7c, $fc, $fc, $f0, $f0, $f0, $f0, $c0, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

bruce_jumping1_right_frame2:
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $01, $01, $00, $00, $00, $01, $05, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $17, $17, $17, $1f, $0f, $ff, $ff, $3f, $3f, $1c, $14, $14, $14, $10, $50, $50, $10, $40, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $40, $c0, $40, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 5 ========================
; Sprite ID:       bruce_jumping2_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=144; PosY=3
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jumping2_right_WIDTH_PX    = 16
bruce_jumping2_right_HEIGHT_PX   = 32
bruce_jumping2_right_BIT_PER_PX  = 2
bruce_jumping2_right_INDEX       = 4
bruce_jumping2_right_NUM_FRAMES  = 2
bruce_jumping2_right_frame1:
                            !BYTE $00, $00, $00, $00, $01, $05, $05, $05, $07, $0f, $3f, $0f, $03, $03, $01, $01, $01, $05, $05, $04, $14, $10, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f0, $d0, $f4, $f4, $c0, $d0, $d0, $c0, $c0, $c0, $54, $54, $04, $10, $10, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jumping2_right_frame2:
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $05, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $5f, $5d, $5f, $7f, $fc, $fd, $fd, $3c, $3c, $1c, $15, $15, $50, $51, $41, $44, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 6 ========================
; Sprite ID:       bruce_pain_drop1_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=122; PosY=120
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_pain_drop1_right_WIDTH_PX    = 16
bruce_pain_drop1_right_HEIGHT_PX   = 32
bruce_pain_drop1_right_BIT_PER_PX  = 2
bruce_pain_drop1_right_INDEX       = 5
bruce_pain_drop1_right_NUM_FRAMES  = 2
bruce_pain_drop1_right_frame1:
                              !BYTE $00, $00, $00, $14, $5c, $7d, $77, $7f, $3f, $3c, $fc, $ff, $ff, $f7, $37, $15, $15, $11, $05, $04, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $34, $04, $00, $00, $40, $40, $50, $54, $54, $10, $00, $00, $00, $00, $00, $00, $00, $00
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_pain_drop1_right_frame2:
                              !BYTE $00, $00, $00, $01, $05, $07, $07, $07, $03, $03, $0f, $0f, $0f, $0f, $03, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $c0, $d0, $70, $f0, $f0, $c0, $c0, $f0, $fc, $7f, $73, $50, $50, $10, $54, $44, $15, $15, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 7 ========================
; Sprite ID:       bruce_knocked_down_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=150; PosY=115
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

bruce_knocked_down_right_WIDTH_PX    = 32
bruce_knocked_down_right_HEIGHT_PX   = 32
bruce_knocked_down_right_BIT_PER_PX  = 2
bruce_knocked_down_right_INDEX       = 6
bruce_knocked_down_right_NUM_FRAMES  = 4
bruce_knocked_down_right_frame1:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $5f, $7d, $77, $3f, $0f, $3f, $3f, $ff, $f3, $c3, $c0, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $fc, $5f, $7d, $fd, $f5, $d5, $55, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $55, $05, $05, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_right_frame2:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $17, $1f, $1d, $0f, $03, $0f, $0f, $3f, $3c, $30, $30, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $c0, $40, $f0, $f0, $fc, $ff, $d7, $df, $ff, $fd, $35, $15, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $d4, $54, $55, $41, $41, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $54, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_right_frame3:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $07, $07, $03, $00, $03, $03, $0f, $0f, $0c, $0c, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f0, $d0, $7c, $fc, $ff, $ff, $f5, $f7, $3f, $3f, $0d, $05, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c5, $f5, $d5, $d5, $50, $50, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $55, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_right_frame4:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $03, $03, $03, $03, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $7c, $f4, $df, $ff, $3f, $ff, $fd, $fd, $cf, $0f, $03, $41, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f1, $7d, $f5, $f5, $d4, $54, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $54, $14, $14, $55, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 8 ========================
; Sprite ID:       bruce_kick1_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=230; PosY=118
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_kick1_right_WIDTH_PX    = 16
bruce_kick1_right_HEIGHT_PX   = 32
bruce_kick1_right_BIT_PER_PX  = 2
bruce_kick1_right_INDEX       = 7
bruce_kick1_right_NUM_FRAMES  = 2
bruce_kick1_right_frame1:
                         !BYTE $00, $00, $14, $5f, $7d, $77, $7f, $3f, $0f, $3f, $3f, $3f, $33, $33, $31, $11, $15, $05, $05, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $ff, $ff, $f3, $f1, $f5, $d0, $54, $55, $55, $45, $05, $14, $54, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick1_right_frame2:
                         !BYTE $00, $00, $01, $05, $07, $07, $07, $03, $00, $03, $03, $03, $03, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $f0, $dc, $7c, $fc, $ff, $ff, $ff, $ff, $ff, $3d, $35, $15, $15, $54, $50, $51, $55, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $30, $10, $50, $00, $40, $50, $50, $50, $50, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 9 ========================
; Sprite ID:       bruce_kick2_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=256; PosY=109
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

bruce_kick2_right_WIDTH_PX    = 32
bruce_kick2_right_HEIGHT_PX   = 32
bruce_kick2_right_BIT_PER_PX  = 2
bruce_kick2_right_INDEX       = 8
bruce_kick2_right_NUM_FRAMES  = 4
bruce_kick2_right_frame1:
                         !BYTE $01, $17, $1f, $1d, $1f, $03, $0f, $3f, $3c, $30, $30, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $c0, $70, $f0, $ff, $ff, $ff, $f5, $f7, $fd, $35, $15, $14, $14, $14, $15, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $c0, $c0, $c0, $00, $55, $55, $40, $00, $00, $40, $54, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick2_right_frame2:
                         !BYTE $00, $05, $07, $07, $07, $00, $03, $0f, $0f, $0c, $0c, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f0, $dc, $7c, $ff, $ff, $ff, $fd, $3d, $3f, $0d, $05, $05, $05, $05, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $c0, $f0, $f0, $70, $c0, $55, $55, $50, $00, $00, $10, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

bruce_kick2_right_frame3:
                         !BYTE $00, $01, $01, $01, $01, $00, $00, $03, $03, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $7c, $f7, $df, $ff, $3f, $ff, $ff, $cf, $0f, $03, $41, $41, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $f0, $fc, $fc, $5c, $70, $d5, $55, $54, $40, $40, $44, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $01, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick2_right_frame4:
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $5f, $7d, $77, $7f, $0f, $3f, $ff, $f3, $c3, $c0, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $c0, $c0, $fc, $ff, $ff, $d7, $dc, $f5, $d5, $55, $50, $50, $51, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $00, $00, $00, $00, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $54, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 10 ========================
; Sprite ID:       bruce_box_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=238; PosY=73
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_box_right_WIDTH_PX    = 24
bruce_box_right_HEIGHT_PX   = 32
bruce_box_right_BIT_PER_PX  = 2
bruce_box_right_INDEX       = 9
bruce_box_right_NUM_FRAMES  = 2
bruce_box_right_frame1:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $0f, $3f, $3f, $3f, $3c, $05, $05, $05, $15, $15, $11, $11, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $15, $5c, $7c, $ff, $c0, $c0, $c0, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $c5, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_box_right_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $00, $00, $00, $01, $01, $01, $01, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $05, $07, $3f, $fc, $fc, $fc, $f1, $c0, $50, $50, $50, $50, $50, $10, $10, $10, $14, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $40, $50, $c0, $c0, $fc, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 11 ========================
; Sprite ID:       bruce_climb_up1
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=186; PosY=77
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_climb_up1_WIDTH_PX    = 16
bruce_climb_up1_HEIGHT_PX   = 32
bruce_climb_up1_BIT_PER_PX  = 2
bruce_climb_up1_INDEX       = 10
bruce_climb_up1_NUM_FRAMES  = 2
bruce_climb_up1_frame1:
                       !BYTE $00, $00, $00, $41, $4d, $5d, $4f, $cf, $c3, $ff, $3f, $0f, $03, $01, $01, $01, $04, $04, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $50, $50, $c0, $f0, $fc, $fc, $fd, $4d, $40, $40, $10, $10, $10, $10, $10, $10, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_climb_up1_frame2:
                       !BYTE $00, $00, $00, $04, $04, $05, $04, $0c, $0c, $0f, $03, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $d5, $d5, $f5, $f5, $3c, $ff, $ff, $ff, $3f, $14, $14, $14, $41, $41, $41, $41, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $d0, $d0, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 12 ========================
; Sprite ID:       bruce_climb_up2
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=162; PosY=77
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_climb_up2_WIDTH_PX    = 16
bruce_climb_up2_HEIGHT_PX   = 32
bruce_climb_up2_BIT_PER_PX  = 2
bruce_climb_up2_INDEX       = 11
bruce_climb_up2_NUM_FRAMES  = 2
bruce_climb_up2_frame1:
                       !BYTE $00, $00, $00, $01, $05, $05, $05, $05, $03, $0f, $3f, $3f, $7f, $71, $01, $01, $04, $04, $04, $04, $04, $04, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $41, $71, $75, $f1, $f3, $c3, $ff, $fc, $f0, $c0, $40, $40, $40, $10, $10, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_climb_up2_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $57, $57, $5f, $5f, $3c, $ff, $ff, $ff, $fc, $14, $14, $14, $41, $41, $41, $41, $40, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $10, $10, $50, $10, $30, $30, $f0, $c0, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 13 ========================
; Sprite ID:       bruce_jump1_right_up
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=232; PosY=6
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jump1_right_up_WIDTH_PX    = 16
bruce_jump1_right_up_HEIGHT_PX   = 32
bruce_jump1_right_up_BIT_PER_PX  = 2
bruce_jump1_right_up_INDEX       = 12
bruce_jump1_right_up_NUM_FRAMES  = 2
bruce_jump1_right_up_frame1:
                            !BYTE $00, $00, $00, $01, $05, $05, $07, $07, $07, $03, $0f, $3f, $3f, $3f, $71, $41, $01, $01, $01, $01, $01, $01, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $f0, $d0, $f0, $f0, $c0, $f0, $fc, $fc, $fc, $4d, $41, $40, $40, $40, $40, $40, $40, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jump1_right_up_frame2:
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $07, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $55, $5f, $7d, $7f, $7f, $3c, $ff, $ff, $ff, $ff, $14, $14, $14, $14, $14, $14, $14, $14, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $d0, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 14 ========================
; Sprite ID:       bruce_jump1_left_up
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=232; PosY=6
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jump1_left_up_WIDTH_PX    = 16
bruce_jump1_left_up_HEIGHT_PX   = 32
bruce_jump1_left_up_BIT_PER_PX  = 2
bruce_jump1_left_up_INDEX       = 13
bruce_jump1_left_up_NUM_FRAMES  = 2
bruce_jump1_left_up_frame1:
                           !BYTE $00, $00, $00, $01, $05, $0f, $07, $0f, $0f, $03, $0f, $3f, $3f, $3f, $71, $41, $01, $01, $01, $01, $01, $01, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $d0, $d0, $d0, $c0, $f0, $fc, $fc, $fc, $4d, $41, $40, $40, $40, $40, $40, $40, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jump1_left_up_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $07, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $55, $f5, $7d, $fd, $fd, $3c, $ff, $ff, $ff, $ff, $14, $14, $14, $14, $14, $14, $14, $14, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $d0, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 15 ========================
; Sprite ID:       bruce_jump2_up
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=62; PosY=110
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jump2_up_WIDTH_PX    = 16
bruce_jump2_up_HEIGHT_PX   = 32
bruce_jump2_up_BIT_PER_PX  = 2
bruce_jump2_up_INDEX       = 14
bruce_jump2_up_NUM_FRAMES  = 2
bruce_jump2_up_frame1:
                      !BYTE $00, $00, $00, $00, $00, $00, $01, $05, $05, $05, $05, $01, $43, $7f, $7f, $f3, $c3, $01, $05, $15, $54, $50, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $50, $50, $40, $c1, $fd, $fd, $cf, $c3, $40, $50, $54, $15, $05, $14, $10, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jump2_up_frame2:
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $07, $07, $0f, $0c, $00, $00, $01, $05, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $55, $55, $55, $55, $14, $3c, $ff, $ff, $3c, $3c, $14, $55, $55, $41, $00, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $d0, $d0, $f0, $30, $00, $00, $40, $50, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 16 ========================
; Sprite ID:       bruce_jump3_up
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=86; PosY=109
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jump3_up_WIDTH_PX    = 16
bruce_jump3_up_HEIGHT_PX   = 32
bruce_jump3_up_BIT_PER_PX  = 2
bruce_jump3_up_INDEX       = 15
bruce_jump3_up_NUM_FRAMES  = 2
bruce_jump3_up_frame1:
                      !BYTE $00, $00, $00, $41, $45, $55, $45, $c5, $c1, $f3, $3f, $3f, $0f, $03, $01, $01, $01, $01, $01, $01, $01, $05, $04, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $41, $51, $55, $51, $53, $43, $cf, $fc, $fc, $f0, $c0, $40, $40, $40, $40, $40, $40, $40, $50, $10, $04, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jump3_up_frame2:
                      !BYTE $00, $00, $00, $04, $04, $05, $04, $0c, $0c, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $55, $55, $55, $55, $14, $3c, $ff, $ff, $ff, $3c, $14, $14, $14, $14, $14, $14, $14, $55, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $10, $10, $50, $10, $30, $30, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 17 ========================
; Sprite ID:       bruce_standing_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=2; PosY=2
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_standing_left_WIDTH_PX    = 16
bruce_standing_left_HEIGHT_PX   = 32
bruce_standing_left_BIT_PER_PX  = 2
bruce_standing_left_INDEX       = 16
bruce_standing_left_NUM_FRAMES  = 2
bruce_standing_left_frame1:
                           !BYTE $00, $00, $00, $00, $00, $01, $03, $03, $03, $00, $00, $03, $4f, $7f, $03, $01, $01, $05, $04, $04, $04, $04, $14, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $d4, $f4, $74, $f4, $f0, $f0, $fc, $fc, $7c, $5c, $f0, $50, $50, $10, $10, $10, $10, $10, $14, $15, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_standing_left_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $07, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $0d, $1f, $37, $3f, $3f, $0f, $0f, $3f, $f7, $f5, $3f, $15, $15, $51, $41, $41, $41, $41, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $40, $40, $40, $40, $00, $00, $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 18 ========================
; Sprite ID:       bruce_running_left_frame1
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=164; PosY=42
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

bruce_running_left_frame1_WIDTH_PX    = 24
bruce_running_left_frame1_HEIGHT_PX   = 32
bruce_running_left_frame1_BIT_PER_PX  = 2
bruce_running_left_frame1_INDEX       = 17
bruce_running_left_frame1_NUM_FRAMES  = 1
bruce_running_left_frame1:
                          !BYTE $00, $00, $00, $00, $00, $54, $f5, $75, $f5, $fd, $3f, $0f, $3f, $3f, $3f, $71, $41, $01, $04, $14, $10, $10, $10, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fc, $fc, $cc, $cc, $44, $44, $54, $50, $40, $50, $05, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 19 ========================
; Sprite ID:       bruce_running_left_frame2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=192; PosY=41
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

bruce_running_left_frame2_WIDTH_PX    = 24
bruce_running_left_frame2_HEIGHT_PX   = 32
bruce_running_left_frame2_BIT_PER_PX  = 2
bruce_running_left_frame2_INDEX       = 18
bruce_running_left_frame2_NUM_FRAMES  = 1
bruce_running_left_frame2:
                          !BYTE $00, $00, $00, $00, $00, $05, $0f, $07, $0f, $0f, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $50, $d0, $f0, $fc, $fc, $fc, $fd, $75, $55, $55, $14, $14, $04, $05, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 20 ========================
; Sprite ID:       bruce_jumping1_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=106; PosY=7
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jumping1_left_WIDTH_PX    = 16
bruce_jumping1_left_HEIGHT_PX   = 32
bruce_jumping1_left_BIT_PER_PX  = 2
bruce_jumping1_left_INDEX       = 19
bruce_jumping1_left_NUM_FRAMES  = 2
bruce_jumping1_left_frame1:
                           !BYTE $00, $00, $00, $15, $3d, $1d, $3d, $3f, $3f, $0f, $0f, $0f, $0f, $03, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $00, $f0, $fc, $cc, $cc, $44, $44, $40, $40, $40, $54, $55, $41, $11, $10, $50, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jumping1_left_frame2:
                           !BYTE $00, $00, $00, $01, $03, $01, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $d4, $d4, $d4, $f4, $f0, $ff, $ff, $fc, $fc, $34, $14, $14, $14, $04, $05, $05, $04, $01, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $40, $40, $00, $00, $00, $40, $50, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 21 ========================
; Sprite ID:       bruce_jumping2_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=144; PosY=3
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_jumping2_left_WIDTH_PX    = 16
bruce_jumping2_left_HEIGHT_PX   = 32
bruce_jumping2_left_BIT_PER_PX  = 2
bruce_jumping2_left_INDEX       = 20
bruce_jumping2_left_NUM_FRAMES  = 2
bruce_jumping2_left_frame1:
                           !BYTE $00, $00, $00, $00, $05, $0f, $07, $1f, $1f, $03, $07, $07, $03, $03, $03, $15, $15, $10, $04, $04, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $50, $d0, $f0, $fc, $f0, $c0, $c0, $40, $40, $40, $50, $50, $10, $14, $04, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_jumping2_left_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $f5, $75, $f5, $fd, $3f, $7f, $7f, $3c, $3c, $34, $54, $54, $05, $45, $41, $11, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $50, $10, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 22 ========================
; Sprite ID:       bruce_kick1_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=230; PosY=118
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_kick1_left_WIDTH_PX    = 16
bruce_kick1_left_HEIGHT_PX   = 32
bruce_kick1_left_BIT_PER_PX  = 2
bruce_kick1_left_INDEX       = 21
bruce_kick1_left_NUM_FRAMES  = 2
bruce_kick1_left_frame1:
                        !BYTE $00, $00, $00, $00, $03, $03, $03, $ff, $ff, $cf, $4f, $5f, $07, $15, $55, $55, $51, $50, $14, $15, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $f5, $7d, $dd, $fd, $fc, $f0, $fc, $fc, $fc, $cc, $cc, $4c, $44, $54, $50, $50, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick1_left_frame2:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0c, $04, $05, $00, $01, $05, $05, $05, $05, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $0f, $37, $3d, $3f, $ff, $ff, $ff, $ff, $ff, $7c, $5c, $54, $54, $15, $05, $45, $55, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $40, $50, $d0, $d0, $d0, $c0, $00, $c0, $c0, $c0, $c0, $c0, $c0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 23 ========================
; Sprite ID:       bruce_kick2_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=256; PosY=109
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

bruce_kick2_left_WIDTH_PX    = 32
bruce_kick2_left_HEIGHT_PX   = 32
bruce_kick2_left_BIT_PER_PX  = 2
bruce_kick2_left_INDEX       = 22
bruce_kick2_left_NUM_FRAMES  = 4
bruce_kick2_left_frame1:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $00, $55, $55, $01, $00, $00, $01, $15, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $01, $03, $0d, $0f, $ff, $ff, $ff, $5f, $df, $7f, $5c, $54, $14, $14, $14, $54, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $d4, $f4, $74, $f4, $c0, $f0, $fc, $3c, $0c, $0c, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick2_left_frame2:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $15, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $00, $00, $00, $00, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $03, $03, $3f, $ff, $ff, $d7, $37, $5f, $57, $55, $05, $05, $45, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f5, $7d, $dd, $fd, $f0, $fc, $ff, $cf, $c3, $03, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick2_left_frame3:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $40, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $0f, $3f, $3f, $35, $0d, $57, $55, $15, $01, $01, $11, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $3d, $df, $f7, $ff, $fc, $ff, $ff, $f3, $f0, $c0, $41, $41, $40, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $40, $40, $40, $40, $00, $00, $c0, $c0, $c0, $c0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_kick2_left_frame4:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $03, $0f, $0f, $0d, $03, $55, $55, $05, $00, $00, $04, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $0f, $37, $3d, $ff, $ff, $ff, $7f, $7c, $fc, $70, $50, $50, $50, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $50, $d0, $d0, $d0, $00, $c0, $f0, $f0, $30, $30, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 24 ========================
; Sprite ID:       bruce_box_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=238; PosY=73
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_box_left_WIDTH_PX    = 24
bruce_box_left_HEIGHT_PX   = 32
bruce_box_left_BIT_PER_PX  = 2
bruce_box_left_INDEX       = 23
bruce_box_left_NUM_FRAMES  = 2
bruce_box_left_frame1:
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $53, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $54, $35, $3d, $ff, $03, $03, $03, $14, $10, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $fc, $fc, $fc, $3c, $50, $50, $50, $54, $54, $44, $44, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_box_left_frame2:
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $03, $03, $3f, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $40, $40, $50, $d0, $fc, $3f, $3f, $3f, $4f, $03, $05, $05, $05, $05, $05, $04, $04, $04, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $00, $00, $00, $40, $40, $40, $40, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 25 ========================
; Sprite ID:       bruce_pain_drop1_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=122; PosY=120
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_pain_drop1_left_WIDTH_PX    = 16
bruce_pain_drop1_left_HEIGHT_PX   = 32
bruce_pain_drop1_left_BIT_PER_PX  = 2
bruce_pain_drop1_left_INDEX       = 24
bruce_pain_drop1_left_NUM_FRAMES  = 2
bruce_pain_drop1_left_frame1:
                             !BYTE $00, $00, $00, $00, $00, $01, $03, $03, $03, $00, $00, $03, $0f, $3f, $73, $41, $01, $01, $05, $04, $15, $55, $54, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $d4, $f4, $74, $f4, $f0, $f0, $fc, $fc, $fc, $7c, $70, $50, $50, $10, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                             !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_pain_drop1_left_frame2:
                             !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $07, $04, $00, $00, $00, $00, $01, $05, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $0d, $1f, $37, $3f, $3f, $0f, $0f, $3f, $ff, $f7, $37, $15, $15, $11, $54, $44, $50, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00
                             !BYTE $00, $00, $00, $00, $40, $40, $40, $40, $00, $00, $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 26 ========================
; Sprite ID:       bruce_knocked_down_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=150; PosY=115
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

bruce_knocked_down_left_WIDTH_PX    = 32
bruce_knocked_down_left_HEIGHT_PX   = 32
bruce_knocked_down_left_BIT_PER_PX  = 2
bruce_knocked_down_left_INDEX       = 25
bruce_knocked_down_left_NUM_FRAMES  = 4
bruce_knocked_down_left_frame1:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $05, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $53, $5f, $57, $57, $05, $05, $55, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $0f, $07, $3d, $3f, $ff, $ff, $5f, $df, $fc, $fc, $70, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $d0, $d0, $c0, $00, $c0, $c0, $f0, $f0, $30, $30, $50, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_left_frame2:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $17, $15, $55, $41, $41, $55, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $01, $0f, $0f, $3f, $ff, $d7, $f7, $ff, $7f, $5c, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $d4, $f4, $74, $f0, $c0, $f0, $f0, $fc, $3c, $0c, $0c, $14, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_left_frame3:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $05, $55, $50, $50, $55, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $0f, $3f, $f5, $7d, $7f, $5f, $57, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f5, $7d, $dd, $fc, $f0, $fc, $fc, $ff, $cf, $c3, $03, $05, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_knocked_down_left_frame4:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $15, $14, $14, $55, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $4f, $7d, $5f, $5f, $17, $15, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $3d, $1f, $f7, $ff, $fc, $ff, $7f, $7f, $f3, $f0, $c0, $41, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 27 ========================
; Sprite ID:       bruce_lying_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=224; PosY=27
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_lying_right_WIDTH_PX    = 32
bruce_lying_right_HEIGHT_PX   = 32
bruce_lying_right_BIT_PER_PX  = 2
bruce_lying_right_INDEX       = 26
bruce_lying_right_NUM_FRAMES  = 2
bruce_lying_right_frame1:
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $55, $55, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $07, $07, $7f, $d7, $c3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $f0, $d0, $70, $f0, $f4, $c0, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_lying_right_frame2:
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $57, $5d, $0c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $5f, $7d, $77, $ff, $7f, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 28 ========================
; Sprite ID:       bruce_lying_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=224; PosY=27
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

bruce_lying_left_WIDTH_PX    = 32
bruce_lying_left_HEIGHT_PX   = 32
bruce_lying_left_BIT_PER_PX  = 2
bruce_lying_left_INDEX       = 27
bruce_lying_left_NUM_FRAMES  = 2
bruce_lying_left_frame1:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $3d, $1f, $37, $3f, $7f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $41, $f5, $5d, $0c, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $41, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $54, $54, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
bruce_lying_left_frame2:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $01, $03, $03, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $d4, $f4, $74, $ff, $f5, $f0, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $55, $d5, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $14, $15, $55, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 29 ========================
; Sprite ID:       ninja_falling_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=4; PosY=31
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_falling_left_WIDTH_PX    = 16
ninja_falling_left_HEIGHT_PX   = 32
ninja_falling_left_BIT_PER_PX  = 2
ninja_falling_left_INDEX       = 28
ninja_falling_left_NUM_FRAMES  = 2
ninja_falling_left_frame1:
                          !BYTE $00, $00, $00, $55, $00, $05, $05, $00, $05, $05, $01, $15, $15, $55, $55, $45, $01, $05, $15, $14, $10, $15, $15, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $14, $04, $44, $44, $44, $44, $44, $54, $54, $50, $40, $40, $00, $40, $40, $40, $50, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_falling_left_frame2:
                          !BYTE $00, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00, $01, $01, $05, $05, $04, $00, $00, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $01, $50, $54, $04, $54, $54, $14, $55, $55, $55, $54, $54, $10, $54, $54, $44, $05, $51, $51, $11, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $50, $40, $40, $40, $40, $40, $40, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 30 ========================
; Sprite ID:       ninja_running_left_frame1
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=52; PosY=51
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

ninja_running_left_frame1_WIDTH_PX    = 24
ninja_running_left_frame1_HEIGHT_PX   = 32
ninja_running_left_frame1_BIT_PER_PX  = 2
ninja_running_left_frame1_INDEX       = 29
ninja_running_left_frame1_NUM_FRAMES  = 1
ninja_running_left_frame1:
                          !BYTE $00, $00, $00, $01, $00, $00, $00, $14, $15, $05, $15, $15, $05, $15, $15, $15, $45, $45, $04, $04, $01, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $10, $04, $01, $05, $14, $50, $50, $40, $40, $40, $50, $40, $50, $54, $04, $04, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 31 ========================
; Sprite ID:       ninja_running_left_frame2
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=26; PosY=49
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

ninja_running_left_frame2_WIDTH_PX    = 24
ninja_running_left_frame2_HEIGHT_PX   = 32
ninja_running_left_frame2_BIT_PER_PX  = 2
ninja_running_left_frame2_INDEX       = 30
ninja_running_left_frame2_NUM_FRAMES  = 1
ninja_running_left_frame2:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $00, $01, $01, $01, $01, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $01, $00, $00, $40, $50, $51, $55, $55, $54, $54, $54, $54, $55, $54, $14, $14, $15, $05, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $40, $10, $10, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 32 ========================
; Sprite ID:       ninja_attack1_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=118; PosY=41
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_attack1_left_WIDTH_PX    = 16
ninja_attack1_left_HEIGHT_PX   = 32
ninja_attack1_left_BIT_PER_PX  = 2
ninja_attack1_left_INDEX       = 31
ninja_attack1_left_NUM_FRAMES  = 2
ninja_attack1_left_frame1:
                          !BYTE $00, $00, $00, $00, $00, $01, $01, $00, $05, $11, $50, $10, $15, $05, $00, $01, $05, $04, $14, $14, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $04, $50, $50, $50, $50, $54, $54, $54, $54, $54, $55, $55, $14, $14, $10, $10, $04, $05, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack1_left_frame2:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $01, $01, $00, $00, $00, $00, $00, $01, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $15, $05, $55, $15, $05, $05, $55, $55, $05, $15, $51, $41, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $10, $40, $00, $00, $00, $00, $40, $40, $40, $40, $40, $50, $50, $40, $40, $00, $00, $40, $50, $10, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 33 ========================
; Sprite ID:       ninja_attack2_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=14; PosY=96
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

ninja_attack2_left_WIDTH_PX    = 32
ninja_attack2_left_HEIGHT_PX   = 32
ninja_attack2_left_BIT_PER_PX  = 2
ninja_attack2_left_INDEX       = 32
ninja_attack2_left_NUM_FRAMES  = 4
ninja_attack2_left_frame1:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $15, $01, $15, $15, $01, $55, $01, $15, $14, $15, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $54, $54, $54, $54, $54, $15, $41, $41, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $54, $04, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_left_frame2:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $00, $05, $05, $00, $55, $00, $05, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $50, $55, $55, $55, $55, $55, $05, $50, $50, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $55, $01, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_left_frame3:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $00, $55, $00, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $10, $54, $55, $15, $55, $15, $55, $41, $54, $14, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $40, $54, $14, $15, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_left_frame4:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $54, $04, $55, $55, $05, $55, $05, $55, $50, $55, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $50, $50, $55, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $10, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 34 ========================
; Sprite ID:       ninja_pain_drop_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=264; PosY=41
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_pain_drop_left_WIDTH_PX    = 16
ninja_pain_drop_left_HEIGHT_PX   = 32
ninja_pain_drop_left_BIT_PER_PX  = 2
ninja_pain_drop_left_INDEX       = 33
ninja_pain_drop_left_NUM_FRAMES  = 2
ninja_pain_drop_left_frame1:
                            !BYTE $00, $00, $01, $01, $04, $05, $11, $50, $41, $41, $10, $05, $01, $10, $15, $00, $00, $00, $01, $01, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $50, $54, $55, $55, $54, $55, $54, $14, $54, $50, $50, $10, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_pain_drop_left_frame2:
                            !BYTE $00, $00, $00, $00, $00, $00, $01, $05, $04, $04, $01, $00, $00, $01, $01, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $40, $54, $15, $05, $15, $15, $05, $55, $15, $05, $55, $01, $05, $05, $15, $11, $44, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $50, $40, $50, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 35 ========================
; Sprite ID:       ninja_knocked_down_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=180; PosY=96
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_knocked_down_left_WIDTH_PX    = 24
ninja_knocked_down_left_HEIGHT_PX   = 32
ninja_knocked_down_left_BIT_PER_PX  = 2
ninja_knocked_down_left_INDEX       = 34
ninja_knocked_down_left_NUM_FRAMES  = 2
ninja_knocked_down_left_frame1:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $44, $45, $41, $15, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $01, $04, $04, $41, $55, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00, $00, $00, $11, $11, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_knocked_down_left_frame2:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $04, $04, $04, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $14, $55, $55, $05, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $55, $10, $40, $40, $11, $51, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $10, $10, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 36 ========================
; Sprite ID:       ninja_standing_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=48; PosY=17
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_standing_left_WIDTH_PX    = 16
ninja_standing_left_HEIGHT_PX   = 32
ninja_standing_left_BIT_PER_PX  = 2
ninja_standing_left_INDEX       = 35
ninja_standing_left_NUM_FRAMES  = 2
ninja_standing_left_frame1:
                           !BYTE $00, $00, $00, $00, $00, $00, $05, $05, $00, $05, $05, $01, $05, $15, $15, $15, $45, $41, $05, $05, $14, $10, $10, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $41, $41, $41, $41, $41, $51, $51, $55, $55, $51, $41, $51, $50, $10, $14, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_standing_left_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $04, $04, $00, $00, $01, $01, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $54, $04, $54, $54, $14, $55, $55, $55, $55, $55, $14, $55, $55, $41, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $10, $50, $50, $10, $10, $10, $00, $00, $40, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 37 ========================
; Sprite ID:       ninja_falling_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=4; PosY=31
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_falling_right_WIDTH_PX    = 16
ninja_falling_right_HEIGHT_PX   = 32
ninja_falling_right_BIT_PER_PX  = 2
ninja_falling_right_INDEX       = 36
ninja_falling_right_NUM_FRAMES  = 2
ninja_falling_right_frame1:
                           !BYTE $00, $00, $00, $55, $14, $10, $11, $11, $11, $11, $11, $15, $15, $05, $01, $01, $00, $01, $01, $01, $05, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00, $50, $50, $00, $50, $50, $40, $54, $54, $55, $55, $51, $40, $50, $54, $14, $04, $54, $54, $40, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_falling_right_frame2:
                           !BYTE $00, $00, $00, $05, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $40, $05, $15, $10, $15, $15, $14, $55, $55, $55, $15, $15, $04, $15, $15, $11, $50, $45, $45, $44, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $00, $40, $40, $50, $50, $10, $00, $00, $40, $40, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 38 ========================
; Sprite ID:       ninja_running_right_frame1
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=52; PosY=51
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

ninja_running_right_frame1_WIDTH_PX    = 24
ninja_running_right_frame1_HEIGHT_PX   = 32
ninja_running_right_frame1_BIT_PER_PX  = 2
ninja_running_right_frame1_INDEX       = 37
ninja_running_right_frame1_NUM_FRAMES  = 1
ninja_running_right_frame1:
                           !BYTE $00, $00, $00, $00, $01, $04, $10, $40, $50, $14, $05, $05, $01, $01, $01, $05, $01, $05, $15, $10, $10, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $14, $54, $50, $54, $54, $50, $54, $54, $54, $51, $51, $10, $10, $40, $40, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 39 ========================
; Sprite ID:       ninja_running_right_frame2
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=26; PosY=49
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

ninja_running_right_frame2_WIDTH_PX    = 24
ninja_running_right_frame2_HEIGHT_PX   = 32
ninja_running_right_frame2_BIT_PER_PX  = 2
ninja_running_right_frame2_INDEX       = 38
ninja_running_right_frame2_NUM_FRAMES  = 1
ninja_running_right_frame2:
                           !BYTE $00, $00, $00, $00, $00, $01, $04, $04, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $40, $00, $00, $01, $05, $45, $55, $55, $15, $15, $15, $15, $55, $15, $14, $14, $54, $50, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $40, $40, $00, $40, $40, $40, $40, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 40 ========================
; Sprite ID:       ninja_attack1_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=118; PosY=41
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_attack1_right_WIDTH_PX    = 16
ninja_attack1_right_HEIGHT_PX   = 32
ninja_attack1_right_BIT_PER_PX  = 2
ninja_attack1_right_INDEX       = 39
ninja_attack1_right_NUM_FRAMES  = 2
ninja_attack1_right_frame1:
                           !BYTE $00, $00, $00, $40, $10, $05, $05, $05, $05, $15, $15, $15, $15, $15, $55, $55, $14, $14, $04, $04, $10, $50, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $50, $44, $05, $04, $54, $50, $00, $40, $50, $10, $14, $14, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack1_right_frame2:
                           !BYTE $00, $00, $00, $04, $01, $00, $00, $00, $00, $01, $01, $01, $01, $01, $05, $05, $01, $01, $00, $00, $01, $05, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $54, $50, $55, $54, $50, $50, $55, $55, $50, $54, $45, $41, $41, $41, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $40, $40, $00, $00, $00, $00, $00, $40, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 41 ========================
; Sprite ID:       ninja_attack2_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=14; PosY=96
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

ninja_attack2_right_WIDTH_PX    = 32
ninja_attack2_right_HEIGHT_PX   = 32
ninja_attack2_right_BIT_PER_PX  = 2
ninja_attack2_right_INDEX       = 40
ninja_attack2_right_NUM_FRAMES  = 4
ninja_attack2_right_frame1:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $15, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $15, $15, $15, $15, $15, $54, $41, $41, $01, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $54, $40, $54, $54, $40, $55, $40, $54, $14, $54, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_right_frame2:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $05, $05, $05, $55, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $15, $15, $10, $55, $55, $50, $55, $50, $55, $05, $55, $50, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_right_frame3:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $15, $14, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $04, $15, $55, $54, $55, $54, $55, $41, $15, $14, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $40, $40, $00, $55, $00, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_attack2_right_frame4:
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $55, $40, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $05, $55, $55, $55, $55, $55, $50, $05, $05, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $00, $50, $50, $00, $55, $00, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 42 ========================
; Sprite ID:       ninja_pain_drop_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=264; PosY=41
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_pain_drop_right_WIDTH_PX    = 16
ninja_pain_drop_right_HEIGHT_PX   = 32
ninja_pain_drop_right_BIT_PER_PX  = 2
ninja_pain_drop_right_INDEX       = 41
ninja_pain_drop_right_NUM_FRAMES  = 2
ninja_pain_drop_right_frame1:
                             !BYTE $00, $00, $00, $00, $00, $01, $05, $05, $05, $15, $55, $55, $15, $55, $15, $14, $15, $05, $05, $04, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $10, $50, $44, $05, $41, $41, $04, $50, $40, $04, $54, $00, $00, $00, $40, $40, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                             !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_pain_drop_right_frame2:
                             !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $05, $01, $05, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $01, $15, $54, $50, $54, $54, $50, $55, $54, $50, $55, $40, $50, $50, $54, $44, $11, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                             !BYTE $00, $00, $00, $00, $00, $00, $40, $50, $10, $10, $40, $00, $00, $40, $40, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 43 ========================
; Sprite ID:       ninja_knocked_down_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=180; PosY=96
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_knocked_down_right_WIDTH_PX    = 24
ninja_knocked_down_right_HEIGHT_PX   = 32
ninja_knocked_down_right_BIT_PER_PX  = 2
ninja_knocked_down_right_INDEX       = 42
ninja_knocked_down_right_NUM_FRAMES  = 2
ninja_knocked_down_right_frame1:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00, $00, $00, $44, $44, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $50, $40, $10, $10, $41, $55, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $11, $51, $41, $54, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_knocked_down_right_frame2:
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $00, $04, $04, $05, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $55, $04, $01, $01, $44, $45, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
                                !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $14, $55, $55, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $10, $10, $10, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 44 ========================
; Sprite ID:       ninja_standing_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=48; PosY=17
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_standing_right_WIDTH_PX    = 16
ninja_standing_right_HEIGHT_PX   = 32
ninja_standing_right_BIT_PER_PX  = 2
ninja_standing_right_INDEX       = 43
ninja_standing_right_NUM_FRAMES  = 2
ninja_standing_right_frame1:
                            !BYTE $00, $00, $00, $00, $00, $40, $40, $41, $41, $41, $41, $41, $45, $45, $55, $55, $45, $41, $45, $05, $04, $14, $10, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $00, $50, $50, $40, $50, $54, $54, $54, $51, $41, $50, $50, $14, $04, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_standing_right_frame2:
                            !BYTE $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $04, $04, $05, $05, $04, $04, $04, $00, $00, $01, $01, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $15, $10, $15, $15, $14, $55, $55, $55, $55, $55, $14, $55, $55, $41, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                            !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $10, $10, $00, $00, $40, $40, $40, $50, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 45 ========================
; Sprite ID:       ninja_climb_up1
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=6; PosY=30
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_climb_up1_WIDTH_PX    = 16
ninja_climb_up1_HEIGHT_PX   = 32
ninja_climb_up1_BIT_PER_PX  = 2
ninja_climb_up1_INDEX       = 44
ninja_climb_up1_NUM_FRAMES  = 2
ninja_climb_up1_frame1:
                       !BYTE $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $05, $05, $05, $15, $51, $41, $05, $05, $04, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $51, $51, $51, $51, $51, $41, $51, $55, $55, $51, $51, $40, $40, $50, $10, $10, $10, $10, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_climb_up1_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $05, $04, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $15, $15, $15, $15, $14, $55, $55, $55, $55, $15, $14, $54, $55, $41, $41, $41, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $50, $50, $10, $10, $00, $00, $00, $00, $00, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 46 ========================
; Sprite ID:       ninja_climb_up2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=6; PosY=74
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

ninja_climb_up2_WIDTH_PX    = 16
ninja_climb_up2_HEIGHT_PX   = 32
ninja_climb_up2_BIT_PER_PX  = 2
ninja_climb_up2_INDEX       = 45
ninja_climb_up2_NUM_FRAMES  = 2
ninja_climb_up2_frame1:
                       !BYTE $00, $00, $00, $00, $05, $05, $05, $05, $45, $41, $45, $15, $15, $05, $05, $01, $01, $05, $04, $04, $04, $04, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $41, $41, $41, $41, $41, $51, $51, $51, $55, $45, $41, $51, $50, $10, $14, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
ninja_climb_up2_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $54, $54, $54, $54, $14, $55, $55, $55, $55, $54, $14, $15, $55, $41, $41, $41, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $50, $50, $10, $10, $00, $00, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 47 ========================
; Sprite ID:       sumo_shout_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=26; PosY=78
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_shout_right_WIDTH_PX    = 16
sumo_shout_right_HEIGHT_PX   = 32
sumo_shout_right_BIT_PER_PX  = 2
sumo_shout_right_INDEX       = 46
sumo_shout_right_NUM_FRAMES  = 2
sumo_shout_right_frame1:
                        !BYTE $00, $00, $00, $47, $5f, $5d, $5f, $1f, $1d, $3d, $0d, $3f, $ff, $f7, $f5, $35, $3f, $15, $35, $3d, $3c, $30, $30, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $d0, $f0, $f0, $f1, $41, $45, $71, $f3, $c3, $ff, $ff, $fc, $f0, $50, $70, $f0, $f0, $30, $30, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

sumo_shout_right_frame2:
                        !BYTE $00, $00, $00, $04, $05, $05, $05, $01, $01, $03, $00, $03, $0f, $0f, $0f, $03, $03, $01, $03, $03, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $fd, $df, $ff, $ff, $d4, $d4, $d7, $ff, $fc, $7f, $5f, $5f, $ff, $55, $57, $df, $cf, $03, $03, $c3, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $10, $10, $50, $10, $30, $30, $f0, $f0, $c0, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 48 ========================
; Sprite ID:       sumo_standing_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=30; PosY=2
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_standing_right_WIDTH_PX    = 16
sumo_standing_right_HEIGHT_PX   = 32
sumo_standing_right_BIT_PER_PX  = 2
sumo_standing_right_INDEX       = 47
sumo_standing_right_NUM_FRAMES  = 2
sumo_standing_right_frame1:
                           !BYTE $00, $00, $00, $57, $5f, $1d, $1f, $1f, $3f, $3f, $3f, $f7, $f5, $f5, $35, $3f, $3f, $15, $35, $3d, $3c, $30, $30, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $d0, $f0, $f0, $f0, $50, $f0, $c1, $fd, $fd, $fd, $f0, $f0, $50, $70, $f0, $f0, $30, $30, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

sumo_standing_right_frame2:
                           !BYTE $00, $00, $00, $05, $05, $01, $01, $01, $03, $03, $03, $0f, $0f, $0f, $03, $03, $03, $01, $03, $03, $03, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $ff, $dd, $ff, $ff, $ff, $f5, $ff, $7c, $5f, $5f, $5f, $ff, $ff, $55, $57, $df, $cf, $03, $03, $c3, $00, $00, $00, $00, $00, $00, $00, $00
                           !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $d0, $d0, $d0, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 49 ========================
; Sprite ID:       sumo_running_right_frame1
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=76; PosY=80
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sumo_running_right_frame1_WIDTH_PX    = 24
sumo_running_right_frame1_HEIGHT_PX   = 32
sumo_running_right_frame1_BIT_PER_PX  = 2
sumo_running_right_frame1_INDEX       = 48
sumo_running_right_frame1_NUM_FRAMES  = 1
sumo_running_right_frame1:
                          !BYTE $00, $00, $00, $04, $05, $05, $01, $01, $01, $03, $03, $3f, $ff, $4f, $4f, $07, $05, $0d, $0f, $0f, $ff, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $fc, $df, $ff, $ff, $fc, $f4, $fc, $fc, $f0, $fc, $5f, $53, $51, $71, $f0, $f0, $f0, $30, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 50 ========================
; Sprite ID:       sumo_running_right_frame2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=94; PosY=46
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sumo_running_right_frame2_WIDTH_PX    = 24
sumo_running_right_frame2_HEIGHT_PX   = 32
sumo_running_right_frame2_BIT_PER_PX  = 2
sumo_running_right_frame2_INDEX       = 49
sumo_running_right_frame2_NUM_FRAMES  = 1
sumo_running_right_frame2:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $57, $5f, $1d, $1f, $1f, $3f, $3f, $3f, $ff, $ff, $ff, $7f, $57, $d5, $d5, $f4, $fc, $c0, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $c0, $c0, $f0, $f0, $f0, $c0, $40, $40, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 51 ========================
; Sprite ID:       sumo_kick1_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=76; PosY=7
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_kick1_right_WIDTH_PX    = 16
sumo_kick1_right_HEIGHT_PX   = 32
sumo_kick1_right_BIT_PER_PX  = 2
sumo_kick1_right_INDEX       = 50
sumo_kick1_right_NUM_FRAMES  = 2
sumo_kick1_right_frame1:
                        !BYTE $00, $4f, $57, $5f, $1d, $1f, $3f, $3d, $0d, $3f, $ff, $ff, $ff, $cf, $45, $4d, $4f, $0f, $03, $0f, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d0, $f0, $f0, $c0, $f0, $7f, $7f, $f3, $f1, $f1, $d0, $5c, $5f, $7f, $0f, $3c, $fc, $f0, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick1_right_frame2:
                        !BYTE $00, $04, $05, $05, $01, $01, $03, $03, $00, $03, $0f, $0f, $0f, $0c, $04, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $7d, $ff, $df, $fc, $ff, $d7, $d7, $ff, $ff, $ff, $fd, $f5, $55, $d7, $f0, $f3, $3f, $ff, $0f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $30, $10, $10, $00, $c0, $f0, $f0, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 52 ========================
; Sprite ID:       sumo_kick2_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=112; PosY=84
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

sumo_kick2_right_WIDTH_PX    = 32
sumo_kick2_right_HEIGHT_PX   = 32
sumo_kick2_right_BIT_PER_PX  = 2
sumo_kick2_right_INDEX       = 51
sumo_kick2_right_NUM_FRAMES  = 4
sumo_kick2_right_frame1:
                        !BYTE $13, $15, $17, $07, $07, $07, $07, $0f, $0f, $3f, $3f, $3f, $37, $35, $1d, $1f, $0f, $03, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f4, $7c, $fc, $fc, $d0, $50, $5c, $ff, $ff, $ff, $fc, $d4, $57, $57, $50, $c0, $c3, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $fd, $fd, $c0, $00, $00, $ff, $ff, $00, $00, $00, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $00, $00, $fc, $fc, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_right_frame2:
                        !BYTE $04, $05, $05, $01, $01, $01, $01, $03, $03, $0f, $0f, $0f, $0d, $0d, $07, $07, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $7d, $df, $ff, $ff, $f4, $d4, $d7, $ff, $ff, $ff, $ff, $f5, $55, $55, $d4, $f0, $f0, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $f0, $00, $00, $ff, $ff, $00, $00, $c0, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $10, $00, $00, $ff, $ff, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_right_frame3:
                        !BYTE $01, $01, $01, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $5f, $77, $7f, $7f, $7d, $75, $f5, $ff, $ff, $ff, $ff, $7d, $55, $d5, $f5, $fc, $3c, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $40, $c0, $c0, $c0, $00, $00, $c0, $ff, $ff, $fc, $c0, $40, $7f, $7f, $00, $00, $30, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d4, $d4, $04, $00, $00, $ff, $ff, $0c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_right_frame4:
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $4f, $57, $5d, $1f, $1f, $1f, $1d, $3d, $3f, $ff, $ff, $ff, $df, $d5, $75, $7d, $3f, $0f, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $d0, $f0, $f0, $f0, $40, $40, $70, $ff, $ff, $ff, $f0, $50, $5f, $5f, $40, $00, $0c, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f5, $f5, $01, $00, $00, $ff, $ff, $03, $00, $00, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                        !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 53 ========================
; Sprite ID:       sumo_falling_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=174; PosY=4
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_falling_right_WIDTH_PX    = 16
sumo_falling_right_HEIGHT_PX   = 32
sumo_falling_right_BIT_PER_PX  = 2
sumo_falling_right_INDEX       = 52
sumo_falling_right_NUM_FRAMES  = 2
sumo_falling_right_frame1:
                          !BYTE $00, $00, $00, $40, $57, $5f, $5d, $1f, $1f, $3f, $3f, $3f, $3f, $ff, $ff, $d5, $d5, $f5, $5d, $7c, $7c, $0c, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $d0, $f0, $f0, $f0, $70, $f0, $c0, $fc, $fc, $5c, $5c, $75, $f4, $f4, $f0, $c0, $f0, $fc, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_falling_right_frame2:
                          !BYTE $00, $00, $00, $04, $05, $05, $05, $01, $01, $03, $03, $03, $03, $0f, $0f, $0d, $0d, $0f, $05, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $ff, $dd, $ff, $ff, $ff, $f7, $ff, $fc, $ff, $ff, $55, $55, $57, $df, $cf, $cf, $cc, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $50, $40, $40, $00, $00, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 54 ========================
; Sprite ID:       sumo_knocked_down_right
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=194; PosY=113
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_knocked_down_right_WIDTH_PX    = 24
sumo_knocked_down_right_HEIGHT_PX   = 32
sumo_knocked_down_right_BIT_PER_PX  = 2
sumo_knocked_down_right_INDEX       = 53
sumo_knocked_down_right_NUM_FRAMES  = 2
sumo_knocked_down_right_frame1:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $4f, $57, $5d, $1f, $1f, $1f, $1d, $3d, $3f, $ff, $ff, $ff, $df, $df, $f5, $15, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d0, $f0, $f0, $f0, $40, $40, $70, $f0, $ff, $ff, $f7, $f7, $5f, $5f, $7f, $f5, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $0c, $fc, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_knocked_down_right_frame2:
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $04, $05, $05, $01, $01, $01, $01, $03, $03, $0f, $0f, $0f, $0d, $0d, $0f, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $7d, $df, $ff, $ff, $f4, $d4, $d7, $ff, $ff, $ff, $ff, $ff, $f5, $55, $57, $ff, $00, $00, $00, $00, $00, $00, $00, $00
                               !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $70, $70, $f0, $f0, $ff, $5f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $f0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 55 ========================
; Sprite ID:       sumo_box_right
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=226; PosY=12
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_box_right_WIDTH_PX    = 24
sumo_box_right_HEIGHT_PX   = 32
sumo_box_right_BIT_PER_PX  = 2
sumo_box_right_INDEX       = 54
sumo_box_right_NUM_FRAMES  = 2
sumo_box_right_frame1:
                      !BYTE $00, $00, $00, $13, $15, $17, $07, $07, $07, $07, $0f, $0f, $3f, $3f, $3f, $37, $37, $1d, $1d, $0f, $03, $3f, $f3, $f3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f4, $7c, $fc, $fc, $d0, $50, $5c, $ff, $ff, $ff, $fc, $fc, $54, $54, $50, $00, $c0, $c0, $c0, $f0, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f5, $f5, $c1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_box_right_frame2:
                      !BYTE $00, $00, $00, $01, $01, $01, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $01, $01, $00, $00, $03, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $5f, $77, $7f, $7f, $7d, $75, $f5, $ff, $ff, $ff, $ff, $7f, $75, $d5, $d5, $f0, $3c, $fc, $3c, $3f, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $40, $c0, $c0, $c0, $00, $00, $c0, $ff, $ff, $fc, $c0, $c0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 56 ========================
; Sprite ID:       sumo_shout_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=26; PosY=78
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_shout_left_WIDTH_PX    = 16
sumo_shout_left_HEIGHT_PX   = 32
sumo_shout_left_BIT_PER_PX  = 2
sumo_shout_left_INDEX       = 55
sumo_shout_left_NUM_FRAMES  = 2
sumo_shout_left_frame1:
                       !BYTE $00, $00, $00, $03, $07, $0f, $0f, $4f, $41, $51, $4d, $cf, $c3, $ff, $ff, $3f, $0f, $05, $0d, $0f, $0f, $0c, $0c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d1, $f5, $75, $f5, $f4, $74, $7c, $70, $fc, $ff, $df, $5f, $5c, $fc, $54, $5c, $7c, $3c, $0c, $0c, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_shout_left_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $04, $04, $05, $04, $0c, $0c, $0f, $0f, $03, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3d, $7f, $f7, $ff, $ff, $17, $17, $d7, $ff, $3f, $fd, $f5, $f5, $ff, $55, $d5, $f7, $f3, $c0, $c0, $c3, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $10, $50, $50, $50, $40, $40, $c0, $00, $c0, $f0, $f0, $f0, $c0, $c0, $40, $c0, $c0, $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 57 ========================
; Sprite ID:       sumo_standing_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=30; PosY=2
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_standing_left_WIDTH_PX    = 16
sumo_standing_left_HEIGHT_PX   = 32
sumo_standing_left_BIT_PER_PX  = 2
sumo_standing_left_INDEX       = 56
sumo_standing_left_NUM_FRAMES  = 2
sumo_standing_left_frame1:
                          !BYTE $00, $00, $00, $03, $0f, $07, $0f, $0f, $0f, $05, $0f, $43, $7f, $7f, $7f, $0f, $0f, $05, $0d, $0f, $0f, $0c, $0c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d5, $f5, $74, $f4, $f4, $fc, $fc, $fc, $df, $5f, $5f, $5c, $fc, $fc, $54, $5c, $7c, $3c, $0c, $0c, $3c, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_standing_left_frame2:
                          !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $07, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3d, $ff, $77, $ff, $ff, $ff, $5f, $ff, $3d, $f5, $f5, $f5, $ff, $ff, $55, $d5, $f7, $f3, $c0, $c0, $c3, $00, $00, $00, $00, $00, $00, $00, $00
                          !BYTE $00, $00, $00, $50, $50, $40, $40, $40, $c0, $c0, $c0, $f0, $f0, $f0, $c0, $c0, $c0, $40, $c0, $c0, $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 58 ========================
; Sprite ID:       sumo_running_left_frame1
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=76; PosY=80
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sumo_running_left_frame1_WIDTH_PX    = 24
sumo_running_left_frame1_HEIGHT_PX   = 32
sumo_running_left_frame1_BIT_PER_PX  = 2
sumo_running_left_frame1_INDEX       = 57
sumo_running_left_frame1_NUM_FRAMES  = 1
sumo_running_left_frame1:
                         !BYTE $00, $00, $00, $00, $3d, $3f, $f7, $ff, $ff, $3f, $1f, $3f, $3f, $0f, $3f, $f5, $c5, $45, $4d, $0f, $0f, $0f, $0c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $50, $50, $40, $40, $40, $c0, $c0, $fc, $ff, $f1, $f1, $d0, $50, $70, $f0, $f0, $ff, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 59 ========================
; Sprite ID:       sumo_running_left_frame2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=94; PosY=46
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sumo_running_left_frame2_WIDTH_PX    = 24
sumo_running_left_frame2_HEIGHT_PX   = 32
sumo_running_left_frame2_BIT_PER_PX  = 2
sumo_running_left_frame2_INDEX       = 58
sumo_running_left_frame2_NUM_FRAMES  = 1
sumo_running_left_frame2:
                         !BYTE $00, $00, $00, $00, $03, $03, $0f, $0f, $0f, $03, $01, $01, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $d5, $f5, $74, $f4, $f4, $fc, $fc, $fc, $ff, $ff, $ff, $fd, $d5, $57, $57, $1f, $3f, $03, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 60 ========================
; Sprite ID:       sumo_kick1_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=76; PosY=7
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_kick1_left_WIDTH_PX    = 16
sumo_kick1_left_HEIGHT_PX   = 32
sumo_kick1_left_BIT_PER_PX  = 2
sumo_kick1_left_INDEX       = 59
sumo_kick1_left_NUM_FRAMES  = 2
sumo_kick1_left_frame1:
                       !BYTE $00, $00, $07, $0f, $0f, $03, $0f, $fd, $fd, $cf, $4f, $4f, $07, $35, $f5, $fd, $f0, $3c, $3f, $0f, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f1, $d5, $f5, $74, $f4, $fc, $7c, $70, $fc, $ff, $ff, $ff, $f3, $51, $71, $f1, $f0, $c0, $f0, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick1_left_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0c, $04, $04, $00, $03, $0f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $7d, $ff, $f7, $3f, $ff, $d7, $d7, $ff, $ff, $ff, $7f, $5f, $55, $d7, $0f, $cf, $fc, $ff, $f0, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $10, $50, $50, $40, $40, $c0, $c0, $00, $c0, $f0, $f0, $f0, $30, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 61 ========================
; Sprite ID:       sumo_kick2_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=112; PosY=84
; Dimensions:      32 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Medium4Frames

sumo_kick2_left_WIDTH_PX    = 32
sumo_kick2_left_HEIGHT_PX   = 32
sumo_kick2_left_BIT_PER_PX  = 2
sumo_kick2_left_INDEX       = 60
sumo_kick2_left_NUM_FRAMES  = 4
sumo_kick2_left_frame1:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $00, $00, $3f, $3f, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7f, $7f, $03, $00, $00, $ff, $ff, $00, $00, $00, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $03, $1f, $3d, $3f, $3f, $07, $05, $35, $ff, $ff, $ff, $3f, $17, $d5, $d5, $05, $03, $c3, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c4, $54, $d4, $d0, $d0, $d0, $d0, $f0, $f0, $fc, $fc, $fc, $dc, $5c, $74, $f4, $f0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_left_frame2:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $5f, $5f, $40, $00, $00, $ff, $ff, $c0, $00, $00, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $07, $0f, $0f, $0f, $01, $01, $0d, $ff, $ff, $ff, $0f, $05, $f5, $f5, $01, $00, $30, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f1, $d5, $75, $f4, $f4, $f4, $74, $7c, $fc, $ff, $ff, $ff, $f7, $57, $5d, $7d, $fc, $f0, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_left_frame3:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $17, $17, $10, $00, $00, $ff, $ff, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $01, $03, $03, $03, $00, $00, $03, $ff, $ff, $3f, $03, $01, $fd, $fd, $00, $00, $0c, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $f5, $dd, $fd, $fd, $7d, $5d, $5f, $ff, $ff, $ff, $ff, $7d, $55, $57, $5f, $3f, $3c, $fc, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $40, $40, $40, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $c0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_kick2_left_frame4:
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $04, $00, $00, $ff, $ff, $0c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $0f, $00, $00, $ff, $ff, $00, $00, $03, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $7d, $f7, $ff, $ff, $1f, $17, $d7, $ff, $ff, $ff, $ff, $5f, $55, $55, $17, $0f, $0f, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                       !BYTE $10, $50, $50, $40, $40, $40, $40, $c0, $c0, $f0, $f0, $f0, $70, $70, $d0, $d0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 62 ========================
; Sprite ID:       sumo_falling_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=174; PosY=4
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_falling_left_WIDTH_PX    = 16
sumo_falling_left_HEIGHT_PX   = 32
sumo_falling_left_BIT_PER_PX  = 2
sumo_falling_left_INDEX       = 61
sumo_falling_left_NUM_FRAMES  = 2
sumo_falling_left_frame1:
                         !BYTE $00, $00, $00, $00, $03, $0f, $07, $0f, $0f, $0f, $0d, $0f, $03, $3f, $3f, $35, $35, $5d, $1f, $1f, $0f, $03, $0f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $d5, $f5, $75, $f4, $f4, $fc, $fc, $fc, $fc, $ff, $ff, $57, $57, $5f, $75, $3d, $3d, $30, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_falling_left_frame2:
                         !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $05, $01, $01, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3d, $ff, $77, $ff, $ff, $ff, $df, $ff, $3f, $ff, $ff, $55, $55, $d5, $f7, $f3, $f3, $33, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
                         !BYTE $00, $00, $00, $10, $50, $50, $50, $40, $40, $c0, $c0, $c0, $c0, $f0, $f0, $70, $70, $f0, $50, $d0, $d0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 63 ========================
; Sprite ID:       sumo_knocked_down_left
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=194; PosY=113
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_knocked_down_left_WIDTH_PX    = 24
sumo_knocked_down_left_HEIGHT_PX   = 32
sumo_knocked_down_left_BIT_PER_PX  = 2
sumo_knocked_down_left_INDEX       = 62
sumo_knocked_down_left_NUM_FRAMES  = 2
sumo_knocked_down_left_frame1:
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $3f, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $0f, $0f, $0f, $01, $01, $0d, $0f, $ff, $ff, $df, $df, $f5, $f5, $fd, $5f, $00, $00, $00, $00, $00, $00, $00, $00
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $f1, $d5, $75, $f4, $f4, $f4, $74, $7c, $fc, $ff, $ff, $ff, $f7, $f7, $5f, $54, $f4, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_knocked_down_left_frame2:
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0d, $0d, $0f, $0f, $ff, $f5, $00, $00, $00, $00, $00, $00, $00, $00
                              !BYTE $00, $00, $00, $00, $00, $00, $00, $0f, $7d, $f7, $ff, $ff, $1f, $17, $d7, $ff, $ff, $ff, $ff, $ff, $5f, $55, $d5, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $50, $50, $40, $40, $40, $40, $c0, $c0, $f0, $f0, $f0, $70, $70, $f0, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 64 ========================
; Sprite ID:       sumo_box_left
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=226; PosY=12
; Dimensions:      24 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_box_left_WIDTH_PX    = 24
sumo_box_left_HEIGHT_PX   = 32
sumo_box_left_BIT_PER_PX  = 2
sumo_box_left_INDEX       = 63
sumo_box_left_NUM_FRAMES  = 2
sumo_box_left_frame1:
                     !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $5f, $5f, $43, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $1f, $3d, $3f, $3f, $07, $05, $35, $ff, $ff, $ff, $3f, $3f, $15, $15, $05, $00, $03, $03, $03, $0f, $00, $00, $00, $00, $00, $00, $00, $00
                     !BYTE $00, $00, $00, $c4, $54, $d4, $d0, $d0, $d0, $d0, $f0, $f0, $fc, $fc, $fc, $dc, $dc, $74, $74, $f0, $c0, $fc, $cf, $cf, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_box_left_frame2:
                     !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $05, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $03, $03, $03, $00, $00, $03, $ff, $ff, $3f, $03, $03, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                     !BYTE $00, $00, $00, $3c, $f5, $dd, $fd, $fd, $7d, $5d, $5f, $ff, $ff, $ff, $ff, $fd, $5d, $57, $57, $0f, $3c, $3f, $3c, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $c0, $40, $40, $00, $00, $c0, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 65 ========================
; Sprite ID:       sumo_climb_up1
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=278; PosY=71
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_climb_up1_WIDTH_PX    = 16
sumo_climb_up1_HEIGHT_PX   = 32
sumo_climb_up1_BIT_PER_PX  = 2
sumo_climb_up1_INDEX       = 64
sumo_climb_up1_NUM_FRAMES  = 2
sumo_climb_up1_frame1:
                      !BYTE $00, $00, $00, $00, $03, $43, $4f, $5d, $4d, $cd, $cf, $cf, $f3, $ff, $3f, $05, $05, $0d, $0f, $0f, $0f, $03, $03, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $5c, $5c, $54, $54, $54, $5c, $fc, $ff, $ff, $fd, $55, $55, $5c, $7c, $3f, $0f, $3c, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_climb_up1_frame2:
                      !BYTE $00, $00, $00, $00, $00, $04, $04, $05, $04, $0c, $0c, $0c, $0f, $0f, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $35, $35, $f5, $d5, $d5, $d5, $f5, $ff, $3f, $ff, $ff, $55, $55, $d5, $f7, $f3, $f0, $33, $30, $f0, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $c0, $c0, $40, $40, $40, $c0, $c0, $f0, $f0, $d0, $50, $50, $c0, $c0, $f0, $f0, $c0, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 66 ========================
; Sprite ID:       sumo_climb_up2
; Sprite Comments: Captured from Screenshot (animation frames.png)
;                  PosX=278; PosY=33
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

sumo_climb_up2_WIDTH_PX    = 16
sumo_climb_up2_HEIGHT_PX   = 32
sumo_climb_up2_BIT_PER_PX  = 2
sumo_climb_up2_INDEX       = 65
sumo_climb_up2_NUM_FRAMES  = 2
sumo_climb_up2_frame1:
                      !BYTE $00, $00, $00, $00, $05, $05, $35, $35, $15, $15, $15, $35, $3f, $ff, $ff, $7f, $55, $55, $35, $3d, $fc, $f0, $3c, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $c0, $f1, $f1, $75, $71, $73, $f3, $f3, $cf, $ff, $fc, $50, $50, $70, $f0, $f0, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
sumo_climb_up2_frame2:
                      !BYTE $00, $00, $00, $00, $00, $00, $03, $03, $01, $01, $01, $03, $03, $0f, $0f, $07, $05, $05, $03, $03, $0f, $0f, $03, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $5c, $5f, $5f, $57, $57, $57, $5f, $ff, $fc, $ff, $ff, $55, $55, $57, $df, $cf, $0f, $cc, $0c, $00, $00, $00, $00, $00, $00, $00, $00
                      !BYTE $00, $00, $00, $00, $00, $00, $10, $10, $50, $10, $30, $30, $30, $f0, $f0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 67 ========================
; Sprite ID:       empty_sprite
; Sprite Comments: Captured from Screenshot (animation frames 2.png)
;                  PosX=194; PosY=113
; Dimensions:      16 x 32 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
; Pre-rendering:   Low2Frames

empty_sprite_WIDTH_PX    = 16
empty_sprite_HEIGHT_PX   = 32
empty_sprite_BIT_PER_PX  = 2
empty_sprite_INDEX       = 66
empty_sprite_NUM_FRAMES  = 2
empty_sprite_frame1:
                    !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
empty_sprite_frame2:
                    !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
                    !BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Retro Sprite Workshop Project END ========================

control_method_ai     = 0
control_method_joy1   = 1
control_method_joy2   = 2
control_method_keyboard = 3

player_control_method
    !BYTE   control_method_joy2

sprite_index_player   =   0
is_player_attacking
    !BYTE   0
player_hit_count
    !BYTE   0

player_hits_per_life = 5

    
player_invulnerability_timer
    !BYTE   0
player_death_pose_timer
    !BYTE   0
player_alive_timer
    !BYTE   0,0

player_invulnerability_time_after_attack  = 40
player_lying_invulnerability_timer      = 12
player_death_pose_length          = 32

player_initial_x_on_screen
    !BYTE   0
player_initial_y_on_screen
    !BYTE   0
player_initial_direction_on_screen
    !BYTE   0
player_current_screen
    !BYTE   0

game_is_in_hard_mode
    !BYTE   0
    
max_y_on_conveyor     = $b8
min_y_on_conveyor     = $30

any_bush_touched
    !BYTE   0

sumo_on_bush_root   =   $80
ninja_on_bush_root    =   $40
player_on_bush_root   =   $20

return_to_main_menu
    !BYTE 00
;---------------------------------------------------------------
;   Player activity main entry point
;---------------------------------------------------------------
player_activity_main_entry_point

    lda   player_death_pose_timer
    beq   player_is_not_dead
    cmp   #$01
    bne   ++
    ;revive player
    lda   player_control_method
    cmp   #control_method_ai
    bne   +
    
    ;demo mode player death
    lda   #$01
    sta   return_to_main_menu
    rts
    
+   ;normal game player death
    jsr   player_death_info_screen
    lda   #$00
    sta   player_alive_timer
    sta   player_alive_timer + 1
    jmp   re_enter_screen
    
++
    dec   player_death_pose_timer
    rts

player_is_not_dead

    ;tick player alive timer
    lda   player_alive_timer + 1
    cmp   #$ff
    beq   ++;max timer, do not tick
    lda   player_alive_timer
    clc
    adc   #$01
    bcc   +
    inc   player_alive_timer + 1
+   sta   player_alive_timer
++   
    lda   is_player_falling
    bne   bruce_falling
    jsr   move_bruce
    cmp   #$ff
    bne   in_animation_skip_physics   ;skip_player_physics

bruce_falling
    jsr   do_player_physics

in_animation_skip_physics

    jsr   check_player_combat_wounds
    
    ;check warp points and other characteristics
    
    lda   last_body_character_behavior
    tax
    and   #character_behavior_warp
    beq   +
    jmp   touched_warp
    
    ;check lamp catch
+
    txa
    and   #character_behavior_lamp
    beq   +
    jmp   touched_lamp
+   
    txa
    and   #character_behavior_conveyor
    beq   ++
    jsr   player_conveyoring
    ;check conveyoring out of screen
    lda   sprite1_data_y
    cmp   #max_y_on_conveyor + 7
    bcc   +
    jsr   move_player_up
    lda   last_body_character_behavior
    tax
    
+   
    cmp   #min_y_on_conveyor - 9
    bcs   ++
    jsr   move_player_down
    ldx   last_body_character_behavior
    
++   
    

    txa
    and   #character_behavior_kill
    beq   +
    jmp   touched_kill
+   
    lda   last_feet_character_behavior
    tax
    and   #character_behavior_kill
    beq   +
    jmp   touched_kill
+   
    txa
    and   #character_behavior_bush_root
    beq   +
    jmp   touched_bush_root
+
    rts
    
touched_kill

    lda   player_current_screen
    cmp   #18
    bne   normal_player_death
    ;special logic for screen 18
    lda   sprite1_data_y
    cmp   #$60
    bcc   normal_player_death
    lda   sprite1_data_frame
    cmp   #frame_lying_left
    beq   player_immunity_crouch
    cmp   #frame_lying_right
    beq   player_immunity_crouch


normal_player_death
    jmp   player_dies
    
touched_bush_root
    lda   any_bush_touched

    ora   #player_on_bush_root
    sta   any_bush_touched
    rts

player_immunity_crouch
    rts
    
;--------------------------------------------------------------------

clear_screen
    sta   $d0
    ldx   #$00
-   lda   #$00
    sta   screen_mem_buffer1,x
    sta   screen_mem_buffer2,x
    sta   screen_mem_buffer1 + $100,x
    sta   screen_mem_buffer2 + $100,x
    sta   screen_mem_buffer1 + $200,x
    sta   screen_mem_buffer2 + $200,x
    sta   screen_mem_buffer1 + $300,x
    sta   screen_mem_buffer2 + $300,x
    lda   $d0
    sta   screen_mem_buffer1 - $400,x
    sta   screen_mem_buffer2 - $400,x
    sta   screen_mem_buffer1 - $300,x
    sta   screen_mem_buffer2 - $300,x
    sta   screen_mem_buffer1 - $200,x
    sta   screen_mem_buffer2 - $200,x
    sta   screen_mem_buffer1 - $100,x
    sta   screen_mem_buffer2 - $100,x

    inx
    bne   -

    rts

;--------------------------------------------------------------------
player_death_info_screen
    
    lda   #SND_OFF
    jsr   (sound_set - music_data_start) + music_target_memory

    sei
    jsr   retain_player_score  ; get score from screen and store for later use
    lda   #$00
    sta   $ff11
    lda   $ff13
    sta   $04
    lda   #$0b
    jsr   show_hide_screen
    lda   #$d8
    sta   $ff13
    lda   #title_scree_blue
    sta   $ff15
    sta   $ff19
    
    lda   #death_screen_text_color
    jsr   clear_screen
    
    lda   current_player
    sta   $df   ;save current player before switching
    lda   game_players
    bne   two_players_mode
    lda   #$00
    sta   current_player
    jmp   decrease_falls

two_players_mode
    lda   current_player
    clc
    adc   #$01
    and   #$01
    sta   current_player  ;alternating


decrease_falls

    lda   falls_counter
    cmp   #digit_zero_INDEX
    bne   +
    lda   falls_counter + 1
    cmp   #digit_zero_INDEX
    bne   +
game_over
    jmp   show_game_over
+
    lda   current_player
    bne   show_next_player
    
    lda   falls_counter + 1
    cmp   #digit_zero_INDEX
    bne   +
    dec   falls_counter
    lda   #digit_9_INDEX + 1
    sta   falls_counter + 1
+
    dec   falls_counter + 1
    
    
show_next_player
    lda   #$1b
    jsr   show_hide_screen
    
    lda   current_player
    jsr   show_player_name

  
    lda   #$0c
    jsr   wait_a_little
    
    jsr   clear_screen
    lda   #$1b
    jsr   show_hide_screen
    lda   #$00
    sta   $ff19
    lda   $04
    sta   $ff13
  
    jsr   change_multiplayer_control_method
    lda   current_player
    jsr   show_player_score
    cli
    rts
;--------------------------------------------------------------------------------------
    
show_game_over
    lda   #$1b
    jsr   show_hide_screen
    lda   $df
    jsr   show_player_name
    lda   $df
    jsr   show_game_over_text
    
    lda   game_players
    bne   two_players_mode_game_over
    lda   #$01
    sta   return_to_main_menu  ;player 1 is dead in a 1 player match... back to main screen
    jmp   wait_and_close_screen
two_players_mode_game_over
    lda   $df
    beq   +
    lda   #$01
    sta   return_to_main_menu  ;player 2 is dead in a 2 players match... back to main screen

wait_and_close_screen
+   

    lda   #$12
    jsr   wait_a_little
    lda   return_to_main_menu
    bne   + ;no chance to return to level
    jsr   clear_screen
    lda   #$1b
    jsr   show_hide_screen
    lda   #$00
    sta   $ff19
    lda   $04
    sta   $ff13
  
    jsr   change_multiplayer_control_method
    cli
    rts
+   
    lda   #$0b
    jsr   show_hide_screen
    cli
    rts

show_game_over_text
    tay
    ldx   #$00
-   lda   big_game_over_line1, x
    sta   screen_mem_buffer1 + $5c,x
    sta   screen_mem_buffer2 + $5c,x
    beq   +
    clc
    adc   #$02
+   sta   screen_mem_buffer1 + 40 + $5c,x
    sta   screen_mem_buffer2 + 40 + $5c,x
    inx   
    cpx   #18
    bne   -

    ;is it for player 1 or 2?
    cpy   #$01
    beq   show_player2_score
show_player1_score
    ldy   #$00
    jmp   show_player2_score + 2

show_player2_score
    ldy   #$06
    ldx   #$00
-   lda   score_player1,y
    sec
    sbc   #$01
    asl
    asl
    clc
    adc   #(big_0 - upper_bound_charset) / 8
    sta   screen_mem_buffer1 + $af + 120,x
    sta   screen_mem_buffer2 + $af + 120,x
    clc
    adc   #$01
    sta   screen_mem_buffer1 + $af + 121,x
    sta   screen_mem_buffer2 + $af + 121,x
    clc
    adc   #$01
    sta   screen_mem_buffer1 + $af + 160,x
    sta   screen_mem_buffer2 + $af + 160,x
    clc
    adc   #$01
    sta   screen_mem_buffer1 + $af + 161,x
    sta   screen_mem_buffer2 + $af + 161,x
    inx
    inx
    iny
    cpx #12
    bne   -
    rts
    


big_game_over_line1
    !BYTE   (big_g - upper_bound_charset) / 8, (big_g - upper_bound_charset) / 8 + 1
    !BYTE   (big_a - upper_bound_charset) / 8, (big_a - upper_bound_charset) / 8 + 1
    !BYTE   (big_m - upper_bound_charset) / 8, (big_m - upper_bound_charset) / 8 + 1
    !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   (big_o - upper_bound_charset) / 8, (big_o - upper_bound_charset) / 8 + 1
    !BYTE   (big_v - upper_bound_charset) / 8, (big_v - upper_bound_charset) / 8 + 1
    !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   (big_r - upper_bound_charset) / 8, (big_r - upper_bound_charset) / 8 + 1
    
show_player_name
    sta   $d0
    ldx   #$00
-   lda   big_player_line1, x
    sta   screen_mem_buffer1 + $ad,x
    sta   screen_mem_buffer2 + $ad,x
    clc
    adc   #$02
    sta   screen_mem_buffer1 + 40 + $ad,x
    sta   screen_mem_buffer2 + 40 + $ad,x
    inx   
    cpx   #12
    bne   -
    
    lda   $d0
    asl
    asl
    clc
    adc   #(big_1 - upper_bound_charset) / 8
    tax
    stx   screen_mem_buffer1 + $bb
    stx   screen_mem_buffer2 + $bb
    inx
    stx   screen_mem_buffer1 + $bb + 1
    stx   screen_mem_buffer2 + $bb + 1
    inx
    stx   screen_mem_buffer1 + $bb + 40
    stx   screen_mem_buffer2 + $bb + 40
    inx
    stx   screen_mem_buffer1 + $bb + 41
    stx   screen_mem_buffer2 + $bb + 41
    rts

wait_a_little
    sta   walp + 1  
    lda   #$00
---   ldx   #$00
--  ldy   #$00
-   iny
    bne   -
    inx
    bne   --
    clc
    adc   #$01
walp  cmp   #$0c
    bcc   ---
    rts
;--------------------------------------------------------------------------------------
change_multiplayer_control_method
;change input method regarding to the settings (swap joysticks)
    lda   sumo_control_method
    cmp   #control_method_ai
    bne   +
    rts
+   ;sumo is controlled by human.. swap joysticks after each turn   
    lda   current_player
    bne   +

    lda   #control_method_joy2
    sta   player_control_method
    lda   #control_method_joy1
    sta   sumo_control_method
    rts 
+   
    lda   #control_method_joy1
    sta   player_control_method

    lda   #control_method_joy2
    sta   sumo_control_method
    rts 
;-------------------------------------------------------------------------------------- 
big_player_line1
    !BYTE   (big_p - upper_bound_charset) / 8, (big_p - upper_bound_charset) / 8 + 1
    !BYTE   (big_l - upper_bound_charset) / 8, (big_l - upper_bound_charset) / 8 + 1
    !BYTE   (big_a - upper_bound_charset) / 8, (big_a - upper_bound_charset) / 8 + 1
    !BYTE   (big_y - upper_bound_charset) / 8, (big_y - upper_bound_charset) / 8 + 1
    !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   (big_r - upper_bound_charset) / 8, (big_r - upper_bound_charset) / 8 + 1
;--------------------------------------------------------------------   
player_conveyoring 
    
    lda   sprite1_data_frame
    cmp   #frame_climb1_up
    beq   +
    cmp   #frame_climb2_up
    beq   +
    rts   ; do not react to conveyor when conveyor is not grabbed
+
    lda   conveyor_move_event
    cmp   #conveyor_event_moved_up
    beq   player_conveyoring_up
    cmp   #conveyor_event_moved_down
    beq   player_conveyoring_down
    rts
player_conveyoring_up
    jsr   move_player_up
    jmp   move_player_up
player_conveyoring_down
    jsr   move_player_down
    jmp   move_player_down
+
    rts

player_dies   ;--------------------------------------------------------------------
    lda   #$ff
    sta   player_invulnerability_timer    ;do not accept attack from enemies in death pose
    lda   #player_death_pose_length
    sta   player_death_pose_timer
    ldx   #frame_jump1_up_left
    lda   last_player_direction
    beq   +
    ldx   #frame_jump1_up_right
+   stx   sprite1_data_frame
    lda   #SND_PLAYERDEATH
    jsr   (sound_set - music_data_start) + music_target_memory
    rts
    
touched_lamp  ;--------------------------------------------------------------------
    
    lda   pointer_to_current_level_lamps    ;1c-1d pointer to lamps on current level
    sta   $1c
    lda   pointer_to_current_level_lamps + 1
    sta   $1d
    
    ;get sprite char x and y pos
    lda   sprite1_data_x
    lsr
    lsr
    sec
    sbc   #$05    ;x off-screen compensation
    sta   $d6     ;sprite char x

    lda   sprite1_data_y
    lsr
    lsr
    lsr
    sec
    sbc   #$03    ;y off-screen compensation
    sta   $d7     ;sprite char y




  ; lda   $d7
  ; asl
  ; tax
  ; lda   screen_rows_mul_table,x
  ; sta   $40
  ; lda   screen_rows_mul_table + 1,x
  ; clc
  ; adc #$0c
  ; sta   $41
    
  ; lda $40
  ; clc
  ; adc $d6
  ; bcc +
  ; inc $41
;+      sta $40
  
; lda #$01
; ldy #$00
; sta ($40),y
    ;byt  $f2






    ;  ----- main loop
    ldy   #$00
-
    sty   $d8
    lda   ($1c),y   ;index of lamp
    cmp   #$ff
    beq   no_more_lamps_for_checking
    tax
    lda   lamp_status_flags, x
    beq   lamp_already_taken_no_need_to_check
    
    iny
    lda   ($1c),y   ;x pos of lamp
    and   #$7f
    sta   $d4     ;lamp x
    iny
    lda   ($1c),y   ;y pos of lamp
    sta   $d5     ;lamp y
    
    ; check positions
    ;byt    $f2
    lda   $d6  ;sprite x
    cmp   $d4 ;lamp  x
    bcs   lamp_not_covered
    clc
    adc   #$03
    cmp   $d4 ;lamp  x
    bcc   lamp_not_covered
    ;here we match x, check y
    ;byt    $f2

    lda   $d7  ;sprite y
    cmp   $d5 ;lamp  y
    bcs   lamp_not_covered
    clc
    adc   #$03
    cmp   $d5 ;lamp yx
    bcc   lamp_not_covered
    
    ; here, lamp touched
    ;x is the lamp index
    lda   lamp_status_flags, x
    cmp   #1
    bne   +
    ;TODO: ADD SOUND EFFECT HERE at scoring - lantern pick
    stx   $59
    sty   $5a

    lda   #SND_LANTERN
    jsr   (sound_set - music_data_start) + music_target_memory
    
    lda   #$03
    jsr   add_score
    ldx   $59
    ldy   $5a
+   
    lda   #$fc    ; -2 will turn to 0 in 2 steps and will clear the item on both buffers
    sta   lamp_status_flags, x   ; invalidate flag
    

    ;byt $f2
    
lamp_not_covered    
lamp_already_taken_no_need_to_check
    ldy   $d8
    iny
    iny
    iny
    bne   -

no_more_lamps_for_checking
    rts

;--------------------------------------------------------------------
;     CHECK PLAYER COMBAT WOUNDS
;--------------------------------------------------------------------
check_player_combat_wounds
    
    lda   player_invulnerability_timer
    beq   ++
    cmp   #20
    bcs   +

    lda   player_hit_count
    bne   +
    ;player is out of life... make death sequence
    lda   #$ff
    sta   player_invulnerability_timer    ;do not accept attack from enemies in death pose
    lda   #$01    ;short death pose, die immediately without posing
    sta   player_death_pose_timer
    rts
+

    dec   player_invulnerability_timer   ;decrease timer
    rts   ; player is temporarily invulnerable
++
    ;lda    sprite1_data_frame
    ;cmp    #frame_lying_left
    ;beq    no_wound_check    ;no wound is possible in a defending pose
    ;cmp    #frame_lying_right
    ;beq    no_wound_check    ;no wound is possible in a defending pose

    ;cmp    #frame_knocked_down_left
    ;beq    no_wound_check    ;no wound is possible in a defending pose
    ;cmp    #frame_knocked_down_right
    ;beq    no_wound_check    ;no wound is possible in a defending pose

    ;cmp    #frame_pain_drop_left
    ;beq    no_wound_check    ;no wound is possible in a defending pose
    ;cmp    #frame_pain_drop_right
    ;beq    no_wound_check    ;no wound is possible in a defending pose

    ;cmp    #frame_jump1_up_left
    ;beq    no_wound_check    ;no wound is possible in a death pose
    ;cmp    #frame_jump1_up_right
    ;beq    no_wound_check    ;no wound is possible in a death pose

    lda   is_player_falling
    sta   $07
    ;byt  $f2
player_check_ninja_attack
    lda   is_ninja_attacking
    clc
    adc   is_ninja_falling
    beq   player_check_sumo_attack
    
    ldx   #sprite_index_player
    ldy   #sprite_index_ninja
    lda   is_ninja_falling
    sta   $06
    lda   last_ninja_direction
    jsr   check_attack_from_sprite
    and   #$7f
    bne   player_wounded_from_ninja     ; return value <> attack_received_noattack
    
player_check_sumo_attack
    lda   is_sumo_attacking
    clc
    adc   is_sumo_falling
    beq   no_wound_check

    ldx   #sprite_index_player
    ldy   #sprite_index_sumo
    lda   is_sumo_falling
    sta   $06
    lda   last_sumo_direction
    jsr   check_attack_from_sprite
    and   #$7f
    bne   player_wounded_from_sumo      ; return value <> attack_received_noattack

no_wound_check
    rts

player_wounded_from_ninja
    tax
    lda   is_ninja_falling
    and   is_player_falling
    beq   +
    rts   ;no harm when both are falling
    
+   
    txa
    jmp   player_wounded

player_wounded_from_sumo
    tax
    lda   is_player_falling
    and   is_sumo_falling
    beq   +
    rts   ;no harm when both are falling
    
+   
    txa
    sta   $aa
    lda   #SND_HIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   $aa
    ldx   #$ff
    stx   sumo_anim_disable_left_right_move
    ;sta    $d0
    ;jsr    stop_sumo_animation
    ;lda    $d0
    

player_wounded
    ldx   level_time    ;shuffle the random seed a bit
    stx   next_random_pointer
    
    dec   player_hit_count

    ldx   #player_invulnerability_time_after_attack
    stx   player_invulnerability_timer    ;make player defended for a few seconds on the ground
    
    cmp   #attack_received_fall_to_ground_left
    beq   player_attacked_fall_left
    cmp   #attack_received_fall_to_ground_right
    beq   player_attacked_fall_right

    cmp   #attack_received_from_the_sky
    beq   player_attacked_from_above

    ldx   #$05              ;just a slight damage from sword, make small invulnerability
    stx   player_invulnerability_timer    
    
    cmp   #attack_received_backup_left
    beq   player_attacked_backup_left
    cmp   #attack_received_backup_right
    beq   player_attacked_backup_right
    ; attacked, stand on feet
    ;inc    $ff19 
    rts
player_attacked_fall_left
    lda   #player_anim_id_fall_right
    jmp   start_player_animation
player_attacked_fall_right
    lda   #player_anim_id_fall_left
    jmp   start_player_animation

player_attacked_from_above
    lda   #SND_HIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   last_player_direction
    bne   +
    lda   #player_anim_id_faint_right
    jmp   start_player_animation
+
    lda   #player_anim_id_faint_left
    jmp   start_player_animation

player_attacked_backup_left
    lda   #SND_SWORDHIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   #player_anim_id_backup_right
    jmp   start_player_animation
player_attacked_backup_right
    lda   #SND_SWORDHIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   #player_anim_id_backup_left
    jmp   start_player_animation



;--------------------------------------------------------------------
;TODO: ADD SOUND EFFECT HERE at scoring - enemy wounded
;--------------------------------------------------------------------
player_wounded_enemy
    sta   $58
    lda   #SND_HIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   $58

    cmp   #attack_received_from_the_sky
    beq   add_score_50_land_on_head
    cmp   #attack_received_fall_to_ground_left
    beq   add_score_for_kick_or_box
    cmp   #attack_received_fall_to_ground_right
    beq   add_score_for_kick_or_box
    rts
add_score_50_land_on_head
    lda   #$00
    jsr   add_score   
    lda   $58
    rts
add_score_for_kick_or_box
    lda   $0f
    and   #attack_received_from_punch
    bne   add_score_100_enemy_punched
add_score_75_enemy_kicked

    lda   #$01
    jsr   add_score   
    lda   $58
    rts
add_score_100_enemy_punched
    lda   #$02
    jsr   add_score   
    lda   $58
    rts
;--------------------------------------------------------------------
;     CHECK ATTACK FROM SPRITE    Parameters: X - receiver sprite index  
;                           Y - attacker sprite index
;                           AC - attacker side 0 - left
;                           $06 - is attacker falling
;                           $07 - is receiver falling
;                     Returns: AC 0 - no attack, or attack type enum
;--------------------------------------------------------------------
attack_received_noattack        = 0
attack_received_fall_to_ground_left   = 1
attack_received_fall_to_ground_right  = 2
attack_received_backup_left       = 3
attack_received_backup_right      = 4
attack_received_from_the_sky      = 5
attack_received_from_punch        = $80

attack_side_offset_x1
    !BYTE   0,12
    
check_attack_from_sprite
    sta   $d4     ;attacker side
    lda   $07     ;is receiver falling?
    bne   +     ;yes, cannot accept attack from above, check normal wounds
    lda   $06     ;is attacker falling?
    beq   +     ;no, cannot fall onto the victim
    ;byt  $f2
    jmp   check_attack_from_sprite_attacker_is_falling_onto_a_standing_victim
+   
    lda   $d4     ;retrieve attacker side
    txa
    asl
    asl
    asl
    asl
    asl
    tax
    lda   sprite_manifests, x ;receiver sprite x pos
    clc
    adc   #$02  ; shift x / half char
    sta   $d0   ; receiver x1 pos
    clc
    adc   #4    ; sprite box width
    sta   $d2   ; receiver x2 pos
    lda   sprite_manifests + 1, x ;receiver sprite y pos
    clc
    adc   #$03  ;shift y offset / half char
    sta   $d1   ; receiver y1 pos
    clc
    adc   #11   ;sprite box height    8
    sta   $d3   ; receiver y2 pos


    lda   $d4
    and   #$01
    tax
    lda   attack_side_offset_x1, x
    sta   attacker_x_offset + 1
    
    tya
    asl
    asl
    asl
    asl
    asl
    tax
    lda   sprite_manifests, x ;attacker sprite x pos
    clc
attacker_x_offset
    adc   #$02  ; shift x / half char
    sta   $d8   ; attacker x1 pos
    clc
    adc   #2    ; sprite box width - attacker attack in a point, (narrow X)
    sta   $da   ; attacker x2 pos
    lda   sprite_manifests + 1, x ;attacker sprite y pos
    clc
    adc   #$04  ;shift y offset / half char
    sta   $d9   ; attacker y1 pos
    clc
    adc   #10   ;sprite box height    
    sta   $db   ; attacker y2 pos

    lda   sprite_manifests + 2, x ;attacker sprite frame
    sta   $d5     ;attacker sprite frame

    lda   $da
    cmp   $d0
    bcc   no_attack_received

    lda   $db
    cmp   $d1
    bcc   no_attack_received

    lda   $d2
    cmp   $d8
    bcc   no_attack_received

    lda   $d3
    cmp   $d9
    bcc   no_attack_received

    ;check attacker sprite frame
    lda   $d5 ;attacker sprite frame
    cmp   #frame_box_left
    beq   attack_fall_to_ground_punch
    cmp   #frame_box_right
    beq   attack_fall_to_ground_punch
    cmp   #frame_kick2_left
    beq   attack_fall_to_ground
    cmp   #frame_kick2_right
    beq   attack_fall_to_ground
    
    cmp   #frame_sumo_box_left
    beq   attack_fall_to_ground
    cmp   #frame_sumo_box_right
    beq   attack_fall_to_ground
    cmp   #frame_sumo_kick2_left
    beq   attack_fall_to_ground
    cmp   #frame_sumo_kick2_right
    beq   attack_fall_to_ground
    
    
    lda   $d4     ;attacker side
    beq   +
    lda   #attack_received_backup_left  ;attack registered
    rts
+   lda   #attack_received_backup_right ;attack registered
    rts

attack_fall_to_ground
    lda   $d4     ;attacker side
    beq   +
    lda   #attack_received_fall_to_ground_left  ;attack registered
    rts
+   lda   #attack_received_fall_to_ground_right ;attack registered
    rts
attack_fall_to_ground_punch
    lda   $d4     ;attacker side
    beq   +
    lda   #attack_received_fall_to_ground_left + attack_received_from_punch ;attack registered
    rts
+   lda   #attack_received_fall_to_ground_right + attack_received_from_punch  ;attack registered
    rts
  
no_attack_received
    lda   #attack_received_noattack
    rts
    
check_attack_from_sprite_attacker_is_falling_onto_a_standing_victim
    ;byt $f2
    txa
    asl
    asl
    asl
    asl
    asl
    tax
    lda   sprite_manifests, x ;receiver sprite x pos
    clc

    adc   #$03  ; shift x / half char
    sta   $d0   ; receiver x1 pos
    clc
    adc   #4    ; sprite box width
    sta   $d2   ; receiver x2 pos
    lda   sprite_manifests + 1, x ;receiver sprite y pos
    clc
    adc   #04 ;shift y offset / half char
    sta   $d1   ; receiver y1 pos
    clc
    adc   #8    ;sprite box height    
    sta   $d3   ; receiver y2 pos


    tya
    asl
    asl
    asl
    asl
    asl
    tax
    lda   sprite_manifests, x ;attacker sprite x pos
    clc
    adc   #$02  ; shift x / half char
    sta   $d8   ; attacker x1 pos
    clc
    adc   #6    ; sprite box width - attacker attack in a point, (narrow X)
    sta   $da   ; attacker x2 pos
    lda   sprite_manifests + 1, x ;attacker sprite y pos
    clc
    adc   #22 ;shift y offset / half char to the feet
    sta   $d9   ; attacker y1 pos
    clc
    adc   #2  ;sprite box height    
    sta   $db   ; attacker y2 pos


    lda   $da
    cmp   $d0
    bcc   no_attack_received_from_sky

    lda   $db
    cmp   $d1
    bcc   no_attack_received_from_sky

    lda   $d2
    cmp   $d8
    bcc   no_attack_received_from_sky

    lda   $d3
    cmp   $d9
    bcc   no_attack_received_from_sky

    lda   #attack_received_from_the_sky ;attack registered
    rts
    
no_attack_received_from_sky
    lda   #attack_received_noattack
    rts

;--------------------------------------------------------------------
;     TOUCHED WARP
;--------------------------------------------------------------------
touched_warp ;--------------------------------------------------------------------
    ldx   #$00
-   lda   last_character_body_chars, x
    cmp   #warp1_INDEX
    bne   +
    lda   #$01
    jmp   player_warped
+   cmp   #warp2_INDEX
    bne   +
    lda   #$02
    jmp   player_warped
+   cmp   #warp3_INDEX
    bne   +
    lda   #$03
    jmp   player_warped
+   cmp   #warp4_INDEX
    bne   +
    lda   #$04
    jmp   player_warped
+   inx
    cpx   #sprite_char_buffer_size
    bne   -
    rts

;---------------------------------------------------------------
;   ADD ONE LIFE
;---------------------------------------------------------------

add_one_life
    lda   falls_counter + 1
    cmp   #digit_9_INDEX
    bne   +
    lda   #digit_zero_INDEX
    sta   falls_counter + 1
    inc   falls_counter
    rts
+   
    inc   falls_counter + 1
    rts
    
;---------------------------------------------------------------
;   RESET ENVIRONMENT FOR SCREEN CHANGE
;---------------------------------------------------------------
reset_environment_for_screen_change

    lda   #player_hits_per_life
    sta   player_hit_count

    jsr   stop_player_animation
    jsr   stop_player_falling
    lda   #$00
    sta   spawn_timer
    sta   last_body_character_behavior
    sta   last_feet_character_behavior
    sta   current_player_input_delay
    sta   current_sumo_input_delay
    sta   current_ninja_input_delay
    
    jsr   stop_ninja_animation
    jsr   stop_ninja_falling
    lda   #$00
    sta   last_ninja_body_character_behavior
    sta   last_ninja_feet_character_behavior

    jsr   stop_sumo_animation
    jsr   stop_sumo_falling
    
    lda   #$00      ;reset all internal status flags for players and NPCs
    sta   last_sumo_body_character_behavior
    sta   last_sumo_feet_character_behavior
    sta   is_player_attacking
    sta   is_ninja_attacking
    sta   is_sumo_attacking
    sta   player_invulnerability_timer
    sta   player_death_pose_timer
    
    ldx   #frame_standing_left
    lda   last_player_direction
    beq   +
    ldx   #frame_standing_right
+   stx   sprite1_data_frame

    ;hide other sprites
    lda   #$00
    sta   sprite2_data_x  
    sta   sprite2_data_y  
    sta   sprite3_data_x  
    sta   sprite3_data_y  
    
    lda   #frame_empty_sprite
    sta   sprite2_data_frame
    sta   sprite3_data_frame

    lda   #$00
    sta   is_ninja_active
    sta   is_sumo_active
    
    jsr   get_next_random_number
    and   #$0f      ; a little bit random spawn init
    sta   spawn_timer   ;restart enely spawn timer for screen
    
    ;stop pending lamp grabs
    ldx   #$00
-   lda   lamp_status_flags,x
    cmp   #$f0
    bcc   +
    lda   #$00 ;this status flag is in grabbing, reset to hide when re-entering
    sta   lamp_status_flags,x
+
    inx
    cpx   #number_of_lamps
    bne   -
    
    ;reset sprite back buffer from remaining chars
    ldx   #$00
    txa
-

    sta   sprite_back_buffer1,x
    sta   sprite_back_buffer2,x
    inx
    cpx   #number_of_sprite_manifests * sprite_char_buffer_size
    bne   -
    
    
    lda   #$00
    sta   level_time
    sta   level_time + 1
    
    ;reset sprite background check buffer
    ldx   #$00
    txa
-   sta   last_character_body_chars, x
    inx
    cpx   #sprite_char_buffer_size
    bne   -
    
    rts
    
;---------------------------------------------------------------
;   WARP PLAYER - Parameter A=warp index 1-4
;---------------------------------------------------------------
player_warped
    tax
    dex
    txa
    and   #$03
    asl
    tax
    lda   level_header_warp_vector_table,x
    sta   $d0
    lda   level_header_warp_vector_table + 1,x
    sta   $d1
    ldy   #$00
    lda   ($d0),y             ; warp target screen index
    bne   +
    rts   ;target screen index is 0... do not warp...

+   
    sta   player_current_screen
    sta   warp_target_level_index + 1   
    iny
    lda   ($d0),y             ; initial x on new screen
    and   #$fe    ;avoid sprite mask shift
    sta   player_initial_x_on_screen
    iny
    lda   ($d0),y             ; initial y on new screen
    sta   player_initial_y_on_screen
    
    lda   last_player_direction
    sta   player_initial_direction_on_screen

    jsr   before_warp

re_enter_screen
    ; stop running animations, actions, reset internal states etc...
    jsr   reset_environment_for_screen_change

    lda   player_initial_x_on_screen
    sta   sprite1_data_x
    lda   player_initial_y_on_screen
    sta   sprite1_data_y
    lda   player_initial_direction_on_screen
    sta   last_player_direction
    
    ;render target screen
    ; seamless transition, using double buffers 

    jsr   get_next_random_number
    sta   lamp_flash_random
    
    lda   draw_to_screen_buffer
    sta   draw_buffer_backup + 1
    
    lda   buffer_drawing
    beq   redraw_screen_buffer1
    
    ;render scene data to buffer 2
    lda   #screen_mem_buffer2 >> 8
    sta   draw_to_screen_buffer

warp_target_level_index
    lda   #$01  ;level (screen) index
    ldx   #screen_mem_buffer2 >> 8  ;target screen buffer memory
    jsr   render_screen ;buffer 2
    jsr   prepare_screen_action_vectors

    ; initiate save background of the sprites

    ;sprite 1
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer2

    ;sprite 2
    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer2

    ;sprite 3
    lda   #$02    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer2
    
-   lda   $ff1d   ;wait for vsync
    cmp   #$d0
    bcc   -

    lda   #screen_mem_buffer2 >> 8
    sta   $ff14
    
    ;render scene data to buffer 1

    lda   #screen_mem_buffer1 >> 8
    sta   draw_to_screen_buffer

    lda   warp_target_level_index + 1 ;level (screen) index
    ldx   #screen_mem_buffer1 >> 8  ;target screen buffer memory  
    jsr   render_screen ;buffer1
    jsr   prepare_screen_action_vectors
    
    ; initiate save background of the sprites
    
    ;sprite 1
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer1

    ;sprite 2
    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer1

    ;sprite 3
    lda   #$02    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer1
    
-   lda   $ff1d   ;wait for vsync
    cmp   #$d0
    bcc   -

    lda   #screen_mem_buffer1 >> 8
    sta   $ff14
    
    jmp   continue_warping

redraw_screen_buffer1
    
    ;render scene data to buffer 1
    
    lda   #screen_mem_buffer1 >> 8
    sta   draw_to_screen_buffer

    lda   warp_target_level_index + 1 ;level (screen) index
    ldx   #screen_mem_buffer1 >> 8  ;target screen buffer memory  
    jsr   render_screen ;buffer1
    jsr   prepare_screen_action_vectors
    ; initiate save background of the sprites
    
    ;sprite 1
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer1

    ;sprite 2
    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer1

    ;sprite 3
    lda   #$02    ;//sprite index
    jsr   render_sprite_buffer1
    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer1
    
-   lda   $ff1d   ;wait for vsync
    cmp   #$d0
    bcc   -

    lda   #screen_mem_buffer1 >> 8
    sta   $ff14
    
    ;render scene data to buffer 2

    lda   #screen_mem_buffer2 >> 8
    sta   draw_to_screen_buffer

    lda   warp_target_level_index + 1 ;level (screen) index
    ldx   #screen_mem_buffer2 >> 8  ;target screen buffer memory
    jsr   render_screen ;buffer 2
    jsr   prepare_screen_action_vectors

    ; initiate save background of the sprites

    ;sprite 1
    lda   #$00    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$00    ;//sprite index
    jsr   restore_sprite_background_buffer2

    ;sprite 2
    lda   #$01    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$01    ;//sprite index
    jsr   restore_sprite_background_buffer2

    ;sprite 3
    lda   #$02    ;//sprite index
    jsr   render_sprite_buffer2
    lda   #$02    ;//sprite index
    jsr   restore_sprite_background_buffer2
    
-   lda   $ff1d   ;wait for vsync
    cmp   #$d0
    bcc   -

    lda   #screen_mem_buffer2 >> 8
    sta   $ff14
    
continue_warping  

draw_buffer_backup
    lda   #$00
    sta   draw_to_screen_buffer
    
    lda   #sprite_index_player
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_body_character_behavior
    and   #character_behavior_conveyor
    beq   +   
    
    ;player entered on_a_conveyor
    lda   #frame_climb1_up;
    sta   sprite1_data_frame


+

    lda   player_current_screen
    jsr   new_room_visited
    rts
    
before_warp
    jsr   draw_black_bar_below_info
    ;lda    #$00
    ;sta    info_bar_bg_color + 1
;   ldx   #$00
;   txa
;-    sta   screen_mem_buffer1 - $400,x
;   sta   screen_mem_buffer2 - $400,x
;   iny
;   cpy   #$28
;   bne   -
    rts


level_header_warp_vector_table
    !WORD   current_screen_warp1_target, current_screen_warp2_target, current_screen_warp3_target, current_screen_warp4_target
;             6905 : 04 CC             
    

prepare_screen_action_vectors
    lda   current_screen_execution_logic
    sta   screen_exec_logic_ptr + 1
    lda   current_screen_execution_logic + 1
    sta   screen_exec_logic_ptr + 2

    lda   current_screen_execution_logic_init
    sta   init_screen_logic + 1
    lda   current_screen_execution_logic_init + 1
    sta   init_screen_logic + 2

init_screen_logic
    jsr   $0000

    rts
;---------------------------------------------------------------
;   DO PLAYER PHYSICS (falling, etc)
;---------------------------------------------------------------
is_player_falling
    !BYTE   00
    
do_player_physics
    lda   #sprite_index_player
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_body_character_behavior
    sta   $d1   ;this is the character behavior bitmask behind the player body
    and   #character_behavior_ladder
    beq   + ; we have no ladder behind, check platform at feet
    jmp   stop_player_falling ;stop doing more physics, ladder is grabbed
    
+   lda   #sprite_index_player
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_feet_character_behavior
    ;sta    $d0   ;this is the character behavior bitmask below the player
    ;sta    screen_mem_buffer1 + 50,y ;DEBUG
    ;sta    screen_mem_buffer2 + 50,y ;DEBUG
  ;!BYTE $f2
    and   #character_behavior_platform + character_behavior_ladder
    bne   stop_player_falling ; we have something below, skip falling
    
    ;no platform below, fall player
    ldx   #frame_jump3_up
    stx   sprite1_data_frame
    jsr   move_player_down
    lda   #$01
    sta   is_player_falling
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite1_data_x
    and   #$fe
    sta   sprite1_data_x
    rts
    
stop_player_falling
    lda   #$00
    sta   is_player_falling
    rts

;---------------------------------------------------------------
;   MOVE BRUCE LEE ON LADDER
;---------------------------------------------------------------
player_climbing_internal_counter
    !BYTE   0
player_climbing_frame_phase
    !BYTE   0
player_climb_vertical_speed = 6
player_climb_horizontal_counter
    !BYTE   0
player_climb_horizontal_anim_speed = 2

player_climb_horizontal_speed_ladder = 6
player_climb_horizontal_speed_conveyor = 2

alternate_climbing_up_down_frames
    lda   player_climbing_frame_phase
    eor   #$01
    sta   player_climbing_frame_phase
    bne   +
    lda   #frame_climb1_up
    jmp   alternate_1
+
    lda   #frame_climb2_up
    
alternate_1
    sta   sprite1_data_frame 
    rts
    
player_horizontal_climbing_speed
    !BYTE   01
    
climbing_player_up
    lda   sprite1_data_y
    cmp   #$26
    bcs   +
    lda   #$00
    sta   player_climbing_internal_counter
    rts
+   lda   player_climbing_internal_counter
    clc
    adc   #$01
    cmp   #player_climb_vertical_speed
    bcc   cutemp1b

    jsr   move_player_up;
    jsr   move_player_up;
    jsr   move_player_up;

    lda   #sprite_index_player
    ldx   #body_area_head
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_up      ;wall during climbing

    jsr   climb_sound_on_demand
    jsr   alternate_climbing_up_down_frames
    lda   #$00
cutemp1b
    sta   player_climbing_internal_counter
    rts
    
wall_during_climb_up    
    jsr   move_player_down;
    jsr   move_player_down;
    jsr   move_player_down;
    lda   #$00
    sta   player_climbing_internal_counter
    rts
    
climbing_player_down
    
  
    lda   sprite1_data_y
    cmp   #$c0
    bcc   +
    lda   #$00
    sta   player_climbing_internal_counter
    rts
+   lda   player_climbing_internal_counter
    clc
    adc   #$01
    cmp   #player_climb_vertical_speed
    bcc   cutemp2b

    jsr   move_player_down;
    jsr   move_player_down;
    jsr   move_player_down;

    lda   #sprite_index_player
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_feet_character_behavior
    and   #character_behavior_wall
    bne   wall_during_climb_down      ;wall during climbing

    jsr   climb_sound_on_demand
    jsr   alternate_climbing_up_down_frames   
    lda   #$00
cutemp2b
    sta   player_climbing_internal_counter
    rts
wall_during_climb_down
    jsr   move_player_up;
    jsr   move_player_up;
    jsr   move_player_up;
    lda   #$00
    sta   player_climbing_internal_counter
    rts
    
    
climbing_player_left

    lda   player_climbing_internal_counter
    clc
    adc   #$01
    cmp   player_horizontal_climbing_speed
    bcc   cutemp2bleft
    
    jsr   move_player_left;

    lda   #sprite_index_player
    ldx   #body_area_left
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_left      ;wall during climbing

    ;lda    player_climb_horizontal_counter
    ;clc
    ;adc    #$01
    ;sta    player_climb_horizontal_counter
    ;cmp    #player_climb_horizontal_anim_speed
    ;bcc    +
    jsr   climb_sound_on_demand
    jsr   alternate_climbing_up_down_frames 
    ;lda    #$00
    ;sta    player_climb_horizontal_counter
;+    
    lda   #$00
cutemp2bleft
    sta   player_climbing_internal_counter
    rts
wall_during_climb_left
    jsr   move_player_right;
    lda   #$00
    sta   player_climbing_internal_counter
    rts
    
climbing_player_right
  lda   player_climbing_internal_counter
    clc
    adc   #$01
    cmp   player_horizontal_climbing_speed
    bcc   cutemp2bright
    
    jsr   move_player_right;

    lda   #sprite_index_player
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_right     ;wall during climbing

    ;lda    player_climb_horizontal_counter
    ;clc
    ;adc    #$01
    ;sta    player_climb_horizontal_counter
    ;cmp    #player_climb_horizontal_anim_speed
    ;bcc    +
    jsr   climb_sound_on_demand
    jsr   alternate_climbing_up_down_frames 
    ;lda    #$00
    ;sta    player_climb_horizontal_counter
;+    

    lda   #$00
cutemp2bright
    sta   player_climbing_internal_counter
    rts
wall_during_climb_right
    jsr   move_player_left;
    lda   #$00
    sta   player_climbing_internal_counter
    rts   
;---------------------------------------------------------------
;   MOVE BRUCE LEE USING JOYSTICK ON GROUND
;---------------------------------------------------------------  
current_player_input_delay
    !BYTE   00
delay_after_wall_hit = 6
    
move_bruce:

    jsr   progress_player_animation
    cmp   #$ff
    beq   +
    ;animation is currently running, no player input accepted
    lda   #$00
    rts   
+
    ; get directions from joystick
    lda   current_player_input_delay
    beq   + ; time to read joystick
    dec   current_player_input_delay
    jmp   player_standing_still
+   
    jsr   read_game_input

    lda   #sprite_index_player
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_body_character_behavior
    tax
    and   #character_behavior_ladder
    beq   normal_movements  ;no ladder behind our body_area_body
    
    ; set speed conveyor or ladder?
    ldy   #player_climb_horizontal_speed_ladder
    txa
    and   #character_behavior_conveyor
    bne   player_on_a_ladder
    ldy   #player_climb_horizontal_speed_conveyor
player_on_a_ladder
    sty   player_horizontal_climbing_speed
    
    ;------ ladder movements
    jsr   stop_player_animation ;when in the middle of jump, etc, just stop the animation

    lda   joy_player_down
    bne   +
    ;climbing down
    jsr   climbing_player_down
    jmp   player_moved_but_no_physics
    
+
    lda   joy_player_up
    bne   +
    ;climbing up
    jsr   climbing_player_up
    jmp   player_moved_but_no_physics
+
    lda   joy_player_left
    bne   +
    ;climbing left
    jsr   climbing_player_left
    jmp   player_moved_but_no_physics
+   
    lda   joy_player_right
    bne   +
    ;climbing right
    jsr   climbing_player_right
    jmp   player_moved_but_no_physics
+   
    lda   #$00
    sta   player_climbing_internal_counter

    jmp   player_moved_but_no_physics
    
    
    ;----- normal movements jumping, lying, boxing, kicking
normal_movements    

    lda   joy_player_down
    bne   +
    ;lying on the floor
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite1_data_x
    and   #$fe
    sta   sprite1_data_x
    lda   last_player_direction
    beq   plfacingleft
    lda   #player_anim_id_lying_right
    jsr   start_player_animation
    lda   #player_lying_invulnerability_timer
    sta   player_invulnerability_timer
    jmp   player_moved

plfacingleft    
    lda   #player_anim_id_lying_left
    jsr   start_player_animation
    lda   #player_lying_invulnerability_timer
    sta   player_invulnerability_timer
    jmp   player_moved

+   
    lda   joy_player_left
    bne   ++++
    lda   joy_player_up
    bne   ++
    ;jump left
    lda   #player_anim_id_jump_left
    jsr   start_player_animation
    jmp   player_moved
++   
    lda   joy_player_fire
    bne   +++
    ;jump kick left
    lda   #sprite_index_player
    ldx   #body_area_left_kick_prep
    ;byt    $f2
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_left     ;wall before kick  beq********************
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    jmp   player_moved
wall_during_kick_left
    lda   #player_anim_id_kick_left
    jsr   start_player_animation
    lda   #SND_HIGHKICK1
    jsr   (sound_set - music_data_start) + music_target_memory
    jmp   player_moved
    
+++   
    ; move player left
    ;check last_body_character_behavior against wall
    lda   #sprite_index_player
    ldx   #body_area_left
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   no_wall_left
    ;jsr    move_player_right
    ;jsr    move_player_right
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    lda   #$00
    sta   last_player_direction
    jmp   player_moved

no_wall_left    
    lda   #frame_running_left
    sta   sprite1_data_frame
    jsr   move_player_left
    jsr   run_sound_on_demand
    jmp   player_moved
++++   
    lda   joy_player_right
    bne   ++++
    lda   joy_player_up
    bne   ++
    ;jump right
    lda   #player_anim_id_jump_right
    jsr   start_player_animation
    jmp   player_moved
++   
    lda   joy_player_fire
    bne   +++
    ;jump kick right
    lda   #sprite_index_player
    ldx   #body_area_right_kick_prep
    ;byt    $f2
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_right      ;wall before kick  beq***********************
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    jmp   player_moved
wall_during_kick_right
    lda   #player_anim_id_kick_right
    jsr   start_player_animation
    lda   #SND_HIGHKICK1
    jsr   (sound_set - music_data_start) + music_target_memory
    jmp   player_moved
    
+++   
    ; move player right
    ;check last_body_character_behavior against wall
    lda   #sprite_index_player
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   no_wall_right
    ;jsr    move_player_left
    ;jsr    move_player_left
    lda   #$01
    sta   last_player_direction
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    jmp   player_moved
no_wall_right
    lda   #frame_running_right
    sta   sprite1_data_frame
    jsr   move_player_right
    jsr   run_sound_on_demand
    jmp   player_moved
++++   
    lda   joy_player_up
    bne   +
    ;jump up

    lda   last_player_direction
    bne   plfright
    lda   #player_anim_id_jump_up_left
    jsr   start_player_animation
    jmp   player_moved
plfright
    lda   #player_anim_id_jump_up_right
    jsr   start_player_animation
    jmp   player_moved
    
+

    lda   joy_player_fire
    bne   +
    ;box punch
    lda   last_player_direction
    cmp   #$00
    beq   box_left_dir
    lda   #player_anim_id_box_right
    jsr   start_player_animation
    jmp   player_moved
box_left_dir:
    lda   #player_anim_id_box_left
    jsr   start_player_animation
    jmp   player_moved


+   
player_standing_still
    ;  nothing pressed
    ;  player standing still
    lda   last_body_character_behavior
    and   #character_behavior_conveyor
    bne   standing_on_a_conveyor
    
    lda   last_player_direction
    bne   +
    lda   #frame_standing_left;
    sta   sprite1_data_frame
    jmp   player_moved
+
    lda   #frame_standing_right;
    sta   sprite1_data_frame
    jmp   player_moved
    
standing_on_a_conveyor
    lda   #frame_climb1_up;
    sta   sprite1_data_frame
    jmp   player_moved



player_moved
    lda   #$ff    ;returns ff means no animation, do the physics
    rts

player_moved_but_no_physics
    lda   #$00    ;returns 00 means do not do the physics
    rts
    
climb_sound_on_demand
    lda   #SND_CLIMB
    jmp   (sound_set - music_data_start) + music_target_memory
    
run_sound_on_demand
    lda   sprite1_data_x
    and   #$03
    bne   +
    lda   #SND_RUN
    jsr   (sound_set - music_data_start) + music_target_memory
+   rts

player_anim_current_frame:
    !BYTE 0
player_anim_subtimer:
    !BYTE 0
anim_subtimer_timeout   = 2
player_anim_disable_left_right_move
    !BYTE 0
player_current_anim_running
    !BYTE 0
;-----------------------------------------------------------------------------------------
;     STOP ANIMATION      
;-----------------------------------------------------------------------------------------
stop_player_animation:
    lda   #anim_id_no_animation
    jmp   start_player_animation

;-----------------------------------------------------------------------------------------
;     START ANIMATION       param:    A = animation sequence id
;-----------------------------------------------------------------------------------------
start_player_animation:

    sta   player_current_anim_running
    asl
    tax
    lda   animation_sequences,x
    sta   anim_seq + 1
    sta   anim_seq2 + 1
    sta   anim_seq3 + 1
    sta   anim_seq4 + 1
    lda   animation_sequences + 1,x
    sta   anim_seq + 2
    sta   anim_seq2 + 2
    sta   anim_seq3 + 2
    sta   anim_seq4 + 2
    lda   #$00
    sta   player_anim_current_frame
    sta   player_anim_subtimer
    sta   player_anim_disable_left_right_move
    rts

;-----------------------------------------------------------------------------------------
;     PROGRESS ANIMATION        does next anim sequence action
;-----------------------------------------------------------------------------------------
;last_body_character_behavior = $e4
;last_feet_character_behavior = $e5

progress_player_animation:
    
    lda   player_anim_current_frame
    asl
    asl
    tax
anim_seq
    lda animation_sequences,x
    cmp   #RESTORE_LADDER_GRAB
    bne   +
    lda   #sprite_index_player    ; Check player on ladder at the end of animation
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_body_character_behavior    
    jsr   player_grabs_ladder_when_necessary
    inc   player_anim_current_frame
    lda   #$ff

+   cmp   #$ff
    bne   +
    ldx   #$00
    stx   is_player_attacking
    rts   ;return 255, no animation needed any more, reached last frame
+
    sta   $d2
    inx
anim_seq2
    lda   animation_sequences,x
    sta   $d1
    inx
anim_seq3
    lda   animation_sequences,x ;is this step timer-dependent?
    sta   $d0

    inx
anim_seq4
    lda   animation_sequences,x ;force player direction flag
    sta   $e3
    
    inc   player_anim_subtimer
    ldy   player_anim_subtimer
    cpy   #anim_subtimer_timeout
    bcc   + ;timer not reached, play current anim frame action step again

    ;timer reached, restart timer, advance to next animation 
    inc   player_anim_current_frame
    ldy   #$00    ;restart timer
    sty   player_anim_subtimer
  
+
    lda   $d0
    beq   do_action_move    ;no timer dependent, do immediately
    
    ;go to the next frame immediately for special, timer-dependent animation steps
    inc   player_anim_current_frame
    ldy   #$00    ;restart timer
    sty   player_anim_subtimer
    
do_action_move
    lda   $d2 ;sprite frame id
    sta   sprite1_data_frame    ;action sequence first byte is the sprite frame
    lda   $d1 ;second byte is the movement operator: direction + count
    tay
    and   #$07
    sta   number_of_moves + 1
    tya
    and   #action_move_attack_moment
    sta   is_player_attacking
    tya
    sta   $e1

    ldx   #$00
-   stx   $e0

    ; animation movements are checking the screen elements to stop animations
    lda   #sprite_index_player    ; sprite 0
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_body_character_behavior
    and   #character_behavior_ladder
    beq   +
    lda   player_current_anim_running
    cmp   #player_anim_id_fall_right
    beq   +   ;can fall on ladder
    cmp   #player_anim_id_fall_left
    beq   +   ;can fall on ladder
    cmp   #player_anim_id_backup_left
    beq   +   ;can fall on ladder
    cmp   #player_anim_id_backup_right
    beq   +   ;can fall on ladder
    jmp   action_skip_more_move_directions_ladder ; we have ladder below, skip moving 
+
    lda   $e1
    and   #action_move_down
    beq   +

    lda   #sprite_index_player    ; sprite 0
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_feet_character_behavior
    and   #character_behavior_platform + character_behavior_ladder
    bne   action_platform_on_move_down_player ; we have platform below, skip moving 
    jsr   move_player_down
+   
continue_from_knock_down_player
    lda   $e1
    and   #action_move_up
    beq   +
    
    jsr   move_player_up
+   
    lda   $e1
    and   #action_move_left
    beq   +
    lda   last_body_character_behavior      ;body character behavior
    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_right ; we have a wall near, skip moving 
    jsr   move_player_left_from_animation
+   
    lda   $e1
    and   #action_move_right
    beq   +
    lda   last_body_character_behavior
    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_left ; we have a wall near, skip moving 
    jsr   move_player_right_from_animation
+
    ldx   $e0
    inx

number_of_moves
    cpx   #$01
    bne   -

    lda   $e3   ;at the end of all moves, force player direction
    sta   last_player_direction

    lda   #$00
    rts

action_platform_on_move_down_player 
    lda   player_current_anim_running
    cmp   #player_anim_id_fall_left
    beq   +
    cmp   #player_anim_id_fall_right
    beq   +
    lda   $e3
    sta   last_player_direction
    jsr   player_grabs_ladder_when_necessary
    lda   #$ff
    rts
+
    jsr   move_player_down
    jmp   continue_from_knock_down_player
    
action_skip_more_move_directions    
    lda   $e3   ;at the end of all moves, force player direction
    sta   last_player_direction
    jsr   player_grabs_ladder_when_necessary
    lda   #$ff
    rts

action_skip_more_move_directions_with_move_right
    jsr   move_player_right
    jsr   move_player_right
    jsr   move_player_right
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_player_direction
    jsr   stop_player_animation
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    jsr   player_grabs_ladder_when_necessary
    lda   #$ff
    rts

action_skip_more_move_directions_with_move_left
    jsr   move_player_left
    jsr   move_player_left
    jsr   move_player_left
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_player_direction
    jsr   stop_player_animation
    lda   #delay_after_wall_hit
    sta   current_player_input_delay
    jsr   player_grabs_ladder_when_necessary
    lda   #$ff
    rts

action_skip_more_move_directions_ladder   
    lda   $e3   ;at the end of all moves, force player direction
    sta   last_player_direction
    
    jsr   player_grabs_ladder_when_necessary
    lda   #$ff
    rts

move_player_left_from_animation
    lda   player_anim_disable_left_right_move
    beq   +
    lda   $d0       ;forced frame move, do this everytime
    bne   +
    rts
+
    jmp   move_player_left

move_player_right_from_animation
    lda   player_anim_disable_left_right_move
    beq   +
    lda   $d0       ;forced frame move, do this everytime
    bne   +
    rts
+
    jmp   move_player_right

;---------------------------------------------------------
;     MOVE PLAYER (UP/DOWN/LEFT/RIGHT)
;--------------------------------------------------------
move_player_left:
    ldx   #$00
    stx   last_player_direction
;   lda   player_control_method
;   cmp   #control_method_ai
;   beq   ++
;   lda   sprite1_data_x
;   cmp   #$08
;   bcc   +
;   dec   sprite1_data_x
;+    rts
;+
    ;ai x limit

    lda   sprite1_data_x
    cmp   #$12
    bcc   +
    dec   sprite1_data_x
+   rts

move_player_right:
    ldx   #$01
    stx   last_player_direction
;   lda   player_control_method
;   cmp   #control_method_ai
;   beq   ++
;   lda   sprite1_data_x
;   cmp   #limit_sprite_x_pos
;   bcs   +
;   inc   sprite1_data_x
;+    rts
;+
    ;ai x limit
    lda   sprite1_data_x
    cmp   #$a8
    bcs   +
    inc   sprite1_data_x
+   rts

move_player_up:
    ;lda  #$77
    ;sta $ff19
    lda   sprite1_data_y
    cmp   #$21
    bcc   +
    dec   sprite1_data_y
+   rts

move_player_down:
    ;lda  #$77
    ;inc $ff19
    lda   sprite1_data_y
    cmp   #limit_sprite_y_pos
    bcs   +
    inc   sprite1_data_y
+   
    rts

;-------------------------------------------------------------------------------------
player_grabs_ladder_when_necessary

    lda   last_body_character_behavior
    and   #character_behavior_ladder
    beq   +
    
    ;we stand on a ladder... set anim frame
    lda   #frame_climb1_up    
    sta   sprite1_data_frame
    lda   #$00
    sta   player_climbing_frame_phase   
+   
    rts

;-------------------------------------------------------------------------------------
;   ANIMATIONS AND SEQUENCES
;-------------------------------------------------------------------------------------
action_move_up        = $80
action_move_down      = $40
action_move_left      = $20
action_move_right     = $10
action_move_attack_moment = $08
action_move_no_move     = $01 ; no direction, 1 step

RESTORE_LADDER_GRAB     = $fe

animation_sequences:
anim_id_no_animation          = 0
      !WORD anim_seq_no_animation
player_anim_id_jump_left        = 1
      !WORD anim_seq_jump_left
player_anim_id_jump_right       = 2
      !WORD anim_seq_jump_right
player_anim_id_jump_up_left       = 3
      !WORD anim_seq_jump_up_left
player_anim_id_jump_up_right      = 4
      !WORD anim_seq_jump_up_right
player_anim_id_box_left         = 5
      !WORD anim_seq_box_left
player_anim_id_box_right        = 6
      !WORD anim_seq_box_right
player_anim_id_kick_left        = 7
      !WORD anim_seq_kick_left
player_anim_id_kick_right       = 8
      !WORD anim_seq_kick_right
player_anim_id_lying_right        = 9
      !WORD anim_seq_lying_right
player_anim_id_lying_left       = 10
      !WORD anim_seq_lying_left
player_anim_id_fall_right       = 11
      !WORD anim_seq_fall_right
player_anim_id_fall_left        = 12
      !WORD anim_seq_fall_left
player_anim_id_backup_right       = 13
      !WORD anim_seq_backup_right
player_anim_id_backup_left        = 14
      !WORD anim_seq_backup_left
player_anim_id_faint_right        = 15
      !WORD anim_seq_faint_right
player_anim_id_faint_left       = 16
      !WORD anim_seq_faint_left
      
anim_seq_no_animation:
      !BYTE 255

anim_seq_jump_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_jumping1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_jumping1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_jumping1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_jumping1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_jumping2_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_jumping2_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_jumping2_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_jumping2_left, action_move_left + 1, 1, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_jumping2_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_jumping2_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_jumping2_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_jumping2_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_jumping1_left, action_move_down + action_move_left+ 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_jumping1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_jumping1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE 255

anim_seq_jump_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_jumping1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_jumping1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_jumping1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_jumping1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_jumping2_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_jumping2_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_jumping2_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_jumping2_right, action_move_right + 1, 1, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_jumping2_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_jumping2_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_jumping2_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_jumping2_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_jumping1_right, action_move_down + action_move_right+ 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_jumping1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_jumping1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE 255

anim_seq_jump_up_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_jump1_up_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame1_up
      !BYTE frame_jump2_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame2_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump2_up, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame2_down
      !BYTE frame_jump1_up_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE 255

anim_seq_jump_up_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_jump1_up_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame1_up
      !BYTE frame_jump2_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame2_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_jump3_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump3_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_jump2_up, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame2_down
      !BYTE frame_jump1_up_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255
      
anim_seq_box_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_box_left, action_move_left + 4 + action_move_attack_moment, 1, 0 ;anim_action_box_punch_left_with_move
      !BYTE frame_box_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_box_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_standing_left, action_move_right + 4, 1, 0 ;anim_action_standing_left
      !BYTE 255

anim_seq_box_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_box_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right_with_move
      !BYTE frame_box_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_box_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255
    
anim_seq_kick_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_kick1_left, action_move_left + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_kick1_left, action_move_left + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_kick2_left, action_move_left + 4, 1, 0 ;anim_action_kick2_left_with_move
      !BYTE frame_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      ;!BYTE frame_kick2_left, action_move_left + 1, 0, 0 ;anim_action_kick2_left
      ;!BYTE frame_kick2_left, action_move_left + 1, 0, 0 ;anim_action_kick2_left 
      !BYTE frame_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_kick1_left, action_move_right + 4, 1, 0 ;anim_action_kick2_left_with_move_back
      !BYTE frame_kick1_left, action_move_left + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE frame_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE 255

anim_seq_kick_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_kick1_right, action_move_right + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_kick1_right, action_move_right + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_kick2_right, action_move_right + 1, 0, 1 ;anim_action_kick2_right
      !BYTE frame_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      ;!BYTE frame_kick2_right, action_move_right + 1, 0, 1 ;anim_action_kick2_right
      ;!BYTE frame_kick2_right, action_move_right + 1, 0, 1 ;anim_action_kick2_right
      !BYTE frame_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right 
      !BYTE frame_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      !BYTE frame_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      !BYTE frame_kick1_right, action_move_right + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255

anim_seq_lying_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_lying_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_lying_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_lying_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_lying_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE 255     

anim_seq_lying_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_lying_left, action_move_no_move, 0, 0 
      !BYTE frame_lying_left, action_move_no_move, 0, 0 
      !BYTE frame_lying_left, action_move_no_move, 0, 0 
      !BYTE frame_lying_left, action_move_no_move, 0, 0 
      !BYTE 255     

anim_seq_fall_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_pain_drop_right, action_move_left +  2, 0, 1 
      !BYTE frame_pain_drop_right, action_move_left +  2, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left +  2, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move + action_move_down + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move + action_move_down + 1, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

anim_seq_fall_right: 
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_pain_drop_left, action_move_right + 2, 0, 0 
      !BYTE frame_pain_drop_left, action_move_right + 2, 0, 0 
      !BYTE frame_knocked_down_left, action_move_left + 2, 1, 0 
      !BYTE frame_knocked_down_left, action_move_right + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_right + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_right + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move + action_move_down + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move + action_move_down + 1, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_standing_left, action_move_right + 4, 1, 0 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

anim_seq_backup_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_standing_right, action_move_left + 1, 0, 1 
      !BYTE frame_standing_right, action_move_left + 1, 0, 1 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

anim_seq_backup_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_standing_left, action_move_right + 1, 0, 0 
      !BYTE frame_standing_left, action_move_right + 1, 0, 0 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

anim_seq_faint_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

anim_seq_faint_right: 
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_pain_drop_left, action_move_left + 1, 1, 0
      !BYTE frame_pain_drop_left, action_move_no_move, 0, 0 
      !BYTE frame_pain_drop_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_standing_left, action_move_right + 1, 1, 0 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     
      
last_player_direction:
        !BYTE 0;    0 - left; 1- right
        
;     registers are 0 when pressed
joy_player_up     !BYTE 255
joy_player_down   !BYTE 255
joy_player_left   !BYTE 255
joy_player_right    !BYTE 255
joy_player_fire   !BYTE 255

read_game_input:

    lda   player_control_method
    cmp   #control_method_joy1
    beq   player_joy1
    cmp   #control_method_joy2
    beq   player_joy2
    cmp   #control_method_keyboard
    beq   player_keyboard
    jmp   player_ai
    
player_joy1 
    lda   #$fb
    sta   $fd30
    sta   $ff08
    jmp   read_player_controls
player_joy2
    lda   #$fd
    sta   $fd30
    sta   $ff08
    jmp   read_player_controls
player_keyboard
    lda   #$f7
    sta   $fd30
    sta   $ff08
    
read_player_controls
    lda   $ff08
    tax
    and   #$01
    sta   joy_player_up
    txa
    and   #$02
    sta   joy_player_down
    txa
    and   #$04
    sta   joy_player_left
    txa
    and   #$08
    sta   joy_player_right
    txa
    and   #$c0
    cmp   #$c0
    beq   +
    lda   #$00
    sta   joy_player_fire
    rts
+
    sta   joy_player_fire
    rts

;---------------------------------------------------------------------
;       PLAYER AI TACTIC
;---------------------------------------------------------------------
player_ai_stand_still_timer
    !BYTE   00
player_ai_run_distance_timer
    !BYTE   00
player_ai_last_run_direction
    !BYTE   00
    
player_ai 
    ; reset inputs before ai turn
    lda   #$ff
    sta   joy_player_down
    sta   joy_player_up
    sta   joy_player_left
    sta   joy_player_right
    sta   joy_player_fire
    
    ;face to player
    lda   sprite1_data_x
    ldx   #$00
    cmp   sprite2_data_x
    bcs   +
    ldx   #$01
+
    stx   last_player_direction

    ;needs to follow?
    
    lda   player_ai_stand_still_timer
    beq   player_is_not_waiting_any_more
    dec   player_ai_stand_still_timer
    rts   ; jmp   player_attack_tactics   ;idle, wait, attack only
    
player_is_not_waiting_any_more
    ;byt   $f2

    lda   player_ai_run_distance_timer
    bne   player_keep_running ;running is on way, continue

    ;end of running, decide next
    lda   sprite1_data_x
    cmp   #$98      ;x near right edge
    bcc   +
    ldx   #$00    ;force running left only
    stx   last_player_direction
+
    cmp   #$20            ;x near left edge
    bcs   +
    ldx   #$01    ;force running right only
    stx   last_player_direction
+
    lda   last_player_direction
    sta   player_ai_last_run_direction

    ;set run distance before next amok turn
    jsr   get_next_random_number
    tax
    and   #$1f
    clc
    adc   #20
    sta   player_ai_run_distance_timer    ;reset timer to new distance and direction
    txa   ;random
    and   #$03
    bne   +   
    lda   #$00    ;jump 1/4 chance
    sta   joy_player_up
+
    jmp   player_continue_running

player_keep_running
    dec   player_ai_run_distance_timer

player_continue_running
    
    ldy   #$00
    ldx   player_ai_last_run_direction
    beq   player_moves_left

player_moves_right
    ; do not allow running out of screen...dirty fix
    lda   sprite1_data_x
    cmp   #$a8
    bcs   after_player_move
    sty   joy_player_right
    lda   #$01
    sta   $d0
    jmp   after_player_move
player_moves_left
    ; do not allow running out of screen...dirty fix
    lda   sprite1_data_x
    cmp   #$10
    bcc   after_player_move
    sty   joy_player_left
    lda   #$00
    sta   $d0

after_player_move

    ;avoid environment elements
    lda   last_body_character_behavior
    and   #character_behavior_wall
    beq   +
    ;ran against wall
    lda   #$00
    sta   player_ai_run_distance_timer  ;reset timer, choose other direction immediately
+

player_attack_tactics

    lda   sprite2_data_y
    sec
    sbc   sprite1_data_y
    cmp   #20
    bcc   player_sumo_close
    cmp   #235
    bcs   player_sumo_close
    jmp   check_ninja_when_sumo_far
    
player_sumo_close
    lda   sprite1_data_x    ;player x
    ldy   $d0
    ldx   sprite2_data_x    ; sumo x
    jsr   suggest_attack_from_sprites
    cmp   #suggested_attack_far
    beq   player_attack_far
    cmp   #suggested_attack_near
    beq   player_attack_close


check_ninja_when_sumo_far
    lda   sprite3_data_y
    sec
    sbc   sprite1_data_y
    cmp   #20
    bcc   player_ninja_close
    cmp   #235
    bcs   player_ninja_close
    rts   ;   enemy far, no attack  
    
player_ninja_close
    lda   sprite1_data_x    ;player x
    ldy   $d0
    ldx   sprite3_data_x    ; ninja x
    
    jsr   suggest_attack_from_sprites
    cmp   #suggested_attack_far
    beq   player_attack_far
    cmp   #suggested_attack_near
    beq   player_attack_close
    rts

player_attack_far
    lda   #$00
    sta   joy_player_fire
    rts
    
player_attack_close
    lda   #$00
    sta   joy_player_fire
    lda   #$ff
    sta   joy_player_left
    sta   joy_player_right
    sta   joy_player_down
    sta   joy_player_up

player_player_defending
    rts

sumo_control_method
    !BYTE   control_method_ai
    
sprite_index_sumo   =   1
is_sumo_attacking
    !BYTE   0

is_sumo_active
    !BYTE   0
sumo_hit_count
    !BYTE   0
sumo_hits_per_life = 3

sumo_invulnerability_timer
    !BYTE   0
sumo_invulnerability_time_after_attack = 35

sumo_alive_timer
    !BYTE   0,0

;---------------------------------------------------------------
;   Sumo NPC activity main entry point
;---------------------------------------------------------------
sumo_activity_main_entry_point

    lda   is_sumo_active
    bne   +
    ;inactive, turn off
    lda   #frame_empty_sprite
    sta   sprite2_data_frame
    lda   #$00
    sta   sprite2_data_x
    sta   sprite2_data_y
    rts

+
    ;sumo is active
    
    ;tick sumo alive timer
    lda   sumo_alive_timer + 1
    cmp   #$ff
    beq   ++;max timer, do not tick
    lda   sumo_alive_timer
    clc
    adc   #$01
    bcc   +
    inc   sumo_alive_timer + 1
+   sta   sumo_alive_timer
++   

    lda   is_sumo_falling
    bne   sumo_falling
    jsr   move_sumo
    cmp   #$ff
    bne   in_animation_skip_physics_sumo    ;skip sumo physics

sumo_falling
    jsr   do_sumo_physics

in_animation_skip_physics_sumo
    jsr   check_sumo_combat_wounds
    
    lda   is_sumo_falling
    beq   +
    lda   #$00    ;reset when falling. On the ground, new running direction will be used
    sta   sumo_ai_run_distance_timer
    lda   #20
    sta   sumo_running_distance_minimum + 1
+   

    lda   last_sumo_body_character_behavior
    tax
    and   #character_behavior_kill
    beq   +
    jmp   sumo_touched_kill
+ 
    txa
    and   #character_behavior_conveyor
    beq   +
    jsr   sumo_conveyoring
    ;check conveyoring out of screen
    lda   sprite2_data_y
    cmp   #max_y_on_conveyor + 15
    bcs   sumo_killed
    cmp   #min_y_on_conveyor - 15
    bcc   sumo_killed
    lda   last_sumo_body_character_behavior
    tax
    
+   
    txa
    and   #character_behavior_warp
    beq   +
    jmp   sumo_touched_warp
+ 
    lda   last_sumo_feet_character_behavior
    tax
    and   #character_behavior_kill
    beq   +
    jmp   sumo_touched_kill
+ 
    txa
    and   #character_behavior_bush_root
    beq   +
    jmp   sumo_touched_bush_root
+
;   txa
;   and   #character_behavior_warp
;   beq   +
;   jmp   sumo_touched_warp
;+    
    rts
    
sumo_touched_kill
    lda   #SND_ENEMYDEATH
    jsr   (sound_set - music_data_start) + music_target_memory

sumo_touched_warp
    
sumo_killed
    lda   #$00
    sta   is_sumo_active
    jsr   get_next_random_number
    and   #$03
    sta   spawn_timer

    rts

sumo_touched_bush_root
    lda   any_bush_touched
    ora   #sumo_on_bush_root
    sta   any_bush_touched
    rts

sumo_conveyoring ;--------------------------------------------------------------------

    lda   sprite2_data_frame
    cmp   #frame_sumo_climb_up1
    beq   +
    cmp   #frame_sumo_climb_up2
    beq   +
    rts   ; do not react to conveyor when conveyor is not grabbed
+
    
    lda   conveyor_move_event
    cmp   #conveyor_event_moved_up
    beq   sumo_conveyoring_up
    cmp   #conveyor_event_moved_down
    beq   sumo_conveyoring_down
    rts
sumo_conveyoring_up
    jsr   move_sumo_up
    jmp   move_sumo_up
sumo_conveyoring_down
    jsr   move_sumo_down
    jmp   move_sumo_down

;--------------------------------------------------------------------
;     CHECK SUMO COMBAT WOUNDS
;--------------------------------------------------------------------
check_sumo_combat_wounds

    lda   sumo_invulnerability_timer
    beq   ++
    cmp   #15
    bcs   +

    lda   sumo_hit_count
    bne   +
    ;sumo is out of life... make death sequence
    jmp   sumo_killed
+

    dec   sumo_invulnerability_timer   ;decrease timer
    rts   ; sumo is temporarily invulnerable
++
    ;lda    sprite2_data_frame
    ;cmp    #frame_lying_left
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose
    ;cmp    #frame_lying_right
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose

    ;cmp    #frame_sumo_knocked_down_left
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose
    ;cmp    #frame_sumo_knocked_down_right
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose

    ;cmp    #frame_pain_drop_left
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose

    ;cmp    #frame_pain_drop_right
    ;beq    no_wound_check_sumo   ;no wound is possible in a defending pose

    lda   is_sumo_falling
    sta   $07

sumo_check_ninja_attack
    lda   is_ninja_attacking
    clc
    adc   is_ninja_falling
    beq   sumo_check_player_attack
    
    ldx   #sprite_index_sumo
    ldy   #sprite_index_ninja
    lda   is_ninja_falling
    sta   $06
    lda   last_ninja_direction
    jsr   check_attack_from_sprite
    and   #$7f
    bne   sumo_wounded_from_ninja     ; return value <> attack_received_noattack
    
sumo_check_player_attack
    lda   is_player_attacking
    clc
    adc   is_player_falling
    beq   no_wound_check_sumo

    ldx   #sprite_index_sumo
    ldy   #sprite_index_player
    lda   is_player_falling
    sta   $06
    lda   last_player_direction
    jsr   check_attack_from_sprite
    sta   $0f
    and   #$7f
    bne   sumo_wounded_from_player      ; return value <> attack_received_noattack

no_wound_check_sumo
    rts

sumo_wounded_from_ninja
    tax
    lda   is_ninja_falling
    and   is_sumo_falling
    beq   +
    rts   ;no harm when both are falling
+
    txa
    sta   $aa
    lda   #SND_SWORDHIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   $aa
    jmp   sumo_wounded
sumo_wounded_from_player
    tax
    lda   is_player_falling
    and   is_sumo_falling
    beq   +
    rts   ;no harm when both are falling
+   
    txa
    ldx   #$ff
    stx   player_anim_disable_left_right_move

    jsr   player_wounded_enemy
    ldx   sumo_hit_count
    cpx   #$01
    bne   sumo_wounded
    ;add score for sumo kill
    ;TODO: ADD SOUND EFFECT HERE at scoring - sumo killed
    sta   $58
    lda   #$05
    jsr   add_score
    lda   $58

sumo_wounded
    dec   sumo_hit_count
    ldx   #$00
    stx   sumo_ai_stand_still_timer   ;wake up sumo from idle period with an attack

    ldx   #sumo_invulnerability_time_after_attack
    stx   sumo_invulnerability_timer    ;make sumo defended for a few seconds on the ground
    
    cmp   #attack_received_fall_to_ground_left
    beq   sumo_attacked_fall_left
    cmp   #attack_received_fall_to_ground_right
    beq   sumo_attacked_fall_right

    cmp   #attack_received_from_the_sky
    beq   sumo_attacked_from_above
    
    ldx   #$05              ;just a slight damage from sword, make small invulnerability
    stx   sumo_invulnerability_timer    
    
    cmp   #attack_received_backup_left
    beq   sumo_attacked_backup_left
    cmp   #attack_received_backup_right
    beq   sumo_attacked_backup_right
    ; attacked, stand on feet
    ;inc    $ff19 
    rts
sumo_attacked_fall_left
    lda   #sumo_anim_id_fall_right
    jmp   start_sumo_animation
sumo_attacked_fall_right
    lda   #sumo_anim_id_fall_left
    jmp   start_sumo_animation

sumo_attacked_backup_left
    lda   #sumo_anim_id_backup_right
    jmp   start_sumo_animation
sumo_attacked_backup_right
    lda   #sumo_anim_id_backup_left
    jmp   start_sumo_animation

sumo_attacked_from_above
    lda   last_sumo_direction
    bne   +

    lda   #sumo_anim_id_faint_right
    jmp   start_sumo_animation
+
    lda   #sumo_anim_id_faint_left
    jmp   start_sumo_animation    
  
;---------------------------------------------------------------
;   DO sumo PHYSICS (falling, etc)
;---------------------------------------------------------------
is_sumo_falling
    !BYTE   00
    
do_sumo_physics
    lda   #sprite_index_sumo
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_body_character_behavior
    sta   $d1   ;this is the character behavior bitmask behind the player body
    and   #character_behavior_ladder
    beq   + ; we have no ladder behind, check platform at feet
    jmp   stop_sumo_falling ;stop doing more physics, ladder is grabbed
    
+   lda   #sprite_index_sumo
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_feet_character_behavior
    ;sta    $d0   ;this is the character behavior bitmask below the player
    ;sta    screen_mem_buffer1 + 50,y ;DEBUG
    ;sta    screen_mem_buffer2 + 50,y ;DEBUG
  ;!BYTE $f2
    and   #character_behavior_platform + character_behavior_ladder
    bne   stop_sumo_falling ; we have something below, skip falling
    
    ;no platform below, fall ninja
    ldx   #frame_sumo_falling_left
    lda   last_sumo_direction
    beq   +
    ldx   #frame_sumo_falling_right
+
    stx   sprite2_data_frame
    jsr   move_sumo_down
    lda   #$01
    sta   is_sumo_falling
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite2_data_x
    and   #$fe
    sta   sprite2_data_x
    rts
    
stop_sumo_falling
    lda   #$00
    sta   is_sumo_falling
    rts

;---------------------------------------------------------------
;   MOVE sumo ON LADDER
;---------------------------------------------------------------
sumo_climbing_internal_counter
    !BYTE   0
sumo_climbing_frame_phase
    !BYTE   0

sumo_climb_vertical_speed = 6
sumo_climb_horizontal_counter
    !BYTE   0
sumo_climb_horizontal_anim_speed = 2

sumo_climb_horizontal_speed_ladder = 6
sumo_climb_horizontal_speed_conveyor = 2
sumo_horizontal_climbing_speed
    !BYTE   0

alternate_climbing_up_down_frames_sumo
    lda   sumo_climbing_frame_phase
    eor   #$01
    sta   sumo_climbing_frame_phase
    bne   +
    lda   #frame_sumo_climb_up1
    jmp   alternate_1_sumo
+
    lda   #frame_sumo_climb_up2
    
alternate_1_sumo
    sta   sprite2_data_frame 
    rts
    
climbing_sumo_up
    lda   sumo_climbing_internal_counter
    clc
    adc   #$01
    cmp   #sumo_climb_vertical_speed
    bcc   cutemp1b_sumo

    jsr   move_sumo_up;
    jsr   move_sumo_up;
    jsr   move_sumo_up;

    lda   #sprite_index_sumo
    ldx   #body_area_head
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_up_sumo     ;wall during climbing

    jsr   alternate_climbing_up_down_frames_sumo
    lda   #$00
cutemp1b_sumo
    sta   sumo_climbing_internal_counter
    rts
    
wall_during_climb_up_sumo   
    jsr   move_sumo_down;
    jsr   move_sumo_down;
    jsr   move_sumo_down;
    lda   #$00
    sta   sumo_climbing_internal_counter
    rts
    
climbing_sumo_down  
    lda   sumo_climbing_internal_counter
    clc
    adc   #$01
    cmp   #sumo_climb_vertical_speed
    bcc   cutemp2b_sumo

    jsr   move_sumo_down;
    jsr   move_sumo_down;
    jsr   move_sumo_down;

    lda   #sprite_index_sumo
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_feet_character_behavior
    and   #character_behavior_wall
    bne   wall_during_climb_down_sumo     ;wall during climbing

    jsr   alternate_climbing_up_down_frames_sumo    
    lda   #$00
cutemp2b_sumo
    sta   sumo_climbing_internal_counter
    rts
wall_during_climb_down_sumo
    jsr   move_sumo_up;
    jsr   move_sumo_up;
    jsr   move_sumo_up;
    lda   #$00
    sta   sumo_climbing_internal_counter
    rts
    
    
climbing_sumo_left
    lda   sumo_climbing_internal_counter
    clc
    adc   #$01
    cmp   sumo_horizontal_climbing_speed
    bcc   cutemp2blefts

    jsr   move_sumo_left;

    lda   #sprite_index_sumo
    ldx   #body_area_left
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_left_sumo     ;wall during climbing

;   lda   sumo_climb_horizontal_counter
;   clc
;   adc   #$01
;   sta   sumo_climb_horizontal_counter
;   cmp   #sumo_climb_horizontal_anim_speed
;   bcc   +
    jsr   alternate_climbing_up_down_frames_sumo  
;   lda   #$00
;   sta   sumo_climb_horizontal_counter
;+    
    lda   #$00
cutemp2blefts
    sta   sumo_climbing_internal_counter
    rts
wall_during_climb_left_sumo
    jsr   move_sumo_right;
    lda   #$00
    sta   sumo_climbing_internal_counter
    rts
    
climbing_sumo_right
    lda   sumo_climbing_internal_counter
    clc
    adc   #$01
    cmp   sumo_horizontal_climbing_speed
    bcc   cutemp2brights

    jsr   move_sumo_right;

    lda   #sprite_index_sumo
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_right_sumo      ;wall during climbing

    ;lda    sumo_climb_horizontal_counter
    ;clc
    ;adc    #$01
    ;sta    sumo_climb_horizontal_counter
    ;cmp    #sumo_climb_horizontal_anim_speed
    ;bcc    +
    jsr   alternate_climbing_up_down_frames_sumo  
    ;lda    #$00
    ;sta    sumo_climb_horizontal_counter
;+    

    lda   #$00
cutemp2brights
    sta   sumo_climbing_internal_counter
    rts
wall_during_climb_right_sumo
    jsr   move_sumo_left;
    lda   #$00
    sta   sumo_climbing_internal_counter
    rts   
  
;---------------------------------------------------------------
;   MOVE sumo USING JOYSTICK ON GROUND
;---------------------------------------------------------------  
current_sumo_input_delay
    !BYTE   00
sumo_delay_after_wall_hit = 6
    
move_sumo:

    jsr   progress_sumo_animation
    cmp   #$ff
    beq   +
    ;animation is currently running, no player input accepted
    lda   #$00
    rts   
+
    ; get directions from joystick
    lda   current_sumo_input_delay
    beq   + ; time to read joystick
    dec   current_sumo_input_delay
    jmp   sumo_standing_still
+   
    jsr   read_sumo_input

    lda   #sprite_index_sumo
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_body_character_behavior
    tax
    and   #character_behavior_ladder
    beq   normal_sumo_movements   ;no ladder behind our body_area_body

  ; set speed conveyor or ladder?
    ldy   #sumo_climb_horizontal_speed_ladder
    txa
    and   #character_behavior_conveyor
    bne   sumo_on_a_ladder
    ldy   #sumo_climb_horizontal_speed_conveyor
sumo_on_a_ladder
    sty   sumo_horizontal_climbing_speed
    
    ;------ ladder movements
    jsr   stop_sumo_animation ;when in the middle of jump, etc, just stop the animation

    lda   joy_sumo_down
    bne   +
    ;climbing down
    jsr   climbing_sumo_down
    jmp   sumo_moved_but_no_physics
    
+
    lda   joy_sumo_up
    bne   +
    ;climbing up
    jsr   climbing_sumo_up
    jmp   sumo_moved_but_no_physics
+
    lda   joy_sumo_left
    bne   +
    ;climbing left
    jsr   climbing_sumo_left
    jmp   sumo_moved_but_no_physics
+   
    lda   joy_sumo_right
    bne   +
    ;climbing right
    jsr   climbing_sumo_right
    jmp   sumo_moved_but_no_physics
+   
    lda   #$00
    sta   sumo_climbing_internal_counter

    jmp   sumo_moved_but_no_physics
        
    ;----- normal movements jumping, lying, boxing, kicking
normal_sumo_movements   

    lda   joy_sumo_down
    bne   +

    ;shout
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite2_data_x
    and   #$fe
    sta   sprite2_data_x    
    lda   last_sumo_direction
    beq   plfacingleft_sumo
    lda   #sumo_anim_id_shout_right
    jsr   start_sumo_animation
    lda   #SND_YAMOSHOUT
    jsr   (sound_set - music_data_start) + music_target_memory

    jmp   sumo_moved

plfacingleft_sumo   
    lda   #sumo_anim_id_shout_left
    jsr   start_sumo_animation
    lda   #SND_YAMOSHOUT
    jsr   (sound_set - music_data_start) + music_target_memory
    jmp   sumo_moved

+   
    lda   joy_sumo_left
    bne   ++++
    lda   joy_sumo_up
    bne   ++
    ;kick left
    jmp   sumo_jump_kick_left
++   
    lda   joy_sumo_fire
    bne   +++
    ;jump kick left
sumo_jump_kick_left
    lda   #sprite_index_sumo
    ldx   #body_area_left_kick_prep
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_left_sumo      ;wall before kick
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay
    jmp   sumo_moved
wall_during_kick_left_sumo
    lda   #sumo_anim_id_kick_left
    jsr   start_sumo_animation
    lda   #SND_HIGHKICK2
    jsr   (sound_set - music_data_start) + music_target_memory
    jmp   sumo_moved
    
+++   
    ; move sumo left
    ;check last_sumo_body_character_behavior against wall
    lda   #sprite_index_sumo
    ldx   #body_area_left_sumo
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   no_wall_left_sumo
    ;jsr    move_sumo_right
    ;jsr    move_sumo_right
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay

    lda   #$00
    sta   last_sumo_direction

    jmp   sumo_moved
no_wall_left_sumo   
    lda   #frame_sumo_running_left
    sta   sprite2_data_frame
    jsr   move_sumo_left
    jmp   sumo_moved
++++   
    lda   joy_sumo_right
    bne   ++++
    lda   joy_sumo_up
    bne   ++
    ;kick right
    jmp   sumo_jump_kick_right
++   
    lda   joy_sumo_fire
    bne   +++
    ;jump kick right
sumo_jump_kick_right
    lda   #sprite_index_sumo
    ldx   #body_area_right_kick_prep
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_right_sumo     ;wall before kick
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay
    jmp   sumo_moved
wall_during_kick_right_sumo
    lda   #sumo_anim_id_kick_right
    jsr   start_sumo_animation
    lda   #SND_HIGHKICK1
    jsr   (sound_set - music_data_start) + music_target_memory
    jmp   sumo_moved
    
+++   
    ; move sumo right
    ;check last_sumo_body_character_behavior against wall
    lda   #sprite_index_sumo
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   no_wall_right_sumo
    ;jsr    move_sumo_left
    ;jsr    move_sumo_left
    lda   #$01
    sta   last_sumo_direction
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay
    jmp   sumo_moved
no_wall_right_sumo
    lda   #frame_sumo_running_right
    sta   sprite2_data_frame
    jsr   move_sumo_right
    jmp   sumo_moved
++++   
    lda   joy_sumo_up
    bne   +
    ;jump up

    lda   last_sumo_direction
    bne   plfright_sumo
    lda   #sumo_anim_id_jump_up_left
    jsr   start_sumo_animation
    jmp   sumo_moved
plfright_sumo
    lda   #sumo_anim_id_jump_up_right
    jsr   start_sumo_animation
    jmp   sumo_moved
    
+
    lda   joy_sumo_fire
    bne   +
    ;box punch
    lda   last_sumo_direction
    cmp   #$00
    beq   box_left_dir_sumo
    lda   #sumo_anim_id_box_right
    jsr   start_sumo_animation
    jmp   sumo_moved
box_left_dir_sumo:
    lda   #sumo_anim_id_box_left
    jsr   start_sumo_animation
+   
sumo_standing_still
    ;  nothing pressed
    ;  sumo standing still
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite2_data_x
    and   #$fe
    sta   sprite2_data_x

    lda   last_sumo_direction
    bne   +
    lda   #frame_sumo_standing_left;
    sta   sprite2_data_frame
    jmp   sumo_moved
+
    lda   #frame_sumo_standing_right;
    sta   sprite2_data_frame
    jmp   sumo_moved

sumo_moved
    lda   #$ff    ;returns ff means no animation, do the physics
    rts

sumo_moved_but_no_physics
    lda   #$00    ;returns 00 means do not do the physics
    rts

sumo_anim_current_frame:
    !BYTE 0
sumo_anim_subtimer:
    !BYTE 0
sumo_anim_subtimer_timeout    = 2
sumo_anim_disable_left_right_move
    !BYTE 0
sumo_current_anim_running
    !BYTE 0

;-----------------------------------------------------------------------------------------
;     STOP sumo ANIMATION     
;-----------------------------------------------------------------------------------------
stop_sumo_animation:
    lda   #sumo_anim_id_no_animation
    jmp   start_sumo_animation

;-----------------------------------------------------------------------------------------
;     START sumo ANIMATION        param:    A = animation sequence id
;-----------------------------------------------------------------------------------------
start_sumo_animation:

    sta   sumo_current_anim_running
    asl
    tax
    lda   sumo_animation_sequences,x
    sta   sumo_anim_seq + 1
    sta   sumo_anim_seq2 + 1
    sta   sumo_anim_seq3 + 1
    sta   sumo_anim_seq4 + 1
    lda   sumo_animation_sequences + 1,x
    sta   sumo_anim_seq + 2
    sta   sumo_anim_seq2 + 2
    sta   sumo_anim_seq3 + 2
    sta   sumo_anim_seq4 + 2
    lda   #$00
    sta   sumo_anim_current_frame
    sta   sumo_anim_subtimer
    sta   sumo_anim_disable_left_right_move
    rts

;-----------------------------------------------------------------------------------------
;     PROGRESS sumo ANIMATION       does next anim sequence action
;-----------------------------------------------------------------------------------------
;last_sumo_body_character_behavior = $f6
;last_sumo_feet_character_behavior = $f7

progress_sumo_animation:
    
    lda   sumo_anim_current_frame
    asl
    asl
    tax
sumo_anim_seq
    lda   sumo_animation_sequences,x
    cmp   #RESTORE_LADDER_GRAB
    bne   +
    lda   #sprite_index_sumo    ; Check player on ladder at the end of animation
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_body_character_behavior   
    jsr   sumo_grabs_ladder_when_necessary
    inc   sumo_anim_current_frame
    lda   #$ff

+     cmp   #$ff
    bne   +
    
    ldx   #$00
    stx   is_sumo_attacking
    rts   ;return 255, no animation needed any more, reached last frame
+
    sta   $d2
    inx
sumo_anim_seq2
    lda   sumo_animation_sequences,x
    sta   $d1
    inx
sumo_anim_seq3
    lda   sumo_animation_sequences,x  ;is this step timer-dependent?
    sta   $d0

    inx
sumo_anim_seq4
    lda   sumo_animation_sequences,x  ;force player direction flag
    sta   $e3
    
    inc   sumo_anim_subtimer
    ldy   sumo_anim_subtimer
    cpy   #sumo_anim_subtimer_timeout
    bcc   + ;timer not reached, play current anim frame action step again

    ;timer reached, restart timer, advance to next animation 
    inc   sumo_anim_current_frame
    ldy   #$00    ;restart timer
    sty   sumo_anim_subtimer
  
+
    lda   $d0
    beq   do_action_move_sumo   ;no timer dependent, do immediately
    
    ;go to the next frame immediately for special, timer-dependent animation steps
    inc   sumo_anim_current_frame
    ldy   #$00    ;restart timer
    sty   sumo_anim_subtimer
    
do_action_move_sumo
  
    lda   $d2 ;sprite frame id
    sta   sprite2_data_frame    ;action sequence first byte is the sprite frame
    lda   $d1 ;second byte is the movement operator: direction + count
    tay
    and   #$07
    sta   number_of_moves_sumo + 1
    tya
    and   #action_move_attack_moment
    sta   is_sumo_attacking
    tya
    sta   $e1

    ldx   #$00
-   stx   $e0

    ; animation movements are checking the screen elements to stop animations
    lda   #sprite_index_sumo    ; sprite 2
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_body_character_behavior
    
    and   #character_behavior_ladder
    beq   +
    lda   sumo_current_anim_running   
    cmp   #sumo_anim_id_fall_right
    beq   +   ;can fall on ladder
    cmp   #sumo_anim_id_fall_left
    beq   +   ;can fall on ladder
    cmp   #sumo_anim_id_backup_left
    beq   +   ;can fall on ladder
    cmp   #sumo_anim_id_backup_right
    beq   +   ;can fall on ladder
    jmp   action_skip_more_move_directions_ladder_sumo ; we have ladder below, skip moving 
+
    lda   $e1
    and   #action_move_down
    beq   +

    lda   #sprite_index_sumo    ; sprite 2
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_sumo_feet_character_behavior
    and   #character_behavior_platform + character_behavior_ladder
    bne   action_platform_on_move_down_sumo ; we have platform below, skip moving 
    jsr   move_sumo_down
+   
continue_from_knock_down_sumo
+   
    lda   $e1
    and   #action_move_up
    beq   +
    
    jsr   move_sumo_up
+   
    lda   $e1
    and   #action_move_left
    beq   +

    ldx   #$00
    stx   sumo_ai_run_distance_timer
    lda   last_sumo_body_character_behavior     ;body character behavior
    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_right_sumo ; we have a wall near, skip moving 
    jsr   move_sumo_left_from_animation
+   
    lda   $e1
    and   #action_move_right
    beq   +

    ldx   #$00
    stx   sumo_ai_run_distance_timer
    lda   last_sumo_body_character_behavior
    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_left_sumo ; we have a wall near, skip moving 
    jsr   move_sumo_right_from_animation
+
    ldx   $e0
    inx
number_of_moves_sumo
    cpx   #$01
    bne   -

    lda   $e3   ;at the end of all moves, force sumo direction
    sta   last_sumo_direction

    lda   #$00
    rts

action_platform_on_move_down_sumo
    lda   sumo_current_anim_running
    cmp   #sumo_anim_id_fall_left
    beq   +
    cmp   #sumo_anim_id_fall_right
    beq   +
    lda   $e3
    sta   last_sumo_direction
    lda   #$ff
    rts
+
    jsr   move_sumo_down
    jmp   continue_from_knock_down_sumo    
    
action_skip_more_move_directions_sumo   
    lda   $e3   ;at the end of all moves, force sumo direction
    sta   last_sumo_direction
    lda   #0 ; recheck running direction after attack
    sta   sumo_ai_run_distance_timer
    lda   #$ff
    rts

action_skip_more_move_directions_with_move_right_sumo
    jsr   move_sumo_right
    jsr   move_sumo_right
    jsr   move_sumo_right
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_sumo_direction
    jsr   stop_sumo_animation
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay
    lda   #0 ; recheck running direction after attack
    sta   sumo_ai_run_distance_timer
    lda   #$ff
    rts

action_skip_more_move_directions_with_move_left_sumo
    jsr   move_sumo_left
    jsr   move_sumo_left
    jsr   move_sumo_left
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_sumo_direction
    jsr   stop_sumo_animation
    lda   #sumo_delay_after_wall_hit
    sta   current_sumo_input_delay
    lda   #0 ; recheck running direction after attack
    sta   sumo_ai_run_distance_timer

    lda   #$ff
    rts

action_skip_more_move_directions_ladder_sumo    
    lda   $e3   ;at the end of all moves, force player direction
    sta   last_sumo_direction
    
    lda   #frame_sumo_climb_up1   ;freeze animation on ladder with setting frame
    sta   sprite2_data_frame
    lda   #$00
    sta   sumo_climbing_frame_phase
    
    lda   #$ff
    rts

move_sumo_left_from_animation
    lda   sumo_anim_disable_left_right_move
    beq   +
    lda   $d0       ;forced frame move, do this everytime
    bne   +
    rts
+
    jmp   move_sumo_left

move_sumo_right_from_animation
    lda   sumo_anim_disable_left_right_move
    beq   +
    lda   $d0       ;forced frame move, do this everytime
    bne   +
    rts
+
    jmp   move_sumo_right

;---------------------------------------------------------
sumo_grabs_ladder_when_necessary

    lda   last_sumo_body_character_behavior
    and   #character_behavior_ladder
    beq   +
    
    ;we stand on a ladder... set anim frame
    lda   #frame_sumo_climb_up1
    sta   sprite2_data_frame
    lda   #$00
    sta   sumo_climbing_frame_phase   
+   
    rts     

;---------------------------------------------------------
;     MOVE SUMO (UP/DOWN/LEFT/RIGHT)
;--------------------------------------------------------
move_sumo_left:
    ;lda  #$55
    ;sta $ff19
    ldx   #$00
    stx   last_sumo_direction
    lda   sprite2_data_x
    cmp   #$08
    bcc   +
    dec   sprite2_data_x
+   rts

move_sumo_right:
    ;lda  #$77
    ;sta $ff19
    ldx   #$01
    stx   last_sumo_direction
    lda   sprite2_data_x
    cmp   #limit_sprite_x_pos
    bcs   +
    inc   sprite2_data_x
+   rts

move_sumo_up:
    ;lda  #$77
    ;sta $ff19
    lda   sprite2_data_y
    cmp   #$08
    bcc   +
    dec   sprite2_data_y
+   rts

move_sumo_down:
    ;lda  #$77
    ;inc $ff19
    lda   sprite2_data_y
    cmp   #limit_sprite_y_pos
    bcs   +
    inc   sprite2_data_y
+   rts

;-------------------------------------------------------------------------------------
;   ANIMATIONS AND SEQUENCES
;-------------------------------------------------------------------------------------
sumo_animation_sequences:
sumo_anim_id_no_animation         = 0
      !WORD sumo_anim_seq_no_animation
sumo_anim_id_jump_left        = 1
      !WORD sumo_anim_seq_jump_left
sumo_anim_id_jump_right       = 2
      !WORD sumo_anim_seq_jump_right
sumo_anim_id_jump_up_left       = 3
      !WORD sumo_anim_seq_jump_up_left
sumo_anim_id_jump_up_right      = 4
      !WORD sumo_anim_seq_jump_up_right
sumo_anim_id_shout_left         = 5
      !WORD sumo_anim_seq_shout_left
sumo_anim_id_shout_right        = 6
      !WORD sumo_anim_seq_shout_right
sumo_anim_id_kick_left        = 7
      !WORD sumo_anim_seq_kick_left
sumo_anim_id_kick_right       = 8
      !WORD sumo_anim_seq_kick_right
sumo_anim_id_box_right        = 9
      !WORD sumo_anim_seq_box_right
sumo_anim_id_box_left       = 10
      !WORD sumo_anim_seq_box_left
sumo_anim_id_fall_left        = 11
      !WORD sumo_anim_seq_fall_left
sumo_anim_id_fall_right       = 12
      !WORD sumo_anim_seq_fall_right
sumo_anim_id_backup_left        = 13
      !WORD sumo_anim_seq_backup_left
sumo_anim_id_backup_right       = 14
      !WORD sumo_anim_seq_backup_right
sumo_anim_id_faint_right        = 15
      !WORD sumo_anim_seq_faint_right
sumo_anim_id_faint_left       = 16
      !WORD sumo_anim_seq_faint_left
      
sumo_anim_seq_no_animation:
      !BYTE 255

sumo_anim_seq_jump_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_sumo_kick1_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_sumo_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_sumo_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_sumo_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_sumo_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_sumo_falling_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_sumo_falling_left, action_move_left + 1, 1, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_sumo_falling_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_sumo_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_sumo_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_sumo_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_sumo_falling_left, action_move_down + action_move_left+ 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_sumo_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_sumo_kick1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE 255

sumo_anim_seq_jump_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_sumo_kick1_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_sumo_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_sumo_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_sumo_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_sumo_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_sumo_falling_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_sumo_falling_right, action_move_right + 1, 1, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_sumo_falling_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_sumo_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_sumo_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_sumo_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_sumo_falling_right, action_move_down + action_move_right+ 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_sumo_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_sumo_kick1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE 255

sumo_anim_seq_jump_up_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame1_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame2_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up1, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame2_down
      !BYTE frame_sumo_climb_up1, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE 255

sumo_anim_seq_jump_up_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame1_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame2_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up2, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame2_down
      !BYTE frame_sumo_climb_up2, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE 255
      
sumo_anim_seq_shout_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_shout_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE 255

sumo_anim_seq_shout_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_shout_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255
    
sumo_anim_seq_kick_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_left, action_move_left + action_move_up + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_sumo_kick1_left, action_move_left  + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_sumo_kick2_left, action_move_left + 4, 1, 0 ;anim_action_kick2_left_with_move
      !BYTE frame_sumo_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_sumo_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_sumo_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_sumo_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_sumo_kick2_left, action_move_left + 1 + action_move_attack_moment, 0, 0 ;anim_action_kick2_left
      !BYTE frame_sumo_kick1_left, action_move_right + 4, 1, 0 ;anim_action_kick2_left_with_move_back
      !BYTE frame_sumo_kick1_left, action_move_left + action_move_down + 1, 0, 0 ;anim_action_kick1_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_right
      !BYTE 255

sumo_anim_seq_kick_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_right, action_move_right +  action_move_up + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_sumo_kick1_right, action_move_right + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_sumo_kick2_right, action_move_right + 1, 0, 1 ;anim_action_kick2_right
      !BYTE frame_sumo_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      !BYTE frame_sumo_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right 
      !BYTE frame_sumo_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      !BYTE frame_sumo_kick2_right, action_move_right + 1 + action_move_attack_moment, 0, 1 ;anim_action_kick2_right
      !BYTE frame_sumo_kick1_right, action_move_right + action_move_down + 1, 0, 1 ;anim_action_kick1_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255

sumo_anim_seq_box_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_box_left, action_move_left + 4 + action_move_attack_moment, 1, 0 ;anim_action_box_punch_left_with_move
      !BYTE frame_sumo_box_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_sumo_box_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_sumo_standing_left, action_move_right + 4, 1, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_sumo_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE 255

sumo_anim_seq_box_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_box_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right_with_move
      !BYTE frame_sumo_box_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_sumo_box_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_sumo_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE 255

sumo_anim_seq_fall_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_right, action_move_left + 2, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_kick1_right, action_move_left + action_move_down + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 ;anim_action_lying_left
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

sumo_anim_seq_fall_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_right, action_move_right + 2, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_kick1_right, action_move_right + action_move_down + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      ;!BYTE frame_sumo_knocked_down_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

sumo_anim_seq_backup_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      !BYTE frame_sumo_standing_right, action_move_left + 1, 0, 1 ;anim_action_lying_left
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

sumo_anim_seq_backup_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_standing_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      !BYTE frame_sumo_standing_left, action_move_right + 1, 0, 0 ;anim_action_lying_left
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

sumo_anim_seq_faint_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_kick1_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_kick1_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_sumo_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE 255     

sumo_anim_seq_faint_right: 
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_sumo_kick1_left, action_move_left + 1, 1, 0
      !BYTE frame_sumo_kick1_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_kick1_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_sumo_standing_left, action_move_right + 1, 1, 0 
      !BYTE 255     
      
last_sumo_direction:
          !BYTE 0;    0 - left; 1- right
        
;     registers are 0 when pressed
joy_sumo_up     !BYTE 255
joy_sumo_down   !BYTE 255
joy_sumo_left   !BYTE 255
joy_sumo_right    !BYTE 255
joy_sumo_fire   !BYTE 255

read_sumo_input:

    lda   sumo_control_method
    cmp   #control_method_joy1
    beq   sumo_joy1
    cmp   #control_method_joy2
    beq   sumo_joy2
    cmp   #control_method_keyboard
    beq   sumo_keyboard
    jmp   sumo_ai
    
sumo_joy1 
    lda   #$fb
    sta   $fd30
    sta   $ff08
    jmp   read_sumo_controls
sumo_joy2
    lda   #$fd
    sta   $fd30
    sta   $ff08
    jmp   read_sumo_controls
sumo_keyboard
    lda   #$f7
    sta   $fd30
    sta   $ff08
    
read_sumo_controls
    lda   $ff08
    tax
    and   #$01
    sta   joy_sumo_up
    txa
    and   #$02
    sta   joy_sumo_down
    txa
    and   #$04
    sta   joy_sumo_left
    txa
    and   #$08
    sta   joy_sumo_right
    txa
    and   #$c0
    cmp   #$c0
    beq   +
    lda   #$00
    sta   joy_sumo_fire
    rts
+
    sta   joy_sumo_fire
    rts

;---------------------------------------------------------------------
;       SUMO AI TACTIC
;---------------------------------------------------------------------
sumo_ai_stand_still_timer
    !BYTE   00
sumo_ai_run_distance_timer
    !BYTE   00
sumo_ai_last_run_direction
    !BYTE   00
    
sumo_ai 

    ; reset inputs before ai turn
    lda   #$ff
    sta   joy_sumo_down
    sta   joy_sumo_up
    sta   joy_sumo_left
    sta   joy_sumo_right
    sta   joy_sumo_fire
    
    ;check fresh spawn timer to shout a big!
    lda   sumo_alive_timer 
    cmp   #$18
    bne   +
    lda   sumo_alive_timer + 1
    bne   +

    ;shout at the begin of life
    lda   #$00
    sta   joy_sumo_down

+   
    ;face to player
    lda   sprite2_data_x
    ldx   #$00
    cmp   sprite1_data_x
    bcs   +
    ldx   #$01
+
    stx   last_sumo_direction

    ;needs to follow?
        
    lda   sumo_ai_stand_still_timer
    beq   sumo_is_not_waiting_any_more
    dec   sumo_ai_stand_still_timer
    jmp   sumo_on_conveyor    ;idle, wait, attack only
        
sumo_is_not_waiting_any_more
    lda   sprite1_data_y    ;player y
    clc
    adc   #15       ;sumo looks higher to follow
    cmp   sprite2_data_y
    bcs   sumo_follows_player

    lda   #$00
    sta   sumo_ai_run_distance_timer    ;keep timer low. When sees me, immediately runs toward me
    jsr   sumo_on_conveyor
    lda   sumo_ai_last_run_direction
    sta   $d0
    jmp   sumo_attack_tactics   ;idle, wait, attack only    ;sumo stands still, no player near

sumo_follows_player

    ;byt   $f2

    lda   sumo_ai_run_distance_timer
    bne   sumo_keep_running ;running is on way, continue

    ;end of running, decide next
    lda   sprite2_data_x
    cmp   #$98      ;x near right edge
    bcc   +
    ldx   #$00    ;force running left only
    stx   last_sumo_direction
+
    cmp   #$20            ;x near left edge
    bcs   +
    ldx   #$01    ;force running right only
    stx   last_sumo_direction
+
    lda   last_sumo_direction
    sta   sumo_ai_last_run_direction

    ;set run distance before next amok turn
    jsr   get_next_random_number
    tax
    and   #$1f
    clc
sumo_running_distance_minimum
    adc   #20
    sta   sumo_ai_run_distance_timer    ;reset timer to new distance and direction
    txa   ;random
    and   #$0f
    bne   +   
    lda   #$00    ;shout 1/16 chance
    sta   joy_sumo_down
+
    jmp   sumo_continue_running

sumo_keep_running
    dec   sumo_ai_run_distance_timer

sumo_continue_running
    ldy   #$00
    ldx   sumo_ai_last_run_direction
    beq   sumo_moves_left

sumo_moves_right
    sty   joy_sumo_right
    lda   #$01
    sta   $d0
    jmp   after_sumo_move
sumo_moves_left
    sty   joy_sumo_left
    lda   #$00
    sta   $d0

after_sumo_move

    ;avoid environment elements
    lda   #sprite_index_sumo    
    ldx   #body_area_left_sumo
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   +
    ;ran against wall
    lda   #$01
    sta   sumo_ai_last_run_direction  ;turn around
    jsr   get_next_random_number
    and   #$0f
    clc
    adc   sumo_running_distance_minimum + 1
    sta   sumo_ai_run_distance_timer  
    jmp   sumo_attack_tactics
+
    lda   #sprite_index_sumo    
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   +
    ;ran against wall
    lda   #$00
    sta   sumo_ai_last_run_direction  ;turn around
    jsr   get_next_random_number
    and   #$0f
    clc
    adc   sumo_running_distance_minimum + 1
    sta   sumo_ai_run_distance_timer  
+
sumo_attack_tactics

    ;attacking
    lda   sprite1_data_y
    sec
    sbc   sprite2_data_y
    cmp   #20
    bcc   sumo_player_close
    cmp   #235
    bcs   sumo_player_close
    lda   #$e0 ;run as far as can when player not in sight
    sta   sumo_running_distance_minimum + 1
    rts   ;   enemy far, no attack  
    
sumo_player_close
    lda   #20
    sta   sumo_running_distance_minimum + 1

    ldx   player_alive_timer + 1
    cpx   #8
    bcc   +
    ldx   #8
+   
    jsr   get_next_random_number
    and   sumo_frustration_table,x
    
    bne   sumo_player_defending; ;do not attack

    lda   sprite2_data_x    ;sumo x
    ldy   sumo_ai_last_run_direction
    ldx   sprite1_data_x    ; player x
    
    jsr   suggest_attack_from_sprites
    sta   dev_mode_info_bar + 29

    cmp   #suggested_attack_far
    beq   sumo_attack_far
    cmp   #suggested_attack_near
    beq   sumo_attack_close
    rts
    ;ldx  #30
    ;jsr  put_hex_to_dev_bar
sumo_attack_far
    lda   #$00
    sta   joy_sumo_fire
    ;lda    #0 ; recheck running direction after attack
    ;sta    sumo_ai_run_distance_timer
    rts
    
sumo_attack_close
    lda   sprite1_data_frame    ;player frame
    cmp   #frame_lying_left
    beq   sumo_player_defending ; do not punch when lying
    cmp   #frame_lying_right
    beq   sumo_player_defending ; do not punch when lying
    jsr   get_next_random_number
    tax
    and   #$03
    beq   run_away_from_attack_sumo
    lda   #$00
    sta   joy_sumo_fire
    lda   #$ff
    sta   joy_sumo_left
    sta   joy_sumo_right
    sta   joy_sumo_down
    sta   joy_sumo_up
    ;lda    #0 ; recheck running direction after attack
    ;sta    sumo_ai_run_distance_timer

sumo_player_defending
    rts
run_away_from_attack_sumo
    txa
    and   #$0f
    clc
    adc   #20
    sta   sumo_running_distance_minimum + 1
    rts
    
sumo_frustration_table
    !BYTE   $0f,$0f,$07,$07,$03,$03,$01,0,0 ;sumo become more aggressive when time flies... 0 means max efficiency

;-----------------------------------------------------------------
sumo_on_conveyor

    lda   last_sumo_body_character_behavior
    and   #character_behavior_conveyor
    beq   ++
    ;sumo on a conveyor
    lda   sprite2_data_y
    cmp   #max_y_on_conveyor
    bcc   +
    lda   #$00
    sta   joy_sumo_up
    rts
+
    cmp   #min_y_on_conveyor
    bcs   ++
    lda   #$00
    sta   joy_sumo_down
++
    rts

;-----------------------------------------------------------------
;       AC - attacker x
;       X  - victim x
;       Y  - attacker direction
;-----------------------------------------------------------------
suggested_attack_none     = 0
suggested_attack_near     = 1
suggested_attack_far      = 2

suggest_attack_from_sprites

    sty   $d3
    stx   $d0
    sta   $d1 ;attacker x
    cmp   $d0 ;victim x
    bcs   victim_is_on_the_left

victim_is_on_the_right
    lda   $d3   ;attacker direction
    beq   attacker_not_facing_victim

    lda   $d0  ;victim x
    sec
    sbc   $d1 ;attacker x
    sta   $d2
    jmp   check_sprite_distance

victim_is_on_the_left
    lda   $d3   ;attacker direction
    bne   attacker_not_facing_victim

    lda   $d1 ;attacker x
    sec
    sbc   $d0  ;victim x
    sta   $d2

check_sprite_distance
    ;$d2 is the distance here
    ;lda    $d2
    ;ldx  #30
    ;jsr  put_hex_to_dev_bar
    
    lda   $d2
    cmp   #22
    bcs   attacker_too_far
    cmp   #5
    bcc   attacker_too_close
    cmp   #10
    bcc   suggest_close_attack
    ;byt    $f2
    lda   #suggested_attack_far
    rts
    
attacker_not_facing_victim
attacker_too_close
attacker_too_far
    ; no attack required
    lda   #suggested_attack_none
    rts
suggest_close_attack
    lda   #suggested_attack_near
    rts

ninja_control_method
    !BYTE   control_method_ai
    
sprite_index_ninja  =   2
is_ninja_attacking
    !BYTE   0

is_ninja_active
    !BYTE   0
ninja_hit_count
    !BYTE   0
ninja_hits_per_life = 2

ninja_invulnerability_timer
    !BYTE   0
ninja_invulnerability_time_after_attack = 35

ninja_alive_timer
    !BYTE   0,0

;---------------------------------------------------------------
;   Ninja NPC activity main entry point
;---------------------------------------------------------------
ninja_activity_main_entry_point

    lda   is_ninja_active
    bne   +
    ;inactive, turn off
    lda   #frame_empty_sprite
    sta   sprite3_data_frame
    lda   #$00
    sta   sprite3_data_x
    sta   sprite3_data_y
    rts

+
    ;ninja is active
    
    ;tick ninja alive timer
    lda   ninja_alive_timer + 1
    cmp   #$ff
    beq   ++;max timer, do not tick
    lda   ninja_alive_timer
    clc
    adc   #$01
    bcc   +
    inc   ninja_alive_timer + 1
+   sta   ninja_alive_timer
++   

    lda   is_ninja_falling
    bne   ninja_falling
    jsr   move_ninja
    cmp   #$ff
    bne   in_animation_skip_physics_ninja   ;skip ninja physics

ninja_falling
    jsr   do_ninja_physics

in_animation_skip_physics_ninja
    jsr   check_ninja_combat_wounds

    lda   is_ninja_falling
    beq   +
    lda   #$00    ;reset when falling. On the ground, new running direction will be used
    sta   ninja_ai_run_distance_timer
    lda   #20
    sta   ninja_running_distance_minimum + 1
+   

    lda   last_ninja_body_character_behavior
    tax
    and   #character_behavior_warp
    beq   +
    jmp   ninja_touched_warp
+   
    txa
    and   #character_behavior_conveyor
    beq   +
    jsr   ninja_conveyoring
    ;check conveyoring out of screen
    lda   sprite3_data_y
    cmp   #max_y_on_conveyor + 15
    bcs   ninja_killed
    cmp   #min_y_on_conveyor - 15
    bcc   ninja_killed
    lda   last_ninja_body_character_behavior
    tax
+       
    txa
    and   #character_behavior_kill
    beq   +
    jmp   ninja_touched_kill
+   
    lda   last_ninja_feet_character_behavior
    tax
    and   #character_behavior_kill
    beq   +
    jmp   ninja_touched_kill
+
    txa
    and   #character_behavior_bush_root
    beq   +
    jmp   ninja_touched_bush_root
+
;   txa
;   and   #character_behavior_warp
;   beq   +
;   jmp   ninja_touched_warp
;+    
    rts
    
ninja_touched_kill
    lda   #SND_ENEMYDEATH
    jsr   (sound_set - music_data_start) + music_target_memory
ninja_touched_warp
    
ninja_killed
    lda   #$00
    sta   is_ninja_active
    jsr   get_next_random_number
    and   #$03
    sta   spawn_timer
    rts

ninja_touched_bush_root
    lda   any_bush_touched
    ora   #ninja_on_bush_root
    sta   any_bush_touched
    rts
    
ninja_conveyoring ;--------------------------------------------------------------------

    lda   sprite3_data_frame
    cmp   #frame_ninja_climb_up1
    beq   +
    cmp   #frame_ninja_climb_up2
    beq   +
    rts   ; do not react to conveyor when conveyor is not grabbed
+
    lda   conveyor_move_event
    cmp   #conveyor_event_moved_up
    beq   ninja_conveyoring_up
    cmp   #conveyor_event_moved_down
    beq   ninja_conveyoring_down
    rts
ninja_conveyoring_up
    jsr   move_ninja_up
    jmp   move_ninja_up
ninja_conveyoring_down
    jsr   move_ninja_down
    jmp   move_ninja_down

;--------------------------------------------------------------------
;     CHECK ninja COMBAT WOUNDS
;--------------------------------------------------------------------
check_ninja_combat_wounds

    lda   ninja_invulnerability_timer
    beq   ++
    cmp   #15
    bcs   +

    lda   ninja_hit_count
    bne   +

    ;ninja is out of life... make death sequence
    jmp   ninja_killed
+

    dec   ninja_invulnerability_timer   ;decrease timer
    rts   ; ninja is temporarily invulnerable
++
    ;lda    sprite3_data_frame
    ;cmp    #frame_lying_left
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose
    ;cmp    #frame_lying_right
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose

    ;cmp    #frame_ninja_knocked_down_left
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose
    ;cmp    #frame_ninja_knocked_down_right
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose

    ;cmp    #frame_ninja_pain_drop_left
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose
    ;cmp    #frame_ninja_pain_drop_right
    ;beq    no_wound_check_ninja    ;no wound is possible in a defending pose

    lda   is_ninja_falling
    sta   $07

ninja_check_sumo_attack
    lda   is_sumo_attacking
    clc
    adc   is_sumo_falling
    beq   ninja_check_player_attack
    
    ldx   #sprite_index_ninja
    ldy   #sprite_index_sumo
    lda   is_sumo_falling
    sta   $06
    lda   last_sumo_direction
    jsr   check_attack_from_sprite
    and   #$7f
    bne   ninja_wounded_from_sumo     ; return value <> attack_received_noattack
    
ninja_check_player_attack
    lda   is_player_attacking
    clc
    adc   is_player_falling
    beq   no_wound_check_ninja

    ldx   #sprite_index_ninja
    ldy   #sprite_index_player
    lda   is_player_falling
    sta   $06
    lda   last_player_direction
    jsr   check_attack_from_sprite
    sta   $0f
    and   #$7f
    bne   ninja_wounded_from_player     ; return value <> attack_received_noattack

no_wound_check_ninja
    rts

ninja_wounded_from_sumo
    tax
    lda   is_ninja_falling
    and   is_sumo_falling
    beq   +
    rts   ;no harm when both are falling
+   txa
    ldx     #$ff
    stx     sumo_anim_disable_left_right_move
    jmp     ninja_wounded
ninja_wounded_from_player
    tax
    lda   is_ninja_falling
    and   is_player_falling
    beq   +
    rts   ;no harm when both are falling
+   txa
    ldx     #$ff
    stx     player_anim_disable_left_right_move
    ;sta    $d0
    ;jsr    stop_ninja_animation
    ;lda    $d0
    jsr   player_wounded_enemy

    ldx   ninja_hit_count
    cpx   #$01
    bne   ninja_wounded
    ;add score for ninja kill
    ;TODO: ADD SOUND EFFECT HERE - ninja killed
    sta   $58
    lda   #$04
    jsr   add_score
    lda   $58
ninja_wounded

    sta   $58
    lda   #SND_HIT
    jsr   (sound_set - music_data_start) + music_target_memory
    lda   $58
    
    dec   ninja_hit_count

    ldx   #$00
    stx   ninja_ai_stand_still_timer  ;wake up ninja from idle period with an attack

    ldx   #ninja_invulnerability_time_after_attack
    stx   ninja_invulnerability_timer   ;make ninja defended for a few seconds on the ground

    cmp   #attack_received_fall_to_ground_left
    beq   ninja_attacked_fall_left
    cmp   #attack_received_fall_to_ground_right
    beq   ninja_attacked_fall_right
    
    cmp   #attack_received_from_the_sky
    beq   ninja_attacked_from_above
    
    ldx   #$05              ;just a slight damage, make small invulnerability
    stx   ninja_invulnerability_timer   
    
    ;cmp    #attack_received_backup_left
    ;beq    ninja_attacked_backup_left
    ;cmp    #attack_received_backup_right
    ;beq    ninja_attacked_backup_right
    ; attacked, stand on feet
    ;inc    $ff19 
    rts
ninja_attacked_fall_left
    lda   #ninja_anim_id_fall_right
    jmp   start_ninja_animation
ninja_attacked_fall_right
    lda   #ninja_anim_id_fall_left
    jmp   start_ninja_animation

ninja_attacked_from_above
    lda   last_ninja_direction
    bne   +
    lda   #ninja_anim_id_faint_right
    jmp   start_ninja_animation
+
    lda   #ninja_anim_id_faint_left
    jmp   start_ninja_animation

;ninja_attacked_backup_left
;   lda   #ninja_anim_id_backup_right
;   jmp   start_ninja_animation
;ninja_attacked_backup_right
;   lda   #ninja_anim_id_backup_left
;   jmp   start_ninja_animation
    
;---------------------------------------------------------------
;   DO NINJA PHYSICS (falling, etc)
;---------------------------------------------------------------
is_ninja_falling
    !BYTE   00
    
do_ninja_physics
    lda   #sprite_index_ninja
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_body_character_behavior
    sta   $d1   ;this is the character behavior bitmask behind the player body
    and   #character_behavior_ladder
    beq   + ; we have no ladder behind, check platform at feet
    jmp   stop_ninja_falling ;stop doing more physics, ladder is grabbed
    
+   lda   #sprite_index_ninja
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_feet_character_behavior
    ;sta    $d0   ;this is the character behavior bitmask below the player
    ;sta    screen_mem_buffer1 + 50,y ;DEBUG
    ;sta    screen_mem_buffer2 + 50,y ;DEBUG
  ;!BYTE $f2
    and   #character_behavior_platform + character_behavior_ladder
    bne   stop_ninja_falling  ; we have something below, skip falling
    
    ;no platform below, fall ninja
    ldx   #frame_ninja_falling_left

    lda   last_ninja_direction
    beq   +
    ldx   #frame_ninja_falling_right
+
    stx   sprite3_data_frame
    jsr   move_ninja_down
    lda   #$01
    sta   is_ninja_falling
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite3_data_x
    and   #$fe
    sta   sprite3_data_x
    rts
    
stop_ninja_falling
    lda   #$00
    sta   is_ninja_falling
    rts

;---------------------------------------------------------------
;   MOVE NINJA ON LADDER
;---------------------------------------------------------------
ninja_climbing_internal_counter
    !BYTE   0
ninja_climbing_frame_phase
    !BYTE   0
ninja_climb_vertical_speed = 6
ninja_climb_horizontal_counter
    !BYTE   0
ninja_climb_horizontal_anim_speed = 2

ninja_climb_horizontal_speed_ladder = 6
ninja_climb_horizontal_speed_conveyor = 2
ninja_horizontal_climbing_speed
    !BYTE   0
    
alternate_climbing_up_down_frames_ninja
    lda   ninja_climbing_frame_phase
    eor   #$01
    sta   ninja_climbing_frame_phase
    bne   +
    lda   #frame_ninja_climb_up1
    jmp   alternate_1_ninja
+
    lda   #frame_ninja_climb_up2
    
alternate_1_ninja
    sta   sprite3_data_frame 
    rts
    
climbing_ninja_up
    lda   ninja_climbing_internal_counter
    clc
    adc   #$01
    cmp   #ninja_climb_vertical_speed
    bcc   cutemp1b_ninja

    jsr   move_ninja_up;
    jsr   move_ninja_up;
    jsr   move_ninja_up;

    lda   #sprite_index_ninja
    ldx   #body_area_head
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_up_ninja      ;wall during climbing

    jsr   alternate_climbing_up_down_frames_ninja
    lda   #$00
cutemp1b_ninja
    sta   ninja_climbing_internal_counter
    rts
    
wall_during_climb_up_ninja    
    jsr   move_ninja_down;
    jsr   move_ninja_down;
    jsr   move_ninja_down;
    lda   #$00
    sta   ninja_climbing_internal_counter
    rts
    
climbing_ninja_down
    lda   ninja_climbing_internal_counter
    clc
    adc   #$01
    cmp   #ninja_climb_vertical_speed
    bcc   cutemp2b_ninja

    jsr   move_ninja_down;
    jsr   move_ninja_down;
    jsr   move_ninja_down;

    lda   #sprite_index_ninja
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_feet_character_behavior
    and   #character_behavior_wall
    bne   wall_during_climb_down_ninja      ;wall during climbing

    jsr   alternate_climbing_up_down_frames_ninja   
    lda   #$00
cutemp2b_ninja
    sta   ninja_climbing_internal_counter
    rts
wall_during_climb_down_ninja
    jsr   move_ninja_up;
    jsr   move_ninja_up;
    jsr   move_ninja_up;
    lda   #$00
    sta   ninja_climbing_internal_counter
    rts
        
climbing_ninja_left
    lda   ninja_climbing_internal_counter
    clc
    adc   #$01
    cmp   ninja_horizontal_climbing_speed
    bcc   cutemp2bleftn

    jsr   move_ninja_left;

    lda   #sprite_index_ninja
    ldx   #body_area_left
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_left_ninja      ;wall during climbing

    ;lda    ninja_climb_horizontal_counter
    ;clc
    ;adc    #$01
    ;sta    ninja_climb_horizontal_counter
    ;cmp    #ninja_climb_horizontal_anim_speed
    ;bcc    +
    jsr   alternate_climbing_up_down_frames_ninja 
    ;lda    #$00
    ;sta    ninja_climb_horizontal_counter
;+    
    lda   #$00
cutemp2bleftn
    sta   ninja_climbing_internal_counter
    rts
wall_during_climb_left_ninja
    jsr   move_ninja_right;
    lda   #$00
    sta   ninja_climbing_internal_counter
    rts
    
climbing_ninja_right
    lda   ninja_climbing_internal_counter
    clc
    adc   #$01
    cmp   ninja_horizontal_climbing_speed
    bcc   cutemp2brightn

    jsr   move_ninja_right;

    lda   #sprite_index_ninja
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    bne   wall_during_climb_right_ninja     ;wall during climbing

    ;lda    ninja_climb_horizontal_counter
    ;clc
    ;adc    #$01
    ;sta    ninja_climb_horizontal_counter
    ;cmp    #ninja_climb_horizontal_anim_speed
    ;bcc    +
    jsr   alternate_climbing_up_down_frames_ninja 
    ;lda    #$00
    ;sta    ninja_climb_horizontal_counter
;+    

    lda   #$00
cutemp2brightn
    sta   ninja_climbing_internal_counter
    rts

wall_during_climb_right_ninja
    jsr   move_ninja_left;
    lda   #$00
    sta   ninja_climbing_internal_counter
    rts   

;---------------------------------------------------------------
;   MOVE NINJA USING JOYSTICK ON GROUND
;---------------------------------------------------------------  
current_ninja_input_delay
    !BYTE   00
ninja_delay_after_wall_hit = 6
    
move_ninja:

    jsr   progress_ninja_animation
    cmp   #$ff
    beq   +
    ;animation is currently running, no player input accepted
    lda   #$00
    rts   
+
    ; get directions from joystick
    lda   current_ninja_input_delay
    beq   + ; time to read joystick
    dec   current_ninja_input_delay
    jmp   ninja_standing_still
+   
    jsr   read_ninja_input

    lda   #sprite_index_ninja
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_body_character_behavior
    tax
    and   #character_behavior_ladder
    beq   normal_ninja_movements  ;no ladder behind our body_area_body
    
    ; set speed conveyor or ladder?
    ldy   #ninja_climb_horizontal_speed_ladder
    txa
    and   #character_behavior_conveyor
    bne   ninja_on_a_ladder
    ldy   #ninja_climb_horizontal_speed_conveyor
ninja_on_a_ladder
    sty   ninja_horizontal_climbing_speed
    
    ;------ ladder movements
    jsr   stop_ninja_animation  ;when in the middle of jump, etc, just stop the animation

    lda   joy_ninja_down
    bne   +
    ;climbing down
    jsr   climbing_ninja_down
    jmp   ninja_moved_but_no_physics
    
+
    lda   joy_ninja_up
    bne   +
    ;climbing up
    jsr   climbing_ninja_up
    jmp   ninja_moved_but_no_physics
+
    lda   joy_ninja_left
    bne   +
    ;climbing left
    jsr   climbing_ninja_left
    jmp   ninja_moved_but_no_physics
+   
    lda   joy_ninja_right
    bne   +
    ;climbing right
    jsr   climbing_ninja_right
    jmp   ninja_moved_but_no_physics
+   
    lda   #$00
    sta   ninja_climbing_internal_counter

    jmp   ninja_moved_but_no_physics
        
    ;----- normal movements jumping, lying, boxing, kicking
normal_ninja_movements    

    lda   joy_ninja_down
    bne   +
    ;lying on the floor
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite3_data_x
    and   #$fe
    sta   sprite3_data_x  
    lda   last_ninja_direction
    beq   plfacingleft_ninja
    lda   #ninja_anim_id_defending_right
    jsr   start_ninja_animation
    jmp   ninja_moved

plfacingleft_ninja    
    lda   #ninja_anim_id_defending_left
    jsr   start_ninja_animation
    jmp   ninja_moved

+   
    lda   joy_ninja_left
    bne   +++
    lda   joy_ninja_up
    bne   ++
    ;jump left
    lda   #ninja_anim_id_jump_left
    jsr   start_ninja_animation
    jmp   ninja_moved
++   
    lda   joy_ninja_fire
    bne   +++
    ;jump kick left
    lda   #sprite_index_ninja
    ldx   #body_area_left_kick_prep
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_left_ninja     ;wall before kick
    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    jmp   ninja_moved
wall_during_kick_left_ninja
    lda   #ninja_anim_id_jump_attack_left
    jsr   start_ninja_animation
    jmp   ninja_moved
    
+++   
    ; move ninja left
    ;check last_ninja_body_character_behavior against wall
    lda   #sprite_index_ninja
    ldx   #body_area_left_ninja
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   no_wall_left_ninja
    ;jsr    move_ninja_right
    ;jsr    move_ninja_right
    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    lda   #$00
    sta   last_ninja_direction

    jmp   ninja_moved
no_wall_left_ninja    
    lda   #frame_ninja_running_left
    sta   sprite3_data_frame
    jsr   move_ninja_left
    jmp   ninja_moved
+   
    lda   joy_ninja_right
    bne   +++
    lda   joy_ninja_up
    bne   ++
    ;jump right
    lda   #ninja_anim_id_jump_right
    jsr   start_ninja_animation
    jmp   ninja_moved
++   
    lda   joy_ninja_fire
    bne   +++
    ;jump kick right
    lda   #sprite_index_ninja
    ldx   #body_area_right_kick_prep
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   wall_during_kick_right_ninja      ;wall before kick
    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    jmp   ninja_moved
wall_during_kick_right_ninja
    lda   #ninja_anim_id_jump_attack_right
    jsr   start_ninja_animation
    jmp   ninja_moved
    
+++   
    ; move ninja right
    ;check last_ninja_body_character_behavior against wall
    lda   #sprite_index_ninja
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position

    and   #character_behavior_wall
    beq   no_wall_right_ninja
    ;jsr    move_ninja_left
    ;jsr    move_ninja_left
    lda   #$01
    sta   last_ninja_direction
    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    jmp   ninja_moved
no_wall_right_ninja
    lda   #frame_ninja_running_right
    sta   sprite3_data_frame
    jsr   move_ninja_right
    jmp   ninja_moved
+   
    lda   joy_ninja_up
    bne   +
    ;jump up
    lda   last_ninja_direction
    bne   plfright_ninja
    lda   #ninja_anim_id_jump_up_left
    jsr   start_ninja_animation
    jmp   ninja_moved
plfright_ninja
    lda   #ninja_anim_id_jump_up_right
    jsr   start_ninja_animation
    jmp   ninja_moved
    
+
    lda   joy_ninja_fire
    bne   +
    ;box punch
    lda   last_ninja_direction
    cmp   #$00
    beq   box_left_dir_ninja
    lda   #ninja_anim_id_spike_right
    jsr   start_ninja_animation
    jmp   ninja_moved
box_left_dir_ninja:
    lda   #ninja_anim_id_spike_left
    jsr   start_ninja_animation
    jmp   ninja_moved

+   
ninja_standing_still
    ;  nothing pressed
    ;  ninja standing still
    ;shift x slightly to avoid sprite frame shift continuously
    lda   sprite3_data_x
    and   #$fe
    sta   sprite3_data_x

    lda   last_ninja_direction
    bne   +
    lda   #frame_ninja_standing_left;
    sta   sprite3_data_frame
    jmp   ninja_moved
+
    lda   #frame_ninja_standing_right;
    sta   sprite3_data_frame
    jmp   ninja_moved

ninja_moved
    lda   #$ff    ;returns ff means no animation, do the physics
    rts

ninja_moved_but_no_physics
    lda   #$00    ;returns 00 means do not do the physics
    rts

ninja_anim_current_frame:
    !BYTE 0
ninja_anim_subtimer:
    !BYTE 0
ninja_anim_subtimer_timeout   = 2
ninja_current_anim_running
    !BYTE 0

;-----------------------------------------------------------------------------------------
;     STOP NINJA ANIMATION      
;-----------------------------------------------------------------------------------------
stop_ninja_animation:
    lda   #ninja_anim_id_no_animation
    jmp   start_ninja_animation

;-----------------------------------------------------------------------------------------
;     START NINJA ANIMATION       param:    A = animation sequence id
;-----------------------------------------------------------------------------------------
start_ninja_animation:

    sta   ninja_current_anim_running
    asl
    tax
    lda   ninja_animation_sequences,x
    sta   ninja_anim_seq + 1
    sta   ninja_anim_seq2 + 1
    sta   ninja_anim_seq3 + 1
    sta   ninja_anim_seq4 + 1
    lda   ninja_animation_sequences + 1,x
    sta   ninja_anim_seq + 2
    sta   ninja_anim_seq2 + 2
    sta   ninja_anim_seq3 + 2
    sta   ninja_anim_seq4 + 2
    lda   #$00
    sta   ninja_anim_current_frame
    sta   ninja_anim_subtimer
    rts

;-----------------------------------------------------------------------------------------
;     PROGRESS NINJA ANIMATION        does next anim sequence action
;-----------------------------------------------------------------------------------------
;last_ninja_body_character_behavior = $f4
;last_ninja_feet_character_behavior = $f5

progress_ninja_animation:
    
    lda   ninja_anim_current_frame
    asl
    asl
    tax
ninja_anim_seq
    lda   ninja_animation_sequences,x
    cmp   #RESTORE_LADDER_GRAB
    bne   +
    lda   #sprite_index_ninja   ; Check player on ladder at the end of animation
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_body_character_behavior    
    jsr   ninja_grabs_ladder_when_necessary
    inc   ninja_anim_current_frame
    lda   #$ff

+     cmp   #$ff
    bne   +
    ldx   #$00
    stx   is_ninja_attacking
  
    rts   ;return 255, no animation needed any more, reached last frame
+
    sta   $d2
    inx
ninja_anim_seq2
    lda   ninja_animation_sequences,x
    sta   $d1
    inx
ninja_anim_seq3
    lda   ninja_animation_sequences,x ;is this step timer-dependent?
    sta   $d0

    inx
ninja_anim_seq4
    lda   ninja_animation_sequences,x ;force player direction flag
    sta   $e3
    
    inc   ninja_anim_subtimer
    ldy   ninja_anim_subtimer
    cpy   #ninja_anim_subtimer_timeout
    bcc   + ;timer not reached, play current anim frame action step again

    ;timer reached, restart timer, advance to next animation 
    inc   ninja_anim_current_frame
    ldy   #$00    ;restart timer
    sty   ninja_anim_subtimer
  
+
    lda   $d0
    beq   do_action_move_ninja    ;no timer dependent, do immediately
    
    ;go to the next frame immediately for special, timer-dependent animation steps
    inc   ninja_anim_current_frame
    ldy   #$00    ;restart timer
    sty   ninja_anim_subtimer
    
do_action_move_ninja
  
    lda   $d2 ;sprite frame id
    sta   sprite3_data_frame    ;action sequence first byte is the sprite frame

    lda   $d1 ;second byte is the movement operator: direction + count
    tay
    and   #$07
    sta   number_of_moves_ninja + 1
    tya
    and   #action_move_attack_moment
    sta   is_ninja_attacking
    tya
    sta   $e1

    ldx   #$00
-   stx   $e0

    ; animation movements are checking the screen elements to stop animations
    lda   #sprite_index_ninja   ; sprite 2
    ldx   #body_area_body
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_body_character_behavior
    
    and   #character_behavior_ladder
    beq   +
    lda   ninja_current_anim_running
    cmp   #ninja_anim_id_fall_right
    beq   +   ;can fall on ladder
    cmp   #ninja_anim_id_fall_left
    beq   +   ;can fall on ladder
    jmp   action_skip_more_move_directions_ladder_ninja ; we have ladder below, skip moving 
+
    lda   $e1
    and   #action_move_down
    beq   +

    lda   #sprite_index_ninja   ; sprite 2
    ldx   #body_area_feet
    jsr   get_behavior_from_sprite_position
    sta   last_ninja_feet_character_behavior
    and   #character_behavior_platform + character_behavior_ladder
    bne   action_platform_on_move_down_ninja ; we have platform below, skip moving 
    jsr   move_ninja_down
+   
continue_from_knock_down_ninja
+   
    lda   $e1
    and   #action_move_up
    beq   +
    
    jsr   move_ninja_up
+   
    lda   $e1
    and   #action_move_left
    beq   +
    lda   last_ninja_body_character_behavior      ;body character behavior
    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_right_ninja ; we have a wall near, skip moving 
    jsr   move_ninja_left
+   
    lda   $e1
    and   #action_move_right
    beq   +
    lda   last_ninja_body_character_behavior

    and   #character_behavior_wall
    bne   action_skip_more_move_directions_with_move_left_ninja ; we have a wall near, skip moving 
    jsr   move_ninja_right
+   
    ldx   $e0
    inx
number_of_moves_ninja
    cpx   #$01
    bne   -

    lda   $e3   ;at the end of all moves, force ninja direction
    sta   last_ninja_direction

    lda   #$00
    rts


action_platform_on_move_down_ninja
    lda   ninja_current_anim_running
    cmp   #ninja_anim_id_fall_left
    beq   +
    cmp   #ninja_anim_id_fall_right
    beq   +
    lda   $e3
    sta   last_ninja_direction
    lda   #$ff
    rts
+
    jsr   move_ninja_down
    jmp   continue_from_knock_down_ninja
    
action_skip_more_move_directions_ninja    
    lda   $e3   ;at the end of all moves, force ninja direction
    sta   last_ninja_direction

    lda   #$ff
    rts

action_skip_more_move_directions_with_move_right_ninja
    jsr   move_ninja_right
    jsr   move_ninja_right
    jsr   move_ninja_right
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_ninja_direction
    jsr   stop_ninja_animation
    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    lda   #$ff
    rts

action_skip_more_move_directions_with_move_left_ninja
    jsr   move_ninja_left
    jsr   move_ninja_left
    jsr   move_ninja_left
    ;lda    $e3   ;at the end of all moves, force player direction
    ;sta    last_ninja_direction
    jsr   stop_ninja_animation

    lda   #ninja_delay_after_wall_hit
    sta   current_ninja_input_delay
    lda   #$ff
    rts

action_skip_more_move_directions_ladder_ninja   
    lda   $e3   ;at the end of all moves, force player direction
    sta   last_ninja_direction
    
    lda   #frame_ninja_climb_up1    ;freeze animation on ladder with setting frame
    sta   sprite3_data_frame
    lda   #$00
    sta   ninja_climbing_frame_phase
    
    lda   #$ff
    rts

;-------------------------------------------------------------------------------------
ninja_grabs_ladder_when_necessary

    lda   last_ninja_body_character_behavior
    and   #character_behavior_ladder
    beq   +
    
    ;we stand on a ladder... set anim frame
    lda   #frame_ninja_climb_up1
    sta   sprite3_data_frame
    lda   #$00
    sta   ninja_climbing_frame_phase    
+   
    rts   

;---------------------------------------------------------
;     MOVE NINJA (UP/DOWN/LEFT/RIGHT)
;--------------------------------------------------------
move_ninja_left:
    ;lda  #$55
    ;sta $ff19
    ldx   #$00
    stx   last_ninja_direction
    lda   sprite3_data_x
    cmp   #$08
    bcc   +
    dec   sprite3_data_x
+   rts

move_ninja_right:
    ;lda  #$77
    ;sta $ff19
    ldx   #$01
    stx   last_ninja_direction
    lda   sprite3_data_x
    cmp   #limit_sprite_x_pos
    bcs   +
    inc   sprite3_data_x
+   rts

move_ninja_up:
    ;lda  #$77
    ;sta $ff19
    lda   sprite3_data_y
    cmp   #$08
    bcc   +
    dec   sprite3_data_y
+   rts

move_ninja_down:
    ;lda  #$77
    ;inc $ff19
    lda   sprite3_data_y
    cmp   #limit_sprite_y_pos
    bcs   +
    inc   sprite3_data_y
+   rts

;-------------------------------------------------------------------------------------
;   ANIMATIONS AND SEQUENCES
;-------------------------------------------------------------------------------------

ninja_animation_sequences:
ninja_anim_id_no_animation          = 0
      !WORD ninja_anim_seq_no_animation
ninja_anim_id_jump_left       = 1
      !WORD ninja_anim_seq_jump_left
ninja_anim_id_jump_right        = 2
      !WORD ninja_anim_seq_jump_right
ninja_anim_id_jump_up_left        = 3
      !WORD ninja_anim_seq_jump_up_left
ninja_anim_id_jump_up_right     = 4
      !WORD ninja_anim_seq_jump_up_right
ninja_anim_id_spike_left          = 5
      !WORD ninja_anim_seq_spike_left
ninja_anim_id_spike_right       = 6
      !WORD ninja_anim_seq_spike_right
ninja_anim_id_jump_attack_left        = 7
      !WORD ninja_anim_seq_jump_attack_left
ninja_anim_id_jump_attack_right       = 8
      !WORD ninja_anim_seq_jump_attack_right
ninja_anim_id_defending_right       = 9
      !WORD ninja_anim_seq_defending_right
ninja_anim_id_defending_left        = 10
      !WORD ninja_anim_seq_defending_left
ninja_anim_id_fall_right        = 11
      !WORD ninja_anim_seq_fall_right
ninja_anim_id_fall_left       = 12
      !WORD ninja_anim_seq_fall_left
ninja_anim_id_faint_right       = 13
      !WORD ninja_anim_seq_faint_right
ninja_anim_id_faint_left        = 14
      !WORD ninja_anim_seq_faint_left      
ninja_anim_seq_no_animation:
      !BYTE 255

ninja_anim_seq_jump_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_ninja_falling_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_falling_left, action_move_left + 1, 1, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_falling_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left+ 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_ninja_falling_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE 255

ninja_anim_seq_jump_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_ninja_falling_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_falling_right, action_move_right + 1, 1, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_falling_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right+ 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_ninja_falling_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE 255

ninja_anim_seq_jump_up_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame2_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_left, action_move_up + 1, 0, 0 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame2_down
      !BYTE frame_ninja_falling_left, action_move_down + 1, 0, 0 ;anim_action_jump_up_frame1_down
      !BYTE 255

ninja_anim_seq_jump_up_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame2_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_right, action_move_up + 1, 0, 1 ;anim_action_jump_up_frame3_up
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame3_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame2_down
      !BYTE frame_ninja_falling_right, action_move_down + 1, 0, 1 ;anim_action_jump_up_frame1_down
      !BYTE 255
      
ninja_anim_seq_spike_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_standing_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_standing_left
      !BYTE frame_ninja_attack2_left, action_move_left + 4 + action_move_attack_moment, 1, 0 ;anim_action_box_punch_left_with_move
      !BYTE frame_ninja_attack2_left, action_move_no_move + action_move_attack_moment, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_standing_left, action_move_right + 4, 1, 0 ;anim_action_standing_left
      !BYTE 255

ninja_anim_seq_spike_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_standing_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_standing_right
      !BYTE frame_ninja_attack2_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right_with_move
      !BYTE frame_ninja_attack2_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_standing_right, action_move_no_move,0, 1 ;anim_action_standing_right
      !BYTE 255
    
ninja_anim_seq_jump_attack_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      ;!BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      ;!BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      ;!BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_ninja_falling_left, action_move_up + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_up
      !BYTE frame_ninja_attack1_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_attack1_left, action_move_left + 1, 1, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_attack1_left, action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_left
      !BYTE frame_ninja_attack1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      !BYTE frame_ninja_attack1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      ;!BYTE frame_ninja_attack1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame2_down
      ;!BYTE frame_ninja_attack1_left, action_move_down + action_move_left+ 1, 0, 0 ;anim_action_jump_left_frame1_down
      ;!BYTE frame_ninja_attack1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_ninja_attack1_left, action_move_down + action_move_left + 1, 0, 0 ;anim_action_jump_left_frame1_down
      !BYTE frame_ninja_attack2_left, action_move_left + 4 + action_move_attack_moment, 1, 0 ;anim_action_box_punch_left_with_move
      !BYTE frame_ninja_attack2_left, action_move_no_move + action_move_attack_moment, 0, 0 ;anim_action_box_punch_left
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_attack2_left, action_move_no_move, 0, 0 ;anim_action_box_punch_left_with_move_back
      !BYTE frame_ninja_standing_left, action_move_right + 4, 1, 0 ;anim_action_standing_left
      !BYTE 255

ninja_anim_seq_jump_attack_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      ;!BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      ;!BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_up
      ;!BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_ninja_falling_right, action_move_up + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_up
      !BYTE frame_ninja_attack1_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_attack1_right, action_move_right + 1, 1, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_attack1_right, action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_right
      !BYTE frame_ninja_attack1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      !BYTE frame_ninja_attack1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      ;!BYTE frame_ninja_attack1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame2_down
      ;!BYTE frame_ninja_attack1_right, action_move_down + action_move_right+ 1, 0, 1 ;anim_action_jump_right_frame1_down
      ;!BYTE frame_ninja_attack1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_ninja_attack1_right, action_move_down + action_move_right + 1, 0, 1 ;anim_action_jump_right_frame1_down
      !BYTE frame_ninja_attack2_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move + action_move_attack_moment, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_attack2_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE frame_ninja_standing_right, action_move_no_move, 0, 1 ;anim_action_box_punch_right_with_move_back
      !BYTE 255

ninja_anim_seq_defending_right:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE frame_ninja_attack1_right, action_move_no_move, 0, 1 ;anim_action_lying_right
      !BYTE 255     

ninja_anim_seq_defending_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE frame_ninja_attack1_left, action_move_no_move, 0, 0 ;anim_action_lying_left
      !BYTE 255     

ninja_anim_seq_fall_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_pain_drop_right, action_move_left + 2, 0, 1 
      !BYTE frame_ninja_pain_drop_right, action_move_left + 2, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_left + 2, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_left + 1, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_left + action_move_down + 1, 0, 1 
      ;!BYTE frame_ninja_knocked_down_right, action_move_left + 1, 0, 1 
      ;!BYTE frame_ninja_knocked_down_right, action_move_left + 1, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      ;!BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      ;!BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      ;!BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

ninja_anim_seq_fall_right: 
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_pain_drop_left, action_move_right + 2, 0, 0 
      !BYTE frame_ninja_pain_drop_left, action_move_right + 2, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_left + 2, 1, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_right + 1, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_right + action_move_down + 1, 0, 0 
      ;!BYTE frame_ninja_knocked_down_left, action_move_right + 1, 0, 0 
      ;!BYTE frame_ninja_knocked_down_left, action_move_right + 1, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      ;!BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      ;!BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      ;!BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_standing_left, action_move_right + 4, 1, 0 
      !BYTE RESTORE_LADDER_GRAB,0,0,0
      !BYTE 255     

ninja_anim_seq_faint_left:
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_pain_drop_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE frame_ninja_knocked_down_right, action_move_no_move, 0, 1 
      !BYTE 255     

ninja_anim_seq_faint_right: 
      ; sprite frame / move direction + count / timer-restricted / force player direction flag
      !BYTE frame_ninja_pain_drop_left, action_move_left + 1, 1, 0
      !BYTE frame_ninja_pain_drop_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_pain_drop_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_knocked_down_left, action_move_no_move, 0, 0 
      !BYTE frame_ninja_standing_left, action_move_right + 1, 1, 0 
      !BYTE 255     
      
last_ninja_direction:
        !BYTE 0;    0 - left; 1- right
        
;     registers are 0 when pressed
joy_ninja_up    !BYTE 255
joy_ninja_down    !BYTE 255
joy_ninja_left    !BYTE 255
joy_ninja_right   !BYTE 255
joy_ninja_fire    !BYTE 255

read_ninja_input:

    lda   ninja_control_method
    cmp   #control_method_joy1
    beq   ninja_joy1
    cmp   #control_method_joy2
    beq   ninja_joy2
    cmp   #control_method_keyboard
    beq   ninja_keyboard
    jmp   ninja_ai

ninja_joy1  
    lda   #$fb
    sta   $fd30
    sta   $ff08
    jmp   read_ninja_controls
ninja_joy2
    lda   #$fd
    sta   $fd30
    sta   $ff08
    jmp   read_ninja_controls
ninja_keyboard
    lda   #$f7
    sta   $fd30
    sta   $ff08
    
read_ninja_controls
    lda   $ff08
    tax
    and   #$01
    sta   joy_ninja_up
    txa
    and   #$02
    sta   joy_ninja_down
    txa
    and   #$04
    sta   joy_ninja_left
    txa
    and   #$08
    sta   joy_ninja_right
    txa
    and   #$c0
    cmp   #$c0
    beq   +
    lda   #$00
    sta   joy_ninja_fire
    rts
+
    sta   joy_ninja_fire
    rts

;---------------------------------------------------------------------
;       NINJA AI TACTIC
;---------------------------------------------------------------------
ninja_ai_stand_still_timer
    !BYTE   00
ninja_ai_run_distance_timer
    !BYTE   00
ninja_ai_last_run_direction
    !BYTE   00
    
ninja_ai  

    ; reset inputs before ai turn
    lda   #$ff
    sta   joy_ninja_down
    sta   joy_ninja_up
    sta   joy_ninja_left
    sta   joy_ninja_right
    sta   joy_ninja_fire

    ;face to player
    lda   sprite3_data_x
    ldx   #$00
    cmp   sprite1_data_x
    bcs   +
    ldx   #$01
+
    stx   last_ninja_direction

    ;needs to follow?
    
    lda   ninja_ai_stand_still_timer
    beq   ninja_is_not_waiting_any_more
    dec   ninja_ai_stand_still_timer
    jmp   ninja_on_conveyor   ;idle, wait, attack only
    
ninja_is_not_waiting_any_more
    lda   sprite1_data_y    ;player y
    clc
    adc   #15       ;ninja looks higher to follow
    cmp   sprite3_data_y
    bcs   ninja_follows_player

    lda   #$00
    sta   ninja_ai_run_distance_timer   ;keep timer low. When sees me, immediately runs toward me
    jsr   ninja_on_conveyor
    lda   ninja_ai_last_run_direction
    sta   $d0
    jmp   ninja_attack_tactics    ;idle, wait, attack only    ;ninja stands still, no player near

ninja_follows_player

    ;byt   $f2

    lda   ninja_ai_run_distance_timer
    bne   ninja_keep_running  ;running is on way, continue

    ;end of running, decide next
    lda   sprite3_data_x
    cmp   #$98      ;x near right edge
    bcc   +
    ldx   #$00    ;force running left only
    stx   last_ninja_direction
+
    cmp   #$20            ;x near left edge
    bcs   +
    ldx   #$01    ;force running right only
    stx   last_ninja_direction
+
    lda   last_ninja_direction
    sta   ninja_ai_last_run_direction

    ;set run distance before next amok turn
    jsr   get_next_random_number
    tax
    and   #$1f
    clc
ninja_running_distance_minimum
    adc   #20
    sta   ninja_ai_run_distance_timer   ;reset timer to new distance and direction
    txa   ;random
    and   #$0f
    bne   +   
    lda   #$00    ;shout 1/16 chance
    sta   joy_ninja_down
+
    jmp   ninja_continue_running

ninja_keep_running
    dec   ninja_ai_run_distance_timer

ninja_continue_running
    ldy   #$00
    ldx   ninja_ai_last_run_direction
    beq   ninja_moves_left

ninja_moves_right
    sty   joy_ninja_right
    lda   #$01
    sta   $d0
    jmp   after_ninja_move
ninja_moves_left
    sty   joy_ninja_left
    lda   #$00
    sta   $d0

after_ninja_move

    ;avoid environment elements
    lda   #sprite_index_ninja   
    ldx   #body_area_left_ninja
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   +
    ;ran against wall
    lda   #$01
    sta   ninja_ai_last_run_direction ;turn around
    jsr   get_next_random_number
    and   #$0f
    clc
    adc   ninja_running_distance_minimum + 1
    sta   ninja_ai_run_distance_timer 
    jmp   ninja_attack_tactics
+
    lda   #sprite_index_ninja   
    ldx   #body_area_right
    jsr   get_behavior_from_sprite_position
    and   #character_behavior_wall
    beq   +
    ;ran against wall
    lda   #$00
    sta   ninja_ai_last_run_direction ;turn around
    jsr   get_next_random_number
    and   #$0f
    clc
    adc   ninja_running_distance_minimum + 1
    sta   ninja_ai_run_distance_timer 
+

ninja_attack_tactics

    ;attacking
    lda   sprite1_data_y
    sec
    sbc   sprite3_data_y
    cmp   #20
    bcc   ninja_player_close
    cmp   #235
    bcs   ninja_player_close
    lda   #$e0 ;run as far as can when player not in sight
    sta   ninja_running_distance_minimum + 1
    rts   ;   enemy far, no attack  
    
ninja_player_close
    lda   #20
    sta   ninja_running_distance_minimum + 1
    lda   sprite3_data_x    ;ninja x
    ldy   ninja_ai_last_run_direction
    ldx   sprite1_data_x    ; player x
    
    jsr   suggest_attack_from_sprites
    sta   dev_mode_info_bar + 28
    
    cmp   #suggested_attack_near
    beq   ninja_attack_close
    rts
    
ninja_attack_close
    lda   sprite1_data_frame    ;player frame
    cmp   #frame_lying_left
    beq   ninja_player_defending  ; do not punch when lying
    cmp   #frame_lying_right
    beq   ninja_player_defending  ; do not punch when lying
    jsr   get_next_random_number
    tax
    and   #$03
    beq   run_away_from_attack_ninja
    lda   #$00
    sta   joy_ninja_fire
    lda   #$ff
    sta   joy_ninja_left
    sta   joy_ninja_right
    sta   joy_ninja_down
    sta   joy_ninja_up
    lda   #0 ; recheck running direction after attack
    sta   ninja_ai_run_distance_timer

ninja_player_defending
    rts
run_away_from_attack_ninja
    txa
    and   #$0f
    clc
    adc   #20
    sta   ninja_running_distance_minimum + 1
    rts
    
;------------------------------------------------------
ninja_on_conveyor
    lda   last_ninja_body_character_behavior
    and   #character_behavior_conveyor
    beq   ++
    ;ninja on a conveyor
    lda   sprite3_data_y
    cmp   #max_y_on_conveyor
    bcc   +
    lda   #$00
    sta   joy_ninja_up
    rts
+
    cmp   #min_y_on_conveyor
    bcs   ++
    lda   #$00
    sta   joy_ninja_down

++
    rts

screens:
    !WORD screen_1
    !WORD screen_1
    !WORD screen_2
    !WORD screen_3
    !WORD screen_4
    !WORD screen_5
    !WORD screen_6
    !WORD screen_7
    !WORD screen_8
    !WORD screen_9
    !WORD screen_10
    !WORD screen_11
    !WORD screen_12
    !WORD screen_13
    !WORD screen_14
    !WORD screen_15
    !WORD screen_16
    !WORD screen_17
    !WORD screen_18
    !WORD screen_19

;-- level data
screen_1:
    ; header structure
    !BYTE $62, $31,$51 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 2;target screen index
    !BYTE $12, $5a ; x and y intially on target screen

    ;warp 2 target
    !BYTE 2;target screen index
    !BYTE $12,$8a ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen
    
    ;pointer to screen execution logic
    !WORD screen_does_nothing   ;init routine
    !WORD screen_does_nothing

    ;spawn interval on this screen
    !BYTE 40

    ;in hard mode, can be spawned with player?
    !BYTE 1
    
    ;lamp positions
    !BYTE 0, 2, 19    ;num, x, y
    !BYTE 1, 38 + LAMP_SHIFT, 19    ;num, x, y
    !BYTE 2, 25, 19   ;num, x, y
    !BYTE 3, 29, 19   ;num, x, y
    !BYTE 4, 31, 13   ;num, x, y
    !BYTE 5, 38 + LAMP_SHIFT, 13    ;num, x, y
    !BYTE 255   

    ;spawn points
    !BYTE $98, $5a
    !BYTE $50, $5a
    !BYTE $90, $8a
    !BYTE $88, $8a
    !BYTE $20, $bb
    !BYTE $90, $bb
    !BYTE $70, $bb
    !BYTE 255
    
    ;blocks
    !BYTE 1,1,23,39,99  ;ground
    !BYTE 0,7,14,99,99  ;bull
    !BYTE 3,27,16,13,99 ;platform
    !BYTE 2,25,16,99,99 ;platform end left
    !BYTE 4, 27,18,99,99  ;column
    !BYTE 5, 31,18,99,99  ;column
    !BYTE 5, 36,18,99,99  ;column
    !BYTE 6, 32,18,99,99  ;door1
    !BYTE 6, 34,18,99,99  ;door1
    !BYTE 7, 39,18,99,99  ;column
    !BYTE 3,0,14,4,99 ; platform
    !BYTE 7, 0,18,99,99  ;column
    !BYTE 7, 0,16,99,4  ;column
    !BYTE 8,2,14,99,99  ;platform end right
    !BYTE 9,0,10,99,99  ;platform thick
    !BYTE 9,15,10,10,99 ;platform thick
    !BYTE 10,4,10,2,99  ;platform thin
    !BYTE 10,10,10,3,99 ;platform thin
    !BYTE 10,16,10,7,99 ;platform thin
    !BYTE 10,25,10,1,99 ;platform thin
    !BYTE 11,1,8,99,99  ;statue
    !BYTE 2,31,10,99,99 ;platform end left
    !BYTE 3,33,10,7,99  ;platform
    !BYTE 12,33,12,99,99  ;door column left
    !BYTE 13,36,12,99,99  ;door column right
    !BYTE 14,34,12,99,99  ;door between the door columns
    !BYTE 15,18,12,99,99  ;ladder top
    !BYTE 16,18,18,99,99  ;ladder bottom
    !BYTE 15,19,12,99,99  ;ladder top
    !BYTE 16,19,18,99,99  ;ladder bottom
    !BYTE 17,1,16,3,3   ;space around spike
    !BYTE 18,2,16,99,99 ;spike down
    !BYTE 19,0,2,40,3   ;sky
    !BYTE 20,0,4,99,3   ;hills 1
    !BYTE 20,10,4,4,3   ;hills 1
    !BYTE 21,14,4,99,3  ;hills 1 right
    !BYTE 20,16,4,1,3   ;hills 1
    !BYTE 21,17,4,99,3  ;hills 1 right
    !BYTE 22,19,2,99,99 ;hills 2 high

    !BYTE 20,22,2,5,3   ;hills 1
    !BYTE 21,27,2,2,3   ;hills 1
    !BYTE 20,28,2,6,3   ;hills 1
    !BYTE 21,34,2,2,3   ;hills 1
    !BYTE 23,35,3,99,99 ;hills 2 high right
    !BYTE 24,38,4,99,99 ;hills 2 high left
    
    !BYTE 42,39,7,1,3   ;warp 1
    !BYTE 43,39,13,1,3    ;warp 2
    
    !BYTE 255; end of level

screen_2:
    ; header structure
    !BYTE $62, $31,$51 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 1;target screen index
    !BYTE $a5,$5a ; x and y intially on target screen

    ;warp 2 target
    !BYTE 1;target screen index
    !BYTE $a5, $8a ; x and y intially on target screen

    ;warp 3 target
    !BYTE 3;target screen index
    !BYTE $12 ,$5a ; x and y intially on target screen

    ;warp 4 target
    !BYTE 5;target screen index
    !BYTE $30,$28 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen2_actions_init    ;init routine
    !WORD screen2_actions

    ;spawn interval on this screen
    !BYTE 40

    ;in hard mode, can be spawned with player?
    !BYTE 1
  
    ;lamp positions
    !BYTE 6, 9 + LAMP_SHIFT, 13   ;num, x, y
    !BYTE 7, 30, 13   ;num, x, y
    !BYTE 8, 6, 19    ;num, x, y
    !BYTE 9, 15 + LAMP_SHIFT, 19    ;num, x, y
    !BYTE 10, 24, 19    ;num, x, y
    !BYTE 11, 32, 19    ;num, x, y
    !BYTE 255 

    ;spawn points
    !BYTE $18, $5a
    !BYTE $98, $5a
    !BYTE $18, $8a
    !BYTE $90, $8a
    !BYTE $20, $bb
    !BYTE $90, $bb

    !BYTE $70, $bb
    !BYTE 255
    
    ;blocks
    ;!BYTE BLOCK_COLOR_OVERRIDE, $3a,0,0,0  ;from now, every block will use the given color
    !BYTE 1,0,23,40,99  ;ground
    !BYTE 3,26,16,14,99 ;platform
    !BYTE 2,24,16,99,99 ;platform end left
    !BYTE 3,32,10,8,99  ;platform
    !BYTE 2,30,10,99,99 ;platform end left

    ;!BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    
    !BYTE 3,0,10,8,99   ;platform
    !BYTE 8,8,10,99,99  ;platform end right

    !BYTE 3,0,16,14,99  ;platform
    !BYTE 8,14,16,99,99 ;platform end right

    !BYTE 4, 26,18,99,99  ;column white
    !BYTE 7, 38,18,99,99  ;column black 
    !BYTE 4, 13,18,99,99  ;column white
    !BYTE 7, 0,18,99,99   ;column black
    !BYTE 4, 7,12,99,5  ;column white
    !BYTE 4, 32,12,99,5   ;column white
    !BYTE 27, 38,12,99,99  ;column black short

    !BYTE 25,2,12,99,99   ;door 3
    !BYTE 26,34,12,99,99  ;door 4
    !BYTE 47,28,18,99,99  ;door 6
    !BYTE 47,34,18,99,99  ;door 6

    !BYTE 28,2,18,99,99   ;door 5
    !BYTE 28,8,18,99,99   ;door 5

    !BYTE 10,14,10,12,99  ;platform thin
    !BYTE 9,15,10,3,99  ;platform thick
    !BYTE 9,22,10,3,99  ;platform thick

    !BYTE 16,19,18,2,2  ;ladder bottom
    !BYTE 15,19,16,2,2  ;ladder top

    !BYTE 29,19,15,99,99  ;small hinge
    !BYTE 30,19,12,99,99  ;small ladder

    !BYTE 31,19,22,99,99  ;lid

    !BYTE 19,0,2,40,4   ;sky
    !BYTE 32,0,4,99,99  ;hill 3
    !BYTE 23,11,5,99,3  ;hills 2 high right
    !BYTE 22,14,4,99,99 ;hills 2 high
    !BYTE 22,16,2,99,99 ;hills 2 high

    !BYTE 17,19,2,4,8     ;space below hilltop
    !BYTE 33,19,2,99,99   ;hilltop
      
    !BYTE 23,23,3,99,99 ;hills 2 high right
    !BYTE 23,25,5,99,99 ;hills 2 high right

    !BYTE 19,35,2,5,5   ;sky
    !BYTE 34,28,5,99,3  ;hill 4
    !BYTE 23,35,6,99,99 ;hills 2 high right
    !BYTE 32,38,7,2,99  ;hill 3
    
    !BYTE 42,0,7,1,3    ;warp 1
    !BYTE 43,0,13,1,3   ;warp 2
    !BYTE 44,39,8,1,2   ;warp 3
    
    !BYTE 255; end of level

screen_3:
    ; header structure
    !BYTE $62, $31,$51 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 2;target screen index
    !BYTE $a5, $5a ; x and y intially on target screen

    ;warp 2 target
    !BYTE 4;target screen index
    !BYTE $12,$bb ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen3_actions_init    ;init routine
    !WORD screen3_actions

    ;spawn interval on this screen
    !BYTE 40

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 12, 22, 13    ;num, x, y
    !BYTE 13, 26 + LAMP_SHIFT, 13   ;num, x, y
    !BYTE 14, 30, 13    ;num, x, y
    !BYTE 15, 5, 13   ;num, x, y
    !BYTE 16, 9 + LAMP_SHIFT, 13    ;num, x, y
    !BYTE 17, 5 + LAMP_SHIFT, 19    ;num, x, y
    !BYTE 18, 9, 19   ;num, x, y
    !BYTE 19, 15 + LAMP_SHIFT, 19   ;num, x, y
    !BYTE 20, 21, 19    ;num, x, y
    !BYTE 21, 27 + LAMP_SHIFT, 19   ;num, x, y
    !BYTE 255

    ;spawn points
    !BYTE $18, $5a
    !BYTE $23, $5a
    !BYTE $18, $8a
    !BYTE $20, $bb

    !BYTE $90, $bb
    !BYTE $66, $bb
    !BYTE 255
    
    ;blocks
    !BYTE 1,0,23,40,99  ;ground
    !BYTE 3,0,10,8,99   ;platform
    !BYTE 8,8,10,99,99  ;platform end right

    !BYTE 3,10,16,4,99  ;platform
    !BYTE 8,14,16,99,99 ;platform end right
    !BYTE 2,9,16,99,99  ;platform end left

    !BYTE 3,0,16,4,99   ;platform
    !BYTE 8,4,16,99,99  ;platform end right

    !BYTE 2,22,10,99,99 ;platform end left
    !BYTE 3,24,10,1,99  ;platform
    !BYTE 8,25,10,99,99 ;platform end right

    !BYTE 7, 0,18,99,99   ;column black
    !BYTE 4, 11,18,99,99  ;column white
    !BYTE 4, 13,18,99,99  ;column white
    !BYTE 4, 3,18,99,99   ;column white
    !BYTE 27, 0,12,99,99  ;column black short

    !BYTE 12,2,12,99,99 ;door column left
    !BYTE 13,3,12,99,99 ;door column right
    
    !BYTE 3,23,16,3,99  ;platform
    !BYTE 8,26,16,99,99 ;platform end right
    !BYTE 2,21,16,99,99 ;platform end left
    !BYTE 4,23,18,99,99   ;column white
    !BYTE 4,25,18,99,99   ;column white
    !BYTE 4,24,12,99,5    ;column white
    
    !BYTE 4,7,12,99,4   ;column white tall top
    !BYTE 4,7,18,99,99  ;column white latt bottom
    !BYTE 35,7,15,1,6  ;column white tall middle 

    !BYTE 1,10,11,10,99 ;high ground
    !BYTE 17,13,11,4,1  ;space between  high ground platform
    
    !BYTE 36,17,12,3,6  ;ladder top
    !BYTE 37,17,18,3,2  ;ladder bottom

    !BYTE 1,30,11,10,99 ;high ground
    !BYTE 0,33,14,99,99 ;bull
    !BYTE 11,34,8,99,99 ;statue
    !BYTE 38,31,12,99,99  ;double column
    !BYTE 39,39,12,99,99  ;double column black
    !BYTE 48,30,12,99,99  ;lamp hanger

    !BYTE 40,32,12,99,99  ;upper left corner
    !BYTE 41,37,12,99,99  ;upper right corder

    !BYTE 19,0,2,40,4   ;sky
    !BYTE 32,35,3,99,99 ;hill 3
    !BYTE 32,6,4,99,99  ;hill 3

    !BYTE 20,17,4,99,3    ;hills 1
    !BYTE 20,27,4,4,3   ;hills 1
    !BYTE 21,31,4,99,3  ;hills 1 right
    !BYTE 20,33,4,1,3   ;hills 1
    !BYTE 21,34,4,99,3  ;hills 1 right

    !BYTE 19,35,3,5,3   ;sky clears right
    
    !BYTE 23,35,5,99,99 ;hills 2 high right
    !BYTE 24,38,6,99,99 ;hills 2 high left

    !BYTE 42,0,7,1,3    ;warp 1
    
    ;!BYTE 7, 16,18,99,99   ;column black   ;debug.... wall at ladder
    ;!BYTE 7, 17,10,99,3    ;column black   ;debug.... wall at ladder
    
    !BYTE 255; end of level 
    
screen_4:
    ; header structure
    !BYTE $62, $31,$51 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 3;target screen index
    !BYTE $a5, $bb ; x and y intially on target screen

    ;warp 2 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 11;target screen index
    !BYTE $12,$b4 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen4_actions_init
    !WORD screen4_actions

    ;spawn interval on this screen
    !BYTE 40

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 22, 29 + LAMP_SHIFT, 19   ;num, x, y
    !BYTE 23, 38, 19    ;num, x, y
    !BYTE 255

    ;spawn points
    !BYTE $98, $bb
    !BYTE 0, 0
    !BYTE 0, 0
    !BYTE 0, 0

    !BYTE 0, 0
    !BYTE 0, 0
    !BYTE 0, 0
    !BYTE 0, 0
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    !BYTE 19,0,2,40,4   ;sky
    !BYTE 32,35,2,99,99 ;hill 3
    !BYTE 23,6,4,99,3 ;hills 2 high right
    !BYTE 22,8,2,99,5 ;hills 2 high

    !BYTE 32,10,2,99,99 ;hill 3
    !BYTE 32,21,2,99,99 ;hill 3
    !BYTE 32,32,2,8,99  ;hill 3

    !BYTE 17,10,5,30,1  ;empty

    !BYTE 1,0,23,40,99  ;ground
    !BYTE 10,0,10,99,99 ;thin platform
    !BYTE 10,15,10,99,99  ;thin platform
    !BYTE 10,30,10,10,99  ;thin platform
    !BYTE 50,0,8,99,99  ;bastille small
    !BYTE 51,1,10,3,99  ;bastille wall
    ;!BYTE  51,1,11,3,99  ;bastille wall
    !BYTE 52,2,12,99,99 ;bastille window
    !BYTE 52,2,16,99,99 ;bastille window
    !BYTE 53,1,21,99,99 ;bastille column
    !BYTE 53,3,21,99,99 ;bastille column
    !BYTE 53,17,21,99,99  ;bastille column
    !BYTE 53,18,21,99,99  ;bastille column
    !BYTE 53,19,21,99,99  ;bastille column
    !BYTE 53,34,21,99,99  ;bastille column
    !BYTE 53,36,21,99,99  ;bastille column
    !BYTE 54,17,15,99,7 ;bastille grid
    !BYTE 54,17,13,99,2 ;bastille grid
    !BYTE 54,1,19,99,2  ;bastille grid
    !BYTE 54,34,19,99,2 ;bastille grid
    !BYTE 55,17,12,99,2 ;bastille grid top
    !BYTE 56,1,18,99,2  ;bastille grid top

    !BYTE 39,8,12,99,99 ;double column black
    !BYTE 39,16,12,99,99  ;double column black
    !BYTE 39,20,12,99,99  ;double column black
    !BYTE 39,28,12,99,99  ;double column black
    !BYTE 39,39,8,99,99 ;double column black
    !BYTE 39,39,12,99,99  ;double column black
    !BYTE 39,39,11,99,3 ;double column black
    !BYTE 39,39,15,99,3 ;double column black
    !BYTE 39,8,15,99,3  ;double column black
    !BYTE 39,16,15,99,3 ;double column black
    !BYTE 39,20,15,99,3 ;double column black
    !BYTE 39,28,15,99,3 ;double column black
    !BYTE 10,39,7,01,02 ;thin platform

    !BYTE 31,5,22,99,99 ;lid

    !BYTE 57,5,12,99,99 ;ladder top

    !BYTE 51,9,10,7,2 ;bastille wall
    !BYTE 51,21,10,7,2  ;bastille wall
    !BYTE 58,7,6,99,99  ;bastille big
    !BYTE 58,19,6,99,99 ;bastille big

    !BYTE 59,32,6,99,99 ;bastille big
    !BYTE 51,34,10,3,8  ;bastille wall
    !BYTE 52,35,12,99,99  ;bastille window
    !BYTE 52,35,16,99,99  ;bastille window
    !BYTE 54,34,19,99,2 ;bastille grid
    !BYTE 56,34,18,99,2 ;bastille grid top

    !BYTE 57,31,12,99,99  ;ladder top
    !BYTE 10,29,16,1,99 ;thin platform
    !BYTE 10,38,16,1,99 ;thin platform
    !BYTE 49,29,18,99,99  ;lamp hanger 2
    !BYTE 48,38,18,99,99  ;lamp hanger 1

    !BYTE 60,9,22,7,99  ;swords up
    !BYTE 60,21,22,7,99 ;swords up

    !BYTE 31,31,22,99,99  ;lid

    !BYTE 42,0,19,1,4   ;warp 1
    
    ;!BYTE 7, 16,18,99,99   ;column black   ;debug.... wall at ladder
    ;!BYTE 7, 17,10,99,3    ;column black   ;debug.... wall at ladder
    
    !BYTE 255; end of level 

screen_5:
    ; header structure
    !BYTE $62, $ae,$ae ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 7;target screen index
    !BYTE $a0, $48 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 6;target screen index
    !BYTE $12,$3d ; x and y intially on target screen

    ;warp 3 target
    !BYTE 6;target screen index
    !BYTE $12,$6b ; x and y intially on target screen

    ;warp 4 target
    !BYTE 2;target screen index
    !BYTE $5b,$58 ; x and y intially on target screen

    ;pointer to screen execution logic

    !WORD screen5_actions_init
    !WORD screen5_actions

    ;spawn interval on this screen
    !BYTE 19

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 24, 2 + LAMP_SHIFT, 5   ;num, x, y
    !BYTE 25, 6 + LAMP_SHIFT, 5   ;num, x, y
    !BYTE 26, 28 , 5    ;num, x, y
    !BYTE 27, 32 + LAMP_SHIFT, 5    ;num, x, y
    !BYTE 28, 38 , 5    ;num, x, y
    !BYTE 29, 30 , 11   ;num, x, y
    !BYTE 30, 2 + LAMP_SHIFT, 19    ;num, x, y
    !BYTE 31, 23 , 19   ;num, x, y
    !BYTE 32, 26 + LAMP_SHIFT, 19   ;num, x, y
    !BYTE 33, 30 , 19   ;num, x, y
    !BYTE 255

    ;spawn points
    !BYTE $26, $48
    !BYTE $26, $78
    !BYTE $30, $28
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    !BYTE 77,0,16,3,99    ;ceiling plant 4

    !BYTE 68,31,8,99,99   ;black column ceiling 3 down
    !BYTE 61,0,22,40,99 ;underground platform
    !BYTE 61,1,14,25,99 ;underground platform
    !BYTE 61,31,14,9,99 ;underground platform
    !BYTE 61,5,8,35,99  ;underground platform
    !BYTE 69,39,2,99,99   ;black column ceiling 3 down
    !BYTE 69,29,2,99,99   ;black column ceiling 3 down
    !BYTE 69,31,2,99,99   ;black column ceiling 3 down
    !BYTE 64,0,2,40,99  ;underground ceiling
    !BYTE 69,5,2,99,99    ;black column ceiling 3 down
    !BYTE 69,1,2,99,99    ;black column ceiling 3 down
    !BYTE 69,12,2,99,2    ;black column ceiling 3 down
    !BYTE 69,28,2,99,2    ;black column ceiling 3 down
    !BYTE 69,32,2,99,2    ;black column ceiling 3 down
    !BYTE 69,38,2,99,2    ;black column ceiling 3 down

    !BYTE 62,11,2,99,99 ;underground platform left end
    !BYTE 62,37,2,99,99 ;underground platform left end
    !BYTE 62,37,8,99,99 ;underground platform left end
    !BYTE 62,37,14,99,99  ;underground platform left end
    !BYTE 62,30,14,99,99  ;underground platform left end
    !BYTE 62,37,22,99,99  ;underground platform left end

    !BYTE 63,6,2,99,99  ;underground platform right end
    !BYTE 63,33,2,99,99 ;underground platform right end
    !BYTE 63,33,8,99,99 ;underground platform right end
    !BYTE 63,26,14,99,99  ;underground platform right end
    !BYTE 63,33,14,99,99  ;underground platform right end
    !BYTE 63,33,22,99,99  ;underground platform right end

    !BYTE 68,1,16,99,99   ;black column ceiling 3 down
    !BYTE 68,24,16,99,99    ;black column ceiling 3 down

    !BYTE 67,0,4,99,19  ; column black
    !BYTE 67,30,4,99,5  ; column black
    !BYTE 67,32,10,99,5 ; column black
    !BYTE 67,26,16,99,2 ; column black
    !BYTE 67,30,16,99,2 ; column black
    !BYTE 67,25,16,99,7 ; column black
    !BYTE 67,31,16,99,7 ; column black
    !BYTE 67,39,16,99,7 ; column black
    !BYTE 69,31,22,99,2   ;black column ceiling 3 down
    !BYTE 69,39,22,99,2   ;black column ceiling 3 down

    !BYTE 69,30,8,99,2    ;black column ceiling 3 down
    !BYTE 69,32,14,99,2   ;black column ceiling 3 down
    !BYTE 69,0,22,99,2    ;black column ceiling 3 down
    !BYTE 69,25,22,99,2   ;black column ceiling 3 down
    
    !BYTE 73,4,8,99,99    ;underground platform left 2
    
    !BYTE 17,7,2,4,2    ;empty
    !BYTE 65,34,2,99,22   ;conveyor

    !BYTE 74,15,4,99,99   ;ceiling plant 1
    !BYTE 74,15,10,99,99    ;ceiling plant 1
    !BYTE 74,15,16,99,99    ;ceiling plant 1
    !BYTE 76,19,10,99,99    ;ceiling plant 3
    !BYTE 76,11,10,99,99    ;ceiling plant 3
    !BYTE 77,10,16,99,99    ;ceiling plant 4
    !BYTE 77,21,16,3,99   ;ceiling plant 4
    !BYTE 77,19,16,3,99   ;ceiling plant 4

    !BYTE 70,13,2,99,99   ;underground door 1
    !BYTE 70,17,2,99,99   ;underground door 1
    !BYTE 71,13,9,99,99   ;underground door 2
    !BYTE 71,17,9,99,99   ;underground door 2
    !BYTE 72,13,15,99,99    ;underground door 2
    !BYTE 72,17,15,99,99    ;underground door 2

    !BYTE 74,6,10,99,99   ;ceiling plant 1
    !BYTE 74,3,4,2,99   ;ceiling plant 1
    !BYTE 75,20,4,99,99   ;ceiling plant 2
    !BYTE 74,24,4,99,99   ;ceiling plant 1
    !BYTE 74,12,4,1,1   ;ceiling plant 1
    !BYTE 74,39,10,1,1    ;ceiling plant 1
    !BYTE 76,25,10,99,99    ;ceiling plant 3
    !BYTE 77,3,16,99,99   ;ceiling plant 4
    
    !BYTE 49,2,4,99,99  ;lamp hanger 2
    !BYTE 49,6,4,99,99  ;lamp hanger 2

    !BYTE 49,32,4,99,99 ;lamp hanger 2
    !BYTE 49,2,18,99,99 ;lamp hanger 2
    !BYTE 49,26,18,99,99  ;lamp hanger 2
    
    !BYTE 48,28,4,99,99 ;lamp hanger 1
    !BYTE 48,38,4,99,99 ;lamp hanger 1
    !BYTE 48,30,10,99,99  ;lamp hanger 1
    !BYTE 48,23,18,99,99  ;lamp hanger 1
    !BYTE 48,30,18,99,99  ;lamp hanger 1

    !BYTE BLOCK_COLOR_OVERRIDE, $cc,0,0,0  ;conveyor color - from now, every block will use the given color
    !BYTE 78,34,2,3,99  ;swords down
    !BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    
    !BYTE 43,39,5,1,3   ;warp 2
    !BYTE 44,39,11,1,3    ;warp 3
    
    !BYTE 255; end of level 

screen_6:
    ; header structure
    !BYTE $62, $ae,$ae ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 5;target screen index
    !BYTE $a4, $47 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 5;target screen index
    !BYTE $a4,$77 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen6_actions_init
    !WORD screen6_actions

    ;spawn interval on this screen
    !BYTE 18

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 34, 8 , 9   ;num, x, y
    !BYTE 35, 10 + LAMP_SHIFT, 9    ;num, x, y
    !BYTE 36, 14 , 9    ;num, x, y
    !BYTE 37, 22 , 9    ;num, x, y
    !BYTE 38, 26 , 9    ;num, x, y
    !BYTE 39, 28 + LAMP_SHIFT, 9    ;num, x, y
    !BYTE 40, 6 , 17    ;num, x, y
    !BYTE 41, 30 + LAMP_SHIFT,17    ;num, x, y

    !BYTE 255

    ;spawn points
    !BYTE $2f, $6a
    !BYTE $7d, $6a
    !BYTE $8c, $ab
    !BYTE $40, $ab
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    !BYTE 77,0,2,5,99   ;ceiling plant 4
    !BYTE 76,4,2,99,99    ;ceiling plant 3
    !BYTE 74,9,2,99,99    ;ceiling plant 1
    !BYTE 76,19,2,99,99   ;ceiling plant 3
    !BYTE 77,14,2,99,99   ;ceiling plant 4
    !BYTE 77,12,2,99,99   ;ceiling plant 4
    !BYTE 74,20,2,99,99   ;ceiling plant 1
    !BYTE 76,24,2,99,99   ;ceiling plant 3
    !BYTE 75,29,2,99,99   ;ceiling plant 2
    !BYTE 74,32,2,3,99    ;ceiling plant 4

    !BYTE 80,39,2,1,22    ;black wall
    !BYTE 81,0,22,99,99   ;black ground
    !BYTE 82,0,14,2,99    ;black block
    !BYTE 82,0,18,2,99    ;black block
    !BYTE 83,2,14,3,99    ;ladder 6
    !BYTE 83,2,18,3,99    ;ladder 6

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ;conveyor color - from now, every block will use the given color
    !BYTE 1,5,21,30,99    ;ground
    !BYTE 1,0,13,5,99   ;ground
    !BYTE 3,6,12,99,99  ;platform
    !BYTE 3,16,12,99,99 ;platform
    !BYTE 2,5,12,99,99  ;platform end left
    !BYTE 8,30,12,99,99 ;platform end right
    !BYTE 3,9,4,99,99 ;platform
    !BYTE 3,19,4,9,99 ;platform
    !BYTE 2,7,4,99,99 ;platform end left
    !BYTE 8,28,4,99,99  ;platform end right

    !BYTE 4, 8,16,99,99  ;column white
    !BYTE 4, 28,16,99,99  ;column white
    !BYTE 4, 8,14,99,99  ;column white
    !BYTE 4, 28,14,99,99  ;column white
    !BYTE 35,8,18,1,2  ;column white tall middle 
    !BYTE 35,28,18,1,2  ;column white tall middle 

    !BYTE 4, 11,8,99,5  ;column white
    !BYTE 4, 18,8,99,5  ;column white
    !BYTE 4, 25,8,99,5  ;column white
    !BYTE 4, 11,6,99,99  ;column white
    !BYTE 4, 18,6,99,99  ;column white
    !BYTE 4, 25,6,99,99  ;column white
    !BYTE 35,11,8,1,4  ;column white tall middle 
    !BYTE 35,18,8,1,4  ;column white tall middle 

    !BYTE 35,25,8,1,4  ;column white tall middle 

    !BYTE 18,14,6,99,99 ;spike down
    !BYTE 18,22,6,99,99 ;spike down

    !BYTE 84,8,6,99,99  ;platform end 2 left
    !BYTE 85,26,6,99,99 ;platform end 2 right
    !BYTE 86,10,14,99,99  ;underground door 4
    !BYTE 86,23,14,99,99  ;underground door 4

    !BYTE 87,6,14,99,99 ;lamp hanger 3 left
    !BYTE 88,30,14,99,99  ;lamp hanger 3 right

    !BYTE 7, 1,8,99,99  ;column
    !BYTE 89, 0,7,2,99  ;thin metal platform
    
    !BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
  
    !BYTE 79,35,2,99,22   ;conveyor wide
    
    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ;black color - from now, every block will use the given color
    !BYTE 78,35,2,4,99  ;swords down
    !BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    
    
    !BYTE 42,0,4,1,3    ;warp 1
    !BYTE 43,0,10,1,3   ;warp 2
    
    !BYTE 255; end of level 



screen_7:
    ; header structure
    !BYTE $62, $ae,$ae ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 8;target screen index
    !BYTE $24, $28 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 5;target screen index
    !BYTE $12,$b8 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen7_actions_init
    !WORD screen7_actions

    ;spawn interval on this screen
    !BYTE 17

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 42, 11 + LAMP_SHIFT, 7    ;num, x, y
    !BYTE 43, 28 , 7    ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $80, $a8
    !BYTE $90, $a8
    !BYTE $a0, $48
    !BYTE $a0, $48
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    ;!BYTE 80,39,2,1,22   ;black wall
    !BYTE 81,6,22,34,99   ;black ground
    !BYTE 90,0,2,17,99    ;underground ceiling 2
    !BYTE 90,24,2,15,99   ;underground ceiling 2
    
    !BYTE 89, 5,9,1,99  ;thin metal platform
    !BYTE 89, 14,9,4,99  ;thin metal platform
    !BYTE 89, 22,9,4,99  ;thin metal platform
    !BYTE 89, 34,9,1,99  ;thin metal platform
    !BYTE 89, 39,9,1,99  ;thin metal platform
    !BYTE 89, 11,15,4,99  ;thin metal platform
    !BYTE 89, 25,15,4,99  ;thin metal platform

    !BYTE 74,24,4,2,99    ;ceiling plant 4
    !BYTE 77,26,4,99,99   ;ceiling plant 2
    
    !BYTE 67,0,4,99,20  ; column black
    !BYTE 67,10,4,99,13 ; column black
    !BYTE 67,29,4,99,13 ; column black
    !BYTE 67,39,10,99,10  ; column black
    !BYTE 67,15,10,99,10  ; column black
    !BYTE 67,5,10,99,14 ; column black
    !BYTE 67,34,10,99,6 ; column black
    !BYTE 67,24,10,99,6 ; column black
    !BYTE 67,14,10,99,2 ; column black
    !BYTE 67,16,10,99,2 ; column black
    !BYTE 67,23,10,99,2 ; column black
    !BYTE 67,25,10,99,2 ; column black

    !BYTE 74,10,16,99,99    ;ceiling plant 1
    !BYTE 77,12,16,3,99   ;ceiling plant 4
    !BYTE 74,24,16,99,99    ;ceiling plant 1
    !BYTE 75,27,16,3,99   ;ceiling plant 2
    !BYTE 75,34,16,1,99   ;ceiling plant 2
    !BYTE 91,1,4,99,99    ;corner plant upper left
    !BYTE 91,30,4,99,99   ;corner plant upper left
    !BYTE 91,11,4,5,99    ;corner plant upper left
    !BYTE 76,36,4,4,99    ;ceiling plant 3

    !BYTE 91,9,4,1,99     ;corner plant upper left
    !BYTE 91,14,12,1,99     ;corner plant upper left
    !BYTE 91,25,12,1,99     ;corner plant upper left

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color
    !BYTE 1,6,21,34,99    ;ground
    !BYTE 7, 15,16,99,99  ;column
    !BYTE 7, 39,16,99,99  ;column
    !BYTE 67,15,14,99,5 ; column black
    !BYTE 67,39,14,99,5 ; column black
    
    !BYTE BLOCK_COLOR_OVERRIDE, $cc,0,0,0  ; from now, every block will use the given color

    !BYTE 15,7,4,2,99 ;ladder top
    !BYTE 15,7,9,2,99 ;ladder top
    !BYTE 15,7,14,2,2 ;ladder top
    !BYTE 16,7,16,2,2 ;ladder bottom

    !BYTE 15,31,4,2,99  ;ladder top
    !BYTE 15,31,9,2,99  ;ladder top
    !BYTE 15,31,14,2,2  ;ladder top
    !BYTE 16,31,16,2,2  ;ladder bottom
    
    !BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
  
    !BYTE 81,15,10,1,2    ;black ground
    !BYTE 81,24,10,1,2    ;black ground

    !BYTE 79,18,2,99,22   ;conveyor wide
    
    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ;black color - from now, every block will use the given color
    !BYTE 78,16,2,2,99  ;swords down
    !BYTE 78,22,2,2,99  ;swords down
    !BYTE 78,17,10,1,99 ;swords down
    !BYTE 78,22,10,1,99 ;swords down
    !BYTE 78,16,12,1,99 ;swords down
    !BYTE 78,23,12,1,99 ;swords down

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color
    !BYTE 60,18,22,4,99 ;swords up
    !BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    
    !BYTE 42,1,23,4,1   ;warp 1
    !BYTE 43,39,6,1,3   ;warp 2

    !BYTE 92,0,2,99,99    ;underground level corner
    !BYTE 92,39,2,99,99   ;underground level corner

    !BYTE 93,1,10,99,99   ;underground door 6
    !BYTE 93,35,10,99,99    ;underground door 6
    
    !BYTE 49,11,6,99,99 ;lamp hanger 2
    !BYTE 48,28,6,99,99 ;lamp hanger 1
    
    !BYTE 255; end of level 

screen_8:

    ; header structure
    !BYTE $62, $b8,$b8 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 9;target screen index
    !BYTE $14, $3d ; x and y intially on target screen

    ;warp 2 target
    !BYTE 9;target screen index
    !BYTE $18,$b8 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 50,50 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 7;target screen index
    !BYTE $23,$48 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen8_actions_init
    !WORD screen8_actions

    ;spawn interval on this screen
    !BYTE 16

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 44, 3 + LAMP_SHIFT, 3   ;num, x, y
    !BYTE 45, 12 , 3    ;num, x, y
    !BYTE 46, 13 + LAMP_SHIFT, 3    ;num, x, y
    !BYTE 47, 25 , 3    ;num, x, y
    !BYTE 48, 26 + LAMP_SHIFT, 3    ;num, x, y
    !BYTE 49, 5 , 9   ;num, x, y
    !BYTE 50, 6 + LAMP_SHIFT, 9   ;num, x, y
    !BYTE 51, 12 , 9    ;num, x, y
    !BYTE 52, 13 + LAMP_SHIFT, 9    ;num, x, y
    !BYTE 53, 25 , 9    ;num, x, y
    !BYTE 54, 26 + LAMP_SHIFT, 9    ;num, x, y
    !BYTE 55, 2 , 17    ;num, x, y
    !BYTE 56, 3 + LAMP_SHIFT, 17    ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $1c, $28
    !BYTE $5c, $38
    !BYTE $94, $68
    !BYTE $20, $68
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    ;!BYTE 80,39,2,1,22   ;black wall
    !BYTE BLOCK_COLOR_OVERRIDE, $af,0,0,0  ; from now, every block will use the given color

    !BYTE 96,8,2,30,99    ;platform bottom only
    !BYTE 96,2,8,32,99    ;platform bottom only

    !BYTE 77,32,2,99,99   ;ceiling plant 4

    !BYTE 1,0,13,40,99    ;ground
    !BYTE 81,0,14,40,99   ;black ground

    !BYTE 1,2,7,32,99   ;ground
    !BYTE 80,0,15,1,8   ;black wall
    !BYTE 94,2,2,99,99  ;double lamp hangers
    !BYTE 7, 33,2,99,99  ;column

    !BYTE 89, 0,7,1,99  ;thin metal platform
    !BYTE 89, 39,7,1,99  ;thin metal platform

    !BYTE 89, 1,21,8,99  ;thin metal platform
    !BYTE 89, 32,21,8,99  ;thin metal platform

    !BYTE 7, 1,8,99,99  ;column

    !BYTE 81,0,22,40,99   ;black ground
    !BYTE 67,0,2,99,6 ; column black
    !BYTE 7, 38,8,99,99  ;column
    !BYTE 67, 33,2,99,3  ;column black

    !BYTE 67,39,2,99,6  ; column black
    !BYTE 67,38,2,99,8  ; column black
    !BYTE 67,1,2,99,8 ; column black
    !BYTE 91,2,2,1,99     ;corner plant upper left
    !BYTE 91,2,2,1,99     ;corner plant upper left
    !BYTE 91,2,8,99,99      ;corner plant upper left
    !BYTE 91,1,16,99,99     ;corner plant upper left
    !BYTE 74,24,16,99,99    ;ceiling plant 1
    !BYTE 75,27,16,99,99    ;ceiling plant 2
    !BYTE 75,15,16,99,99    ;ceiling plant 2
    !BYTE 76,10,16,99,99    ;ceiling plant 3
    
    !BYTE 74,25,2,99,99   ;ceiling plant 1
    !BYTE 75,28,2,99,99   ;ceiling plant 2
    !BYTE 75,22,2,99,99   ;ceiling plant 2
    !BYTE 76,9,2,99,99    ;ceiling plant 3
    !BYTE 75,13,2,99,99   ;ceiling plant 2

    !BYTE 76,9,8,99,99    ;ceiling plant 3
    !BYTE 75,14,8,99,99   ;ceiling plant 2
    !BYTE 74,18,8,99,99   ;ceiling plant 1
    !BYTE 76,22,8,99,99   ;ceiling plant 3
    !BYTE 75,27,8,99,99   ;ceiling plant 2
    !BYTE 76,28,8,99,99   ;ceiling plant 3
    !BYTE 97,20,16,99,99    ;ceiling plant 5
    !BYTE 97,32,16,8,99   ;ceiling plant 5
    
    !BYTE 31,2,20,99,99 ;lid
    !BYTE 95,8,8,99,99  ;underground door 6
    !BYTE 95,28,8,99,99 ;underground door 6

    !BYTE 95,18,2,99,99 ;underground door 6
    !BYTE 95,16,2,99,99 ;underground door 6
    !BYTE 95,20,2,99,99 ;underground door 6
    
    !BYTE 42,39,9,1,4   ;warp 1
    !BYTE 43,39,17,1,4    ;warp 2
    !BYTE 44,0,9,1,4    ;warp 3
    !BYTE 45,4,2,4,1    ;warp 4
    
    !BYTE 94,12,2,99,99 ;double lamp hangers
    !BYTE 94,25,2,99,99 ;double lamp hangers
    !BYTE 94,5,8,99,99  ;double lamp hangers
    !BYTE 94,12,8,99,99 ;double lamp hangers
    !BYTE 94,25,8,99,99 ;double lamp hangers
    !BYTE 94,2,16,99,99 ;double lamp hangers

    !BYTE 98,5,20,31,99 ;zapper

    !BYTE 255; end of level 

screen_9:
    ; header structure
    !BYTE $62, $b8,$b8 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 10;target screen index
    !BYTE $12, $4d ; x and y intially on target screen

    ;warp 2 target
    !BYTE 10;target screen index
    !BYTE $12, $bd ; x and y intially on target screen

    ;warp 3 target
    !BYTE 8;target screen index
    !BYTE $a5,$6b ; x and y intially on target screen

    ;warp 4 target
    !BYTE 8;target screen index
    !BYTE $a5,$ad ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen9_actions_init
    !WORD screen9_actions

    ;spawn interval on this screen
    !BYTE 255

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 57, 15 , 5    ;num, x, y
    !BYTE 58, 24 , 5    ;num, x, y
    !BYTE 59, 6 + LAMP_SHIFT, 13    ;num, x, y
    !BYTE 60, 33 ,13    ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE 255
    
    ;blocks

    ;!BYTE 80,39,2,1,22   ;black wall

    !BYTE BLOCK_COLOR_OVERRIDE, $af,0,0,0  ; from now, every block will use the given color
    !BYTE 97,3,2,99,99    ;ceiling plant 5
    !BYTE 74,0,2,3,99   ;ceiling plant 1
    !BYTE 97,27,2,8,99    ;ceiling plant 5
    !BYTE 74,35,2,99,99   ;ceiling plant 1
    !BYTE 75,38,2,2,99    ;ceiling plant 2

    !BYTE BLOCK_COLOR_OVERRIDE, $9f,0,0,0  ; from now, every block will use the given color

    !BYTE 89, 0,7,6,99  ;thin metal platform
    !BYTE 89, 34,7,6,99  ;thin metal platform
    !BYTE 89, 34,7,6,99  ;thin metal platform
    !BYTE 89, 14,9,99,99  ;thin metal platform
    !BYTE 89, 18,9,99,99  ;thin metal platform
    !BYTE 89, 6,11,1,99  ;thin metal platform
    !BYTE 89, 33,11,1,99  ;thin metal platform
    !BYTE 49, 6,12,99,99  ;lamp hanger 2
    !BYTE 48, 33,12,99,99 ;lamp hanger 1
    
    !BYTE 64,0,22,40,99 ;;underground ceiling
    !BYTE 64,11,16,5,99 ;;underground ceiling
    !BYTE 64,24,16,5,99 ;;underground ceiling

    !BYTE 60,9,22,2,99  ;swords up
    !BYTE 60,17,22,3,99 ;swords up
    !BYTE 60,20,22,3,99 ;swords up
    !BYTE 60,29,22,2,99 ;swords up

    !BYTE 62,5,22,99,99 ;underground platform left end
    !BYTE 63,8,22,99,99 ;underground platform right end
    !BYTE 62,11,22,99,99  ;underground platform left end
    !BYTE 63,16,22,99,99  ;underground platform right end
    !BYTE 62,23,22,99,99  ;underground platform left end
    !BYTE 63,28,22,99,99  ;underground platform right end
    !BYTE 62,31,22,99,99  ;underground platform left end
    !BYTE 63,34,22,99,99  ;underground platform right end
    !BYTE 62,11,16,99,99  ;underground platform left end
    !BYTE 63,15,16,99,99  ;underground platform right end
    !BYTE 62,24,16,99,99  ;underground platform left end
    !BYTE 63,28,16,99,99  ;underground platform right end

    !BYTE 91,15,10,1,99     ;corner plant upper left
  
    !BYTE 77,24,10,1,99   ;ceiling plant 4
    !BYTE 91,14,2,1,99      ;corner plant upper left
    !BYTE 77,25,2,1,99    ;ceiling plant 4
    
    !BYTE 78,16,10,1,99 ;swords down
    !BYTE 78,23,10,1,99 ;swords down
    
    !BYTE 18,15,2,99,99 ;spike down
    !BYTE 18,24,2,99,99 ;spike down
    
    !BYTE 67, 38,2,99,6  ;column black
    
    !BYTE 69,1,22,99,2    ;black column ceiling 3 down
    !BYTE 69,38,22,99,2   ;black column ceiling 3 down
    !BYTE 69,14,16,99,2   ;black column ceiling 3 down
    !BYTE 69,25,16,99,2   ;black column ceiling 3 down
    !BYTE 67,1,18,99,4  ; column black
    !BYTE 67,38,18,99,4 ; column black
    !BYTE 67,14,10,99,6 ; column black
    !BYTE 67,25,10,99,6 ; column black
    ;!BYTE 67,38,2,99,2 ; column black
    
    !BYTE 80,1,8,1,8    ;black wall
    !BYTE 80,38,8,1,8   ;black wall
    
    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ; from now, every block will use the given color
    
    !BYTE 99, 12,18,99,4  ;wall conveyor
    !BYTE 99, 25,18,99,4  ;wall conveyor
    !BYTE 102, 13,22,99,2  ;wall conveyor middle
    !BYTE 102, 26,22,99,2  ;wall conveyor middle
    !BYTE 102, 0,8,99,8  ;wall conveyor middle
    !BYTE 102, 5,8,99,8  ;wall conveyor middle
    !BYTE 102, 39,8,99,8  ;wall conveyor middle
    !BYTE 102, 34,8,99,8  ;wall conveyor middle

    !BYTE 100, 13,2,99,10  ;wall conveyor left
    !BYTE 101, 26,2,99,10  ;wall conveyor right
    !BYTE 100, 0,16,99,2  ;wall conveyor left
    !BYTE 102, 1,16,99,2  ;wall conveyor middle
    !BYTE 101, 39,16,99,2  ;wall conveyor right
    !BYTE 102, 38,16,99,2  ;wall conveyor middle
    
    !BYTE 42,39,3,1,4   ;warp 1
    !BYTE 43,39,18,1,4    ;warp 2
    !BYTE 44,0,3,1,4    ;warp 3
    !BYTE 45,0,18,1,4   ;warp 4

    !BYTE BLOCK_COLOR_OVERRIDE, $1a,0,0,0  ; from now, every block will use the given color

    !BYTE 65,17,2,99,20   ;conveyor
    !BYTE 65,20,2,99,20   ;conveyor
    !BYTE 65,2,8,99,16    ;conveyor
    !BYTE 65,35,8,99,16   ;conveyor

    !BYTE 255; end of level 

screen_10:
    ; header structure
    !BYTE $62, $b8,$b8 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 6;target screen index
    !BYTE $a0, $be ; x and y intially on target screen

    ;warp 2 target
    !BYTE 0;target screen index
    !BYTE 0,50 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 9;target screen index
    !BYTE $a5,$3d ; x and y intially on target screen

    ;warp 4 target
    !BYTE 9;target screen index
    !BYTE $a0,$b8 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen10_actions_init
    !WORD screen10_actions

    ;spawn interval on this screen
    !BYTE 255

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 61, 15 + LAMP_SHIFT , 13    ;num, x, y
    !BYTE 62, 32 , 3    ;num, x, y
    !BYTE 63, 27 + LAMP_SHIFT , 19    ;num, x, y
    !BYTE 64, 28 , 19   ;num, x, y
    !BYTE 65, 32 + LAMP_SHIFT, 19   ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE $0, $0
    !BYTE 255
    
    ;blocks

    ;!BYTE 80,39,2,1,22   ;black wall

    !BYTE BLOCK_COLOR_OVERRIDE, $9f,0,0,0  ; from now, every block will use the given color

    !BYTE 89, 0,23,8,1  ;thin metal platform
    !BYTE 89, 10,5,6,1  ;thin metal platform
    !BYTE 89, 29,5,6,1  ;thin metal platform
    !BYTE 89, 0,17,3,99  ;thin metal platform
    !BYTE 67,0,10,99,2  ; column black
    !BYTE 67,1,10,99,2  ; column black
    !BYTE 67,2,10,99,8  ; column black

    !BYTE 76,0,2,99,99      ;corner plant 3
    !BYTE 91,23,2,5,99      ;corner plant upper left
    !BYTE 97,5,2,4,99   ;ceiling plant 5
    !BYTE 91,21,2,1,99      ;corner plant upper left
    !BYTE 97,20,2,1,99    ;ceiling plant 5

    !BYTE 97,3,18,99,99     ;ceiling plant 5
    !BYTE 74,13,18,3,99     ;ceiling plant 5
    !BYTE 97,21,18,6,99     ;ceiling plant 5

    !BYTE 89, 0,9,3,1  ;thin metal platform
    !BYTE 89, 31,23,8,1  ;thin metal platform
    !BYTE 89, 23,23,8,1  ;thin metal platform
    !BYTE 89, 15,23,8,1  ;thin metal platform

    !BYTE 98,4,22,21,99 ;zapper
    !BYTE 31,27,22,99,99  ;lid
    !BYTE 31,32,22,99,99  ;lid

    !BYTE 89, 14,11,1,99  ;thin metal platform
    !BYTE 89, 12,13,1,99  ;thin metal platform
    
    !BYTE 49, 15,12,99,99 ;lamp hanger 2
    !BYTE 49, 27,18,99,99 ;lamp hanger 2
    !BYTE 49, 32,18,99,99 ;lamp hanger 2

    !BYTE 48, 28,18,99,99 ;lamp hanger 1
    !BYTE 48, 32,2,99,99  ;lamp hanger 1
    !BYTE 7, 33,2,1,1 
    
    !BYTE 64,22,16,11,99  ;;underground ceiling
    !BYTE 64,10,16,6,99 ;;underground ceiling
    ;!BYTE  64,24,16,5,99 ;;underground ceiling

    !BYTE 60,8,14,1,99  ;swords up
    !BYTE 60,9,12,2,99  ;swords up
    !BYTE 60,11,10,2,99 ;swords up
    !BYTE 60,13,8,3,99  ;swords up

    !BYTE 62,21,16,99,99  ;underground platform left end
    !BYTE 63,16,16,99,99  ;underground platform right end
    !BYTE 63,33,16,99,99  ;underground platform right end
    
    !BYTE 69,10,16,1,2    ;black column ceiling 3 down
    
    !BYTE 69,23,16,1,2    ;black column ceiling 3 down
    !BYTE 67,23,10,99,6 ; column black 

    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ; from now, every block will use the given color

    !BYTE 78,34,10,1,99 ;swords down
    
    !BYTE 99, 29,18,3,2  ;wall conveyor
    !BYTE 102, 39,2,99,10  ;wall conveyor middle
    !BYTE 102, 39,12,99,10  ;wall conveyor middle
    !BYTE 102, 39,22,99,2  ;wall conveyor middle
    !BYTE 102, 34,2,99,8  ;wall conveyor middle
    !BYTE 102, 22,2,99,10  ;wall conveyor middle
    !BYTE 102, 0,12,99,6  ;wall conveyor middle
    !BYTE 102, 1,12,99,6  ;wall conveyor middle
    !BYTE 102, 30,20,99,4  ;wall conveyor middle
    
    !BYTE 102, 15,10,99,2  ;wall conveyor middle
    !BYTE 102, 14,10,99,2  ;wall conveyor middle
    !BYTE 102, 13,10,99,4  ;wall conveyor middle
    !BYTE 102, 12,12,99,2  ;wall conveyor middle
    !BYTE 102, 11,12,99,4  ;wall conveyor middle
    !BYTE 102, 10,14,99,2  ;wall conveyor middle
    !BYTE 102, 9,14,99,4  ;wall conveyor middle
    !BYTE 102, 8,16,99,2  ;wall conveyor middle
    !BYTE 60,3,16,5,99    ;swords up
    !BYTE 60,24,16,4,99   ;swords up
    !BYTE 69,28,16,1,2  ; column black------
    
    ;!BYTE 42,39,3,1,4    ;warp 1
    ;!BYTE 43,39,18,1,4   ;warp 2
    !BYTE 44,0,5,1,4    ;warp 3
    !BYTE 45,0,19,1,4   ;warp 4

    !BYTE BLOCK_COLOR_OVERRIDE, $1a,0,0,0  
  
    !BYTE 79,35,2,99,22   ;conveyor wide
    !BYTE 78,35,2,4,99  ;swords down
  
    !BYTE 79,11,6,99,2    ;conveyor wide
    !BYTE 79,9,6,2,2    ;conveyor wide
    !BYTE 79,9,8,99,2   ;conveyor wide
    !BYTE 79,7,8,2,2    ;conveyor wide
    !BYTE 79,7,10,99,2    ;conveyor wide
    !BYTE 79,5,10,2,2   ;conveyor wide
    !BYTE 79,5,12,99,2    ;conveyor wide
    !BYTE 79,4,12,99,2    ;conveyor wide
    !BYTE 79,3,14,99,2    ;conveyor wide
    !BYTE 79,4,14,99,2    ;conveyor wide

    !BYTE 79,25,12,99,4   ;conveyor wide
    !BYTE 79,24,12,99,4   ;conveyor wide

    !BYTE 79,27,10,99,2   ;conveyor wide
    !BYTE 79,26,10,99,2   ;conveyor wide
    !BYTE 79,25,10,2,2    ;conveyor wide

    !BYTE 79,29,8,99,2    ;conveyor wide
    !BYTE 79,28,8,99,2    ;conveyor wide
    !BYTE 79,27,8,2,2   ;conveyor wide

    !BYTE 79,30,6,99,2    ;conveyor wide
    !BYTE 79,29,6,2,2   ;conveyor wide

    !BYTE BLOCK_COLOR_OVERRIDE, $9f,0,0,0  ; from now, every block will use the given color

    !BYTE 60,28,14,1,99 ;swords up
    
    !BYTE 255; end of level 

screen_11:
    ; header structure
    !BYTE $22, $8e,$41 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 12;target screen index
    !BYTE $12, $b5 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 4;target screen index
    !BYTE $84,$b4 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen11_actions_init
    !WORD screen11_actions

    ;spawn interval on this screen
    !BYTE 13

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 66, 1  , 7    ;num, x, y
    !BYTE 67, 30  , 13    ;num, x, y
    !BYTE 68, 30  , 19    ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $4a, $54
    !BYTE $7a, $54
    !BYTE $4a, $84
    !BYTE $7a, $84
    !BYTE 255
    
    ;blocks

    !BYTE 111,1,5,38,99   ;underground brick line

    !BYTE 105,5,4,99,10   ;yinyang
    !BYTE 105,33,4,99,10    ;yinyang
    ;!BYTE 113,0,3,40,99    ;underground ceiling thin
    !BYTE 114,0,3,40,99   ;underground ceiling deco

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color

    !BYTE 103,0,22,40,99    ;underground platform 2
    !BYTE 103,1,16,38,99    ;underground platform 2
    !BYTE 103,5,10,35,99    ;underground platform 2
    !BYTE 104,39,12,99,11   ;underground wall 2
    !BYTE 104,0,4,99,12   ;underground wall 2
    !BYTE 104,0,16,99,2   ;underground wall 2
    !BYTE 104,38,6,99,4   ;underground wall 2

    !BYTE 107,13,18,99,99   ;underground door 10
    !BYTE 107,13,12,99,99   ;underground door 10

    !BYTE 107,25,18,99,99   ;underground door 10
    !BYTE 107,25,12,99,99   ;underground door 10
    !BYTE 107,1,18,99,99    ;underground door 10

    !BYTE 107,5,6,2,99    ;underground door 10
    !BYTE 107,9,6,2,99    ;underground door 10
    !BYTE 107,13,6,2,99   ;underground door 10
    !BYTE 107,29,6,2,99   ;underground door 10
    !BYTE 107,33,6,2,99   ;underground door 10
    !BYTE 107,37,6,1,99   ;underground door 10
    !BYTE 107,5,12,2,99   ;underground door 10
    !BYTE 107,38,12,1,99    ;underground door 10
    !BYTE 107,38,18,1,99    ;underground door 10

    !BYTE 108,39,6,1,99   ;underground door shadow
    !BYTE 108,0,18,1,99   ;underground door shadow

    !BYTE 109,7,10,8,99   ;underground platform shadow
    !BYTE 109,31,10,8,99    ;underground platform shadow

    !BYTE 110,3,4,99,99   ;underground brick 1
    !BYTE 110,7,4,99,99   ;underground brick 1
    !BYTE 110,11,4,99,99    ;underground brick 1
    !BYTE 110,15,4,99,99    ;underground brick 1
    !BYTE 110,19,4,99,99    ;underground brick 1
    !BYTE 110,23,4,99,99    ;underground brick 1
    !BYTE 110,27,4,99,99    ;underground brick 1
    !BYTE 110,31,4,99,99    ;underground brick 1
    !BYTE 110,35,4,99,99    ;underground brick 1

    !BYTE 112,15,6,99,99    ;underground brick 2
    !BYTE 112,19,6,99,99    ;underground brick 2
    !BYTE 112,23,6,99,99    ;underground brick 2
    !BYTE 112,27,6,99,99    ;underground brick 2

    ;!BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    !BYTE BLOCK_COLOR_OVERRIDE, $a9,0,0,0  ; from now, every block will use the given color
    !BYTE 106,8,11,3,2    ;underground ladder
    !BYTE 106,8,17,3,2    ;underground ladder

    !BYTE 120,1,6,1,1   ;underground lamp hanger
    !BYTE 120,30,12,1,1   ;underground lamp hanger
    !BYTE 120,30,18,1,1   ;underground lamp hanger
    
    !BYTE 89, 37,5,3,1  ;thin metal platform
    !BYTE 42,39,6,1,4   ;warp 1
    ;!BYTE 43,39,18,1,4   ;warp 2
    
    !BYTE 255; end of level 

screen_12:
    ; header structure
    !BYTE $55, $c4,$c4 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 13;target screen index
    !BYTE $14,$55 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 14;target screen index
    !BYTE $14,$55 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 15;target screen index
    !BYTE $1c,$55; x and y intially on target screen

    ;warp 4 target
    !BYTE 11;target screen index
    !BYTE $a5,$55 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen12_actions_init
    !WORD screen12_actions

    ;spawn interval on this screen
    !BYTE 13

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 69, 7  , 19   ;num, x, y
    !BYTE 70, 18 + LAMP_SHIFT , 5   ;num, x, y
    !BYTE 71, 21  , 5   ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $5c, $45
    !BYTE $7f, $b5

    !BYTE $5b, $b5
    !BYTE $38, $b5
    !BYTE 255
    
    ;blocks

    !BYTE 103,0,22,40,99    ;underground platform 2
    !BYTE 103,6,8,28,99   ;underground platform 2
    !BYTE 108,0,18,3,5  ;underground door shadow
    !BYTE 116,2,2,99,14   ;underground wall 3
    !BYTE 116,6,9,99,15   ;underground wall 3
    !BYTE 116,33,9,99,7   ;underground wall 3
    !BYTE 116,37,2,99,99    ;underground wall 3
    
    !BYTE 117,0,4,2,6   ;underground grid
    !BYTE 117,0,10,2,6    ;underground grid
    !BYTE 117,38,4,2,6    ;underground grid
    !BYTE 117,38,10,2,6   ;underground grid
    !BYTE 117,38,16,2,6   ;underground grid
    !BYTE 117,38,22,2,2   ;underground grid

    !BYTE 117,7,10,6,6    ;underground grid
    !BYTE 117,13,10,6,6   ;underground grid
    !BYTE 117,19,10,6,6   ;underground grid
    !BYTE 117,25,10,6,6   ;underground grid
    !BYTE 117,31,10,2,6   ;underground grid

    !BYTE 119,9,10,4,6    ;underground gray block
    !BYTE 119,18,10,4,6   ;underground gray block
    !BYTE 119,27,10,4,6   ;underground gray block
    !BYTE 119,8,12,6,2    ;underground gray block
    !BYTE 119,17,12,6,2   ;underground gray block
    !BYTE 119,26,12,6,2   ;underground gray block

    !BYTE 118,3,2,3,99    ;ladder 6
    !BYTE 118,9,16,4,2    ;ladder 6
    !BYTE 118,18,16,4,2   ;ladder 6
    !BYTE 118,27,16,4,2   ;ladder 6
    
    !BYTE 118,10,18,2,1   ;ladder 6
    !BYTE 118,19,18,2,1   ;ladder 6
    !BYTE 118,28,18,2,1   ;ladder 6

    !BYTE 120,7,18,1,1    ;underground lamp hanger
    !BYTE 115,18,4,1,1    ;underground lamp hanger
    !BYTE 120,21,4,1,1    ;underground lamp hanger

    !BYTE 105,0,2,99,10   ;yinyang
    !BYTE 105,38,2,99,10    ;yinyang
    
    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ;black color - from now, every block will use the given color
    !BYTE 78,0,16,3,99  ;swords down
    !BYTE 78,7,16,2,99  ;swords down
    !BYTE 78,13,16,5,99 ;swords down
    !BYTE 78,22,16,5,99 ;swords down
    !BYTE 78,31,16,3,99 ;swords down
    !BYTE 78,6,2,12,99  ;swords down
    !BYTE 78,18,2,12,99 ;swords down
    !BYTE 78,30,2,7,99  ;swords down

    !BYTE 107,19,2,2,4    ;underground door 10

    !BYTE 42,9,14,4,1   ;warp 1
    !BYTE 43,18,14,4,1    ;warp 2
    !BYTE 44,27,14,4,1    ;warp 3
    !BYTE 45,0,18,1,4   ;warp 4
    
    !BYTE 255; end of level 

screen_13:
    ; header structure
    !BYTE $22, $8e,$41 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 12;target screen index
    !BYTE $38,$b5 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 14;target screen index
    !BYTE $12,$b5 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 16;target screen index
    !BYTE $a0,$20 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen13_actions_init
    !WORD screen13_actions

    ;spawn interval on this screen
    !BYTE 13

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 72, 36 + LAMP_SHIFT , 7   ;num, x, y
    !BYTE 73, 36  + LAMP_SHIFT , 13   ;num, x, y
    !BYTE 74, 36 + LAMP_SHIFT  , 19 ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $36, $54
    !BYTE $76, $54
    !BYTE $36, $84
    ;!BYTE  $76, $84
    !BYTE $36, $b4
    !BYTE $76, $b4
    !BYTE 255

    ;blocks

    !BYTE 105,9,4,99,10   ;yinyang
    !BYTE 105,13,4,99,10    ;yinyang
    !BYTE 105,17,4,99,10    ;yinyang
    !BYTE 105,21,4,99,10    ;yinyang
    !BYTE 105,25,4,99,10    ;yinyang
    !BYTE 105,29,4,99,10    ;yinyang
    
    !BYTE 113,0,3,40,99   ;underground ceiling thin
    !BYTE 114,0,3,40,99   ;underground ceiling deco
    !BYTE BLOCK_COLOR_OVERRIDE, $f9,0,0,0  ; from now, every block will use the given color
    !BYTE 89, 1,5,6,1  ;thin metal platform

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color

    !BYTE 107,37,6,2,99   ;underground door 10
    !BYTE 107,37,12,2,99    ;underground door 10
    !BYTE 107,37,18,2,99    ;underground door 10
    !BYTE 107,10,18,2,99    ;underground door 10
    !BYTE 107,23,18,2,99    ;underground door 10
    !BYTE 107,25,6,2,99   ;underground door 10
    !BYTE 107,9,6,2,99    ;underground door 10

    !BYTE 107,29,6,2,99   ;underground door 10
    !BYTE 107,33,6,2,99   ;underground door 10
    !BYTE 107,29,10,2,99    ;underground door 10
    !BYTE 107,33,10,2,99    ;underground door 10
    !BYTE 107,29,14,2,99    ;underground door 10
    !BYTE 107,33,14,2,99    ;underground door 10
    !BYTE 107,29,18,2,99    ;underground door 10
    !BYTE 107,33,18,2,99    ;underground door 10

    !BYTE 107,3,6,2,99    ;underground door 10
    !BYTE 107,3,4,2,2   ;underground door 10
    !BYTE 107,7,4,2,2   ;underground door 10
    !BYTE 107,11,4,2,2    ;underground door 10
    !BYTE 107,15,4,2,2    ;underground door 10
    !BYTE 107,19,4,2,2    ;underground door 10
    !BYTE 107,23,4,2,2    ;underground door 10
    !BYTE 107,27,4,2,2    ;underground door 10
    !BYTE 107,31,4,2,2    ;underground door 10
    !BYTE 107,35,4,2,2    ;underground door 10

    !BYTE 112,13,6,99,1   ;underground brick 2
    !BYTE 112,17,6,99,1   ;underground brick 2
    !BYTE 112,21,6,99,1   ;underground brick 2
    !BYTE 112,22,12,1,99    ;underground brick 2
    !BYTE 112,22,18,1,99    ;underground brick 2

    !BYTE 123,12,12,1,99    ;underground brick 3
    !BYTE 123,12,18,1,99    ;underground brick 3
  
    !BYTE 103,0,22,40,99    ;underground platform 2
    !BYTE 103,1,16,27,99    ;underground platform 2
    !BYTE 103,1,10,27,99    ;underground platform 2
    !BYTE 103,35,10,5,99    ;underground platform 2
    !BYTE 103,35,16,5,99    ;underground platform 2

    !BYTE 109,35,10,5,99    ;underground platform shadow
    !BYTE 109,35,16,5,99    ;underground platform shadow
    !BYTE 109,23,10,6,99    ;underground platform shadow
    !BYTE 109,23,16,6,99    ;underground platform shadow
    !BYTE 109,23,22,17,99   ;underground platform shadow
    !BYTE 109,0,22,12,99    ;underground platform shadow
    !BYTE 109,1,16,11,99    ;underground platform shadow
    !BYTE 109,9,10,2,99   ;underground platform shadow

    !BYTE 108,1,6,2,5   ;underground door shadow
    !BYTE 108,5,6,2,5   ;underground door shadow
    
    !BYTE 104,38,12,99,4    ;underground wall 2
    !BYTE 104,38,18,99,4    ;underground wall 2
    !BYTE 104,0,4,99,12   ;underground wall 2
    !BYTE 104,0,16,99,6   ;underground wall 2
    !BYTE 104,39,4,99,6   ;underground wall 2

    !BYTE 117,25,18,4,4   ;underground grid
    !BYTE 128,1,12,6,4    ;underground grid
    !BYTE 128,7,12,5,4    ;underground grid
    !BYTE 117,6,18,4,4    ;underground grid

    !BYTE 122,23,11,99,99   ;underground slide
    !BYTE 122,1,17,99,99    ;underground slide

    !BYTE 115,36,6,1,1    ;underground lamp hanger 115/120
    !BYTE 115,36,12,1,1   ;underground lamp hanger 115/120
    !BYTE 115,36,18,1,1   ;underground lamp hanger 115/120

    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ; from now, every block will use the given color
    
    !BYTE 121,35,11,1,1   ;underground black block
    !BYTE 121,39,11,1,1   ;underground black block
    !BYTE 121,35,17,1,1   ;underground black block
    !BYTE 121,39,17,1,1   ;underground black block
    !BYTE 121,23,17,1,1   ;underground black block
    !BYTE 121,28,17,1,1   ;underground black block

    !BYTE 121,1,17,1,1    ;underground black block
    !BYTE 121,6,17,1,1    ;underground black block
    !BYTE 121,23,11,1,1   ;underground black block
    !BYTE 121,28,11,1,1   ;underground black block

    !BYTE 42,39,12,1,4    ;warp 1
    !BYTE 43,39,18,1,4    ;warp 2
    
    !BYTE 255; end of level 

screen_14:
    ; header structure
    !BYTE $22, $8e,$41 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target

    !BYTE 12;target screen index
    !BYTE $5c,$b5 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 13;target screen index
    !BYTE $a5,$b5 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 15;target screen index
    !BYTE $12,$b5 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 16;target screen index
    !BYTE $a0,$20 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen14_actions_init
    !WORD screen14_actions

    ;spawn interval on this screen
    !BYTE 13

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 75, 9  , 13   ;num, x, y
    !BYTE 76, 30 + LAMP_SHIFT , 13    ;num, x, y
    !BYTE 77, 9  , 19   ;num, x, y
    !BYTE 78, 30 + LAMP_SHIFT , 19    ;num, x, y
    
    !BYTE 255

    ;spawn points
    !BYTE $32, $54
    !BYTE $86, $54
    !BYTE $38, $84
    !BYTE $82, $84
    !BYTE $28, $b4
    !BYTE $8a, $b4
    !BYTE 255
    
    ;blocks

    !BYTE 111,15,9,10,99    ;underground brick line

    !BYTE 105,5,4,99,10   ;yinyang
    !BYTE 105,33,4,99,10    ;yinyang
    
    !BYTE 113,0,3,40,99   ;underground ceiling thin
    !BYTE 114,0,3,40,99   ;underground ceiling deco
    !BYTE BLOCK_COLOR_OVERRIDE, $f9,0,0,0  ; from now, every block will use the given color
    !BYTE 89, 1,5,2,1  ;thin metal platform
    !BYTE 89, 38,5,2,1  ;thin metal platform

    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color
  
    !BYTE 103,0,22,40,99    ;underground platform 2
    !BYTE 103,0,16,40,99    ;underground platform 2
    !BYTE 103,0,10,15,99    ;underground platform 2
    !BYTE 103,25,10,15,99   ;underground platform 2

    !BYTE 109,0,10,15,99    ;underground platform shadow
    !BYTE 109,25,10,15,99   ;underground platform shadow
    !BYTE 109,0,16,9,99   ;underground platform shadow
    !BYTE 109,31,16,9,99    ;underground platform shadow
    !BYTE 109,0,22,9,99   ;underground platform shadow
    !BYTE 109,31,22,9,99    ;underground platform shadow
    !BYTE 109,19,16,2,99    ;underground platform shadow
    !BYTE 109,19,22,2,99    ;underground platform shadow

    !BYTE 108,1,6,2,5   ;underground door shadow
    
    !BYTE 104,39,12,99,5    ;underground wall 2
    !BYTE 104,0,4,99,12   ;underground wall 2
    !BYTE 104,0,16,99,5   ;underground wall 2

    !BYTE 128,3,18,4,4    ;underground grid
    !BYTE 128,33,18,4,4   ;underground grid

    !BYTE 122,1,11,99,99    ;underground slide
    !BYTE 122,33,11,99,99   ;underground slide

    !BYTE 120,9,12,1,1    ;underground lamp hanger 115/120
    !BYTE 120,9,18,1,1    ;underground lamp hanger 115/120
    !BYTE 115,30,12,1,1   ;underground lamp hanger 115/120
    !BYTE 115,30,18,1,1   ;underground lamp hanger 115/120

    !BYTE 107,5,6,2,99    ;underground door 10
    !BYTE 107,9,6,2,99    ;underground door 10
    !BYTE 107,13,6,2,99   ;underground door 10
    !BYTE 107,17,6,2,4    ;underground door 10
    !BYTE 107,21,6,2,4    ;underground door 10
    !BYTE 107,25,6,2,4    ;underground door 10
    !BYTE 107,29,6,2,99   ;underground door 10
    !BYTE 107,33,6,2,99   ;underground door 10
    !BYTE 107,37,6,2,99   ;underground door 10

    !BYTE 107,7,12,2,99   ;underground door 10
    !BYTE 107,19,12,2,99    ;underground door 10
    !BYTE 107,31,12,2,99    ;underground door 10
    !BYTE 107,1,18,2,99   ;underground door 10
    !BYTE 107,7,18,2,99   ;underground door 10
    !BYTE 107,19,18,2,99    ;underground door 10
    !BYTE 107,31,18,2,99    ;underground door 10
    !BYTE 107,37,18,2,99    ;underground door 10
    !BYTE 107,19,10,2,2   ;underground door 10

    !BYTE 107,3,4,2,2   ;underground door 10
    !BYTE 107,7,4,2,2   ;underground door 10
    !BYTE 107,11,4,2,2    ;underground door 10
    !BYTE 107,15,4,2,2    ;underground door 10
    !BYTE 107,19,4,2,2    ;underground door 10
    !BYTE 107,23,4,2,2    ;underground door 10
    !BYTE 107,27,4,2,2    ;underground door 10

    !BYTE 107,31,4,2,2    ;underground door 10
    !BYTE 107,35,4,2,2    ;underground door 10

    ;!BYTE BLOCK_COLOR_OVERRIDE, USE_BLOCK_COLOR,0,0,0 ; from now, the blocks will use their default color
    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ; from now, every block will use the given color

    !BYTE 121,0,11,1,1    ;underground black block
    !BYTE 121,6,11,1,1    ;underground black block
    !BYTE 121,33,11,1,1   ;underground black block
    !BYTE 121,39,11,1,1   ;underground black block
    !BYTE 121,0,17,1,1    ;underground black block
    !BYTE 121,39,17,1,1   ;underground black block
    !BYTE 121,0,23,1,1    ;underground black block
    !BYTE 121,39,23,1,1   ;underground black block

    !BYTE 42,39,6,1,4   ;warp 1
    !BYTE 43,0,18,1,4   ;warp 2
    !BYTE 44,39,18,1,4    ;warp 3
    
    !BYTE 255; end of level 

screen_15:
    ; header structure
    !BYTE $22, $8e,$41 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 12;target screen index
    !BYTE $80,$b5 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 14;target screen index
    !BYTE $a5,$b5 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 16;target screen index
    !BYTE $a0,$20 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen15_actions_init
    !WORD screen15_actions

    ;spawn interval on this screen
    !BYTE 13

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 79, 32 + LAMP_SHIFT  , 7    ;num, x, y
    !BYTE 80, 5  , 13   ;num, x, y

    ;lamp 81 is reserved for yinjang pickup
    !BYTE 255

    ;spawn points
    !BYTE $50, $54
    !BYTE $86, $54
    !BYTE $38, $84
    !BYTE $82, $84
    !BYTE $28, $b4
    !BYTE $8a, $b4
    !BYTE 255
    
    ;blocks

    !BYTE 111,15,9,10,99    ;underground brick line
    
    !BYTE 113,0,3,40,99   ;underground ceiling thin

    !BYTE 114,33,3,1,99   ;underground ceiling deco
    !BYTE 114,35,3,1,99   ;underground ceiling deco
    !BYTE 114,36,3,1,99   ;underground ceiling deco
    !BYTE 114,35,2,1,99   ;underground ceiling deco
    !BYTE 114,36,2,1,99   ;underground ceiling deco
    !BYTE 114,38,3,1,99   ;underground ceiling deco

    !BYTE 114,1,3,1,99    ;underground ceiling deco
    !BYTE 114,3,3,1,99    ;underground ceiling deco
    !BYTE 114,4,3,1,99    ;underground ceiling deco
    !BYTE 114,3,2,1,99    ;underground ceiling deco
    !BYTE 114,4,2,1,99    ;underground ceiling deco
    !BYTE 114,6,3,1,99    ;underground ceiling deco
    
    !BYTE 124,7,4,26,99   ;underground ceiling deco 2

    !BYTE 105,14,4,99,10    ;yinyang
    !BYTE 105,23,4,99,10    ;yinyang
    
    !BYTE BLOCK_COLOR_OVERRIDE, $ff,0,0,0  ; from now, every block will use the given color
    !BYTE 105,36,18,99,10   ;yinyang
    !BYTE 105,36,20,99,10   ;yinyang

    !BYTE BLOCK_COLOR_OVERRIDE, $f9,0,0,0  ; from now, every block will use the given color
    !BYTE 89, 3,5,2,1  ;thin metal platform
    !BYTE 89, 35,5,2,1  ;thin metal platform
    
    !BYTE BLOCK_COLOR_OVERRIDE, $de,0,0,0  ; from now, every block will use the given color
    !BYTE 103,0,22,40,99    ;underground platform 2
    !BYTE 103,0,16,40,99    ;underground platform 2
    !BYTE 103,1,10,34,99    ;underground platform 2
    ;!BYTE 103,25,10,15,99    ;underground platform 2

    !BYTE 109,0,10,7,99   ;underground platform shadow
    !BYTE 109,14,10,11,99   ;underground platform shadow
    !BYTE 109,29,16,10,99   ;underground platform shadow
    !BYTE 109,0,22,13,99    ;underground platform shadow
    !BYTE 109,29,22,10,99   ;underground platform shadow

    !BYTE 108,2,12,1,5    ;underground door shadow
    
    !BYTE 104,0,4,99,7    ;underground wall 2
    !BYTE 104,39,4,99,19    ;underground wall 2
    !BYTE 104,39,16,99,7    ;underground wall 2

    !BYTE 115,32,6,1,1    ;underground lamp hanger 115/120
    !BYTE 120,5,12,1,1    ;underground lamp hanger 115/120

    !BYTE 107,1,6,2,99    ;underground door 10
    !BYTE 108,3,6,2,5   ;underground door shadow
    !BYTE 107,5,6,2,99    ;underground door 10

    !BYTE 107,14,6,2,99   ;underground door 10
    !BYTE 107,17,6,2,99   ;underground door 10
    !BYTE 107,20,6,2,99   ;underground door 10
    !BYTE 107,23,6,2,99   ;underground door 10
    !BYTE 107,33,6,2,99   ;underground door 10
    !BYTE 107,37,6,2,99   ;underground door 10
    !BYTE 107,0,12,2,99   ;underground door 10
    !BYTE 107,3,12,2,99   ;underground door 10
    !BYTE 107,10,12,2,99    ;underground door 10
    !BYTE 107,11,12,2,99    ;underground door 10
    !BYTE 107,20,12,2,99    ;underground door 10
    !BYTE 107,30,12,2,99    ;underground door 10
    !BYTE 107,29,12,2,99    ;underground door 10
    !BYTE 107,33,12,2,99    ;underground door 10
    !BYTE 107,37,10,2,2   ;underground door 10
    !BYTE 107,37,12,2,99    ;underground door 10

    !BYTE 107,1,4,2,2   ;underground door 10
    !BYTE 107,5,4,2,2   ;underground door 10
    !BYTE 107,33,4,2,2    ;underground door 10
    !BYTE 107,37,4,2,2    ;underground door 10

    !BYTE 107,1,18,2,99   ;underground door 10
    !BYTE 107,10,18,2,99    ;underground door 10
    !BYTE 107,11,18,2,99    ;underground door 10
    !BYTE 107,20,18,2,99    ;underground door 10
    !BYTE 107,30,18,2,99    ;underground door 10
    !BYTE 107,29,18,2,99    ;underground door 10

    !BYTE 117,32,12,1,4   ;underground grid
    !BYTE 117,35,6,2,99   ;underground grid

    !BYTE 128,32,18,3,4   ;underground grid
    !BYTE 128,3,18,6,4    ;underground grid
    !BYTE 128,9,18,1,4    ;underground grid
    !BYTE 117,35,12,2,4   ;underground grid

    !BYTE BLOCK_COLOR_OVERRIDE, $88,0,0,0  ; from now, every block will use the given color

    !BYTE 121,34,11,1,1   ;underground black block
    !BYTE 121,0,11,1,1    ;underground black block
    !BYTE 121,0,17,1,1    ;underground black block
    !BYTE 121,39,17,1,1   ;underground black block

    !BYTE 121,0,23,1,1    ;underground black block
    !BYTE 121,39,23,1,1   ;underground black block

    !BYTE 42,0,12,1,4   ;warp 1
    !BYTE 43,0,18,1,4   ;warp 2
    
    !BYTE 255; end of level 
        
screen_16:
    ; header structure
    !BYTE $62, $ce,$ce ;color split line y, bg color upper, bg color lower
    !BYTE $00, $f1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 17;target screen index
    !BYTE $12, $b8 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 15;target screen index
    !BYTE $1c,$4a ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen16_actions_init
    !WORD screen16_actions

    ;spawn interval on this screen
    !BYTE 255

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
  
    !BYTE 255

    ;spawn points
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    !BYTE BLOCK_COLOR_OVERRIDE, $2a,0,0,0  ; from now, every block will use the given color
    !BYTE 105,7,2,99,99   ;yinyang
    !BYTE 105,17,2,99,99    ;yinyang
    !BYTE 105,27,2,99,99    ;yinyang
    
    
    !BYTE BLOCK_COLOR_OVERRIDE, $ae,0,0,0  ; from now, every block will use the given color
    !BYTE 125,2,13,4,99 ;zapper platform
    !BYTE 126,1,23,39,99  ;zapper platform 2

    !BYTE 125,34,23,6,99  ;zapper platform

    !BYTE 89, 34,8,4,1  ;thin metal platform
    !BYTE 89, 34,18,4,1  ;thin metal platform
    !BYTE 126,6,8,28,99 ;zapper platform 2
    !BYTE 126,6,18,28,99  ;zapper platform 2
    !BYTE 126,6,13,28,99  ;zapper platform 2

    !BYTE 104,1,2,99,12   ;underground wall 2
    !BYTE 104,1,14,99,10    ;underground wall 2
    !BYTE 104,39,10,99,4    ;underground wall 2
    !BYTE 104,39,2,99,2   ;underground wall 2
    !BYTE 104,30,2,99,2   ;underground wall 2
    !BYTE 104,20,2,99,2   ;underground wall 2
    !BYTE 104,10,2,99,2   ;underground wall 2

    !BYTE 127,0,10,99,4   ;underground wall 4
    !BYTE 127,0,2,99,2    ;underground wall 4
    !BYTE 127,5,2,99,2    ;underground wall 4
    !BYTE 127,15,2,99,2   ;underground wall 4
    !BYTE 127,25,2,99,2   ;underground wall 4
    !BYTE 127,33,2,99,2   ;underground wall 4
    !BYTE 127,38,2,99,12    ;underground wall 4
    !BYTE 127,38,14,99,5    ;underground wall 4

    !BYTE 117,2,2,3,2   ;underground grid
    !BYTE 117,11,2,4,2    ;underground grid
    !BYTE 117,21,2,4,2    ;underground grid
    !BYTE 117,31,2,2,2    ;underground grid

    !BYTE 42,39,19,1,4    ;warp 1
    ;!BYTE 43,34,2,4,1      ;warp 2

    !BYTE BLOCK_COLOR_OVERRIDE, $f9,0,0,0  ; from now, every block will use the given color

    !BYTE 121,0,16,1,8    ;underground black block
    !BYTE 108,39,16,1,3   ;underground door shadow
    !BYTE 108,38,19,1,4   ;underground door shadow
    !BYTE 255; end of level 
  
screen_17:
    ; header structure
    !BYTE $92, $ce,$e1 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 18;target screen index
    !BYTE $12, $a8 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 16;target screen index
    !BYTE $a5,$b8 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen17_actions_init
    !WORD screen17_actions

    ;spawn interval on this screen
    !BYTE 5

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 82, 18  , 4   ;num, x, y
    !BYTE 83, 22 + LAMP_SHIFT  , 4    ;num, x, y
    !BYTE 84, 14 + LAMP_SHIFT  , 8    ;num, x, y
    !BYTE 85, 26   , 8    ;num, x, y
    !BYTE 86, 13 + LAMP_SHIFT  , 12   ;num, x, y
    !BYTE 87, 27   , 12   ;num, x, y
  
    !BYTE 255

    ;spawn points
    !BYTE $80,$b0
    !BYTE $70,$b0
    !BYTE $60,$b0
    !BYTE $50,$b0
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks
    
    !BYTE BLOCK_COLOR_OVERRIDE, $2a,0,0,0  ; from now, every block will use the given color

    !BYTE 125,0,23,40,99  ;zapper platform
    !BYTE 2,15,2,99,99  ;platform end left
    !BYTE 3,17,2,7,2    ;platform
    !BYTE 8,24,2,99,99  ;platform end right
    !BYTE 17,18,2,2,1 ;platform end left
    !BYTE 17,21,2,2,1 ;platform end right
    
    !BYTE BLOCK_COLOR_OVERRIDE, $a9,0,0,0  ; from now, every block will use the given color

    !BYTE 89, 0,11,3,1  ;thin metal platform
    !BYTE 89, 37,11,3,1  ;thin metal platform

    !BYTE 128,10,16,6,1   ;underground grid
    !BYTE 128,16,16,6,1   ;underground grid
    !BYTE 128,22,16,6,1   ;underground grid
    !BYTE 128,24,16,6,1   ;underground grid
    !BYTE 128,33,16,4,1   ;underground grid

    !BYTE 104,0,12,99,6   ;underground wall 2  104/127
    !BYTE 127,39,18,99,6    ;underground wall 2  104/127
    !BYTE 104,17,8,99,10    ;underground wall 2  104/127
    !BYTE 127,23,8,99,10    ;underground wall 2  104/127
    !BYTE 128,0,18,6,4    ;underground grid 2
    !BYTE 128,6,18,6,4    ;underground grid 2
    !BYTE 128,12,18,6,4   ;underground grid
    !BYTE 128,18,18,6,4   ;underground grid
    !BYTE 128,24,18,6,4   ;underground grid
    !BYTE 128,30,18,6,4   ;underground grid
    !BYTE 128,36,18,3,4   ;underground grid
    !BYTE 128,19,4,3,3    ;underground grid
    
    !BYTE 128,18,8,5,6    ;underground grid
    !BYTE 128,18,14,5,2   ;underground grid
    
    !BYTE 107,1,12,2,99   ;underground door 10
    !BYTE 128,1,16,6,1    ;underground grid

    !BYTE BLOCK_COLOR_OVERRIDE, $be,0,0,0  ; from now, every block will use the given color
    !BYTE 125,14,11,3,99  ;zapper platform
    !BYTE 125,24,11,3,99  ;zapper platform
    !BYTE 125,15,7,11,99  ;zapper platform
    !BYTE 125,20,13,3,99  ;zapper platform

    !BYTE 127,17,4,99,4   ;underground wall 2  104/127
    !BYTE 104,23,4,99,4   ;underground wall 2  104/127
    !BYTE 104,39,12,99,5    ;underground wall 2  104/127

    !BYTE BLOCK_COLOR_OVERRIDE, $ee,0,0,0  ; from now, every block will use the given color
    !BYTE 125,1,17,6,99 ;zapper platform
    !BYTE 125,10,17,20,99 ;zapper platform
    !BYTE 125,33,17,7,99  ;zapper platform

    !BYTE BLOCK_COLOR_OVERRIDE, $cc,0,0,0  ; from now, every block will use the given color
    !BYTE 15,18,8,99,99 ;ladder top
    !BYTE 16,18,12,99,99  ;ladder bottom
    !BYTE 15,21,14,99,4 ;ladder top
    !BYTE 15,18,18,99,1 ;ladder top
    !BYTE 16,18,19,99,1 ;ladder bottom

    ;!BYTE 120,18,4,1,1   ;underground lamp hanger 115/120
    !BYTE 115,14,7,1,1    ;underground lamp hanger 115/120
    !BYTE 115,13,11,1,1   ;underground lamp hanger 115/120
    ;!BYTE 115,22,4,1,1   ;underground lamp hanger 115/120
    !BYTE 120,26,7,1,1    ;underground lamp hanger 115/120
    !BYTE 120,27,11,1,1   ;underground lamp hanger 115/120

    !BYTE 112,16,8,1,2    ;corner 123/112
    !BYTE 112,16,12,1,2   ;corner 123/112
    !BYTE 123,24,8,1,2    ;corner 123/112
    !BYTE 123,24,12,1,2   ;corner 123/112
    
    ;!BYTE 42,39,12,1,1   ;warp 1
    ;!BYTE 42,39,13,1,4   ;warp 1
    !BYTE 43,0,18,1,1     ;warp 2
    !BYTE 43,0,19,1,4     ;warp 2
    
    !BYTE 255; end of level 
  
screen_18:
    ; header structure
    !BYTE $92, $c1,$c1 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 19;target screen index
    !BYTE 50, 50 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 17;target screen index
    !BYTE $a5,$88 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;pointer to screen execution logic
    !WORD screen18_actions_init
    !WORD screen18_actions

    ;spawn interval on this screen
    !BYTE 255

    ;in hard mode, can be spawned with player?
    !BYTE 1

    ;lamps
    !BYTE 88, 31 + LAMP_SHIFT  , 21   ;num, x, y
    !BYTE 89, 2   , 3   ;num, x, y
    !BYTE 90, 31 + LAMP_SHIFT   , 8   ;num, x, y
  
    !BYTE 255

    ;spawn points
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0

    !BYTE 0,0
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks

    !BYTE 119,1,4,1,5   ;underground gray block
    !BYTE BLOCK_COLOR_OVERRIDE, $ff,0,0,0  ; from now, every block will use the given color
    !BYTE 130,8,2,30,1  ;horizontal ladder

    !BYTE BLOCK_COLOR_OVERRIDE, $2f,0,0,0  ; from now, every block will use the given color
    !BYTE 125,1,23,38,99  ;zapper platform
    !BYTE 1, 0,21,8,1  ;thin metal platform
    !BYTE 1, 0,15,8,1  ;thin metal platform
    !BYTE 1, 0,9,8,1  ;thin metal platform
    !BYTE 1, 0,5,8,1  ;thin metal platform
    !BYTE 1, 37,7,3,1  ;thin metal platform

    !BYTE 125,2,21,5,99 ;zapper platform
    !BYTE 125,2,15,5,99 ;zapper platform
    !BYTE 125,2,9,30,99 ;zapper platform
    !BYTE 126,3,9,26,99 ;zapper platform 2
    !BYTE 125,2,5,5,99  ;zapper platform
    !BYTE 125,33,21,6,99  ;zapper platform

    !BYTE 127,0,4,99,12   ;underground wall 2  104/127
    !BYTE 127,1,2,99,2    ;underground wall 2  104/127
    !BYTE 104,1,10,99,6   ;underground wall 2  104/127
    !BYTE 104,1,22,99,2   ;underground wall 2  104/127
    !BYTE 127,7,22,99,2   ;underground wall 2  104/127
    !BYTE 104,32,8,99,4   ;underground wall 2  104/127
    !BYTE 104,32,14,99,2    ;underground wall 2  104/127
    !BYTE 104,32,18,99,6    ;underground wall 2  104/127
    !BYTE 104,39,8,99,12    ;underground wall 2  104/127
    !BYTE 104,39,20,99,2    ;underground wall 2  104/127
    !BYTE 127,38,22,99,2    ;underground wall 2  104/127
    !BYTE 104,36,2,99,2   ;underground wall 2  104/127
    !BYTE 104,37,2,99,2   ;underground wall 2  104/127
    !BYTE 104,38,2,99,2   ;underground wall 2  104/127

    !BYTE 117,2,22,5,2    ;underground grid 2
    !BYTE 117,33,22,5,2   ;underground grid 2
    !BYTE 60,32,6,1,99  ;swords up

    ;!BYTE BLOCK_COLOR_OVERRIDE, $b9,0,0,0  ; from now, every block will use the given color
    !BYTE 119,37,4,2,3    ;underground gray block
    !BYTE 129,14,18,99,99   ;underground gray block
    !BYTE 129,18,18,99,99   ;underground gray block
    !BYTE 129,23,18,99,99   ;underground gray block
    !BYTE 129,27,18,99,99   ;underground gray block

    !BYTE BLOCK_COLOR_OVERRIDE, $ff,0,0,0  ; from now, every block will use the given color
;   !BYTE 15,3,10,99,2  ;ladder top
;   !BYTE 16,18,12,99,99  ;ladder bottom
    !BYTE 17,24,16,3,4  ;empty
    !BYTE 17,37,18,2,2  ;empty

;   !BYTE 36,17,12,3,6  ;ladder top
    ;!BYTE 37,29,10,3,2 ;ladder bottom
    !BYTE 36,37,14,2,2  ;ladder bottom
    !BYTE 36,37,8,2,4 ;ladder bottom
    ;!BYTE 15,19,16,2,2 ;ladder top
    
    !BYTE 130,8,10,24,1 ;horizontal ladder
    !BYTE 130,2,10,5,1  ;horizontal ladder
    !BYTE 37,3,10,3,2 ;ladder bottom
    !BYTE 37,3,6,3,1  ;ladder bottom

    !BYTE 120,2,2,1,1   ;underground lamp hanger 115/120
    !BYTE 115,31,20,1,1   ;underground lamp hanger 115/120
    !BYTE 115,31,7,1,1    ;underground lamp hanger 115/120
    
    !BYTE 119,0,16,2,5    ;underground gray block
    !BYTE 119,7,16,1,5    ;underground gray block
    !BYTE 119,7,10,1,5    ;underground gray block
    !BYTE 119,7,2,1,3   ;underground gray block

    
    !BYTE 89, 13,15,6,1  ;thin metal platform
    !BYTE 89, 23,15,6,1  ;thin metal platform
    
    
    !BYTE 42,39,4,1,3   ;warp 1
    ;!BYTE 42,39,13,1,4   ;warp 1
    !BYTE 43,0,16,1,4     ;warp 2
    
    !BYTE 255; end of level 
  
screen_19:
    ; header structure
    !BYTE $92, $c1,$c1 ;color split line y, bg color upper, bg color lower
    !BYTE $00, $a1  ;additional colors (multi 1/2)
    
    ;warp 1 target
    !BYTE 0;target screen index
    !BYTE 0, 0 ; x and y intially on target screen

    ;warp 2 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 3 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;warp 4 target
    !BYTE 0;target screen index
    !BYTE 0,0 ; x and y intially on target screen

    ;pointer to screen execution logic

    !WORD congrats_screen
    !WORD screen_does_nothing

    ;spawn interval on this screen
    !BYTE 255

    ;in hard mode, can be spawned with player?
    !BYTE 0

    ;lamps
    !BYTE 255

    ;spawn points
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    !BYTE 0,0
    ;!BYTE  $18, $8a
    ;!BYTE  $90, $8a
    ;!BYTE  $20, $bb
    ;!BYTE  $90, $bb
    !BYTE 255
    
    ;blocks
    !BYTE 255; end of level 

;----------------------------------------------------------------------------
;       Global Characteristics
;---------------------------------------------------------------------------- 

number_of_sprite_manifests      = 3

sprite_frame_height_char      = 4       ; 3 char is the real image and +1 for shifting down
sprite_frame_width_char       = 5       ; 4 char is the real image and +1 for shifting right
sprite_char_buffer_size       =   (sprite_frame_height_char * sprite_frame_width_char);
limit_sprite_y_pos          = 223
limit_sprite_x_pos          = (((sprite_frame_width_char) + 39) * 4) - 1;(off on left + full screen columns) * 4 pixels - 1

;----------------------------------------------------------------------------
;       RESTORE SPRITE BACKGROUND A=sprite index X=target screen memory hi 0c::00   
;---------------------------------------------------------------------------- 
restore_sprite_background_buffer1:
    
    asl
    asl
    asl
    asl
    asl
    tax

    ; get data from manifest records by index. 
    lda   sprite_manifests + 12,x ;limit buffer size for buffer1
    sta   overw27 + 1 ;limit main cycle for smaller width
    lda   sprite_manifests + 4,x ;pos of last char lo for buffer1
    sta   overw21 + 1
    lda   sprite_manifests + 5,x ;pos of last char hi for buffer1
    sta   overw21 + 2
    lda   sprite_manifests + 6,x ;background buffer lo for buffer1
    sta   overw25 + 1
    lda   sprite_manifests + 7,x ;background buffer hi for buffer1
    sta   overw25 + 2
    lda   sprite_manifests + 17,x ;background buffer mask lo for buffer1
    sta   overw28 + 1
    lda   sprite_manifests + 18,x ;background buffer mask hi for buffer1
    sta   overw28 + 2
    lda   sprite_manifests + 21,x ;background buffer mask start index for buffer 1
    cmp   overw27 + 1
    bcc   +
    rts   ; the start index is bigger than end index... do nothing
+   sta   overw26 + 1

    
    ; main cycle to retrieve chars behind sprite

overw26:ldx   #$00
-   
overw28:lda   $8000,x
    bne   +     ;skip modification of bytes outside of the screen
    ldy   sprite_frame_internal_offset,x
overw25:lda   sprite_back_buffer1, x  ;read what was behind   
overw21:sta   $8000,y
+   inx   
overw27:cpx   #20 ;limited dynamically for width
    bne - ;end sprite cycle screen rendering
    
    rts

;----------------------------------------------------------------------------------------------------
restore_sprite_background_buffer2:
    
    asl
    asl
    asl
    asl
    asl
    tax
    ; get data from manifest records by index. 
    lda   sprite_manifests + 13,x ;limit buffer size for buffer2
    sta   overw77 + 1 ;limit main cycle for smaller width
    lda   sprite_manifests + 8,x ;pos of last char lo for buffer2
    sta   overw71 + 1
    lda   sprite_manifests + 9,x ;pos of last char hi for buffer2
    sta   overw71 + 2
    lda   sprite_manifests + 10,x ;background buffer lo for buffer2
    sta   overw75 + 1
    lda   sprite_manifests + 11,x ;background buffer hi for buffer2
    sta   overw75 + 2
    lda   sprite_manifests + 19,x ;background buffer mask lo for buffer2
    sta   overw78 + 1
    lda   sprite_manifests + 20,x ;background buffer mask hi for buffer2

    sta   overw78 + 2
    lda   sprite_manifests + 22,x ;background buffer mask start index for buffer 2
    cmp   overw77 + 1
    bcc   +
    rts   ;the start index is bigger than end index... do nothing
+   sta   overw76 + 1

    
    ; main cycle to retrieve chars behind sprite

overw76:ldx   #$00

-   
overw78:lda   $8000,x
    bne   +         ;skip modification of bytes outside of the screen
    ldy   sprite_frame_internal_offset,x
overw75:lda   sprite_back_buffer1, x  ;read what was behind   
overw71:sta   $8000,y
+   inx   
overw77:cpx   #20 ;limited dynamically for width
    bne - ;end sprite cycle screen rendering
    
    rts
  
;----------------------------------------------------------------------------
;       RENDER SPRITE A=sprite index X=target screen memory 0c00  Y=target char mem address 7800
;----------------------------------------------------------------------------
render_sprite_buffer1:
    asl
    asl
    asl
    asl
    asl
    tay
    ; get data from manifest records by index
    lda   sprite_manifests + 6,y ;background buffer lo for buffer1
    sta   sbb1ow + 1
    lda   sprite_manifests + 7,y ;background buffer hi for buffer1
    sta   sbb1ow + 2
    lda   sprite_manifests + 24,y ;sprite char color
    sta   sprcol + 1
    lda   sprite_manifests + 25,y ;sprite char color conversion table low
    sta   colconvtable + 1
    lda   sprite_manifests + 26,y ;sprite char color conversion table high
    sta   colconvtable + 2

    lda   sprite_manifests + 3, y
    sta   $d5     ;//sprite character
    sta   overw8 + 1
    lda   sprite_manifests + 1, y
    cmp   #limit_sprite_y_pos     ;limit y pos
    bcc   +
    lda   #limit_sprite_y_pos
+   sta   $d3     ;//sprite y
    lda   sprite_manifests + 2, y
    sta   $d4     ;//sprite image index

    lda   sprite_manifests, y 
    cmp   #limit_sprite_x_pos
    bcc   +
    lda   #limit_sprite_x_pos
+   sta   $d2     ;//sprite x

    lsr
    lsr
    sta   adc_b1 + 1 ;overwrite adc command with character x pos
    sta   $d6
    
    
    lda   $d3     ;get pos y
    and   #$f8
    lsr
    lsr         ; get character pos for y
    tax
    lda   screen_rows_mul_table_buffer1 + 1,x
    sta   overw1 + 2
    sta   overw2 + 2
    sta   sprite_manifests + 5,y ;screen buffer hi for buffer1
    sec
    sbc   #$04
    sta   overwc + 2
    
    lda   sprite_frame_masks_by_rows,x
    sta   sprite_manifests + 17,y ;sprite frame offset mask lo for buffer1
    sta   overw5 + 1;
    lda   sprite_frame_masks_by_rows + 1,x
    sta   sprite_manifests + 18,y ;sprite frame offset mask hi for buffer1
    sta   overw5 + 2;

    lda   screen_rows_mul_table_buffer1,x
    clc
adc_b1: adc   #$00  ;add char pos x to final row start
    bcc   +
    inc   overw1 + 2
    inc   overw2 + 2
    inc   overwc + 2
    sty   $02
    ldx   $02
    inc   sprite_manifests + 5,x ;screen buffer hi for buffer1
+   sta   overw1 + 1
    sta   overw2 + 1
    sta   overwc + 1
    sta   sprite_manifests + 4,y ;screen buffer lo for buffer1

    ; d5-sprite char, d4-frame index
    
    ldx   $d4   ;sprite image index
    lda   sprite_frame_width_by_image_index, x
    sta   $3a
    sta   overw7 + 1 ;limit main cycle for smaller width
    sta   sprite_manifests + 12,y ;size of sprite characters for buffer1
    asl
    asl
    asl
    sta   overw12 + 1 ; * 8 to calculate how many bytes should be copied to charset

    ;automatically limit frame size when on right side of screen
    ldx   $d6   ;get sprite char x
    lda   sprite_width_limit_by_col,x
    beq   +     ; 0 means, no frame size overwrite
    cmp   overw7 + 1
    bcs   +     ;calculated frame limit is smaller than offset limit... ignore 
    sta   overw7 + 1;     limit main cycle for smaller width
    sta   sprite_manifests + 12,y     ; size of sprite characters for buffer1
    asl
    asl
    asl
    sta   overw12 + 1   ; size of sprite characters for buffer1
+   
    ; check left side off-screen sprite frame start index
    lda   sprite_frame_left_column__by_col,x
    sta   sprite_manifests + 21,y ;background buffer mask start index for buffer 1
    cmp   overw7 + 1
    bcc   +
    rts   ;the start index is bigger than end index... do nothing
+   
    sta   overw3 + 1
    clc
    adc   $d5
    sta   $d5   ;shift frame start char with the start index

    lda   #sprite_color_correction_buffer >> 8
    sta   $db
    lda   #(sprite_color_correction_buffer & $ff )
    sta   $da

    ; main cycle to render sprite chars
overw3: ldx   #$00

-   
overw5: lda   $8000,x       ;skip sprite char render when off-screen
    bne   +

    stx   $d8
    ldy   sprite_frame_internal_offset,x
overw1: lda   $8000,y
sbb1ow: sta   sprite_back_buffer1, x  ;store what is behind   
    ; calculate charset address of background character
    tax
    lda   sprite_charset_mul_table_lo,x
    sta   overw4 + 1
    lda   sprite_charset_mul_table_hi1,x
    sta   overw4 + 2

    lda   chars_with_fixed_color, x
    sta   xcolcorrmask + 1
    bne   nocolor
    ;write sprite color to color mem
sprcol
    lda   #$ee      ;sprite color
overwc: sta   $0000,y

nocolor
    ;get next char to from sprite frame to put to screen
    lda   $d5
overw2: sta   $8000,y

    ; calculate charset address of sprite frame character
    tax
    lda   sprite_charset_mul_table_lo,x
    sta   overw6 + 1
    lda   sprite_charset_mul_table_hi1,x
    sta   overw6 + 2
    
    ldy   #$00    ;copy charset data from background to sprite foreground
-
overw4: lda   $8000,y
overw6: sta   $8000,y
xcolcorrmask
    lda   #$00      ;color correction flag
    sta   ($da),y
    iny
    cpy   #$08
    bne   -

    ldx   $d8
+

    ;target to color correction buffer
    lda   $da
    clc
    adc   #$08
    bcc   +
    inc   $db   
+   sta   $da

    ;next char to render to screen
    inc   $d5       
  
    inx   
overw7: cpx   #20 ;limited dynamically for width
    bne overw5 ;--  ;end sprite cycle screen rendering
    
    ; put sprite frame data over pre-rendered background
    
overw8: ldx   #$00    ;sprite char
    lda   $d3     ;sprite y
    and   #$07    ;horizontal shift from y inside target buffer
    clc
    adc   sprite_charset_mul_table_lo,x
    sta   target1 + 1
    sta   target2 + 1
    lda   sprite_charset_mul_table_hi1,x
    sta   target1 + 2
    sta   target2 + 2

    lda   #(sprite_color_correction_buffer >> 8)
    sta   corrbuff + 2

    lda   $d3
    and   #$07
    clc
    adc   #(sprite_color_correction_buffer & $ff)
    bcc   +
    inc   corrbuff + 2
+   sta   corrbuff + 1

    ;copy sprite frame image data to target charset
    lda   $d4     ;sprite image index
    asl
    tax
    lda   sprite_frames_ptr,x
    sta   sprref1 + 1
    sta   sprref2 + 1
    lda   sprite_frames_ptr + 1,x
    sta   sprref1 + 2
    sta   sprref2 + 2
    
    lda   $d2   ;x pos
    and   #$03
    sta   $d2   ;param for shift_sprite_frame
    ;lsr
    asl
    tax

sprref1
    lda   sprite_frames,x
    sta   source1 + 1
    sta   frshftbuff + 1
    ;sta    $d3   ;param for shift_sprite_frame
    inx
sprref2
    lda   sprite_frames,x
    sta   source1 + 2     ;this is the source address of the subframe
    sta   frshftbuff + 2
    ;sta    $d4   ;param for shift_sprite_frame
    
    lda   $3a
    cmp   #5 * sprite_frame_height_char   ;5 char width sprites already shifted
    beq   skip_sprite_frame_shift1
    jsr   shift_sprite_frame1
skip_sprite_frame_shift1
    
    
    ldx   #$00
- 
frshftbuff  
    ldy   frame_shift_buffer1,x
corrbuff
    lda   sprite_color_correction_buffer, x
    beq   + 
colconvtable
    lda   sprite_color_conversion_table,y
    tay

+
    ;y-ban a byte
    sty   tora + 1
target1:lda   $7800,x
    and   mask_table,y
tora:ora    #$00

target2:sta   $7800,x
    inx
overw12:cpx   #$10
    bne   -
    rts

;--------------------------------------------------------------------------------------------------
;   SHIFT SPRITE FRAME BUFFER 1   Params: d3-d3: frame addr   d2: subframe (x & 3)
;--------------------------------------------------------------------------------------------------
frame_shift_buffer1
    !FILL   sprite_char_buffer_size * 8,0   ;reserve buffer for color avoidance
    
shift_sprite_frame1 
    
    lda   source1 + 4
    sta   frshftbuff + 1
    lda   source1 + 5
    sta   frshftbuff + 2
    
    ldx   #$00
-
source1:lda   $2000, x
    sta   frame_shift_buffer1, x
    inx
    cpx   overw12 + 1
    bne   -
    ;rts    ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    lda   $d2
    and   #$01
    bne   +
    rts   ;no need to shift frame, no offset required from x
+   
    ldx   #$00
-   
    clc
    lda   frame_shift_buffer1, x
    ror
    sta   frame_shift_buffer1, x
    
    lda   frame_shift_buffer1 + 1 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 1 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer1 + 2 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 2 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer1 + 3 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 3 * sprite_frame_height_char * 8, x
    
    ;lda    frame_shift_buffer1 + 4 * sprite_frame_height_char * 8, x
    ;ror
  ; sta   frame_shift_buffer1 + 4 * sprite_frame_height_char * 8, x

    clc
    lda   frame_shift_buffer1, x
    ror
    sta   frame_shift_buffer1, x
    
    lda   frame_shift_buffer1 + 1 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 1 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer1 + 2 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 2 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer1 + 3 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer1 + 3 * sprite_frame_height_char * 8, x
    
  ; lda   frame_shift_buffer1 + 4 * sprite_frame_height_char * 8, x
    ;ror
    ;sta    frame_shift_buffer1 + 4 * sprite_frame_height_char * 8, x
    
    inx
    cpx   #sprite_frame_height_char * 8
    bne   -
    rts
    
;--------------------------------------------------------------------------------------------------
;   SHIFT SPRITE FRAME BUFFER 2   Params: d3-d3: frame addr   d2: subframe (x & 3)
;--------------------------------------------------------------------------------------------------
frame_shift_buffer2
    !FILL   sprite_char_buffer_size * 8,0   ;reserve buffer for color avoidance
    
shift_sprite_frame2 
    
    lda   xsource1 + 4
    sta   xfrshftbuff + 1
    lda   xsource1 + 5
    sta   xfrshftbuff + 2


    ldx   #$00
-
xsource1:lda    $2000, x
    sta   frame_shift_buffer2, x
    inx
    cpx   xoverw12 + 1
    bne   -
    ;rts    ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lda   $d2
    and   #$01
    bne   +
    rts   ;no need to shift frame, no offset required from x
+   
    ldx   #$00
-   
    clc
    lda   frame_shift_buffer2, x
    ror
    sta   frame_shift_buffer2, x
    
    lda   frame_shift_buffer2 + 1 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 1 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer2 + 2 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 2 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer2 + 3 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 3 * sprite_frame_height_char * 8, x
    
  ; lda   frame_shift_buffer2 + 4 * sprite_frame_height_char * 8, x
  ; ror
  ; sta   frame_shift_buffer2 + 4 * sprite_frame_height_char * 8, x

    clc
    lda   frame_shift_buffer2, x
    ror
    sta   frame_shift_buffer2, x
    
    lda   frame_shift_buffer2 + 1 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 1 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer2 + 2 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 2 * sprite_frame_height_char * 8, x
    
    lda   frame_shift_buffer2 + 3 * sprite_frame_height_char * 8, x
    ror
    sta   frame_shift_buffer2 + 3 * sprite_frame_height_char * 8, x
    
  ; lda   frame_shift_buffer2 + 4 * sprite_frame_height_char * 8, x
  ; ror
  ; sta   frame_shift_buffer2 + 4 * sprite_frame_height_char * 8, x
    
    inx
    cpx   #sprite_frame_height_char * 8
    bne   -
    rts
    
;--------------------------------------------------------------------------------------------------
render_sprite_buffer2:    
    asl
    asl
    asl
    asl
    asl
    tay
    ; get data from manifest records by index
    lda   sprite_manifests + 10,y ;background buffer lo for buffer2
    sta   sbb2ow + 1
    lda   sprite_manifests + 11,y ;background buffer hi for buffer2
    sta   sbb2ow + 2
    lda   sprite_manifests + 24,y ;sprite char color
    sta   xsprcol + 1

    lda   sprite_manifests + 25,y ;sprite char color conversion table low
    sta   xcolconvtable + 1
    lda   sprite_manifests + 26,y ;sprite char color conversion table high
    sta   xcolconvtable + 2

    lda   sprite_manifests + 3, y
    sta   $d5     ;//sprite character
    sta   xoverw8 + 1

    lda   sprite_manifests + 1, y
    cmp   #limit_sprite_y_pos     ;limit y pos
    bcc   +
    lda   #limit_sprite_y_pos
+   sta   $d3     ;//sprite y
    lda   sprite_manifests + 2, y
    sta   $d4     ;//sprite image index
    lda   sprite_manifests, y 
    cmp   #limit_sprite_x_pos
    bcc   +
    lda   #limit_sprite_x_pos
+   sta   $d2     ;//sprite x

    lsr
    lsr
    sta   xadc_b1 + 1 ;overwrite adc command with character x pos
    sta   $d6
    
    lda   $d3     ;get pos y
    and   #$f8
    lsr
    lsr         ; get character pos for y
    tax
    lda   screen_rows_mul_table_buffer2 + 1,x
    sta   xoverw1 + 2
    sta   xoverw2 + 2
    sta   sprite_manifests + 9,y ;screen buffer hi for buffer2
    sec
    sbc   #$04
    sta   xoverwc + 2   ; color screen page
    
    lda   sprite_frame_masks_by_rows,x
    sta   sprite_manifests + 19,y ;sprite frame offset mask lo for buffer2
    sta   xoverw5 + 1;
    lda   sprite_frame_masks_by_rows + 1,x
    sta   sprite_manifests + 20,y ;sprite frame offset mask hi for buffer2
    sta   xoverw5 + 2;    

    lda   screen_rows_mul_table_buffer2,x
    clc
xadc_b1:adc   #$00  ;add char pos x to final row start
    bcc   +
    inc   xoverw1 + 2
    inc   xoverw2 + 2
    inc   xoverwc + 2
    sty   $02
    ldx   $02
    inc   sprite_manifests + 9,x ;screen buffer hi for buffer2

+   sta   xoverw1 + 1
    sta   xoverw2 + 1
    sta   xoverwc + 1
    sta   sprite_manifests + 8,y ;screen buffer lo for buffer2

    ; d5-sprite char, d4-frame index
    
    ldx   $d4   ;sprite image index
    lda   sprite_frame_width_by_image_index, x
    sta   $3a
    sta   xoverw7 + 1 ;limit main cycle for smaller width
    sta   sprite_manifests + 13,y ;size of sprite characters for buffer2

    asl
    asl
    asl
    sta   xoverw12 + 1 ; * 8 to calculate how many bytes should be copied to charset
    
    ;automatically limit frame size when on right side of screen
    ldx   $d6   ;get sprite char x
    lda   sprite_width_limit_by_col,x
    beq   +     ; 0 means, no frame size overwrite
    cmp   xoverw7 + 1
    bcs   +     ;calculated frame limit is msller than offset limit... ignore 
    sta   xoverw7 + 1;      limit main cycle for smaller width
    sta   sprite_manifests + 13,y     ; size of sprite characters for buffer1
    asl
    asl
    asl
    sta   xoverw12 + 1    ; size of sprite characters for buffer1
+   
    ; check left side off-screen sprite frame start index
    lda   sprite_frame_left_column__by_col,x
    sta   sprite_manifests + 22,y ;background buffer mask start index for buffer 2
    cmp   xoverw7 + 1
    bcc   +
    rts   ;the start index is bigger than end index... do nothing
+   
    sta   xoverw3 + 1
    clc
    adc   $d5
    sta   $d5   ;shift frame start char with the start index

    lda   #sprite_color_correction_buffer >> 8
    sta   $db
    lda   #(sprite_color_correction_buffer & $ff )
    sta   $da

    ; main cycle to render sprite chars
xoverw3:ldx   #$00

-   
xoverw5:  lda   $8000,x       ;skip sprite char render when off-screen
    bne   +

    stx   $d8

    ldy   sprite_frame_internal_offset,x
xoverw1:lda   $0000,y
sbb2ow: sta   sprite_back_buffer1, x  ;store what is behind   
    ; calculate charset address of background character
    tax
    lda   sprite_charset_mul_table_lo,x
    sta   xoverw4 + 1
    lda   sprite_charset_mul_table_hi2,x
    sta   xoverw4 + 2
    
    lda   chars_with_fixed_color, x
    sta   colcorrmask + 1
    bne   xnocolor
    
    ;write sprite color to color mem
xsprcol
    lda   #$ee      ;sprite color
xoverwc:sta   $0000,y

xnocolor
    ;get next char from sprite frame to put to screen
    lda   $d5
xoverw2:sta   $0000,y
    ; calculate charset address of sprite frame character
    tax
    lda   sprite_charset_mul_table_lo,x
    sta   xoverw6 + 1
    lda   sprite_charset_mul_table_hi2,x
    sta   xoverw6 + 2
    
    ldy   #$00    ;copy charset data from background to sprite foreground
-
xoverw4:  lda   $8000,y
xoverw6:  sta   $8000,y
colcorrmask
    lda   #$00      ;color correction flag
    sta   ($da),y
    iny
    cpy   #$08
    bne   -
    ldx   $d8
+

    ;target to color correction buffer
    lda   $da
    clc
    adc   #$08
    bcc   +
    inc   $db   
+   sta   $da

    ;next char to render to screen
    inc   $d5       
    inx   
xoverw7:cpx   #20 ;limited dynamically for width
    bne xoverw5 ;--  ;end sprite cycle screen rendering
    
    ; put sprite frame data over pre-rendered background
    
xoverw8:ldx   #$00    ;sprite char
    lda   $d3     ;sprite y
    and   #$07    ;horizontal shift from y inside target buffer
    clc
    adc   sprite_charset_mul_table_lo,x
    sta   xtarget1 + 1
    sta   xtarget2 + 1
    lda   sprite_charset_mul_table_hi2,x
    sta   xtarget1 + 2
    sta   xtarget2 + 2
    
    lda   #(sprite_color_correction_buffer >> 8)
    sta   xcorrbuff + 2

    lda   $d3
    and   #$07
    clc
    adc   #(sprite_color_correction_buffer & $ff)
    bcc   +
    inc   xcorrbuff + 2
+   sta   xcorrbuff + 1
    
    
    ;copy sprite frame image data to target charset
    lda   $d4     ;sprite image index
    asl
    tax
    lda   sprite_frames_ptr,x
    sta   xsprref1 + 1
    sta   xsprref2 + 1
    lda   sprite_frames_ptr + 1,x
    sta   xsprref1 + 2
    sta   xsprref2 + 2
    
    lda   $d2   ;x pos
    and   #$03
    sta   $d2   ;param for shift_sprite_frame
    ;lsr
    asl
    tax

xsprref1
    lda   sprite_frames,x
    sta   xsource1 + 1
    sta   xfrshftbuff + 1
    ;sta    $d3   ;param for shift_sprite_frame
    inx
xsprref2
    lda   sprite_frames,x
    sta   xsource1 + 2      ;this is the source address of the subframe
    sta   xfrshftbuff + 2
    ;sta    $d4   ;param for shift_sprite_frame

    lda   $3a
    cmp   #5 * sprite_frame_height_char  ;5 char width sprites already shifted
    beq   skip_sprite_frame_shift
    jsr   shift_sprite_frame2
skip_sprite_frame_shift
    
    ldx   #$00
- 
xfrshftbuff 
    ldy   frame_shift_buffer2,x
xcorrbuff
    lda   sprite_color_correction_buffer, x
    beq   + 
xcolconvtable
    lda   sprite_color_conversion_table,y
    tay
+
    ;y-ban a byte
    sty   xtora + 1
xtarget1:lda    $7800,x
    and   mask_table,y
xtora:ora   #$00

xtarget2:sta  $7800,x
    inx
xoverw12:cpx    #$10
    bne   -
    rts

;---------------------------------------------------------------
;   GET BEHAVIOR FROM SPRITE POSITION: paramaters: AC=sprite manifest record id; x=check body area index
;   Returns bit combination of the characters behind the given body parts
;---------------------------------------------------------------
get_behavior_from_sprite_position
    stx   $d9 ; body part
    tay
    txa
    asl
    asl
    sta   body_part_compensation_offset + 1
    
    tya
    asl
    asl
    asl
    asl
    asl
    tax
    stx   $d4   ;calculate first byte of the given manifest record

    
    lda   sprite_manifests, x   ;//sprite x
    cmp   #(sprite_frame_width_char -1 ) * 4
    bcs   +
    ;sprite x is too low, adjust pos x for avoid checking off-screen
    lda   #(sprite_frame_width_char -1) * 4
+
    cmp   #(sprite_frame_width_char + 37) * 4     
    bcc   +
    ;sprite x is too high, adjust pos x for avoid checking off-screen
    lda   #(sprite_frame_width_char + 37) * 4     
+

    ;byt  $f2
    sta   $d8   ;store sprite pixel x
    lsr
    lsr
    sta   gibadc + 1  ;sprite char x
    
    lda   sprite_manifests + 1, x   ;//sprite y
    sta   $d1             ; store y
    and   #$f8
    lsr
    lsr         ; get character pos for y
    tax

    lda   buffer_drawing
    beq   +

    lda   screen_rows_mul_table_buffer2 + 1,x
    sta   back_buffer_temp + 2
    lda   screen_rows_mul_table_buffer2,x
    jmp   gibsp_1
+
    lda   screen_rows_mul_table_buffer1 + 1,x
    sta   back_buffer_temp + 2
    lda   screen_rows_mul_table_buffer1,x
gibsp_1
    clc
gibadc
    adc   #$00
    bcc   +
    inc   back_buffer_temp + 2
+   
    sta   back_buffer_temp + 1

    ;byt $f2

    ;DEBUG to screen the x
    ;lda    $d8     ;get sprite pixel x
    ;and    #$03
    ;clc
    ;adc    #zero_digit_offset_in_charset
    ;sta    screen_mem_buffer1 + 26   ;DEBUG
    ;sta    screen_mem_buffer2 + 26 
    
    lda   #$00
    sta   $d0   ;composite behavior bits final result
    
    ; shift of background chars based on half char x
    lda   $d8   ;sprite pixel x pos
    and   #$02
    clc
body_part_compensation_offset
    adc   #$04  ;body part compensation (4 bytes (2 pointers/body part) 
    tax
    lda   player_background_character_indexes_ptr, x
    sta   base_body_chars_index_table + 1
    lda   player_background_character_indexes_ptr + 1,x
    sta   base_body_chars_index_table + 2
    

sprite_shift_right_in_frame
    
    lda   #$07
    sta   $d7   ;default shift y in char for MIN search
    
    ;check chars and build behavior bitmask from characters
    ldy   #$00
-
base_body_chars_index_table
    ldx   $cccc, y
    cpx   #$ff
    beq   ++    ;no more characters to check
back_buffer_temp

    lda   $8888, x
    sta   last_character_body_chars, y
    ;sta    screen_mem_buffer1,y  ;DEBUG
    ;sta    screen_mem_buffer2,y  ;DEBUG
    tax
    lda   $d0
    ora   character_behavior_table, x
    ;sta    screen_mem_buffer1 + 40,y   ;DEBUG
    ;sta    screen_mem_buffer2 + 40,y   ;DEBUG
    sta   $d0
    
    lda   platform_shift_y_table, x
    cmp   $d7
    bcs   +
    sta   $d7   ;store when platform shift is bigger than current... search min 
+   
    iny
    ;cpy    #$04  ;how many characters do we need to check?
    bne   -
++

    ;DEBUG to screen the allowed y offset
    ;lda    $d7
    ;clc
    ;adc    #zero_digit_offset_in_charset
    ;sta    screen_mem_buffer1 + 34   ;DEBUG
    ;sta    screen_mem_buffer2 + 34 
    
    ;!BYTE  $f2
    lda   $d9   ;body part
    cmp   #body_area_feet
    beq   y_pos_compensation ;compensate player y pos when standing on a platform

    lda   $d0 ; just return the bitmask for body check
    rts
        
y_pos_compensation    
    lda   $d0
    and   #character_behavior_platform
    bne   + ;jump when platform
    
    lda   $d0 ; return found behavior mask
    rts
+
;   !BYTE $F2
    lda   $d1
    and   #$07
    cmp   $d7
    bcc   + ;our current y shift is smaller  than we need... fall more
    bcs   ++ ;our leg is deeper in the ground than allowed... shift up
    
    lda   $d0; return behavior found
    rts
+   
    ;remove platform and ladder bit
    lda   $d0
    and   #character_behavior_platform_remove_bit
    ;and    #character_behavior_ladder_remove_bit
    rts

++   ; move sprite up, it is too deep in ground
    ; d7 is the allowed y shift inside the char.. use that for real y coordinate

    lda   $d1   ;sprite y
    and   #$f8
    ora   $d7 ;set allowed y shift MIN value
    ldx   $d4
    sta   sprite_manifests + 1, x   ;write back to sprite y pos
    
  
    lda   $d0   ;return original behavior finding
    rts

last_character_body_chars
    !FILL   sprite_char_buffer_size,0


body_area_feet      = 0
player_feet_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 1) * 40 + 0, (sprite_frame_height_char - 1) * 40 + 1, 255;lower part of bg buffer char indexes
player_feet_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 1) * 40 + 1, (sprite_frame_height_char - 1) * 40 + 2, 255 ;lower part of bg buffer char indexes

body_area_body      = 1
player_body_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 2) * 40 + 0, (sprite_frame_height_char - 2) * 40 + 1
    !BYTE (sprite_frame_height_char - 3) * 40 + 0, (sprite_frame_height_char - 3) * 40 + 1
    ;!BYTE (sprite_frame_height_char - 4) * 40 + 0, (sprite_frame_height_char - 4) * 40 + 1
    !BYTE 255;lower part of bg buffer char indexes
player_body_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 2) * 40 + 1, (sprite_frame_height_char - 2) * 40 + 2
    !BYTE (sprite_frame_height_char - 3) * 40 + 1, (sprite_frame_height_char - 3) * 40 + 2
    ;!BYTE (sprite_frame_height_char - 4) * 40 + 1, (sprite_frame_height_char - 4) * 40 + 2
    !BYTE 255;lower part of bg buffer char indexes

body_area_head      = 2
player_head_character_indexes0 ;(left x) 
    !BYTE  0,  1, 255;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
player_head_character_indexes1 ;(right x)
    !BYTE 1,   2, 255 ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

body_area_left      = 3
player_left_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 1) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
player_left_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 1) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

body_area_right     = 4
player_right_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 1) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
player_right_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 1) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

body_area_left_kick_prep      = 5
player_left_kick_prep_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 3) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 - 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 - 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 - 3   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
player_left_kick_prep_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 3) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 - 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 - 2   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

body_area_right_kick_prep     = 6
player_right_kick_prep_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 3) * 40 + 1   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 3   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 4   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
player_right_kick_prep_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 3) * 40 + 2   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 3   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 4   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 + 5   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

body_area_left_ninja      = 7
body_area_left_sumo     = 7
ninja_left_character_indexes0 ;(left x) 
    !BYTE (sprite_frame_height_char - 1) * 40 -1    ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 -1    ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 3) * 40 -1    ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 -1    ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes
ninja_left_character_indexes1 ;(right x)
    !BYTE (sprite_frame_height_char - 1) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 2) * 40 + 0   ;lower part of bg buffer char indexes

    !BYTE (sprite_frame_height_char - 3) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE (sprite_frame_height_char - 4) * 40 + 0   ;lower part of bg buffer char indexes
    !BYTE 255;lower part of bg buffer char indexes

player_background_character_indexes_ptr
    !WORD player_feet_character_indexes0, player_feet_character_indexes1
    !WORD player_body_character_indexes0, player_body_character_indexes1
    !WORD player_head_character_indexes0, player_head_character_indexes1
    !WORD player_left_character_indexes0, player_left_character_indexes1
    !WORD player_right_character_indexes0, player_right_character_indexes1
    !WORD player_left_kick_prep_character_indexes0, player_left_kick_prep_character_indexes1
    !WORD player_right_kick_prep_character_indexes0, player_right_kick_prep_character_indexes1
    !WORD ninja_left_character_indexes0, ninja_left_character_indexes1

character_behavior_platform           = $80
character_behavior_platform_remove_bit      = $7f
character_behavior_ladder           = $40
character_behavior_ladder_remove_bit      = $bf
character_behavior_wall             = $20
character_behavior_wall_remove_bit        = $df
character_behavior_warp             = $10
character_behavior_lamp             = $08
character_behavior_kill             = $04
character_behavior_conveyor           = $02
character_behavior_bush_root          = $01

character_behavior_table
    ; each byte represents the char code -> behavior mapping with bit combinations
    !BYTE 0,0,0,0,character_behavior_platform,character_behavior_platform,character_behavior_wall,(character_behavior_ladder + character_behavior_conveyor),character_behavior_wall,character_behavior_wall,0,0,0,0,character_behavior_bush_root,character_behavior_ladder
cbt16:  !BYTE character_behavior_ladder,0,character_behavior_platform,0,0,0,0,0,0,0,0,0,0,character_behavior_platform,character_behavior_platform,character_behavior_platform
cbt32:  !BYTE 0,0,character_behavior_platform,character_behavior_platform,0,0,0,0,0,character_behavior_platform,0,0, character_behavior_wall, character_behavior_platform,character_behavior_wall,0
cbt48:  !BYTE 0,character_behavior_platform, character_behavior_platform, character_behavior_platform, character_behavior_platform, 0,character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall, character_behavior_wall
cbt64:  !BYTE character_behavior_wall, character_behavior_wall,0,(character_behavior_ladder),(character_behavior_ladder),(character_behavior_ladder),0,character_behavior_kill,0,0,character_behavior_bush_root,character_behavior_bush_root,(character_behavior_wall),(character_behavior_wall ),(character_behavior_wall ),(character_behavior_wall )
cbt80:  !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,character_behavior_platform,character_behavior_platform,(character_behavior_ladder + character_behavior_platform)
cbt96:  !BYTE (character_behavior_ladder + character_behavior_platform),(character_behavior_ladder + character_behavior_platform),(character_behavior_ladder + character_behavior_platform),character_behavior_platform,0,0,0,0,0,character_behavior_warp,character_behavior_warp,character_behavior_warp,character_behavior_warp,character_behavior_lamp,character_behavior_lamp,character_behavior_lamp
cbt112: !BYTE character_behavior_lamp,character_behavior_lamp,character_behavior_lamp,character_behavior_lamp,character_behavior_lamp,0,0,0,0,0,0,0,0,0,0,0
cbt128: !BYTE 0,0,character_behavior_kill,0,character_behavior_wall,character_behavior_platform,character_behavior_platform,character_behavior_platform,character_behavior_platform,0,0,(character_behavior_ladder + character_behavior_conveyor),(character_behavior_ladder + character_behavior_conveyor),(character_behavior_ladder + character_behavior_conveyor),(character_behavior_ladder + character_behavior_conveyor),(character_behavior_ladder + character_behavior_conveyor)

cbt144: !BYTE (character_behavior_ladder + character_behavior_conveyor),character_behavior_platform,0,0,character_behavior_platform,0,character_behavior_platform,0,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill
cbt160: !BYTE character_behavior_kill,character_behavior_kill,character_behavior_kill,(character_behavior_platform + character_behavior_wall),(character_behavior_platform + character_behavior_wall),(character_behavior_wall),(character_behavior_wall),character_behavior_ladder,0,0,0,0,0,0,0,0
cbt176: !BYTE character_behavior_platform,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill,character_behavior_kill
    !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

platform_shift_y_table
    ; each byte represents the char code -> y shift inside the plaform char (0-7)
    !BYTE 7,7,7,7,$5,$5,$5,7,7,7,7,7,7,7,7,7
psy16:  !BYTE 7,7,$5,7,7,7,7,7,7,7,7,7,7,$3,$3,$3
psy32:  !BYTE 7,7,$2,$2,7,7,7,7,7,$3,7,7,7,$3,7,7
psy48:  !BYTE 7,$2,$7,$5,$5,7,7,7,7,7,7,7,$0,$0,7,7
psy64:  !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
psy80:  !BYTE 7,7,$0,7,7,7,7,7,7,7,7,7,7,$5,$5,7
psy96:  !BYTE 7,7,7,$3,7,7,7,7,7,7,7,7,7,7,7,7
psy112: !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
psy128: !BYTE 7,7,7,$7,7,$7,$7,$0,$0,7,7,7,7,7,$0,7
psy144: !BYTE 7,$0,7,7,$0,7,$0,7,7,7,7,7,7,7,7,7
psy160: !BYTE 7,7,7,$0,$0,$0,$0,7,7,7,7,7,7,7,7,7
psy176: !BYTE $0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
    !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
    !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
    !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
    !BYTE 7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7

chars_with_fixed_color  ; the sprite will not disturb the colors of these characters
    !BYTE 0,0,0,0,$1,$1,0,$1,0,0,0,0,0,0,$1,0
fco16:  !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,$1,$1,$1
fco32:  !BYTE $1,$1,$1,$1,0,0,0,0,$1,$1,0,0,0,$1,0,0
fco48:  !BYTE $1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
fco64:  !BYTE $1,$1,0,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
fco80:  !BYTE $1,$1,$1,$1,$1,$1,$0,$0,0,$1,0,0,$1,$1,$1,0
fco96:  !BYTE 0,0,0,$1,0,$1,0,0,$1,0,0,0,0,0,0,0
fco112: !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fco128: !BYTE 0,0,$1,$0,$1,$1,$1,$1,$1,0,0,$1,$1,$1,$1,$1
fco144: !BYTE $1,$1,$1,$1,$1,0,$1,$1,0,0,0,0,0,0,0,0
fco160: !BYTE 0,0,0,0,0,0,0,$1,0,0,0,0,0,0,0,0
fco176: !BYTE $1,0,0,0,0,$1,0,$1,0,0,0,0,0,0,0,$1
fco192: !BYTE $1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
    !BYTE $1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
    !BYTE $1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
    !BYTE $1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1


sprite_manifests:

sprite1_data:
sprite1_data_x = sprite1_data
sprite1_data_y = sprite1_data + 1
sprite1_data_frame = sprite1_data + 2
sprite1_data_color = sprite1_data + 24
    !BYTE   41,80,01 ,$c0                   ; sprite1 x,y,frame index, color, char in charset 
    !BYTE 0,$fc                         ; pointer to saved characters behind the sprite - buffer 1
    !WORD sprite_back_buffer1 + sprite_char_buffer_size * 0   ; manifest record index 0
    !BYTE 0,$fc                         ; pointer to saved characters behind the sprite - buffer 2
    !WORD sprite_back_buffer2 + sprite_char_buffer_size * 0   ; manifest record index 0
    !BYTE 0,0                           ; pointer to "Color Disturbance Prevention" table (0,0) when none
    !BYTE 0                           ; color disturbance mode
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 1
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 2
    !BYTE 0,0,0,0,0,$ee
    !WORD sprite_color_conversion_table
    !BYTE 0,0,0,0,0
    
sprite2_data:
sprite2_data_x = sprite2_data
sprite2_data_y = sprite2_data + 1
sprite2_data_frame = sprite2_data + 2
sprite2_data_color = sprite2_data + 24
    !BYTE   21,40,01, $d4                   ;sprite1 x,y,frame index, color, char in charset
    !BYTE 0,$fc
    !WORD sprite_back_buffer1 + sprite_char_buffer_size * 1   ;manifest record index 1
    !BYTE 0,$fc
    !WORD sprite_back_buffer2 + sprite_char_buffer_size * 1   ;manifest record index 1
    !BYTE 0,0                           ; pointer to "Color Disturbance Prevention" table (0,0) when none
    !BYTE 0                           ; color disturbance mode
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 1
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 2
    !BYTE 0,0,0,0,0,$ee
    !WORD sprite_color_conversion_table2
    !BYTE 0,0,0,0,0

sprite3_data:
sprite3_data_x = sprite3_data
sprite3_data_y = sprite3_data + 1
sprite3_data_frame = sprite3_data + 2
sprite3_data_color = sprite3_data + 24
    !BYTE   120,123,01, $e8                   ;sprite1 x,y,frame index, color, char in charset
    !BYTE 0,$fc
    !WORD sprite_back_buffer1 + sprite_char_buffer_size * 2   ;manifest record index 2
    !BYTE 0,$fc
    !WORD sprite_back_buffer2 + sprite_char_buffer_size * 2   ;manifest record index 2
    !BYTE 0,0                           ; pointer to "Color Disturbance Prevention" table (0,0) when none
    !BYTE 0                           ; color disturbance mode
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 1
    !BYTE 0,0                           ; pointer to last used "sprite frame internal" offset table - buffer 2
    !BYTE 0,0,0,0,0,$ee
    !WORD sprite_color_conversion_table2
    !BYTE 0,0,0,0,0

; add more manifests here   
    
sprite_frame_width_by_image_index:
; 0 < (limited width) < sprite_frame_width_char (5)

frame_standing_right = 0
    !BYTE 3 * sprite_frame_height_char    ;frame image 0 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_standing_left = 1
    !BYTE 3 * sprite_frame_height_char    ;frame image 1 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_running_right = 2
    !BYTE 3 * sprite_frame_height_char    ;frame image 2 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_running_left = 3
    !BYTE 3 * sprite_frame_height_char    ;frame image 3 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jumping1_right = 4
    !BYTE 3 * sprite_frame_height_char    ;frame image 4 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jumping2_right = 5
    !BYTE 3 * sprite_frame_height_char    ;frame image 5 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jumping1_left = 6
    !BYTE 3 * sprite_frame_height_char    ;frame image 6 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jumping2_left = 7
    !BYTE 3 * sprite_frame_height_char    ;frame image 7 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jump1_up_right = 8
    !BYTE 3 * sprite_frame_height_char    ;frame image 8 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jump1_up_left = 9
    !BYTE 3 * sprite_frame_height_char    ;frame image 9 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jump2_up = 10
    !BYTE 3 * sprite_frame_height_char    ;frame image 10 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_jump3_up = 11
    !BYTE 3 * sprite_frame_height_char    ;frame image 11 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_box_right = 12
    !BYTE 4 * sprite_frame_height_char    ;frame image 12 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_box_left = 13
    !BYTE 4 * sprite_frame_height_char    ;frame image 13 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_kick1_left = 14
    !BYTE 3 * sprite_frame_height_char    ;frame image 14 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_kick2_left = 15
    !BYTE 5 * sprite_frame_height_char    ;frame image 15 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_kick1_right = 16
    !BYTE 3 * sprite_frame_height_char    ;frame image 16 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_kick2_right = 17
    !BYTE 5 * sprite_frame_height_char    ;frame image 17 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_lying_right = 18
    !BYTE 5 * sprite_frame_height_char    ;frame image 18 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_lying_left = 19
    !BYTE 5 * sprite_frame_height_char    ;frame image 19 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_climb1_up = 20
    !BYTE 3 * sprite_frame_height_char    ;frame image 20 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_climb2_up = 21
    !BYTE 3 * sprite_frame_height_char    ;frame image 20 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_empty_sprite = 22
    !BYTE 3 * sprite_frame_height_char    ;frame image 21 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_falling_left = 23
    !BYTE 3 * sprite_frame_height_char    ;frame image 22 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_falling_right = 24
    !BYTE 3 * sprite_frame_height_char    ;frame image 23 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_falling_left = 25
    !BYTE 3 * sprite_frame_height_char    ;frame image 22 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_falling_right = 26
    !BYTE 3 * sprite_frame_height_char    ;frame image 23 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_running_left = 27
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_running_right = 28
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_running_left = 29
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_running_right = 30
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_standing_left = 31
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_standing_right = 32
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_standing_left = 33
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_standing_right = 34
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_shout_left = 35
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_shout_right = 36
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_kick1_left = 37
    !BYTE 3 * sprite_frame_height_char    ;frame image 24 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_kick1_right = 38
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_kick2_left = 39
    !BYTE 5 * sprite_frame_height_char    ;frame image 24 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_sumo_kick2_right = 40
    !BYTE 5 * sprite_frame_height_char    ;frame image 25 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_ninja_attack1_left = 41
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_attack1_right = 42
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_attack2_left = 43
    !BYTE 5 * sprite_frame_height_char    ;frame image 26 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_ninja_attack2_right = 44
    !BYTE 5 * sprite_frame_height_char    ;frame image 26 is 5 characters widht (4 chars width real image, 1 char shift buffer)
frame_sumo_box_left = 45
    !BYTE 4 * sprite_frame_height_char    ;frame image 27 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_sumo_box_right = 46
    !BYTE 4 * sprite_frame_height_char    ;frame image 25 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_sumo_climb_up1 = 47
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_sumo_climb_up2 = 48
    !BYTE 3 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_climb_up1 = 49
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_climb_up2 = 50
    !BYTE 3 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_pain_drop_left = 51
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_pain_drop_right = 52
    !BYTE 3 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_knocked_down_left = 53
    !BYTE 5 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (4 chars width real image, 1 char shift buffer)
frame_knocked_down_right = 54
    !BYTE 5 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (4 chars width real image, 1 char shift buffer)
frame_sumo_knocked_down_left = 55
    !BYTE 4 * sprite_frame_height_char    ;frame image 26 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_sumo_knocked_down_right = 56
    !BYTE 4 * sprite_frame_height_char    ;frame image 27 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_ninja_knocked_down_left = 57
    !BYTE 4 * sprite_frame_height_char    ;frame image 25 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_ninja_knocked_down_right = 58
    !BYTE 4 * sprite_frame_height_char    ;frame image 26 is 4 characters widht (3 chars width real image, 1 char shift buffer)
frame_ninja_pain_drop_left = 59
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
frame_ninja_pain_drop_right = 60
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
    !BYTE 3 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (2 chars width real image, 1 char shift buffer)
    !BYTE 3 * sprite_frame_height_char    ;frame image 25 is 3 characters widht (2 chars width real image, 1 char shift buffer)
    !BYTE 3 * sprite_frame_height_char    ;frame image 26 is 3 characters widht (2 chars width real image, 1 char shift buffer)
    !BYTE 3 * sprite_frame_height_char    ;frame image 27 is 3 characters widht (2 chars width real image, 1 char shift buffer)
    
sprite_frames:
    !WORD bruce_standing_right_frame1; pointer to frames
    !WORD bruce_standing_right_frame1; pointer to frames
    !WORD bruce_standing_right_frame2; pointer to frames
    !WORD bruce_standing_right_frame2; pointer to frames

    !WORD bruce_standing_left_frame1; pointer to frames
    !WORD bruce_standing_left_frame1; pointer to frames
    !WORD bruce_standing_left_frame2; pointer to frames
    !WORD bruce_standing_left_frame2; pointer to frames
    
    !WORD bruce_running_right_frame1; pointer to frames
    !WORD bruce_running_right_frame1; pointer to frames
    !WORD bruce_running_right_frame2; pointer to frames
    !WORD bruce_running_right_frame2; pointer to frames

    !WORD bruce_running_left_frame1; pointer to frames
    !WORD bruce_running_left_frame1; pointer to frames
    !WORD bruce_running_left_frame2; pointer to frames
    !WORD bruce_running_left_frame2; pointer to frames

    !WORD bruce_jumping1_right_frame1; pointer to frames
    !WORD bruce_jumping1_right_frame1; pointer to frames
    !WORD bruce_jumping1_right_frame2; pointer to frames
    !WORD bruce_jumping1_right_frame2; pointer to frames

    !WORD bruce_jumping2_right_frame1; pointer to frames
    !WORD bruce_jumping2_right_frame1; pointer to frames
    !WORD bruce_jumping2_right_frame2; pointer to frames
    !WORD bruce_jumping2_right_frame2; pointer to frames

    !WORD bruce_jumping1_left_frame1; pointer to frames
    !WORD bruce_jumping1_left_frame1; pointer to frames
    !WORD bruce_jumping1_left_frame2; pointer to frames
    !WORD bruce_jumping1_left_frame2; pointer to frames

    !WORD bruce_jumping2_left_frame1; pointer to frames
    !WORD bruce_jumping2_left_frame1; pointer to frames
    !WORD bruce_jumping2_left_frame2; pointer to frames
    !WORD bruce_jumping2_left_frame2; pointer to frames
    
    !WORD bruce_jump1_right_up_frame1
    !WORD bruce_jump1_right_up_frame1
    !WORD bruce_jump1_right_up_frame2
    !WORD bruce_jump1_right_up_frame2

    !WORD bruce_jump1_left_up_frame1
    !WORD bruce_jump1_left_up_frame1
    !WORD bruce_jump1_left_up_frame2
    !WORD bruce_jump1_left_up_frame2

    !WORD bruce_jump2_up_frame1
    !WORD bruce_jump2_up_frame1
    !WORD bruce_jump2_up_frame2
    !WORD bruce_jump2_up_frame2

    !WORD bruce_jump3_up_frame1
    !WORD bruce_jump3_up_frame1
    !WORD bruce_jump3_up_frame2
    !WORD bruce_jump3_up_frame2
    
    !WORD bruce_box_right_frame1
    !WORD bruce_box_right_frame1
    !WORD bruce_box_right_frame2
    !WORD bruce_box_right_frame2

    !WORD bruce_box_left_frame1
    !WORD bruce_box_left_frame1
    !WORD bruce_box_left_frame2
    !WORD bruce_box_left_frame2

    !WORD bruce_kick1_left_frame1; pointer to frames
    !WORD bruce_kick1_left_frame1; pointer to frames
    !WORD bruce_kick1_left_frame2; pointer to frames
    !WORD bruce_kick1_left_frame2; pointer to frames

    !WORD bruce_kick2_left_frame1; pointer to frames
    !WORD bruce_kick2_left_frame2; pointer to frames
    !WORD bruce_kick2_left_frame3; pointer to frames
    !WORD bruce_kick2_left_frame4; pointer to frames

    !WORD bruce_kick1_right_frame1; pointer to frames
    !WORD bruce_kick1_right_frame1; pointer to frames
    !WORD bruce_kick1_right_frame2; pointer to frames
    !WORD bruce_kick1_right_frame2; pointer to frames

    !WORD bruce_kick2_right_frame1; pointer to frames
    !WORD bruce_kick2_right_frame2; pointer to frames
    !WORD bruce_kick2_right_frame3; pointer to frames
    !WORD bruce_kick2_right_frame4; pointer to frames

    !WORD bruce_lying_right_frame1
    !WORD bruce_lying_right_frame1
    !WORD bruce_lying_right_frame2
    !WORD bruce_lying_right_frame2

    !WORD bruce_lying_left_frame1
    !WORD bruce_lying_left_frame1
    !WORD bruce_lying_left_frame2
    !WORD bruce_lying_left_frame2

    !WORD bruce_climb_up1_frame1; pointer to frames
    !WORD bruce_climb_up1_frame1; pointer to frames
    !WORD bruce_climb_up1_frame2; pointer to frames
    !WORD bruce_climb_up1_frame2; pointer to frames

    !WORD bruce_climb_up2_frame1; pointer to frames
    !WORD bruce_climb_up2_frame1; pointer to frames
    !WORD bruce_climb_up2_frame2; pointer to frames
    !WORD bruce_climb_up2_frame2; pointer to frames
    
    !WORD empty_sprite_frame1; pointer to frames
    !WORD empty_sprite_frame1; pointer to frames
    !WORD empty_sprite_frame2; pointer to frames
    !WORD empty_sprite_frame2; pointer to frames

    !WORD ninja_falling_left_frame1
    !WORD ninja_falling_left_frame1
    !WORD ninja_falling_left_frame2
    !WORD ninja_falling_left_frame2

    !WORD ninja_falling_right_frame1
    !WORD ninja_falling_right_frame1
    !WORD ninja_falling_right_frame2
    !WORD ninja_falling_right_frame2
    
    !WORD sumo_falling_left_frame1
    !WORD sumo_falling_left_frame1
    !WORD sumo_falling_left_frame2
    !WORD sumo_falling_left_frame2

    !WORD sumo_falling_right_frame1
    !WORD sumo_falling_right_frame1
    !WORD sumo_falling_right_frame2
    !WORD sumo_falling_right_frame2

    !WORD ninja_running_left_frame1
    !WORD ninja_running_left_frame1
    !WORD ninja_running_left_frame2
    !WORD ninja_running_left_frame2

    !WORD ninja_running_right_frame1
    !WORD ninja_running_right_frame1
    !WORD ninja_running_right_frame2
    !WORD ninja_running_right_frame2

    !WORD sumo_running_left_frame1
    !WORD sumo_running_left_frame1
    !WORD sumo_running_left_frame2
    !WORD sumo_running_left_frame2

    !WORD sumo_running_right_frame1
    !WORD sumo_running_right_frame1
    !WORD sumo_running_right_frame2
    !WORD sumo_running_right_frame2

    !WORD ninja_standing_left_frame1
    !WORD ninja_standing_left_frame1
    !WORD ninja_standing_left_frame2
    !WORD ninja_standing_left_frame2

    !WORD ninja_standing_right_frame1
    !WORD ninja_standing_right_frame1
    !WORD ninja_standing_right_frame2
    !WORD ninja_standing_right_frame2

    !WORD sumo_standing_left_frame1
    !WORD sumo_standing_left_frame1
    !WORD sumo_standing_left_frame2
    !WORD sumo_standing_left_frame2

    !WORD sumo_standing_right_frame1
    !WORD sumo_standing_right_frame1
    !WORD sumo_standing_right_frame2
    !WORD sumo_standing_right_frame2

    !WORD sumo_shout_left_frame1
    !WORD sumo_shout_left_frame1
    !WORD sumo_shout_left_frame2
    !WORD sumo_shout_left_frame2

    !WORD sumo_shout_right_frame1
    !WORD sumo_shout_right_frame1
    !WORD sumo_shout_right_frame2
    !WORD sumo_shout_right_frame2
    
    !WORD sumo_kick1_left_frame1
    !WORD sumo_kick1_left_frame1
    !WORD sumo_kick1_left_frame2
    !WORD sumo_kick1_left_frame2

    !WORD sumo_kick1_right_frame1
    !WORD sumo_kick1_right_frame1
    !WORD sumo_kick1_right_frame2
    !WORD sumo_kick1_right_frame2
  
    !WORD sumo_kick2_left_frame1
    !WORD sumo_kick2_left_frame2
    !WORD sumo_kick2_left_frame3
    !WORD sumo_kick2_left_frame4

    !WORD sumo_kick2_right_frame1
    !WORD sumo_kick2_right_frame2
    !WORD sumo_kick2_right_frame3
    !WORD sumo_kick2_right_frame4
    
    !WORD ninja_attack1_left_frame1
    !WORD ninja_attack1_left_frame1
    !WORD ninja_attack1_left_frame2
    !WORD ninja_attack1_left_frame2

    !WORD ninja_attack1_right_frame1
    !WORD ninja_attack1_right_frame1
    !WORD ninja_attack1_right_frame2
    !WORD ninja_attack1_right_frame2

    !WORD ninja_attack2_left_frame1
    !WORD ninja_attack2_left_frame2
    !WORD ninja_attack2_left_frame3
    !WORD ninja_attack2_left_frame4

    !WORD ninja_attack2_right_frame1
    !WORD ninja_attack2_right_frame2
    !WORD ninja_attack2_right_frame3
    !WORD ninja_attack2_right_frame4

    !WORD sumo_box_left_frame1
    !WORD sumo_box_left_frame1
    !WORD sumo_box_left_frame2
    !WORD sumo_box_left_frame2

    !WORD sumo_box_right_frame1
    !WORD sumo_box_right_frame1
    !WORD sumo_box_right_frame2
    !WORD sumo_box_right_frame2

    !WORD sumo_climb_up1_frame1
    !WORD sumo_climb_up1_frame1
    !WORD sumo_climb_up1_frame2
    !WORD sumo_climb_up1_frame2
    
    !WORD sumo_climb_up2_frame1
    !WORD sumo_climb_up2_frame1
    !WORD sumo_climb_up2_frame2
    !WORD sumo_climb_up2_frame2
    
    !WORD ninja_climb_up1_frame1
    !WORD ninja_climb_up1_frame1
    !WORD ninja_climb_up1_frame2
    !WORD ninja_climb_up1_frame2
    
    !WORD ninja_climb_up2_frame1
    !WORD ninja_climb_up2_frame1
    !WORD ninja_climb_up2_frame2
    !WORD ninja_climb_up2_frame2
    
    !WORD bruce_pain_drop1_left_frame1
    !WORD bruce_pain_drop1_left_frame1
    !WORD bruce_pain_drop1_left_frame2
    !WORD bruce_pain_drop1_left_frame2

    !WORD bruce_pain_drop1_right_frame1
    !WORD bruce_pain_drop1_right_frame1
    !WORD bruce_pain_drop1_right_frame2
    !WORD bruce_pain_drop1_right_frame2
    
    !WORD bruce_knocked_down_left_frame1
    !WORD bruce_knocked_down_left_frame2
    !WORD bruce_knocked_down_left_frame3
    !WORD bruce_knocked_down_left_frame4

    !WORD bruce_knocked_down_right_frame1
    !WORD bruce_knocked_down_right_frame2
    !WORD bruce_knocked_down_right_frame3
    !WORD bruce_knocked_down_right_frame4
    
    !WORD sumo_knocked_down_left_frame1
    !WORD sumo_knocked_down_left_frame1
    !WORD sumo_knocked_down_left_frame2
    !WORD sumo_knocked_down_left_frame2

    !WORD sumo_knocked_down_right_frame1
    !WORD sumo_knocked_down_right_frame1
    !WORD sumo_knocked_down_right_frame2
    !WORD sumo_knocked_down_right_frame2
    
    !WORD ninja_knocked_down_left_frame1
    !WORD ninja_knocked_down_left_frame1
    !WORD ninja_knocked_down_left_frame2
    !WORD ninja_knocked_down_left_frame2

    !WORD ninja_knocked_down_right_frame1
    !WORD ninja_knocked_down_right_frame1
    !WORD ninja_knocked_down_right_frame2
    !WORD ninja_knocked_down_right_frame2
  
    !WORD ninja_pain_drop_left_frame1
    !WORD ninja_pain_drop_left_frame1
    !WORD ninja_pain_drop_left_frame2
    !WORD ninja_pain_drop_left_frame2

    !WORD ninja_pain_drop_right_frame1
    !WORD ninja_pain_drop_right_frame1
    !WORD ninja_pain_drop_right_frame2
    !WORD ninja_pain_drop_right_frame2

sprite_frames_ptr
    !WORD sprite_frames, sprite_frames + (1*8), sprite_frames + (2*8), sprite_frames + (3*8), sprite_frames + (4*8), sprite_frames + (5*8), sprite_frames + (6*8), sprite_frames + (7*8), sprite_frames + (8*8), sprite_frames + (9*8)
    !WORD sprite_frames + (10*8), sprite_frames + (11*8), sprite_frames + (12*8), sprite_frames + (13*8), sprite_frames + (14*8), sprite_frames + (15*8), sprite_frames + (16*8), sprite_frames + (17*8), sprite_frames + (18*8), sprite_frames + (19*8)
    !WORD sprite_frames + (20*8), sprite_frames + (21*8), sprite_frames + (22*8), sprite_frames + (23*8), sprite_frames + (24*8), sprite_frames + (25*8), sprite_frames + (26*8), sprite_frames + (27*8), sprite_frames + (28*8), sprite_frames + (29*8)
    !WORD sprite_frames + (30*8), sprite_frames + (31*8), sprite_frames + (32*8), sprite_frames + (33*8), sprite_frames + (34*8), sprite_frames + (35*8), sprite_frames + (36*8), sprite_frames + (37*8), sprite_frames + (38*8), sprite_frames + (39*8)
    !WORD sprite_frames + (40*8), sprite_frames + (41*8), sprite_frames + (42*8), sprite_frames + (43*8), sprite_frames + (44*8), sprite_frames + (45*8), sprite_frames + (46*8), sprite_frames + (47*8), sprite_frames + (48*8), sprite_frames + (49*8)
    !WORD sprite_frames + (50*8), sprite_frames + (51*8), sprite_frames + (52*8), sprite_frames + (53*8), sprite_frames + (54*8), sprite_frames + (55*8), sprite_frames + (56*8), sprite_frames + (57*8), sprite_frames + (58*8), sprite_frames + (59*8)
    !WORD sprite_frames + (60*8), sprite_frames + (61*8), sprite_frames + (62*8), sprite_frames + (63*8), sprite_frames + (64*8), sprite_frames + (65*8), sprite_frames + (66*8), sprite_frames + (67*8), sprite_frames + (68*8), sprite_frames + (69*8)
    !WORD sprite_frames + (70*8), sprite_frames + (71*8), sprite_frames + (72*8), sprite_frames + (73*8), sprite_frames + (74*8), sprite_frames + (75*8), sprite_frames + (76*8), sprite_frames + (77*8), sprite_frames + (78*8), sprite_frames + (79*8)
    !WORD sprite_frames + (80*8), sprite_frames + (81*8), sprite_frames + (82*8), sprite_frames + (83*8), sprite_frames + (84*8), sprite_frames + (85*8), sprite_frames + (86*8), sprite_frames + (87*8), sprite_frames + (88*8), sprite_frames + (89*8)

sprite_frame_internal_offset: ; correct, when sprite_frame_width_char or sprite_frame_height_char is canged
    !BYTE   0,40,80,120
    !BYTE   1,41,81,121
    !BYTE   2,42,82,122
    !BYTE   3,43,83,123
    !BYTE   4,44,84,124

sprite_frame_mask:      ;0 means put that position back to screen, FF means, skip byte
    !BYTE   0,0,0,0
    !BYTE   0,0,0,0
    !BYTE   0,0,0,0
    !BYTE   0,0,0,0
    !BYTE   0,0,0,0

sprite_frame_mask_minus1: ;0 means put that position back to screen, FF means, skip byte
    !BYTE   255,0,0,0
    !BYTE   255,0,0,0
    !BYTE   255,0,0,0
    !BYTE   255,0,0,0
    !BYTE   255,0,0,0

sprite_frame_mask_minus2: ;0 means put that position back to screen, FF means, skip byte
    !BYTE   255,255,0,0
    !BYTE   255,255,0,0
    !BYTE   255,255,0,0
    !BYTE   255,255,0,0
    !BYTE   255,255,0,0

sprite_frame_mask_minus3: ;0 means put that position back to screen, FF means, skip byte
    !BYTE   255,255,255,0
    !BYTE   255,255,255,0
    !BYTE   255,255,255,0
    !BYTE   255,255,255,0
    !BYTE   255,255,255,0

sprite_frame_mask_bottom1:  ;0 means put that position back to screen, FF means, skip byte
    !BYTE   0,0,0,255
    !BYTE   0,0,0,255
    !BYTE   0,0,0,255
    !BYTE   0,0,0,255
    !BYTE   0,0,0,255

sprite_frame_mask_bottom2:  ;0 means put that position back to screen, FF means, skip byte
    !BYTE   0,0,255,255
    !BYTE   0,0,255,255
    !BYTE   0,0,255,255
    !BYTE   0,0,255,255
    !BYTE   0,0,255,255

sprite_frame_mask_bottom3:  ;0 means put that position back to screen, FF means, skip byte
    !BYTE   0,255,255,255
    !BYTE   0,255,255,255
    !BYTE   0,255,255,255
    !BYTE   0,255,255,255
    !BYTE   0,255,255,255
        
sprite_frame_masks_by_rows:
    ;negative rows
    !WORD sprite_frame_mask_minus3, sprite_frame_mask_minus3, sprite_frame_mask_minus2

    ;normals masks for on-scrren rows
    !WORD sprite_frame_mask_minus1, sprite_frame_mask_minus1, sprite_frame_mask, sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask
    !WORD sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask,sprite_frame_mask
    !WORD sprite_frame_mask, sprite_frame_mask
    ;bottom rows
    !WORD sprite_frame_mask_bottom1, sprite_frame_mask_bottom2, sprite_frame_mask_bottom3, sprite_frame_mask_bottom3, sprite_frame_mask_bottom3, sprite_frame_mask_bottom3, sprite_frame_mask_bottom3
    
sprite_back_buffer1:
    !FILL   number_of_sprite_manifests * sprite_char_buffer_size,0  ;reserve back buffer for sprites (4*5 chars for each manifest for 2 buffers
sprite_back_buffer2:
    !FILL   number_of_sprite_manifests * sprite_char_buffer_size,0  ;reserve back buffer for sprites (4*5 chars for each manifest for 2 buffers
sprite_color_correction_buffer:
    !FILL   sprite_char_buffer_size * 8,0   ;reserve buffer for color avoidance

mask_table:     ;multicolor masking table    
    !BYTE   $ff,$fc,$fc,$fc,$f3,$f0,$f0,$f0,$f3,$f0,$f0,$f0,$f3,$f0,$f0,$f0
    !BYTE   $cf,$cc,$cc,$cc,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0
    !BYTE   $cf,$cc,$cc,$cc,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0
    !BYTE   $cf,$cc,$cc,$cc,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0,$c3,$c0,$c0,$c0
    !BYTE   $3f,$3c,$3c,$3c,$33,$30,$30,$30,$33,$30,$30,$30,$33,$30,$30,$30
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $3f,$3c,$3c,$3c,$33,$30,$30,$30,$33,$30,$30,$30,$33,$30,$30,$30
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $3f,$3c,$3c,$3c,$33,$30,$30,$30,$33,$30,$30,$30,$33,$30,$30,$30
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00
    !BYTE   $0f,$0c,$0c,$0c,$03,$00,$00,$00,$03,$00,$00,$00,$03,$00,$00,$00

sprite_color_conversion_table ;1-1 mapping of bytes and the converted counterparts  11 -> 10
    !BYTE   $00,$01,$02,$02,$04,$05,$06,$06,$08,$09,$0a,$0a,$08,$09,$0a,$0a
    !BYTE   $10,$11,$12,$12,$14,$15,$16,$16,$18,$19,$1a,$1a,$18,$19,$1a,$1a
    !BYTE   $20,$21,$22,$22,$24,$25,$26,$26,$28,$29,$2a,$2a,$28,$29,$2a,$2a
    !BYTE   $20,$21,$22,$22,$24,$25,$26,$26,$28,$29,$2a,$2a,$28,$29,$2a,$2a
    !BYTE   $40,$41,$42,$42,$44,$45,$46,$46,$48,$49,$4a,$4a,$48,$49,$4a,$4a
    !BYTE   $50,$51,$52,$52,$54,$55,$56,$56,$58,$59,$5a,$5a,$58,$59,$5a,$5a
    !BYTE   $60,$61,$62,$62,$64,$65,$66,$66,$68,$69,$6a,$6a,$68,$69,$6a,$6a
    !BYTE   $60,$61,$62,$62,$64,$65,$66,$66,$68,$69,$6a,$6a,$68,$69,$6a,$6a
    !BYTE   $80,$81,$82,$82,$84,$85,$86,$86,$88,$89,$8a,$8a,$88,$89,$8a,$8a
    !BYTE   $90,$91,$92,$92,$94,$95,$96,$96,$98,$99,$9a,$9a,$98,$99,$9a,$9a
    !BYTE   $a0,$a1,$a2,$a2,$a4,$a5,$a6,$a6,$a8,$a9,$aa,$aa,$a8,$a9,$aa,$aa
    !BYTE   $a0,$a1,$a2,$a2,$a4,$a5,$a6,$a6,$a8,$a9,$aa,$aa,$a8,$a9,$aa,$aa
    !BYTE   $80,$81,$82,$82,$84,$85,$86,$86,$88,$89,$8a,$8a,$88,$89,$8a,$8a
    !BYTE   $90,$91,$92,$92,$94,$95,$96,$96,$98,$99,$9a,$9a,$98,$99,$9a,$9a
    !BYTE   $a0,$a1,$a2,$a2,$a4,$a5,$a6,$a6,$a8,$a9,$aa,$aa,$a8,$a9,$aa,$aa
    !BYTE   $a0,$a1,$a2,$a2,$a4,$a5,$a6,$a6,$a8,$a9,$aa,$aa,$a8,$a9,$aa,$aa

sprite_color_conversion_table2 ;1-1 mapping of bytes and the converted counterparts  11 -> 01
    !BYTE   $00,$01,$02,$01,$04,$05,$06,$05,$08,$09,$0a,$09,$04,$05,$06,$05
    !BYTE   $10,$11,$12,$11,$14,$15,$16,$15,$18,$19,$1a,$19,$14,$15,$16,$15
    !BYTE   $20,$21,$22,$21,$24,$25,$26,$25,$28,$29,$2a,$29,$24,$25,$26,$25
    !BYTE   $10,$11,$12,$11,$14,$15,$16,$15,$18,$19,$1a,$19,$14,$15,$16,$15
    !BYTE   $40,$41,$42,$41,$44,$45,$46,$45,$48,$49,$4a,$49,$44,$45,$46,$45
    !BYTE   $50,$51,$52,$51,$54,$55,$56,$55,$58,$59,$5a,$59,$54,$55,$56,$55
    !BYTE   $60,$61,$62,$61,$64,$65,$66,$65,$68,$69,$6a,$69,$64,$65,$66,$65
    !BYTE   $50,$51,$52,$51,$54,$55,$56,$55,$58,$59,$5a,$59,$54,$55,$56,$55
    !BYTE   $80,$81,$82,$81,$84,$85,$86,$85,$88,$89,$8a,$89,$84,$85,$86,$85
    !BYTE   $90,$91,$92,$91,$94,$95,$96,$95,$98,$99,$9a,$99,$94,$95,$96,$95
    !BYTE   $a0,$a1,$a2,$a1,$a4,$a5,$a6,$a5,$a8,$a9,$aa,$a9,$a4,$a5,$a6,$a5
    !BYTE   $90,$91,$92,$91,$94,$95,$96,$95,$98,$99,$9a,$99,$94,$95,$96,$95
    !BYTE   $40,$41,$42,$41,$44,$45,$46,$45,$48,$49,$4a,$49,$44,$45,$46,$45
    !BYTE   $50,$51,$52,$51,$54,$55,$56,$55,$58,$59,$5a,$59,$54,$55,$56,$55
    !BYTE   $60,$61,$62,$61,$64,$65,$66,$65,$68,$69,$6a,$69,$64,$65,$66,$65
    !BYTE   $50,$51,$52,$51,$54,$55,$56,$55,$58,$59,$5a,$59,$54,$55,$56,$55

sprite_charset_mul_table_lo:
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
    !BYTE   $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$78,$80,$88,$90,$98,$a0,$a8,$b0,$b8,$c0,$c8,$d0,$d8,$e0,$e8,$f0,$f8
sprite_charset_mul_table_hi1:
    !BYTE (character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8),(character_set_mem_buffer1 >> 8)
    !BYTE (character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1,(character_set_mem_buffer1 >> 8) + 1
    !BYTE (character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2,(character_set_mem_buffer1 >> 8) + 2
    !BYTE (character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3,(character_set_mem_buffer1 >> 8) + 3
    !BYTE (character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4,(character_set_mem_buffer1 >> 8) + 4
    !BYTE (character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5,(character_set_mem_buffer1 >> 8) + 5
    !BYTE (character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6,(character_set_mem_buffer1 >> 8) + 6
    !BYTE (character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7,(character_set_mem_buffer1 >> 8) + 7
sprite_charset_mul_table_hi2: 
    !BYTE (character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8),(character_set_mem_buffer2 >> 8)
    !BYTE (character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1,(character_set_mem_buffer2 >> 8) + 1
    !BYTE (character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2,(character_set_mem_buffer2 >> 8) + 2
    !BYTE (character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3,(character_set_mem_buffer2 >> 8) + 3
    !BYTE (character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4,(character_set_mem_buffer2 >> 8) + 4
    !BYTE (character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5,(character_set_mem_buffer2 >> 8) + 5
    !BYTE (character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6,(character_set_mem_buffer2 >> 8) + 6
    !BYTE (character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7,(character_set_mem_buffer2 >> 8) + 7
  
screen_rows_mul_table_buffer1: ; 40x multiplication table for 25 rows - with buffer 1 address
    
    ;support for seamless frame support - create as many "negative" rows as high the sprite character buffer is
    !WORD     screen_mem_buffer1 - (3 * 40) - (sprite_frame_width_char - 1)
    !WORD     screen_mem_buffer1 - (2 * 40) - (sprite_frame_width_char - 1)
    !WORD     screen_mem_buffer1 - (1 * 40) - (sprite_frame_width_char - 1)
    
    ;for visible rows:
    !WORD     (0 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (1 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (2 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (3 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (4 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (5 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (6 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (7 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (8 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (9 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (10 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (11 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (12 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (13 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (14 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (15 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (16 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (17 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (18 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (19 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (20 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (21 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (22 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (23 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (24 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1)
    !WORD     (24 * 40) + screen_mem_buffer1 - (sprite_frame_width_char - 1);safety overflow

screen_rows_mul_table_buffer2: ; 40x multiplication table for 25 rows - with buffer 2 address

    ;support for seamless frame support - create as many "negative" rows as high the sprite character buffer is
    !WORD     screen_mem_buffer2 - (3 * 40) - (sprite_frame_width_char - 1)
    !WORD     screen_mem_buffer2 - (2 * 40) - (sprite_frame_width_char - 1)
    !WORD     screen_mem_buffer2 - (1 * 40) - (sprite_frame_width_char - 1)
    
    ;for visible rows:
    !WORD     (0 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (1 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (2 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (3 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (4 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (5 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (6 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (7 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (8 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (9 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (10 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (11 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (12 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (13 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (14 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (15 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (16 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (17 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (18 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (19 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (20 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (21 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (22 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (23 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (24 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1)
    !WORD     (24 * 40) + screen_mem_buffer2 - (sprite_frame_width_char - 1);safety overflow

sprite_width_limit_by_col:
    !BYTE     0,0,0
    !BYTE     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; no limit override on screen columns
    !BYTE     sprite_frame_height_char * 5, sprite_frame_height_char * 4, sprite_frame_height_char * 3, sprite_frame_height_char * 2, sprite_frame_height_char * 1    ;right side off-screen limits
    ;safety oveflow buffer
    !BYTE sprite_frame_height_char * 1,sprite_frame_height_char * 1,sprite_frame_height_char * 1,sprite_frame_height_char * 1,sprite_frame_height_char * 1,sprite_frame_height_char * 1

sprite_frame_left_column__by_col:
    !BYTE     sprite_frame_height_char * 4, sprite_frame_height_char * 3, sprite_frame_height_char * 2, sprite_frame_height_char * 1
    !BYTE     0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; no limit override on screen columns
    !BYTE     0, 0, 0, 0, 0   ;right side off-screen limits
    ;safety overflow buffer
    !BYTE     0, 0, 0, 0, 0, 0, 0, 0, 0

;=============================================================================================
;         RENDER SCREEN  ; input parameters: A for level index, X for target screen eg. 0c for 0c00
;=============================================================================================

use_this_as_block_color
    !BYTE   0

!ZONE render_screen
render_screen:        
    stx   target_screen_ptr_hi + 1
    dex
    dex
    dex
    dex         ; -4 for color page
    stx   $1a
    ldx   #$00
    stx   $19     ; 19-1a pointer to target screen color area (eg., 08000)
    asl
    tax
    lda   screens,x ; pointer to level start (10-11)
    sta   $10
    lda   screens + 1,x
    sta   $11

    ; clear screen color
    lda   #$88      ;default char color
    ldx   #$00
.back1
-   ldy   #$00
-   sta   ($19),y
    iny
    bne   -
    inc   $1a
    inx
    cpx   #$04
    bne   .back1 ; --
    
    ; reset color override
    lda   #$00
    sta   use_this_as_block_color
    
    jsr   retain_player_score
    ; clear screen content
    ldx   #$00
.back2
-   ldy   #$00
    tya
-   sta   ($19),y
    iny
    bne   -
    inc   $1a
    inx
    cpx   #$04
    bne   .back2 ; --
    dec   $1a     ;pull back screen pointer to bottom black line

    ;draw black line to the bottom of the screen
    ldy   #$c0    ;start pos of the last line on the 3rd page of the screen mem
-   lda   #$35    ;black multi1 filled character
    sta   ($19),y
    lda   #0
    sta   screen_mem_buffer1 - $4c0,y
    sta   screen_mem_buffer2 - $4c0,y
    iny
    cpy   #$e8
    bne   -
    dec   $1a     ;pull back screen pointer to top after clear screen
    dec   $1a
    dec   $1a
    
    ; draw black second line below the info bar
    ldy   #$28
    lda   #$35
-   sta   ($19),y
    iny
    cpy   #$50
    bne   -

    ; read header structure of the screen

    ldy   #$00
-   lda   ($10),y
    sta   current_screen_header_data_structure,y
    iny
    cpy   #screen_header_data_structure_size
    bne   -

    lda   $10       ;increment pointer to lamp block
    clc
    adc   #screen_header_data_structure_size
    bcc   +
    inc   $11
+   sta   $10

    ;set screen-related spawn difficulty
    lda   current_screen_spawn_interval
    sec
    sbc   spawn_interval_reduction
    bcs   +
    lda   #$00 ; do not allow negative spawn interval
    
+   sta   spawn_interval

    ;set spawn interval to zero for hard mode
    lda   game_is_in_hard_mode
    beq   +
    lda   #$00
    sta   spawn_interval
+   
    ;   save lamp positions buffer pointer
    lda   $10
    sta   $1c
    sta   pointer_to_current_level_lamps
    lda   $11
    sta   $1d     ;$1c-$1d lamp block start
    sta   pointer_to_current_level_lamps + 1
    
    ldy   #$00
-   lda   ($1c),y
    cmp   #$ff      ;find end of lamp block
    beq   +
    iny
    bne   -
+
    iny
    sty   lamp_block_size + 1
    
    lda   $10       ;increment pointer to spawn points blocks start
    clc
lamp_block_size
    adc   #$00
    bcc   +
    inc   $11
+   sta   $10
    
    ;   save spawn point buffer pointer
    lda   $10
    sta   $1c
    sta   pointer_to_current_level_spawn_points
    lda   $11
    sta   $1d     ;$1c-$1d spawn block start
    sta   pointer_to_current_level_spawn_points + 1
    ldy   #$00
-   lda   ($1c),y
    cmp   #$ff      ;find end of spawn points block
    beq   +
    iny
    bne   -
+
    iny
    sty   spawn_points_block_size + 1
    dey
    tya
    lsr
    tay
    sty   current_level_number_of_spawn_points
    
    lda   $10       ;increment pointer to level blocks start
    clc
spawn_points_block_size
    adc   #$00
    bcc   +
    inc   $11
+   sta   $10

render_next_block
    ldy   #$00    ; main iteration in the level (5 bytes per block) -> blockNO, posX, posY, limitW, limitH
    lda   ($10),y   ;block no
    cmp   #$ff
    beq   ++++     ;//end of level
    cmp   #BLOCK_COLOR_OVERRIDE
    bne   ++
    ;color override block
    iny

    lda   ($10),y ;next byte is the color
    sta   use_this_as_block_color;
    jmp   step_to_next_block
    ;tax
    ;and    #level_block_conditional
    ;bne    step_to_next_block
    ;txa    
++   
      ;!BYTE  $f2
    tax
    lda   #level_blocks_pointer_table>>8
    sta   block_ptr1 + 2
    sta   block_ptr2 + 2
    txa
    and   #$80
    beq   lower_blocks
    inc   block_ptr1 + 2
    inc   block_ptr2 + 2
lower_blocks
    txa
    asl
    tax 
block_ptr1    
    lda   level_blocks_pointer_table,x
    sta   $12
block_ptr2
    lda   level_blocks_pointer_table + 1,x
    sta   $13     ;pointer to the block (12-13)
    iny
    lda   ($10),y   ;pos x
    sta   block_pos_x
    iny
    lda   ($10),y   ;pos y
    sta   block_pos_y
    iny
    lda   ($10),y   ;limit x
    sta   block_limit_w
    iny
    lda   ($10),y   ;limit y
    sta   block_limit_h
    iny
    sty   REG_A     ;--preserve y
    jsr   draw_one_block
    ldy   REG_A     ;-- restore y

step_to_next_block    
    lda   $10       ;increment pointer to next block
    clc
    adc   #$05      ;block size
    bcc   +++
    inc   $11
+++   sta   $10
    jmp   render_next_block 
++++   
target_screen_ptr_hi
    ldx   #$00    ;target screen ptr_level_lamps_hi
    lda   lamp_flash_random
    jsr   render_current_level_lamps

    ldx   target_screen_ptr_hi + 1
    lda   lamp_flash_random
    jsr   render_current_level_lamps

    lda   current_screen_additional_color1
    sta   $ff16
    lda   current_screen_additional_color2
    sta   $ff17
    
    ;spawn on hard mode
    lda   game_is_in_hard_mode
    beq   not_in_hard_mode
    
    ;can enemies spawn with player?
    lda   current_screen_hard_mode_spawn_with_player
    beq   +
    
    ;create enemies with player
    lda   sprite1_data_x
    sta   $d2
    ldy   sprite1_data_y
    dey
    sty   $d3
    ldy   #$00
    jsr   bring_sumo_to_life

    lda   sprite1_data_x
    sta   $d2
    ldy   sprite1_data_y
    dey
    dey
    dey
    sty   $d3
    ldy   #$02
    jsr   ninja_spawn

+   

not_in_hard_mode  

    jsr   show_info_bar
    lda   current_player
    jsr   show_player_score
  
    rts

;----------------------------------------------------
;
;   SPAWN ENEMY... random pos for screen and random enemy, when not active
;
;----------------------------------------------------
spawn_timer
    !BYTE   0
spawn_interval
    !BYTE   20
spawn_interval_reduction
    !BYTE   0
    
pointer_to_current_level_spawn_points
    !WORD   0
current_level_number_of_spawn_points
    !BYTE   0

invalid_pos_no_spawn    
    rts
spawn_enemy
    lda   pointer_to_current_level_spawn_points
    sta   $d0
    lda   pointer_to_current_level_spawn_points + 1
    sta   $d1
-   jsr   get_next_random_number
    and   #$0f
    cmp   current_level_number_of_spawn_points
    bcs   -
    asl
    tay
    lda   ($d0),y   ;spawn x
    sta   $d2
    beq   invalid_pos_no_spawn
    iny
    lda   ($d0),y   ;spawn y
    sta   $d3
    beq   invalid_pos_no_spawn
    
    ;get enemy random id
    jsr   get_next_random_number
    tay
    and   #$01
    beq   sumo_spawn
    ldx   is_ninja_active
    cpx   #$00
    bne   sumo_spawn ;ninja is active on screen, spawn sumo
ninja_spawn
    ldx   #$00
    lda   $d3
    sta   sprite3_data_y
    tya
    and   #$07
    clc
    adc   $d2
    sta   sprite3_data_x
    cmp   #90 ; half screen width to initial direction
    bcs   +
    ldx   #$01
+
    stx   last_ninja_direction
    jsr   stop_ninja_animation
    jsr   stop_ninja_falling
    lda   #$00      
    sta   ninja_alive_timer
    sta   ninja_alive_timer + 1
    sta   last_ninja_body_character_behavior
    sta   last_ninja_feet_character_behavior
    sta   is_ninja_attacking
    sta   ninja_ai_run_distance_timer   ;for AI
    lda   #ninja_hits_per_life
    sta   ninja_hit_count

    jsr   get_next_random_number      ;wait a little at start, stays idle (for AI)
    and   #$1f
    clc
    adc   #20
    sta   ninja_ai_stand_still_timer

    lda   #$01
    sta   is_ninja_active
    lda   #SND_ENEMYSPAWN
    jsr   (sound_set - music_data_start) + music_target_memory
    rts
sumo_spawn    
    ldx   is_sumo_active
    cpx   #$00
    beq   bring_sumo_to_life  
    ldx   is_ninja_active
    cpx   #$00
    beq   ninja_spawn 
    rts   ;sumo is active, skip creating sumo
  
bring_sumo_to_life  
    ldx   #$00
    lda   $d3
    sta   sprite2_data_y
    tya
    and   #$07
    clc
    adc   $d2
    sta   sprite2_data_x
    cmp   #90 ; half screen width to initial direction
    bcs   +
    ldx   #$01
+
    stx   last_sumo_direction
    jsr   stop_sumo_animation
    jsr   stop_sumo_falling
    lda   #$00      
    sta   sumo_alive_timer
    sta   sumo_alive_timer + 1  
    sta   last_sumo_body_character_behavior
    sta   last_sumo_feet_character_behavior
    sta   is_sumo_attacking
    sta   sumo_ai_run_distance_timer    ;for AI
    
    lda   #sumo_hits_per_life
    sta   sumo_hit_count
    
    jsr   get_next_random_number      ;wait a little at start, stays idle (for AI)
    and   #$3f
    clc
    adc   #30
    sta   sumo_ai_stand_still_timer
    
    lda   #$01
    sta   is_sumo_active
    lda   #SND_ENEMYSPAWN
    jsr   (sound_set - music_data_start) + music_target_memory
    rts
    
;----------------------------------------------------
;   Render current level lamps: parameters: X=screen target !WORD hi, A = random offset should be the same for both buffers to avoid flicker
;----------------------------------------------------
pointer_to_current_level_lamps
    !WORD   0

lamp_shifted
    !BYTE   0
    
no_more_lamps_for_level_short
    JMP   no_more_lamps_for_level
    
render_current_level_lamps
    ;render lamps
    sta   random_lamp_offset + 1
    stx   target_screen_adr + 1

    lda   pointer_to_current_level_lamps    ;1c-1d pointer to lamps on current level
    sta   $1c
    lda   pointer_to_current_level_lamps + 1
    sta   $1d
    
    ;  ----- main loop
    ldy   #$00
render_next_lamp    
    sty   $1e
    
    lda   ($1c),y   ;index of lamp
    cmp   #$ff
    beq   no_more_lamps_for_level_short
    tax
    lda   lamp_status_flags, x
    beq   lamp_already_taken_short
    cmp   #$f0
    bcc   +
    ;lamp is in pickup stage, needs to remove from screen
    ;byt  $f2
    inc   lamp_status_flags, x
    jsr   remove_lamp_from_screen
    jmp   lamp_already_taken
+   
    iny
    lda   ($1c),y   ;x pos of lamp
    tax
    and   #LAMP_SHIFT
    sta   lamp_shifted
    txa
    and   #$7f
    sta   lamp_pos_x + 1
    iny
    lda   ($1c),y   ;y pos of lamp
    asl
    tax
    dex
    dex   ;y-1 to check upper char
    lda   screen_rows_mul_table + 1,x
    clc
target_screen_adr
    adc   #$00    ;target screen adr 0c:00
    sta   $15
    lda   screen_rows_mul_table,x
    clc
lamp_pos_x
    adc   #$00
    bcc   +
    inc   $15
+   sta   $14

    lda   lamp_shifted
    bne   render_lamp_shifted

    ; render normal lamp
    ldy   #$00
    lda   ($14),y ; check lamp top ------------------
    cmp   #lamp_post_roof1_INDEX
    bne   +
    lda   #lamp_hanger2_INDEX
    jmp   draw_lamp_top   
+   
    cmp   #lamp_post_roof2_INDEX
    bne   +
    lda   #lamp_hanger_INDEX
    jmp   draw_lamp_top
+   
    cmp   #lamp_post_ceiling_INDEX
    bne   +
    lda   #lamp_hanger_ceiling_INDEX
    jmp   draw_lamp_top
+   
draw_lamp_top   
    
    sta   ($14),y ; replace lamp top
    ldy   #$28
    lda   $1e
    clc
random_lamp_offset
    adc   #$00
    tax
    lda   random_numbers_table, x
    and   #$03
    clc
    adc   #lamp1_INDEX    ;lamp top
    sta   ($14),y

lamp_already_taken_short    
    jmp   lamp_already_taken
    
    ;render shifted lamp ------------------
render_lamp_shifted

    ldy   #$00
    lda   ($14),y ; check lamp top
    cmp   #lamp_post_roof1_INDEX
    bne   +
    lda   #lamp_hanger2_shifted_INDEX
    jmp   draw_lamp_top_shifted   
+   
    cmp   #lamp_post_roof2_INDEX
    bne   +
    lda   #lamp_hanger_shifted_INDEX
    jmp   draw_lamp_top_shifted
+   
    cmp   #lamp_post_ceiling_INDEX
    bne   +
    lda   #lamp_hanger_ceiling_shifted_INDEX
    ;jmp    draw_lamp_top_shifted
+   
draw_lamp_top_shifted 
    
    sta   ($14),y ; replace lamp top
    ldy   #$28
    lda   $1e
    clc
    adc   random_lamp_offset + 1
    tax
    lda   random_numbers_table, x
    and   #$03
    clc
    adc   #lamp1_shifted_INDEX    ;lamp top shifted
    sta   ($14),y
    ;byt $f2
    
lamp_already_taken    
    ldy   $1e
    iny
    iny
    iny
    ;beq    no_more_lamps_for_level
    jmp   render_next_lamp

no_more_lamps_for_level
    rts;

remove_lamp_from_screen
    iny
    lda   ($1c),y   ;x pos of lamp
    and   #$7f
    sta   rllamp_pos_x + 1
    iny
    lda   ($1c),y   ;y pos of lamp
    asl
    tax
    dex
    dex   ;y-1 to check upper char
    lda   screen_rows_mul_table + 1,x
    clc
    adc   target_screen_adr + 1   ;target screen adr 0c:00
    sta   $15
    lda   screen_rows_mul_table,x
    clc
rllamp_pos_x
    adc   #$00
    bcc   +
    inc   $15
+   sta   $14

    ;byt    $f2

    ; remove lamp
    ldy   #$00
    lda   ($14),y ; check lamp top ------------------
    cmp   #lamp_hanger2_INDEX
    bne   +
    lda   #lamp_post_roof1_INDEX
    jmp   remove_lamp_body    
+   
    cmp   #lamp_hanger_INDEX
    bne   +
    lda   #lamp_post_roof2_INDEX
    jmp   remove_lamp_body
+   
    cmp   #lamp_hanger_ceiling_INDEX
    bne   +
    lda   #lamp_post_ceiling_INDEX
    jmp   remove_lamp_body
+   
    cmp   #lamp_hanger2_shifted_INDEX
    bne   +
    lda   #lamp_post_roof1_INDEX
    jmp   remove_lamp_body
+       
    cmp   #lamp_hanger_shifted_INDEX
    bne   +
    lda   #lamp_post_roof2_INDEX
    jmp   remove_lamp_body
+       
    cmp   #lamp_hanger_ceiling_shifted_INDEX
    bne   +
    lda   #lamp_post_ceiling_INDEX
    ;jmp    remove_lamp_body
+   
remove_lamp_body  
    sta   ($14),y  ;replace lamp top
    
    ldy   #$28
    lda   ($14),y ; check lamp body
    tax
    lda   character_behavior_table, x
    and   #character_behavior_lamp
    beq   +
    lda   #$00  ;put space
    sta   ($14),y
+
    rts
    
number_of_lamps = 90
number_of_rooms = 20

lamp_status_flags
    !FILL number_of_lamps,0

room_visit_check_for_scoring
    !FILL   number_of_rooms,0
        
block_pos_x:    !BYTE 0
block_pos_y:    !BYTE 0
block_max_x:    !BYTE 0
block_max_y:    !BYTE 0
block_limit_w:    !BYTE 0
block_limit_h:    !BYTE 0
block_color:    !BYTE 0
curr_idx_in_block:  !BYTE 0
curr_line_offset:   !BYTE 0
last_block_char:  !BYTE 0

  
;=============================================================================================
;         DRAW ONE BLOCK  ;puts one block onto the screen. Input parameters are:
                    ;12-13  level block pointer
                    ;block_pos_x
                    ;block_pos_y
                    ;block_limit_w
                    ;block_limit_h
;=============================================================================================
!ZONE draw_one_block
draw_one_block:       
    ;calculate screen position from x and y with multiplication table
    lda   block_pos_y
    asl
    tax
    lda   screen_rows_mul_table + 1,x
    sta   $15
    lda   screen_rows_mul_table,x
    clc
    adc   block_pos_x
    bcc   +
    inc   $15
+   sta   $14
    sta   $16
    
    lda   $15 
    clc   
    adc   $1a ; current screen base pointer 0c:00
    sta   $15
    sec
    sbc   #$04
    sta   $17
    
    ldy   #$00
    sty   curr_line_offset  ;offset is the "jump" after every line in the block when width is limited
    
    ; read block max x
    lda   ($12),y
    sta   block_max_x     ;block max x
    cmp   block_limit_w   ; when limit is less than original size, overwrite original size
    bcc   +
    tax
    lda   block_limit_w
    sta   block_max_x
    txa   ; block max is in X->A
    sbc   block_limit_w
    sta   curr_line_offset  ;calculate offset after every row when width is limited
+   iny
    
    ; read block max y
    lda   ($12),y
    sta   block_max_y     ; block max y
    cmp   block_limit_h   ; when limit is less than original size, overwrite original size
    bcc   +
    tax
    lda   block_limit_h   ; overwrite original block height to limited height
    sta   block_max_y
+   iny

    ; read block color
    lda   use_this_as_block_color
    bne   +     ;not zero, use that color
    lda   ($12),y
+   sta   block_color     ; block color
    
    ; start main loop for rendering
    iny
    sty   curr_idx_in_block
    ldx   #$00        ;main cycle draws lines and columns of the block
.back3
-   ldy   #$00        ; columns in a row
-   ;stx    REG_C
    sty   REG_D

    ldy   curr_idx_in_block
    lda   ($12),y   ;12-13 is the address of the block
    cmp   #$ff    ; when block char is FF, reuse the last block char
    bne   +
    dec   curr_idx_in_block ;move back block pointer to FF special char
    lda   #$00
    sta   curr_line_offset;//when reached end of block, we do not need the line offset any more for limited widths
    lda   last_block_char
+   sta   last_block_char
    ldy   REG_D
    sta   ($14),y   ;14-15 is the character mem
    lda   block_color
    sta   ($16),y   ;16-17 is the character color memory
    
    inc   curr_idx_in_block
        
    ;ldx    REG_C
    ldy   REG_D
    iny
    cpy   block_max_x
    bne   -
    ; add offset when width was limited
    lda   curr_idx_in_block
    clc
    adc   curr_line_offset
    sta   curr_idx_in_block
    ;add new line to target screen pointer
    lda   $14
    clc
    adc   #$28
    bcc   +
    inc   $15
    inc   $17

+   sta   $14
    sta   $16
    
    inx
    cpx   block_max_y
    bne   .back3 ; --
    rts 

handle_one_char_conveyors

    lda   conveyor_anim_phase 
    and   #$07
    tax
    lda   draw_to_screen_buffer
    cmp   #screen_mem_buffer1 >> 8
    bne   +
    
    ldy   #$00
-
    lda   one_char_conveyor_wall,x
    sta   character_set_mem_buffer1 + 55*8,y
    lda   one_char_conveyor,x
    sta   character_set_mem_buffer1 + 7*8,y
    inx
    iny
    cpy   #$08
    bne   -
    rts
+
    ldy   #$00
-
    lda   one_char_conveyor_wall,x
    sta   character_set_mem_buffer2 + 55*8,y
    lda   one_char_conveyor,x
    sta   character_set_mem_buffer2 + 7*8,y
    inx
    iny
    cpy   #$08
    bne   -
    rts

one_char_conveyor
    !BYTE   $3c,$3c,$ff,$ff,$c3,$c3,$ff,$ff,$3c,$3c,$ff,$ff,$c3,$c3,$ff,$ff
one_char_conveyor_wall
    !BYTE   $14,$14,$55,$55,$41,$41,$55,$55,$14,$14,$55,$55,$41,$41,$55,$55
    
;--------------------------------------------------------
;   HANDLE LID  Parameters: x,y position of the lid
;--------------------------------------------------------
lid_animation_frame
    !BYTE 0
    
reset_lid_animation
    lda   #$00
    sta   lid_animation_frame
    rts
    
handle_lid
    lda   level_time + 1
    bne   +
    lda   level_time
    bne   +

    ;jump immediately to frame 4 when entering to room
    lda   #$04
    sta   lid_animation_frame
    ;lda    #SND_GATEOPEN
    ;stx    $ab
    ;jsr    (sound_set - music_data_start) + music_target_memory
    ;ldx    $ab
    jmp   show_lid_animation_frame
+
    lda   lid_animation_frame
    cmp   #$05
    bcc   +
    rts   ; we are over the animation frames, do nothing
+   
    cmp   #$00
    bne   +
    lda   #SND_GATEOPEN
    stx   $ab
    jsr   (sound_set - music_data_start) + music_target_memory
    ldx   $ab
+
    jsr   show_lid_animation_frame
    lda   level_time
    and   #$01
    bne   +
    inc   lid_animation_frame
+
    rts

show_lid_animation_frame
    ;byt  $f2
    stx   lid_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sec
    sbc   #$04;color screen mem
    sta   $17
    lda   screen_rows_mul_table,y
    clc
lid_pos_x
    adc   #$00
    bcc   +
    inc   $15
    inc   $17
+   sta   $14
    sta   $16
    
    lda   lid_animation_frame
    asl
    tax
    lda   lid_animation_frames_ptr, x
    sta   lid_anim_frame_ptr + 1
    lda   lid_animation_frames_ptr + 1, x
    sta   lid_anim_frame_ptr + 2

    ldx   #$00
-
lid_anim_frame_ptr    
    lda   $8888,x
    ldy   lid_screen_offsets,x
    sta   ($14),y
lid_color_for_level
    lda   #$3a
    sta   ($16),y
    inx
    cpx   #$09
    bne   -
    
    rts

  rts

;--------------------------------------------------------
;   HANDLE BUSH     parameterx x,y, pointer to bush data structure
;-------------------------------------------------------
handle_bush
    stx   $d0
    sty   $d1
    ldy   #$00
    lda   ($d0),y ;bush x
    sec
    sbc   #1
    sta   bush_pos_x + 1
    iny
    lda   ($d0),y
    sec
    sbc   #2
    sta   $d2 ;bush y
    iny
    lda   ($d0),y
    sta   $d3 ;anim frame index
    iny
    lda   ($d0),y
    sta   $d8 ;color
    
    lda   $d2
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sec
    sbc   #$04;color screen mem
    sta   $17
    lda   screen_rows_mul_table,y
    clc
bush_pos_x
    adc   #$00
    bcc   +
    inc   $15
    inc   $17
+   sta   $14
    sta   $16   

;   lda   $14
;   sec
;   sbc   #81
;   bcs   +
;   dec   15
;   dec   17
;+    sta   $14
;   sta   $16

    lda   $d3
    beq   draw_root
    cmp   #$01
    beq   draw_medium
    cmp   #$02
    beq   draw_grown
    cmp   #$03
    beq   draw_medium
    
draw_root
    ldx   #$00
-   lda   root_bush_chars,x
    ldy   grown_bush_y,x
    sta   ($14),y
    inx
    cpx   #10
    bne   -
    jmp   continue_bush

draw_medium
    cmp   #$03
    bne   +
    lda   #SND_EXPLOSION
    jsr   (sound_set - music_data_start) + music_target_memory
+
    ldx   #$00
-   lda   medium_bush_chars,x
    ldy   grown_bush_y,x
    sta   ($14),y
    lda   $d8
    sta   ($16),y
    inx
    cpx   #10
    bne   -
    jmp   continue_bush
    
draw_grown    
    ldx   #$00
-   lda   grown_bush_chars,x
    ldy   grown_bush_y,x
    sta   ($14),y
    lda   $d8
    sta   ($16),y
    inx
    cpx   #10
    bne   -
    
continue_bush
      
    ldy   #$04
    lda   ($d0),y   ;internal counter
    cmp   #5
    bcs   +
    clc
    adc   #$01
    sta   ($d0),y
    jmp   bush_afterplay
    ;advance animation
+   lda   #$00
    sta   ($d0),y
    lda   $d3
    beq   +
    sec
    sbc   #$01
    ldy   #$02
    sta   ($d0),y
+

bush_afterplay
    ;restart bush here
    lda   any_bush_touched
    beq   +   ;bush not touched

    ;start bush
    ldx   sprite1_data_x
    ldy   sprite1_data_y
    jsr   check_sprite_positions_for_bush
    ldx   sprite2_data_x
    ldy   sprite2_data_y
    jsr   check_sprite_positions_for_bush
    ldx   sprite3_data_x
    ldy   sprite3_data_y
    jsr   check_sprite_positions_for_bush
    ;jsr    trigger_bush
+
    rts

;-------------------------------------------------------------------
;   CHECK SPRITE POSITIONS FOR BUSH   Parameters: x,y sprite x y
;                 $d0-$d1 pointer to bush structure
;-------------------------------------------------------------------
check_sprite_positions_for_bush

    ;get sprite char x and y pos
    txa
    lsr
    lsr
    sec
    sbc   #$05    ;x off-screen compensation
    sta   $d6     ;sprite char x

    tya
    lsr
    lsr
    lsr
    sec
    sbc   #$02    ;y off-screen compensation
    sta   $d7     ;sprite char y

;   lda   $d7
;   asl
;   tax
;   lda   screen_rows_mul_table,x
;   sta   $40
;   lda   screen_rows_mul_table + 1,x
;   clc
;   adc #$0c
;   sta   $41
    
;   lda $40
;   clc
;   adc $d6
;   bcc +
;   inc $41
;+      sta $40
  
; lda #$01
; ldy #$00
; sta ($40),y
    ;byt  $f2

    ldy   #$00
    lda   ($d0),y   ;x pos of bush
    sta   $d4     ;x
    iny
    lda   ($d0),y   ;y pos of bush
    sta   $d5     ;y
    
    ; check positions
    ;byt    $f2
    lda   $d6  ;sprite x
    cmp   $d4 ;bush  x
    bcs   bush_not_covered
    clc
    adc   #$02
    cmp   $d4 ;bush  x
    bcc   bush_not_covered
    ;here we match x, check y
    ;byt    $f2

    lda   $d7  ;sprite y
    cmp   $d5 ;bush  y
    bcs   bush_not_covered
    clc
    adc   #$02
    cmp   $d5 ;bush yx
    bcc   bush_not_covered
    
    jsr trigger_bush

    ;byt $f2
    
bush_not_covered    
    rts

;--------------------------------------------------------------------
trigger_bush
    ldy   #$02
    lda   ($d0),y   
    beq   +  ;start only when not in root state
    rts
+   lda   #$06
    sta   ($d0),y   
    rts   
    
root_bush_chars
    !BYTE 0,0,0   ,0,0,0  ,0,(bush_root_top_INDEX - first_sprite_192_INDEX) + hills_INDEX,0  ,(bush_root_bottom_INDEX - first_sprite_192_INDEX) + hills_INDEX
medium_bush_chars
    !BYTE 0,0,0,178,179,28,180,181,182,183
grown_bush_chars
    !BYTE 184,185,186,187,188,189,190,191,hills_INDEX, hills_2_INDEX ;compensated chars moved to hills bank
grown_bush_y
    !BYTE 0,1,2,40,41,42,80,81,82,121

set_bush_root_1
    lda   #(bush_root_top_INDEX - first_sprite_192_INDEX) + hills_INDEX
    ldx   #(bush_root_bottom_INDEX - first_sprite_192_INDEX) + hills_INDEX
    sta   root_bush_chars + 7
    stx   root_bush_chars + 9
    rts

set_bush_root_2
    lda   #0
    ldx   #14
    jmp   set_bush_root_1 + 4
    
;--------------------------------------------------------
;   MOVE ZAPPER     parameterx x,y, pointer to zapper data structure
;-------------------------------------------------------
move_zapper
    stx   $d0
    sty   $d1
    ldy   #$00
    lda   ($d0),y
    sta   zapper_pos_x + 1
    iny
    lda   ($d0),y
    sta   $d2 ;zapper y
    iny
    lda   ($d0),y
    sta   $d3 ;width
    iny
    lda   ($d0),y
    sta   $d4 ;direction
    iny
    lda   ($d0),y
    sta   $da     ;real step
    lsr
    sta   $d5 ;curr step half char
    lda   zapper_pos_x + 1
    clc
    adc   $d5
    sta   zapper_pos_x + 1
    iny
    lda   ($d0),y
    sta   $d6 ;max step
    iny
    lda   ($d0),y
    sta   $db ;enabled

    lda   $d2
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    ;sec
    ;sbc    #$04;color screen mem
    ;sta    $17
    lda   screen_rows_mul_table,y
    clc
zapper_pos_x
    adc   #$00
    bcc   +
    inc   $15
    ;inc    $17
+   sta   $14
    ;sta    $16   
            
    jsr   draw_zapper

    lda   level_time
    and   #$07
    tax
    lda   zapper_speed_div_table, x
    beq   zapper_skip_move

    lda   $d4   ;direction
    bne   zapper_rtl
    lda   $da
    clc
    adc   #$02
    cmp   $d6
    bcc   +
    lda   #$00    
+   ldy   #$04
    sta   ($d0),y ; write back increased step
    jmp   zapper_skip_move
zapper_rtl    
    lda   $da
    sec
    sbc   #$02
    bcs   +
    lda   $d6 
    sec   
    sbc   #$03
+   ldy   #$04
    sta   ($d0),y ; write back increased step
zapper_skip_move

    lda   $db  ;enabed
    bne   +
    ;disabled, freeze step counter when cropped
    ldy   #$04
    cmp   $d6
    ldy   #$04
    lda   ($d0),y
    bne   +
    lda   #$ff    ;write back from 00 to ff
    sta   ($d0),y ; write back increased step
+
    rts
  
;------------------------------------------------------------------ 
draw_zapper
    lda   $d4
    bne   zapper_draw_rtl
    
    ;byt  $f2
    ldy   #$00
    ldx   $d5
-   cpx   $d3
    bcs   end_zapper_draw
    cpx   #$02
    bcc   + ; skip drawing left side
    lda   zapper_chars,y
    sta   ($14),y
+   inx
    iny
    cpy   #$03
    bne   -
end_zapper_draw   
    rts

zapper_draw_rtl
    ;byt  $f2
    ldy   #$00
    ldx   $d5
-   cpx   $d3
    bcs   end_zapper_draw
    cpx   #$02
    bcc   + ; skip drawing left side
    lda   zapper_chars + 2,y
    sta   ($14),y
+   inx
    iny
    cpy   #$03
    bne   -
    rts
    
zapper_chars
    !BYTE 0,0, zapper_beam_INDEX,0,0
zapper_speed_div_table
    !BYTE 1,1,1,0,1,1,1,0
    
slow_down_zapper
    lda   #$00
    sta   zapper_speed_div_table + 1
    sta   zapper_speed_div_table + 5
    sta   zapper_speed_div_table + 6
    rts 

speed_up_zapper
    lda   #$01
    sta   zapper_speed_div_table + 1
    sta   zapper_speed_div_table + 5
    sta   zapper_speed_div_table + 6
    rts 
    
;--------------------------------------------------------
;   MOVE LASER      parameterx x,y, pointer to laser data structure
;-------------------------------------------------------
laser_beam_half_char_table
    !BYTE   laser_beam_INDEX, laser_beam_second_half_INDEX
    !BYTE   laser_beam_first_half_INDEX, laser_beam_INDEX
move_laser
    stx   $d0
    sty   $d1
    ldy   #$00
    lda   ($d0),y
    sta   laser_pos_x + 1
    iny
    lda   ($d0),y
    sta   $d2 ;laser y
    iny
    lda   ($d0),y
    sta   $d3 ;width
    iny
    lda   ($d0),y
    sta   $d4 ;color
    iny
    lda   ($d0),y
    sta   $da     ;real step
    lsr
    sta   $d5 ;curr step half char
    lda   laser_pos_x + 1
    clc
    adc   $d5
    sta   laser_pos_x + 1
    iny

    lda   ($d0),y
    sta   $d6 ;max step
    iny
    lda   ($d0),y
    sta   $db ;enabled

    lda   $d2
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sec
    sbc   #$04;color screen mem
    sta   $17
    lda   screen_rows_mul_table,y
    clc
laser_pos_x
    adc   #$00
    bcc   +
    inc   $15
    inc   $17
+   sta   $14
    sta   $16   
    
    lda   $da
    and   #$01
    asl
    tax 
    lda   laser_beam_half_char_table,x
    sta   $d8
    lda   laser_beam_half_char_table + 1,x
    sta   $d9 ; 2 char of beam / half char shift
    
    lda   $d5
    beq   laser_approach1
    cmp   #$01
    beq   laser_approach2
laser_approach3
    ldx   $d5
    cpx   $d3
    bcs   hide_laser_end
    ldy   #$0
    lda   #00   ;space
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    iny
    inx 
    cpx   $d3
    bcs   hide_laser_end
    lda   $d8
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    iny
    inx 
    cpx   $d3
    bcs   hide_laser_end

    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   laser_continue
      
laser_approach1
    ldy   #$02
    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   laser_continue

laser_approach2
    ldy   #$01
    lda   $d8
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    iny
    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   laser_continue

laser_continue
hide_laser_end
    lda   level_time
    and   #$07
    tax
    lda   laser_speed_div_table, x
    beq   ++
    lda   $da
    clc
    adc   #$01
    cmp   $d6
    bcc   +
    lda   #$00    
+   ldy   #$04
    sta   ($d0),y ; write back increased step

++
    lda   $db  ;enabed
    bne   +
    ;disabled, freeze step counter when cropped
    ldy   #$04
    cmp   $d6
    ldy   #$04
    lda   ($d0),y
    bne   +
    lda   #$ff    ;write back from 00 to ff
    sta   ($d0),y ; write back increased step
+

    rts

laser_speed_div_table
    !BYTE 1,1,1,0,1,1,1,0

move_laser_rocket
    stx   $d0
    sty   $d1
    ldy   #$00
    lda   ($d0),y
    sta   rlaser_pos_x + 1
    iny
    lda   ($d0),y
    sta   $d2 ;laser y
    iny
    lda   ($d0),y
    sta   $d3 ;width
    iny
    lda   ($d0),y
    sta   $d4 ;color
    iny
    lda   ($d0),y
    sta   $da     ;real step
    lsr
    sta   $d5 ;curr step half char
    lda   rlaser_pos_x + 1
    clc
    adc   $d5
    sta   rlaser_pos_x + 1
    iny
    lda   ($d0),y
    sta   $d6 ;max step
    iny
    lda   ($d0),y
    sta   $db ;enabled

    lda   $d2
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sec
    sbc   #$04;color screen mem
    sta   $17
    lda   screen_rows_mul_table,y
    clc
rlaser_pos_x
    adc   #$00
    bcc   +
    inc   $15
    inc   $17
+   sta   $14
    sta   $16   
    
    lda   $da
    and   #$01
    asl
    asl
    tax 
    lda   laser_rocket_half_char_table,x
    sta   $d8
    lda   laser_rocket_half_char_table + 1,x
    sta   $d9 ; 2 char of beam / half char shift
    lda   laser_rocket_half_char_table + 2,x
    sta   $de ; 2 char of beam / half char shift
    lda   laser_rocket_half_char_table + 3,x
    sta   $df ; 2 char of beam / half char shift
    
    lda   $d5
    beq   rlaser_approach1
    cmp   #$01
    beq   rlaser_approach2
rlaser_approach3
    ldx   $d5
    cpx   $d3
    bcs   rhide_laser_end_near
    ldy   #$0
    lda   #00   ;space
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$28
    lda   #00   ;space
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    inx 
    cpx   $d3
    bcs   rhide_laser_end_near
    ldy   #$01
    lda   $d8
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$29
    lda   $de
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    inx 
    cpx   $d3
    bcs   rhide_laser_end_near
    ldy   #$02
    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$2a
    lda   $df
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   rlaser_continue
rhide_laser_end_near
    jmp   rhide_laser_end
    
rlaser_approach1
    ldy   #$02
    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$2a
    lda   $df
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   rlaser_continue

rlaser_approach2
    ldy   #$01
    lda   $d8
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$29
    lda   $de
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$02
    lda   $d9
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    ldy   #$2a
    lda   $df
    sta   ($14),y
    lda   $d4
    sta   ($16),y
    jmp   rlaser_continue

rlaser_continue
rhide_laser_end
    lda   level_time
    and   #$07
    tax
    lda   laser_rocket_speed_div_table, x
    beq   ++
    lda   $da
    clc
    adc   #$01
    cmp   $d6
    bcc   +
    lda   #$00    
+   ldy   #$04
    sta   ($d0),y ; write back increased step

++
    lda   $db  ;enabed
    bne   +
    ;disabled, freeze step counter when cropped
    ldy   #$04
    cmp   $d6
    ldy   #$04
    lda   ($d0),y
    bne   +
    lda   #$ff    ;write back from 00 to ff
    sta   ($d0),y ; write back increased step

+   rts   

laser_rocket_speed_div_table
    !BYTE 1,1,1,1,1,1,1,1
    
laser_rocket_half_char_table
    !byte  rocket1_1_INDEX, rocket2_1_INDEX ; half char shifted rocket
    !byte  rocket3_1_INDEX, rocket4_1_INDEX 
    !byte  rocket1_INDEX, rocket2_INDEX 
    !byte  rocket3_INDEX, rocket4_INDEX 

;--------------------------------------------------------
;   MOVE CONVEYOR
;-------------------------------------------------------
conveyor_bitmap
    !FILL   6 * 8 * 8,0 ;6 char, 8 bit/char, 8 phase
conveyor_bitmap_phase1    = conveyor_bitmap
conveyor_bitmap_phase2    = conveyor_bitmap + 1*6*8
conveyor_bitmap_phase3    = conveyor_bitmap + 2*6*8
conveyor_bitmap_phase4    = conveyor_bitmap + 3*6*8
conveyor_bitmap_phase5    = conveyor_bitmap + 4*6*8
conveyor_bitmap_phase6    = conveyor_bitmap + 5*6*8
conveyor_bitmap_phase7    = conveyor_bitmap + 6*6*8
conveyor_bitmap_phase8    = conveyor_bitmap + 7*6*8
    
init_conveyor

    ;copies the default conveyor bitmap to buffer to create shifted versions
    ldx   #00
-
    lda   character_set_mem_buffer1 + (conveyor1_INDEX * 8), x
    sta   conveyor_bitmap_phase1, x
    sta   conveyor_bitmap_phase2, x
    sta   conveyor_bitmap_phase3, x
    sta   conveyor_bitmap_phase4, x
    sta   conveyor_bitmap_phase5, x
    sta   conveyor_bitmap_phase6, x
    sta   conveyor_bitmap_phase7, x
    sta   conveyor_bitmap_phase8, x
    inx
    cpx   #48
    bne   -
  
        ;byt $f2
    lda   #conveyor_bitmap_phase2 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase2 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up

    lda   #conveyor_bitmap_phase3 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase3 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up

    lda   #conveyor_bitmap_phase4 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase4 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up

    lda   #conveyor_bitmap_phase5 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase5 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    
    lda   #conveyor_bitmap_phase6 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase6 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up

    lda   #conveyor_bitmap_phase7 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase7 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up

    lda   #conveyor_bitmap_phase8 >> 8
    sta   $d1
    sta   $d3
    lda   #conveyor_bitmap_phase8 & $ff
    sta   $d0
    sta   $d2
    
    lda   $d0
    clc
    adc   #$01
    bcc   +
    inc   $d1
+   sta   $d0
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    jsr   shift_conveyor_column_up
    
    rts

shift_conveyor_column_up

    ;byt      $f2
    ldy   #$00
    lda   ($d2),y
    sta   $d5
-   lda   ($d0),y
    sta   ($d2),y
    iny
    cpy   #$10
    bne   -
    dey
    lda   $d5
    sta   ($d2),y

    ldy   #$10
    lda   ($d2),y
    sta   $d5
-   lda   ($d0),y
    sta   ($d2),y
    iny
    cpy   #$20
    bne   -
    dey
    lda   $d5
    sta   ($d2),y

    ldy   #$20
    lda   ($d2),y
    sta   $d5
-   lda   ($d0),y
    sta   ($d2),y
    iny
    cpy   #$30
    bne   -
    dey
    lda   $d5
    sta   ($d2),y
    rts

conveyor_bitmap_phases_ptr  
    !WORD conveyor_bitmap_phase1
    !WORD conveyor_bitmap_phase2
    !WORD conveyor_bitmap_phase3
    !WORD conveyor_bitmap_phase4
    !WORD conveyor_bitmap_phase5
    !WORD conveyor_bitmap_phase6
    !WORD conveyor_bitmap_phase7
    !WORD conveyor_bitmap_phase8
    
conveyor_anim_phase
    !BYTE   0

conveyor_speed
    !BYTE   0
conveyor_direction
    !BYTE   0
conveyor_speed_mask
    !BYTE   14,9,6,4
conveyor_speed_tick
    !BYTE   0
conveyor_speed_tick2
    !BYTE   0
conveyor_speeds
    !BYTE   0,0,0,0,0,1,1,1,1,1,2,2,2,2,3,3
    !BYTE   3,3,2,2,2,2,1,1,1,1,1,0,0,0,0,0
    !BYTE   0,0,0,0,0,1,1,1,1,1,2,2,2,2,3,3
    !BYTE   3,3,2,2,2,2,1,1,1,1,1,0,0,0,0,0
conveyor_directions
    !BYTE   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    !BYTE   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    !BYTE   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    !BYTE   1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

conveyor_move_event
    !BYTE   0
conveyor_event_did_not_move     = 0
conveyor_event_moved_up       = 1
conveyor_event_moved_down     = 2

move_conveyor

    ;lda    conveyor_speed
    ;ldx    #33
    ;jsr    put_hex_to_dev_bar

    lda   #conveyor_event_did_not_move
    sta   conveyor_move_event
    lda   level_time
    and   #$07
    bne   +
    inc   conveyor_speed_tick2
+   lda   conveyor_speed_tick2
    lsr
    lsr 
    tax
    lda   conveyor_directions,x   
    sta   conveyor_direction
    lda   conveyor_speeds,x
    sta   conveyor_speed
    and   #$03
    tax 
    lda   conveyor_speed_tick
    clc
    adc   #$01
    sta   conveyor_speed_tick
    cmp   conveyor_speed_mask,x
    bcc   conv_next
    lda   #$00
    sta   conveyor_speed_tick

    lda   conveyor_direction
    bne   conv_down

    lda   #conveyor_event_moved_up
    sta   conveyor_move_event
    inc   conveyor_anim_phase
    jmp   conv_next

conv_down
    lda   #conveyor_event_moved_down
    sta   conveyor_move_event
    dec   conveyor_anim_phase
  
conv_next
    
    lda   conveyor_anim_phase
    and   #$07
    asl
    tax
    lda   conveyor_bitmap_phases_ptr,x 
    sta   conv_anim_frame + 1
    sta   conv_anim_frame2 + 1
    lda   conveyor_bitmap_phases_ptr + 1,x
    sta   conv_anim_frame + 2
    sta   conv_anim_frame2 + 2
    
    lda   draw_to_screen_buffer
    cmp   #screen_mem_buffer1 >> 8
    bne   +
    
    ldx   #$00
-
conv_anim_frame
    lda   $dddd,x
    sta   character_set_mem_buffer1 + (conveyor1_INDEX * 8), x
    inx
    cpx   #48
    bne   -
    rts

+
    ldx   #$00
-
conv_anim_frame2
    lda   $dddd,x
    sta   character_set_mem_buffer2 + (conveyor1_INDEX * 8), x
    inx
    cpx   #48
    bne   -
    rts

move_conveyor_wall
    lda   draw_to_screen_buffer
    cmp   #screen_mem_buffer1 >> 8
    bne   +
    
    ldx   #$00
-
    lda   character_set_mem_buffer1 + (conveyor1_INDEX * 8), x
    sta   character_set_mem_buffer1 + (((wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX) * 8), x
    inx
    cpx   #48
    bne   -
    rts

+
    ldx   #$00
-
    lda   character_set_mem_buffer2 + (conveyor1_INDEX * 8), x
    sta   character_set_mem_buffer2 + (((wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX) * 8), x
    inx
    cpx   #48
    bne   -
    rts

;--------------------------------------------------------
;   RESTORE CONVEYOR BLOCK  Parameters: x,y pos, AC=0 narrow, 1 = wide
;-------------------------------------------------------
conveyor_block_shift
    !BYTE   0,1,2,40,41,42
conveyor_block_chars
    !BYTE   conveyor1_INDEX, conveyor2_INDEX, conveyor3_INDEX, conveyor4_INDEX, conveyor5_INDEX, conveyor6_INDEX
conveyor_block_shift_wide
    !BYTE   0,1,2,3,40,41,42,43
conveyor_block_chars_wide
    !BYTE   conveyor1_INDEX, conveyor2_INDEX, conveyor2_INDEX, conveyor3_INDEX, conveyor4_INDEX, conveyor5_INDEX, conveyor5_INDEX, conveyor6_INDEX

restore_conveyor_block
    sta   $d0
    stx   conveyor_block_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    ;sec
    ;sbc    #$04;color screen mem
    ;sta    $17
    lda   screen_rows_mul_table,y
    clc
conveyor_block_pos_x
    adc   #$00
    bcc   +
    inc   $15
    ;inc    $17
+   sta   $14
    ;sta    $16
    lda   $d0
    bne   restore_wide_conveyor
    ldx   #$00
-   ldy   conveyor_block_shift,x
    lda   conveyor_block_chars,x
    sta   ($14),y
    inx
    cpx   #$06
    bne   -
    rts
restore_wide_conveyor
    ldx   #$00
-   ldy   conveyor_block_shift_wide,x
    lda   conveyor_block_chars_wide,x
    sta   ($14),y
    inx
    cpx   #$08
    bne   -
    rts

;--------------------------------------------------------
;   SET LAMP AS BAD  Parameters: x,y pos, AC= 0 good, 1- bad
;-------------------------------------------------------    
set_lamp_as_bad
    sta   $d0
    stx   bad_lamp_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    sec
    sbc   #$04      ;color mem
    sta   $17
    lda   screen_rows_mul_table,y
    clc

bad_lamp_pos_x
    adc   #$00
    bcc   +
    inc   $15
    inc   $17
+   sta   $14
    sta   $16
    
    lda   $d0
    beq   set_as_good_lamp
set_as_bad_lamp

    ldy   #$00
    lda   ($14),y
    cmp   #lamp_hanger_INDEX
    bne   +
    lda   #bad_lamp_hanger_INDEX
+
    cmp   #lamp_hanger2_shifted_INDEX
    bne   +
    lda   #bad_lamp_hanger_shifted_INDEX
+
    sta   ($14),y

    ldy   #$28
    lda   ($14),y
    cmp   #lamp1_INDEX
    bne   +
    lda   #bad_lamp_INDEX
+
    cmp   #lamp2_INDEX
    bne   +
    lda   #bad_lamp_INDEX
+
    cmp   #lamp3_INDEX
    bne   +
    lda   #bad_lamp_INDEX
+
    cmp   #lamp4_INDEX
    bne   +
    lda   #bad_lamp_INDEX
+
    cmp   #lamp1_shifted_INDEX
    bne   +
    lda   #bad_lamp_shifted_INDEX
+
    cmp   #lamp2_shifted_INDEX
    bne   +
    lda   #bad_lamp_shifted_INDEX
+
    cmp   #lamp3_shifted_INDEX
    bne   +
    lda   #bad_lamp_shifted_INDEX
+
    cmp   #lamp4_shifted_INDEX
    bne   +
    lda   #bad_lamp_shifted_INDEX
+
    sta   ($14),y
    
    lda   next_random_pointer
    ora   #$88
    sta   ($16),y  ;set random color
    
    rts
set_as_good_lamp    

    ldy   #$00
    lda   ($14),y
    cmp   #bad_lamp_hanger_INDEX
    bne   +
    lda   #lamp_hanger_INDEX
+
    cmp   #bad_lamp_hanger_shifted_INDEX
    bne   +
    lda   #lamp_hanger2_shifted_INDEX
+
    sta   ($14),y

    rts   

;--------------------------------------------------------
;   OPEN DYNAMIC DOOR  Parameters: x,y pos, AC= length
;-------------------------------------------------------
DOOR_TO_WARP_1 = $10
DOOR_TO_WARP_2 = $20
DOOR_TO_WARP_3 = $30
DOOR_TO_WARP_4 = $40
DOOR_IS_HORIZONTAL = $80

door_warp_chars
    !BYTE   0, warp1_INDEX, warp2_INDEX, warp3_INDEX, warp4_INDEX
    
open_dynamic_door
    sta   $d0
    lda   #SND_GATEOPEN
    stx   $ab
    jsr   (sound_set - music_data_start) + music_target_memory
    ldx   $ab
    lda   $d0
    and   #$0f
    sta   dynamic_door_size + 1
    stx   door_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    ;sec
    ;sbc    #$04;color screen mem
    ;sta    $17
    lda   screen_rows_mul_table,y
    clc
door_pos_x
    adc   #$00
    bcc   +
    inc   $15
    ;inc    $17
+   sta   $14
    ;sta    $16
    
    lda   $d0
    lsr
    lsr
    lsr
    lsr
    and   #$07
    tax
    lda   door_warp_chars,x
    sta   door_char_replace + 1
    sta   door_char_replace1 + 1
    
    ldx   #40   ;vertical increment (+40 chars per line)
    lda   $d0
    and   #DOOR_IS_HORIZONTAL
    beq   +
    ldx   #1    ; horizontal increment (right to left)
+   stx   door_pos_change + 1
    
    ldx   #$00
    ldy   #$00
-   lda   ($14),y
door_char_replace
    cmp   #$00
    beq   door_already_open
    cmp   #wall_bottom_1_INDEX
    bne   +
    lda   #wall_bottom_1_no_wall_INDEX
    jmp   clear_wall
+
    cmp   #wall_bottom_2_INDEX
    bne   +
    lda   #wall_bottom_2_no_wall_INDEX
    jmp   clear_wall
+   
    cmp   #black_column_bottom_INDEX
    bne   +
    lda   #platform_INDEX
    jmp   clear_wall
+   
door_char_replace1
    lda   #0    ;put space or warp char
clear_wall
    sta   ($14),y


    lda   $14
    clc
door_pos_change
    adc   #40
    bcc   +
    inc   $15
+   sta   $14
    inx
dynamic_door_size 
    cpx   #$00
    bne   -

door_already_open

    rts

;--------------------------------------------------------
;   CLEAR SCREEN AREA  Parameters: x,y pos, AC= width,height hi4bit/lo4bit
;-------------------------------------------------------
!ZONE clear_screen_area
clear_screen_area
    sta   $d0
    stx   region_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    lda   screen_rows_mul_table,y
    clc
region_pos_x
    adc   #$00
    bcc   +
    inc   $15
    ;inc    $17
+   sta   $14
    ;sta    $16
    
    lda   $d0
    lsr
    lsr
    lsr
    lsr
    sta   screen_region_width + 1
    lda   $d0
    and   #$0f
    sta   screen_region_height + 1
    
    ldx   #$00
.back4
-   ldy   #$00
    lda   #$00
-   sta   ($14),y
    iny
screen_region_width
    cpy   #$00
    bne   -

    lda   $14
    clc
    adc   #40
    bcc   +
    inc   $15
+   sta   $14

    inx
screen_region_height  
    cpx   #$00
    bne   .back4 ; --

    rts

;--------------------------------------------------------
;   copy SCREEN AREA  Parameters: x,y pos, AC= width,height hi4bit/lo4bit, $d0 copy source x, $d1 copy source y
;-------------------------------------------------------
!ZONE copy_screen_area 
copy_screen_area
    sta   $d8
    stx   target_region_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $15
    lda   screen_rows_mul_table,y
    clc
target_region_pos_x
    adc   #$00
    bcc   +
    inc   $15
+   sta   $14
    
    ;source pos calculation
    ldx   $d0
    ldy   $d1
    stx   source_region_pos_x + 1
    tya   
    asl
    tay
    lda   screen_rows_mul_table + 1,y
    clc
    adc   draw_to_screen_buffer
    sta   $17
    lda   screen_rows_mul_table,y
    clc
source_region_pos_x
    adc   #$00
    bcc   +
    inc   $17
+   sta   $16
    
    lda   $d8
    lsr
    lsr
    lsr
    lsr
    sta   screen_region_width_copy + 1
    lda   $d8
    and   #$0f
    sta   screen_region_height_copy + 1

    ldx   #$00
.back5
-   ldy   #$00
-   lda   ($16),y
    sta   ($14),y
    iny
screen_region_width_copy
    cpy   #$00
    bne   -

    lda   $14
    clc
    adc   #40
    bcc   +
    inc   $15
+   sta   $14

    lda   $16
    clc
    adc   #40
    bcc   +
    inc   $17
+   sta   $16

    inx
screen_region_height_copy
    cpx   #$00
    bne   .back5 ; --

    rts
char_subset_available
    !BYTE char_subset_not_initiated
    
char_subset_not_initiated = 0
char_subset_surface     = 1
char_subset_underworld    = 2

init_surface_world_charset_buffer

    lda   char_subset_available
    cmp   #char_subset_not_initiated
    beq   +
    rts
+
    ;at start, copy underworld to buffer, surface remains in charset
    ldx   #$00
-   lda   character_set_mem_buffer1 + (first_sprite_192_INDEX * 8),x
    sta   character_set_swap_buffer,x
    inx
    cpx   #number_of_swapped_chars_hills * 8
    bne   -
    
    ;copy warp chars for dev mode
    ldx   #$00
-   lda   character_set_mem_buffer1 + (warp1_INDEX * 8),x
    sta   character_set_swap_buffer_warp_dev_chars,x
    inx
    cpx   #32  ; 4 chars
    bne   -
    
    ldx   #$00
-   lda   character_set_mem_buffer1 + (first_sprite_192_INDEX * 8) + (number_of_swapped_chars_hills * 8),x
    sta   character_set_swap_buffer_bull,x
    inx
    cpx   #number_of_swapped_chars_bull * 8
    bne   -

    ldx   #$00
-   lda   character_set_mem_buffer1 + (first_sprite_192_INDEX * 8) + (number_of_swapped_chars_hills * 8) + (number_of_swapped_chars_bull * 8) + 8,x
    sta   character_set_swap_buffer_statue,x
    inx
    cpx   #number_of_swapped_chars_statue * 8
    bne   -
    
    
    lda   #char_subset_surface
    sta   char_subset_available
    rts

init_warp_chars_for_dev_mode
    
    lda   DEVELOPER_MODE
    beq   clear_warp_door_chars
    ;copy warp chars for dev mode
set_dev_warp_door_chars
    ldx   #$00
-   
    lda   character_set_swap_buffer_warp_dev_chars,x
    sta   character_set_mem_buffer1 + (warp1_INDEX * 8),x
    sta   character_set_mem_buffer2 + (warp1_INDEX * 8),x
    inx
    cpx   #32  ; 4 chars
    bne   -
    rts
    
clear_warp_door_chars
    ;delete warp chars for normal mode
    ldx   #$00
    txa
-   
    sta   character_set_mem_buffer1 + (warp1_INDEX * 8),x
    sta   character_set_mem_buffer2 + (warp1_INDEX * 8),x
    inx
    cpx   #32  ; 4 chars
    bne   -
    rts

init_warp_chars_for_shadow_doors
    
    lda   DEVELOPER_MODE
    bne   set_dev_warp_door_chars
    ;copy warp chars for dev mode
    ldx   #$00
    lda   #$aa
-   
    sta   character_set_mem_buffer1 + (warp1_INDEX * 8),x
    sta   character_set_mem_buffer2 + (warp1_INDEX * 8),x
    inx
    cpx   #32  ; 4 chars
    bne   -
    rts

copy_surface_world_chars_to_charset

    lda   char_subset_available
    cmp   #char_subset_surface
    bne   +
    rts   ;this charset is available now, do nothing
+   
    ;swap hills back to charset
    lda   #char_subset_surface
    sta   char_subset_available
    lda   #$01
    sta   chars_with_fixed_color + 86;this is a hill in the surface..  force color change
    sta   chars_with_fixed_color + 87;this is a hill in the surface..  force color change
    sta   chars_with_fixed_color + 18;this is a door underground.. do not force color change
    
    lda   #character_behavior_wall
    sta   character_behavior_table + 54
    sta   character_behavior_table + 56
    sta   character_behavior_table + 57
    sta   character_behavior_table + 58
    sta   character_behavior_table + 60
    sta   character_behavior_table + 61


swap_charset    
    ldx   #$00
-
    lda   character_set_mem_buffer1 + (hills_INDEX * 8),x
    sta   $d0
    lda   character_set_swap_buffer,x
    sta   character_set_mem_buffer1 + (hills_INDEX * 8),x
    sta   character_set_mem_buffer2 + (hills_INDEX * 8),x
    lda   $d0
    sta   character_set_swap_buffer,x
    inx
    cpx   #number_of_swapped_chars_hills * 8
    bne   -

    ldx   #$00
-
    lda   character_set_mem_buffer1 + (bull_INDEX * 8),x
    sta   $d0
    lda   character_set_swap_buffer_bull,x
    sta   character_set_mem_buffer1 + (bull_INDEX * 8),x
    sta   character_set_mem_buffer2 + (bull_INDEX * 8),x
    lda   $d0
    sta   character_set_swap_buffer_bull,x
    inx
    cpx   #number_of_swapped_chars_bull * 8
    bne   -

    ldx   #$00
-
    lda   character_set_mem_buffer1 + (statue_INDEX * 8),x
    sta   $d0
    lda   character_set_swap_buffer_statue,x
    sta   character_set_mem_buffer1 + (statue_INDEX * 8),x
    sta   character_set_mem_buffer2 + (statue_INDEX * 8),x
    lda   $d0
    sta   character_set_swap_buffer_statue,x
    inx
    cpx   #number_of_swapped_chars_statue * 8
    bne   -

    rts

copy_underground_chars_to_charset 

    lda   char_subset_available
    cmp   #char_subset_underworld
    bne   +
    rts   ;this charset is available now, do nothing
+         
    ;swap hills to underworld charset
    lda   #char_subset_underworld
    sta   char_subset_available
    lda   #$00
    sta   chars_with_fixed_color + 86;this is a door underground.. do not force color change
    sta   chars_with_fixed_color + 87;this is a door underground.. do not force color change
    sta   chars_with_fixed_color + 18;this is a door underground.. do not force color change
    
    lda   #character_behavior_platform
    sta   character_behavior_table + 56
    sta   character_behavior_table + 57
    sta   character_behavior_table + 58
    sta   character_behavior_table + 60
    sta   character_behavior_table + 61
    lda   #0
    sta   character_behavior_table + 54

    jmp   swap_charset
        
lid_animation_frames_ptr
    !WORD lid_anim_frame1, lid_anim_frame2, lid_anim_frame3, lid_anim_frame3, lid_anim_frame3, lid_anim_frame3, lid_anim_frame3, lid_anim_frame3
lid_anim_frame1
    !BYTE 0,0,50,50,31,31,99,99, warp4_INDEX
lid_anim_frame2
    !BYTE 0,50,50,0,31,99,99, warp4_INDEX, warp4_INDEX
lid_anim_frame3
    !BYTE 50,50,0,0,99,99, warp4_INDEX, warp4_INDEX, warp4_INDEX
lid_screen_offsets
    !BYTE 0,1,2,3,40,41,42,43,44

screen_header_data_structure_size = 23

current_screen_header_data_structure
current_screen_bg_color_split_line
    !BYTE 00
current_screen_bg_color_top
    !BYTE 00
current_screen_bg_color_bottom
    !BYTE 00
current_screen_additional_color1
    !BYTE 00
current_screen_additional_color2
    !BYTE 00

current_screen_warp1_target
    !BYTE 0;target screen index
current_screen_warp1_target_initial_x   
    !BYTE 0
current_screen_warp1_target_initial_y
    !BYTE 0

current_screen_warp2_target
    !BYTE 0;target screen index
current_screen_warp2_target_initial_x   
    !BYTE 0
current_screen_warp2_target_initial_y
    !BYTE 0

current_screen_warp3_target
    !BYTE 0;target screen index
current_screen_warp3_target_initial_x   
    !BYTE 0
current_screen_warp3_target_initial_y
    !BYTE 0
    
current_screen_warp4_target
    !BYTE 0;target screen index
current_screen_warp4_target_initial_x   
    !BYTE 0
current_screen_warp4_target_initial_y
    !BYTE 0
current_screen_execution_logic_init
    !WORD 0
current_screen_execution_logic
    !WORD 0
current_screen_spawn_interval   
    !BYTE 0
current_screen_hard_mode_spawn_with_player    
    !BYTE 0
    
screen_rows_mul_table: ; 40x multiplication table for 25 rows
    !WORD 0 * 40, 1 * 40, 2 * 40, 3 * 40, 4 * 40, 5 * 40, 6 * 40, 7 * 40, 8 * 40, 9 * 40, 10 * 40,11 * 40,12 * 40,13 * 40, 14*40, 15*40, 16*40, 17*40, 18*40, 19*40, 20*40, 21*40, 22*40, 23*40, 24*40
  
LAMP_SHIFT    = 128
      
;------ level blocks vector table
level_blocks_pointer_table: 
    !WORD level_block_bull        ;index 0
    !WORD level_block_ground        ;index 1
    !WORD level_block_platform_end_left   ;index 2
    !WORD level_block_platform      ;index 3
    !WORD level_block_column1       ;index 4
    !WORD level_block_column2       ;index 5
    !WORD level_block_door1       ;index 6
    !WORD level_block_column3       ;index 7
    !WORD level_block_platform_end_right  ;index 8
    !WORD level_block_platform2_thick   ;index 9
    !WORD level_block_platform2_thin    ;index 10
    !WORD level_block_statue1       ;index 11
    !WORD level_block_door_column_left  ;index 12
    !WORD level_block_door_column_right ;index 13
    !WORD level_block_door2       ;index 14
    !WORD level_block_ladder1       ;index 15
    !WORD level_block_ladder2       ;index 16
    !WORD level_block_empty       ;index 17
    !WORD level_block_spike_down      ;index 18
    !WORD level_block_sky         ;index 19
    !WORD level_block_hill1       ;index 20
    !WORD level_block_hill1_right     ;index 21
    !WORD level_block_hill2_high      ;index 22
    !WORD level_block_hill2_high_right  ;index 23
    !WORD level_block_hill2_high_left   ;index 24
    !WORD level_block_door3       ;index 25
    !WORD level_block_door4       ;index 26
    !WORD level_block_column3_short   ;index 27
    !WORD level_block_door5       ;index 28
    !WORD level_block_small_hinge     ;index 29
    !WORD level_block_small_ladder    ;index 30
    !WORD level_block_lid         ;index 31
    !WORD level_block_hill3       ;index 32
    !WORD level_block_hilltop       ;index 33
    !WORD level_block_hill4       ;index 34
    !WORD level_block_column_m      ;index 35
    !WORD level_block_ladder3       ;index 36
    !WORD level_block_ladder4       ;index 37
    !WORD level_block_double_column   ;index 38
    !WORD level_block_double_column_black ;index 39
    !WORD level_block_upper_left_corner ;index 40
    !WORD level_block_upper_right_corner  ;index 41
    !WORD level_block_warp1       ;index 42
    !WORD level_block_warp2       ;index 43
    !WORD level_block_warp3       ;index 44
    !WORD level_block_warp4       ;index 45
    !WORD level_block_warp4_near_lid    ;index 46
    !WORD level_block_door6       ;index 47
    !WORD level_block_lamp_hanger1    ;index 48
    !WORD level_block_lamp_hanger2    ;index 49
    !WORD level_block_bastille_small    ;index 50
    !WORD level_block_bastille_wall   ;index 51
    !WORD level_block_bastille_wall_windows;index 52
    !WORD level_block_column_white_bastille;index 53
    !WORD level_block_bastille_grid   ;index 54
    !WORD level_block_bastille_grid_top   ;index 55
    !WORD level_block_bastille_grid_top2  ;index 56
    !WORD level_block_ladder5       ;index 57
    !WORD level_block_bastille_big    ;index 58
    !WORD level_block_bastille_medium   ;index 59
    !WORD level_block_swords_up     ;index 60
    !WORD level_block_underworld_platform ;index 61
    !WORD level_block_underworld_platform_left_end  ;index 62
    !WORD level_block_underworld_platform_right_end ;index 63
    !WORD level_block_underworld_ceiling  ;index 64
    !WORD level_block_conveyor      ;index 65
    !WORD level_block_double_ceiling_black_console ;index 66
    !WORD level_block_black_column_only ;index 67
    !WORD level_block_black_column_ceiling    ;index 68
    !WORD level_block_black_column_ceiling2 ;index 69
    !WORD level_block_underground_door1 ;index 70
    !WORD level_block_underground_door2 ;index 71
    !WORD level_block_underground_door3 ;index 72
    !WORD level_block_underground_plaftorm_left2    ;index 73
    !WORD level_block_ceiling_plant1    ;index 74
    !WORD level_block_ceiling_plant2    ;index 75
    !WORD level_block_ceiling_plant3    ;index 76
    !WORD level_block_ceiling_plant4    ;index 77
    !WORD level_block_swords_down     ;index 78
    !WORD level_block_conveyor_wide   ;index 79
    !WORD level_block_black_wall      ;index 80
    !WORD level_block_black_ground    ;index 81
    !WORD level_block_black_block     ;index 82
    !WORD level_block_ladder6       ;index 83
    !WORD level_block_platform_end2_left  ;index 84
    !WORD level_block_platform_end2_right ;index 85
    !WORD level_block_underground_door4 ;index 86
    !WORD level_block_lamp_hanger3_left ;index 87
    !WORD level_block_lamp_hanger3_right  ;index 88
    !WORD level_block_thin_metal_platform ;index 89
    !WORD level_block_underground_ceiling2;index 90
    !WORD level_block_corner_plant_ul   ;index 91
    !WORD level_block_underground_level_corner;index 92
    !WORD level_block_underground_door5   ;index 93
    !WORD level_block_double_lamp_hangers   ;index 94
    !WORD level_block_underground_door6   ;index 95
    !WORD level_block_platform_bottom_only  ;index 96
    !WORD level_block_ceiling_plant5      ;index 97
    !WORD level_block_zapper      ;index 98
    !WORD level_block_wall_conveyor     ;index 99
    !WORD level_block_wall_conveyor_left      ;index 100
    !WORD level_block_wall_conveyor_right     ;index 101
    !WORD level_block_wall_conveyor_middle      ;index 102
    !WORD level_block_underground_platform2;      index 103
    !WORD level_block_underground_wall2;      index 104
    !WORD level_block_yinyang;      index 105
    !WORD level_block_underground_ladder;     index 106
    !WORD level_block_underground_door10      ;index 107
    !WORD level_block_underground_door_shadow     ;index 108
    !WORD level_block_underground_platform_shadow   ;index 109
    !WORD level_block_underground_brick1    ;index 110
    !WORD level_block_underground_brick_line    ;index 111
    !WORD level_block_underground_brick2      ;index 112
    !WORD level_block_underground_ceiling_thin      ;index 113
    !WORD level_block_underground_ceiling_deco      ;index 114
    !WORD level_block_underground_lamp_hanger     ;index 115
    !WORD level_block_underground_wall3     ;index 116
    !WORD level_block_underground_grid      ;index 117
    !WORD level_block_underground_ladder6   ;index 118
    !WORD level_block_underground_gray_block    ;index 119
    !WORD level_block_underground_lamp_hanger2    ;index 120
    !WORD level_block_underground_black_block   ;index 121
    !WORD level_block_underground_slide   ;index 122
    !WORD level_block_underground_brick3    ;index 123
    !WORD level_block_underground_ceiling_deco2   ;index 124
    !WORD level_block_zapper_platform     ;index 125
    !WORD level_block_zapper_platform2      ;index 126
    !WORD level_block_underground_wall4     ;index 127
    !WORD level_block_underground_grid2     ;index 128
    !WORD level_block_underground_column6     ;index 129
    !WORD level_block_horizontal_ladder     ;index 130
        
BLOCK_COLOR_OVERRIDE  = $fe
USE_BLOCK_COLOR     = 0

;--- horizontal ladder
level_block_horizontal_ladder:
    !BYTE 30,1, $5a           ;width and height and color
    !BYTE 7,255

;--- underground column 6
level_block_underground_column6:
    !BYTE 1,6, $de            ;width and height and color
    !BYTE 44,45,12,12,12,30
    
;--- underground grid 2
level_block_underground_grid2:
    !BYTE 6,6, $de            ;width and height and color
    !BYTE 10,10,10,10,10,10
    !BYTE 2,2,2,2,2,2
    !BYTE 10,10,10,10,10,10
    !BYTE 2,2,2,2,2,2
    !BYTE 10,10,10,10,10,10
    !BYTE 2,2,2,2,2,2

;--- underground wall 4
level_block_underground_wall4:
    !BYTE 1,12, $ae           ;width and height and color
    !BYTE 62,63,62,63,62,63,62,63,62,63,62,63
    
;--- zapper platform 2
level_block_zapper_platform2:
    !BYTE 40,1, $ae           ;width and height and color
    !BYTE 61,255

;--- zapper platform
level_block_zapper_platform:
    !BYTE 40,1, $ae           ;width and height and color
    !BYTE 60,255
    
;--- underground ceiling_deco2
level_block_underground_ceiling_deco2:
    !BYTE 40,1, $de           ;width and height and color
    !BYTE 59,255
    
;--- underground brick 3
level_block_underground_brick3:
    !BYTE 2,2, $de            ;width and height and color
    !BYTE  13,11,18,17

;--- underground slide
level_block_underground_slide:
    !BYTE 6,5, $de            ;width and height and color
    !BYTE 2,56,57,57,58,10
    !BYTE 10,56,57,57,58,2
    !BYTE 2,56,57,57,58,10
    !BYTE 10,56,57,57,58,2
    !BYTE 2,10,2,10,2,10
    
;--- underground black block
level_block_underground_black_block:
    !BYTE 10,10, $88            ;width and height and color
    !BYTE 53,255

;--- underground lamp hanger 2
level_block_underground_lamp_hanger2:
    !BYTE 1,1, $de            ;width and height and color
    !BYTE 54
    
;--- underground gray space
level_block_underground_gray_block:
    !BYTE 6,6, $db            ;width and height and color
    !BYTE 12,255

;--- underground ladder 6
level_block_underground_ladder6:
    !BYTE 4,22, $db           ;width and height and color
    !BYTE 7,255

;--- underground grid
level_block_underground_grid:
    !BYTE 6,6, $de            ;width and height and color
    !BYTE 2,10,2,10,2,10
    !BYTE 10,2,10,2,10,2
    !BYTE 2,10,2,10,2,10
    !BYTE 10,2,10,2,10,2
    !BYTE 2,10,2,10,2,10
    !BYTE 10,2,10,2,10,2

;--- underground wall 3
level_block_underground_wall3:
    !BYTE 1,22, $de           ;width and height and color
    !BYTE 55, 255
    
;--- underground lamp hanger
level_block_underground_lamp_hanger:
    !BYTE 1,1, $de            ;width and height and color
    !BYTE 3

;--- underground ceiling deco
level_block_underground_ceiling_deco:
    !BYTE 40,1, $f9           ;width and height and color
    !BYTE 53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53,53,19,19,53

;--- underground ceiling thin
level_block_underground_ceiling_thin:
    !BYTE 40,1, $f9           ;width and height and color
    !BYTE 19, 255

;--- underground brick 2
level_block_underground_brick2:
    !BYTE 2,2, $de            ;width and height and color
    !BYTE  11,13,17,18

;--- underground brick line
level_block_underground_brick_line:
    !BYTE 40,1, $de           ;width and height and color
    !BYTE  149,255

;--- underground brick 1
level_block_underground_brick1:
    !BYTE 2,2, $de            ;width and height and color
    !BYTE  (sprite_90_INDEX - first_sprite_192_INDEX) + hills_INDEX , (sprite_91_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE   43,42
    
;--- underground platform shadow
level_block_underground_platform_shadow:
    !BYTE 40,1, $de           ;width and height and color
    !BYTE  4,255
    
;--- underground door shadow
level_block_underground_door_shadow:
    !BYTE 4,5, $de            ;width and height and color
    !BYTE  12,12,12,12
    !BYTE  12,12,12,12
    !BYTE  12,12,12,12
    !BYTE  12,12,12,12
    !BYTE  4,4,4,4

;--- underground door 10
level_block_underground_door10:
    !BYTE 5,5, $de            ;width and height and color
    !BYTE  (sprite_92_INDEX - first_sprite_192_INDEX) + hills_INDEX, bull_INDEX,              bull_INDEX + 1,           (sprite_92_INDEX - first_sprite_192_INDEX) + hills_INDEX,                bull_INDEX
    !BYTE  (sprite_90_INDEX - first_sprite_192_INDEX) + hills_INDEX , (sprite_91_INDEX - first_sprite_192_INDEX) + hills_INDEX, bull_INDEX + 9, (sprite_90_INDEX - first_sprite_192_INDEX) + hills_INDEX,(sprite_91_INDEX - first_sprite_192_INDEX)+ hills_INDEX
    !BYTE  (sprite_92_INDEX - first_sprite_192_INDEX) + hills_INDEX, bull_INDEX,              bull_INDEX + 1,           (sprite_92_INDEX - first_sprite_192_INDEX) + hills_INDEX,                bull_INDEX
    !BYTE  (sprite_90_INDEX - first_sprite_192_INDEX) + hills_INDEX , (sprite_91_INDEX - first_sprite_192_INDEX) + hills_INDEX, bull_INDEX + 9, (sprite_90_INDEX - first_sprite_192_INDEX) + hills_INDEX,(sprite_91_INDEX - first_sprite_192_INDEX)+ hills_INDEX
    !BYTE  4,4,4,4,4

;--- underground ladder
level_block_underground_ladder:
    !BYTE 3,6, $de            ;width and height and color
    !BYTE (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ladder_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX

;--- yinyang
level_block_yinyang:
    !BYTE 2,2, $f9            ;width and height and color
    !BYTE (yinyang1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (yinyang2_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (yinyang3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (yinyang4_INDEX - first_sprite_192_INDEX) + hills_INDEX

;--- underground wall 2
level_block_underground_wall2:
    !BYTE 1,12, $de           ;width and height and color
    !BYTE (ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX,(ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX,(ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX,(ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX,(ug_wall1_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (ug_wall2_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    
;--- underground platform 2
level_block_underground_platform2:
    !BYTE 40,2, $de           ;width and height and color
    !BYTE (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_top_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    !BYTE (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX, (platform2_bottom_INDEX - bull_replacement_start_INDEX) + bull_INDEX
    
;--- wall_conveyor middle
level_block_wall_conveyor_middle:
    !BYTE 1,10, $88           ;width and height and color
    !BYTE (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX

;--- wall_conveyor right
level_block_wall_conveyor_right:
    !BYTE 1,10, $88           ;width and height and color
    !BYTE (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX

;--- wall_conveyor left
level_block_wall_conveyor_left:
    !BYTE 1,10, $88           ;width and height and color
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX

;--- wall_conveyor
level_block_wall_conveyor:
    !BYTE 3,8, $88            ;width and height and color
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor1_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor2_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor3_INDEX - first_sprite_192_INDEX) + hills_INDEX
    !BYTE (wall_conveyor4_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor5_INDEX - first_sprite_192_INDEX) + hills_INDEX, (wall_conveyor6_INDEX - first_sprite_192_INDEX) + hills_INDEX

;--- zapper
level_block_zapper:
    !BYTE 40,2, $de           ;width and height and color
    !BYTE 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177, 177
    !BYTE 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176

;--- ceiling plant 5
level_block_ceiling_plant5:
    !BYTE 10,2, $de           ;width and height and color
    !BYTE 138,138,104,101,104,104,104,101,104,138
    !BYTE 0,0,0,103,0,0,0,103,0,0

;--- platform_bottom_only
level_block_platform_bottom_only:
    !BYTE 40,1, $de           ;width and height and color
    !BYTE 137,255
    
;--- underground door 6
level_block_underground_door6:
    !BYTE 3,6, $de            ;width and height and color
    !BYTE 38,38,38
    !BYTE 39,39,39
    !BYTE 43,21,42
    !BYTE 90,24,91
    !BYTE 43,21,42
    !BYTE 30,30,30
    
;--- double lamp hangers
level_block_double_lamp_hangers:
    !BYTE 2,1, $de            ;width and height and color
    !BYTE 36,47

;--- underground door 5
level_block_underground_door5:
    !BYTE 4,8, $de            ;width and height and color
    !BYTE 43,21,21,42
    !BYTE 90,24,24,91
    !BYTE 22,21,21,20
    !BYTE 25,66,66,23
    !BYTE 22,21,21,20
    !BYTE 25,66,66,23
    !BYTE 43,21,21,42
    !BYTE 90,24,24,91    
    
;--- underground level corner
level_block_underground_level_corner:
    !BYTE 1,2, $de            ;width and height and color
    !BYTE 21,30
    
;--- corner plant upper left
level_block_corner_plant_ul:
    !BYTE 6,2, $de            ;width and height and color
    !BYTE 100,101,104,101,102,104
    !BYTE 102,103,0,0,0,0

;--- underground ceiling 2
level_block_underground_ceiling2:
    !BYTE 20,2, $de           ;width and height and color
    !BYTE 132,132,132,132,132,132,132,132,132,132,132,132,132,132,132,132,132,132,132,132
    !BYTE 146,146,146,146,146,146,146,146,146,146,146,146,146,146,146,146,146,146,146,146

;--- thin metal platform
level_block_thin_metal_platform:
    !BYTE 8,2, $de            ;width and height and color
    !BYTE 52,52,52,52,52,52,52,52
    !BYTE 137,137,137,137,137,137,137,137

;--- lamp hanger down right
level_block_lamp_hanger3_right:
    !BYTE 1,3, $de            ;width and height and color
    !BYTE 171,171,47

;--- lamp hanger down left
level_block_lamp_hanger3_left:
    !BYTE 1,3, $de            ;width and height and color
    !BYTE 168,169,36

;--- underground door 4
level_block_underground_door4:
    !BYTE 4,8, $de            ;width and height and color
    !BYTE 38,38,38,38
    !BYTE 39,39,39,39
    !BYTE 43,21,21,42
    !BYTE 90,24,24,91
    !BYTE 43,21,21,42
    !BYTE 90,24,24,91
    !BYTE 40,40,40,40
    !BYTE 41,41,41,41

;--- platform end 2 right
level_block_platform_end2_right:
    !BYTE 3,3, $de            ;width and height and color
    !BYTE 48,48,56
    !BYTE 49,49,59
    !BYTE 36,0,47

;--- platform end 2 left
level_block_platform_end2_left:
    !BYTE 3,3, $de            ;width and height and color
    !BYTE 54,32,32
    !BYTE 57,34,34
    !BYTE 36,0,47

;--- ladder 6
level_block_ladder6:
    !BYTE 4,4, $cc            ;width and height and color
    !BYTE 167,167,167,167
    !BYTE 39,39,39,39
    !BYTE 167,167,167,167
    !BYTE 39,39,39,39

;--- black block
level_block_black_block:
    !BYTE 4,4, $de            ;width and height and color
    !BYTE 163,163,163,163
    !BYTE 164,164,164,164
    !BYTE 163,163,163,163
    !BYTE 164,164,164,164
    
;--- black ground
level_block_black_ground:
    !BYTE 40,2, $de           ;width and height and color
    !BYTE black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX
    !BYTE black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX,black_wall2_INDEX
    !BYTE black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX
    !BYTE black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX,black_wall1_INDEX

;--- black wall
level_block_black_wall:
    !BYTE 1,24, $de           ;width and height and color
    !BYTE black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX
    !BYTE black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX
    !BYTE black_wall2_INDEX,black_wall1_INDEX,black_wall2_INDEX,black_wall1_INDEX
    
;--- conveyor wide
level_block_conveyor_wide:
    !BYTE 4,24, $cc           ;width and height and color
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor5_INDEX,conveyor6_INDEX

;--- swords down
level_block_swords_down:
    !BYTE 12,2, $de           ;width and height and color
    !BYTE 151,151,151,151,151,151,151,151,151,151,151,151
 ;            D183 : 97 97 97 97 97 97 
    !BYTE 71,71,71,71,71,71,71,71,71,71,71,71
 ;            D18F : 47 47 47 47 47 47 

;--- ceiling plant 4
level_block_ceiling_plant4:
    !BYTE 6,2, $de            ;width and height and color
    !BYTE 104,104,100,101,104,100
    !BYTE 0,0,102,103,0,102

;--- ceiling plant 3
level_block_ceiling_plant3:
    !BYTE 5,2, $de            ;width and height and color
    !BYTE 104,104,101,138,104
    !BYTE 0,0,103,0,0

;--- ceiling plant 2
level_block_ceiling_plant2:
    !BYTE 3,2, $de            ;width and height and color
    !BYTE 104,101,104
    !BYTE 0,103,0

;--- ceiling plant 1
level_block_ceiling_plant1:
    !BYTE 3,2, $de            ;width and height and color
    !BYTE 138,101,138
    !BYTE 0,103,0

;--- underground platform left 2
level_block_underground_plaftorm_left2:
    !BYTE 1,2, $de            ;width and height and color
    !BYTE 149,150

;--- underground door 3
level_block_underground_door3:
    !BYTE 3,9, $de            ;width and height and color
    !BYTE 148,148,148
    !BYTE 21,21,21
    !BYTE 24,24,24
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 40,40,40
    !BYTE 148,148,148
    
;--- underground door 2
level_block_underground_door2:
    !BYTE 3,6, $de            ;width and height and color
    !BYTE 148,148,148
    !BYTE 21,21,21
    !BYTE 24,24,24
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 40,40,40
    
;--- underground door 1
level_block_underground_door1:
    !BYTE 3,7, $de            ;width and height and color
    !BYTE 38,38,38
    !BYTE 39,39,39
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 40,40,40

;--- black column ceiling 2
level_block_black_column_ceiling2:
    !BYTE 1,3, $de            ;width and height and color
    !BYTE 132,wall_bottom_2_INDEX,137

;--- black column ceiling
level_block_black_column_ceiling:
    !BYTE 1,3, $de            ;width and height and color
    !BYTE 46,46,137

;--- black column only
level_block_black_column_only:
    !BYTE 1,25, $de           ;width and height and color
    !BYTE 46,46,46,255

;--- double ceiling black console
level_block_double_ceiling_black_console:
    !BYTE 5,1, $de            ;width and height and color
    !BYTE 132,144,144,144,132

;--- conveyor
level_block_conveyor:
    !BYTE 3,24, $cc           ;width and height and color
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX
    !BYTE conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX,conveyor1_INDEX,conveyor2_INDEX,conveyor3_INDEX,conveyor4_INDEX,conveyor5_INDEX,conveyor6_INDEX

;--- underworld platform_right_end
level_block_underworld_platform_right_end:
    !BYTE 1,2, $de            ;width and height and color
    !BYTE 133,135

;--- underworld platform_left_end
level_block_underworld_platform_left_end:
    !BYTE 1,2, $de            ;width and height and color
    !BYTE 134,136
    
;--- underworld platform
level_block_underworld_platform:
    !BYTE 40,2, $de           ;width and height and color
    !BYTE 131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131,131           ;Characters for block
    !BYTE wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX
    
;--- underworld ceiling
level_block_underworld_ceiling:
    !BYTE 40,2, $de           ;width and height and color
    !BYTE platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX,platform_top1_INDEX
    !BYTE wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX,wall_bottom_2_no_wall_INDEX
    
;--- bull 
level_block_bull:
    !BYTE 6,10, $3a           ;width and height and color
    !BYTE 1,0,2,3,0,0       ;Characters for block
    !BYTE 4,5,6,7,8,0
    !BYTE 9,10,11,12,12,13
    !BYTE 14,15,16,17,18,19
    !BYTE 0,20,21,21,22,0
    !BYTE 0, 23,24,24,25,0
    !BYTE 0,21,21,21,21,0
    !BYTE 0,24,24,24,24,0
    !BYTE 26,27,27,27,27,28
    !BYTE 29,30,30,30,30,31

;--- ground 
level_block_ground:
    !BYTE 40,1, $3a           ;width and height and color
    !BYTE 31                ;Characters for block
    !BYTE 255             ; repeat last character till the end of the block
    
;--- platform end 
level_block_platform_end_left:
    !BYTE 2,3, $3a            ;width and height and color
    !BYTE 32,33       ;Characters for block
    !BYTE 34,35
    !BYTE 36,37
    
  ;--- platform1  
level_block_platform:
    !BYTE 15,3, $3a           ;width and height and color
    !BYTE 33,33,33,33,33,33,33,33,33,33,33,33,33,33,33      ;Characters for block
    !BYTE 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
    !BYTE 37,37,37,37,37,37,37,37,37,37,37,37,37,37,37
    
;--- column 1
level_block_column1:
    !BYTE 1,6, $3a            ;width and height and color
    !BYTE 38            ;Characters for block
    !BYTE 39
    !BYTE 12
    !BYTE 12
    !BYTE 40
    !BYTE 41        

;--- column 2
level_block_column2:
    !BYTE 1,6 , $3a           ;width and height and color
    !BYTE 38            ;Characters for block
    !BYTE 39
    !BYTE 21
    !BYTE 24
    !BYTE 21
    !BYTE 30        

;--- door1
level_block_door1:
    !BYTE 2,6 , $3a           ;width and height and color
    !BYTE 38, 38            ;Characters for block
    !BYTE 39,39
    !BYTE 22,20
    !BYTE 25, 23
    !BYTE 42,42
    !BYTE 30,30

;--- column 3
level_block_column3:
    !BYTE 1,6, $3a            ;width and height and color
    !BYTE 38            ;Characters for block
    !BYTE 44
    !BYTE 46
    !BYTE 46
    !BYTE 46
    !BYTE 45        

;--- platform end  right
level_block_platform_end_right:
    !BYTE 2,3, $3a            ;width and height and color
    !BYTE 33,48       ;Characters for block
    !BYTE 35,49
    !BYTE 37,47
    
;--- platform2  thick
level_block_platform2_thick:
    !BYTE 15,2, $3a           ;width and height and color
    !BYTE 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50        ;Characters for block
    !BYTE 51,51,51,51,51,51,51,51,51,51,51,51,51,51,51

;--- platform2  thin
level_block_platform2_thin:
    !BYTE 15,2, $3a           ;width and height and color
    !BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0       ;Characters for block
    !BYTE 52,52,52,52,52,52,52,52,52,52,52,52,52,52,52
        
;--- statue 1
level_block_statue1:
    !BYTE 3,4, $3a          ;width and height and color
    !BYTE 54, 55,56         ;Characters for block
    !BYTE 57, 58, 59
    !BYTE 60,61,62
    !BYTE 63,64,65
    
;--- door column left
level_block_door_column_left:
    !BYTE 1,5, $3a          ;width and height and color
    !BYTE 38              ;Characters for block
    !BYTE 39  
    !BYTE 22
    !BYTE 25
    !BYTE 40
    
;--- door column right
level_block_door_column_right:
    !BYTE 1,5 , $3a         ;width and height and color
    !BYTE 38              ;Characters for block
    !BYTE 39
    !BYTE 20
    !BYTE 23
    !BYTE 40
    
;--- door 2
level_block_door2:
    !BYTE 2,5 , $3a         ;width and height and color
    !BYTE 38,38           ;Characters for block
    !BYTE 39,39           
    !BYTE 21,21
    !BYTE 66,66
    !BYTE 40, 40
    
;--- ladder 1
level_block_ladder1:
    !BYTE 2,6 , $ae         ;width and height and color
    !BYTE 67,68           ;Characters for block
    !BYTE 67,68
    !BYTE 67,68
    !BYTE 67,68
    !BYTE 67,68
    !BYTE 67,68
    
;--- ladder 2
level_block_ladder2:
    !BYTE 2,2 , $ae         ;width and height and color
    !BYTE 68,68           ;Characters for block
    !BYTE 69,69
    
;--- empty
level_block_empty:
    !BYTE 40,20, $3a          ;width and height and color
    !BYTE 0             ;Characters for block
    !BYTE 255             ; repeat last character till the end of the block
    
;--- spike down
level_block_spike_down:
    !BYTE 1,3 , $3a         ;width and height and color
    !BYTE 70              ;Characters for block
    !BYTE 71
    !BYTE 36
    
;--- sky
level_block_sky:
    !BYTE 40,8 , $ee          ;width and height and color
    !BYTE 83              ;Characters for block 
    !BYTE 255             ; repeat last character till the end of the block
    
;--- hill 1
level_block_hill1:
    !BYTE 10,6 , $ee          ;width and height and color
    !BYTE 72,73,74,73,74,74,73,74,75,83   ;Characters for block 
    !BYTE 76,77,78,77,78,78,77,78,79,80
    !BYTE 00,00,81,00,82,00,00,82,0,255; spaces till the end of the block   
    
;--- hill 1 righ
level_block_hill1_right:
    !BYTE 2,6 , $ee         ;width and height and color
    !BYTE 75,83           ;Characters for block 
    !BYTE 79,80
    !BYTE 00,255            ; spaces till the end of the block    

;--- hill 2 high
level_block_hill2_high:
    !BYTE 3,6 , $ee         ;width and height and color
    !BYTE 83,83,83          ;Characters for block 
    !BYTE 83,83,85
    !BYTE 83,86,0
    !BYTE 85,87,0,255
    
;--- hill 2 high right
level_block_hill2_high_right:
    !BYTE 3,3 , $ee         ;width and height and color
    !BYTE 80,83,83          ;Characters for block 
    !BYTE 00,89,83
    !BYTE 0,0,80
    
;--- hill 2 high left
level_block_hill2_high_left:
    !BYTE 2,2 , $ee         ;width and height and color
    !BYTE 83,86           ;Characters for block 
    !BYTE 85,87
    
;--- door 3
level_block_door3:
    !BYTE 3,5 , $3a         ;width and height and color
    !BYTE 38,38,38          ;Characters for block 
    !BYTE 39,39,39
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 40,40,40
    
;--- door 4
level_block_door4:
    !BYTE 3,5 , $3a         ;width and height and color
    !BYTE 38,38,38          ;Characters for block 
    !BYTE 39,39,39
    !BYTE 43,21,42
    !BYTE 90,66,91
    !BYTE 40,40,40
    
;--- column 3
level_block_column3_short:
    !BYTE 1,5, $3a          ;width and height and color
    !BYTE 38              ;Characters for block
    !BYTE 44
    !BYTE 46
    !BYTE 46
    !BYTE 92            
    
;--- door 5
level_block_door5:
    !BYTE 3,6 , $3a         ;width and height and color
    !BYTE 38,38,38          ;Characters for block 
    !BYTE 39,39,39
    !BYTE 22,21,20
    !BYTE 25,66,23
    !BYTE 43,21,42
    !BYTE 30,30,30    
    
;--- small hinge
level_block_small_hinge:
    !BYTE 2,1 , $3a         ;width and height and color
    !BYTE 93,94           ;Characters for block 
        
;--- small ladder
level_block_small_ladder:
    !BYTE 2,2 , $ff         ;width and height and color
    !BYTE 95,96           ;Characters for block 
    !BYTE 97,98
    
;--- lid
level_block_lid:
    !BYTE 2,2 , $3a         ;width and height and color
    !BYTE 50,50           ;Characters for block 
    !BYTE 99,99
    
;--- hill 3
level_block_hill3:
    !BYTE 11,3 , $ee          ;width and height and color
    !BYTE 83,72,73,74,75,73,74,75,73,73,75    ;Characters for block 
    !BYTE 85,76,77,78,79,77,78,79,77,77,79
    !BYTE 0,81,88,82,0,0,81,0,88,81,0

;--- hilltop
level_block_hilltop:
    !BYTE 4,3 , $ee         ;width and height and color
    !BYTE 72,73,73,75
    !BYTE 76,77,77,79
    !BYTE 0,81,0,81

;--- hill 4
level_block_hill4:
    !BYTE 7,3 , $ee         ;width and height and color
    !BYTE 83,72,73,73,74,74,75
    !BYTE 83,76,77,77,78,78,79
    !BYTE 86,88,0,81,0,88,0

;--- white column middle
level_block_column_m:
    !BYTE 1,20 , $3a          ;width and height and color
    !BYTE 12,255

;--- ladder 3
level_block_ladder3:
    !BYTE 3,6 , $ae         ;width and height and color
    !BYTE 69,68,67
    !BYTE 69,68,67
    !BYTE 69,68,67
    !BYTE 69,68,67
    !BYTE 69,68,67
    !BYTE 69,68,67

;--- ladder 4
level_block_ladder4:
    !BYTE 3,2 , $ae         ;width and height and color
    !BYTE 68,68,68
    !BYTE 69,69,69

;--- double column
level_block_double_column:
    !BYTE 1,12 , $3a          ;width and height and color
    !BYTE 46,46,46,46,46,45,12,12,12,12,40,41

;--- double column black
level_block_double_column_black:
    !BYTE 1,12 , $3a          ;width and height and color
    !BYTE 46,46,46,46,46,45,46,46,46,46,46,45

;--- upper left corner
level_block_upper_left_corner:
    !BYTE 2,2 , $3a         ;width and height and color
    !BYTE 100,101
    !BYTE 102,103

;--- upper right corner
level_block_upper_right_corner:
    !BYTE 2,2 , $3a         ;width and height and color
    !BYTE 104,101
    !BYTE 0,103

;--- warp 1
level_block_warp1:
    !BYTE 6,6 , $3a         ;width and height and color
    !BYTE warp1_INDEX, warp1_INDEX,  warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX, warp1_INDEX,255

;--- warp 2
level_block_warp2:
    !BYTE 6,6 , $3a         ;width and height and color
    !BYTE  warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX, warp2_INDEX,255

;--- warp 3
level_block_warp3:
    !BYTE 6,6 , $3a         ;width and height and color
    !BYTE warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, warp3_INDEX, 255

;--- warp 4
level_block_warp4:
    !BYTE 6,6 , $3a         ;width and height and color
    !BYTE warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, warp4_INDEX, 255

;--- warp 4 near lid
level_block_warp4_near_lid:
    !BYTE 4,2 , $3a         ;width and height and color
    !BYTE 50,50, 0, 0           ;Characters for block 
    !BYTE 99,99, warp4_INDEX,warp4_INDEX
    
;--- door 6
level_block_door6:
    !BYTE 3,6 , $3a         ;width and height and color
    !BYTE 38,38,38          ;Characters for block 
    !BYTE 39,39,39
    !BYTE 43,21,42
    !BYTE 90,66,91
    !BYTE 43,21,42
    !BYTE 30,30,30
    
;--- lamp hanger 1
level_block_lamp_hanger1:
    !BYTE 1,1 , $3a         ;width and height and color
    !BYTE 36
    
;--- lamp hanger 2
level_block_lamp_hanger2:
    !BYTE 1,1 , $3a         ;width and height and color
    !BYTE 47
    
;--- bastille small
level_block_bastille_small:
    !BYTE 5,2 , $3a         ;width and height and color
    !BYTE 123,0,127,0,123
    !BYTE 124,125,12,125,126
    
;--- bastille wall
level_block_bastille_wall:
    !BYTE 8,8 , $3a         ;width and height and color
    !BYTE 12,12,12,12,12,12,12,12,12,255

;--- bastille wall windows
level_block_bastille_wall_windows:
    !BYTE 1,4 , $3a         ;width and height and color
    !BYTE 21,66,21,24
    
;--- bastille wall column 1
level_block_column_white_bastille:
    !BYTE 1,3 , $3a         ;width and height and color
    !BYTE 24,40,41

;--- bastille grid
level_block_bastille_grid:
    !BYTE 3,8 , $3a         ;width and height and color
    !BYTE 24,66,24
    !BYTE 21,21,21
    !BYTE 24,66,24
    !BYTE 21,21,21
    !BYTE 24,66,24
    !BYTE 21,21,21
    !BYTE 24,66,24
    !BYTE 21,21,21

;--- bastille grid top
level_block_bastille_grid_top:
    !BYTE 3,1 , $3a         ;width and height and color
    !BYTE 20,21,22
    
;--- bastille grid top 2
level_block_bastille_grid_top2:
    !BYTE 3,1 , $3a         ;width and height and color
    !BYTE 22,21,20
    
;--- ladder 5
level_block_ladder5:
    !BYTE 2,8 , $ae         ;width and height and color
    !BYTE 68,67,68,67,68,67,68,67,68,67,68,67,68,67,68,67,255
    
;--- bastille big
level_block_bastille_big:
    !BYTE 11,4 , $3a          ;width and height and color
    !BYTE 123,0,123,0,127,0,127,0,123,0,123
    !BYTE 124,125,124,125,12,125,12,125,126,125,126
    !BYTE 0,12,12,12,21,12,21,12,12,12,0
    !BYTE 0,128,12,12,66,12,66,12,12,129,0
    
;--- bastille medium
level_block_bastille_medium:
    !BYTE 7,4 , $3a         ;width and height and color
    !BYTE 123,0,123,0,123,0,123
    !BYTE 124,125,124,125,126,125,126
    !BYTE 0,12,12,12,12,12,0
    !BYTE 0,128,12,12,12,129,0
    
;--- swords up
level_block_swords_up:
    !BYTE 8,2 , $3a         ;width and height and color
    !BYTE 71,71,71,71,71,71,71,71
    !BYTE 130,130,130,130,130,130,130,130
    
add_score
    ;byt    $f2
    asl
    asl
    asl
    clc
    adc   #$05
    tay
    ldx   #$05
-   lda   score_placement_on_screen_memory,x
    clc
    adc   scores_to_add + 2,y
    cmp   #digit_9_INDEX + 1
    bcc   +
    inc   score_placement_on_screen_memory - 1,x
    inc   score_placement_on_screen_memory2 - 1,x
    sec
    sbc   #$0a
+
    sta     score_placement_on_screen_memory,x
    sta     score_placement_on_screen_memory2,x
    dey
    dex
    cpx   #$00
    bne   -
    rts

;50 Landing on Ninja or on Yamo
;75 Kick at Ninja or Yamo
;100  Punch on Ninja or Yamo
;125  Collecting lanterns
;200  Victory over Ninja
;450  Victory over Yamo
;2000 Enter new room
;3000 Victory over sorcerer

scores_to_add
    !BYTE   0,0,0,0,0,0,5,0
    !BYTE   0,0,0,0,0,0,7,5
    !BYTE   0,0,0,0,0,1,0,0
    !BYTE   0,0,0,0,0,1,2,5
    !BYTE   0,0,0,0,0,2,0,0
    !BYTE   0,0,0,0,0,4,5,0
    !BYTE   0,0,0,0,2,0,0,0

info_bar_text_top   
    !BYTE   0,0, letter_t_INDEX,letter_o_INDEX,letter_p_INDEX,00
info_bar_text_falls   
    !BYTE   letter_f_INDEX,letter_a_INDEX,letter_l_INDEX,letter_l_INDEX,letter_s_INDEX,0
falls_counter
    !BYTE   0,0
high_score    
    !BYTE   digit_zero_INDEX,digit_zero_INDEX,digit_zero_INDEX,digit_zero_INDEX,digit_zero_INDEX,digit_zero_INDEX
current_player
    !BYTE   0

number_of_swapped_chars_hills   =  17;(hills_17_INDEX - hills_INDEX)
number_of_swapped_chars_bull    =  19;(bull_postament_end_INDEX - bull_INDEX)
number_of_swapped_chars_statue    =  12;

* = $f800
character_set_swap_buffer
    !FILL   number_of_swapped_chars_hills * 8,0

character_set_swap_buffer_warp_dev_chars 
    !FILL    8 * 4,0
character_set_swap_buffer_bull 
    !FILL    number_of_swapped_chars_bull * 8,0
character_set_swap_buffer_statue
    !FILL    number_of_swapped_chars_statue * 8,0

show_player_id
    lda   level_time
    and   #$10
    beq   show_score_flashing
hide_score_flashing
    ldx   #$00
    txa
-   sta   screen_mem_buffer1+4,x
    sta   screen_mem_buffer2+4,x
    inx
    cpx   #$03
    bne   -
    rts
show_score_flashing
    ldx   #$00
-   lda   info_bar_1_up,x
    sta   screen_mem_buffer1+4,x
    sta   screen_mem_buffer2+4,x
    inx
    cpx   #$03
    bne   -
    rts

info_bar_1_up
    !BYTE   digit_1_INDEX, letter_u_INDEX,letter_p_INDEX
    
show_info_bar
    ldx   #$00
-   lda   info_bar_text_top,x
    sta   screen_mem_buffer1 + 14,x
    sta   screen_mem_buffer2 + 14,x
    lda   high_score,x
    sta   screen_mem_buffer1 + 20,x
    sta   screen_mem_buffer2 + 20,x
    
    lda   info_bar_text_falls,x
    sta   screen_mem_buffer1 + 28,x
    sta   screen_mem_buffer2 + 28,x
    inx
    cpx   #$06
    bne   -
    
    ;show "falls"
    lda   falls_counter
    sta   screen_mem_buffer1 + 34
    sta   screen_mem_buffer2 + 34
    lda   falls_counter + 1
    sta   screen_mem_buffer1 + 35
    sta   screen_mem_buffer2 + 35

    rts

;----------------------------------------------
; SHOW PLAYER SCORES    AC - player 0/1
;---------------------------------------------
show_player_score
    bne   +
    ldx   #$00
-   lda   score_player1,x
    sta   score_placement_on_screen_memory,x
    sta   score_placement_on_screen_memory2,x
    inx
    cpx   #6
    bne   -
    lda   #digit_1_INDEX
    sta   info_bar_1_up  ;overwrite player number on flashing bar
    rts
+
    ldx   #$00
-   lda   score_player2,x
    sta   score_placement_on_screen_memory,x
    sta   score_placement_on_screen_memory2,x
    inx
    cpx   #6
    bne   -
    lda   #digit_2_INDEX
    sta   info_bar_1_up  ;overwrite player number on flashing bar
    rts
    
;--------------------------------------------------
reset_player_scores
    ldx   #$00
-   lda   #digit_zero_INDEX
    sta   score_player1,x
    ;lda    #digit_1_INDEX
    sta   score_player2,x
    inx
    cpx   #6
    bne   -
    rts
    
score_player1
    !FILL   6,0
score_player2
    !FILL   6,0
    
next_random_pointer
    !BYTE   00

get_next_random_number
    stx   rndret +1
    inc   next_random_pointer
    ldx   next_random_pointer
    lda   random_numbers_table, x
rndret
    ldx   #$00
    rts

random_numbers_table
    !BYTE $84, $4b, $4a, $b9, $fe, $73, $36, $9d, $58, $65, $5c, $6d, $e3, $d2, $a4, $62
    !BYTE $16, $06, $bc, $5a, $64, $f5, $b4, $81, $0d, $9e, $f7, $a6, $40, $a2, $e2, $23
    !BYTE $13, $3d, $fb, $1e, $6e, $21, $9a, $0b, $37, $95, $8a, $4f, $7a, $42, $52, $fd
    !BYTE $a1, $74, $38, $11, $8f, $96, $c8, $60, $f1, $d4, $3e, $f6, $f4, $24, $ba, $8b
    !BYTE $bf, $be, $66, $97, $c0, $59, $bd, $19, $ec, $cd, $b5, $54, $2d, $aa, $12, $33
    !BYTE $7d, $4c, $5b, $15, $43, $76, $da, $bb, $dc, $eb, $05, $0a, $d9, $77, $b7, $d1
    !BYTE $db, $93, $32, $b0, $89, $8e, $85, $8c, $e1, $ac, $39, $3a, $4e, $a3, $cf, $2e
    !BYTE $69, $68, $61, $94, $53, $b3, $29, $57, $2a, $9c, $72, $f0, $1c, $b8, $cb, $56
    !BYTE $ca, $c3, $04, $46, $2c, $af, $0f, $ce, $b1, $92, $c5, $b2, $e7, $c7, $1f, $e6
    !BYTE $5d, $8d, $67, $55, $22, $88, $ff, $90, $86, $7f, $27, $5e, $f3, $4d, $71, $6b
    !BYTE $28, $47, $a8, $70, $ad, $45, $35, $ed, $a0, $26, $dd, $25, $d3, $3f, $7e, $cc
    !BYTE $83, $ef, $20, $01, $09, $18, $c6, $6f, $fa, $e5, $ee, $78, $c4, $c1, $07, $14
    !BYTE $df, $9b, $c9, $e0, $1b, $e8, $79, $9f, $d7, $82, $48, $a7, $00, $0c, $99, $31
    !BYTE $f9, $6c, $2f, $49, $2b, $5f, $d5, $e9, $87, $de, $50, $b6, $63, $80, $d6, $3c
    !BYTE $02, $f8, $44, $75, $98, $fc, $ab, $17, $0e, $d8, $7b, $41, $f2, $a5, $e4, $30
    !BYTE $3b, $a9, $7c, $6a, $51, $ae, $08, $03, $10, $d0, $c2, $ea, $91, $1d, $34, $1a

title_screen
    sei
    

    lda   #$0b
    jsr   show_hide_screen
    
    ;jsr    (music_player_init - music_data_start) + music_target_memory

    jsr   clear_screen    
    ldx   #$00
    sty   $ff11
-
    lda   #$61
    sta   $0800,x
    sta   $08c0,x
    sta   $0b00,x
    lda   #$71
    sta   $09c3,x
    sta   $0ac3,x
    inx
    bne   -
    lda   #$08
    sta   $ff12
    lda   $ff07
    and   #$40
    ora   #$08
    sta   $ff07
    lda   #$d8
    sta   $ff13
    lda   #title_scree_blue
    sta   $ff15
    sta   $ff19
    
    ;texts
    ;ldx    #$00
;-    lda   title_text_1,x    ;datasoft presents
;   sta   $0c2b,x
;   lda   title_text_2,x    ;by ron j fortier
;   sta   $0d43,x
;   inx
;   cpx   #34
;   bne   -
    
    ldx   #$00
-
    lda   title_text_3_line1,x    ;bruce lee top
    sta   $0cab,x
    beq   +
    clc
    adc   #$02
+   ;bottom
    sta   $0cd3,x
    inx
    cpx   #20
    bne   -
    
    ldx   #$00
    stx   $0cd3 + 19 - 6
    stx   $0cd3 + 18 - 6
-   lda   menu_line1,x    
    sta   $0dc3,x
    lda   menu_line2,x  
    sta   $0e13,x
    lda   menu_line3,x  
    sta   $0e63,x
    inx
    cpx   #25
    bne   -
    
    ldx   #$00
    ldy   #((version_info - upper_bound_charset) / 8)
-   tya
    sta   $0fde,x
    iny
    inx
    cpx   #10
    bne   -
    
    ;byt  $f2
    jsr   (PLAYER_INIT - music_data_start) + music_target_memory

    lda   #menu_irq >> 8
    sta   $ffff
    lda   #menu_irq & $ff
    sta   $fffe
    lda   #$80
    sta   $ff0b
    cli
    
    lda   #$00
    sta   DEVELOPER_MODE

    jsr   repaint_menu
    lda   #$1b
    jsr   show_hide_screen

menu_cycle    
    lda   #$fe
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ef
    beq   f1_pressed
    cmp   #$df
    beq   f2_pressed
    cmp   #$bf
    beq   f3_pressed
    
    jsr   check_dev_mode
    
    lda   menu_timer + 1
    cmp   #$08
    bcs   start_demo_mode
    jmp   menu_cycle

start_demo_mode
    lda   #$0b
    jsr   show_hide_screen
    lda   #control_method_ai
    sta   sumo_control_method
    sta   ninja_control_method
    sta   player_control_method
    lda   #$00
    sta   $ff11
    rts
    
f1_pressed
    lda   game_players
    clc
    adc   #$01
    and   #$01
    sta   game_players
    jsr   repaint_menu
    jsr   wait_for_key_release
    jmp   menu_cycle

f2_pressed
    lda   game_opponents
    clc
    adc   #$01
    cmp   #$03
    bcc   +
    lda   #$00
+   sta   game_opponents
    jsr   repaint_menu
    jsr   wait_for_key_release
    jmp   menu_cycle
    
f3_pressed  
    lda   #$0b
    jsr   show_hide_screen
    lda   #$00
    sta   $ff11
    lda   #control_method_joy2
    sta   player_control_method
    lda   game_opponents
    cmp   #$01
    beq   one_numan_opponent
    cmp   #$02
    beq   two_numan_opponents
    lda   #control_method_ai
    sta   sumo_control_method
    sta   ninja_control_method
    rts
one_numan_opponent
    lda   #control_method_joy1
    sta   sumo_control_method
    lda   #control_method_ai
    sta   ninja_control_method
    rts
two_numan_opponents
    lda   #control_method_joy1
    sta   sumo_control_method
    lda   #control_method_keyboard
    sta   ninja_control_method
    rts
    
upper_bound_charset = $d800
*     = upper_bound_charset

; ==================== Retro Sprite Workshop Project (I:\plus4\Microassembler\bruce lee\bruce lee letters.inc) ========================
; Generated On:       2022. 03. 17. 14:24:03
; Project Name:       Bruce Lee
; Project Comments:   
; Target Platform:    Commodore 16/Plus4
; Project Created On: 2022.02.12 11:22:33

; ==================== Sprite 1 ========================
; Sprite ID:       char_space2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

char_space2_WIDTH_PX    = 8
char_space2_HEIGHT_PX   = 8
char_space2_BIT_PER_PX  = 2
char_space2_INDEX       = 0
char_space2_NUM_FRAMES  = 1
char_space2:
            !BYTE $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 2 ========================
; Sprite ID:       digit_zero
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_zero_WIDTH_PX    = 8
digit_zero_HEIGHT_PX   = 8
digit_zero_BIT_PER_PX  = 1
digit_zero_INDEX       = 1
digit_zero_NUM_FRAMES  = 1
digit_zero:
           !BYTE $3c, $66, $6e, $76, $66, $66, $3c, $00

; ==================== Sprite 3 ========================
; Sprite ID:       digit_1
; Sprite Comments: Captured from Screenshot (vice-screen-2022022418153806.png)
;                  PosX=120; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_1_WIDTH_PX    = 8
digit_1_HEIGHT_PX   = 8
digit_1_BIT_PER_PX  = 1
digit_1_INDEX       = 2
digit_1_NUM_FRAMES  = 1
digit_1:
        !BYTE $18, $18, $38, $18, $18, $18, $7e, $00

; ==================== Sprite 4 ========================
; Sprite ID:       digit_2
; Sprite Comments: Captured from Screenshot (vice-screen-2022022418153806.png)
;                  PosX=128; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_2_WIDTH_PX    = 8
digit_2_HEIGHT_PX   = 8
digit_2_BIT_PER_PX  = 1
digit_2_INDEX       = 3
digit_2_NUM_FRAMES  = 1
digit_2:
        !BYTE $3c, $66, $06, $0c, $30, $60, $7e, $00

; ==================== Sprite 5 ========================
; Sprite ID:       digit_3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_3_WIDTH_PX    = 8
digit_3_HEIGHT_PX   = 8
digit_3_BIT_PER_PX  = 1
digit_3_INDEX       = 4
digit_3_NUM_FRAMES  = 1
digit_3:
        !BYTE $3c, $66, $06, $1c, $06, $66, $3c, $00

; ==================== Sprite 6 ========================
; Sprite ID:       digit_4
; Sprite Comments: Captured from Screenshot (vice-screen-2022022418153806.png)
;                  PosX=312; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_4_WIDTH_PX    = 8
digit_4_HEIGHT_PX   = 8
digit_4_BIT_PER_PX  = 1
digit_4_INDEX       = 5
digit_4_NUM_FRAMES  = 1
digit_4:
        !BYTE $06, $0e, $1e, $66, $7f, $06, $06, $00

; ==================== Sprite 7 ========================
; Sprite ID:       digit_5
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=104; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_5_WIDTH_PX    = 8
digit_5_HEIGHT_PX   = 8
digit_5_BIT_PER_PX  = 1
digit_5_INDEX       = 6
digit_5_NUM_FRAMES  = 1
digit_5:
        !BYTE $7e, $60, $7c, $06, $06, $66, $3c, $00

; ==================== Sprite 8 ========================
; Sprite ID:       digit_6
; Sprite Comments: Captured from Screenshot (vice-screen-2022022716173714.png)
;                  PosX=120; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

digit_6_WIDTH_PX    = 8
digit_6_HEIGHT_PX   = 8
digit_6_BIT_PER_PX  = 1
digit_6_INDEX       = 7
digit_6_NUM_FRAMES  = 1
digit_6:
        !BYTE $3c, $66, $60, $7c, $66, $66, $3c, $00

; ==================== Sprite 9 ========================
; Sprite ID:       digit_7
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=96; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_7_WIDTH_PX    = 8
digit_7_HEIGHT_PX   = 8
digit_7_BIT_PER_PX  = 1
digit_7_INDEX       = 8
digit_7_NUM_FRAMES  = 1
digit_7:
        !BYTE $7e, $66, $0c, $18, $18, $18, $18, $00

; ==================== Sprite 10 ========================
; Sprite ID:       digit_8
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

digit_8_WIDTH_PX    = 8
digit_8_HEIGHT_PX   = 8
digit_8_BIT_PER_PX  = 1
digit_8_INDEX       = 9
digit_8_NUM_FRAMES  = 1
digit_8:
        !BYTE $3c, $66, $66, $3c, $66, $66, $3c, $00

; ==================== Sprite 11 ========================
; Sprite ID:       digit_9
; Sprite Comments: Captured from Screenshot (vice-screen-2022022809570947.png)
;                  PosX=120; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

digit_9_WIDTH_PX    = 8
digit_9_HEIGHT_PX   = 8
digit_9_BIT_PER_PX  = 1
digit_9_INDEX       = 10
digit_9_NUM_FRAMES  = 1
digit_9:
        !BYTE $3c, $66, $66, $3e, $06, $66, $3c, $00

; ==================== Sprite 12 ========================
; Sprite ID:       letter_a
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=232; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_a_WIDTH_PX    = 8
letter_a_HEIGHT_PX   = 8
letter_a_BIT_PER_PX  = 1
letter_a_INDEX       = 11
letter_a_NUM_FRAMES  = 1
letter_a:
         !BYTE $18, $3c, $66, $7e, $66, $66, $66, $00
;             D85E : 66 00             

; ==================== Sprite 13 ========================
; Sprite ID:       letter_b
; Sprite Comments: Captured from Screenshot (vice-screen-2022031111440711.png)
;                  PosX=190; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_b_WIDTH_PX    = 8
letter_b_HEIGHT_PX   = 8
letter_b_BIT_PER_PX  = 1
letter_b_INDEX       = 12
letter_b_NUM_FRAMES  = 1
letter_b:
         !BYTE $7c, $66, $66, $7c, $66, $66, $7c, $00

; ==================== Sprite 14 ========================
; Sprite ID:       letter_c
; Sprite Comments: Captured from Screenshot (vice-screen-2022031111440711.png)
;                  PosX=166; PosY=147
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_c_WIDTH_PX    = 8
letter_c_HEIGHT_PX   = 8
letter_c_BIT_PER_PX  = 1
letter_c_INDEX       = 13
letter_c_NUM_FRAMES  = 1
letter_c:
         !BYTE $3c, $66, $60, $60, $60, $66, $3c, $00

; ==================== Sprite 15 ========================
; Sprite ID:       letter_d
; Sprite Comments: Captured from Screenshot (vice-screen-2022031111440711.png)
;                  PosX=190; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_d_WIDTH_PX    = 8
letter_d_HEIGHT_PX   = 8
letter_d_BIT_PER_PX  = 1
letter_d_INDEX       = 14
letter_d_NUM_FRAMES  = 1
letter_d:
         !BYTE $7c, $66, $66, $66, $66, $66, $7c, $00

; ==================== Sprite 16 ========================
; Sprite ID:       letter_e
; Sprite Comments: Captured from Screenshot (vice-screen-2022031111440711.png)
;                  PosX=262; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_e_WIDTH_PX    = 8
letter_e_HEIGHT_PX   = 8
letter_e_BIT_PER_PX  = 1
letter_e_INDEX       = 15
letter_e_NUM_FRAMES  = 1
letter_e:
         !BYTE $7e, $60, $60, $78, $60, $60, $7e, $00

; ==================== Sprite 17 ========================
; Sprite ID:       letter_f
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=224; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_f_WIDTH_PX    = 8
letter_f_HEIGHT_PX   = 8
letter_f_BIT_PER_PX  = 1
letter_f_INDEX       = 16
letter_f_NUM_FRAMES  = 1
letter_f:
         !BYTE $7e, $60, $60, $78, $60, $60, $60, $00

; ==================== Sprite 18 ========================
; Sprite ID:       letter_t
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=128; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_t_WIDTH_PX    = 8
letter_t_HEIGHT_PX   = 8
letter_t_BIT_PER_PX  = 1
letter_t_INDEX       = 17
letter_t_NUM_FRAMES  = 1
letter_t:
         !BYTE $7e, $18, $18, $18, $18, $18, $18, $00

; ==================== Sprite 19 ========================
; Sprite ID:       letter_o
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=136; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_o_WIDTH_PX    = 8
letter_o_HEIGHT_PX   = 8
letter_o_BIT_PER_PX  = 1
letter_o_INDEX       = 18
letter_o_NUM_FRAMES  = 1
letter_o:
         !BYTE $3c, $66, $66, $66, $66, $66, $3c, $00

; ==================== Sprite 20 ========================
; Sprite ID:       letter_p
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=144; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_p_WIDTH_PX    = 8
letter_p_HEIGHT_PX   = 8
letter_p_BIT_PER_PX  = 1
letter_p_INDEX       = 19
letter_p_NUM_FRAMES  = 1
letter_p:
         !BYTE $7c, $66, $66, $7c, $60, $60, $60, $00

; ==================== Sprite 21 ========================
; Sprite ID:       letter_l
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=240; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_l_WIDTH_PX    = 8
letter_l_HEIGHT_PX   = 8
letter_l_BIT_PER_PX  = 1
letter_l_INDEX       = 20
letter_l_NUM_FRAMES  = 1
letter_l:
         !BYTE $60, $60, $60, $60, $60, $60, $7e, $00

; ==================== Sprite 22 ========================
; Sprite ID:       letter_s
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=256; PosY=0
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_s_WIDTH_PX    = 8
letter_s_HEIGHT_PX   = 8
letter_s_BIT_PER_PX  = 1
letter_s_INDEX       = 21
letter_s_NUM_FRAMES  = 1
letter_s:
         !BYTE $3c, $66, $60, $3c, $06, $66, $3c, $00

; ==================== Sprite 23 ========================
; Sprite ID:       letter_u
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=72; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_u_WIDTH_PX    = 8
letter_u_HEIGHT_PX   = 8
letter_u_BIT_PER_PX  = 1
letter_u_INDEX       = 22
letter_u_NUM_FRAMES  = 1
letter_u:
         !BYTE $66, $66, $66, $66, $66, $66, $3c, $00

; ==================== Sprite 24 ========================
; Sprite ID:       letter_asterisk
; Sprite Comments: Captured from Screenshot (vice-screen-2022031309452835.png)
;                  PosX=240; PosY=43
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      Vertical

letter_asterisk_WIDTH_PX    = 8
letter_asterisk_HEIGHT_PX   = 8
letter_asterisk_BIT_PER_PX  = 1
letter_asterisk_INDEX       = 23
letter_asterisk_NUM_FRAMES  = 1
letter_asterisk:
                !BYTE $00, $66, $3c, $ff, $3c, $66, $00, $00

; ==================== Sprite 25 ========================
; Sprite ID:       letter_y
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=294; PosY=131
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_y_WIDTH_PX    = 8
letter_y_HEIGHT_PX   = 8
letter_y_BIT_PER_PX  = 1
letter_y_INDEX       = 24
letter_y_NUM_FRAMES  = 1
letter_y:
         !BYTE $66, $66, $66, $3c, $18, $18, $18, $00

; ==================== Sprite 26 ========================
; Sprite ID:       letter_m
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=182; PosY=147
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_m_WIDTH_PX    = 8
letter_m_HEIGHT_PX   = 8
letter_m_BIT_PER_PX  = 1
letter_m_INDEX       = 25
letter_m_NUM_FRAMES  = 1
letter_m:
         !BYTE $63, $77, $7f, $6b, $63, $63, $63, $00

; ==================== Sprite 27 ========================
; Sprite ID:       letter_g
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=206; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_g_WIDTH_PX    = 8
letter_g_HEIGHT_PX   = 8
letter_g_BIT_PER_PX  = 1
letter_g_INDEX       = 26
letter_g_NUM_FRAMES  = 1
letter_g:
         !BYTE $3c, $66, $60, $6e, $66, $66, $3c, $00

; ==================== Sprite 28 ========================
; Sprite ID:       letter_i
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=214; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_i_WIDTH_PX    = 8
letter_i_HEIGHT_PX   = 8
letter_i_BIT_PER_PX  = 1
letter_i_INDEX       = 27
letter_i_NUM_FRAMES  = 1
letter_i:
         !BYTE $3c, $18, $18, $18, $18, $18, $3c, $00

; ==================== Sprite 29 ========================
; Sprite ID:       letter_n
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=222; PosY=163
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_n_WIDTH_PX    = 8
letter_n_HEIGHT_PX   = 8
letter_n_BIT_PER_PX  = 1
letter_n_INDEX       = 28
letter_n_NUM_FRAMES  = 1
letter_n:
         !BYTE $66, $76, $7e, $7e, $6e, $66, $66, $00

; ==================== Sprite 30 ========================
; Sprite ID:       letter_r
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=78; PosY=147
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_r_WIDTH_PX    = 8
letter_r_HEIGHT_PX   = 8
letter_r_BIT_PER_PX  = 1
letter_r_INDEX       = 29
letter_r_NUM_FRAMES  = 1
letter_r:
         !BYTE $7c, $66, $66, $7c, $78, $6c, $66, $00

; ==================== Sprite 31 ========================
; Sprite ID:       double_d
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=64; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_d_WIDTH_PX    = 16
double_d_HEIGHT_PX   = 8
double_d_BIT_PER_PX  = 1
double_d_INDEX       = 30
double_d_NUM_FRAMES  = 1
double_d:
         !BYTE $00, $3f, $3c, $3c, $3c, $3c, $3f, $00, $00, $c0, $f0, $3c, $3c, $f0, $c0, $00

; ==================== Sprite 32 ========================
; Sprite ID:       double_a
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=80; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_a_WIDTH_PX    = 16
double_a_HEIGHT_PX   = 8
double_a_BIT_PER_PX  = 1
double_a_INDEX       = 31
double_a_NUM_FRAMES  = 1
double_a:
         !BYTE $00, $03, $0f, $3c, $3f, $3c, $3c, $00, $00, $c0, $f0, $3c, $fc, $3c, $3c, $00

; ==================== Sprite 33 ========================
; Sprite ID:       double_t
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=96; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_t_WIDTH_PX    = 16
double_t_HEIGHT_PX   = 8
double_t_BIT_PER_PX  = 1
double_t_INDEX       = 32
double_t_NUM_FRAMES  = 1
double_t:
         !BYTE $00, $3f, $03, $03, $03, $03, $03, $00, $00, $fc, $c0, $c0, $c0, $c0, $c0, $00

; ==================== Sprite 34 ========================
; Sprite ID:       double_s
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=128; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_s_WIDTH_PX    = 16
double_s_HEIGHT_PX   = 8
double_s_BIT_PER_PX  = 1
double_s_INDEX       = 33
double_s_NUM_FRAMES  = 1
double_s:
         !BYTE $00, $0f, $3c, $0f, $00, $00, $0f, $00, $00, $f0, $00, $f0, $3c, $3c, $f0, $00

; ==================== Sprite 35 ========================
; Sprite ID:       double_o
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=144; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_o_WIDTH_PX    = 16
double_o_HEIGHT_PX   = 8
double_o_BIT_PER_PX  = 1
double_o_INDEX       = 34
double_o_NUM_FRAMES  = 1
double_o:
         !BYTE $00, $0f, $3c, $3c, $3c, $3c, $0f, $00, $00, $f0, $3c, $3c, $3c, $3c, $f0, $00

; ==================== Sprite 36 ========================
; Sprite ID:       double_f
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=160; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_f_WIDTH_PX    = 16
double_f_HEIGHT_PX   = 8
double_f_BIT_PER_PX  = 1
double_f_INDEX       = 35
double_f_NUM_FRAMES  = 1
double_f:
         !BYTE $00, $3f, $3c, $3f, $3c, $3c, $3c, $00, $00, $fc, $00, $f0, $00, $00, $00, $00

; ==================== Sprite 37 ========================
; Sprite ID:       double_p
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=208; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_p_WIDTH_PX    = 16
double_p_HEIGHT_PX   = 8
double_p_BIT_PER_PX  = 1
double_p_INDEX       = 36
double_p_NUM_FRAMES  = 1
double_p:
         !BYTE $00, $3f, $3c, $3c, $3f, $3c, $3c, $00, $00, $f0, $3c, $3c, $f0, $00, $00, $00

; ==================== Sprite 38 ========================
; Sprite ID:       double_r
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=224; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_r_WIDTH_PX    = 16
double_r_HEIGHT_PX   = 8
double_r_BIT_PER_PX  = 1
double_r_INDEX       = 37
double_r_NUM_FRAMES  = 1
double_r:
         !BYTE $00, $3f, $3c, $3c, $3f, $3c, $3c, $00, $00, $f0, $3c, $3c, $f0, $f0, $3c, $00

; ==================== Sprite 39 ========================
; Sprite ID:       double_e
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=240; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_e_WIDTH_PX    = 16
double_e_HEIGHT_PX   = 8
double_e_BIT_PER_PX  = 1
double_e_INDEX       = 38
double_e_NUM_FRAMES  = 1
double_e:
         !BYTE $00, $3f, $3c, $3f, $3c, $3c, $3f, $00, $00, $fc, $00, $f0, $00, $00, $fc, $00

; ==================== Sprite 40 ========================
; Sprite ID:       double_n
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=288; PosY=52
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_n_WIDTH_PX    = 16
double_n_HEIGHT_PX   = 8
double_n_BIT_PER_PX  = 1
double_n_INDEX       = 39
double_n_NUM_FRAMES  = 1
double_n:
         !BYTE $00, $3c, $3f, $3f, $3f, $3c, $3c, $00, $00, $3c, $3c, $fc, $fc, $fc, $3c, $00

; ==================== Sprite 41 ========================
; Sprite ID:       double_b
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=64; PosY=108
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_b_WIDTH_PX    = 16
double_b_HEIGHT_PX   = 8
double_b_BIT_PER_PX  = 1
double_b_INDEX       = 40
double_b_NUM_FRAMES  = 1
double_b:
         !BYTE $00, $3f, $3c, $3f, $3c, $3c, $3f, $00, $00, $f0, $3c, $f0, $3c, $3c, $f0, $00

; ==================== Sprite 42 ========================
; Sprite ID:       letter_dash
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=118; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

letter_dash_WIDTH_PX    = 8
letter_dash_HEIGHT_PX   = 8
letter_dash_BIT_PER_PX  = 1
letter_dash_INDEX       = 41
letter_dash_NUM_FRAMES  = 1
letter_dash:
            !BYTE $00, $00, $00, $7e, $00, $00, $00, $00
;             D9A6 : 00 00             

; ==================== Sprite 43 ========================
; Sprite ID:       INDEX_53
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

INDEX_53_WIDTH_PX    = 8
INDEX_53_HEIGHT_PX   = 8
INDEX_53_BIT_PER_PX  = 2
INDEX_53_INDEX       = 42
INDEX_53_NUM_FRAMES  = 1
INDEX_53:
         !BYTE $55, $55, $55, $55, $55, $55, $55, $55

; ==================== Sprite 44 ========================
; Sprite ID:       double_y
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=80; PosY=108
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_y_WIDTH_PX    = 16
double_y_HEIGHT_PX   = 8
double_y_BIT_PER_PX  = 1
double_y_INDEX       = 43
double_y_NUM_FRAMES  = 1
double_y:
         !BYTE $00, $3c, $3c, $0f, $03, $03, $03, $00, $00, $3c, $3c, $f0, $c0, $c0, $c0, $00

; ==================== Sprite 45 ========================
; Sprite ID:       double_j
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=192; PosY=108
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_j_WIDTH_PX    = 16
double_j_HEIGHT_PX   = 8
double_j_BIT_PER_PX  = 1
double_j_INDEX       = 44
double_j_NUM_FRAMES  = 1
double_j:
         !BYTE $00, $00, $00, $00, $00, $3c, $0f, $00, $00, $3c, $3c, $3c, $3c, $3c, $f0, $00

; ==================== Sprite 46 ========================
; Sprite ID:       double_i
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=288; PosY=108
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

double_i_WIDTH_PX    = 16
double_i_HEIGHT_PX   = 8
double_i_BIT_PER_PX  = 1
double_i_INDEX       = 45
double_i_NUM_FRAMES  = 1
double_i:
         !BYTE $00, $3f, $03, $03, $03, $03, $3f, $00, $00, $fc, $c0, $c0, $c0, $c0, $fc, $00

; ==================== Sprite 47 ========================
; Sprite ID:       big_b
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=128; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_b_WIDTH_PX    = 16
big_b_HEIGHT_PX   = 16
big_b_BIT_PER_PX  = 1
big_b_INDEX       = 46
big_b_NUM_FRAMES  = 1
big_b:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $3c, $f0, $3f, $3c, $3c, $3c, $3f, $3f, $00, $00, $f0, $3c, $3c, $3c, $fc, $f0, $00, $00

; ==================== Sprite 48 ========================
; Sprite ID:       big_r
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=144; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_r_WIDTH_PX    = 16
big_r_HEIGHT_PX   = 16
big_r_BIT_PER_PX  = 1
big_r_INDEX       = 47
big_r_NUM_FRAMES  = 1
big_r:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $3c, $fc, $3f, $3c, $3c, $3c, $3c, $3c, $00, $00, $f0, $f0, $f0, $3c, $3c, $3c, $00, $00

; ==================== Sprite 49 ========================
; Sprite ID:       big_u
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=160; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_u_WIDTH_PX    = 16
big_u_HEIGHT_PX   = 16
big_u_BIT_PER_PX  = 1
big_u_INDEX       = 48
big_u_NUM_FRAMES  = 1
big_u:
      !BYTE $00, $00, $3c, $3c, $3c, $3c, $3c, $3c, $00, $00, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3f, $0f, $00, $00, $3c, $3c, $3c, $3c, $fc, $f0, $00, $00

; ==================== Sprite 50 ========================
; Sprite ID:       big_c
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=176; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_c_WIDTH_PX    = 16
big_c_HEIGHT_PX   = 16
big_c_BIT_PER_PX  = 1
big_c_INDEX       = 49
big_c_NUM_FRAMES  = 1
big_c:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3c, $00, $00, $f0, $fc, $3c, $3c, $00, $00, $3c, $3c, $3c, $3c, $3f, $0f, $00, $00, $00, $00, $3c, $3c, $fc, $f0, $00, $00

; ==================== Sprite 51 ========================
; Sprite ID:       big_e
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=192; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_e_WIDTH_PX    = 16
big_e_HEIGHT_PX   = 16
big_e_BIT_PER_PX  = 1
big_e_INDEX       = 50
big_e_NUM_FRAMES  = 1
big_e:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $3c, $3f, $00, $00, $fc, $fc, $00, $00, $00, $c0, $3f, $3c, $3c, $3c, $3f, $3f, $00, $00, $c0, $00, $00, $00, $fc, $fc, $00, $00

; ==================== Sprite 52 ========================
; Sprite ID:       big_l
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=224; PosY=77
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_l_WIDTH_PX    = 16
big_l_HEIGHT_PX   = 16
big_l_BIT_PER_PX  = 1
big_l_INDEX       = 51
big_l_NUM_FRAMES  = 1
big_l:
      !BYTE $00, $00, $3c, $3c, $3c, $3c, $3c, $3c, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $3c, $3c, $3c, $3f, $3f, $00, $00, $00, $00, $00, $00, $fc, $fc, $00, $00

; ==================== Sprite 53 ========================
; Sprite ID:       tm
; Sprite Comments: Captured from Screenshot (game over.png)
;                  PosX=273; PosY=71
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

tm_WIDTH_PX    = 16
tm_HEIGHT_PX   = 8
tm_BIT_PER_PX  = 1
tm_INDEX       = 52
tm_NUM_FRAMES  = 1
tm:
   !BYTE $7e, $18, $18, $18, $00, $00, $00, $00, $66, $7e, $66, $66, $00, $00, $00, $00

; ==================== Sprite 54 ========================
; Sprite ID:       version_info
; Sprite Comments: 
; Dimensions:      64 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

version_info_WIDTH_PX    = 64
version_info_HEIGHT_PX   = 8
version_info_BIT_PER_PX  = 1
version_info_INDEX       = 53
version_info_NUM_FRAMES  = 1
version_info:
             !BYTE $00, $64, $54, $64, $44, $47, $00, $00, $00, $53, $54, $52, $51, $26, $00, $00, $00, $28, $28, $38, $08, $08, $00, $00, $00, $ae, $a8, $ac, $a8, $4e, $00, $00, $00, $c6, $a8, $c4, $a2, $ac, $00, $00, $00, $92, $aa, $ab, $aa, $92, $00, $00, $00, $46, $45, $46, $c5, $46, $00, $00, $00, $51, $50, $20, $20, $20, $00, $00
;             DAB6 : 00 00 00 53 54 52 
;             DABC : 51 26 00 00 00 28 
;             DAC2 : 28 38 08 08 00 00 
;             DAC8 : 00 AE A8 AC A8 4E 
;             DACE : 00 00 00 C6 A8 C4 
;             DAD4 : A2 AC 00 00 00 92 
;             DADA : AA AB AA 92 00 00 
;             DAE0 : 00 46 45 46 C5 46 
;             DAE6 : 00 00 00 51 50 20 
;             DAEC : 20 20 00 00       

; ==================== Sprite 55 ========================
; Sprite ID:       tcfs
; Sprite Comments: 
; Dimensions:      16 x 8 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

tcfs_WIDTH_PX    = 16
tcfs_HEIGHT_PX   = 8
tcfs_BIT_PER_PX  = 1
tcfs_INDEX       = 54
tcfs_NUM_FRAMES  = 1
tcfs:
     !BYTE $00, $c9, $95, $91, $95, $89, $00, $00, $00, $cc, $10, $88, $04, $18, $00, $00

; ==================== Sprite 56 ========================
; Sprite ID:       big_g
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=88; PosY=2
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_g_WIDTH_PX    = 16
big_g_HEIGHT_PX   = 16
big_g_BIT_PER_PX  = 1
big_g_INDEX       = 55
big_g_NUM_FRAMES  = 1
big_g:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3c, $00, $00, $f0, $fc, $3c, $3c, $00, $00, $3c, $3c, $3c, $3c, $3f, $0f, $00, $00, $fc, $fc, $3c, $3c, $fc, $f0, $00, $00
;             DB06 : 3C 3C 00 00 F0 FC 
;             DB0C : 3C 3C 00 00 3C 3C 
;             DB12 : 3C 3C 3F 0F 00 00 
;             DB18 : FC FC 3C 3C FC F0 
;             DB1E : 00 00             

; ==================== Sprite 57 ========================
; Sprite ID:       big_a
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=104; PosY=2
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_a_WIDTH_PX    = 16
big_a_HEIGHT_PX   = 16
big_a_BIT_PER_PX  = 1
big_a_INDEX       = 56
big_a_NUM_FRAMES  = 1
big_a:
      !BYTE $00, $00, $03, $0f, $3f, $3c, $3c, $3c, $00, $00, $c0, $f0, $fc, $3c, $3c, $3c, $3f, $3f, $3c, $3c, $3c, $3c, $00, $00, $fc, $fc, $3c, $3c, $3c, $3c, $00, $00
;             DB26 : 3C 3C 00 00 C0 F0 
;             DB2C : FC 3C 3C 3C 3F 3F 
;             DB32 : 3C 3C 3C 3C 00 00 
;             DB38 : FC FC 3C 3C 3C 3C 
;             DB3E : 00 00             

; ==================== Sprite 58 ========================
; Sprite ID:       big_m
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=121; PosY=2
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_m_WIDTH_PX    = 16
big_m_HEIGHT_PX   = 16
big_m_BIT_PER_PX  = 1
big_m_INDEX       = 57
big_m_NUM_FRAMES  = 1
big_m:
      !BYTE $00, $00, $78, $78, $7e, $7e, $7f, $7f, $00, $00, $1e, $1e, $7e, $7e, $fe, $fe, $79, $79, $78, $78, $78, $78, $00, $00, $9e, $9e, $1e, $1e, $1e, $1e, $00, $00

; ==================== Sprite 59 ========================
; Sprite ID:       big_o
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=168; PosY=2
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_o_WIDTH_PX    = 16
big_o_HEIGHT_PX   = 16
big_o_BIT_PER_PX  = 1
big_o_INDEX       = 58
big_o_NUM_FRAMES  = 1
big_o:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3c, $00, $00, $f0, $fc, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3f, $0f, $00, $00, $3c, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DB66 : 3C 3C 00 00 F0 FC 
;             DB6C : 3C 3C 3C 3C 3C 3C 
;             DB72 : 3C 3C 3F 0F 00 00 
;             DB78 : 3C 3C 3C 3C FC F0 
;             DB7E : 00 00             

; ==================== Sprite 60 ========================
; Sprite ID:       big_v
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=184; PosY=2
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_v_WIDTH_PX    = 16
big_v_HEIGHT_PX   = 16
big_v_BIT_PER_PX  = 1
big_v_INDEX       = 59
big_v_NUM_FRAMES  = 1
big_v:
      !BYTE $00, $00, $3c, $3c, $3c, $3c, $3c, $3c, $00, $00, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $0f, $0f, $03, $03, $00, $00, $3c, $3c, $f0, $f0, $c0, $c0, $00, $00
;             DB86 : 3C 3C 00 00 3C 3C 
;             DB8C : 3C 3C 3C 3C 3C 3C 
;             DB92 : 0F 0F 03 03 00 00 
;             DB98 : 3C 3C F0 F0 C0 C0 
;             DB9E : 00 00             

; ==================== Sprite 61 ========================
; Sprite ID:       big_p
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=96; PosY=34
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_p_WIDTH_PX    = 16
big_p_HEIGHT_PX   = 16
big_p_BIT_PER_PX  = 1
big_p_INDEX       = 60
big_p_NUM_FRAMES  = 1
big_p:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $3c, $fc, $3f, $3c, $3c, $3c, $3c, $3c, $00, $00, $f0, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 62 ========================
; Sprite ID:       big_y
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=144; PosY=34
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_y_WIDTH_PX    = 16
big_y_HEIGHT_PX   = 16
big_y_BIT_PER_PX  = 1
big_y_INDEX       = 61
big_y_NUM_FRAMES  = 1
big_y:
      !BYTE $00, $00, $3c, $3c, $3c, $3c, $0f, $0f, $00, $00, $3c, $3c, $3c, $3c, $f0, $f0, $03, $03, $03, $03, $03, $03, $00, $00, $c0, $c0, $c0, $c0, $c0, $c0, $00, $00
;             DBC6 : 0F 0F 00 00 3C 3C 
;             DBCC : 3C 3C F0 F0 03 03 
;             DBD2 : 03 03 03 03 00 00 
;             DBD8 : C0 C0 C0 C0 C0 C0 
;             DBDE : 00 00             

; ==================== Sprite 63 ========================
; Sprite ID:       big_0
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=112; PosY=58
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_0_WIDTH_PX    = 16
big_0_HEIGHT_PX   = 16
big_0_BIT_PER_PX  = 1
big_0_INDEX       = 62
big_0_NUM_FRAMES  = 1
big_0:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3c, $00, $00, $f0, $fc, $3c, $3c, $fc, $fc, $3f, $3f, $3c, $3c, $3f, $0f, $00, $00, $3c, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DBE6 : 3C 3C 00 00 F0 FC 
;             DBEC : 3C 3C FC FC 3F 3F 
;             DBF2 : 3C 3C 3F 0F 00 00 
;             DBF8 : 3C 3C 3C 3C FC F0 
;             DBFE : 00 00             

; ==================== Sprite 64 ========================
; Sprite ID:       big_1
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=208; PosY=34
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_1_WIDTH_PX    = 16
big_1_HEIGHT_PX   = 16
big_1_BIT_PER_PX  = 1
big_1_INDEX       = 63
big_1_NUM_FRAMES  = 1
big_1:
      !BYTE $00, $00, $03, $03, $03, $0f, $0f, $03, $00, $00, $c0, $c0, $c0, $c0, $c0, $c0, $03, $03, $03, $03, $3f, $3f, $00, $00, $c0, $c0, $c0, $c0, $fc, $fc, $00, $00

; ==================== Sprite 65 ========================
; Sprite ID:       big_2
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=144; PosY=58
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_2_WIDTH_PX    = 16
big_2_HEIGHT_PX   = 16
big_2_BIT_PER_PX  = 1
big_2_INDEX       = 64
big_2_NUM_FRAMES  = 1
big_2:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $00, $00, $00, $00, $f0, $fc, $3c, $3c, $3c, $fc, $03, $0f, $3f, $3c, $3f, $3f, $00, $00, $f0, $c0, $00, $00, $fc, $fc, $00, $00
;             DC26 : 00 00 00 00 F0 FC 
;             DC2C : 3C 3C 3C FC 03 0F 
;             DC32 : 3F 3C 3F 3F 00 00 
;             DC38 : F0 C0 00 00 FC FC 
;             DC3E : 00 00             

; ==================== Sprite 66 ========================
; Sprite ID:       big_3
; Sprite Comments: Captured from Screenshot (vice-screen-2022031714094682.png)
;                  PosX=192; PosY=101
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_3_WIDTH_PX    = 16
big_3_HEIGHT_PX   = 16
big_3_BIT_PER_PX  = 1
big_3_INDEX       = 65
big_3_NUM_FRAMES  = 1
big_3:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $00, $03, $00, $00, $f0, $fc, $3c, $3c, $3c, $f0, $03, $00, $3c, $3c, $3f, $0f, $00, $00, $f0, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DC46 : 00 03 00 00 F0 FC 
;             DC4C : 3C 3C 3C F0 03 00 
;             DC52 : 3C 3C 3F 0F 00 00 
;             DC58 : F0 3C 3C 3C FC F0 
;             DC5E : 00 00             

; ==================== Sprite 67 ========================
; Sprite ID:       big_4
; Sprite Comments: Captured from Screenshot (vice-screen-2022031714173310.png)
;                  PosX=193; PosY=101
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_4_WIDTH_PX    = 16
big_4_HEIGHT_PX   = 16
big_4_BIT_PER_PX  = 1
big_4_INDEX       = 66
big_4_NUM_FRAMES  = 1
big_4:
      !BYTE $00, $00, $00, $01, $01, $07, $1e, $78, $00, $00, $78, $f8, $f8, $f8, $78, $78, $78, $7f, $7f, $00, $00, $00, $00, $00, $78, $fe, $fe, $78, $78, $78, $00, $00

; ==================== Sprite 68 ========================
; Sprite ID:       big_5
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=192; PosY=58
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_5_WIDTH_PX    = 16
big_5_HEIGHT_PX   = 16
big_5_BIT_PER_PX  = 1
big_5_INDEX       = 67
big_5_NUM_FRAMES  = 1
big_5:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $3f, $3f, $00, $00, $fc, $fc, $00, $00, $f0, $fc, $00, $00, $3c, $3c, $3f, $0f, $00, $00, $3c, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DC86 : 3F 3F 00 00 FC FC 
;             DC8C : 00 00 F0 FC 00 00 
;             DC92 : 3C 3C 3F 0F 00 00 
;             DC98 : 3C 3C 3C 3C FC F0 
;             DC9E : 00 00             

; ==================== Sprite 69 ========================
; Sprite ID:       big_6
; Sprite Comments: Captured from Screenshot (title screen.png)
;                  PosX=160; PosY=58
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_6_WIDTH_PX    = 16
big_6_HEIGHT_PX   = 16
big_6_BIT_PER_PX  = 1
big_6_INDEX       = 68
big_6_NUM_FRAMES  = 1
big_6:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $00, $f0, $3f, $3c, $3c, $3c, $3f, $0f, $00, $00, $fc, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DCA6 : 3C 3F 00 00 F0 FC 
;             DCAC : 3C 3C 00 F0 3F 3C 
;             DCB2 : 3C 3C 3F 0F 00 00 
;             DCB8 : FC 3C 3C 3C FC F0 
;             DCBE : 00 00             

; ==================== Sprite 70 ========================
; Sprite ID:       big_7
; Sprite Comments: Captured from Screenshot (vice-screen-2022031714090904.png)
;                  PosX=208; PosY=101
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_7_WIDTH_PX    = 16
big_7_HEIGHT_PX   = 16
big_7_BIT_PER_PX  = 1
big_7_INDEX       = 69
big_7_NUM_FRAMES  = 1
big_7:
      !BYTE $00, $00, $3f, $3f, $3c, $3c, $00, $00, $00, $00, $fc, $fc, $3c, $3c, $fc, $f0, $03, $03, $03, $03, $03, $03, $00, $00, $f0, $c0, $c0, $c0, $c0, $c0, $00, $00
;             DCC6 : 00 00 00 00 FC FC 
;             DCCC : 3C 3C FC F0 03 03 
;             DCD2 : 03 03 03 03 00 00 
;             DCD8 : F0 C0 C0 C0 C0 C0 
;             DCDE : 00 00             

; ==================== Sprite 71 ========================
; Sprite ID:       big_8
; Sprite Comments: Captured from Screenshot (vice-screen-2022031714180752.png)
;                  PosX=192; PosY=101
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_8_WIDTH_PX    = 16
big_8_HEIGHT_PX   = 16
big_8_BIT_PER_PX  = 1
big_8_INDEX       = 70
big_8_NUM_FRAMES  = 1
big_8:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $3c, $fc, $3f, $3c, $3c, $3c, $3f, $0f, $00, $00, $fc, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DCE6 : 3C 3F 00 00 F0 FC 
;             DCEC : 3C 3C 3C FC 3F 3C 
;             DCF2 : 3C 3C 3F 0F 00 00 
;             DCF8 : FC 3C 3C 3C FC F0 
;             DCFE : 00 00             

; ==================== Sprite 72 ========================
; Sprite ID:       big_9
; Sprite Comments: Captured from Screenshot (vice-screen-2022031714180752.png)
;                  PosX=192; PosY=101
; Dimensions:      16 x 16 pixels
; Color Mode:      Hi-Res (2 colors, 1 bit per pixel)
; Byte Order:      CharacterBased

big_9_WIDTH_PX    = 16
big_9_HEIGHT_PX   = 16
big_9_BIT_PER_PX  = 1
big_9_INDEX       = 71
big_9_NUM_FRAMES  = 1
big_9:
      !BYTE $00, $00, $0f, $3f, $3c, $3c, $3c, $3f, $00, $00, $f0, $fc, $3c, $3c, $3c, $fc, $0f, $00, $00, $3c, $3f, $0f, $00, $00, $fc, $3c, $3c, $3c, $fc, $f0, $00, $00
;             DD06 : 3C 3F 00 00 F0 FC 
;             DD0C : 3C 3C 3C FC 0F 00 
;             DD12 : 00 3C 3F 0F 00 00 
;             DD18 : FC 3C 3C 3C FC F0 
;             DD1E : 00 00             

; ==================== Retro Sprite Workshop Project END ========================


title_scree_blue      =   $ae
death_screen_text_color   =   $61



show_hide_screen
-   ldx   $ff1d ;vsync
    cpx   #$d0
    bcc   -
    sta   $ff06
    rts   
check_dev_mode
    lda   #$fb
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$fb
    bne   +
    lda   #1
    sta   devmode_keystrokes + 7
    jsr   shift_keystroke_buffer
+
    lda   #$fd
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$bf
    bne   +
    lda   #2
    sta   devmode_keystrokes + 7
    jsr   shift_keystroke_buffer
+   
    lda   #$f7
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$7f
    bne   +
    lda   #3
    sta   devmode_keystrokes + 7
    jsr   shift_keystroke_buffer
+   
    lda   #$ef
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ef
    bne   +
    lda   #4
    sta   devmode_keystrokes + 7
    jsr   shift_keystroke_buffer
+   
    lda   #$ef
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$bf
    bne   +
    lda   #5
    sta   devmode_keystrokes + 7
    jsr   shift_keystroke_buffer
+   
    
    rts

devmode_keystrokes
    !FILL   8,0

shift_keystroke_buffer
    ldx   #$00
-   lda   devmode_keystrokes + 1,x
    sta   devmode_keystrokes,x
    inx
    cpx   #$07
    bne   -
    ;wait for key release
-   lda   #$00
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ff
    bne   -
    ;byt    $f2   
    ldx   #$00
-   lda   devmode_pattern,x
    cmp   devmode_keystrokes,x
    bne   +
    inx
    cpx   #$07
    bne   -
    lda   #$01
    sta   DEVELOPER_MODE
    ldx   #$0e
    ldy   #$68
    lda   #13
    jsr   set_inverse   

+
    rts

menu_timer
    !BYTE   0,0
devmode_pattern
    !BYTE   1,2,3,4,5,1,2
;             DDE9 : 02                
game_players
    !BYTE   0
game_opponents
    !BYTE   0
    
players_table
    !BYTE   $c8,$0d,10,00
    !BYTE   $c8 + 9,$0d,11,00

opponents_table
    !BYTE   $18,$0e,10,00
    !BYTE   $18 + 9,$0e,10,00
    !BYTE   $18 + 9,$0e,11,00
    !BYTE   $18,$0e,10,00
  
wait_for_key_release
    lda   #$fe  
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ff
    bne   wait_for_key_release
    lda   #$bf    
    sta   $fd30
    sta   $ff08
    lda   $ff08
    cmp   #$ff
    bne   wait_for_key_release
    rts
    
repaint_menu    
-   ;vsync
    lda   $ff1d
    cmp   #$a0
    bcc   -

    lda   #$00
    sta   menu_timer
    sta   menu_timer + 1

    ldx   #$0d
    ldy   #$c8
    lda   #25
    jsr   clear_inverse
    
    ldx   #$0e
    ldy   #$18
    lda   #26
    jsr   clear_inverse

    ldx   #$00
    lda   game_opponents
    cmp   #$02
    bne   +
    ldx   #(letter_s - upper_bound_charset) / 8
+
    stx   $0e2b
    
    lda   game_players
    and   #$01
    asl
    asl
    tax
    lda   players_table,x
    sta   $d0       
    lda   players_table + 1,x
    sta   $d1       
    lda   players_table + 2,x
    sta   $d2       
    ldx   $d1
    ldy   $d0
    lda   $d2
    jsr   set_inverse

    lda   game_opponents  
    and   #$03
    asl
    asl
    tax
    lda   opponents_table,x
    sta   $d0       
    lda   opponents_table + 1,x
    sta   $d1       
    lda   opponents_table + 2,x
    sta   $d2       
    ldx   $d1
    ldy   $d0
    lda   $d2
    jsr   set_inverse   
    
  
+   
    rts
;--------------------------------------------------------------------------
;     Parameters  x/y screen mem address lo/hi,  AC number of chars
;--------------------------------------------------------------------------
clear_inverse
    stx   $d1
    sty   $d0
    sta   $d2
    ldy   #$00
-   lda   ($d0),y
    and   #$7f
    sta   ($d0),y
    iny
    cpy   $d2
    bne   -
    rts
set_inverse
    stx   $d1
    sty   $d0
    sta   $d2
    ldy   #$00
-   lda   ($d0),y
    ora   #$80
    sta   ($d0),y
    iny
    cpy   $d2
    bne   -
    rts

menu_irq
    sta   $50
    stx   $51
    sty   $52
    asl   $ff09
    
    ;lda    menu_timer
    ;and    #$01
    ;bne    +
    jsr   (PLAYER - music_data_start) + music_target_memory
;+
    lda   #$e0
    sta   $ff0b
    ;inc    $ff19
    lda   menu_timer
    clc
    adc   #$01
    bcc   +
    inc   menu_timer + 1
+
    sta   menu_timer
    

    lda   $50
    ldx   $51
    ldy   $52
    rti

score_placement_on_screen_memory    = screen_mem_buffer1 + 8  
score_placement_on_screen_memory2   = screen_mem_buffer2 + 8  

retain_player_score
    jsr   update_high_score
    lda   info_bar_1_up   ;1up or 2up is showing on screen?
    cmp   #digit_2_INDEX
    beq   +
    ldx   #$00
-
    lda   score_placement_on_screen_memory,x
    sta   score_player1,x
    inx
    cpx   #6
    bne   -
    rts
+
    ldx   #$00
-   lda   score_placement_on_screen_memory,x
    sta   score_player2,x
    inx
    cpx   #6
    bne   -
    rts

update_high_score
    ldx   #$00
-   lda   score_placement_on_screen_memory,x
    cmp   high_score,x
    bcs   new_high_score
    bcc   score_is_smaller
    inx
    cpx   #6
    bne   -
score_is_smaller
    rts
new_high_score
    ldx   #$00
-   lda   score_placement_on_screen_memory,x
    sta   high_score,x
    inx
    cpx   #$06
    bne   -
    rts
  
new_room_visited
    tax
    lda   room_visit_check_for_scoring,x
    bne   +
    ;this room is visited first time
    lda   #$01
    sta   room_visit_check_for_scoring,x    
    lda   #$06
    jsr   add_score
    
+
    rts
    
title_text_1
    !BYTE   (double_d - upper_bound_charset) / 8, (double_d - upper_bound_charset) / 8 + 1
    !BYTE   (double_a - upper_bound_charset) / 8, (double_a - upper_bound_charset) / 8 + 1
    !BYTE   (double_t - upper_bound_charset) / 8, (double_t - upper_bound_charset) / 8 + 1
    !BYTE   (double_a - upper_bound_charset) / 8, (double_a - upper_bound_charset) / 8 + 1
    !BYTE   (double_s - upper_bound_charset) / 8, (double_s - upper_bound_charset) / 8 + 1
    !BYTE   (double_o - upper_bound_charset) / 8, (double_o - upper_bound_charset) / 8 + 1
    !BYTE   (double_f - upper_bound_charset) / 8, (double_f - upper_bound_charset) / 8 + 1
    !BYTE   (double_t - upper_bound_charset) / 8, (double_t - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   (double_p - upper_bound_charset) / 8, (double_p - upper_bound_charset) / 8 + 1
    !BYTE   (double_r - upper_bound_charset) / 8, (double_r - upper_bound_charset) / 8 + 1
    !BYTE   (double_e - upper_bound_charset) / 8, (double_e - upper_bound_charset) / 8 + 1
    !BYTE   (double_s - upper_bound_charset) / 8, (double_s - upper_bound_charset) / 8 + 1
    !BYTE   (double_e - upper_bound_charset) / 8, (double_e - upper_bound_charset) / 8 + 1
    !BYTE   (double_n - upper_bound_charset) / 8, (double_n - upper_bound_charset) / 8 + 1
    !BYTE   (double_t - upper_bound_charset) / 8, (double_t - upper_bound_charset) / 8 + 1
    !BYTE   (double_s - upper_bound_charset) / 8, (double_s - upper_bound_charset) / 8 + 1

title_text_2
    !BYTE   (double_b - upper_bound_charset) / 8, (double_b - upper_bound_charset) / 8 + 1
    !BYTE   (double_y - upper_bound_charset) / 8, (double_y - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   0,0
    !BYTE   (double_r - upper_bound_charset) / 8, (double_r - upper_bound_charset) / 8 + 1
    !BYTE   (double_o - upper_bound_charset) / 8, (double_o - upper_bound_charset) / 8 + 1
    !BYTE   (double_n - upper_bound_charset) / 8, (double_n - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   (double_j - upper_bound_charset) / 8, (double_j - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   (double_f - upper_bound_charset) / 8, (double_f - upper_bound_charset) / 8 + 1
    !BYTE   (double_o - upper_bound_charset) / 8, (double_o - upper_bound_charset) / 8 + 1
    !BYTE   (double_r - upper_bound_charset) / 8, (double_r - upper_bound_charset) / 8 + 1
    !BYTE   (double_t - upper_bound_charset) / 8, (double_t - upper_bound_charset) / 8 + 1
    !BYTE   (double_i - upper_bound_charset) / 8, (double_i - upper_bound_charset) / 8 + 1
    !BYTE   (double_e - upper_bound_charset) / 8, (double_e - upper_bound_charset) / 8 + 1
    !BYTE   (double_r - upper_bound_charset) / 8, (double_r - upper_bound_charset) / 8 + 1

title_text_3_line1
;   !BYTE   (big_b - upper_bound_charset) / 8, (big_b - upper_bound_charset) / 8 + 1
;   !BYTE   (big_r - upper_bound_charset) / 8, (big_r - upper_bound_charset) / 8 + 1
;   !BYTE   (big_u - upper_bound_charset) / 8, (big_u - upper_bound_charset) / 8 + 1
;   !BYTE   (big_c - upper_bound_charset) / 8, (big_c - upper_bound_charset) / 8 + 1
;   !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   0,0
    !BYTE   0,0
    !BYTE   (big_l - upper_bound_charset) / 8, (big_l - upper_bound_charset) / 8 + 1
    !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   (big_e - upper_bound_charset) / 8, (big_e - upper_bound_charset) / 8 + 1
    !BYTE   (tm - upper_bound_charset) / 8, (tm - upper_bound_charset) / 8 + 1
    !BYTE   0,0
    !BYTE   0,0
    !BYTE   0,0
    
menu_line1
    !BYTE   (letter_f - upper_bound_charset) / 8 + 128
    !BYTE   (digit_1 - upper_bound_charset) / 8 + 128
    !BYTE   0
    !BYTE   (letter_dash - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (digit_1 - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_p - upper_bound_charset) / 8
    !BYTE   (letter_l - upper_bound_charset) / 8
    !BYTE   (letter_a - upper_bound_charset) / 8
    !BYTE   (letter_y - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   (letter_r - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_dash - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (digit_2 - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_p - upper_bound_charset) / 8
    !BYTE   (letter_l - upper_bound_charset) / 8
    !BYTE   (letter_a - upper_bound_charset) / 8
    !BYTE   (letter_y - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   (letter_r - upper_bound_charset) / 8
    !BYTE   (letter_s - upper_bound_charset) / 8
    
menu_line2
    !BYTE   (letter_f - upper_bound_charset) / 8 + 128
    !BYTE   (digit_2 - upper_bound_charset) / 8 + 128
    !BYTE   0
    !BYTE   (letter_dash - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_c - upper_bound_charset) / 8
    !BYTE   (letter_o - upper_bound_charset) / 8
    !BYTE   (letter_m - upper_bound_charset) / 8
    !BYTE   (letter_p - upper_bound_charset) / 8
    !BYTE   (letter_u - upper_bound_charset) / 8
    !BYTE   (letter_t - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   (letter_r - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_dash - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_o - upper_bound_charset) / 8
    !BYTE   (letter_p - upper_bound_charset) / 8
    !BYTE   (letter_p - upper_bound_charset) / 8
    !BYTE   (letter_o - upper_bound_charset) / 8
    !BYTE   (letter_n - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   (letter_n - upper_bound_charset) / 8
    !BYTE   (letter_t - upper_bound_charset) / 8
    !BYTE   0

menu_line3
    !BYTE   (letter_f - upper_bound_charset) / 8 + 128
    !BYTE   (digit_3 - upper_bound_charset) / 8 + 128
    !BYTE   0
    !BYTE   (letter_dash - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_t - upper_bound_charset) / 8
    !BYTE   (letter_o - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_b - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   (letter_g - upper_bound_charset) / 8
    !BYTE   (letter_i - upper_bound_charset) / 8
    !BYTE   (letter_n - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   (letter_g - upper_bound_charset) / 8
    !BYTE   (letter_a - upper_bound_charset) / 8
    !BYTE   (letter_m - upper_bound_charset) / 8
    !BYTE   (letter_e - upper_bound_charset) / 8
    !BYTE   0
    !BYTE   0
    !BYTE   0
    !BYTE   0
    !BYTE   0
    !BYTE   0
    !BYTE   0

*     = screen_mem_buffer2    - $400 ;$e000

music_data_start:

;----------------------------------
    
;put sounds here
;----------------------------------
square_ptr  = $36
noise_ptr = $38

SND_OFF   = $00

SND_SWORDHIT  = $01
SND_YAMOSHOUT = $02
SND_LANTERN = $03
SND_ENEMYDEATH  = $04
SND_PLAYERDEATH = $05
SND_GATEOPEN  = $06
SND_ENEMYSPAWN  = $07

SND_HIGHKICK1 = $81
SND_HIGHKICK2 = $82
SND_RUN   = $83
SND_CLIMB = $84
SND_HIT   = $85
SND_EXPLOSION = $86

sound_set
  tax
  beq sound_off
  bmi sound_set_noise
  ;
sound_set_square
  lda (square_ptr_lo - music_data_start) + music_target_memory,x
  sta square_ptr
  lda (square_ptr_hi - music_data_start) + music_target_memory,x
  sta square_ptr+1
  rts

sound_set_noise
  and #$7F
  tax
  lda (noise_ptr_lo - music_data_start) + music_target_memory,x
  sta noise_ptr
  lda (noise_ptr_hi - music_data_start) + music_target_memory,x
  sta noise_ptr+1
  rts
  
sound_off
  jsr (sound_set_noise - music_data_start) + music_target_memory
  jsr (sound_set_square - music_data_start) + music_target_memory
  ;
  jsr (sound_off_square - music_data_start) + music_target_memory
  ;
sound_off_noise
  lda #$FE  ; FF0F/FF10: noise
  sta $FF0F
  lda #$03  
  sta $FF10
  rts
  
sound_off_square
  lda #$FE  ; FF0E/FF12: square
  sta $FF0E
  lda $FF12
  and #$FC
  ora #$03
  sta $FF12
  rts
  
sound_call
  ldy #$00
  lda (square_ptr),y
  bpl sc1
  ;
  jsr (sound_off_square - music_data_start) + music_target_memory
  jmp (sc_noise - music_data_start) + music_target_memory
  ;
sc1 ora #$50
  sta $FF11
  iny
  lda (square_ptr),y
  sta $FF0E
  iny
  lda $FF12
  and #$FC
  ora (square_ptr),y
  sta $FF12
  ;
  iny
  tya
  clc
  adc square_ptr
  sta square_ptr
  bcc *+4
  inc square_ptr+1
  ;
sc_noise
  ldy #$00
  lda (noise_ptr),y
  bpl sc2
  ;
  jmp (sound_off_noise - music_data_start) + music_target_memory
  ;
sc2 ora #$50
  sta $FF11
  iny
  lda (noise_ptr),y
  sta $FF0F
  iny
  lda (noise_ptr),y
  sta $FF10
  ;
  iny
  tya
  clc
  adc noise_ptr
  sta noise_ptr
  bcc *+4
  inc noise_ptr+1
  ;
  rts
  
sound_sword_hit
  !BYTE $5, $80,$02
  !BYTE $5, $10,$02
  !BYTE $4, $80,$01
  !BYTE $4, $10,$01
sound_stop
  !BYTE $FF
  
sound_yamo_shout  ; original is 15 frames, saw wave, whole tone up (B -> Ci)
  !BYTE $5, $7E,$00
  !BYTE $5, $7E,$00
  !BYTE $5, $7E,$00
  !BYTE $4, $7E,$00
  !BYTE $4, $7F,$00
  ;
  !BYTE $4, $82,$00
  !BYTE $3, $86,$00
  !BYTE $3, $AA,$00
  !BYTE $3, $D8,$00
  !BYTE $2, $DC,$00
  ;
  !BYTE $2, $DF,$00
  !BYTE $2, $E0,$00
  !BYTE $1, $E0,$00
  !BYTE $1, $E0,$00
  !BYTE $1, $E0,$00
  ;
  !BYTE $FF
  
sound_lantern
  !BYTE $5, $96,$03 ; C6
  !BYTE $4, $E5,$02 ; G4
  !BYTE $4, $2C,$03 ; C5
  !BYTE $3, $9C,$02 ; Di4
  !BYTE $3, $E5,$02 ; G4
  ;
  !BYTE $5, $96,$03 ; C6
  !BYTE $4, $E5,$02 ; G4
  !BYTE $4, $2C,$03 ; C5
  !BYTE $3, $9C,$02 ; Di4
  !BYTE $3, $E5,$02 ; G4
  ;
  !BYTE $5, $89,$03 ; Ai5
  !BYTE $4, $C3,$02 ; F4
  !BYTE $4, $12,$03 ; Ai4
  !BYTE $3, $70,$02 ; Ci4
  !BYTE $3, $C3,$02 ; F4
  ;
  !BYTE $5, $89,$03 ; Ai5
  !BYTE $4, $C3,$02 ; F4
  !BYTE $4, $12,$03 ; Ai4
  !BYTE $3, $70,$02 ; Ci4
  !BYTE $3, $C3,$02 ; F4
  ;
  !BYTE $5, $96,$03 ; C6
  !BYTE $4, $E5,$02 ; G4
  !BYTE $4, $2C,$03 ; C5
  !BYTE $3, $9C,$02 ; Di4
  !BYTE $3, $E5,$02 ; G4
  ;
  !BYTE $2, $96,$03 ; C6
  ;
  !BYTE $FF
  
sound_enemy_death ; D3, saw, 8 frames hold, 6 frames slide down

  
sound_player_death  ; ???
  !BYTE $5, $86,$02
  !BYTE $5, $88,$02
  !BYTE $5, $84,$02
  !BYTE $5, $89,$02
  !BYTE $5, $83,$02
  !BYTE $5, $8A,$02
  !BYTE $5, $82,$02
  !BYTE $5, $86,$02
  ;
  !BYTE $4, $70,$02
  !BYTE $4, $60,$02
  !BYTE $3, $50,$02
  !BYTE $3, $40,$02
  !BYTE $2, $30,$02
  !BYTE $2, $10,$02
  ;
  !BYTE $FF
  
sound_gate_open
  !BYTE $3, $10,$00
  !BYTE $3, $FE,$03
  !BYTE $4, $20,$00
  !BYTE $4, $FE,$03
  !BYTE $4, $30,$00
  !BYTE $4, $FE,$03
  !BYTE $5, $40,$00
  !BYTE $5, $FE,$03
  !BYTE $5, $50,$00
  !BYTE $5, $FE,$03
  !BYTE $4, $60,$00
  !BYTE $4, $FE,$03
  !BYTE $4, $70,$00
  !BYTE $4, $FE,$03
  !BYTE $3, $80,$00
  !BYTE $3, $FE,$03
  ;
  !BYTE $FF

sound_enemy_spawn 
  !BYTE $3, $38,$03 ; ci5
  !BYTE $3, $89,$03 ; ai5
  !BYTE $3, $43,$03 ; d5
  !BYTE $3, $A2,$03 ; d6
  !BYTE $3, $7B,$03 ; gi5
  !BYTE $3, $B1,$03 ; f6
  !BYTE $3, $89,$03 ; ai5
  !BYTE $3, $9C,$03 ; ci6
  !BYTE $3, $38,$03 ; ci5
  !BYTE $3, $B1,$03 ; f6
  !BYTE $3, $89,$03 ; ai5
  !BYTE $3, $7B,$03 ; gi5
  !BYTE $FF
  
sound_high_kick_1
  !BYTE $4, $70,$03
  !BYTE $4, $80,$03
  !BYTE $4, $88,$03
  !BYTE $4, $90,$03
  !BYTE $4, $98,$03
  ;
  !BYTE $4, $A0,$03
  !BYTE $4, $A4,$03
  !BYTE $4, $A8,$03
  !BYTE $4, $AC,$03
  !BYTE $4, $B0,$03
  ;
  !BYTE $3, $B5,$03
  !BYTE $3, $B8,$03
  !BYTE $3, $BB,$03
  !BYTE $3, $BD,$03
  !BYTE $3, $BF,$03
  ;
  !BYTE $2, $C1,$03
  !BYTE $2, $C2,$03
  !BYTE $2, $C3,$03
  !BYTE $2, $C4,$03
  !BYTE $2, $C5,$03
  ;
  !BYTE $FF
  
sound_high_kick_2
  !BYTE $4, $60,$03
  !BYTE $4, $68,$03
  !BYTE $4, $78,$03
  !BYTE $4, $78,$03
  !BYTE $4, $80,$03
  ;
  !BYTE $4, $88,$03
  !BYTE $4, $90,$03
  !BYTE $4, $98,$03
  !BYTE $4, $A0,$03
  !BYTE $4, $A8,$03
  ;
  !BYTE $3, $B0,$03
  !BYTE $3, $B8,$03
  !BYTE $3, $C0,$03
  !BYTE $3, $C4,$03
  !BYTE $3, $C8,$03
  ;
  !BYTE $2, $CC,$03
  !BYTE $2, $D0,$03
  !BYTE $2, $D1,$03
  !BYTE $2, $D2,$03
  !BYTE $2, $D3,$03
  ;
  !BYTE $FF
  
sound_run
  !BYTE $2, $F1,$03 ; every 3 frames
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  ;
  !BYTE $2, $EC,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  ;
  !BYTE $FF
  
sound_climb
  !BYTE $2, $F1,$03 ; every 12 frames
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  ;
  !BYTE $2, $EC,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  !BYTE $2, $FE,$03
  ;

  !BYTE $FF
  
sound_hit
  !BYTE $6, $D7,$03 ; 7 frames
  !BYTE $6, $11,$03
  !BYTE $5, $92,$02
  !BYTE $5, $13,$02
  !BYTE $4, $94,$01
  !BYTE $3, $15,$01
  !BYTE $2, $96,$00
  !BYTE $FF
  
sound_explosion
  !BYTE $4, $50,$02 ; original is about 35 frames
  !BYTE $4, $40,$02
  !BYTE $4, $40,$01
  !BYTE $4, $48,$02
  !BYTE $4, $38,$02
  !BYTE $4, $30,$01
  !BYTE $4, $40,$02
  !BYTE $4, $30,$02
  ;
  !BYTE $3, $38,$02
  !BYTE $3, $28,$02
  !BYTE $3, $20,$01
  !BYTE $3, $30,$02
  !BYTE $3, $20,$02
  !BYTE $3, $10,$01
  !BYTE $3, $28,$02
  !BYTE $3, $18,$02
  ;
  !BYTE $2, $20,$02
  !BYTE $2, $10,$02
  !BYTE $2, $00,$01
  !BYTE $2, $18,$02
  !BYTE $2, $08,$02
  !BYTE $2, $F0,$00
  !BYTE $2, $10,$02
  !BYTE $2, $00,$02
  ;
  !BYTE $1, $08,$02
  !BYTE $1, $F8,$01
  !BYTE $1, $E0,$00
  !BYTE $1, $00,$02
  !BYTE $1, $F0,$01
  !BYTE $1, $D0,$00
  !BYTE $1, $F0,$01
  !BYTE $1, $E0,$01
  ;
  !BYTE $FF
  
square_ptr_lo
  !BYTE ((sound_stop - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_sword_hit - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_yamo_shout - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_lantern - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_enemy_death - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_player_death - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_gate_open - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_enemy_spawn - music_data_start) + music_target_memory) & 255

square_ptr_hi
  !BYTE ((sound_stop - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_sword_hit - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_yamo_shout - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_lantern - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_enemy_death - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_player_death - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_gate_open - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_enemy_spawn - music_data_start) + music_target_memory) >> 8
  
noise_ptr_lo
  !BYTE ((sound_stop - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_high_kick_1 - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_high_kick_2 - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_run - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_climb - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_hit - music_data_start) + music_target_memory) & 255
  !BYTE ((sound_explosion - music_data_start) + music_target_memory) & 255

noise_ptr_hi
  !BYTE ((sound_stop - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_high_kick_1 - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_high_kick_2 - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_run - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_climb - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_hit - music_data_start) + music_target_memory) >> 8
  !BYTE ((sound_explosion - music_data_start) + music_target_memory) >> 8
;eof;
; LOD Player Version 2
;
F1LO  = $FF0E
F1HI  = $FF12
F2LO  = $FF0F
F2HI  = $FF10

OFF = ((freqs_hi - music_data_start + music_target_memory) -(freqs_lo - music_data_start + music_target_memory))-1
  
; COMMAND BYTES

END_MARK  = $FE
;SET_VOLTAB = $FF
;SET_ARP    = $FD
;CLICK    = $FC
;VOL_DN   = $FB
SETINS    = $F0
SETLEN    = $40

; Constants
base_note = -14 ; shift to C
C0  = 0
;Ci0  = base_note + 1
;D0 = base_note + 2
Di0 = 1
;E0 = base_note + 4
F0  = 2
;Fi0  = base_note + 6
G0  = 3
Gi0 = 4
;A0 = base_note + 9
Ai0 = 5
;B0 = base_note + 11

C1  = 6
;Ci1  = base_note + 13
D1  = 7
Di1 = 8
;E1 = base_note + 16
F1  = 9
;Fi1  = base_note + 18
G1  = 10
;Gi1  = base_note + 20
;A1 = base_note + 21
;Ai1  = base_note + 22
;B1 = base_note + 23

C2  = 11
;Ci2  = base_note + 25
D2  = base_note + 26
Di2 = base_note + 27
E2  = base_note + 28
F2  = base_note + 29
Fi2 = base_note + 30
G2  = base_note + 31
Gi2 = base_note + 32
A2  = base_note + 33
Ai2 = base_note + 34
B2  = base_note + 35

C3  = base_note + 36
Ci3 = base_note + 37
D3  = base_note + 38
Di3 = base_note + 39
E3  = base_note + 40
F3  = base_note + 41
Fi3 = base_note + 42
G3  = base_note + 43
Gi3 = base_note + 44
A3  = base_note + 45
Ai3 = base_note + 46
B3  = base_note + 47

C4  = base_note + 48
Ci4 = base_note + 49
D4  = base_note + 50
Di4 = base_note + 51
E4  = base_note + 52
F4  = base_note + 53
Fi4 = base_note + 54
G4  = base_note + 55
Gi4 = base_note + 56
A4  = base_note + 57
Ai4 = base_note + 58
B4  = base_note + 59

C5  = base_note + 60
Ci5 = base_note + 61
D5  = base_note + 62

;-----
          
  ;ALIGN 256
PLAYER_INIT
  ldx #$FF
  stx VOLTAB_CNT
  inx       
  stx NOTE1
  stx NOTE2
  jsr res - music_data_start + music_target_memory
  inx
  stx NOTELEN1
  stx NOTELEN2
  ;
res 
  lda #$00
  sta PCH,x
  ;
advance
  ldy PCH,x
  inc PCH,x
  txa
  bne adv2
  ;
  lda ( Channel1_lo - music_data_start) + music_target_memory,y ; LO byte
  beq res
  sta CH1_LO,x
  lda #( (( pat_bass_c - music_data_start) + music_target_memory) >> 8) ; HI byte is hardcoded
  sta CH1_HI,x
  rts
  ;
adv2
  lda ( Channel2_hi - music_data_start) + music_target_memory,y ; HI byte
  beq res
  sta CH1_HI,x
  lda ( Channel2_lo - music_data_start) + music_target_memory,y ; LO byte
  sta CH1_LO,x
  rts
  
  ;
  ;##################
  ;

PLAYER
  ;rts
  ;lda $FF19
  ;sta *+17
  ;lda #$67
  ;sta $FF19
  ;eor #$32^$67
  ;sta *-6
  ;jsr PLAYER_
  ;lda #$00
  ;sta $FF19
  ;rts
;PLAYER_
  ldx #$01
channel_loop
  inc NOTE1,x
  ;
  lda NOTE1,x
  cmp NOTELEN1,x
  bne channel_loop_end
  ;
next_note 
  lda CH1_LO,x
  sta CH_TEMP
  lda CH1_HI,x
  sta CH_TEMP+1
  ;
  ldy #$00
  tya
  sta NOTE1,x   ; reset note counter
  ;   
  lda (CH_TEMP),y   ; get byte
  iny
  ;
  cmp #END_MARK   ; $FF goes to new pattern
  bne pl_10
  ;
  jsr advance - music_data_start + music_target_memory
  bne next_note   ; should never be zero
  ;
pl_10 
; cmp #SET_VOLTAB
; bne pl_12
; ;
; sta VOLTAB_CNT
; ;
; lda (CH_TEMP),y   ; get lo byte
; iny
; sta VOL_TAB+1
; ;
; lda (CH_TEMP),y   ; get hi byte
; iny
; sta VOL_TAB+2
; ;
; lda (CH_TEMP),y   ; get byte
; iny
; ;
;pl_12  
; cmp #SET_ARP    ; instrument change?
; bne pl_13
; ;
; lda (CH_TEMP),y   ; get arpeggio byte
; and #$0F
; sta arpeggio_data+0
; ;
; lda (CH_TEMP),y   ; get same byte again
; lsr a
; lsr a
; lsr a
; lsr a
; sta arpeggio_data+1
; ;
; iny
; ;
; lda (CH_TEMP),y   ; get byte
; iny
; ;
pl_13 
; cmp #CLICK    ; TESTING ONLY
; bne pl_14
; ;
; lda #$51
; sta $0C25,x
; ;
; lda (CH_TEMP),y   ; get byte
; iny
; ;
;pl_14
; cmp #VOL_DN
; bne pl_15
; ;
; lda VOLUME
; cmp #20*9
; beq vol_at_min
; ;
; clc
; adc #$09
; sta VOLUME
; ;
;vol_at_min
; lda (CH_TEMP),y   ; get byte
; iny
; ;
;pl_15  
; cmp #$FA
; bne pl_11
; ;
; dec $FF19
; ;
; lda (CH_TEMP),y   ; get byte
; iny
; ;
;pl_11  
  cmp #SETINS   ; instrument change?
  bcc pl_01
  ;
  and #$0F    ; keep lower 4 bits
  sta INS_TYPE1,x     ; store instrument type
  ;
  lda (CH_TEMP),y   ; get byte
  iny
  ;
pl_01 cmp #SETLEN   ; set note length?
  bcc pl_02
  ;
  ;SEC      ; we know carry is always set
  sbc #$40
  sta NOTELEN1,x
  ;
  lda (CH_TEMP),y
  iny
  ;
pl_02 ; - store note!
  ;
  sta TONE1,x
  ;
  ; --- advance pointer
  ;
  tya
  clc
  adc CH1_LO,x
  sta CH1_LO,x
  bcc noi_1
  inc CH1_HI,x
noi_1 ;
  ;
  ; -----------------------------------------------------------------
  ;
channel_loop_end
  dex
  bmi pl_50
  jmp  channel_loop - music_data_start + music_target_memory
  ;    
pl_50 
  ;
  ; --- SOUND PROCESSING
  ;
PLAYER_SOUND
  lda #$30
  sta NOISE
  ;
; ldx #$02    ; channel 3
; jsr sound
; ;
; cmp #$FE
; bne do_ch2
  ;
  ldx #$01    ; channel 2
  jsr sound - music_data_start + music_target_memory
  ;
do_ch2  sta F1LO
  sty F1HI_x - music_data_start + music_target_memory + 1
  ;
  lda F1HI
  and #$FC
F1HI_x  ora #$00
  sta F1HI
  ;
  ; ---
  ;
; lda FX
; beq nofx
; ;
; and #$0F
; tax
; lda fx_vol,x
; sta $FF11
; ;
; lda fx_freq,x
; ldy #$03
; ;
; cpx #$03
; beq fxover
; ;
; inc FX
; bne fxdone
; ;
;fxover ldy #$00
; sty FX
;fxdone sta F2LO
; sty F2HI
; rts
; ;
;nofx 
  ldx #$00    ; channel 1
  jsr sound - music_data_start + music_target_memory
  sta F2LO
  sty F2HI
  ;
  ; ---
  ;    
  ;INC TICK1
  ;INC TICK2
  ;
  ; ---
  ;
  ldy VOLTAB_CNT
  iny
res_v 
VOL_TAB
  lda vol_default - music_data_start + music_target_memory,y
  bpl noi_v   ; check for $FF
  ldy #$00    ; reached, so warp
  beq res_v
noi_v sty VOLTAB_CNT
; clc
; adc VOLUME
; tay
; lda volume_map,y
  ora NOISE
  ;
  ldy F1LO
  cpy #$FE
  bne setvol    ; not silent
  ldy F2LO
  cpy #$FE
  beq sil     ; silent: skip setting $FF11 to avoid clicks
  ;
setvol  sta $FF11   ; self-mod
  ;
sil rts     
  ;
sound lda TONE1,x
  cmp #OFF
  beq lookup
  ;
  lda INS_TYPE1,x   ; hardcoded instrument table
  beq vib     ; $00 = vibrato
  cmp #$02
  beq arpCC   ; $02 = arpeggio ($C)
;noise
  tay     ; $03 = noise (also high byte of notes) 
  lda #$01
  sta NOTELEN1,x    ; force note length to be 1 frame
  lda #$50    ; 
  sta NOISE
  lda TONE1,x
  ora #$C0
  rts
  ;
  ; ---
  ;
arpCC ldy #$00
  lda NOTE1,x
  and #$01
  beq arpCC1
  ldy #$0C
arpCC1  tya
  clc
  adc TONE1,x
  ;
lookup  tax
  lda ( freqs_lo - music_data_start) + music_target_memory,x
  ldy ( freqs_hi - music_data_start) + music_target_memory,x
  rts
  ;
vib lda NOTE1,x
  and #$07
  tay
  lda ( vibrato_data - music_data_start) + music_target_memory,y
  sta VIB_ADD
  ;
  lda TONE1,x
  tax
  ldy ( freqs_hi - music_data_start) + music_target_memory,x
  lda ( freqs_lo - music_data_start) + music_target_memory,x
  clc
  adc VIB_ADD
  rts
  ;
  ; ---
  ;
vibrato_data
  !BYTE $00,$01,$02,$01
  !BYTE $00,$FF,$FE,$FF
;[eof]

freqs_lo
  !BYTE $07,$A9,$06,$59
  !BYTE $7F,$C5
  
  !BYTE $04,$3B,$54
  !BYTE $83,$AD
  
  !BYTE $02,$1E,$2A,$36,$42,$4C,$56
  !BYTE $60,$69,$71,$79
  
  !BYTE $81,$88,$8F,$95
  !BYTE $9B,$A1,$A6,$AB,$B0,$B4,$B9,$BD
  
  !BYTE $C0,$C4,$C7
  !BYTE $FE
  ;,$CB,$CE,$D0,$D3,$FE
  ;$D6
  ;!BYTE $D8,$DA,$DC,$DE,$E0,$E2,$E4,$FE
  
freqs_hi
  !BYTE $00,$00,$01,$01
  !BYTE $01,$01
  
  !BYTE $02,$02,$02
  !BYTE $02,$02
  
  !BYTE $03,$03,$03,$03,$03,$03,$03
  !BYTE $03,$03,$03,$03
  
  !BYTE $03,$03,$03,$03
  !BYTE $03,$03,$03,$03,$03,$03,$03,$03
  
  !BYTE $03,$03,$03
  !BYTE $03
  ;!BYTE ,$03,$03,$03,$03,$03
  ;!BYTE $03,$03,$03,$03,$03,$03,$03,$03

;volume_map
; !BYTE $10,$11,$12,$13,$14,$15,$16,$17,$18
; !BYTE $10,$11,$12,$13,$14,$15,$16,$17,$18
; !BYTE $10,$11,$12,$13,$14,$15,$15,$16,$17
; !BYTE $10,$11,$12,$13,$13,$14,$15,$16,$17
; ;
; !BYTE $10,$11,$12,$12,$13,$14,$15,$16,$16
; !BYTE $10,$11,$12,$12,$13,$14,$15,$15,$16
; !BYTE $10,$11,$11,$12,$13,$14,$14,$15,$16
; !BYTE $10,$11,$11,$12,$13,$13,$14,$15,$15
; ;
; !BYTE $10,$11,$11,$12,$12,$13,$14,$14,$15
; !BYTE $10,$11,$11,$12,$12,$13,$13,$14,$14
; !BYTE $10,$11,$11,$12,$12,$13,$13,$14,$14
; !BYTE $10,$10,$11,$11,$12,$12,$13,$13,$14
; ;
; !BYTE $10,$10,$11,$11,$12,$12,$12,$13,$13
; !BYTE $10,$10,$11,$11,$11,$12,$12,$12,$13
; !BYTE $10,$10,$11,$11,$11,$12,$12,$12,$12
; !BYTE $10,$10,$11,$11,$11,$11,$12,$12,$12
; ;
; !BYTE $10,$10,$10,$11,$11,$11,$11,$11,$12
; !BYTE $10,$10,$10,$10,$11,$11,$11,$11,$11
; !BYTE $10,$10,$10,$10,$10,$11,$11,$11,$11
; !BYTE $10,$10,$10,$10,$10,$10,$10,$10,$11
; ;
; !BYTE $10,$10,$10,$10,$10,$10,$10,$10,$10 ; 21
; 
;arpeggio_data
; !BYTE 0,$C,0
;[eof]

; Variables
;base = $a0
;VOLTAB_CNT  = base + $00
;NOISE   = base + $01

;PCH   = base + $02  ; pattern data pointers (2)

;CH1_LO    = base + $04  ; channel data pointers
;CH2_LO    = base + $05
;CH1_HI    = base + $06
;CH2_HI    = base + $07

;CH_TEMP   = base + $08  ; 16 bit

;NOTE1   = base + $0A  ; note counters
;NOTE2   = base + $0B
;NOTELEN1  = base + $0C  ; current note lengths
;NOTELEN2  = base + $0D

;INS_TYPE1 = base + $0E
;INS_TYPE2 = base + $0F
;TONE1   = base + $10
;TONE2   = base + $11
;VIB_ADD   = base + $12
;eof

vol_default
  !BYTE 8,8,8,7,7,7,6
  !BYTE 6,6,5,5,5,4,4
  !BYTE 8,8,7,7,6,6,5
  !BYTE 5,4,4,3,3,2,2
  ;!BYTE 8,8,8,7,7,7,6
  ;!BYTE 6,6,5,5,5,4,4
  ;!BYTE 8,8,8,7,7,7,6
  ;!BYTE 6,6,5,5,5,4,4
  !BYTE $FF
  
Channel1_lo
  !BYTE (( pat_bass_c - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_bass_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_f - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_harmony_1 - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_c - music_data_start) + music_target_memory )& 255
  !BYTE (( pat_bass_drums_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_f - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_f - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_bass_drums_c - music_data_start) + music_target_memory) & 255
  !BYTE (( pat_harmony_1 - music_data_start) + music_target_memory) & 255
  !BYTE 0
  
;Channel1_hi
; !BYTE pat_bass_c >> 8
; !BYTE pat_bass_c >> 8
; !BYTE pat_bass_c >> 8
; !BYTE pat_bass_f >> 8
; !BYTE pat_harmony_1 >> 8
; !BYTE pat_bass_drums_c >> 8
; !BYTE pat_bass_drums_c >> 8
; !BYTE pat_bass_drums_c >> 8
; !BYTE pat_bass_drums_c >> 8
; !BYTE pat_bass_drums_f >> 8
; !BYTE pat_bass_drums_f >> 8
; !BYTE pat_bass_drums_c >> 8
; !BYTE pat_harmony_1 >> 8
; !BYTE 0
  
Channel2_lo
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory ) & 255
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_harmony_2 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)  & 255
  !BYTE (( pat_harmony_2 - music_data_start) + music_target_memory)  & 255

Channel2_hi
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c1 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_harmony_2 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_quiet - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_f - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_lead_c2 - music_data_start) + music_target_memory)   >> 8
  !BYTE (( pat_harmony_2 - music_data_start) + music_target_memory)   >> 8
  !BYTE 0
  
LEN = $40

speed = 14

  ;
  ; ####################################################
  ;
pat_quiet
  !BYTE LEN+speed*8, OFF
  !BYTE END_MARK
  
pat_lead_c1
  !BYTE $F0
  !BYTE LEN+speed, C3, Ai2, C3, LEN+speed*5, OFF
  !BYTE END_MARK
  
pat_lead_c2
  !BYTE $F0
  !BYTE LEN+speed, C3, Ai2, C3, OFF

  !BYTE $F2
  !BYTE LEN+9, G2
  !BYTE LEN+5, Gi2
  !BYTE LEN+9, G2
  !BYTE LEN+5, Di2
  !BYTE LEN+9, G2
  !BYTE LEN+5, Di2
  !BYTE LEN+9, D3
  !BYTE LEN+5, C3
  !BYTE END_MARK
  
pat_lead_f
  !BYTE $F0
  !BYTE LEN+6, F3, LEN+3, OFF
  !BYTE        F3, LEN+2, OFF
  !BYTE LEN+6, F3, LEN+3, OFF
  !BYTE        F3, LEN+2, OFF
  !BYTE LEN+speed, Di3, F3
  ;
  !BYTE END_MARK
  
pat_harmony_2
  !BYTE $F0
  !BYTE LEN+6, G1, LEN+3, OFF
  !BYTE        G1, LEN+2, OFF
  !BYTE LEN+6, G1, LEN+3, OFF
  !BYTE        G1, LEN+2, OFF
  !BYTE LEN+speed, F1, G1
  ;
  !BYTE LEN+6, D2, LEN+3, OFF
  !BYTE        D2, LEN+2, OFF
  !BYTE LEN+6, D2, LEN+3, OFF
  !BYTE        D2, LEN+2, OFF
  !BYTE LEN+speed, C2, D2
  ;
  !BYTE LEN+6, G2, LEN+3, OFF
  !BYTE        G2, LEN+2, OFF
  !BYTE LEN+6, G2, LEN+3, OFF
  !BYTE        G2, LEN+2, OFF
  !BYTE LEN+speed, F2, G2
  ;
  !BYTE LEN+4, G3 
  !BYTE        F3
  !BYTE LEN+3, D3 
  !BYTE        C3
  !BYTE LEN+4, G2 
  !BYTE        F2
  !BYTE LEN+3, D2 
  !BYTE        C2
  !BYTE LEN+speed, G1, OFF
  !BYTE END_MARK
  
pat_bass_f
  !BYTE LEN+speed,F0
  !BYTE LEN+1,Di1,LEN+speed-1,F1
  !BYTE LEN+speed,F0
  !BYTE LEN+1,Di1,LEN+speed-1,F1
  ;
  !BYTE LEN+speed,F0
  !BYTE LEN+1,Di1,LEN+speed-1,F1

  !BYTE LEN+speed,F0
  !BYTE LEN+1,Di1,LEN+speed-1,F1
  ;
pat_bass_c
  !BYTE $F0
  ;
  !BYTE LEN+speed,C0
  !BYTE LEN+1,Ai0,LEN+speed-1,C1
  !BYTE LEN+speed,G0,Gi0
  ;
  !BYTE           C0
  !BYTE LEN+1,Ai0,LEN+speed-1,C1
  !BYTE LEN+speed,G0,Gi0
  ;
  !BYTE END_MARK
  
pat_bass_drums_c
  !BYTE $F0, LEN+1, C1,G0,Di0,        LEN+speed-3,   C0
  !BYTE $F3,        $35,         $F0, LEN+speed-1-5, C1
  !BYTE $F3,        $34,         $F0, LEN+speed-1-9, C1
  ;
  !BYTE $F3,        $13,$11,$07, $F0, LEN+speed-3,   G0
  !BYTE $F3,        $35,         $F0, LEN+speed-1,   Gi0
  ;
  !BYTE $F0, LEN+1, C1,G0,Di0,        LEN+speed-3,   C0
  !BYTE $F3,        $35,         $F0, LEN+speed-1-5, C1
  !BYTE $F3,        $34,         $F0, LEN+speed-1-9, C1
  ;
  !BYTE $F3,        $13,$11,$07, $F0, LEN+speed-3,   G0
  !BYTE $F3,        $39,         $F0, LEN+speed-1-5, Gi0
  !BYTE $F3,        $1D,$15,$13, $F0, LEN+speed-3-9, Gi0
  !BYTE END_MARK
  
pat_bass_drums_f
  !BYTE $F0, LEN+1, F1,C1,Gi0,        LEN+speed-3,   F0
  !BYTE $F3,        $39,         $F0, LEN+speed-1-5, F1
  !BYTE $F3,        $38,         $F0, LEN+speed-1-9, F1
  ;
  !BYTE $F3,        $13,$11,$07, $F0, LEN+speed-3,   F0
  !BYTE $F3,        $39,         $F0, LEN+speed-1,   F1
  ;
  !BYTE END_MARK
  
pat_harmony_1
  !BYTE $F0
  !BYTE LEN+6, D1, LEN+3, OFF
  !BYTE        D1, LEN+2, OFF
  !BYTE LEN+6, D1, LEN+3, OFF
  !BYTE        D1, LEN+2, OFF
  !BYTE LEN+speed, C1, D1
  ;
  !BYTE LEN+6, G1, LEN+3, OFF
  !BYTE        G1, LEN+2, OFF
  !BYTE LEN+6, G1, LEN+3, OFF
  !BYTE        G1, LEN+2, OFF
  !BYTE LEN+speed, F1, G1
  ;
  !BYTE LEN+6, D2, LEN+3, OFF
  !BYTE        D2, LEN+2, OFF
  !BYTE LEN+6, D2, LEN+3, OFF
  !BYTE        D2, LEN+2, OFF
  !BYTE LEN+speed, C2, D2
  ;
  !BYTE G0,G0,G0,OFF
  !BYTE END_MARK
pat_end
;[eof]

    
*     = character_set_mem_buffer1
character_set_start:
; ==================== Retro Sprite Workshop Project (I:\plus4\Microassembler\bruce lee\bruce lee charset.inc) ========================
; Generated On:       2022. 03. 20. 11:56:57
; Project Name:       Bruce Lee
; Project Comments:   
; Target Platform:    Commodore 16/Plus4
; Project Created On: 2022.02.12 11:22:33

; ==================== Sprite 1 ========================
; Sprite ID:       char_space
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

char_space_WIDTH_PX    = 8
char_space_HEIGHT_PX   = 8
char_space_BIT_PER_PX  = 2
char_space_INDEX       = 0
char_space_NUM_FRAMES  = 1
char_space:
           !BYTE $00, $00, $00, $00, $00, $00, $00, $00

; ==================== Sprite 2 ========================
; Sprite ID:       bull
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_WIDTH_PX    = 8
bull_HEIGHT_PX   = 8
bull_BIT_PER_PX  = 2
bull_INDEX       = 1
bull_NUM_FRAMES  = 1
bull:
     !BYTE $00, $00, $80, $80, $80, $80, $28, $28

; ==================== Sprite 3 ========================
; Sprite ID:       bull_1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_1_WIDTH_PX    = 8
bull_1_HEIGHT_PX   = 8
bull_1_BIT_PER_PX  = 2
bull_1_INDEX       = 2
bull_1_NUM_FRAMES  = 1
bull_1:
       !BYTE $00, $00, $00, $00, $00, $00, $0a, $0a

; ==================== Sprite 4 ========================
; Sprite ID:       bull_2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_2_WIDTH_PX    = 8
bull_2_HEIGHT_PX   = 8
bull_2_BIT_PER_PX  = 2
bull_2_INDEX       = 3
bull_2_NUM_FRAMES  = 1
bull_2:
       !BYTE $00, $00, $80, $80, $80, $80, $00, $00

; ==================== Sprite 5 ========================
; Sprite ID:       bull_3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_3_WIDTH_PX    = 8
bull_3_HEIGHT_PX   = 8
bull_3_BIT_PER_PX  = 2
bull_3_INDEX       = 4
bull_3_NUM_FRAMES  = 1
bull_3:
       !BYTE $02, $02, $0a, $0a, $05, $05, $2a, $2a

; ==================== Sprite 6 ========================
; Sprite ID:       bull_4
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_4_WIDTH_PX    = 8
bull_4_HEIGHT_PX   = 8
bull_4_BIT_PER_PX  = 2
bull_4_INDEX       = 5
bull_4_NUM_FRAMES  = 1
bull_4:
       !BYTE $41, $41, $aa, $aa, $96, $96, $aa, $aa

; ==================== Sprite 7 ========================
; Sprite ID:       bull_5
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_5_WIDTH_PX    = 8
bull_5_HEIGHT_PX   = 8
bull_5_BIT_PER_PX  = 2
bull_5_INDEX       = 6
bull_5_NUM_FRAMES  = 1
bull_5:
       !BYTE $a1, $a1, $9a, $9a, $aa, $aa, $aa, $aa

; ==================== Sprite 8 ========================
; Sprite ID:       bull_6
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_6_WIDTH_PX    = 8
bull_6_HEIGHT_PX   = 8
bull_6_BIT_PER_PX  = 2
bull_6_INDEX       = 7
bull_6_NUM_FRAMES  = 1
bull_6:
       !BYTE $a6, $a6, $aa, $aa, $aa, $aa, $aa, $aa

; ==================== Sprite 9 ========================
; Sprite ID:       bull_7
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_7_WIDTH_PX    = 8
bull_7_HEIGHT_PX   = 8
bull_7_BIT_PER_PX  = 2
bull_7_INDEX       = 8
bull_7_NUM_FRAMES  = 1
bull_7:
       !BYTE $00, $00, $60, $60, $a8, $a8, $aa, $aa

; ==================== Sprite 10 ========================
; Sprite ID:       bull_8
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_8_WIDTH_PX    = 8
bull_8_HEIGHT_PX   = 8
bull_8_BIT_PER_PX  = 2
bull_8_INDEX       = 9
bull_8_NUM_FRAMES  = 1
bull_8:
       !BYTE $99, $99, $aa, $aa, $15, $15, $15, $15

; ==================== Sprite 11 ========================
; Sprite ID:       bull_9
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_9_WIDTH_PX    = 8
bull_9_HEIGHT_PX   = 8
bull_9_BIT_PER_PX  = 2
bull_9_INDEX       = 10
bull_9_NUM_FRAMES  = 1
bull_9:
       !BYTE $aa, $aa, $aa, $aa, $6a, $6a, $aa, $aa

; ==================== Sprite 12 ========================
; Sprite ID:       bull_10
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_10_WIDTH_PX    = 8
bull_10_HEIGHT_PX   = 8
bull_10_BIT_PER_PX  = 2
bull_10_INDEX       = 11
bull_10_NUM_FRAMES  = 1
bull_10:
        !BYTE $9a, $9a, $9a, $9a, $6a, $6a, $5a, $5a

; ==================== Sprite 13 ========================
; Sprite ID:       bull_11
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_11_WIDTH_PX    = 8
bull_11_HEIGHT_PX   = 8
bull_11_BIT_PER_PX  = 2
bull_11_INDEX       = 12
bull_11_NUM_FRAMES  = 1
bull_11:
        !BYTE $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
;             E866 : AA AA             

; ==================== Sprite 14 ========================
; Sprite ID:       bull_12
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=96; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_12_WIDTH_PX    = 8
bull_12_HEIGHT_PX   = 8
bull_12_BIT_PER_PX  = 2
bull_12_INDEX       = 13
bull_12_NUM_FRAMES  = 1
bull_12:
        !BYTE $80, $80, $80, $80, $80, $80, $00, $00

; ==================== Sprite 15 ========================
; Sprite ID:       bull_13
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_13_WIDTH_PX    = 8
bull_13_HEIGHT_PX   = 8
bull_13_BIT_PER_PX  = 2
bull_13_INDEX       = 14
bull_13_NUM_FRAMES  = 1
bull_13:
        !BYTE $aa, $aa, $0a, $0a, $3f, $3f, $02, $02

; ==================== Sprite 16 ========================
; Sprite ID:       bull_14
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_14_WIDTH_PX    = 8
bull_14_HEIGHT_PX   = 8
bull_14_BIT_PER_PX  = 2
bull_14_INDEX       = 15
bull_14_NUM_FRAMES  = 1
bull_14:
        !BYTE $a9, $a9, $15, $15, $ff, $ff, $aa, $aa

; ==================== Sprite 17 ========================
; Sprite ID:       bull_15
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_15_WIDTH_PX    = 8
bull_15_HEIGHT_PX   = 8
bull_15_BIT_PER_PX  = 2
bull_15_INDEX       = 16
bull_15_NUM_FRAMES  = 1
bull_15:
        !BYTE $56, $56, $4a, $4a, $ff, $ff, $aa, $aa

; ==================== Sprite 18 ========================
; Sprite ID:       bull_16
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_16_WIDTH_PX    = 8
bull_16_HEIGHT_PX   = 8
bull_16_BIT_PER_PX  = 2
bull_16_INDEX       = 17
bull_16_NUM_FRAMES  = 1
bull_16:
        !BYTE $85, $85, $95, $95, $ff, $ff, $aa, $aa

; ==================== Sprite 19 ========================
; Sprite ID:       bull_17
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_17_WIDTH_PX    = 8
bull_17_HEIGHT_PX   = 8
bull_17_BIT_PER_PX  = 2
bull_17_INDEX       = 18
bull_17_NUM_FRAMES  = 1
bull_17:
        !BYTE $2a, $2a, $a8, $a8, $ff, $ff, $aa, $aa

; ==================== Sprite 20 ========================
; Sprite ID:       bull_18
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=96; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_18_WIDTH_PX    = 8
bull_18_HEIGHT_PX   = 8
bull_18_BIT_PER_PX  = 2
bull_18_INDEX       = 19
bull_18_NUM_FRAMES  = 1
bull_18:
        !BYTE $00, $00, $00, $00, $c0, $c0, $00, $00

; ==================== Sprite 21 ========================
; Sprite ID:       bull_postament
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_postament_WIDTH_PX    = 8
bull_postament_HEIGHT_PX   = 8
bull_postament_BIT_PER_PX  = 2
bull_postament_INDEX       = 20
bull_postament_NUM_FRAMES  = 1
bull_postament:
               !BYTE $02, $02, $aa, $aa, $02, $02, $02, $02

; ==================== Sprite 22 ========================
; Sprite ID:       sprite_20
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_20_WIDTH_PX    = 8
sprite_20_HEIGHT_PX   = 8
sprite_20_BIT_PER_PX  = 2
sprite_20_INDEX       = 21
sprite_20_NUM_FRAMES  = 1
sprite_20:
          !BYTE $82, $82, $aa, $aa, $82, $82, $82, $82

; ==================== Sprite 23 ========================
; Sprite ID:       sprite_21
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_21_WIDTH_PX    = 8
sprite_21_HEIGHT_PX   = 8
sprite_21_BIT_PER_PX  = 2
sprite_21_INDEX       = 22
sprite_21_NUM_FRAMES  = 1
sprite_21:
          !BYTE $80, $80, $aa, $aa, $80, $80, $80, $80

; ==================== Sprite 24 ========================
; Sprite ID:       sprite_22
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_22_WIDTH_PX    = 8
sprite_22_HEIGHT_PX   = 8
sprite_22_BIT_PER_PX  = 2
sprite_22_INDEX       = 23
sprite_22_NUM_FRAMES  = 1
sprite_22:
          !BYTE $02, $02, $aa, $aa, $82, $82, $82, $82

; ==================== Sprite 25 ========================
; Sprite ID:       sprite_23
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_23_WIDTH_PX    = 8
sprite_23_HEIGHT_PX   = 8
sprite_23_BIT_PER_PX  = 2
sprite_23_INDEX       = 24
sprite_23_NUM_FRAMES  = 1
sprite_23:
          !BYTE $aa, $aa, $82, $82, $aa, $aa, $82, $82

; ==================== Sprite 26 ========================
; Sprite ID:       sprite_24
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_24_WIDTH_PX    = 8
sprite_24_HEIGHT_PX   = 8
sprite_24_BIT_PER_PX  = 2
sprite_24_INDEX       = 25
sprite_24_NUM_FRAMES  = 1
sprite_24:
          !BYTE $80, $80, $aa, $aa, $82, $82, $82, $82

; ==================== Sprite 27 ========================
; Sprite ID:       sprite_25
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_25_WIDTH_PX    = 8
sprite_25_HEIGHT_PX   = 8
sprite_25_BIT_PER_PX  = 2
sprite_25_INDEX       = 26
sprite_25_NUM_FRAMES  = 1
sprite_25:
          !BYTE $02, $02, $00, $00, $0a, $0a, $00, $00

; ==================== Sprite 28 ========================
; Sprite ID:       sprite_26
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_26_WIDTH_PX    = 8
sprite_26_HEIGHT_PX   = 8
sprite_26_BIT_PER_PX  = 2
sprite_26_INDEX       = 27
sprite_26_NUM_FRAMES  = 1
sprite_26:
          !BYTE $02, $02, $20, $20, $22, $22, $20, $20

; ==================== Sprite 29 ========================
; Sprite ID:       bull_postament_end
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=96; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_postament_end_WIDTH_PX    = 8
bull_postament_end_HEIGHT_PX   = 8
bull_postament_end_BIT_PER_PX  = 2
bull_postament_end_INDEX       = 28
bull_postament_end_NUM_FRAMES  = 1
bull_postament_end:
                   !BYTE $00, $00, $00, $00, $80, $80, $00, $00

; ==================== Sprite 30 ========================
; Sprite ID:       sprite_28
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=56; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_28_WIDTH_PX    = 8
sprite_28_HEIGHT_PX   = 8
sprite_28_BIT_PER_PX  = 2
sprite_28_INDEX       = 29
sprite_28_NUM_FRAMES  = 1
sprite_28:
          !BYTE $02, $02, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 31 ========================
; Sprite ID:       sprite_29
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_29_WIDTH_PX    = 8
sprite_29_HEIGHT_PX   = 8
sprite_29_BIT_PER_PX  = 2
sprite_29_INDEX       = 30
sprite_29_NUM_FRAMES  = 1
sprite_29:
          !BYTE $aa, $aa, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 32 ========================
; Sprite ID:       platform
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=96; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

platform_WIDTH_PX    = 8
platform_HEIGHT_PX   = 8
platform_BIT_PER_PX  = 2
platform_INDEX       = 31
platform_NUM_FRAMES  = 1
platform:
         !BYTE $00, $00, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 33 ========================
; Sprite ID:       sprite
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_WIDTH_PX    = 8
sprite_HEIGHT_PX   = 8
sprite_BIT_PER_PX  = 2
sprite_INDEX       = 32
sprite_NUM_FRAMES  = 1
sprite:
       !BYTE $00, $00, $00, $00, $0a, $0a, $0f, $0f

; ==================== Sprite 34 ========================
; Sprite ID:       sprite_1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=208; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_1_WIDTH_PX    = 8
sprite_1_HEIGHT_PX   = 8
sprite_1_BIT_PER_PX  = 2
sprite_1_INDEX       = 33
sprite_1_NUM_FRAMES  = 1
sprite_1:
         !BYTE $00, $00, $00, $00, $00, $00, $3c, $3c

; ==================== Sprite 35 ========================
; Sprite ID:       sprite_2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_2_WIDTH_PX    = 8
sprite_2_HEIGHT_PX   = 8
sprite_2_BIT_PER_PX  = 2
sprite_2_INDEX       = 34
sprite_2_NUM_FRAMES  = 1
sprite_2:
         !BYTE $ff, $ff, $ff, $ff, $10, $10, $10, $10

; ==================== Sprite 36 ========================
; Sprite ID:       sprite_3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=208; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_3_WIDTH_PX    = 8
sprite_3_HEIGHT_PX   = 8
sprite_3_BIT_PER_PX  = 2
sprite_3_INDEX       = 35
sprite_3_NUM_FRAMES  = 1
sprite_3:
         !BYTE $ff, $ff, $ff, $ff, $56, $56, $5a, $5a

; ==================== Sprite 37 ========================
; Sprite ID:       lamp_post_roof2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_post_roof2_WIDTH_PX    = 8
lamp_post_roof2_HEIGHT_PX   = 8
lamp_post_roof2_BIT_PER_PX  = 2
lamp_post_roof2_INDEX       = 36
lamp_post_roof2_NUM_FRAMES  = 1
lamp_post_roof2:
                !BYTE $01, $01, $05, $05, $05, $05, $00, $00

; ==================== Sprite 38 ========================
; Sprite ID:       lamp_post_ceiling
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=208; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_post_ceiling_WIDTH_PX    = 8
lamp_post_ceiling_HEIGHT_PX   = 8
lamp_post_ceiling_BIT_PER_PX  = 2
lamp_post_ceiling_INDEX       = 37
lamp_post_ceiling_NUM_FRAMES  = 1
lamp_post_ceiling:
                  !BYTE $5a, $5a, $5a, $5a, $59, $59, $00, $00

; ==================== Sprite 39 ========================
; Sprite ID:       sprite_6
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=216; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_6_WIDTH_PX    = 8
sprite_6_HEIGHT_PX   = 8
sprite_6_BIT_PER_PX  = 2
sprite_6_INDEX       = 38
sprite_6_NUM_FRAMES  = 1
sprite_6:
         !BYTE $5a, $5a, $5a, $5a, $59, $59, $55, $55

; ==================== Sprite 40 ========================
; Sprite ID:       sprite_7
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=216; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_7_WIDTH_PX    = 8
sprite_7_HEIGHT_PX   = 8
sprite_7_BIT_PER_PX  = 2
sprite_7_INDEX       = 39
sprite_7_NUM_FRAMES  = 1
sprite_7:
         !BYTE $aa, $aa, $82, $82, $82, $82, $82, $82

; ==================== Sprite 41 ========================
; Sprite ID:       sprite_8
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=216; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_8_WIDTH_PX    = 8
sprite_8_HEIGHT_PX   = 8
sprite_8_BIT_PER_PX  = 2
sprite_8_INDEX       = 40
sprite_8_NUM_FRAMES  = 1
sprite_8:
         !BYTE $aa, $aa, $82, $82, $aa, $aa, $be, $be

; ==================== Sprite 42 ========================
; Sprite ID:       sprite_9
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=216; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_9_WIDTH_PX    = 8
sprite_9_HEIGHT_PX   = 8
sprite_9_BIT_PER_PX  = 2
sprite_9_INDEX       = 41
sprite_9_NUM_FRAMES  = 1
sprite_9:
         !BYTE $ff, $ff, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 43 ========================
; Sprite ID:       sprite_10
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=256; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_10_WIDTH_PX    = 8
sprite_10_HEIGHT_PX   = 8
sprite_10_BIT_PER_PX  = 2
sprite_10_INDEX       = 42
sprite_10_NUM_FRAMES  = 1
sprite_10:
          !BYTE $aa, $aa, $02, $02, $02, $02, $02, $02

; ==================== Sprite 44 ========================
; Sprite ID:       sprite_11
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=272; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_11_WIDTH_PX    = 8
sprite_11_HEIGHT_PX   = 8
sprite_11_BIT_PER_PX  = 2
sprite_11_INDEX       = 43
sprite_11_NUM_FRAMES  = 1
sprite_11:
          !BYTE $aa, $aa, $80, $80, $80, $80, $80, $80

; ==================== Sprite 45 ========================
; Sprite ID:       sprite_12
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=312; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_12_WIDTH_PX    = 8
sprite_12_HEIGHT_PX   = 8
sprite_12_BIT_PER_PX  = 2
sprite_12_INDEX       = 44
sprite_12_NUM_FRAMES  = 1
sprite_12:
          !BYTE $55, $55, $45, $45, $51, $51, $45, $45

; ==================== Sprite 46 ========================
; Sprite ID:       black_column_bottom
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=312; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

black_column_bottom_WIDTH_PX    = 8
black_column_bottom_HEIGHT_PX   = 8
black_column_bottom_BIT_PER_PX  = 2
black_column_bottom_INDEX       = 45
black_column_bottom_NUM_FRAMES  = 1
black_column_bottom:
                    !BYTE $7d, $7d, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 47 ========================
; Sprite ID:       wall1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=312; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall1_WIDTH_PX    = 8
wall1_HEIGHT_PX   = 8
wall1_BIT_PER_PX  = 2
wall1_INDEX       = 46
wall1_NUM_FRAMES  = 1
wall1:
      !BYTE $51, $51, $45, $45, $51, $51, $45, $45

; ==================== Sprite 48 ========================
; Sprite ID:       lamp_post_roof1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_post_roof1_WIDTH_PX    = 8
lamp_post_roof1_HEIGHT_PX   = 8
lamp_post_roof1_BIT_PER_PX  = 2
lamp_post_roof1_INDEX       = 47
lamp_post_roof1_NUM_FRAMES  = 1
lamp_post_roof1:
                !BYTE $40, $40, $50, $50, $50, $50, $00, $00

; ==================== Sprite 49 ========================
; Sprite ID:       sprite_17
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_17_WIDTH_PX    = 8
sprite_17_HEIGHT_PX   = 8
sprite_17_BIT_PER_PX  = 2
sprite_17_INDEX       = 48
sprite_17_NUM_FRAMES  = 1
sprite_17:
          !BYTE $00, $00, $00, $00, $a0, $a0, $f0, $f0

; ==================== Sprite 50 ========================
; Sprite ID:       sprite_18
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_18_WIDTH_PX    = 8
sprite_18_HEIGHT_PX   = 8
sprite_18_BIT_PER_PX  = 2
sprite_18_INDEX       = 49
sprite_18_NUM_FRAMES  = 1
sprite_18:
          !BYTE $ff, $ff, $ff, $ff, $04, $04, $04, $04

; ==================== Sprite 51 ========================
; Sprite ID:       invisible_platform
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=48; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

invisible_platform_WIDTH_PX    = 8
invisible_platform_HEIGHT_PX   = 8
invisible_platform_BIT_PER_PX  = 2
invisible_platform_INDEX       = 50
invisible_platform_NUM_FRAMES  = 1
invisible_platform:
                   !BYTE $00, $00, $00, $00, $00, $00, $ff, $ff

; ==================== Sprite 52 ========================
; Sprite ID:       sprite_31
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=48; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_31_WIDTH_PX    = 8
sprite_31_HEIGHT_PX   = 8
sprite_31_BIT_PER_PX  = 2
sprite_31_INDEX       = 51
sprite_31_NUM_FRAMES  = 1
sprite_31:
          !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $55, $55

; ==================== Sprite 53 ========================
; Sprite ID:       sprite_32
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=40; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_32_WIDTH_PX    = 8
sprite_32_HEIGHT_PX   = 8
sprite_32_BIT_PER_PX  = 2
sprite_32_INDEX       = 52
sprite_32_NUM_FRAMES  = 1
sprite_32:
          !BYTE $00, $00, $00, $00, $ff, $ff, $55, $55

; ==================== Sprite 54 ========================
; Sprite ID:       bottom_line_black
; Sprite Comments: 
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bottom_line_black_WIDTH_PX    = 8
bottom_line_black_HEIGHT_PX   = 8
bottom_line_black_BIT_PER_PX  = 2
bottom_line_black_INDEX       = 53
bottom_line_black_NUM_FRAMES  = 1
bottom_line_black:
                  !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; ==================== Sprite 55 ========================
; Sprite ID:       statue
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_WIDTH_PX    = 8
statue_HEIGHT_PX   = 8
statue_BIT_PER_PX  = 2
statue_INDEX       = 54
statue_NUM_FRAMES  = 1
statue:
       !BYTE $00, $00, $00, $00, $10, $10, $10, $10

; ==================== Sprite 56 ========================
; Sprite ID:       statue_1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_1_WIDTH_PX    = 8
statue_1_HEIGHT_PX   = 8
statue_1_BIT_PER_PX  = 2
statue_1_INDEX       = 55
statue_1_NUM_FRAMES  = 1
statue_1:
         !BYTE $41, $61, $55, $55, $3c, $3c, $14, $14

; ==================== Sprite 57 ========================
; Sprite ID:       statue_2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_2_WIDTH_PX    = 8
statue_2_HEIGHT_PX   = 8
statue_2_BIT_PER_PX  = 2
statue_2_INDEX       = 56
statue_2_NUM_FRAMES  = 1
statue_2:
         !BYTE $00, $00, $00, $00, $04, $04, $04, $04

; ==================== Sprite 58 ========================
; Sprite ID:       statue_3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_3_WIDTH_PX    = 8
statue_3_HEIGHT_PX   = 8
statue_3_BIT_PER_PX  = 2
statue_3_INDEX       = 57
statue_3_NUM_FRAMES  = 1
statue_3:
         !BYTE $11, $11, $15, $15, $0d, $0d, $03, $03

; ==================== Sprite 59 ========================
; Sprite ID:       statue_4
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_4_WIDTH_PX    = 8
statue_4_HEIGHT_PX   = 8
statue_4_BIT_PER_PX  = 2
statue_4_INDEX       = 58
statue_4_NUM_FRAMES  = 1
statue_4:
         !BYTE $55, $55, $55, $55, $d7, $d7, $7d, $7d

; ==================== Sprite 60 ========================
; Sprite ID:       statue_5
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_5_WIDTH_PX    = 8
statue_5_HEIGHT_PX   = 8
statue_5_BIT_PER_PX  = 2
statue_5_INDEX       = 59
statue_5_NUM_FRAMES  = 1
statue_5:
         !BYTE $44, $44, $54, $54, $70, $70, $c0, $c0

; ==================== Sprite 61 ========================
; Sprite ID:       statue_6
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_6_WIDTH_PX    = 8
statue_6_HEIGHT_PX   = 8
statue_6_BIT_PER_PX  = 2
statue_6_INDEX       = 60
statue_6_NUM_FRAMES  = 1
statue_6:
         !BYTE $10, $10, $11, $11, $15, $15, $03, $03

; ==================== Sprite 62 ========================
; Sprite ID:       statue_7
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_7_WIDTH_PX    = 8
statue_7_HEIGHT_PX   = 8
statue_7_BIT_PER_PX  = 2
statue_7_INDEX       = 61
statue_7_NUM_FRAMES  = 1
statue_7:
         !BYTE $96, $96, $55, $55, $55, $55, $7d, $7d

; ==================== Sprite 63 ========================
; Sprite ID:       statue_8
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_8_WIDTH_PX    = 8
statue_8_HEIGHT_PX   = 8
statue_8_BIT_PER_PX  = 2
statue_8_INDEX       = 62
statue_8_NUM_FRAMES  = 1
statue_8:
         !BYTE $04, $04, $44, $44, $54, $54, $c0, $c0

; ==================== Sprite 64 ========================
; Sprite ID:       statue_9
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_9_WIDTH_PX    = 8
statue_9_HEIGHT_PX   = 8
statue_9_BIT_PER_PX  = 2
statue_9_INDEX       = 63
statue_9_NUM_FRAMES  = 1
statue_9:
         !BYTE $3d, $3d, $ff, $ff, $f0, $f0, $00, $00

; ==================== Sprite 65 ========================
; Sprite ID:       statue_10
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_10_WIDTH_PX    = 8
statue_10_HEIGHT_PX   = 8
statue_10_BIT_PER_PX  = 2
statue_10_INDEX       = 64
statue_10_NUM_FRAMES  = 1
statue_10:
          !BYTE $7d, $7d, $ff, $ff, $eb, $eb, $14, $14

; ==================== Sprite 66 ========================
; Sprite ID:       statue_11
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=24; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

statue_11_WIDTH_PX    = 8
statue_11_HEIGHT_PX   = 8
statue_11_BIT_PER_PX  = 2
statue_11_INDEX       = 65
statue_11_NUM_FRAMES  = 1
statue_11:
          !BYTE $7c, $7c, $ff, $ff, $0f, $0f, $00, $00

; ==================== Sprite 67 ========================
; Sprite ID:       sprite_33
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=272; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_33_WIDTH_PX    = 8
sprite_33_HEIGHT_PX   = 8
sprite_33_BIT_PER_PX  = 2
sprite_33_INDEX       = 66
sprite_33_NUM_FRAMES  = 1
sprite_33:
          !BYTE $aa, $aa, $82, $82, $00, $00, $00, $00

; ==================== Sprite 68 ========================
; Sprite ID:       sprite_34
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=144; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_34_WIDTH_PX    = 8
sprite_34_HEIGHT_PX   = 8
sprite_34_BIT_PER_PX  = 2
sprite_34_INDEX       = 67
sprite_34_NUM_FRAMES  = 1
sprite_34:
          !BYTE $3f, $3f, $c0, $c0, $fc, $fc, $c0, $c0

; ==================== Sprite 69 ========================
; Sprite ID:       sprite_35
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=160; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_35_WIDTH_PX    = 8
sprite_35_HEIGHT_PX   = 8
sprite_35_BIT_PER_PX  = 2
sprite_35_INDEX       = 68
sprite_35_NUM_FRAMES  = 1
sprite_35:
          !BYTE $3f, $3f, $03, $03, $fc, $fc, $03, $03

; ==================== Sprite 70 ========================
; Sprite ID:       sprite_36
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=144; PosY=152
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_36_WIDTH_PX    = 8
sprite_36_HEIGHT_PX   = 8
sprite_36_BIT_PER_PX  = 2
sprite_36_INDEX       = 69
sprite_36_NUM_FRAMES  = 1
sprite_36:
          !BYTE $3f, $3f, $03, $03, $fc, $fc, $00, $00

; ==================== Sprite 71 ========================
; Sprite ID:       sprite_37
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_37_WIDTH_PX    = 8
sprite_37_HEIGHT_PX   = 8
sprite_37_BIT_PER_PX  = 2
sprite_37_INDEX       = 70
sprite_37_NUM_FRAMES  = 1
sprite_37:
          !BYTE $15, $15, $2a, $2a, $08, $08, $08, $08

; ==================== Sprite 72 ========================
; Sprite ID:       sprite_38
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_38_WIDTH_PX    = 8
sprite_38_HEIGHT_PX   = 8
sprite_38_BIT_PER_PX  = 2
sprite_38_INDEX       = 71
sprite_38_NUM_FRAMES  = 1
sprite_38:
          !BYTE $08, $08, $08, $08, $08, $08, $08, $08

; ==================== Sprite 73 ========================
; Sprite ID:       hills
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=0; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_WIDTH_PX    = 8
hills_HEIGHT_PX   = 8
hills_BIT_PER_PX  = 2
hills_INDEX       = 72
hills_NUM_FRAMES  = 1
hills:
      !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $fa, $fa

; ==================== Sprite 74 ========================
; Sprite ID:       hills_2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_2_WIDTH_PX    = 8
hills_2_HEIGHT_PX   = 8
hills_2_BIT_PER_PX  = 2
hills_2_INDEX       = 73
hills_2_NUM_FRAMES  = 1
hills_2:
        !BYTE $ff, $ff, $fa, $fa, $aa, $aa, $aa, $aa

; ==================== Sprite 75 ========================
; Sprite ID:       hills_1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_1_WIDTH_PX    = 8
hills_1_HEIGHT_PX   = 8
hills_1_BIT_PER_PX  = 2
hills_1_INDEX       = 74
hills_1_NUM_FRAMES  = 1
hills_1:
        !BYTE $af, $af, $aa, $aa, $aa, $aa, $aa, $aa

; ==================== Sprite 76 ========================
; Sprite ID:       hills_3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_3_WIDTH_PX    = 8
hills_3_HEIGHT_PX   = 8
hills_3_BIT_PER_PX  = 2
hills_3_INDEX       = 75
hills_3_NUM_FRAMES  = 1
hills_3:
        !BYTE $ff, $ff, $ff, $ff, $bf, $bf, $af, $af

; ==================== Sprite 77 ========================
; Sprite ID:       hills_4
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=0; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_4_WIDTH_PX    = 8
hills_4_HEIGHT_PX   = 8
hills_4_BIT_PER_PX  = 2
hills_4_INDEX       = 76
hills_4_NUM_FRAMES  = 1
hills_4:
        !BYTE $ea, $ea, $a2, $a2, $02, $02, $0a, $0a

; ==================== Sprite 78 ========================
; Sprite ID:       hills_5
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=8; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_5_WIDTH_PX    = 8
hills_5_HEIGHT_PX   = 8
hills_5_BIT_PER_PX  = 2
hills_5_INDEX       = 77
hills_5_NUM_FRAMES  = 1
hills_5:
        !BYTE $aa, $aa, $aa, $aa, $8a, $8a, $0a, $0a

; ==================== Sprite 79 ========================
; Sprite ID:       hills_6
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_6_WIDTH_PX    = 8
hills_6_HEIGHT_PX   = 8
hills_6_BIT_PER_PX  = 2
hills_6_INDEX       = 78
hills_6_NUM_FRAMES  = 1
hills_6:
        !BYTE $aa, $aa, $aa, $aa, $a8, $a8, $a0, $a0

; ==================== Sprite 80 ========================
; Sprite ID:       hills_7
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=64; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_7_WIDTH_PX    = 8
hills_7_HEIGHT_PX   = 8
hills_7_BIT_PER_PX  = 2
hills_7_INDEX       = 79
hills_7_NUM_FRAMES  = 1
hills_7:
        !BYTE $aa, $aa, $aa, $aa, $a8, $a8, $20, $20
;             EA7E : 20 20             

; ==================== Sprite 81 ========================
; Sprite ID:       hills_8
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_8_WIDTH_PX    = 8
hills_8_HEIGHT_PX   = 8
hills_8_BIT_PER_PX  = 2
hills_8_INDEX       = 80
hills_8_NUM_FRAMES  = 1
hills_8:
        !BYTE $ff, $ff, $3f, $3f, $03, $03, $00, $00
;             EA86 : 00 00             

; ==================== Sprite 82 ========================
; Sprite ID:       hills_9
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=16; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_9_WIDTH_PX    = 8
hills_9_HEIGHT_PX   = 8
hills_9_BIT_PER_PX  = 2
hills_9_INDEX       = 81
hills_9_NUM_FRAMES  = 1
hills_9:
        !BYTE $28, $28, $08, $08, $00, $00, $00, $00

; ==================== Sprite 83 ========================
; Sprite ID:       hills_10
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=32; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_10_WIDTH_PX    = 8
hills_10_HEIGHT_PX   = 8
hills_10_BIT_PER_PX  = 2
hills_10_INDEX       = 82
hills_10_NUM_FRAMES  = 1
hills_10:
         !BYTE $80, $80, $80, $80, $00, $00, $00, $00

; ==================== Sprite 84 ========================
; Sprite ID:       hills_11
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=72; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_11_WIDTH_PX    = 8
hills_11_HEIGHT_PX   = 8
hills_11_BIT_PER_PX  = 2
hills_11_INDEX       = 83
hills_11_NUM_FRAMES  = 1
hills_11:
         !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; ==================== Sprite 85 ========================
; Sprite ID:       hills_12
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=88; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_12_WIDTH_PX    = 8
hills_12_HEIGHT_PX   = 8
hills_12_BIT_PER_PX  = 2
hills_12_INDEX       = 84
hills_12_NUM_FRAMES  = 1
hills_12:
         !BYTE $fa, $fa, $ea, $ea, $ea, $ea, $aa, $aa

; ==================== Sprite 86 ========================
; Sprite ID:       hills_13
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=128; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_13_WIDTH_PX    = 8
hills_13_HEIGHT_PX   = 8
hills_13_BIT_PER_PX  = 2
hills_13_INDEX       = 85
hills_13_NUM_FRAMES  = 1
hills_13:
         !BYTE $ff, $ff, $fc, $fc, $c0, $c0, $00, $00

; ==================== Sprite 87 ========================
; Sprite ID:       hills_14
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=168; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_14_WIDTH_PX    = 8
hills_14_HEIGHT_PX   = 8
hills_14_BIT_PER_PX  = 2
hills_14_INDEX       = 86
hills_14_NUM_FRAMES  = 1
hills_14:
         !BYTE $fc, $fc, $f0, $f0, $f0, $f0, $c0, $c0

; ==================== Sprite 88 ========================
; Sprite ID:       hills_15
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=168; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_15_WIDTH_PX    = 8
hills_15_HEIGHT_PX   = 8
hills_15_BIT_PER_PX  = 2
hills_15_INDEX       = 87
hills_15_NUM_FRAMES  = 1
hills_15:
         !BYTE $c0, $c0, $00, $00, $00, $00, $00, $00

; ==================== Sprite 89 ========================
; Sprite ID:       hills_16
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_16_WIDTH_PX    = 8
hills_16_HEIGHT_PX   = 8
hills_16_BIT_PER_PX  = 2
hills_16_INDEX       = 88
hills_16_NUM_FRAMES  = 1
hills_16:
         !BYTE $02, $02, $00, $00, $00, $00, $00, $00

; ==================== Sprite 90 ========================
; Sprite ID:       hills_17
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=280; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

hills_17_WIDTH_PX    = 8
hills_17_HEIGHT_PX   = 8
hills_17_BIT_PER_PX  = 2
hills_17_INDEX       = 89
hills_17_NUM_FRAMES  = 1
hills_17:
         !BYTE $ff, $ff, $3f, $3f, $0f, $0f, $03, $03

; ==================== Sprite 91 ========================
; Sprite ID:       sprite_39
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=272; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_39_WIDTH_PX    = 8
sprite_39_HEIGHT_PX   = 8
sprite_39_BIT_PER_PX  = 2
sprite_39_INDEX       = 90
sprite_39_NUM_FRAMES  = 1
sprite_39:
          !BYTE $aa, $aa, $88, $88, $aa, $aa, $88, $88

; ==================== Sprite 92 ========================
; Sprite ID:       sprite_40
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=288; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_40_WIDTH_PX    = 8
sprite_40_HEIGHT_PX   = 8
sprite_40_BIT_PER_PX  = 2
sprite_40_INDEX       = 91
sprite_40_NUM_FRAMES  = 1
sprite_40:
          !BYTE $aa, $aa, $22, $22, $aa, $aa, $22, $22

; ==================== Sprite 93 ========================
; Sprite ID:       sprite_41
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=304; PosY=128
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_41_WIDTH_PX    = 8
sprite_41_HEIGHT_PX   = 8
sprite_41_BIT_PER_PX  = 2
sprite_41_INDEX       = 92
sprite_41_NUM_FRAMES  = 1
sprite_41:
          !BYTE $51, $51, $45, $45, $51, $51, $7d, $7d

; ==================== Sprite 94 ========================
; Sprite ID:       sprite_42
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=152; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_42_WIDTH_PX    = 8
sprite_42_HEIGHT_PX   = 8
sprite_42_BIT_PER_PX  = 2
sprite_42_INDEX       = 93
sprite_42_NUM_FRAMES  = 1
sprite_42:
          !BYTE $00, $00, $00, $00, $33, $33, $3f, $3f

; ==================== Sprite 95 ========================
; Sprite ID:       sprite_43
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=160; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_43_WIDTH_PX    = 8
sprite_43_HEIGHT_PX   = 8
sprite_43_BIT_PER_PX  = 2
sprite_43_INDEX       = 94
sprite_43_NUM_FRAMES  = 1
sprite_43:
          !BYTE $00, $00, $00, $00, $cc, $cc, $fc, $fc

; ==================== Sprite 96 ========================
; Sprite ID:       sprite_44
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=152; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_44_WIDTH_PX    = 8
sprite_44_HEIGHT_PX   = 8
sprite_44_BIT_PER_PX  = 2
sprite_44_INDEX       = 95
sprite_44_NUM_FRAMES  = 1
sprite_44:
          !BYTE $aa, $aa, $80, $80, $28, $28, $80, $80

; ==================== Sprite 97 ========================
; Sprite ID:       sprite_45
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=160; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_45_WIDTH_PX    = 8
sprite_45_HEIGHT_PX   = 8
sprite_45_BIT_PER_PX  = 2
sprite_45_INDEX       = 96
sprite_45_NUM_FRAMES  = 1
sprite_45:
          !BYTE $aa, $aa, $02, $02, $a8, $a8, $02, $02

; ==================== Sprite 98 ========================
; Sprite ID:       sprite_46
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=152; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_46_WIDTH_PX    = 8
sprite_46_HEIGHT_PX   = 8
sprite_46_BIT_PER_PX  = 2
sprite_46_INDEX       = 97
sprite_46_NUM_FRAMES  = 1
sprite_46:
          !BYTE $2a, $2a, $00, $00, $00, $00, $00, $00

; ==================== Sprite 99 ========================
; Sprite ID:       sprite_47
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=160; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_47_WIDTH_PX    = 8
sprite_47_HEIGHT_PX   = 8
sprite_47_BIT_PER_PX  = 2
sprite_47_INDEX       = 98
sprite_47_NUM_FRAMES  = 1
sprite_47:
          !BYTE $28, $28, $00, $00, $00, $00, $00, $00

; ==================== Sprite 100 ========================
; Sprite ID:       sprite_48
; Sprite Comments: Captured from Screenshot (2.png)
;                  PosX=152; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_48_WIDTH_PX    = 8
sprite_48_HEIGHT_PX   = 8
sprite_48_BIT_PER_PX  = 2
sprite_48_INDEX       = 99
sprite_48_NUM_FRAMES  = 1
sprite_48:
          !BYTE $3c, $3c, $ff, $ff, $ff, $ff, $00, $00

; ==================== Sprite 101 ========================
; Sprite ID:       sprite_49
; Sprite Comments: Captured from Screenshot (3.png)
;                  PosX=256; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_49_WIDTH_PX    = 8
sprite_49_HEIGHT_PX   = 8
sprite_49_BIT_PER_PX  = 2
sprite_49_INDEX       = 100
sprite_49_NUM_FRAMES  = 1
sprite_49:
          !BYTE $51, $51, $14, $14, $45, $45, $10, $10

; ==================== Sprite 102 ========================
; Sprite ID:       sprite_50
; Sprite Comments: Captured from Screenshot (3.png)
;                  PosX=264; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_50_WIDTH_PX    = 8
sprite_50_HEIGHT_PX   = 8
sprite_50_BIT_PER_PX  = 2
sprite_50_INDEX       = 101
sprite_50_NUM_FRAMES  = 1
sprite_50:
          !BYTE $44, $44, $d5, $d5, $70, $70, $44, $44

; ==================== Sprite 103 ========================
; Sprite ID:       sprite_51
; Sprite Comments: Captured from Screenshot (3.png)
;                  PosX=256; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_51_WIDTH_PX    = 8
sprite_51_HEIGHT_PX   = 8
sprite_51_BIT_PER_PX  = 2
sprite_51_INDEX       = 102
sprite_51_NUM_FRAMES  = 1
sprite_51:
          !BYTE $14, $14, $44, $44, $00, $00, $40, $40

; ==================== Sprite 104 ========================
; Sprite ID:       sprite_52
; Sprite Comments: Captured from Screenshot (3.png)
;                  PosX=264; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_52_WIDTH_PX    = 8
sprite_52_HEIGHT_PX   = 8
sprite_52_BIT_PER_PX  = 2
sprite_52_INDEX       = 103
sprite_52_NUM_FRAMES  = 1
sprite_52:
          !BYTE $10, $10, $00, $00, $00, $00, $00, $00

; ==================== Sprite 105 ========================
; Sprite ID:       sprite_53
; Sprite Comments: Captured from Screenshot (3.png)
;                  PosX=296; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_53_WIDTH_PX    = 8
sprite_53_HEIGHT_PX   = 8
sprite_53_BIT_PER_PX  = 2
sprite_53_INDEX       = 104
sprite_53_NUM_FRAMES  = 1
sprite_53:
          !BYTE $71, $71, $45, $45, $10, $10, $01, $01

; ==================== Sprite 106 ========================
; Sprite ID:       warp1
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

warp1_WIDTH_PX    = 8
warp1_HEIGHT_PX   = 8
warp1_BIT_PER_PX  = 2
warp1_INDEX       = 105
warp1_NUM_FRAMES  = 1
warp1:
      !BYTE $00, $00, $04, $04, $04, $04, $00, $00

; ==================== Sprite 107 ========================
; Sprite ID:       warp2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

warp2_WIDTH_PX    = 8
warp2_HEIGHT_PX   = 8
warp2_BIT_PER_PX  = 2
warp2_INDEX       = 106
warp2_NUM_FRAMES  = 1
warp2:
      !BYTE $00, $00, $14, $04, $10, $14, $00, $00

; ==================== Sprite 108 ========================
; Sprite ID:       warp3
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

warp3_WIDTH_PX    = 8
warp3_HEIGHT_PX   = 8
warp3_BIT_PER_PX  = 2
warp3_INDEX       = 107
warp3_NUM_FRAMES  = 1
warp3:
      !BYTE $00, $14, $04, $14, $04, $14, $00, $00

; ==================== Sprite 109 ========================
; Sprite ID:       warp4
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=80; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

warp4_WIDTH_PX    = 8
warp4_HEIGHT_PX   = 8
warp4_BIT_PER_PX  = 2
warp4_INDEX       = 108
warp4_NUM_FRAMES  = 1
warp4:
      !BYTE $00, $00, $44, $54, $04, $04, $00, $00

; ==================== Sprite 110 ========================
; Sprite ID:       lamp1
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=145
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp1_WIDTH_PX    = 8
lamp1_HEIGHT_PX   = 8
lamp1_BIT_PER_PX  = 2
lamp1_INDEX       = 109
lamp1_NUM_FRAMES  = 1
lamp1:
      !BYTE $2a, $2a, $15, $15, $2a, $2a, $08, $08

; ==================== Sprite 111 ========================
; Sprite ID:       lamp2
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=72; PosY=145
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp2_WIDTH_PX    = 8
lamp2_HEIGHT_PX   = 8
lamp2_BIT_PER_PX  = 2
lamp2_INDEX       = 110
lamp2_NUM_FRAMES  = 1
lamp2:
      !BYTE $2a, $2a, $1d, $1d, $2a, $2a, $08, $08

; ==================== Sprite 112 ========================
; Sprite ID:       lamp3
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=193
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp3_WIDTH_PX    = 8
lamp3_HEIGHT_PX   = 8
lamp3_BIT_PER_PX  = 2
lamp3_INDEX       = 111
lamp3_NUM_FRAMES  = 1
lamp3:
      !BYTE $2a, $2a, $11, $11, $2a, $2a, $08, $08

; ==================== Sprite 113 ========================
; Sprite ID:       lamp4
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=193
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp4_WIDTH_PX    = 8
lamp4_HEIGHT_PX   = 8
lamp4_BIT_PER_PX  = 2
lamp4_INDEX       = 112
lamp4_NUM_FRAMES  = 1
lamp4:
      !BYTE $2a, $2a, $19, $19, $2a, $2a, $08, $08

; ==================== Sprite 114 ========================
; Sprite ID:       lamp1_shifted
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=145
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp1_shifted_WIDTH_PX    = 8
lamp1_shifted_HEIGHT_PX   = 8
lamp1_shifted_BIT_PER_PX  = 2
lamp1_shifted_INDEX       = 113
lamp1_shifted_NUM_FRAMES  = 1
lamp1_shifted:
              !BYTE $a8, $a8, $54, $54, $a8, $a8, $20, $20

; ==================== Sprite 115 ========================
; Sprite ID:       lamp2_shifted
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=72; PosY=145
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp2_shifted_WIDTH_PX    = 8
lamp2_shifted_HEIGHT_PX   = 8
lamp2_shifted_BIT_PER_PX  = 2
lamp2_shifted_INDEX       = 114
lamp2_shifted_NUM_FRAMES  = 1
lamp2_shifted:
              !BYTE $a8, $a8, $74, $74, $a8, $a8, $20, $20

; ==================== Sprite 116 ========================
; Sprite ID:       lamp3_shifted
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=193
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp3_shifted_WIDTH_PX    = 8
lamp3_shifted_HEIGHT_PX   = 8
lamp3_shifted_BIT_PER_PX  = 2
lamp3_shifted_INDEX       = 115
lamp3_shifted_NUM_FRAMES  = 1
lamp3_shifted:
              !BYTE $a8, $a8, $44, $44, $a8, $a8, $20, $20

; ==================== Sprite 117 ========================
; Sprite ID:       lamp4_shifted
; Sprite Comments: Captured from Screenshot (vice-screen-2022022808573166.png)
;                  PosX=104; PosY=193
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

lamp4_shifted_WIDTH_PX    = 8
lamp4_shifted_HEIGHT_PX   = 8
lamp4_shifted_BIT_PER_PX  = 2
lamp4_shifted_INDEX       = 116
lamp4_shifted_NUM_FRAMES  = 1
lamp4_shifted:
              !BYTE $a8, $a8, $64, $64, $a8, $a8, $20, $20

; ==================== Sprite 118 ========================
; Sprite ID:       lamp_hanger_shifted
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger_shifted_WIDTH_PX    = 8
lamp_hanger_shifted_HEIGHT_PX   = 8
lamp_hanger_shifted_BIT_PER_PX  = 2
lamp_hanger_shifted_INDEX       = 117
lamp_hanger_shifted_NUM_FRAMES  = 1
lamp_hanger_shifted:
                    !BYTE $01, $01, $05, $05, $05, $15, $20, $20

; ==================== Sprite 119 ========================
; Sprite ID:       lamp_hanger_ceiling_shifted
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=208; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger_ceiling_shifted_WIDTH_PX    = 8
lamp_hanger_ceiling_shifted_HEIGHT_PX   = 8
lamp_hanger_ceiling_shifted_BIT_PER_PX  = 2
lamp_hanger_ceiling_shifted_INDEX       = 118
lamp_hanger_ceiling_shifted_NUM_FRAMES  = 1
lamp_hanger_ceiling_shifted:
                            !BYTE $5a, $5a, $5a, $5a, $59, $59, $20, $20

; ==================== Sprite 120 ========================
; Sprite ID:       lamp_hanger2_shifted
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger2_shifted_WIDTH_PX    = 8
lamp_hanger2_shifted_HEIGHT_PX   = 8
lamp_hanger2_shifted_BIT_PER_PX  = 2
lamp_hanger2_shifted_INDEX       = 119
lamp_hanger2_shifted_NUM_FRAMES  = 1
lamp_hanger2_shifted:
                     !BYTE $40, $40, $50, $50, $50, $50, $20, $20

; ==================== Sprite 121 ========================
; Sprite ID:       lamp_hanger
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger_WIDTH_PX    = 8
lamp_hanger_HEIGHT_PX   = 8
lamp_hanger_BIT_PER_PX  = 2
lamp_hanger_INDEX       = 120
lamp_hanger_NUM_FRAMES  = 1
lamp_hanger:
            !BYTE $01, $01, $05, $05, $05, $05, $08, $08

; ==================== Sprite 122 ========================
; Sprite ID:       lamp_hanger_ceiling
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=208; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger_ceiling_WIDTH_PX    = 8
lamp_hanger_ceiling_HEIGHT_PX   = 8
lamp_hanger_ceiling_BIT_PER_PX  = 2
lamp_hanger_ceiling_INDEX       = 121
lamp_hanger_ceiling_NUM_FRAMES  = 1
lamp_hanger_ceiling:
                    !BYTE $5a, $5a, $5a, $5a, $59, $59, $08, $08

; ==================== Sprite 123 ========================
; Sprite ID:       lamp_hanger2
; Sprite Comments: Captured from Screenshot (1.png)
;                  PosX=200; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

lamp_hanger2_WIDTH_PX    = 8
lamp_hanger2_HEIGHT_PX   = 8
lamp_hanger2_BIT_PER_PX  = 2
lamp_hanger2_INDEX       = 122
lamp_hanger2_NUM_FRAMES  = 1
lamp_hanger2:
             !BYTE $40, $40, $50, $50, $50, $54, $08, $08

; ==================== Sprite 124 ========================
; Sprite ID:       sprite_4
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=32; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical
 
sprite_4_WIDTH_PX    = 8
sprite_4_HEIGHT_PX   = 8
sprite_4_BIT_PER_PX  = 2
sprite_4_INDEX       = 123
sprite_4_NUM_FRAMES  = 1
sprite_4:
         !BYTE $00, $00, $00, $00, $aa, $aa, $aa, $aa

; ==================== Sprite 125 ========================
; Sprite ID:       sprite_5
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=0; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_5_WIDTH_PX    = 8
sprite_5_HEIGHT_PX   = 8
sprite_5_BIT_PER_PX  = 2
sprite_5_INDEX       = 124
sprite_5_NUM_FRAMES  = 1
sprite_5:
         !BYTE $aa, $aa, $2a, $2a, $2a, $2a, $02, $02

; ==================== Sprite 126 ========================
; Sprite ID:       sprite_15
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=8; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_15_WIDTH_PX    = 8
sprite_15_HEIGHT_PX   = 8
sprite_15_BIT_PER_PX  = 2
sprite_15_INDEX       = 125
sprite_15_NUM_FRAMES  = 1
sprite_15:
          !BYTE $82, $82, $aa, $aa, $82, $82, $aa, $aa

; ==================== Sprite 127 ========================
; Sprite ID:       sprite_16
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=32; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_16_WIDTH_PX    = 8
sprite_16_HEIGHT_PX   = 8
sprite_16_BIT_PER_PX  = 2
sprite_16_INDEX       = 126
sprite_16_NUM_FRAMES  = 1
sprite_16:
          !BYTE $aa, $aa, $a8, $a8, $a8, $a8, $80, $80

; ==================== Sprite 128 ========================
; Sprite ID:       sprite_55
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=104; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_55_WIDTH_PX    = 8
sprite_55_HEIGHT_PX   = 8
sprite_55_BIT_PER_PX  = 2
sprite_55_INDEX       = 127
sprite_55_NUM_FRAMES  = 1
sprite_55:
          !BYTE $00, $00, $00, $00, $82, $82, $aa, $aa

; ==================== Sprite 129 ========================
; Sprite ID:       sprite_57
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=64; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_57_WIDTH_PX    = 8
sprite_57_HEIGHT_PX   = 8
sprite_57_BIT_PER_PX  = 2
sprite_57_INDEX       = 128
sprite_57_NUM_FRAMES  = 1
sprite_57:
          !BYTE $aa, $aa, $2a, $2a, $02, $02, $00, $00

; ==================== Sprite 130 ========================
; Sprite ID:       sprite_58
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=128; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_58_WIDTH_PX    = 8
sprite_58_HEIGHT_PX   = 8
sprite_58_BIT_PER_PX  = 2
sprite_58_INDEX       = 129
sprite_58_NUM_FRAMES  = 1
sprite_58:
          !BYTE $aa, $aa, $a8, $a8, $80, $80, $00, $00

; ==================== Sprite 131 ========================
; Sprite ID:       sprite_59
; Sprite Comments: Captured from Screenshot (4.png)
;                  PosX=72; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_59_WIDTH_PX    = 8
sprite_59_HEIGHT_PX   = 8
sprite_59_BIT_PER_PX  = 2
sprite_59_INDEX       = 130
sprite_59_NUM_FRAMES  = 1
sprite_59:
          !BYTE $08, $08, $88, $88, $a8, $a8, $fb, $fb

; ==================== Sprite 132 ========================
; Sprite ID:       wall_bottom_1_no_wall
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=0; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_bottom_1_no_wall_WIDTH_PX    = 8
wall_bottom_1_no_wall_HEIGHT_PX   = 8
wall_bottom_1_no_wall_BIT_PER_PX  = 2
wall_bottom_1_no_wall_INDEX       = 131
wall_bottom_1_no_wall_NUM_FRAMES  = 1
wall_bottom_1_no_wall:
                      !BYTE $00, $00, $00, $00, $00, $00, $88, $88

; ==================== Sprite 133 ========================
; Sprite ID:       wall_bottom_1
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=8; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_bottom_1_WIDTH_PX    = 8
wall_bottom_1_HEIGHT_PX   = 8
wall_bottom_1_BIT_PER_PX  = 2
wall_bottom_1_INDEX       = 132
wall_bottom_1_NUM_FRAMES  = 1
wall_bottom_1:
              !BYTE $51, $51, $45, $45, $51, $51, $dd, $dd

; ==================== Sprite 134 ========================
; Sprite ID:       sprite_62
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=48; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_62_WIDTH_PX    = 8
sprite_62_HEIGHT_PX   = 8
sprite_62_BIT_PER_PX  = 2
sprite_62_INDEX       = 133
sprite_62_NUM_FRAMES  = 1
sprite_62:
          !BYTE $00, $00, $00, $00, $03, $03, $3c, $3c

; ==================== Sprite 135 ========================
; Sprite ID:       sprite_63
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=88; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_63_WIDTH_PX    = 8
sprite_63_HEIGHT_PX   = 8
sprite_63_BIT_PER_PX  = 2
sprite_63_INDEX       = 134
sprite_63_NUM_FRAMES  = 1
sprite_63:
          !BYTE $00, $00, $00, $00, $c0, $c0, $3c, $3c

; ==================== Sprite 136 ========================
; Sprite ID:       sprite_64
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=48; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_64_WIDTH_PX    = 8
sprite_64_HEIGHT_PX   = 8
sprite_64_BIT_PER_PX  = 2
sprite_64_INDEX       = 135
sprite_64_NUM_FRAMES  = 1
sprite_64:
          !BYTE $f0, $f0, $ff, $ff, $f0, $f0, $0c, $0c

; ==================== Sprite 137 ========================
; Sprite ID:       sprite_65
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=88; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_65_WIDTH_PX    = 8
sprite_65_HEIGHT_PX   = 8
sprite_65_BIT_PER_PX  = 2
sprite_65_INDEX       = 136
sprite_65_NUM_FRAMES  = 1
sprite_65:
          !BYTE $0f, $0f, $ff, $ff, $0f, $0f, $30, $30

; ==================== Sprite 138 ========================
; Sprite ID:       sprite_66
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=8; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_66_WIDTH_PX    = 8
sprite_66_HEIGHT_PX   = 8
sprite_66_BIT_PER_PX  = 2
sprite_66_INDEX       = 137
sprite_66_NUM_FRAMES  = 1
sprite_66:
          !BYTE $51, $51, $45, $45, $55, $55, $00, $00

; ==================== Sprite 139 ========================
; Sprite ID:       sprite_67
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=48; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_67_WIDTH_PX    = 8
sprite_67_HEIGHT_PX   = 8
sprite_67_BIT_PER_PX  = 2
sprite_67_INDEX       = 138
sprite_67_NUM_FRAMES  = 1
sprite_67:
          !BYTE $45, $45, $04, $04, $10, $10, $00, $00

; ==================== Sprite 140 ========================
; Sprite ID:       conveyor1
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=272; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor1_WIDTH_PX    = 8
conveyor1_HEIGHT_PX   = 8
conveyor1_BIT_PER_PX  = 2
conveyor1_INDEX       = 139
conveyor1_NUM_FRAMES  = 1
conveyor1:
          !BYTE $03, $03, $33, $33, $0c, $0c, $c3, $c3

; ==================== Sprite 141 ========================
; Sprite ID:       conveyor4
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=272; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor4_WIDTH_PX    = 8
conveyor4_HEIGHT_PX   = 8
conveyor4_BIT_PER_PX  = 2
conveyor4_INDEX       = 140
conveyor4_NUM_FRAMES  = 1
conveyor4:
          !BYTE $0c, $0c, $33, $33, $03, $03, $cc, $cc

; ==================== Sprite 142 ========================
; Sprite ID:       conveyor2
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=280; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor2_WIDTH_PX    = 8
conveyor2_HEIGHT_PX   = 8
conveyor2_BIT_PER_PX  = 2
conveyor2_INDEX       = 141
conveyor2_NUM_FRAMES  = 1
conveyor2:
          !BYTE $3c, $3c, $ff, $ff, $f3, $f3, $3f, $3f

; ==================== Sprite 143 ========================
; Sprite ID:       conveyor5
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=280; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor5_WIDTH_PX    = 8
conveyor5_HEIGHT_PX   = 8
conveyor5_BIT_PER_PX  = 2
conveyor5_INDEX       = 142
conveyor5_NUM_FRAMES  = 1
conveyor5:
          !BYTE $cc, $cc, $ff, $ff, $33, $33, $ff, $ff

; ==================== Sprite 144 ========================
; Sprite ID:       conveyor3
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=288; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor3_WIDTH_PX    = 8
conveyor3_HEIGHT_PX   = 8
conveyor3_BIT_PER_PX  = 2
conveyor3_INDEX       = 143
conveyor3_NUM_FRAMES  = 1
conveyor3:
          !BYTE $c0, $c0, $cc, $cc, $30, $30, $c3, $c3

; ==================== Sprite 145 ========================
; Sprite ID:       conveyor6
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=288; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

conveyor6_WIDTH_PX    = 8
conveyor6_HEIGHT_PX   = 8
conveyor6_BIT_PER_PX  = 2
conveyor6_INDEX       = 144
conveyor6_NUM_FRAMES  = 1
conveyor6:
          !BYTE $30, $30, $cc, $cc, $c0, $c0, $33, $33

; ==================== Sprite 146 ========================
; Sprite ID:       wall_bottom_2_no_wall
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=0; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_bottom_2_no_wall_WIDTH_PX    = 8
wall_bottom_2_no_wall_HEIGHT_PX   = 8
wall_bottom_2_no_wall_BIT_PER_PX  = 2
wall_bottom_2_no_wall_INDEX       = 145
wall_bottom_2_no_wall_NUM_FRAMES  = 1
wall_bottom_2_no_wall:
                      !BYTE $ff, $ff, $cc, $cc, $ff, $ff, $33, $33

; ==================== Sprite 147 ========================
; Sprite ID:       wall_bottom_2
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=8; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_bottom_2_WIDTH_PX    = 8
wall_bottom_2_HEIGHT_PX   = 8
wall_bottom_2_BIT_PER_PX  = 2
wall_bottom_2_INDEX       = 146
wall_bottom_2_NUM_FRAMES  = 1
wall_bottom_2:
              !BYTE $ff, $ff, $dd, $dd, $ff, $ff, $33, $33

; ==================== Sprite 148 ========================
; Sprite ID:       platform_top1
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=0; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

platform_top1_WIDTH_PX    = 8
platform_top1_HEIGHT_PX   = 8
platform_top1_BIT_PER_PX  = 2
platform_top1_INDEX       = 147
platform_top1_NUM_FRAMES  = 1
platform_top1:
              !BYTE $00, $00, $00, $00, $00, $00, $cc, $cc

; ==================== Sprite 149 ========================
; Sprite ID:       sprite_54
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=104; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_54_WIDTH_PX    = 8
sprite_54_HEIGHT_PX   = 8
sprite_54_BIT_PER_PX  = 2
sprite_54_INDEX       = 148
sprite_54_NUM_FRAMES  = 1
sprite_54:
          !BYTE $ff, $ff, $ff, $ff, $aa, $aa, $55, $55

; ==================== Sprite 150 ========================
; Sprite ID:       sprite_56
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=32; PosY=64
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_56_WIDTH_PX    = 8
sprite_56_HEIGHT_PX   = 8
sprite_56_BIT_PER_PX  = 2
sprite_56_INDEX       = 149
sprite_56_NUM_FRAMES  = 1
sprite_56:
          !BYTE $00, $00, $00, $00, $00, $00, $aa, $aa

; ==================== Sprite 151 ========================
; Sprite ID:       sprite_70
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=32; PosY=72
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_70_WIDTH_PX    = 8
sprite_70_HEIGHT_PX   = 8
sprite_70_BIT_PER_PX  = 2
sprite_70_INDEX       = 150
sprite_70_NUM_FRAMES  = 1
sprite_70:
          !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $55, $55

; ==================== Sprite 152 ========================
; Sprite ID:       sprite_60
; Sprite Comments: Captured from Screenshot (5_2.png)
;                  PosX=272; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      Vertical

sprite_60_WIDTH_PX    = 8
sprite_60_HEIGHT_PX   = 8
sprite_60_BIT_PER_PX  = 2
sprite_60_INDEX       = 151
sprite_60_NUM_FRAMES  = 1
sprite_60:
          !BYTE $3f, $3f, $2a, $2a, $08, $08, $08, $08

; ==================== Sprite 153 ========================
; Sprite ID:       laser_beam
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313372112.png)
;                  PosX=52; PosY=116
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

laser_beam_WIDTH_PX    = 8
laser_beam_HEIGHT_PX   = 8
laser_beam_BIT_PER_PX  = 2
laser_beam_INDEX       = 152
laser_beam_NUM_FRAMES  = 1
laser_beam:
           !BYTE $00, $ee, $ee, $00, $00, $ee, $ee, $00

; ==================== Sprite 154 ========================
; Sprite ID:       laser_beam_first_half
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313372112.png)
;                  PosX=52; PosY=116
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

laser_beam_first_half_WIDTH_PX    = 8
laser_beam_first_half_HEIGHT_PX   = 8
laser_beam_first_half_BIT_PER_PX  = 2
laser_beam_first_half_INDEX       = 153
laser_beam_first_half_NUM_FRAMES  = 1
laser_beam_first_half:
                      !BYTE $00, $0e, $0e, $00, $00, $0e, $0e, $00

; ==================== Sprite 155 ========================
; Sprite ID:       laser_beam_second_half
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313372112.png)
;                  PosX=52; PosY=116
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

laser_beam_second_half_WIDTH_PX    = 8
laser_beam_second_half_HEIGHT_PX   = 8
laser_beam_second_half_BIT_PER_PX  = 2
laser_beam_second_half_INDEX       = 154
laser_beam_second_half_NUM_FRAMES  = 1
laser_beam_second_half:
                       !BYTE $00, $e0, $e0, $00, $00, $e0, $e0, $00

; ==================== Sprite 156 ========================
; Sprite ID:       rocket1
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=252; PosY=187
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket1_WIDTH_PX    = 8
rocket1_HEIGHT_PX   = 8
rocket1_BIT_PER_PX  = 2
rocket1_INDEX       = 155
rocket1_NUM_FRAMES  = 1
rocket1:
        !BYTE $00, $00, $00, $00, $0c, $0c, $00, $00

; ==================== Sprite 157 ========================
; Sprite ID:       rocket2
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=260; PosY=187
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket2_WIDTH_PX    = 8
rocket2_HEIGHT_PX   = 8
rocket2_BIT_PER_PX  = 2
rocket2_INDEX       = 156
rocket2_NUM_FRAMES  = 1
rocket2:
        !BYTE $00, $00, $02, $02, $a8, $a8, $c2, $c2
;             ECE6 : C2 C2             

; ==================== Sprite 158 ========================
; Sprite ID:       rocket3
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=252; PosY=195
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket3_WIDTH_PX    = 8
rocket3_HEIGHT_PX   = 8
rocket3_BIT_PER_PX  = 2
rocket3_INDEX       = 157
rocket3_NUM_FRAMES  = 1
rocket3:
        !BYTE $0b, $0b, $00, $00, $0c, $0c, $00, $00

; ==================== Sprite 159 ========================
; Sprite ID:       rocket4
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=260; PosY=195
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket4_WIDTH_PX    = 8
rocket4_HEIGHT_PX   = 8
rocket4_BIT_PER_PX  = 2
rocket4_INDEX       = 158
rocket4_NUM_FRAMES  = 1
rocket4:
        !BYTE $80, $80, $c2, $c2, $a8, $a8, $02, $02

; ==================== Sprite 160 ========================
; Sprite ID:       rocket1_1
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=252; PosY=187
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket1_1_WIDTH_PX    = 8
rocket1_1_HEIGHT_PX   = 8
rocket1_1_BIT_PER_PX  = 2
rocket1_1_INDEX       = 159
rocket1_1_NUM_FRAMES  = 1
rocket1_1:
          !BYTE $00, $00, $00, $00, $ca, $ca, $0c, $0c

; ==================== Sprite 161 ========================
; Sprite ID:       rocket2_1
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=260; PosY=187
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket2_1_WIDTH_PX    = 8
rocket2_1_HEIGHT_PX   = 8
rocket2_1_BIT_PER_PX  = 2
rocket2_1_INDEX       = 160
rocket2_1_NUM_FRAMES  = 1
rocket2_1:
          !BYTE $00, $00, $20, $20, $80, $80, $20, $20

; ==================== Sprite 162 ========================
; Sprite ID:       rocket3_1
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=252; PosY=195
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket3_1_WIDTH_PX    = 8
rocket3_1_HEIGHT_PX   = 8
rocket3_1_BIT_PER_PX  = 2
rocket3_1_INDEX       = 161
rocket3_1_NUM_FRAMES  = 1
rocket3_1:
          !BYTE $b8, $b8, $0c, $0c, $ca, $ca, $00, $00

; ==================== Sprite 163 ========================
; Sprite ID:       rocket4_1
; Sprite Comments: Captured from Screenshot (vice-screen-2022031313361157.png)
;                  PosX=260; PosY=195
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

rocket4_1_WIDTH_PX    = 8
rocket4_1_HEIGHT_PX   = 8
rocket4_1_BIT_PER_PX  = 2
rocket4_1_INDEX       = 162
rocket4_1_NUM_FRAMES  = 1
rocket4_1:
          !BYTE $00, $00, $20, $20, $80, $80, $20, $20

; ==================== Sprite 164 ========================
; Sprite ID:       sprite_14
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=0; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_14_WIDTH_PX    = 8
sprite_14_HEIGHT_PX   = 8
sprite_14_BIT_PER_PX  = 2
sprite_14_INDEX       = 163
sprite_14_NUM_FRAMES  = 1
sprite_14:
          !BYTE $55, $55, $14, $14, $55, $55, $51, $51

; ==================== Sprite 165 ========================
; Sprite ID:       sprite_61
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=0; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_61_WIDTH_PX    = 8
sprite_61_HEIGHT_PX   = 8
sprite_61_BIT_PER_PX  = 2
sprite_61_INDEX       = 164
sprite_61_NUM_FRAMES  = 1
sprite_61:
          !BYTE $15, $15, $44, $44, $55, $55, $11, $11

; ==================== Sprite 166 ========================
; Sprite ID:       black_wall1
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=8; PosY=184
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

black_wall1_WIDTH_PX    = 8
black_wall1_HEIGHT_PX   = 8
black_wall1_BIT_PER_PX  = 2
black_wall1_INDEX       = 165
black_wall1_NUM_FRAMES  = 1
black_wall1:
            !BYTE $01, $01, $44, $44, $10, $10, $44, $44

; ==================== Sprite 167 ========================
; Sprite ID:       black_wall2
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=8; PosY=176
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

black_wall2_WIDTH_PX    = 8
black_wall2_HEIGHT_PX   = 8
black_wall2_BIT_PER_PX  = 2
black_wall2_INDEX       = 166
black_wall2_NUM_FRAMES  = 1
black_wall2:
            !BYTE $11, $11, $44, $44, $10, $10, $44, $44

; ==================== Sprite 168 ========================
; Sprite ID:       ladder2
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=16; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ladder2_WIDTH_PX    = 8
ladder2_HEIGHT_PX   = 8
ladder2_BIT_PER_PX  = 2
ladder2_INDEX       = 167
ladder2_NUM_FRAMES  = 1
ladder2:
        !BYTE $fa, $fa, $fa, $fa, $fb, $fb, $ff, $ff

; ==================== Sprite 169 ========================
; Sprite ID:       sprite_68
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=48; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_68_WIDTH_PX    = 8
sprite_68_HEIGHT_PX   = 8
sprite_68_BIT_PER_PX  = 2
sprite_68_INDEX       = 168
sprite_68_NUM_FRAMES  = 1
sprite_68:
          !BYTE $01, $01, $01, $01, $11, $11, $11, $11

; ==================== Sprite 170 ========================
; Sprite ID:       sprite_69
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=48; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_69_WIDTH_PX    = 8
sprite_69_HEIGHT_PX   = 8
sprite_69_BIT_PER_PX  = 2
sprite_69_INDEX       = 169
sprite_69_NUM_FRAMES  = 1
sprite_69:
          !BYTE $15, $15, $01, $01, $01, $01, $01, $01

; ==================== Sprite 171 ========================
; Sprite ID:       sprite_71
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=240; PosY=112
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_71_WIDTH_PX    = 8
sprite_71_HEIGHT_PX   = 8
sprite_71_BIT_PER_PX  = 2
sprite_71_INDEX       = 170
sprite_71_NUM_FRAMES  = 1
sprite_71:
          !BYTE $40, $40, $40, $40, $44, $44, $44, $44

; ==================== Sprite 172 ========================
; Sprite ID:       sprite_72
; Sprite Comments: Captured from Screenshot (6.png)
;                  PosX=240; PosY=120
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_72_WIDTH_PX    = 8
sprite_72_HEIGHT_PX   = 8
sprite_72_BIT_PER_PX  = 2
sprite_72_INDEX       = 171
sprite_72_NUM_FRAMES  = 1
sprite_72:
          !BYTE $54, $54, $40, $40, $40, $40, $40, $40

; ==================== Sprite 173 ========================
; Sprite ID:       bad_lamp
; Sprite Comments: Captured from Screenshot (7_2.png)
;                  PosX=224; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bad_lamp_WIDTH_PX    = 8
bad_lamp_HEIGHT_PX   = 8
bad_lamp_BIT_PER_PX  = 2
bad_lamp_INDEX       = 172
bad_lamp_NUM_FRAMES  = 1
bad_lamp:
         !BYTE $15, $15, $2e, $2e, $15, $15, $04, $04

; ==================== Sprite 174 ========================
; Sprite ID:       bad_lamp_hanger
; Sprite Comments: Captured from Screenshot (7_2.png)
;                  PosX=224; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bad_lamp_hanger_WIDTH_PX    = 8
bad_lamp_hanger_HEIGHT_PX   = 8
bad_lamp_hanger_BIT_PER_PX  = 2
bad_lamp_hanger_INDEX       = 173
bad_lamp_hanger_NUM_FRAMES  = 1
bad_lamp_hanger:
                !BYTE $01, $01, $05, $05, $05, $05, $04, $04

; ==================== Sprite 175 ========================
; Sprite ID:       bad_lamp_shifted
; Sprite Comments: Captured from Screenshot (7_2.png)
;                  PosX=224; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bad_lamp_shifted_WIDTH_PX    = 8
bad_lamp_shifted_HEIGHT_PX   = 8
bad_lamp_shifted_BIT_PER_PX  = 2
bad_lamp_shifted_INDEX       = 174
bad_lamp_shifted_NUM_FRAMES  = 1
bad_lamp_shifted:
                 !BYTE $54, $54, $b8, $b8, $54, $54, $10, $10

; ==================== Sprite 176 ========================
; Sprite ID:       bad_lamp_hanger_shifted
; Sprite Comments: Captured from Screenshot (7_2.png)
;                  PosX=224; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bad_lamp_hanger_shifted_WIDTH_PX    = 8
bad_lamp_hanger_shifted_HEIGHT_PX   = 8
bad_lamp_hanger_shifted_BIT_PER_PX  = 2
bad_lamp_hanger_shifted_INDEX       = 175
bad_lamp_hanger_shifted_NUM_FRAMES  = 1
bad_lamp_hanger_shifted:
                        !BYTE $40, $40, $50, $50, $50, $50, $10, $10

; ==================== Sprite 177 ========================
; Sprite ID:       zapper
; Sprite Comments: Captured from Screenshot (8.png)
;                  PosX=40; PosY=168
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

zapper_WIDTH_PX    = 8
zapper_HEIGHT_PX   = 8
zapper_BIT_PER_PX  = 2
zapper_INDEX       = 176
zapper_NUM_FRAMES  = 1
zapper:
       !BYTE $cc, $cc, $cc, $cc, $cc, $cc, $ff, $ff

; ==================== Sprite 178 ========================
; Sprite ID:       zapper_beam
; Sprite Comments: Captured from Screenshot (8.png)
;                  PosX=160; PosY=160
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

zapper_beam_WIDTH_PX    = 8
zapper_beam_HEIGHT_PX   = 8
zapper_beam_BIT_PER_PX  = 2
zapper_beam_INDEX       = 177
zapper_beam_NUM_FRAMES  = 1
zapper_beam:
            !BYTE $00, $00, $00, $00, $00, $00, $88, $88

; ==================== Sprite 179 ========================
; Sprite ID:       sprite_13
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=48; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_13_WIDTH_PX    = 8
sprite_13_HEIGHT_PX   = 8
sprite_13_BIT_PER_PX  = 2
sprite_13_INDEX       = 178
sprite_13_NUM_FRAMES  = 1
sprite_13:
          !BYTE $00, $00, $00, $00, $02, $02, $00, $00

; ==================== Sprite 180 ========================
; Sprite ID:       sprite_30
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=56; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_30_WIDTH_PX    = 8
sprite_30_HEIGHT_PX   = 8
sprite_30_BIT_PER_PX  = 2
sprite_30_INDEX       = 179
sprite_30_NUM_FRAMES  = 1
sprite_30:
          !BYTE $00, $00, $20, $20, $20, $20, $82, $82
;             ED9E : 82 82             

; ==================== Sprite 181 ========================
; Sprite ID:       sprite_73
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=48; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_73_WIDTH_PX    = 8
sprite_73_HEIGHT_PX   = 8
sprite_73_BIT_PER_PX  = 2
sprite_73_INDEX       = 180
sprite_73_NUM_FRAMES  = 1
sprite_73:
          !BYTE $20, $20, $08, $08, $02, $02, $00, $00

; ==================== Sprite 182 ========================
; Sprite ID:       sprite_74
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=56; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_74_WIDTH_PX    = 8
sprite_74_HEIGHT_PX   = 8
sprite_74_BIT_PER_PX  = 2
sprite_74_INDEX       = 181
sprite_74_NUM_FRAMES  = 1
sprite_74:
          !BYTE $88, $88, $88, $88, $ac, $ac, $2e, $2e

; ==================== Sprite 183 ========================
; Sprite ID:       sprite_75
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=64; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_75_WIDTH_PX    = 8
sprite_75_HEIGHT_PX   = 8
sprite_75_BIT_PER_PX  = 2
sprite_75_INDEX       = 182
sprite_75_NUM_FRAMES  = 1
sprite_75:
          !BYTE $20, $20, $28, $28, $80, $80, $00, $00

; ==================== Sprite 184 ========================
; Sprite ID:       sprite_77
; Sprite Comments: Captured from Screenshot (bokor1.png)
;                  PosX=56; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_77_WIDTH_PX    = 8
sprite_77_HEIGHT_PX   = 8
sprite_77_BIT_PER_PX  = 2
sprite_77_INDEX       = 183
sprite_77_NUM_FRAMES  = 1
sprite_77:
          !BYTE $ba, $ba, $fb, $fb, $ba, $ba, $14, $14

; ==================== Sprite 185 ========================
; Sprite ID:       sprite_78
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=48; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_78_WIDTH_PX    = 8
sprite_78_HEIGHT_PX   = 8
sprite_78_BIT_PER_PX  = 2
sprite_78_INDEX       = 184
sprite_78_NUM_FRAMES  = 1
sprite_78:
          !BYTE $00, $00, $00, $00, $08, $08, $02, $02

; ==================== Sprite 186 ========================
; Sprite ID:       sprite_79
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=56; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_79_WIDTH_PX    = 8
sprite_79_HEIGHT_PX   = 8
sprite_79_BIT_PER_PX  = 2
sprite_79_INDEX       = 185
sprite_79_NUM_FRAMES  = 1
sprite_79:
          !BYTE $22, $22, $08, $08, $08, $08, $22, $22

; ==================== Sprite 187 ========================
; Sprite ID:       sprite_80
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=64; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_80_WIDTH_PX    = 8
sprite_80_HEIGHT_PX   = 8
sprite_80_BIT_PER_PX  = 2
sprite_80_INDEX       = 186
sprite_80_NUM_FRAMES  = 1
sprite_80:
          !BYTE $00, $00, $00, $00, $20, $20, $28, $28

; ==================== Sprite 188 ========================
; Sprite ID:       sprite_81
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=48; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_81_WIDTH_PX    = 8
sprite_81_HEIGHT_PX   = 8
sprite_81_BIT_PER_PX  = 2
sprite_81_INDEX       = 187
sprite_81_NUM_FRAMES  = 1
sprite_81:
          !BYTE $00, $00, $00, $00, $22, $22, $20, $20

; ==================== Sprite 189 ========================
; Sprite ID:       sprite_82
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=56; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_82_WIDTH_PX    = 8
sprite_82_HEIGHT_PX   = 8
sprite_82_BIT_PER_PX  = 2
sprite_82_INDEX       = 188
sprite_82_NUM_FRAMES  = 1
sprite_82:
          !BYTE $a8, $a8, $20, $20, $20, $20, $82, $82

; ==================== Sprite 190 ========================
; Sprite ID:       sprite_83
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=64; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_83_WIDTH_PX    = 8
sprite_83_HEIGHT_PX   = 8
sprite_83_BIT_PER_PX  = 2
sprite_83_INDEX       = 189
sprite_83_NUM_FRAMES  = 1
sprite_83:
          !BYTE $80, $80, $80, $80, $88, $88, $00, $00

; ==================== Sprite 191 ========================
; Sprite ID:       sprite_84
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=48; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_84_WIDTH_PX    = 8
sprite_84_HEIGHT_PX   = 8
sprite_84_BIT_PER_PX  = 2
sprite_84_INDEX       = 190
sprite_84_NUM_FRAMES  = 1
sprite_84:
          !BYTE $08, $08, $82, $82, $22, $22, $0a, $0a

; ==================== Sprite 192 ========================
; Sprite ID:       sprite_85
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=56; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_85_WIDTH_PX    = 8
sprite_85_HEIGHT_PX   = 8
sprite_85_BIT_PER_PX  = 2
sprite_85_INDEX       = 191
sprite_85_NUM_FRAMES  = 1
sprite_85:
          !BYTE $28, $28, $20, $20, $ac, $ac, $ee, $ee

; ==================== Sprite 193 ========================
; Sprite ID:       first_sprite_192
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=64; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

first_sprite_192_WIDTH_PX    = 8
first_sprite_192_HEIGHT_PX   = 8
first_sprite_192_BIT_PER_PX  = 2
first_sprite_192_INDEX       = 192
first_sprite_192_NUM_FRAMES  = 1
first_sprite_192:
                 !BYTE $22, $22, $28, $28, $80, $80, $ea, $ea

; ==================== Sprite 194 ========================
; Sprite ID:       c73_sprite_87
; Sprite Comments: Captured from Screenshot (bokor2.png)
;                  PosX=56; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

c73_sprite_87_WIDTH_PX    = 8
c73_sprite_87_HEIGHT_PX   = 8
c73_sprite_87_BIT_PER_PX  = 2
c73_sprite_87_INDEX       = 193
c73_sprite_87_NUM_FRAMES  = 1
c73_sprite_87:
              !BYTE $ba, $ba, $fb, $fb, $ea, $ea, $88, $88

; ==================== Sprite 195 ========================
; Sprite ID:       bush_root_top
; Sprite Comments: Captured from Screenshot (8.png)
;                  PosX=56; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bush_root_top_WIDTH_PX    = 8
bush_root_top_HEIGHT_PX   = 8
bush_root_top_BIT_PER_PX  = 2
bush_root_top_INDEX       = 194
bush_root_top_NUM_FRAMES  = 1
bush_root_top:
              !BYTE $00, $00, $00, $00, $20, $20, $22, $22

; ==================== Sprite 196 ========================
; Sprite ID:       bush_root_bottom
; Sprite Comments: Captured from Screenshot (8.png)
;                  PosX=56; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bush_root_bottom_WIDTH_PX    = 8
bush_root_bottom_HEIGHT_PX   = 8
bush_root_bottom_BIT_PER_PX  = 2
bush_root_bottom_INDEX       = 195
bush_root_bottom_NUM_FRAMES  = 1
bush_root_bottom:
                 !BYTE $2a, $2a, $ff, $ff, $aa, $aa, $14, $14

; ==================== Sprite 197 ========================
; Sprite ID:       wall_conveyor1
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=272; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor1_WIDTH_PX    = 8
wall_conveyor1_HEIGHT_PX   = 8
wall_conveyor1_BIT_PER_PX  = 2
wall_conveyor1_INDEX       = 196
wall_conveyor1_NUM_FRAMES  = 1
wall_conveyor1:
               !BYTE $01, $01, $11, $11, $04, $04, $41, $41

; ==================== Sprite 198 ========================
; Sprite ID:       wall_conveyor4
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=272; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor4_WIDTH_PX    = 8
wall_conveyor4_HEIGHT_PX   = 8
wall_conveyor4_BIT_PER_PX  = 2
wall_conveyor4_INDEX       = 197
wall_conveyor4_NUM_FRAMES  = 1
wall_conveyor4:
               !BYTE $04, $04, $11, $11, $01, $01, $44, $44

; ==================== Sprite 199 ========================
; Sprite ID:       wall_conveyor2
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=280; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor2_WIDTH_PX    = 8
wall_conveyor2_HEIGHT_PX   = 8
wall_conveyor2_BIT_PER_PX  = 2
wall_conveyor2_INDEX       = 198
wall_conveyor2_NUM_FRAMES  = 1
wall_conveyor2:
               !BYTE $14, $14, $55, $55, $51, $51, $15, $15

; ==================== Sprite 200 ========================
; Sprite ID:       wall_conveyor5
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=280; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor5_WIDTH_PX    = 8
wall_conveyor5_HEIGHT_PX   = 8
wall_conveyor5_BIT_PER_PX  = 2
wall_conveyor5_INDEX       = 199
wall_conveyor5_NUM_FRAMES  = 1
wall_conveyor5:
               !BYTE $44, $44, $55, $55, $11, $11, $55, $55

; ==================== Sprite 201 ========================
; Sprite ID:       wall_conveyor3
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=288; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor3_WIDTH_PX    = 8
wall_conveyor3_HEIGHT_PX   = 8
wall_conveyor3_BIT_PER_PX  = 2
wall_conveyor3_INDEX       = 200
wall_conveyor3_NUM_FRAMES  = 1
wall_conveyor3:
               !BYTE $40, $40, $44, $44, $10, $10, $41, $41
;             EE46 : 41 41             

; ==================== Sprite 202 ========================
; Sprite ID:       wall_conveyor6
; Sprite Comments: Captured from Screenshot (5.png)
;                  PosX=288; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

wall_conveyor6_WIDTH_PX    = 8
wall_conveyor6_HEIGHT_PX   = 8
wall_conveyor6_BIT_PER_PX  = 2
wall_conveyor6_INDEX       = 201
wall_conveyor6_NUM_FRAMES  = 1
wall_conveyor6:
               !BYTE $10, $10, $44, $44, $40, $40, $11, $11

; ==================== Sprite 203 ========================
; Sprite ID:       yinyang1
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=40; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

yinyang1_WIDTH_PX    = 8
yinyang1_HEIGHT_PX   = 8
yinyang1_BIT_PER_PX  = 2
yinyang1_INDEX       = 202
yinyang1_NUM_FRAMES  = 1
yinyang1:
         !BYTE $03, $03, $3e, $3e, $fa, $fa, $fe, $fe

; ==================== Sprite 204 ========================
; Sprite ID:       yinyang2
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=48; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

yinyang2_WIDTH_PX    = 8
yinyang2_HEIGHT_PX   = 8
yinyang2_BIT_PER_PX  = 2
yinyang2_INDEX       = 203
yinyang2_NUM_FRAMES  = 1
yinyang2:
         !BYTE $80, $80, $a8, $a8, $fa, $fa, $aa, $aa

; ==================== Sprite 205 ========================
; Sprite ID:       yinyang3
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=40; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

yinyang3_WIDTH_PX    = 8
yinyang3_HEIGHT_PX   = 8
yinyang3_BIT_PER_PX  = 2
yinyang3_INDEX       = 204
yinyang3_NUM_FRAMES  = 1
yinyang3:
         !BYTE $ff, $ff, $fa, $fa, $3f, $3f, $03, $03

; ==================== Sprite 206 ========================
; Sprite ID:       yinyang4
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=48; PosY=40
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

yinyang4_WIDTH_PX    = 8
yinyang4_HEIGHT_PX   = 8
yinyang4_BIT_PER_PX  = 2
yinyang4_INDEX       = 205
yinyang4_NUM_FRAMES  = 1
yinyang4:
         !BYTE $ea, $ea, $fa, $fa, $e8, $e8, $80, $80

; ==================== Sprite 207 ========================
; Sprite ID:       sprite_90
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=72; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_90_WIDTH_PX    = 8
sprite_90_HEIGHT_PX   = 8
sprite_90_BIT_PER_PX  = 2
sprite_90_INDEX       = 206
sprite_90_NUM_FRAMES  = 1
sprite_90:
          !BYTE $80, $80, $80, $80, $80, $80, $80, $80

; ==================== Sprite 208 ========================
; Sprite ID:       sprite_91
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=80; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_91_WIDTH_PX    = 8
sprite_91_HEIGHT_PX   = 8
sprite_91_BIT_PER_PX  = 2
sprite_91_INDEX       = 207
sprite_91_NUM_FRAMES  = 1
sprite_91:
          !BYTE $02, $02, $02, $02, $02, $02, $02, $02

; ==================== Sprite 209 ========================
; Sprite ID:       sprite_92
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=72; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_92_WIDTH_PX    = 8
sprite_92_HEIGHT_PX   = 8
sprite_92_BIT_PER_PX  = 2
sprite_92_INDEX       = 208
sprite_92_NUM_FRAMES  = 1
sprite_92:
          !BYTE $80, $80, $80, $80, $80, $80, $aa, $aa

; ==================== Sprite 210 ========================
; Sprite ID:       bull_replacement_start
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=80; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bull_replacement_start_WIDTH_PX    = 8
bull_replacement_start_HEIGHT_PX   = 8
bull_replacement_start_BIT_PER_PX  = 2
bull_replacement_start_INDEX       = 209
bull_replacement_start_NUM_FRAMES  = 1
bull_replacement_start:
                       !BYTE $02, $02, $02, $02, $02, $02, $aa, $aa

; ==================== Sprite 211 ========================
; Sprite ID:       sprite_94
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=120; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_94_WIDTH_PX    = 8
sprite_94_HEIGHT_PX   = 8
sprite_94_BIT_PER_PX  = 2
sprite_94_INDEX       = 210
sprite_94_NUM_FRAMES  = 1
sprite_94:
          !BYTE $08, $08, $a8, $a8, $2a, $2a, $20, $20

; ==================== Sprite 212 ========================
; Sprite ID:       underg_lamp_hanger
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=8; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

underg_lamp_hanger_WIDTH_PX    = 8
underg_lamp_hanger_HEIGHT_PX   = 8
underg_lamp_hanger_BIT_PER_PX  = 2
underg_lamp_hanger_INDEX       = 211
underg_lamp_hanger_NUM_FRAMES  = 1
underg_lamp_hanger:
                   !BYTE $00, $00, $00, $00, $0a, $0a, $20, $20

; ==================== Sprite 213 ========================
; Sprite ID:       sprite_96
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=104; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_96_WIDTH_PX    = 8
sprite_96_HEIGHT_PX   = 8
sprite_96_BIT_PER_PX  = 2
sprite_96_INDEX       = 212
sprite_96_NUM_FRAMES  = 1
sprite_96:
          !BYTE $aa, $aa, $eb, $eb, $ff, $ff, $55, $55

; ==================== Sprite 214 ========================
; Sprite ID:       platform2_top
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=120; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

platform2_top_WIDTH_PX    = 8
platform2_top_HEIGHT_PX   = 8
platform2_top_BIT_PER_PX  = 2
platform2_top_INDEX       = 213
platform2_top_NUM_FRAMES  = 1
platform2_top:
              !BYTE $00, $00, $c3, $c3, $ff, $ff, $55, $55

; ==================== Sprite 215 ========================
; Sprite ID:       platform2_bottom
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=64; PosY=88
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

platform2_bottom_WIDTH_PX    = 8
platform2_bottom_HEIGHT_PX   = 8
platform2_bottom_BIT_PER_PX  = 2
platform2_bottom_INDEX       = 214
platform2_bottom_NUM_FRAMES  = 1
platform2_bottom:
                 !BYTE $41, $41, $55, $55, $14, $14, $14, $14

; ==================== Sprite 216 ========================
; Sprite ID:       ladder6
; Sprite Comments: Captured from Screenshot (12.png)
;                  PosX=32; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ladder6_WIDTH_PX    = 8
ladder6_HEIGHT_PX   = 8
ladder6_BIT_PER_PX  = 2
ladder6_INDEX       = 215
ladder6_NUM_FRAMES  = 1
ladder6:
        !BYTE $3c, $3c, $ff, $ff, $c3, $c3, $ff, $ff

; ==================== Sprite 217 ========================
; Sprite ID:       ug_wall1
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=312; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ug_wall1_WIDTH_PX    = 8
ug_wall1_HEIGHT_PX   = 8
ug_wall1_BIT_PER_PX  = 2
ug_wall1_INDEX       = 216
ug_wall1_NUM_FRAMES  = 1
ug_wall1:
         !BYTE $54, $54, $54, $54, $44, $44, $45, $45

; ==================== Sprite 218 ========================
; Sprite ID:       ug_wall2
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=312; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ug_wall2_WIDTH_PX    = 8
ug_wall2_HEIGHT_PX   = 8
ug_wall2_BIT_PER_PX  = 2
ug_wall2_INDEX       = 217
ug_wall2_NUM_FRAMES  = 1
ug_wall2:
         !BYTE $45, $45, $45, $45, $45, $45, $55, $55

; ==================== Sprite 219 ========================
; Sprite ID:       sprite_102
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=216; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_102_WIDTH_PX    = 8
sprite_102_HEIGHT_PX   = 8
sprite_102_BIT_PER_PX  = 2
sprite_102_INDEX       = 218
sprite_102_NUM_FRAMES  = 1
sprite_102:
           !BYTE $20, $20, $2a, $2a, $a8, $a8, $08, $08

; ==================== Sprite 220 ========================
; Sprite ID:       sprite_103
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=120; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_103_WIDTH_PX    = 8
sprite_103_HEIGHT_PX   = 8
sprite_103_BIT_PER_PX  = 2
sprite_103_INDEX       = 219
sprite_103_NUM_FRAMES  = 1
sprite_103:
           !BYTE $a8, $a8, $0a, $0a, $02, $02, $02, $02

; ==================== Sprite 221 ========================
; Sprite ID:       char_12_same_bull_column_placeholder
; Sprite Comments: 
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

char_12_same_bull_column_placeholder_WIDTH_PX    = 8
char_12_same_bull_column_placeholder_HEIGHT_PX   = 8
char_12_same_bull_column_placeholder_BIT_PER_PX  = 2
char_12_same_bull_column_placeholder_INDEX       = 220
char_12_same_bull_column_placeholder_NUM_FRAMES  = 1
char_12_same_bull_column_placeholder:
                                     !BYTE $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa

; ==================== Sprite 222 ========================
; Sprite ID:       sprite_104
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=128; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_104_WIDTH_PX    = 8
sprite_104_HEIGHT_PX   = 8
sprite_104_BIT_PER_PX  = 2
sprite_104_INDEX       = 221
sprite_104_NUM_FRAMES  = 1
sprite_104:
           !BYTE $2a, $2a, $a0, $a0, $80, $80, $80, $80

; ==================== Sprite 223 ========================
; Sprite ID:       bush_root2
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=152; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

bush_root2_WIDTH_PX    = 8
bush_root2_HEIGHT_PX   = 8
bush_root2_BIT_PER_PX  = 2
bush_root2_INDEX       = 222
bush_root2_NUM_FRAMES  = 1
bush_root2:
           !BYTE $82, $82, $eb, $eb, $ff, $ff, $ff, $ff

; ==================== Sprite 224 ========================
; Sprite ID:       ladder_bottom
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=64; PosY=136
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ladder_bottom_WIDTH_PX    = 8
ladder_bottom_HEIGHT_PX   = 8
ladder_bottom_BIT_PER_PX  = 2
ladder_bottom_INDEX       = 223
ladder_bottom_NUM_FRAMES  = 1
ladder_bottom:
              !BYTE $82, $82, $aa, $aa, $28, $28, $28, $28

; ==================== Sprite 225 ========================
; Sprite ID:       ladder_top
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=64; PosY=144
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

ladder_top_WIDTH_PX    = 8


ladder_top_HEIGHT_PX   = 8
ladder_top_BIT_PER_PX  = 2
ladder_top_INDEX       = 224
ladder_top_NUM_FRAMES  = 1
ladder_top:
           !BYTE $aa, $aa, $82, $82, $aa, $aa, $82, $82

; ==================== Sprite 226 ========================
; Sprite ID:       sprite_76
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=120; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_76_WIDTH_PX    = 8
sprite_76_HEIGHT_PX   = 8
sprite_76_BIT_PER_PX  = 2
sprite_76_INDEX       = 225
sprite_76_NUM_FRAMES  = 1
sprite_76:
          !BYTE $02, $02, $02, $02, $00, $00, $00, $00

; ==================== Sprite 227 ========================
; Sprite ID:       sprite_86
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=120; PosY=56
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_86_WIDTH_PX    = 8
sprite_86_HEIGHT_PX   = 8
sprite_86_BIT_PER_PX  = 2
sprite_86_INDEX       = 226
sprite_86_NUM_FRAMES  = 1
sprite_86:
          !BYTE $80, $80, $80, $80, $00, $00, $00, $00

; ==================== Sprite 228 ========================
; Sprite ID:       sprite_88
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=104; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_88_WIDTH_PX    = 8
sprite_88_HEIGHT_PX   = 8
sprite_88_BIT_PER_PX  = 2
sprite_88_INDEX       = 227
sprite_88_NUM_FRAMES  = 1
sprite_88:
          !BYTE $00, $00, $00, $00, $ff, $ff, $aa, $aa

; ==================== Sprite 229 ========================
; Sprite ID:       char20
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=168; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

char20_WIDTH_PX    = 8
char20_HEIGHT_PX   = 8
char20_BIT_PER_PX  = 2
char20_INDEX       = 228
char20_NUM_FRAMES  = 1
char20:
       !BYTE $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; ==================== Sprite 230 ========================
; Sprite ID:       c54_underg_lamp_hanger
; Sprite Comments: Captured from Screenshot (11.png)
;                  PosX=8; PosY=48
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

c54_underg_lamp_hanger_WIDTH_PX    = 8
c54_underg_lamp_hanger_HEIGHT_PX   = 8
c54_underg_lamp_hanger_BIT_PER_PX  = 2
c54_underg_lamp_hanger_INDEX       = 229
c54_underg_lamp_hanger_NUM_FRAMES  = 1
c54_underg_lamp_hanger:
                       !BYTE $00, $00, $00, $00, $a0, $a0, $08, $08

; ==================== Sprite 231 ========================
; Sprite ID:       sprite_19
; Sprite Comments: Captured from Screenshot (12.png)
;                  PosX=48; PosY=80
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_19_WIDTH_PX    = 8
sprite_19_HEIGHT_PX   = 8
sprite_19_BIT_PER_PX  = 2
sprite_19_INDEX       = 230
sprite_19_NUM_FRAMES  = 1
sprite_19:
          !BYTE $14, $14, $55, $55, $41, $41, $55, $55

; ==================== Sprite 232 ========================
; Sprite ID:       sprite_27
; Sprite Comments: Captured from Screenshot (13.png)
;                  PosX=200; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_27_WIDTH_PX    = 8
sprite_27_HEIGHT_PX   = 8
sprite_27_BIT_PER_PX  = 2
sprite_27_INDEX       = 231
sprite_27_NUM_FRAMES  = 1
sprite_27:
          !BYTE $3f, $3f, $b8, $b8, $3f, $3f, $32, $32

; ==================== Sprite 233 ========================
; Sprite ID:       sprite_87
; Sprite Comments: Captured from Screenshot (13.png)
;                  PosX=208; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_87_WIDTH_PX    = 8
sprite_87_HEIGHT_PX   = 8
sprite_87_BIT_PER_PX  = 2
sprite_87_INDEX       = 232
sprite_87_NUM_FRAMES  = 1
sprite_87:
          !BYTE $ff, $ff, $88, $88, $ff, $ff, $22, $22

; ==================== Sprite 234 ========================
; Sprite ID:       sprite_89
; Sprite Comments: Captured from Screenshot (13.png)
;                  PosX=216; PosY=96
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_89_WIDTH_PX    = 8
sprite_89_HEIGHT_PX   = 8
sprite_89_BIT_PER_PX  = 2
sprite_89_INDEX       = 233
sprite_89_NUM_FRAMES  = 1
sprite_89:
          !BYTE $fa, $fa, $ba, $ba, $fa, $fa, $3a, $3a

; ==================== Sprite 235 ========================
; Sprite ID:       sprite_93
; Sprite Comments: Captured from Screenshot (15.png)
;                  PosX=88; PosY=32
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_93_WIDTH_PX    = 8
sprite_93_HEIGHT_PX   = 8
sprite_93_BIT_PER_PX  = 2
sprite_93_INDEX       = 234
sprite_93_NUM_FRAMES  = 1
sprite_93:
          !BYTE $82, $82, $28, $28, $00, $00, $00, $00

; ==================== Sprite 236 ========================
; Sprite ID:       sprite_95
; Sprite Comments: Captured from Screenshot (16.png)
;                  PosX=24; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_95_WIDTH_PX    = 8
sprite_95_HEIGHT_PX   = 8
sprite_95_BIT_PER_PX  = 2
sprite_95_INDEX       = 235
sprite_95_NUM_FRAMES  = 1
sprite_95:
          !BYTE $cc, $cc, $ff, $ff, $ff, $ff, $55, $55

; ==================== Sprite 237 ========================
; Sprite ID:       sprite_97
; Sprite Comments: Captured from Screenshot (16.png)
;                  PosX=48; PosY=104
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_97_WIDTH_PX    = 8
sprite_97_HEIGHT_PX   = 8
sprite_97_BIT_PER_PX  = 2
sprite_97_INDEX       = 236
sprite_97_NUM_FRAMES  = 1
sprite_97:
          !BYTE $cc, $cc, $ff, $ff, $dd, $dd, $55, $55

; ==================== Sprite 238 ========================
; Sprite ID:       sprite_98
; Sprite Comments: Captured from Screenshot (16.png)
;                  PosX=40; PosY=16
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_98_WIDTH_PX    = 8
sprite_98_HEIGHT_PX   = 8
sprite_98_BIT_PER_PX  = 2
sprite_98_INDEX       = 237
sprite_98_NUM_FRAMES  = 1
sprite_98:
          !BYTE $15, $15, $15, $15, $11, $11, $51, $51

; ==================== Sprite 239 ========================
; Sprite ID:       sprite_99
; Sprite Comments: Captured from Screenshot (16.png)
;                  PosX=40; PosY=24
; Dimensions:      8 x 8 pixels
; Color Mode:      Multicolor (4 colors, 2 bits per pixel)
; Byte Order:      CharacterBased

sprite_99_WIDTH_PX    = 8
sprite_99_HEIGHT_PX   = 8
sprite_99_BIT_PER_PX  = 2
sprite_99_INDEX       = 238
sprite_99_NUM_FRAMES  = 1
sprite_99:
          !BYTE $51, $51, $51, $51, $51, $51, $55, $55

;Comparing files bl_new_0002_fc99.prg and BL_ORG_0002_FC99.PRG
;*= $000B
; !BYTE $00 ; 8A 00
;*= $000D
; !BYTE $FF ;0000000D: 00 FF
;*= $0014
; !BYTE $00 ;00000014: 10 00
;*= $0015
; !BYTE $00 ;00000015: 10 00
;*= $0023
; !BYTE $FC ;00000023: 02 FC
;*= $0024
; !BYTE $44 ;00000024: 08 44
;*= $0025
; !BYTE $A4 ;00000025: 85 A4
;*= $003A
; !BYTE $FF ;0000003A: 00 FF
;*= $003B
; !BYTE $00 ;0000003B: 0A 00
;*= $0045
; !BYTE $00 ;00000045: 52 00
;*= $0047
; !BYTE $24 ;00000047: C4 24
;*= $0048
; !BYTE $00 ;00000048: D8 00
;*= $0049
; !BYTE $00 ;00000049: C4 00
;*= $004A
; !BYTE $00 ;0000004A: D8 00
;*= $005D
; !BYTE $FC ;0000005D: 00 FC
;*= $0061
; !BYTE $05 ;00000061: 8D 05
;*= $0062
; !BYTE $F9 ;00000062: 00 F9
;*= $0063
; !BYTE $FC ;00000063: 00 FC
;*= $0064
; !BYTE $19 ;00000064: 10 19
;*= $0065
; !BYTE $00 ;00000065: 10 00
;*= $0066
; !BYTE $20 ;00000066: 00 20
;*= $0069
; !BYTE $80 ;00000069: 8D 80
;*= $006A
; !BYTE $00 ;0000006A: 80 00
;*= $006B
; !BYTE $00 ;0000006B: 70 00
;*= $006D
; !BYTE $02 ;0000006D: 00 02
;*= $0078
; !BYTE $00 ;00000078: B2 00
;*= $0081
; !BYTE $00 ;00000081: 80 00
;*= $009A
; !BYTE $80 ;0000009A: 00 80
;*= $00A4
; !BYTE $02 ;000000A4: 05 02
;*= $00A5
; !BYTE $76 ;000000A5: 4C 76
;*= $00C3
; !BYTE $05 ;000000C3: 02 05
;*= $00C4
; !BYTE $05 ;000000C4: 09 05
;*= $00C5
; !BYTE $00 ;000000C5: 02 00
;*= $00C8
; !BYTE $C8 ;000000C8: 90 C8
;*= $00C9
; !BYTE $0C ;000000C9: 0D 0C
;*= $00CD
; !BYTE $05 ;000000CD: 0A 05
;*= $00CE
; !BYTE $0A ;000000CE: 0D 0A
;*= $00D0
; !BYTE $18 ;000000D0: A8 18
;*= $00D2
; !BYTE $E7 ;000000D2: 77 E7
;*= $00D3
; !BYTE $10 ;000000D3: 11 10
;*= $00EA
; !BYTE $C8 ;000000EA: 90 C8
;*= $00EB
; !BYTE $08 ;000000EB: 09 08
;*= $00EC
; !BYTE $00 ;000000EC: 26 00
;*= $00ED
; !BYTE $00 ;000000ED: E0 00
;*= $00FE
; !BYTE $00 ;000000FE: 05 00

;*= $018D
; !BYTE $FF ;0000018D: DF FF
;*= $01B6
; !BYTE $00 ;000001B6: 02 00
;*= $01E1
; !BYTE $00 ;000001E1: 2D 00
;*= $01E2
; !BYTE $FF ;000001E2: 3F FF
;*= $01E3
; !BYTE $1C ;000001E3: DB 1C
;*= $01E4
; !BYTE $DB ;000001E4: FF DB
;*= $01E5
; !BYTE $53 ;000001E5: 3F 53
;*= $01E6
; !BYTE $CE ;000001E6: DB CE
;*= $01E7
; !BYTE $37 ;000001E7: 1C 37
;*= $01E8
; !BYTE $00 ;000001E8: DB 00
;*= $01E9
; !BYTE $28 ;000001E9: 1C 28
;*= $01EA
; !BYTE $02 ;000001EA: DB 02
;*= $01EB
; !BYTE $2D ;000001EB: 53 2D
;*= $01ED
; !BYTE $00 ;000001ED: 37 00
;*= $01EF
; !BYTE $FD ;000001EF: 2D FD
;*= $01F0
; !BYTE $23 ;000001F0: CE 23
;*= $01F1
; !BYTE $10 ;000001F1: 00 10
;*= $01F2
; !BYTE $10 ;000001F2: 00 10
;*= $01F3
; !BYTE $10 ;000001F3: FD 10
;*= $01F4
; !BYTE $00 ;000001F4: 23 00
;*= $01F5
; !BYTE $12 ;000001F5: 10 12
;*= $01F6
; !BYTE $93 ;000001F6: 10 93
;*= $01F7
; !BYTE $A7 ;000001F7: CE A7
;*= $01F8
; !BYTE $5E ;000001F8: A7 5E
;*= $01F9
; !BYTE $88 ;000001F9: DB 88
;*= $01FA
; !BYTE $18 ;000001FA: 8B 18
;*= $01FB
; !BYTE $87 ;000001FB: 8B 87
;*= $0200
; !BYTE $00 ;00000200: 8A 00
;*= $0202
; !BYTE $00 ;00000202: 4E 00
;*= $025C
; !BYTE $00 ;0000025C: 10 00
;*= $02E9
; !BYTE $05 ;000002E9: 0A 05
;*= $04F7
; !BYTE $00 ;000004F7: FA 00
;*= $051C
; !BYTE $FE ;0000051C: FF FE
;*= $0527
; !BYTE $00 ;00000527: 10 00
;*= $0528
; !BYTE $00 ;00000528: 10 00
;*= $0542
; !BYTE $0A ;00000542: 10 0A
;*= $0549
; !BYTE $00 ;00000549: 09 00
;*= $0612
; !BYTE $FF ;00000612: BF FF
;*= $06BD
; !BYTE $FE ;000006BD: FF FE
;*= $06D4
; !BYTE $FD ;000006D4: FF FD
;*= $06F1
; !BYTE $00 ;000006E1: 01 00
;*= $06F2
; !BYTE $EF ;000006F2: FF EF
;*= $07EB
; !BYTE $0A ;000007EB: 0D 0A
;*= $0BF1
; !BYTE $00 ;00000BF1: 20 00
;*= $0D18
; !BYTE $20 ;00000D18: 3F 20
;*= $0D19
; !BYTE $20 ;00000D19: 13 20
;*= $0D1A
; !BYTE $20 ;00000D1A: 19 20
;*= $0D1B
; !BYTE $20 ;00000D1B: 0E 20
;*= $0D1C
; !BYTE $20 ;00000D1C: 14 20
;*= $0D1D
; !BYTE $20 ;00000D1D: 01 20
;*= $0D1E
; !BYTE $20 ;00000D1E: 18 20
;*= $0D20
; !BYTE $20 ;00000D20: 05 20
;*= $0D21
; !BYTE $20 ;00000D21: 12 20
;*= $0D22
; !BYTE $20 ;00000D22: 12 20
;*= $0D23
; !BYTE $20 ;00000D23: 0F 20
;*= $0D24
; !BYTE $20 ;00000D24: 12 20
;*= $0D40
; !BYTE $20 ;00000D40: 12 20
;*= $0D41
; !BYTE $20 ;00000D41: 05 20
;*= $0D42
; !BYTE $20 ;00000D42: 01 20
;*= $0D43
; !BYTE $20 ;00000D43: 04 20
;*= $0D44
; !BYTE $20 ;00000D44: 19 20
;*= $0D45
; !BYTE $20 ;00000D45: 2E 20
;*= $0D68
; !BYTE $20 ;00000D68: 12 20
;*= $0D69
; !BYTE $20 ;00000D69: 15 20
;*= $0D6A
; !BYTE $20 ;00000D6A: 0E 20
;*= $FF00
; !BYTE $20 ;0000FF00: E7 20
;*= $FF01
; !BYTE $16 ;0000FF01: 1E 16
;*= $FF02
; !BYTE $A3 ;0000FF02: 17 A3
;*= $FF03
; !BYTE $D0 ;0000FF03: 27 D0
;*= $FF04
; !BYTE $B5 ;0000FF04: 32 B5
;*= $FF05
; !BYTE $D0 ;0000FF05: 27 D0
;*= $FF0C
; !BYTE $FC ;0000FF0C: FF FC
;*= $FF0D
; !BYTE $C8 ;0000FF0D: FF C8
;*= $FF1D
; !BYTE $C4 ;0000FF1D: DA C4
;*= $FF1E
; !BYTE $B0 ;0000FF1E: 0A B0

;F $000B,$000B $00
;F $000D,$000D $FF 
;F $0014,$0014 $00
;F $0015,$0015 $00
;F $0023,$0023 $FC
;F $0024,$0024 $44
;F $0025,$0025 $A4
;F $003A,$003A $FF
;F $003B,$003B $00
;F $0045,$0045 $00
;F $0047,$0047 $24
;F $0048,$0048 $00
;F $0049,$0049 $00
;F $004A,$004A $00
;F $005D,$005D $FC
;F $0061,$0061 $05
;F $0062,$0062 $F9
;F $0063,$0063 $FC
;F $0064,$0064 $19
;F $0065,$0065 $00
;F $0066,$0066 $20
;F $0069,$0069 $80
;F $006A,$006A $00
;F $006B,$006B $00
;F $006D,$006D $02
;F $0078,$0078 $00
;F $0081,$0081 $00
;F $009A,$009A $80
;F $00A4,$00A4 $02
;F $00A5,$00A5 $76
;F $00C3,$00C3 $05
;F $00C4,$00C4 $05
;F $00C5,$00C5 $00
;F $00C8,$00C8 $C8
;F $00C9,$00C9 $0C
;F $00CD,$00CD $05
;F $00CE,$00CE $0A
;F $00D0,$00D0 $18
;F $00D2,$00D2 $E7
;F $00D3,$00D3 $10
;F $00EA,$00EA $C8
;F $00EB,$00EB $08
;F $00EC,$00EC $00
;F $00ED,$00ED $00
;F $00FE,$00FE $00
