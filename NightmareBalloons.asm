;Syed Abdullah 24L-0595
;Maryam Waseem 24L-0949
[org 0x0100]

;jmp startGame
;jmp endGame

jmp startScreen

studioName: db 'M and A Studios Presents', 0

scoreText: db 'Score : ', 0
score: dw 0

timeText: db 'Time :  ', 0
time: dw 60

gameTitle:	db 'Nightmare Balloons', 0

title1 db 'NN  N  III  GGGG  H  H  TTTTT  MM MM  AAAA  RRRR   EEEE', 0
title2 db 'N N N   I   G     H  H    T    M M M  A  A  R   R  E   ', 0
title3 db 'N N N   I   G GG  HHHH    T    M M M  AAAA  RRRR   EEEE', 0
title4 db 'N  NN   I   G  G  H  H    T    M   M  A  A  R  R   E   ', 0
title5 db 'N   N  III  GGGG  H  H    T    M   M  A  A  R   R  EEEE', 0

title6 db  'BBBB   AAAA  L     L      OOO   OOO  N   N  SSSS', 0
title7 db  'B   B  A  A  L     L     O   O O   O NN  N  S   ', 0
title8 db  'BBBB   AAAA  L     L     O   O O   O N N N  SSSS', 0
title9 db  'B   B  A  A  L     L     O   O O   O N  NN     S', 0
title10 db 'BBBB   A  A  LLLL  LLLL   OOO   OOO  N   N  SSSS', 0


gameInstruction1:	db 'Press Enter to Start the Game', 0

spookyAhh:  db 'Tonight, the cursed rise once more...', 0
spookyAhh2: db 'Their spirits haunt every balloon in sight.', 0
spookyAhh3: db 'Pop them fast... before they pop YOU!', 0

trackPose : dw 0
bat1: db '^V^', 0
bat2: db 'vVv', 0

msg1: db 'WAH SHAMPY WAH', 0
msg2: db 'Thank you for playing our game.', 0
msg3: db 'We hope you enjoyed it.', 0
msg4: db 'Credits: ', 0
msg5: db 'Maryam Waseem', 0
msg6: db 'Syed Abdullah', 0
msg7: db 'Press R to Restart (ESC to exit)', 0

instructTitle db "===== INSTRUCTIONS =====", 0
instruct1 db "You are the saviour. Pop the balloons to stop the dead", 0
instruct2 db "from rising before the time ends.", 0
instruct3 db "1. Player is given the total time of 1 minute.", 0
instruct4 db "2. Each balloon pop will award 10 points.", 0
instruct5 db "3. Type correct letter displayed on the balloon to pop it.", 0
instructPrompt db "Press ENTER to Begin... and Happy Popping!!", 0

randSeed dw 137

letterTracker : dw 'A C P'
rowTracker : dw 25, 25, 25
columnTracker : dw 10, 40, 65

batTick : dw 0

timerTick : dw 0
timerTickCheck : dw 5


worthy : db 'You saved them!!!', 0
unworthy : db 'That was just sad. Really, really sad.', 0

oldTimerISR : dd 0

soundEnabled dw 1
soundTicks dw 0
soundPhase dw 0
startMelodyPosition dw 0
melodyPosition dw 0
irregularPattern dw 0

lives : dw 5
livesText : db 'Lives : ', 0

level2 : db 'You really thought it would be this easy', 0

flash : dw 0

levelText : db 'Level : ', 0
level : dw 1

currentSpeed : dw 8

YourScore : db 'Your score : ', 0

pauseText : db 'PAUSED', 0
pauseText2 : db 'Press R to Resume Popping', 0

;==============================================================================================================

; All sounds

; Start screen sound

startSoundInt8:
    push ax
    push bx
    push cx
    push dx
    push si
    push ds
    
    mov ax, cs
    mov ds, ax
    
    cmp word [soundEnabled], 1
    jne startDone
    
    inc word [soundTicks]
    mov ax, [soundTicks]
    and ax, 15      ; Slow, atmospheric pace
    jnz startDone
    
    mov si, [startMelodyPosition]
    
    ; Slow, melancholic melody in minor key
    cmp si, 0
    je startNote1
    cmp si, 1
    je startNote2
    cmp si, 2
    je startNote3
    cmp si, 3
    je startNote4
    cmp si, 4
    je startNote5
    jmp resetStart

; Melancholic A minor progression
startNote1: mov ax, 440   ; A (tonic)
            mov cx, 16
            jmp playStart
startNote2: mov ax, 523   ; C (minor third)
            mov cx, 12
            jmp playStart
startNote3: mov ax, 659   ; E (perfect fifth)
            mov cx, 16
            jmp playStart
startNote4: mov ax, 392   ; G (minor seventh)
            mov cx, 20
            jmp playStart
startNote5: mov ax, 330   ; Low E (deep resolution)
            mov cx, 24

playStart:
    in al, 61h
    or al, 00000011b
    out 61h, al
    out 42h, al
    mov al, ah
    out 42h, al
    
    ; Smooth, musical delays
    push cx
startDelay:
    push cx
    mov cx, 150
startInner:
    loop startInner
    pop cx
    loop startDelay
    pop cx
    
    inc word [startMelodyPosition]
    cmp word [startMelodyPosition], 5
    jl startDone
    
resetStart:
    mov word [startMelodyPosition], 0

startDone:
    mov al, 0x20
    out 0x20, al
    pop ds
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret

