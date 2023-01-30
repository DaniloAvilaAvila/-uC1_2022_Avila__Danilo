;# unp

;**Curso:** Microcontroladores I

;**Autor:** Danilo Josemaria Avila Avila

;Tarjeta: Curiosity Nano PIC18f57q84

;Entorno: MPLAB X IDE

;Lenguaje: AMS - C

;UNIVERSIDAD NACIONAL DE PIURA, PERÚ
    
PROCESSOR 18F57Q84
#include "BIT_CONFIG.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>

PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit1
Leds_on1:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO    Reload
Exit1:
    RETFIE
PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT2?
    GOTO    Exit2  
Leds:
    BCF	    PIR10,0,0	; limpiamos el flag de INT2
    GOTO    Exit2
Exit2:
    RETFIE    

PSECT udata_acs
Contador1:  DS 1	    
Contador2:  DS 1
offset:	    DS 1
offset1:    DS 1
counter:    DS 1
counter1:   DS 1 
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2
    CALL    Secuencia
toggle:
   BTG	   LATF,3,0
   CALL    Delay_500ms,1
   BTG	   LATF,3,0
   CALL    Delay_500ms,1
   goto	   toggle

Loop:
    BSF	    LATF,3,0	   
    BANKSEL PCLATU
    MOVLW   low highword(Secuencia)
    MOVWF   PCLATU,1
    MOVLW   high(Secuencia)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    Secuencia
    MOVWF   LATC,0
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0
    GOTO    Next_Seq
    
Verifica:
    DECFSZ  counter1,1,0
    GOTO    Reload2
    Goto    OFF
    
 Next_Seq:
    INCF    offset,1,0
    GOTO    Loop
    
Reload:
    MOVLW   0x05	
    MOVWF   counter1,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    
Reload2:
    MOVLW   0x0A	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    GOTO    Loop  
    
    
Config_OSC:
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
OFF:
    NOP
    
Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    BSF	    LATF,2,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    BCF	    TRISF,2,1
    
    ;Button RA3
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;Button RB4
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF     WPUB,4,1
    
    
    ;BUTTON RF2
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1
    BSF     WPUF,2,1
   
    
    ;Config PORTC
    BANKSEL PORTC
    CLRF    PORTC,1	
    CLRF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
    
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03        ;03=RA3
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C        ;C=RB4
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A        ;2A=RF2
    MOVWF   INT2PPS,1   ; INT2--> RF2
    
    RETURN
    
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    BSF IPR10,0,1   ; IPR1<INT2IP> = 1 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF INTCON0,0 ; INT2 por flanco de bajada 
    BCF PIR10,0,0  ; limpiamos el flag de interrupcion
    BSF PIE10,0,0  ; habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
   
Secuencia:
    ADDWF   PCL,1,0
    RETLW   10000001B	; RCO-RC7 0 INICIA LA PRIMERA SECUENCIA
    RETLW   01000010B	; RC1-RC6 
    RETLW   00100100B	; RC2-RC5 
    RETLW   00011000B	; RC3-RC4 
    RETLW   00000000B	; APAGAMOS TODO
    RETLW   00011000B	; RC3-RC4 INICIA LA SEGUNDA SECUENCIA
    RETLW   00100100B	; RC2-RC5
    RETLW   01000010B	; RC1-RC6
    RETLW   10000001B	; RC0-RC7
    RETLW   00000000B	; APAGAMOS TODO
    

;Bloque de Retardos   

Delay_250ms:		    ; 2Tcy -- Call
    MOVLW   250		    ; 1Tcy -- k2
    MOVWF   Contador2,0	    ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		    ; 1Tcy -- k1
    MOVWF   Contador1,0	    ; 1Tcy
Int_Loop:
    NOP			    ; k1*Tcy
    DECFSZ  Contador1,1,0   ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	    ; (k1-1)*2Tcy
    DECFSZ  Contador2,1,0
    GOTO    Ext_Loop
    RETURN		    ; 2Tcy
    
Delay_500ms:
    MOVLW 245
    MOVWF Contador2,0   
Primer_loop: ; (6+8k)
    ; 2 Tcy por el call
    MOVLW	255	    
    MOVWF	Contador1,0 
segundo_loop:
    NOP
    NOP
    NOP
    NOP
    NOP			    
    DECFSZ Contador1,1,0   
    GOTO   segundo_loop    
    DECFSZ Contador2,1,0    
    GOTO   Primer_loop
    RETURN		         
   
End resetVect

