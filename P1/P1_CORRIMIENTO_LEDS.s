;# unp

;**Curso:** Microcontroladores I

;**Autor:** Danilo Josemaria Avila Avila

;Tarjeta: Curiosity Nano PIC18f57q84

;Entorno: MPLAB X IDE

;Lenguaje: AMS - C

;UNIVERSIDAD NACIONAL DE PIURA, PERÚ
    
PROCESSOR 18F57Q84
#include "BIT_CONFIG.inc"  // config statements should precede project file includes.
#include <xc.inc>  

PSECT resetVect,class=code,reloc=2
resetVect:
    goto Main
    
PSECT udata_acs
Contador1: DS 1            ; reserva 1 byte en acces ram
Contador2: DS 1            ; reserva 1 byte en access ram
   
    
PSECT code
 
Main:
    CALL Config_OSC,1
    CALL Config_Port,1

BUTTON:
    BANKSEL   LATA
    CLRF      LATC,b
    BCF       LATE,1,b
    BCF       LATE,0,b
    BTFSC     PORTA,3,b
    goto      BUTTON
    goto      NUMEROS_PAR
     
NUMEROS_PAR:
   
    BCF   LATE,0,b
    BSF   LATE,1,b
    MOVLW 00000010B ;posicion2
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 00001000B ;posicion4
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 00100000B ;posicion6
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON1
    
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 1000000B ;posicion8
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON1
    
NUMEROS_IMPAR:
   
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000001B ;posicion1
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000100B ;posicion3
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00010000B ;posicion5
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON2
    
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 010000000B ;posicion7
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON2
    GOTO  NUMEROS_PAR
    
BUTTON1:
    ;cuando es numero par
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    BUTTON1
    GOTO    NUMEROS_PAR
    
BUTTON2:
    ;cuando es numero impar
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    BUTTON1
    GOTO    NUMEROS_IMPAR    
    
Config_OSC:
        ;Configuracion del Oscilador interno a una frecuencia interna de 4Mhz 
         BANKSEL OSCCON1
	 MOVLW 0X60     ;Seleccionamos el bloque del osc con un Div:1
	 MOVWF OSCCON1,1
	 MOVLW 0X02     ;Seleccionamos una Frecuencia de 4Mhz
	 MOVWF OSCFRQ ,1
         RETURN

Config_Port:   ;PORT-LAT-ANSEL-TRIS  LED:RF3,  BUTTON:RA3    ;Config Led

    BANKSEL  PORTF
    CLRF     TRISC,b    ;TRISC = 0 Como salida
    CLRF     ANSELC,b   ;ANSELC<7:0> = 0 - Port C digital
    BCF      TRISE,1,b  ;TRISF<1> = 0  RE1 como SALIDA
    BCF      TRISE,0,b  ;TRISF<0> = 0  RF0 como SALIDA
    BCF      ANSELE,1,b  ;TRISF<1> = 0  RE1 como Digital
    BCF      ANSELE,0,b  ;TRISF<0> = 0  RE0 como Digital
    
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,b     ;PortA<7:0> = 0 
    CLRF    ANSELA,b    ;PortA Digital
    BSF     TRISA,3,b   ;RA3 como entrada
    BSF     WPUA,3,b    ;Activamos la resistencia Pull-up del pin RA3
    RETURN
;Retardos:
Delay_500ms:
    MOVLW 245
    MOVWF Contador2,0   
Primer_loop: ; (6+8k)
    ; 2 Tcy por el call
    MOVLW	255	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop:
    NOP
    NOP
    NOP
    NOP
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop    ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop
    RETURN		    ; 2 Tcy, salta a return cuando es cero  
    
Delay_250ms:
    MOVLW 250
    MOVWF Contador2,0
    
Primer_loop1: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop1:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop1     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop1
    RETURN		    ; 2 Tcy, salta a return cuando es cero   
    
END resetVect