mainSoundInt8:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    
    mov ax, cs
    mov ds, ax
    
    cmp word [soundEnabled], 1
    jne mainDone
    
    inc word [soundTicks]
    mov ax, [soundTicks]
    and ax, 3      ; Medium pace, driving rhythm
    jnz mainDone
    
    mov si, [melodyPosition]
    
    ; Driving, serious melody in D minor
    cmp si, 0
    je mainNote1
    cmp si, 1
    je mainNote2
    cmp si, 2
    je mainNote3
    cmp si, 3
    je mainNote4
    cmp si, 4
    je mainNote5
    cmp si, 5
    je mainNote6
    jmp resetMain

; Driving D minor progression
mainNote1: mov ax, 587   ; D (tonic)
           mov cx, 6
           jmp playMain
mainNote2: mov ax, 698   ; F (minor third)
           mov cx, 4
           jmp playMain
mainNote3: mov ax, 880   ; A (perfect fifth)
           mov cx, 6
           jmp playMain
mainNote4: mov ax, 784   ; G (subdominant)
           mov cx, 4
           jmp playMain
mainNote5: mov ax, 659   ; E (mediant)
           mov cx, 6
           jmp playMain
mainNote6: mov ax, 523   ; C (submediant)
           mov cx, 8

playMain:
    in al, 61h
    or al, 00000011b
    out 61h, al
    out 42h, al
    mov al, ah
    out 42h, al
    
    ; Consistent, rhythmic delays
    push cx
mainDelay:
    push cx
    mov cx, 100
mainInner:
    loop mainInner
    pop cx
    loop mainDelay
    pop cx
    
    ; Occasional harmony note (adds depth without screeching)
    mov ax, [soundTicks]
    and ax, 7
    cmp ax, 0
    jne noHarmony
    
    mov ax, 294   ; Low D - adds bass harmony
    out 42h, al
    mov al, ah
    out 42h, al
    mov cx, 40
harmonyDelay:
    loop harmonyDelay
    
noHarmony:
    inc word [melodyPosition]
    cmp word [melodyPosition], 6
    jl mainDone
    
resetMain:
    mov word [melodyPosition], 0

mainDone:
    mov al, 0x20
    out 0x20, al
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret

	
; End screen sound

endSoundInt8:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    
    mov ax, cs
    mov ds, ax
    
    cmp word [soundEnabled], 1
    jne twinkleDone
    
    inc word [soundTicks]
    mov ax, [soundTicks]
    
    ; Gentle musical pace
    and ax, 11      ; Every 12 ticks (~0.66 seconds)
    jnz twinkleDone
    
    mov si, [melodyPosition]
    
    ; Complete "Twinkle Twinkle" melody with variations
    cmp si, 0
    je twinkle1
    cmp si, 1
    je twinkle2
    cmp si, 2
    je twinkle3
    cmp si, 3
    je twinkle4
    cmp si, 4
    je twinkle5
    cmp si, 5
    je twinkle6
    cmp si, 6
    je twinkle7
    cmp si, 7
    je twinkle8
    cmp si, 8
    je twinkle9
    cmp si, 9
    je twinkle10
    cmp si, 10
    je twinkle11
    cmp si, 11
    je twinkle12
    cmp si, 12
    je twinkle13
    cmp si, 13
    je twinkle14
    cmp si, 14
    je twinkle15
    cmp si, 15
    je twinkle16
    cmp si, 16
    je twinkle17
    cmp si, 17
    je twinkle18
    cmp si, 18
    je twinkle19
    cmp si, 19
    je twinkle20
    cmp si, 20
    je twinkle21
    cmp si, 21
    je twinkle22
    cmp si, 22
    je twinkle23
    cmp si, 23
    je twinkle24
    jmp resetTwinkle

; Full "Twinkle Twinkle" in C major (warm frequencies)
; Verse 1
twinkle1:  mov ax, 523   ; C
           mov cx, 300
           jmp playTwinkle
twinkle2:  mov ax, 523   ; C
           mov cx, 300
           jmp playTwinkle
twinkle3:  mov ax, 784   ; G
           mov cx, 300
           jmp playTwinkle
twinkle4:  mov ax, 784   ; G
           mov cx, 300
           jmp playTwinkle
twinkle5:  mov ax, 880   ; A
           mov cx, 300
           jmp playTwinkle
twinkle6:  mov ax, 880   ; A
           mov cx, 300
           jmp playTwinkle
twinkle7:  mov ax, 784   ; G
           mov cx, 450
           jmp playTwinkle
twinkle8:  mov ax, 0     ; Pause
           mov cx, 150
           jmp playTwinkle

; Verse 2
twinkle9:  mov ax, 698   ; F
           mov cx, 300
           jmp playTwinkle
twinkle10: mov ax, 698   ; F
           mov cx, 300
           jmp playTwinkle
twinkle11: mov ax, 659   ; E
           mov cx, 300
           jmp playTwinkle
twinkle12: mov ax, 659   ; E
           mov cx, 300
           jmp playTwinkle
twinkle13: mov ax, 587   ; D
           mov cx, 300
           jmp playTwinkle
twinkle14: mov ax, 587   ; D
           mov cx, 300
           jmp playTwinkle
twinkle15: mov ax, 523   ; C
           mov cx, 450
           jmp playTwinkle
twinkle16: mov ax, 0     ; Pause
           mov cx, 150
           jmp playTwinkle

; Chorus Variation
twinkle17: mov ax, 784   ; G
           mov cx, 250
           jmp playTwinkle
twinkle18: mov ax, 784   ; G
           mov cx, 250
           jmp playTwinkle
twinkle19: mov ax, 698   ; F
           mov cx, 250
           jmp playTwinkle
