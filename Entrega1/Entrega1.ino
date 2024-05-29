///////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracion de librerias                                                                          //
#include <Pololu3piPlus32U4.h>                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////
using namespace Pololu3piPlus32U4;                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////
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

uint16_t sensorValues[5];             // Array para guardar los valores de los sensores
uint8_t muestras = 350;               // Numero de muestras para calibrar
uint16_t cal_speed = 80;              // Velocidad de calibracion
uint16_t prediccion = 0;              // Valor de prediccion
uint16_t speed = 100;                 // Velocidad de seguimiento
uint16_t posibilidades[3] = {0,0,0};  // Arreglo utilizado para la toma de desiciones en las vueltas

// Variables adiciones
// Se comprenderán mejor posteriormente en las funciones
int follow = 0;                       // Permitirá iniciar a recorrer el laberinto
int opcion = 0;                       // Nos indicará el color de linea a seguir
int select = 0;                       // Permitirá realizar solamente 1 vez la calibración
int sum = 0;                          // Velocidad adicional a añadir como compensación
int ajuste = 0;                       // Nos indicará si se deberá de dar una vuelta
//int stop = 0;                       // En el siguiente avance nos permitirá detener al pololu en la
                                      // meta, por el momento no se ocupa, pero nos servira más
                                      // adelante
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Funciones para el desarrollo de nuestro Pololu
// más adelante se explicará cada una, para no entrar en detalles en este momento
void linea();
void calibracion();
void startMode();
void caminos();
void startMode();
void start_dist();
void ruta();
void start_ang(int, int, int);
void finish();
////////////////////////////////////////////////////////////////////////////////////////////////////
// Inicialización de la pantalla OLED
void setup() {
  display.setLayout21x8(); // Configuracion de la pantalla OLED
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Ejecución principal de nuestro código (main)
// donde se manda a llamar las funciones como linea, calibración, startMode y camino
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
////////////////////////////////////////////////////////////////////////////////////////////////////
// Esta función es la que se encarga de ajustar la calibración de nuestros sensores seguidores de
// linea, para que pueda ajustar dependiendo de la pista, además una vez terminada la calibración
// ya no se ejecutará nuevamente
void calibracion(){
  // Calibramos al presionar el boton A
  motors.setSpeeds(cal_speed, -cal_speed);      // Mover el robot a la velocidad de calibracion 
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
  select = 1;             // Aquí select nos sirve para que en el void loop, no sé ejecute
                          // calibrar más de una vez
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Nos muestra si los sensores han encontrado un posible camino, dependiendo de un rango que 
// nosotros definimos, dando un 1 en presencia de un camino detectado (izquierda y/o derecha y/o en
// frente) al igual que detectar cuando se ha salido de dicho camino, dando como valor un 0, de 
// esta forma nosotros guardamos el valor en posibilidades[] para que justamente nos muestre cuáles
// son los posibles caminos que podría tomar, y dependiendo de que algoritmo (mano izquierda o 
// derecha) siga, pueda resolver el laberinto, nos desplegará en la pantalla no solamente cuando un
// sensor es detectado, sino también, los valores de los sensores, los cuales van en una escala del 
// 0 al 1000, siendo 0 detectando blanco o 1000 en presencia del negro.
void camino(){
  char buffer[10];    // Nos servirá para poder imprimir el valor de posibilidad en una cadena
  display.noAutoDisplay();
  display.clear();
  // Si es que se eligió que siguiera línea negra:
  if(opcion == 0){
    lineSensors.readLineBlack(sensorValues); // Leer el valor de prediccion
    //  Ajuste en la sensibilidad del sensor izquierdo
      if(sensorValues[0] > 200){
        display.gotoXY(0,4);
        display.print("IZQ");
        posibilidades[0] = 1;
      }else{
        posibilidades[0] = 0;
      }
    // Ajuste en la sensibilidad del sensor derecho
      if(sensorValues[4] > 200){
        display.gotoXY(18,4);
        display.print("DER");
        posibilidades[2] = 1;
      }else{
        posibilidades[2] = 0;
      }
    // Ajuste en la sensibilidad del sensor de en frente
      if(sensorValues[2] > 100){
        display.gotoXY(10,0);
        display.print("FORW");
        posibilidades[1] = 1;
      }else{
        posibilidades[1] = 0;
      }
  }
  // Aquí se ajustaron las sensibilidades si es que el usuario eligió que se siguiera
  // una línea blanca
  else{
    lineSensors.readLineWhite(sensorValues); // Leer el valor de prediccion
    //  Ajuste en la sensibilidad del sensor izquierdo
    if(sensorValues[0] <= 580){
      display.gotoXY(0,4);
      display.print("IZQ");
      display.gotoXY(0,5);
      display.print(sensorValues[0]);
      posibilidades[0] = 1;
    }else{
      posibilidades[0] = 0;
    }
    //  Ajuste en la sensibilidad del sensor derecho
    if(sensorValues[4] <= 580){
      display.gotoXY(18,4);
      display.print("DER");
      display.gotoXY(18,5);
      display.print(sensorValues[4]);
      posibilidades[2] = 1;
    }else{
      posibilidades[2] = 0;
    }
    //  Ajuste en la sensibilidad del sensor en frente
    if(sensorValues[2] < 680){
      display.gotoXY(10,0);
      display.print("FORW");
      display.gotoXY(11,1);
      display.print(sensorValues[2]);
      posibilidades[1] = 1;
    }else{
      posibilidades[1] = 0;
    }
  } 
  // Imprimir lectura de los sensores al igual que posibilidades, para saber la presencia
  // de algún posible camino
  display.gotoXY(0,5);
  display.print(sensorValues[0]);
  display.gotoXY(17,5);
  display.print(sensorValues[4]);
  display.gotoXY(11,1);
  display.print(sensorValues[2]);
  display.gotoXY(7, 7);
  sprintf(buffer, "(%d, %d, %d)", posibilidades[0], posibilidades[1], posibilidades[2]);
  display.print(buffer);
  display.display();
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// En esta función se hace la selección del color de línea que seguira nuestro robot, ya sea blanca
// o negra, se despliega en ese momento en pantalla las posibilidades, al igual que cuál opcion está 
// eligiendo, para evitar posibles errores, el color por defecto es seguidor de líneas negras
void linea(){
  int sel = 0;
  while (sel == 0)
  {  
    display.gotoXY(0, 0); // Mover el cursor a la fila 0
    display.print("Color de linea"); // Mostrar mensaje de linea
    display.gotoXY(2, 2); // Mover el cursor a la fila 1
    display.print("Negra      Blanca");
    // El botón A se deberá de presionar para que elija seguir una línea negra
    if(buttonA.isPressed()){
      opcion = 0;
      display.gotoXY(4, 3);
      display.print(".            ");
      //stop = 1000;
    }
    // El botón C se deberá de presionar para que elija seguir una línea blanca
    else if(buttonC.isPressed()){
      opcion = 1;
      display.gotoXY(4, 3);
      display.print("            .");
      //stop = 0;
    }
    // El botón B se deberá de presionar para poder avanzar cuando ya se haya elegido el color
    // de línea a seguir.
    if(buttonB.isPressed()){
      buttonB.waitForRelease();
      sel = 1;
    }
    display.display(); // Actualizar la pantalla
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Será quien ejecute el avance de nuestro robot, al igual que correción para evitar que se salga
// de la línea, pero sin que se note bruscamente esta corrección, será en dónde se tome la decisión
// de cuál camino deberá tomar, dependiendo de las posibilidades que tenemos en el momento
void startMode(){
  // Se presiona el Botón B para poder iniciar la ejecución de nuestro Pololu
  if (buttonB.isPressed()) {
    buttonB.waitForRelease();
    follow = 1;
  }
  // Se presiona el boton C para detener la ejecucón de nuestro Pololu
  if (buttonC.isPressed()) {
    buttonC.waitForRelease();
    follow = 0;
  }
  // Se selecciona qué color de línea deberá de seguir para hacer la predicción de en dónde se
  // encuentra la línea, dependiendo del color, esto ya que en otra función se ha elegido el color
  // no hace falta hacer la selección nuevamente.
  if(opcion == 0){
    prediccion = lineSensors.readLineBlack(sensorValues); // Leer el valor de prediccion
  }else{
    prediccion = lineSensors.readLineWhite(sensorValues); // Leer el valor de prediccion
  }  
  // Ajuste en el avance del robot, para evitar que se salga abruptamente de la línea
  if(follow == 1 && posibilidades[0] == 0 && posibilidades[1] == 1 && posibilidades[2] == 0){
    ajuste = 1;
    if (prediccion <=2000 and prediccion > 1800){
      motors.setSpeeds(speed , speed);
    }
    else if (prediccion <=2500 and prediccion > 2000){
      sum = prediccion - 2000;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed + sum, speed-sum);
    }
    else if(prediccion <= 1800 and prediccion > 1300){
      sum = 1800 - prediccion;
      sum = (sum / 50 )*5;
      motors.setSpeeds(speed-sum, speed + sum);
    }
  }
  // En un dado caso que se detecten o no, más caminos, se tomará la decisión si deberá dar
  // una vuelta de 90 grados y en qué sentido, o si debera de dar una vuelta de 180 grados.
  else{
    motors.setSpeeds(0,0);
    if(follow == 1 && ajuste ==1){
      delay(25);                   // Delay a modificar
      camino();
      finish();
      motors.setSpeeds(30, 30);   // Delay para mejorar vuelta
      delay(160);
      motors.setSpeeds(0, 0);       // Delay a modificar
      delay(15);
      ruta();
      ajuste = 0;
    }
  }
  display.gotoXY(7, 6);
  display.print(prediccion);
  display.display();
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Nos servirá para una de las decisiones que deberá tomar nuestro robot, cuando encuentre un camino
// recto o encuentra una intersección a la izquierda, por lo que avanará un poco más para ignorar la
// intersección y seguir su camino (en este caso porque estamos usando el algoritmo de mano derecha)
void start_dist(){
  float dist_actual = 0; // Distancia actual
  float pos_left = 0;
  float pos_right = 0;
  // Debemos de limpiar los encoders, de lo contrario, no avanzará lo que nosotros deseamos, porque
  // los encoders tendrán ya una distancia guardada.
  encoders.getCountsAndResetLeft();
  encoders.getCountsAndResetRight();
  while (dist_actual < .8)
  {
    pos_left = float(encoders.getCountsAndResetLeft()); // Se obtiene la posición del motor  
                                                        // izquierdo y se reinicia el contador 
    pos_left *= (1/12.0);   // Se convierte la posición a vueltas (1 vuelta = 12 pulsos)
    pos_left *= (1/29.86);  // Se convierte la posición de vultas de motor a vueltas de rueda 
                            // (1 vuelta de motor = 29.86 vueltas de rueda)
    pos_left *= (10.0531);  // Se convierte de revoluciones de la rueda a grados (1 revolución 
                            // = 360 grados)
    // Se obtiene la posición del motor derecho y se reinicia el contador
    pos_right = float(encoders.getCountsAndResetRight()) * (1/12.0) * (1/29.86) * (10.0531); 
    // Calcular la ditancia actual
    dist_actual = dist_actual + ((pos_right + pos_left)/2);
    motors.setSpeeds(speed-20, speed-20);
  }
  motors.setSpeeds(0, 0);
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Decide en qué sentido y cuántos grados girará, dependiendo de los caminos posibles, no utilizamos
// por completo 90° o 180° porque debido a la velocidad se pasaba, entonces compensando esos grados 
// de más por la velocidad de las vueltas, se logran los 90° o 180°, mandando llamar a la función
// start_ang, aquí solamente se decide cuánto y a qué velocidad girar dependiendo de los casos
void ruta(){
  // Gira en sentido de las manecillas del reloj 90°
  if(posibilidades[0] == 1 && posibilidades[2] == 1){
    start_ang(80,70,-70);
  }
  // Gira en sentido de las manecillas del reloj 90°
  else if(posibilidades[2] == 1){
    start_ang(80,70,-70);
  }
  // Gira en contra del sentido de las manecillas del reloj 90° si solamente hay camino a la izquierda
  // peri si hay camino para en frente da prioridad a ello
  else if(posibilidades[0] == 1){
    if(posibilidades[1] == 1){
      start_dist();
    }
    else{
      start_ang(80,-70,70);
    }
  }
  // Gira en sentido de las manecillas del reloj 180°
  else if(posibilidades[0] == 0 && posibilidades[1] == 0 && posibilidades[2] == 0){
    start_ang(165,70,-70);
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// Esta función es quien hace girar a nuestro robot los grados correspondientes a la velocidad 
// correspondiente que nos da ruta()
void start_ang(int angulo, int izq, int der){
  float ang_actual = 0; // Distancia actual
  float pos_left = 0;   // Posición encoder izquierdo
  float pos_right = 0;  // posición encoder derecho
  float radio = 1.6;    // Radio de las ruedas
  float len = 8.8;      // Longitud entre ruedas
  float error;
  // Se deben resetear los encoder antes de utilizarlo, para evitar que tengan algún dato anterior
  // Y evitar que no gira la distancia deseada
  encoders.getCountsAndResetLeft();
  encoders.getCountsAndResetRight();
  while (ang_actual < angulo)
  {
    pos_left = float(encoders.getCountsAndResetLeft()); // Se obtiene la posición del motor 
                                                        // izquierdo y se reinicia el contador 
    pos_left *= (1/12.0); // Se convierte la posición a vueltas (1 vuelta = 12 pulsos)
    pos_left *= (1/29.86); // Se convierte la posición de vultas de motor a vueltas de rueda 
                           // (1 vuelta de motor = 29.86 vueltas de rueda)
    pos_left *= (360.0/1.0); // Se convierte de revoluciones de la rueda a grados (1 revolución 
                              // = 360 grados)
    //pos_right = encoders.getCountsRight(); // Se obtiene la posición del motor derecho
    // Se obtiene la posición del motor derecho y se reinicia el contador
    pos_right = float(encoders.getCountsAndResetRight()) * (1/12.0) * (1/29.86) * (360.0/1.0); 
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
////////////////////////////////////////////////////////////////////////////////////////////////////
// Una vez que llega a la meta final nuestro Robot, avanzará un poco más, y empezará a girar a gran
// velocidad en sentido de las manecillas del reloj, a modo de celebración para indicar que ha
// llegado a la meta, esto se hace verificando el valor de los 5 sensores seguidores de línea, a 
// diferencia de las otras funciones que solamente ocupaba de posibilidades[] el cual estaba dado
// por 3 sensores, ya que necesitamos verificar que todos indiquen que están sensando el color de 
// la meta
void finish(){
  // Se imprime en la pantalla el valor de los 5 sensores, para la visualización de qué valor sensan
  // y que podamos verificar que efectivamente, se ha llegado a la meta en un dado caso que si, o 
  // si solamente pasó por una intersección
  display.noAutoDisplay();
  display.clear();
  display.gotoXY(0, 0);
  display.print(sensorValues[0]);
  display.gotoXY(0, 1);
  display.print(sensorValues[1]);
  display.gotoXY(0, 2);
  display.print(sensorValues[2]);s
  display.gotoXY(0, 3);
  display.print(sensorValues[3]);
  display.gotoXY(0, 4);
  display.print(sensorValues[4]);
  if(sensorValues[0] <= 50 && sensorValues[1] <= 50 && sensorValues[2] <= 50 && sensorValues[3] <= 50 && sensorValues[4] <= 50){
    motors.setSpeeds(30, 30);
    delay(1000);
    while(1){
      motors.setSpeeds(200,-200);
    }
  }
  display.display();
}