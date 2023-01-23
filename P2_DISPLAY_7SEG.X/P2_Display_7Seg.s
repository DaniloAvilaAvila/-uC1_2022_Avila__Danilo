;# unp

;**Curso:** Microcontroladores I

;**Autor:** Danilo Josemaria Avila Avila

;Tarjeta: Curiosity Nano PIC18f57q84

;Entorno: MPLAB X IDE

;Lenguaje: AMS - C

;UNIVERSIDAD NACIONAL DE PIURA, PERÚ
    
PROCESSOR 18F57Q84
    
PSECT udata_acs
contador1: DS 1	    ;reserva un byte en access ram 
contador2: DS 1     ;reserva un byte en access ram
contador3: DS 1     ;reserva un byte en access ram
    
#include "BIT_CONFIG.inc"   /* config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT CODE
Main: 
   CALL	    Config_Osc,1
   CALL	    Config_Port,1
   
;BUTTON cuando esta presionado:    
   BANKSEL  PORTA
   BTFSS    PORTA,3,0	
   GOTO	    CONTEO_A_F
   
;inicia el conteo de 0 a 9
;sin presionar button
   
CONTEO_0_9:
    MOVLW   01000000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   01111001B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00100100B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00110000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00011001B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00010010B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00000011B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00111000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00000000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    MOVLW   00011000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSS   PORTA,3,0
    GOTO    CONTEO_A_F
    
    GOTO    CONTEO_0_9
    
;Inicia conteo de A-F
;Inicia cuando se presiona BUTTON
CONTEO_A_F:    
    MOVLW   00001000B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_0_9
    
    MOVLW   000000011B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_0_9
    
    MOVLW   01000110B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_0_9
    
    MOVLW   0100001B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_0_9
    
    MOVLW   00000110B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_0_9
    
    MOVLW   00001110B
    MOVWF   LATD,1
    CALL    Delay_1000ms,1
    BTFSC   PORTA,3,0
    GOTO    CONTEO_A_F
    
    GOTO    CONTEO_A_F
    
    
Config_Osc:
    ;Configuracion de un oscilador interno a una frecuencia de 4 MHz
    BANKSEL OSCCON1	
    MOVLW   0X60	;seleccionamos el bloque del osc interno con un div:1
    MOVWF   OSCCON1,1	
    MOVLW   0X02	;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1	
    RETURN   

Config_Port:	    ;PORT-LAT-ANSEL-TRIS
    ;config Led
    BANKSEL	PORTF
    CLRF	PORTF,1	    ;PORTF=0
    BSF		LATF,3,1    ;LATF<3>=1 - LED OFF
    CLRF	ANSELF,1    ;ANSELF=0
    CLRF	TRISD,0	    ;Puerto d como salida
    
    ;Config Buttom
    BANKSEL	PORTA
    CLRF	PORTA,1	    ;PORTA=0
    CLRF	ANSELA,1    ;ANSEL digital
    BSF		TRISA,3,1   ;RA3 como entrada 
    BSF		WPUA,3,1    ;Activamos la resistencia Pull-up del pin RA3
    RETURN  
    
;Inicia los tiempos    
Delay_1000ms:			
    MOVLW   4               
    MOVWF   contador3,0     
Delay_250ms:                
    MOVLW   250             
    MOVWF   contador2,0     
    
PRIMER_250ms_Loop:                  
    MOVLW   249		        
    MOVWF   contador1,0		
SEGUNDO_250ms_Loop:
    NOP			        
    DECFSZ  contador1,1,0              
    GOTO    SEGUNDO_250ms_Loop   
    DECFSZ  contador2,1,0	
    GOTO    PRIMER_250ms_Loop		
    DECFSZ  contador3,1,0
    GOTO    Delay_250ms
    RETURN                      
   
 
   
END resetVect