twinkle20: mov ax, 698   ; F
           mov cx, 250
           jmp playTwinkle
twinkle21: mov ax, 659   ; E
           mov cx, 250
           jmp playTwinkle
twinkle22: mov ax, 659   ; E
           mov cx, 250
           jmp playTwinkle
twinkle23: mov ax, 587   ; D
           mov cx, 400
           jmp playTwinkle
twinkle24: mov ax, 392   ; Low G - peaceful ending
           mov cx, 600

playTwinkle:
    cmp ax, 0
    je twinkleSilence
    
    in al, 61h
    or al, 00000011b
    out 61h, al
    out 42h, al
    mov al, ah
    out 42h, al
    
    ; Musical timing
    push cx
twinkleDelay:
    push cx
    mov cx, 100
twinkleInner:
    loop twinkleInner
    pop cx
    loop twinkleDelay
    pop cx
    
    ; Add harmony on longer notes
    cmp si, 7
    je addHarmony1
    cmp si, 15
    je addHarmony2
    cmp si, 23
    je addHarmony3
    jmp noHarmonyTwinkle

addHarmony1:
    mov di, ax
    mov ax, 392     ; G harmony for final G
    jmp playHarmonyTwinkle
addHarmony2:
    mov di, ax
    mov ax, 262     ; C harmony for final C
    jmp playHarmonyTwinkle
addHarmony3:
    mov di, ax
    mov ax, 294     ; D harmony for final D

playHarmonyTwinkle:
    out 42h, al
    mov al, ah
    out 42h, al
    mov cx, 150
harmonyTwinkleDelay:
    loop harmonyTwinkleDelay
    mov ax, di      ; Restore main note
    out 42h, al
    mov al, ah
    out 42h, al
    
noHarmonyTwinkle:
    jmp nextTwinkleNote

twinkleSilence:
    in al, 61h
    and al, 11111100b
    out 61h, al
    
    push cx
silenceTwinkle:
    push cx
    mov cx, 100
silenceTwinkleInner:
    loop silenceTwinkleInner
    pop cx
    loop silenceTwinkle
    pop cx

nextTwinkleNote:
    inc word [melodyPosition]
    cmp word [melodyPosition], 24
    jl twinkleDone
    
resetTwinkle:
    mov word [melodyPosition], 0

twinkleDone:
    mov al, 0x20
    out 0x20, al
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret

; Stop sound

stopSound:

	push bp
	mov bp, sp
    push ax
    mov word [soundEnabled], 0
    in al, 61h
    and al, 11111100b
    out 61h, al
	mov word[soundTicks], 0
	mov word[soundPhase], 0
    pop ax
	mov sp, bp
	pop bp
    ret

;==============================================================================================================
;Start of main code

screenDelay:	;delay for switching between screens	
			push bp
			mov bp, sp
			push cx
			mov cx, 200
			
jumperD:	push cx
			mov cx, 0xFFFF

insideD: 	loop insideD

		pop cx
		dec cx
		cmp cx, 0
		jne jumperD
		pop cx
		pop bp
		ret
		; end of screenDelay
		
		
cx10:    mov ax, title1
		push ax		
		jmp jumpTo

cx9:     mov ax, title2
			push ax	
			jmp jumpTo

cx8:     mov ax, title3
			push ax
			jmp jumpTo

cx7:     mov ax, title4
			push ax	
			jmp jumpTo

cx6:     mov ax, title5
			push ax		
			jmp jumpTo
			
cx5:     mov ax, title6
			push ax		
			jmp jumpTo

cx4:     mov ax, title7
			push ax	
			jmp jumpTo

cx3:     mov ax, title8
			push ax
			jmp jumpTo

cx2:     mov ax, title9
			push ax	
			jmp jumpTo

cx1:     mov ax, title10
			push ax		
			jmp jumpTo
			
firstName: 
			mov ax, 13
			push ax
			mov ax, 7
			jmp conti

startScreen: 

				
				xor ax, ax
				mov es, ax
			
				mov ax, [es : 8*4]
				mov [oldTimerISR], ax
				mov ax, [es : 8*4 + 2]
				mov [oldTimerISR + 2], ax
				
				cli
				mov word[es : 8*4], startSoundInt8
				mov word[es : 8*4 + 2], cs
				sti
				
				
				call clrscr
				
				
				;print studio name
				mov ax, 27
				push ax
				mov ax, 11
				push ax
				mov ax, 0x0A
				push ax
				mov ax, studioName
				push ax		
				call printstr
				call screenDelay
				call clrscr
				
				mov cx, 10 ; counter to print 5 title strings
printMain:
			; print game title
			
			cmp cx, 5
			jg firstName
			mov ax, 16
			push ax
			mov ax, 9
			
conti: 			
			add ax, 5
			sub ax, cx
			push ax
			mov ax, 0x04
			push ax
			
			cmp cx, 10
			je cx10
			cmp cx, 9
			je cx9
			cmp cx, 8
			je cx8
			cmp cx, 7
			je cx7
			cmp cx, 6
			je cx6
			
			cmp cx, 5
			je cx5
			cmp cx, 4
			je cx4
			cmp cx, 3
			je cx3
			cmp cx, 2
			je cx2
			cmp cx, 1
			je cx1
			

			
jumpTo:		
			call printstr
			mov dx, 20
			push dx
			call delay
			loop printMain
			call screenDelay
			
			;Print enter start 
			mov ax, 24
			push ax
			mov ax, 19
			push ax
			mov ax, 0x8E
			push ax
			mov ax, gameInstruction1
			push ax		
			call printstr
			
			            ; --- WAIT FOR ENTER KEY ---
