;given right ascension of sun = 10hrs 41min 16s and declination = + 8 deg 18min 17sec
;H = LST - RA
#start= stepper_motor.exe#
.model small
.data

.code
    mov ax, @data
    mov ds, ax  
    mov ah, 2ch        ;int 21h service to get system time
    int 21h            ;stores ch=hour, cl=min, dh=second
    
    cmp dh, 16
    ja sub1
    add dh, 60
    sub dh, 16         ;dh stores seconds part of H
    dec cl
    
    next1:
        cmp cl, 41     ;comparing 41 with current minutes
        ja sub2
        add cl, 60
        sub cl, 41     ;cl stores minutes part of H
        dec ch
    
    next2:
        cmp ch, 10
        ja sub3
        add ch, 24
        sub ch, 10     ;ch stores hours part of H
        jmp next3
    
    
    sub1:
        sub dh, 16       
        jmp next1
    
    
    sub2:
        sub cl, 41
        jmp next2
    
    sub3:
        sub ch, 10
    next3:
        mov al, ch
        mov bl, 15
        mul bl           ;al=al*bl  al=H in degrees

;cos(declination) = 0.989
;observer's coordinates (somewhere near vellore) latitude = 79, sin(79) = 0.981
    
;formula for altitude, a:
;sin(a) = sin(declination)*sin(observer's latitude) + cos(declination)*cos(obs lat.)*cos(H)

;formula for azimuth A:
;sin(A) = -sin(H) * cos(declination)/ cos(a)

    start:
        ;stepper motor rotation
        ;half step in clockwise direction 
        mov al, 03h
        out 7, al
        mov al, 06h
        out 7, al
        mov al, 04h
        out 7, al
        mov al, 01h
        out 7, al        
        hlt