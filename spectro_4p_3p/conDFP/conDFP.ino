// Integración de librería de Edge Impulse y DFPlayer Mini
/* Edge Impulse ingestion SDK
 * Copyright (c) 2022 EdgeImpulse Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
// If your target is limited in memory remove this macro to save 10K RAM
#define EIDSP_QUANTIZE_FILTERBANK   0
// Librería para la extracción de características y clasificación de la señal
#include <spectro_noedit_inferencing.h> 

// DFPlayer
#include <DFRobotDFPlayerMini.h>
HardwareSerial mySerial(1);  // UART1 for ESP32
DFRobotDFPlayerMini myDFPlayer;

#define DF_RX_PIN 17  // ESP32 RX -> DFPlayer TX
#define DF_TX_PIN 16  // ESP32 TX -> DFPlayer RX

// Variables para la adquisición continua cada 2 segundos
#define SAMPLE_RATE 1000
#define SAMPLE_DURATION 2
#define NUM_SAMPLES (SAMPLE_RATE * SAMPLE_DURATION)
#define SENSOR_PIN 15

static float input_data[NUM_SAMPLES]; // Buffer
static bool debug_nn = false;

// Asociación de los archivos de la tarjeta SD con sus correspondientes clases
int getAudioFileNumber(const char* label) {
    if (strcmp(label, "EB") == 0) return 6;
    if (strcmp(label, "gracias") == 0) return 4;
    if (strcmp(label, "hola") == 0) return 3;
    if (strcmp(label, "no") == 0) return 2;
    return 0;  
}

void setup() {
    Serial.begin(115200);
    analogReadResolution(12);

    // Edge Impulse setup
    ei_printf("Edge Impulse Inferencing Demo\n");
    run_classifier_init();

    // DFPlayer setup
    mySerial.begin(9600, SERIAL_8N1, DF_RX_PIN, DF_TX_PIN);
    if (!myDFPlayer.begin(mySerial)) {
        Serial.println("DFPlayer Mini not detected!");
        while (true);
    }
    myDFPlayer.volume(15);  // Establecer volumen entre 0-30
    Serial.println("DFPlayer Mini ready!");
    myDFPlayer.play(6); // Inicializar en silencio
    delay(2000);
}

void loop() {
    Serial.println("Collecting data...");
    for (int i = 0; i < NUM_SAMPLES; i++) {
        // llenar buffer con una fs = 1 kHz
        input_data[i] = (float)analogRead(SENSOR_PIN) * (3.3 / 4095.0);
        delayMicroseconds(1000);
    }

    // Comandos de la librería de Edge Impulse para llevar a cabo la clasificación
    Serial.println("Running inference...");
    signal_t signal;
    signal.total_length = NUM_SAMPLES;
    signal.get_data = &raw_adc_signal_get_data;

    ei_impulse_result_t result = {0};
    EI_IMPULSE_ERROR res = run_classifier(&signal, &result, debug_nn);
    if (res != EI_IMPULSE_OK) {
        ei_printf("ERR: Failed to run classifier (%d)\n", res);
        return;
    }

    // Identificar la clase con mayor puntaje
    const char* best_label = nullptr;
    float best_score = -1.0;
    for (size_t i = 0; i < EI_CLASSIFIER_LABEL_COUNT; i++) {
        ei_printf("    %s: ", result.classification[i].label);
        ei_printf_float(result.classification[i].value);
        ei_printf("\n");

        if (result.classification[i].value > best_score) {
            best_score = result.classification[i].value;
            best_label = result.classification[i].label;
        }
    }

#if EI_CLASSIFIER_HAS_ANOMALY == 1
    ei_printf("    Anomaly score: ");
    ei_printf_float(result.anomaly);
    ei_printf("\n");
#endif
    // reproducir el audio correspondiente a la mejor clase
    if (best_label) {
        int track = getAudioFileNumber(best_label);
        if (track > 0) {
            Serial.print("Playing track for label ");
            Serial.print(best_label);
            Serial.print(": ");
            Serial.println(track);
            myDFPlayer.play(track);
            delay(1200);
            Serial.println("Returning to EB (silence)");
            myDFPlayer.play(6);
        } else {
            Serial.print("No track mapped for label: ");
            Serial.println(best_label);
            myDFPlayer.play(6); // play silence anyways (EB)
        }
    }

    delay(500);  // Delay para la siguiente clasificación
}

// Required for Edge Impulse
static int raw_adc_signal_get_data(size_t offset, size_t length, float *out_ptr) {
    memcpy(out_ptr, &input_data[offset], length * sizeof(float));
    return 0;
}