wait_for_enter:
            mov ah, 0
            int 0x16       
            cmp al, 0x0D   ; Check for Enter Key
            jne wait_for_enter
            ; ---------------------------
			
			;print start game dialogue
			
			call clrscr
			mov ax, 17
			push ax
			mov ax, 12
			push ax
			mov ax, 0x02
			push ax
			mov ax, spookyAhh
			push ax		
			call printstr
			call screenDelay
			
			call clrscr
			mov ax, 17
			push ax
			mov ax, 12
			push ax
			mov ax, 0x0E
			push ax
			mov ax, spookyAhh2
			push ax		
			call printstr
			call screenDelay
			
			call clrscr
			mov ax, 17
			push ax
			mov ax, 12
			push ax
			mov ax, 0x04
			push ax
			mov ax, spookyAhh3
			push ax		
			call printstr
			call screenDelay
			; end of startScreen and dialogue
			
instructionsScreen:
			call clrscr

			; Title
			mov ax, 25               ; column
			push ax
			mov ax, 3                ; row
			push ax
			mov ax, 0x0E             
			push ax
			mov ax, instructTitle
			push ax
			call printstr

			; Line 1
			mov ax, 5
			push ax
			mov ax, 6
			push ax
			mov ax, 0x0F
			push ax
			mov ax, instruct1
			push ax
			call printstr

			; Line 2
			mov ax, 5
			push ax
			mov ax, 8
			push ax
			mov ax, 0x0F
			push ax
			mov ax, instruct2
			push ax
			call printstr

			; Line 3
			mov ax, 5
			push ax
			mov ax, 10
			push ax
			mov ax, 0x0F
			push ax
			mov ax, instruct3
			push ax
			call printstr

			; Line 4
			mov ax, 5
			push ax
			mov ax, 12
			push ax
			mov ax, 0x0F
			push ax
			mov ax, instruct4
			push ax
			call printstr

			; Line 5
			mov ax, 5
			push ax
			mov ax, 14
			push ax
			mov ax, 0x0F
			push ax
			mov ax, instruct5
			push ax
			call printstr

			; Prompt
			mov ax, 15
			push ax
			mov ax, 20
			push ax
			mov ax, 0x8E
			push ax
			mov ax, instructPrompt
			push ax
			call printstr
			
wait_for_enter2:
            mov ah, 0
            int 0x16       
            cmp al, 0x0D   ; Check for Enter Key
            jne wait_for_enter2
            ; ---------------------------
			
			call stopSound
			
			jmp startGame
			
drawBorder:; drawing border of the game

			push bp
			mov bp, sp
			push es
			push ax
			push di
			push cx
			
			mov ax, 0xB800
			mov es, ax
			
			mov ax, 0x0F2B
			mov word[es : 0], ax
			mov word[es : 158], ax
			mov word[es : 3998], ax
			mov word[es : 3840], ax
			mov di, 2
			
			mov cx, 78
			mov ax, 0x0F23
			cld
			rep stosw
			
			mov di, 3842
			
			mov cx, 78
			mov ax, 0x0F23
			cld
			rep stosw
			
			mov di, 160
			mov cx, 23
lineLoop:			
			mov ax, 0x0F23
			cld
			mov [es : di], ax
			add di, 160
			loop lineLoop
			
			mov di, 318
			mov cx, 23
lineLoop2:			
			mov ax, 0x0F23
			cld
			mov [es : di], ax
			add di, 160
			loop lineLoop2
			
			pop cx
			pop di
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret
		;end of drawBorder
			
drawWeb:	;drawing cobwebs, useless for now since cobwebs were doobius
		
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push cx
			
			mov ax, 0xB800
			mov es, ax
			
			mov al, 80
			mul byte[bp + 4]
			add ax, [bp + 6]
			shl ax, 1
			
			mov di, ax
			mov ax, 0xEF2A
			mov [es : di], ax
			
			mov word[es: di - 164], 0xE05C
			mov word[es: di - 160], 0xE07C
			mov word[es: di - 156], 0xE02F
			mov word[es: di - 2], 0xE02D
			mov word[es: di + 2], 0xE02D
			mov word[es: di + 164], 0xE05C
			mov word[es: di + 160], 0xE07C
			mov word[es: di +156], 0xE02F
			
			pop cx
			pop di
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret 4 
			; drawWeb ends
		
			
drawBats:	; to draw 4 bats on the screen, all hardcoded
			push bp
			mov bp, sp
			push es
			push ax
			push bx
			push di
			
			mov ax, 0xB800
			mov es, ax
			
			cmp word [trackPose], 0
			je pose1
			mov bx, bat2
			mov word[trackPose], 0
			jmp printem
			
pose1: mov bx, bat1
		mov word[trackPose], 1
			
			; pose 1 of bats, wings up
printem:
			mov ax, 32
			push ax
			mov ax, 7
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr
			
			mov ax, 45
			push ax
			mov ax, 8
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr
			
			mov ax, 10
			push ax
			mov ax, 15
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr

			mov ax, 20
			push ax
			mov ax, 5
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr

			mov ax, 30
			push ax
			mov ax, 12
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr

			mov ax, 55
			push ax
			mov ax, 7
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr

			mov ax, 62
			push ax
			mov ax, 15
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr

			
			mov ax, 70
			push ax
			mov ax, 4
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr
			
			mov ax, 10
			push ax
			mov ax, 2
			push ax
			mov ax, 0x60
			push ax
			mov ax, bx
			push ax
			call printstr
			
			
			
			
			pop di
			pop bx
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret
			; drawBats ends
			
