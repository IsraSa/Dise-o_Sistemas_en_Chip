/*
 * Practica5.c
 *
 * Created: 29/04/2024 07:04:32 p. m.
 * Author: Israel Sanchez
 *         Paulina Lopez
 *         Jose Alberto Aguilar
 */

#asm
        .equ __lcd_port=0x0B
        .equ __lcd_EN=3
        .equ __lcd_RS=2
        .equ __lcd_D4=4
        .equ __lcd_D5=5
        .equ __lcd_D6=6
        .equ __lcd_D7=7
#endasm

#include <mega328p.h>
#include <delay.h>
#include <stdio.h>
#include <display.h>
#include <stdlib.h>

unsigned int cont = 0;
char cadena[17];

void main(void)
{
    PORTC = 0x07; // Configurar los pines PC0, PC1 y PC2 como entradas (pull-up)
    SetupLCD();
    StringLCD(" People Counter");
while (1)
    {
        sprintf(cadena, "%003i", cont);
        MoveCursor(6,1);
        StringLCDVar(cadena);
        if (PINC.0 == 0){ // Si se presiona C0 ()
            cont = 0;
            while (PINC.0 == 0); // Espera a que se suelte el boton
        }
        if (PINC.1 == 0 && cont > 0){ // Si se presiona C1
            cont--;
            while (PINC.1 == 0); // Espera a que se suelte el boton
        }
        if (PINC.2 == 0 && cont < 999){ // Si se presiona C2
            cont++;
            while (PINC.2 == 0); // Espera a que se suelte el boton
        }
    }
}
