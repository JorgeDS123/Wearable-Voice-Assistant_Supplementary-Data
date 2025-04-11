// Este es el código utilizado para adquirir la señal del sensor durante la captura de registros.
void setup() {
    Serial.begin(115200);
    analogReadResolution(12); // Use 12-bit ADC resolution (0-4095)
}

void loop() {
    int analogValue = analogRead(15); // Read ADC pin
    Serial.println(analogValue); // Send ADC value as a string
    delay(1); // 1 ms delay = ~1 kHz sampling rate
}