drawPumpkin: ; JACK O' LANTERN !!!

		push bp
		mov bp, sp
		push es
		push ax
		push di
		push dx
		
		mov ax, 0xb800
		mov es, ax
		
		mov al, 80
		mul byte[bp + 4]
		add ax, [bp + 6]
		shl ax, 1
		mov di, ax
		mov dx, [bp + 8]
		push di
		
		mov ah, 0x06

		mov al, '_'
		stosw
		mov al, '_'
		stosw
		mov al, '/'
		stosw		
		mov al, '\'
		stosw
		mov al, '_'
		stosw
		mov al, '_'
		stosw
	
		add di, 160
		mov al, ')'
		mov [es : di], ax	
		add di, 160
		mov al, ')'
		mov [es : di], ax
		
		pop di
		mov [es : di + 160], word 0x0000
		mov [es : di + 162], word 0x0000
		mov [es : di + 164], word 0x0000
		mov [es : di + 166], word 0x0000
		mov [es : di + 168], word 0x0000
		mov [es : di + 170], word 0x0000
		mov [es : di - 2], word 0x0000
		mov [es : di + 12], word 0x0000
		add di, 158
		mov al, '('
		mov [es : di], ax
		push di
		add di, dx
		mov al, 'V'
		stosw
		add di, 2
		stosw
		
		pop di
		add di, 160
		mov al, '('
		mov [es : di], ax
		
		add di, 2
		
		
		mov al, '_'
		stosw
		mov al, '/'
		stosw
		mov al, '\'
		stosw
		mov al, '/'
		stosw
		mov al, '\'
		stosw
		mov al, '_'
		stosw
		
		pop dx
		pop di
		pop ax
		pop es
		mov sp, bp
		pop bp
		
		ret 6
		;drawPumpkin ends
		
drawPumpkins:

			push bp
			mov bp, sp
			push ax

		; draw pumpkin			
			mov ax, 6
			push ax
			mov ax, 4
			push ax
			mov ax, 20
			push ax
			call drawPumpkin
			
			mov ax, 4
			push ax
			mov ax, 70
			push ax
			mov ax, 20
			push ax
			call drawPumpkin
			
			pop ax
			mov sp, bp
			pop bp
			ret

drawBG: ; the main game background, calls all above functions

			push bp
			mov bp, sp
			push es
			push ax
			push di
			push cx
			
			mov ax, 0xB800
			mov es, ax
			
			;print bg color
			mov cx, 2002
			mov ax, 0x6000
			mov di, 0
			cld
			rep stosw
			
			pop cx
			pop di
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret
			; end of drawBG

clrscr:		push bp
			mov bp, sp
			push es
			push ax
			push di
			push cx
			
			mov ax, 0xB800
			mov es, ax
			
			mov cx, 2002 ; 2002 because the bottom right corner doesn't get filled
			mov ax, 0x0720
			mov di, 0
			cld
			rep stosw
			
			pop cx
			pop di
			pop ax
			pop es
			mov sp, bp
			pop bp
			ret
			; end of clrscr
			
strlen:		push bp
			mov bp, sp
			push cx
			push es
			push di
			
			mov di, [bp + 4]
			push ds
			pop es
			mov ax, 0
			mov cx, 0XFFFF
			repne scasb
			mov ax, 0XFFFF
			sub ax, cx
			dec ax
			
			pop di
			pop es
			pop cx
			mov sp, bp
			pop bp
			ret 2
			; end of strlen
			
printstr:	push bp
			mov bp, sp
			push es
			push ax
			push cx
			push si
			push di
			
			push word [bp + 4]
			call strlen
			
			cmp ax, 0
			mov cx, ax
			
			mov ax, 0xb800
			mov es, ax
			mov al, 80
			mul byte[bp + 8]
			add ax, [bp + 10]
			shl ax, 1
			mov di, ax
			mov ah, [bp + 6]
			mov si, [bp + 4]
			
			
			cld
nextchar:	lodsb
			stosw
			loop nextchar
			pop di
			pop si
			pop cx
			pop ax
			pop es
			mov sp, bp
			pop bp

			ret 8
			;end of printstr
			
printNum:	push bp
			mov bp, sp
			push es
			push ax
			push bx
			push cx
			push dx
			push di
			
			mov ax, 0xb800
			mov es, ax
			mov ax, 80
			mul byte[bp + 8]
			add ax, [bp + 10]
			shl ax, 1
			mov di, ax
			
			mov ax, [bp + 4]
			mov bx, 10
			mov cx, 0
			
numLoop:	mov dx, 0
			div bx
			add dx, 0x30
			push dx
			inc cx
			cmp ax, 0
			jne numLoop
			
numLoop2:	pop ax
			mov ah, [bp + 6]
			stosw
			loop numLoop2
			
			pop di
			pop dx
			pop cx
			pop bx
			pop ax
			pop es
			mov sp, bp
			pop bp
			
			ret 8
			;end of printNum
			
printBalloon: ;A sort of hardcoded balloon printing function that prints relative to a center coordinate

			push bp
			mov bp, sp
			push es
			push ax
			push cx
			push dx
			push di
			
			
			mov ax, 0xB800
			mov es, ax
			
			;printing character
			mov dl, [bp + 4]
			mov al, 80
			mul dl
			add ax, [bp + 6]
			shl ax, 1
			mov di, ax
			
			mov al, [bp + 12]
			mov ah, 0x6E
			
			mov [es : di], ax
			
			;Printing the rest of the balloon hard coded relative to center
			
			mov dl, [bp + 4]
			sub dl, 1
			mov al, 80
			mul dl
			add ax, [bp + 6]
			shl ax, 1
			mov di, ax
			
			sub di, 2
			push di
			
			mov ah, [bp + 10]
			
			mov dx, [bp + 12]
			cmp dx, 0x20
			jne cont
			mov al, dl
			jmp cont2
			
