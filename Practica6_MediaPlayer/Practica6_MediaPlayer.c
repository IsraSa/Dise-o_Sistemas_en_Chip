/*
 * Practica6_MediaPlayer.c
 *
 * Created: 15/05/2024 07:30:01 p. m.
 * Author: Ingesitos en Chip
 */
#include <mega328p.h>
#include <delay.h>

/*
  Mii Channel's theme
  Connect a piezo buzzer or speaker to pin 11 or select a new pin.
  More songs available at https://github.com/robsoncouto/arduino-songs

                                              Robson Couto, 2019
*/

// Notas constantes
#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978
#define REST      0

int cambio;
// change this to make the song slower or faster
//int tempo = 114;

// change this to whichever pin you want to use
//int buzzer = 11;

// notes of the moledy followed by the duration.
// a 4 means a quarter note, 8 an eighteenth , 16 sixteenth, so on
// !!negative numbers are used to represent dotted notes,
// so -4 means a dotted quarter note, that is, a quarter plus an eighteenth!!

// -- CANCION MII -- //
flash int melodyMii[] = {
  NOTE_C5,4, //1
  NOTE_F5,4, NOTE_F5,8, NOTE_G5,8, NOTE_F5,8, NOTE_E5,8,
  NOTE_D5,4, NOTE_D5,4, NOTE_D5,4,
  NOTE_G5,4, NOTE_G5,8, NOTE_A5,8, NOTE_G5,8, NOTE_F5,8,
  NOTE_E5,4, NOTE_C5,4, NOTE_C5,4,
  NOTE_A5,4, NOTE_A5,8, NOTE_AS5,8, NOTE_A5,8, NOTE_G5,8,
  NOTE_F5,4, NOTE_D5,4, NOTE_C5,8, NOTE_C5,8,
  NOTE_D5,4, NOTE_G5,4, NOTE_E5,4,

  NOTE_F5,2, NOTE_C5,4, //8
  NOTE_F5,4, NOTE_F5,8, NOTE_G5,8, NOTE_F5,8, NOTE_E5,8,
  NOTE_D5,4, NOTE_D5,4, NOTE_D5,4,
  NOTE_G5,4, NOTE_G5,8, NOTE_A5,8, NOTE_G5,8, NOTE_F5,8,
  NOTE_E5,4, NOTE_C5,4, NOTE_C5,4,
  NOTE_A5,4, NOTE_A5,8, NOTE_AS5,8, NOTE_A5,8, NOTE_G5,8,
  NOTE_F5,4, NOTE_D5,4, NOTE_C5,8, NOTE_C5,8,
  NOTE_D5,4, NOTE_G5,4, NOTE_E5,4,
  NOTE_F5,2, NOTE_C5,4,

  NOTE_F5,4, NOTE_F5,4, NOTE_F5,4,//17
  NOTE_E5,2, NOTE_E5,4,
  NOTE_F5,4, NOTE_E5,4, NOTE_D5,4,
  NOTE_C5,2, NOTE_A5,4,
  NOTE_AS5,4, NOTE_A5,4, NOTE_G5,4,
  NOTE_C6,4, NOTE_C5,4, NOTE_C5,8, NOTE_C5,8,
  NOTE_D5,4, NOTE_G5,4, NOTE_E5,4,
  NOTE_F5,2, NOTE_C5,4,
  NOTE_F5,4, NOTE_F5,8, NOTE_G5,8, NOTE_F5,8, NOTE_E5,8,
  NOTE_D5,4, NOTE_D5,4, NOTE_D5,4,

  NOTE_G5,4, NOTE_G5,8, NOTE_A5,8, NOTE_G5,8, NOTE_F5,8, //27
  NOTE_E5,4, NOTE_C5,4, NOTE_C5,4,
  NOTE_A5,4, NOTE_A5,8, NOTE_AS5,8, NOTE_A5,8, NOTE_G5,8,
  NOTE_F5,4, NOTE_D5,4, NOTE_C5,8, NOTE_C5,8,
  NOTE_D5,4, NOTE_G5,4, NOTE_E5,4,
  NOTE_F5,2, NOTE_C5,4,
  NOTE_F5,4, NOTE_F5,4, NOTE_F5,4,
  NOTE_E5,2, NOTE_E5,4,
  NOTE_F5,4, NOTE_E5,4, NOTE_D5,4,

  NOTE_C5,2, NOTE_A5,4,//36
  NOTE_AS5,4, NOTE_A5,4, NOTE_G5,4,
  NOTE_C6,4, NOTE_C5,4, NOTE_C5,8, NOTE_C5,8,
  NOTE_D5,4, NOTE_G5,4, NOTE_E5,4,
  NOTE_F5,2, NOTE_C5,4,
  NOTE_F5,4, NOTE_F5,8, NOTE_G5,8, NOTE_F5,8, NOTE_E5,8,
  NOTE_D5,4, NOTE_D5,4, NOTE_D5,4,
  NOTE_G5,4, NOTE_G5,8, NOTE_A5,8, NOTE_G5,8, NOTE_F5,8,
  NOTE_E5,4, NOTE_C5,4, NOTE_C5,4,

  //finishes with 26
  //NOTE_FS4,8, REST,8, NOTE_A4,8, NOTE_CS5,8, REST,8, NOTE_A4,8, REST,8, NOTE_FS4,8

};

