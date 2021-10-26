char var[5];
void setup() {
  // Iniciliza la comunicación serial:
  Serial.begin(115200);
  
  //-Envía un ecabezado en las lecturas
  //-Se recomienda usarlo si se hará una captura
  //Serial.print("Test 1 \t");Serial.println("")
  //Serial.print('\n');
  //Serial.´println("Tension [V]");
}

void loop() {
  // Escribe la lectura del pin A0 directo al serial:
  Serial.println(analogRead(A0));
  
  //Este es el que debemos usar con el script de MatLab:
  //sprintf(var,"%04d",analogRead(A0));
  //+ %agarra la lectura del A0 
  //+ 04 siempre cuarto digitos (si la lectura es de menos cifras, ponle ceros a la izq
  // d = integer 
  //Serial.println(var); Este imprime lo de arriba


  //Frecuancia de muestreo: 
  delay(1000);
}