cont:		mov al, 0x2A

cont2:		
			mov cx, 3
			rep stosw
			
			sub di, 2
			add di, 162
			mov[es : di], word ax
			
			
			add di, 160
			mov[es : di], word ax
			
			pop di
			add di, 158
			mov[es : di], word ax
			
			add di, 160
			mov[es : di], word ax
			
			add di, 162
			mov[es : di], word ax
			
			add di, 162
			mov[es : di], word ax
			
			push di
			
			add di, 162
			mov[es : di], word ax
			add di, 158
			mov[es : di], word ax
			add di, 162
			mov[es : di], word ax
			
			pop di
			
			sub di, 158
			mov[es : di], word ax
			
			pop di
			pop dx
			pop cx
			pop ax
			
			mov sp, bp
			pop bp
			ret 10
			; printBalloon ends

callPB:		push bp
			mov bp, sp
			push ax
			push bx
			
			mov bx, [bp + 8]
			
			mov ax, [bp + 6]
			push ax
			mov ax, [bp + 4]
			push ax
			mov ax, 10
			push ax
			mov ax, [columnTracker + bx]
			push ax
			mov ax, [rowTracker + bx]
			push ax
			
			call printBalloon	

			pop bx
			pop ax
			mov sp, bp
			pop bp
			ret 6
			; callPB ends
			

			
printScore:

			push bp
			mov bp, sp
			push ax
	
			mov ax, 5
			push ax
			mov ax, 4
			push ax
			mov ax, 0x6F
			push ax
			mov ax, scoreText
			push ax
			call printstr
			
			mov ax, 13
			push ax
			mov ax, 4
			push ax
			mov ax, 0x6F
			push ax
			mov ax, [score]
			push ax
			call printNum

			pop ax
			mov sp, bp
			pop bp
			ret
	
printTime:	push bp
			mov bp, sp
			push ax
			
			mov ax, 5
			push ax
			mov ax, 6
			push ax
			mov ax, 0x6F
			push ax
			mov ax, timeText
			push ax
			call printstr
			
			mov ax, 13
			push ax
			mov ax, 6
			push ax
			mov ax, 0x6F
			push ax
			mov ax, [time]
			push ax
			call printNum
			
			pop ax
			mov sp, bp
			pop bp
			ret
			
printLives:	push bp
			mov bp, sp
			push ax
			
			mov ax, 68
			push ax
			mov ax, 3
			push ax
			mov ax, 0x6F
			push ax
			mov ax, livesText
			push ax
			call printstr
			
			mov ax, 76
			push ax
			mov ax, 3
			push ax
			mov ax, 0x6F
			push ax
			mov ax, [lives]
			push ax
			call printNum
			
			pop ax
			mov sp, bp
			pop bp
			ret
			
printLevel:	push bp
			mov bp, sp
			push ax
			
			mov ax, 33
			push ax
			mov ax, 4
			push ax
			mov ax, 0x6F
			push ax
			mov ax, levelText
			push ax
			call printstr
			
			mov ax, 42
			push ax
			mov ax, 4
			push ax
			mov ax, 0x6F
			push ax
			mov ax, [level]
			push ax
			call printNum
			
			pop ax
			mov sp, bp
			pop bp
			ret
			
printTitle:	push bp
			mov bp, sp
			push ax
			
			mov ax, 30 ;column
			push ax
			mov ax, 2 ; row
			push ax
			mov ax, 0x6B ; attribute
			push ax
			mov ax, gameTitle ;string
			push ax
			call printstr
			
			pop ax
			mov sp, bp
			pop bp
			ret

delay:		;used to add a delay to certain areas of the game
			push bp
			mov bp, sp
			push cx
			mov cx, [bp + 4]
jumper:		push cx
			mov cx, 0xFFFF

inside: 	loop inside

		pop cx
		dec cx
		cmp cx, 0
		jne jumper
		pop cx
		pop bp
		ret		
				

resetBalloon:
    push bp
    mov bp, sp
    push dx 
    push bx
	push ax
    
    mov bx, [bp + 4]
    
generateAgain:
    mov ax, [randSeed]
    add ax, 37
    rol ax, 3
    mov [randSeed], ax
    
    mov ax, [randSeed]
    xor dx, dx
    mov cx, 80
    div cx
    mov cx, dx
    
    cmp cx, 5
    jl newSeed
    cmp cx, 75
    jg newSeed
    
    ; Set new starting position
    mov word[rowTracker + bx], 25
    mov word[columnTracker + bx], cx
    
   
    mov ax, [randSeed]
    and ax, 0x1F          ; Get value 0-31
    add ax, 'A'           ; Convert to A-Z
    cmp ax, 'Z'
    jbe letterOK
    sub ax, 26            ; Wrap around if beyond Z
letterOK:
    mov [letterTracker + bx], ax
    
	pop ax
    pop bx
    pop dx
    mov sp, bp
    pop bp
    ret

newSeed: 
    add word[randSeed], 0xF398
    jmp generateAgain
	
	