// sizeof gives the number of bytes, each int value is composed of two bytes (16 bits)
// there are two values per note (pitch and duration), so for each note there are four bytes
int notes = sizeof(melodyMii) / sizeof(melodyMii[0]) / 2;

// this calculates the duration of a whole note in ms
int wholenote = 1714;

int divider = 0, noteDuration = 0;

// -- CANCION CUMPLES -- //
flash int melodyCUM[] = {

  // Happy Birthday
  // Score available at https://musescore.com/user/8221/scores/26906

  NOTE_C4,4, NOTE_C4,8,
  NOTE_D4,-4, NOTE_C4,-4, NOTE_F4,-4,
  NOTE_E4,-2, NOTE_C4,4, NOTE_C4,8,
  NOTE_D4,-4, NOTE_C4,-4, NOTE_G4,-4,
  NOTE_F4,-2, NOTE_C4,4, NOTE_C4,8,

  NOTE_C5,-4, NOTE_A4,-4, NOTE_F4,-4,
  NOTE_E4,-4, NOTE_D4,-4, NOTE_AS4,4, NOTE_AS4,8,
  NOTE_A4,-4, NOTE_F4,-4, NOTE_G4,-4,
  NOTE_F4,-2,

};

// sizeof gives the number of bytes, each int value is composed of two bytes (16 bits)
// there are two values per note (pitch and duration), so for each note there are four bytes
int notesCUM = sizeof(melodyCUM) / sizeof(melodyCUM[0]) / 2;

// this calculates the duration of a whole note in ms
int wholenoteCUM = 1714;       //(60000 * 4) / tempo;

int dividerCUM = 0, noteDurationCUM = 0;

// -- FUNCIONES -- //
void tono (float frec)
{
    float cuentas;
    unsigned int cuentaEntera;

    DDRB.1 = 1; //PB1 de salida
    TCCR1A = 0x40;  // Timer 1 en ctc (En la salida OC1A)
    TCCR1B = 0x09;  // Con preescalador CK

    // El mciro hace la operacion
    cuentas = 500000.0 /frec;
    cuentaEntera = cuentas;
    /*
    // Redondeo 1
    if ((cuentas - cuentaEntera) >= 0.5)
        cuentaEntera ++;
    */
    // Redondeo 2
    cuentaEntera = cuentas + 0.5;
    OCR1AH = (cuentaEntera -1) / 256;
    OCR1AL = (cuentaEntera -1) % 256;
}

void noTono ()
{
    TCCR1B = 0x00; // Apaga el timer
    TCCR1A = 0x00;
    PORTB.1 = 0;
}


void main(void)
{
    PORTC = 0x03; // Pull Ups PC0 - PC3
    while (1)
    {
        // Melodia 1
        if (PINC.0 == 0)
            cambio = 0;
        if (PINC.1 == 0)
            cambio = 1;

        if (PINC.0 == 0 && cambio == 0){
            int thisNote = 0;
            for (thisNote = 0; thisNote < notes * 2; thisNote = thisNote + 2)
            {
                // calculates the duration of each note
                divider = melodyMii[thisNote + 1];

                if (divider > 0)
                {
                    // regular note, just proceed
                    noteDuration = (wholenote) / divider;
                } else if (divider < 0) {
                    // dotted notes are represented with negative durations!!
                    divider = (-1) * divider;
                    noteDuration = (wholenote) / (divider);
                    noteDuration = noteDuration * 1.5; // increases the duration in half for dotted notes
                }

                // we only play the note for 90% of the duration, leaving 10% as a pause
                tono(melodyMii[thisNote]);
                delay_ms(noteDuration * 0.9);
                noTono();
                delay_ms(noteDuration * 0.1);

                if(PINC.1 == 0){
                    cambio = 1;
                    break;
                    }
            }
        }

        // Melodia 2
        if (PINC.1 == 0 && cambio == 1)
        {
            int thisNoteA;
            for (thisNoteA = 0; thisNoteA < notesCUM * 2; thisNoteA = thisNoteA + 2)
            {
                // calculates the duration of each note
                dividerCUM = melodyCUM[thisNoteA + 1];
                if (dividerCUM > 0) {
                    // regular note, just proceed
                    noteDurationCUM = (wholenoteCUM) / dividerCUM;

                } else if (dividerCUM < 0) {
                // dotted notes are represented with negative durations!!
                dividerCUM = (-1)*dividerCUM;
                noteDurationCUM = (wholenoteCUM) / dividerCUM;
                noteDurationCUM = 1.5*noteDurationCUM; // increases the duration in half for dotted notes

                }

                tono(melodyCUM[thisNoteA]);
                delay_ms(noteDurationCUM * 0.9);
                noTono();
                delay_ms(noteDurationCUM * 0.1);

                if(PINC.0 == 0){
                    cambio = 0;
                    break;
                    }
            }
        }
    }
}
