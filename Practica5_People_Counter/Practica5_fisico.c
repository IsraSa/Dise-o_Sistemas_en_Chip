/*
 * Contador_de_gente.c
 *
 * Created: 29/04/2024 07:22:48 p. m.
 * Author: LENOVO
 */    
 
        #asm
        .equ __lcd_port = 0x0B
        .equ __lcd_EN=3
        .equ __lcd_RS=2
        .equ __lcd_D4=4
        .equ __lcd_D5=5
        .equ __lcd_D6=6
        .equ __lcd_D7=7
       #endasm  

// Librerias //
#include <mega328p.h>
#include <delay.h>
#include <stdio.h>
#include <display.h>
#include <stdlib.h>

// VARIABLES //
unsigned int cont = 0; // Contador
char cadena[17];       // Cadena Auxiliar

void main(void)
{
    // Entradas Pull-up
    PORTC = 0x07;       
    // Configuracion LCD
    SetupLCD();
    StringLCD(" People Counter ");   
    while (1)
    {   
        sprintf(cadena, "%003i",cont);
        MoveCursor(6,1);        
        StringLCDVar(cadena);  
        // Reinicio        
        if (PINC.0 == 0)     
        {
            cont = 0; 
            delay_us(1250);      
        }
        // Menos
        if (PINC.1 == 0 && cont > 0)
        {
            cont -= 1;      
            delay_us(1250);   
        }
        // Mas
        if (PINC.2 == 0 && cont < 999)     
        {
            cont += 1;  
            delay_us(1250);   
        }
        // Configuracion rebote de botones 
        while (PINC.0 == 0);
        {
          delay_ms(10);  
        }
        while (PINC.1 == 0);
        {
            delay_ms(10);
        }
        while (PINC.2 == 0);
        {
            delay_ms(10);
        }   
        
    }  // End while
}