pauseGame:
	
	
	call drawBG
	
	mov ax, 36 ;column
	push ax
	mov ax, 10 ; row
	push ax
	mov ax, 0x6B ; attribute
	push ax
	mov ax, pauseText ;string
	push ax
	call printstr
	
	mov ax, 26 ;column
	push ax
	mov ax, 13 ; row
	push ax
	mov ax, 0x61 ; attribute
	push ax
	mov ax, pauseText2 ;string
	push ax
	call printstr
	
	mov ah, 0x00        ; Get the key
    int 0x16
	
	
	cmp al, 'r'
	je endPause
	cmp al, 'R'
	je endPause
	
	jmp pauseGame

endPause: 


	call drawBG
	je noInput


				
startGame:	

			mov word[soundEnabled], 1
			
			xor ax, ax
			mov es, ax
			
			cli
			mov word[es : 8*4], mainSoundInt8
			mov word[es : 8*4 + 2], cs
			sti
			
			call drawBG
			
			mov bx, 0
			
game:		; main game loop
			
			call drawBorder
			
			call drawPumpkins
			
checkKey:
    mov ah, 0x01        ; check if key is waiting
    int 0x16
    jz noInput          ; skip everything if no input

    mov ah, 0x00        ; get the key
    int 0x16
    
    ; Convert Lowercase to Uppercase
    cmp al, 'a'
    jb checkBalloons
    cmp al, 'z'
    ja checkBalloons
    sub al, 32

checkBalloons:
   
    mov bx, 0
    cmp al, byte [letterTracker + bx]
    jne tryBalloon2
    
  
    push bx
    mov ax, 0x20        
    push ax
    mov ax, 0x60      
    push ax
    call callPB
    
    add word [score], 10
    push bx
    call resetBalloon
    jmp noInput

tryBalloon2:
    
    mov bx, 2
    cmp al, byte [letterTracker + bx]
    jne tryBalloon3

 
    push bx
    mov ax, 0x20
    push ax
    mov ax, 0x60
    push ax
    call callPB
    
    add word [score], 10
    push bx
    call resetBalloon
    jmp noInput

tryBalloon3:
   
    mov bx, 4
    cmp al, byte [letterTracker + bx]
    jne tryPause

   
    push bx
    mov ax, 0x20
    push ax
    mov ax, 0x60
    push ax
    call callPB
    
    add word [score], 10
    push bx
    call resetBalloon
	
tryPause:

	cmp al, 0x1B
	je pauseGame

noInput:
			mov bx, 0
			inc word[batTick]
			cmp word[batTick], 2
			jne skipBats
			mov word[batTick], 0
			call drawBats

skipBats:
			
			call printScore
			
			call printLives
			
			call printTime
			inc word[timerTick]
			mov dx, [timerTickCheck]
			cmp word[timerTick], dx
			jne skipTimer
			dec word[time]
			mov word[timerTick], 0
			
skipTimer:			
			call printTitle
			call printLevel
			
			push bx
			mov ax, [letterTracker + bx]
			push ax
			mov ax, 0xA5
			push ax
			call callPB
			
			add bx, 2
			
			push bx
			mov ax, [letterTracker + bx]
			push ax
			mov ax, 0xA5
			push ax
			call callPB
			
			add bx, 2
			
			push bx
			mov ax, [letterTracker + bx]
			push ax
			mov ax, 0xA5
			push ax
			call callPB
			
			mov dx, [currentSpeed]
			push dx
			call delay
			
			mov bx, 0
			
			push bx
			mov ax, 0x20
			push ax
			mov ax, 0x60
			push ax
			call callPB
			
			cmp word[rowTracker + bx], 0
			jne nextCmp
			dec word[lives]
			inc word[flash]
			cmp word[lives], 0
			je keepMoving
			push bx
			call resetBalloon
			
nextCmp:	add bx, 2
			
			push bx
			mov ax, 0x20
			push ax
			mov ax, 0x60
			push ax
			call callPB
			
			cmp word[rowTracker + bx], 0
			jne nextCmp2
			dec word[lives]
			inc word[flash]
			cmp word[lives], 0
			je keepMoving
			push bx
			call resetBalloon
			
nextCmp2:	add bx, 2
			
			push bx
			mov ax, 0x20
			push ax
			mov ax, 0x60
			push ax
			call callPB
			
			cmp word[rowTracker + bx], 0
			jne keepMoving
			dec word[lives]
			inc word[flash]
			cmp word[lives], 0
			je keepMoving
			
			push bx
			call resetBalloon

keepMoving:
			
			mov bx, 0
			
			sub word[rowTracker + bx], 1
			
			add bx, 2
			
			sub word[rowTracker + bx], 1
			
			add bx, 2
			
			sub word[rowTracker + bx], 1
			
			mov bx, 0
			
			cmp word[flash], 1
			jl move
			call flashRed
			mov word[flash], 0
move:			
			cmp word[time], 0
			je shiftToEnd
			
			
			
			cmp word[lives], 0
			je shiftToEnd
			
			cmp word[time], 30
			jne moveOn
			call switchLevel2
moveOn:	
			jmp game
			
flashRed:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    push si          
    
    mov ax, 0xb800
    mov es, ax
    
    mov si, 1
    
