/*
 * Ejercicio_Serial.c
 *
 * Created: 27/05/2024 09:12:50 a. m.
 * Author: Isra
 */

#include <mega328p.h>
#include <delay.h>
#include <stdio.h>

// ADC Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
// Read Voltage=read_adc*(Vref/1024.0)
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


float volt;

unsigned int voltDigital;
unsigned char voltEnt, voltDec;


void main(void)
{

    // Verifirico apoyandonos del code Wizard, linea de la 141 a la 150
    // ADC initialization
    // ADC Clock frequency: 125.000 kHz
    // ADC Auto Trigger Source: Software
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
    // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
    // ADC4: On, ADC5: Off
    DIDR0=(1<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);


    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600 (Double Speed Mode)
    UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (1<<U2X0) | (0<<MPCM0);
    UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
    UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
    UBRR0H=0x00;
    UBRR0L=0x0C;

while (1)
      {
        voltDigital = read_adc(5);                          // Read the AD conversion result pin 5
        volt = (voltDigital * 100.0) / 1024.0;              // Convert the result to voltage (digital)
        // Ejemplo 1: 20.56°C   Ejemplo 2: 20.98°C
        voltEnt = volt;                                     // Extract the integer part
        // Ejemplo 1: 20        Ejemplo 2: 20
        volt = volt - voltEnt;                       // Extract the decimal part
        // Ejemplo 1: 0.56      Ejemplo 2: 0.98
        volt = volt * 10;
        // Ejemplo 1: 5.6       Ejemplo 2: 9.8
        volt = volt + .5;                                  // Round the decimal part
        // Ejemplo 1: 6.1         Ejemplo 2: 10.3
        if (volt<10)
          voltDec = volt;                                   // Extract the decimal part
        else{
          voltDec = 0;
          voltEnt++;                                        // Increase the integer part
        }

        //sprintf(Cadena, "%0i.%i %\n\r", voltEnt, voltDec);     // Print the result, 0XDF -> "�"
        printf("%i.%i %c \n\r", voltEnt, voltDec, 0x25);
        delay_ms(1000);
      }
}