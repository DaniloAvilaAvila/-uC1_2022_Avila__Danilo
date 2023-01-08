;# unp

;**Curso:** Microcontroladores I

;**Autor:** Danilo Josemaria Avila Avila

;Tarjeta: Curiosity Nano PIC18f57q84

;Entorno: MPLAB X IDE

;Lenguaje: AMS - C

;UNIVERSIDAD NACIONAL DE PIURA, PERÚ

;El codigo creado,esta diseñado para crear retardos en intervalos de tiempo ya establecidos.

PSECT udata_acs
Contador1: DS 1		;se reserva 1 byte en acces ram
Contador2: DS 1         ; se reserva 1 byte en acces ram
 ;Inicia los retardos con microsegundos
 
PSECT code	
 
Delay_10us: ; (6+4k)
        ; 2 Tcy por el call
    MOVLW	1	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+Tcy
    GOTO   Delay_Loop	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero
    
Delay_25us: ;(7+3k)
    ; 2 tcy
    NOP                     ; 1 Tcy
    MOVLW	6	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop2:
    DECFSZ Contador1,1,0    ; +3Tcy
    GOTO   Delay_Loop2	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero
 
Delay_50us: ;(6+4k)
    ; 2 tcy
    MOVLW	11	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop3:
    NOP                     ; k*Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   Delay_Loop3	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero
Delay_100us: ;(7+3k)
    ; 2 tcy
    NOP                     ; 1 Tcy
    MOVLW	31	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop4:
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   Delay_Loop4	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero
Delay_200us: ;(8+4k)
    ; 2 tcy
    NOP                     ; 1 Tcy
    NOP                     ; 1 Tcy
    MOVLW 48		    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop5:
    NOP                     ;k*1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   Delay_Loop5	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero
    
Delay_250us:;(6+4k)		   
    ; 2 tcy 
    MOVLW	61	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop6:
    NOP                     ; k*Tcy
    DECFSZ Contador1,1,0    ; (k-1)+ 3Tcy
    GOTO   Delay_Loop6   ; (k-1)*Tcy
    RETURN		    ; 2 Tcy

Delay_500us: ;(8+4k)
    ; 2 tcy
    NOP                     ; 1 Tcy
    NOP                     ; 1 Tcy
    MOVLW 123		    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop7:
    NOP
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   Delay_Loop7	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero

;Inicia los retardos en milisengundos
;Implementamos los milisegundos con bucles añidados(5ms,10ms,25ms,50ms,100ms,200ms,250ms)
    
Delay_1ms: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
Delay_Loop1ms:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+Tcy
    GOTO   Delay_Loop1ms	    ; (k-1)*Tcy, salta a goto cuando no es cero
    RETURN		    ; 2 Tcy, salta a return cuando es cero   
Delay_5ms:
    MOVLW 250
    MOVWF Contador2,0
    
Primer_loop: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop
    RETURN	; 2 Tcy, salta a return cuando es cero   
Delay_10ms:
    MOVLW 10
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
Delay_25ms:
    MOVLW 25
    MOVWF Contador2,0
    
Primer_loop2: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop2:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop2     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop2
    RETURN		    ; 2 Tcy, salta a return cuando es cero  
Delay_50ms:
    MOVLW 50
    MOVWF Contador2,0
    
Primer_loop3: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop3:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop3     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop3
    RETURN		    ; 2 Tcy, salta a return cuando es cero  
Delay_100ms:
    MOVLW 100
    MOVWF Contador2,0
    
Primer_loop4: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop4:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop4     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop4
    RETURN		    ; 2 Tcy, salta a return cuando es cero  
Delay_200ms:
    MOVLW 200
    MOVWF Contador2,0
    
Primer_loop5: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop5:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop5     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop5
    RETURN		    ; 2 Tcy, salta a return cuando es cero      
Delay_250ms:
    MOVLW 250
    MOVWF Contador2,0
    
Primer_loop6: ; (6+4k)
    ; 2 Tcy por el call
    MOVLW	249	    ; 1 Tcy
    MOVWF	Contador1,0 ; 1 Tcy
segundo_loop6:
    NOP			    ; 1 Tcy
    DECFSZ Contador1,1,0    ; (k-1)+3Tcy
    GOTO   segundo_loop6     ; (k-1)*Tcy, salta a goto cuando no es cero
    DECFSZ Contador2,1,0    ; (k-1)+3Tcy
    GOTO   Primer_loop6
    RETURN		    ; 2 Tcy, salta a return cuando es cero      
     