flashLoop:

    mov di, 0
    mov ax, 0x4020  
    mov cx, 2000     
    cld
    rep stosw
    
    mov dx, 1
    push dx
    call delay
    
  
    mov di, 0
    mov ax, 0x0020   
    mov cx, 2000   
    cld
    rep stosw
    
   
    mov dx, 1
    push dx
    call delay
    
    dec si
    jnz flashLoop
	
	call drawBG
        
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret


		
switchLevel2:

			push bp
			mov bp, sp
			push es
			push ax
			push di
			push cx

			cmp word[timerTick], 0
			jne game

			call clrscr
			
			
			
			mov ax, 0xB800
			mov es, ax
			
			mov cx, 2002 ; 2002 because the bottom right corner doesn't get filled
			mov ax, 0x4420
			mov di, 0
			cld
			rep stosw
			
			mov ax, 20
			push ax
			mov ax, 10
			push ax
			mov ax, 0x40
			push ax
			mov ax, level2
			push ax
			call printstr
			
			call stopSound
			
			mov dx, 200
			push dx
			call delay
			
			call drawBG
			
			mov word[soundEnabled], 1
			cli
			mov word[es : 8*4], mainSoundInt8
			mov word[es : 8*4 + 2], cs
			sti
			
			call flashRed
			call flashRed
			call flashRed
			
			mov word[currentSpeed], 4
			mov word[timerTickCheck], 6
			
			inc word[level]
			
			
			pop cx
			pop di
			pop ax
			pop es
			mov sp, bp
			pop bp
			
			ret
			
			
			
shiftToEnd:

			call printScore
			
			call printTitle
			
			call drawBats
			
			call drawBorder
			
			call drawPumpkins
			
			call printTime
			
			call stopSound
			
			call printLives
			
			call screenDelay
			
			jmp endGame


			
;============================================================================================================			
			
endGame:
			mov word[soundEnabled], 1
			
			xor ax, ax
			mov es, ax
			
			cli
			mov word[es : 8*4], endSoundInt8
			mov word[es : 8*4 + 2], cs
			sti

			

			mov ax, 0xB800
			mov es, ax


			; Fill background
			mov ax, 0xE020 
			mov cx, 2000
			xor di, di
			cld
			rep stosw
			
			

			; Print message
			mov si, msg1
			mov di, 1980          
			mov ah, 0x6F           

			print1:
				lodsb
				or al, al
				jz next_screen
				stosw
				jmp print1

			next_screen:
				call screenDelay   
				
			call clrscr
			
			jmp feedback

youSuck: 	mov ax, 0x04
			push ax
			mov ax, unworthy
			push ax
			jmp nxt	

feedback:	
			
			
			call clrscr

			mov ax, 22
			push ax
			mov ax, 12
			push ax
			cmp word[score], 500
			jl youSuck
			mov ax, 0x02
			push ax
			mov ax, worthy
			push ax
			
nxt:		call printstr
			call screenDelay   	

			; thank you note
			
			mov cx, 5
			
thanks:		call clrscr
			
			mov ax, 22
			push ax
			mov ax, 12
			push ax
			mov ax, 0x02
			push ax
			cmp cx, 5
			je p1
			cmp cx, 4
			je p2
			cmp cx, 3
			je p3
			cmp cx, 2
			je p4
			cmp cx, 1
			je p5
			
continuePrint:
			push ax
			call printstr
			
			mov dx, 30
			push dx
			call delay
			push dx
			call delay
			push dx
			call delay
			loop thanks
			jmp nextScr3

p1: mov ax, msg2
    jmp continuePrint
p2: mov ax, msg3
    jmp continuePrint
p3: mov ax, msg4
    jmp continuePrint
p4: mov ax, msg5
    jmp continuePrint
p5: mov ax, msg6
    jmp continuePrint

nextScr3:   call clrscr
			; Print restart message
			mov si, msg7
			mov di, 2924
			mov ah, 0x8E    

			print2:
				lodsb
				or al, al
				jz neo
				stosw
				jmp print2
				
pushColor:
mov ax, 0x04
ret
neo:				
			mov ax, 30
			push ax
			mov ax, 10
			push ax
			
			mov ax, 0x02
			cmp word[score], 500
			jge contin
			call pushColor
contin:		push ax
			
			mov ax, YourScore
			push ax
			call printstr
			
			mov ax, 44
			push ax
			mov ax, 10
			push ax
			
			mov ax, 0x02
			cmp word[score], 500
			jge contin2
			call pushColor
contin2:	push ax
			
			mov ax, [score]
			push ax
			call printNum

exit:		
       
			call stopSound

			xor ax, ax
			mov es, ax
			
			mov ax, [oldTimerISR]
			mov bx, [oldTimerISR + 2]
			
			cli
			mov word[es : 8*4], ax
			mov word[es : 8*4 + 2], bx
			sti
			
wait_for_restart:

            mov ah, 0
            int 0x16            ; Wait for key press
            
            cmp al, 'r'         ; Check lowercase 'r'
            je do_restart
            cmp al, 'R'         ; Check uppercase 'R'
            je do_restart
            
            cmp al, 27          ; Check ESC key to quit
            je real_exit
            
            jmp wait_for_restart

do_restart:
            
            mov word [score], 0
            mov word [time], 60
            mov word [batTick], 0
            mov word [timerTick], 0
            
        
            mov word [rowTracker], 25
            mov word [rowTracker+2], 25
            mov word [rowTracker+4], 25
            
            mov word [columnTracker], 10
            mov word [columnTracker+2], 40
            mov word [columnTracker+4], 65
            
       
            mov word [letterTracker], 'A'
            mov word [letterTracker+2], 'C'
            mov word [letterTracker+4], 'P'
			
			mov word[soundEnabled], 1
			
			mov word[timerTickCheck], 5
			mov word[level], 1
			mov word[currentSpeed], 8
            
            jmp startGame

real_exit:
			mov ax, 0x4c00
			int 21h