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
uint16_t speed = 100; // Velocidad de seguimiento
uint16_t posibilidades[3] = {0,0,0}; // Posibilidades
int follow = 0;
int opcion = 0;
int select = 0;
int sum = 0;
int ajuste = 0;

void linea();
void calibracion();
void startMode();
void caminos();
void startMode();
void start_dist();
void ruta();
void start_ang(int, int, int);

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
  camino();
  startMode();

}
// Nos muestra si los sensores han encontrado un posible camino
void camino(){
  char buffer[10];
  display.noAutoDisplay();
  display.clear();

  if(opcion == 0){
    lineSensors.readLineBlack(sensorValues); // Leer el valor de prediccion
    //  IZQ
      if(sensorValues[0] > 100){
        display.gotoXY(0,4);
        display.print("IZQ");
        posibilidades[0] = 1;
      }else{
        posibilidades[0] = 0;
      }
    // DER
      if(sensorValues[4] > 100){
        display.gotoXY(18,4);
        display.print("DER");
        posibilidades[2] = 1;
      }else{
        posibilidades[2] = 0;
      }
    // FORW
      if(sensorValues[2] > 100){
        display.gotoXY(10,0);
        display.print("FORW");
        posibilidades[1] = 1;
      }else{
        posibilidades[1] = 0;
      }
  }else{
    lineSensors.readLineWhite(sensorValues); // Leer el valor de prediccion
    //  IZQ
    if(sensorValues[0] < 400){
      display.gotoXY(0,4);
      display.print("IZQ");
      display.gotoXY(0,5);
      display.print(sensorValues[0]);
      posibilidades[0] = 1;
    }else{
      posibilidades[0] = 0;
    }
  // DER
    if(sensorValues[4] < 400){
      display.gotoXY(18,4);
      display.print("DER");
      display.gotoXY(18,5);
      display.print(sensorValues[4]);
      posibilidades[2] = 1;
    }else{
      posibilidades[2] = 0;
    }
  // FORW
    if(sensorValues[2] < 400){
      display.gotoXY(10,0);
      display.print("FORW");
      display.gotoXY(11,1);
      display.print(sensorValues[2]);
      posibilidades[1] = 1;
    }else{
      posibilidades[1] = 0;
    }
  } 
  display.gotoXY(0,5);
  display.print(sensorValues[0]);
  display.gotoXY(18,5);
  display.print(sensorValues[4]);
  display.gotoXY(11,1);
  display.print(sensorValues[2]);
  display.gotoXY(7, 7);
  sprintf(buffer, "(%d, %d, %d)", posibilidades[0], posibilidades[1], posibilidades[2]);
  display.print(buffer);
  display.display();
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

  if(follow == 1 && posibilidades[0] == 0 && posibilidades[1] == 1 && posibilidades[2] == 0){
    ajuste = 1;
    if (prediccion <=2000 and prediccion > 1800){
      motors.setSpeeds(speed , speed);
    }
    else if (prediccion <=2300 and prediccion > 2000){
      sum = prediccion - 2000;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed + sum, speed-sum);
    }
    else if(prediccion <= 1800 and prediccion > 1500){
      sum = 1800 - prediccion;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed-sum, speed + sum);
    }
  }
  else{
    motors.setSpeeds(0,0);
    if(follow == 1 && ajuste ==1){
      delay(500);
      start_dist();
      ruta();
      ajuste = 0;
    }
  }
  display.gotoXY(7, 6);
  display.print(prediccion);
  display.display();
}

void start_dist(){
  float dist_actual = 0; // Distancia actual
  float pos_left = 0;
  float pos_right = 0;
  encoders.getCountsAndResetLeft();
  encoders.getCountsAndResetRight();
  while (dist_actual <0.6)
  {
    pos_left = float(encoders.getCountsAndResetLeft()); // Se obtiene la posición del motor izquierdo y se reinicia el contador 
    pos_left *= (1/12.0); // Se convierte la posición a vueltas (1 vuelta = 12 pulsos)
    pos_left *= (1/29.86); // Se convierte la posición de vultas de motor a vueltas de rueda (1 vuelta de motor = 29.86 vueltas de rueda)
    pos_left *= (10.0531); // Se convierte de revoluciones de la rueda a grados (1 revolución = 360 grados)
    //pos_right = encoders.getCountsRight(); // Se obtiene la posición del motor derecho
    pos_right = float(encoders.getCountsAndResetRight()) * (1/12.0) * (1/29.86) * (10.0531); // Se obtiene la posición del motor derecho y se reinicia el contador
    // Calcular la ditancia actual
    dist_actual = dist_actual + ((pos_right + pos_left)/2);
    motors.setSpeeds(speed-30, speed-30);
  }
  motors.setSpeeds(0, 0);
}

// Decide a donde se va a mover dependiendo de los caminos posibles

void ruta(){
  if(posibilidades[0] == 1 && posibilidades[2] == 1){
    start_ang(80,40,-40);
  }
  else if(posibilidades[2] == 1){
    start_ang(80,40,-40);
  }
  else if(posibilidades[0] == 1){
    if(posibilidades[1] == 1){
      start_dist();
    }
    else{
      start_ang(80,-40,40);
    }
  }
  else if(posibilidades[0] == 0 && posibilidades[1] == 0 posibilidades[2] == 0){
    start_ang(170,40,-40);
  }
}

void start_ang(int angulo, int izq, int der){
  float ang_actual = 0; // Distancia actual
  float pos_left = 0;
  float pos_right = 0;
  float radio = 1.6; // Radio de las ruedas
  float len = 8.8; // Longitud entre ruedas
  float error;
  encoders.getCountsAndResetLeft();
  encoders.getCountsAndResetRight();
  while (ang_actual < angulo)
  {
    pos_left = float(encoders.getCountsAndResetLeft()); // Se obtiene la posición del motor izquierdo y se reinicia el contador 
    pos_left *= (1/12.0); // Se convierte la posición a vueltas (1 vuelta = 12 pulsos)
    pos_left *= (1/29.86); // Se convierte la posición de vultas de motor a vueltas de rueda (1 vuelta de motor = 29.86 vueltas de rueda)
    pos_left *= (360.0/1.0); // Se convierte de revoluciones de la rueda a grados (1 revolución = 360 grados)
    //pos_right = encoders.getCountsRight(); // Se obtiene la posición del motor derecho
    pos_right = float(encoders.getCountsAndResetRight()) * (1/12.0) * (1/29.86) * (360.0/1.0); // Se obtiene la posición del motor derecho y se reinicia el contador
    // Calcular el ángulo de giro
    if(izq > 0){
      ang_actual = ang_actual + (radio*((pos_left - pos_right)/len)); // Se calcula el ángulo de giro en grados
    }
    else{
      ang_actual = ang_actual + (radio*((pos_right - pos_left)/len)); // Se calcula el ángulo de giro en grados
    }
    error = angulo - ang_actual; // Se calcula el error
    if (error > 2){
      motors.setSpeeds(izq,der); // Se gira a la derecha
    }
    else{
      motors.setSpeeds(0, 0); // No hace nada
    }
  }
  ang_actual = 0;
}





















