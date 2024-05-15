// Declaracion de librerias
#include <Pololu3piPlus32U4.h>
 
using namespace Pololu3piPlus32U4;

// Declaracion de componentes
OLED display;
Buzzer buzzer;
ButtonA buttonA;
ButtonB buttonB;
ButtonC buttonC;
LineSensors lineSensors;
BumpSensors bumpSensors;
Motors motors;
Encoders encoders;

uint16_t sensorValues[5]; // Array para guardar los valores de los sensores
uint8_t muestras = 350; // Numero de muestras para calibrar
uint16_t cal_speed = 80; // Velocidad de calibracion
uint16_t prediccion = 0; // Valor de prediccion
uint16_t speed = 150; // Velocidad de seguimiento
int follow = 0;
int opcion = 0;
int select = 0;
int sum = 0;

void linea();
void calibracion();
void startMode();

void setup() {
  display.setLayout21x8(); // Configuracion de la pantalla OLED
}

void loop() {

  if (select == 0){    
    display.noAutoDisplay(); // Desactivar la actualizacion automatica de la pantalla
    display.clear(); // Limpiar la pantalla
    linea();
    delay(1000); // Esperar 1 segundo
    calibracion();
  }
  startMode();
}

void linea(){
  int sel = 0;
  while (sel == 0)
  {  
    display.gotoXY(0, 0); // Mover el cursor a la fila 0
    display.print("Color de linea"); // Mostrar mensaje de linea
    display.gotoXY(2, 2); // Mover el cursor a la fila 1
    display.print("Negra      Blanca");
    if(buttonA.isPressed()){
      opcion = 0;
      display.gotoXY(4, 3);
      display.print(".            ");
    }
    else if(buttonC.isPressed()){
      opcion = 1;
      display.gotoXY(4, 3);
      display.print("            .");
    }
    if(buttonB.isPressed()){
      buttonB.waitForRelease();
      sel = 1;
    }
    display.display(); // Actualizar la pantalla
  }
}

void calibracion(){
    // Calibramos al presionar el boton A
  motors.setSpeeds(cal_speed, -cal_speed); // Mover el robot a la velocidad de calibracion 
  display.noAutoDisplay(); // Desactivar la actualizacion automatica de la pantalla
  display.clear(); // Limpiar la pantalla
  display.print("Calibrando..."); // Mostrar mensaje de calibracion
  display.display(); // Actualizar la pantalla
  for (int i = 0; i < muestras/2 ; i++){
    lineSensors.calibrate(); // Calibrar los sensores de linea
    delay(25);
  }
 motors.setSpeeds(-cal_speed, cal_speed); // Mover el robot a la velocidad de calibracion 
  for (int i = muestras/2; i < muestras ; i++){
    lineSensors.calibrate(); // Calibrar los sensores de linea
    delay(25);
  }
  motors.setSpeeds(0, 0); // Detener el robot
  select = 1;
}

void startMode(){
    
  if (buttonB.isPressed()) {
    buttonB.waitForRelease();
    follow = 1;
  }
  if (buttonC.isPressed()) {
    buttonC.waitForRelease();
    follow = 0;
  }
  if(opcion == 0){
    prediccion = lineSensors.readLineBlack(sensorValues); // Leer el valor de prediccion
  }else{
    prediccion = lineSensors.readLineWhite(sensorValues); // Leer el valor de prediccion
  }  

  if (follow == 1){
    if (prediccion <=1950 and prediccion > 1650){
      motors.setSpeeds(speed , speed);
    }
    else if (prediccion <=2300 and prediccion > 1950){
      sum = prediccion - 2200;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed + sum, speed-sum);
    }
    else if(prediccion <= 1650 and prediccion > 1300){
      sum = 1800 - prediccion;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed-sum, speed + sum);
    }else if (prediccion > 2300){
      motors.setSpeeds(speed -5 , speed - 80);
    }
    else if (prediccion <= 1300){
      motors.setSpeeds(speed - 80 , speed -5);
    }
  }else{
    motors.setSpeeds(0,0);
  }

  lineSensors.read(sensorValues); // Leer los valores de los sensores de linea
  display.noAutoDisplay(); // Desactivar la actualizacion automatica de la pantalla
  display.clear(); // Limpiar la pantalla
  display.print(sensorValues[0]); // Mostrar el valor del sensor 0
  display.gotoXY(0, 1); // Mover el cursor a la fila 1
  display.print(sensorValues[1]); // Mostrar el valor del sensor 1
  display.gotoXY(0, 2); // Mover el cursor a la fila 2
  display.print(sensorValues[2]); // Mostrar el valor del sensor 2
  display.gotoXY(0, 3); // Mover el cursor a la fila 3
  display.print(sensorValues[3]); // Mostrar el valor del sensor 3
  display.gotoXY(0, 4); // Mover el cursor a la fila 4
  display.print(sensorValues[4]); // Mostrar el valor del sensor 4
  display.gotoXY(0, 5); // Mover el cursor a la fila 5
  display.print("Prediccion: "); // Mostrar el valor de prediccion
  display.gotoXY(0, 6); // Mover el cursor a la fila 6
  display.print(prediccion); // Mostrar el valor de prediccion
  display.display(); // Actualizar la pantalla
}
