// Prueba del modelo de clasificación sin el uso del DFPlayer
// If your target is limited in memory remove this macro to save 10K RAM
#define EIDSP_QUANTIZE_FILTERBANK   0
#include <spectro_noedit_inferencing.h>  // Edge Impulse model

#define SAMPLE_RATE 1000     // 1 kHz sampling rate
#define SAMPLE_DURATION 2    // 2 seconds
#define NUM_SAMPLES (SAMPLE_RATE * SAMPLE_DURATION)
//#define NUM_SAMPLES 1999
#define SENSOR_PIN 32        // Analog input pin

static float input_data[NUM_SAMPLES];  // Buffer for sensor data
static bool debug_nn = false;          // Debug flag
//float recorded_signal[NUM_SAMPLES] = {  };

void setup() {
    Serial.begin(115200);
    analogReadResolution(12); // Use 12-bit ADC resolution (0-4095)

    ei_printf("Edge Impulse Inferencing Demo\n");
    ei_printf("Sampling at %d Hz, collecting %d samples (%d seconds)\n", SAMPLE_RATE, NUM_SAMPLES, SAMPLE_DURATION);

    run_classifier_init();  // Initialize Edge Impulse classifier

    ei_printf("\nStarting continuous inference in 2 seconds...\n");
    delay(2000);
}

void loop() {
    Serial.println("Collecting data...");
    
    // Collect 2 seconds of sensor data at 1 kHz
    for (int i = 0; i < NUM_SAMPLES; i++) {
        //input_data[i] = recorded_signal[i];
        input_data[i] = (float)analogRead(SENSOR_PIN)*(3.3/4095.0); // Normalize input
        delayMicroseconds(1000); // 1 ms delay for 1 kHz sampling
    }

    Serial.println("Running inference...");
    
    // Run inference
    signal_t signal;
    signal.total_length = NUM_SAMPLES;
    signal.get_data = &raw_adc_signal_get_data;
    ei_impulse_result_t result = {0};

    EI_IMPULSE_ERROR res = run_classifier(&signal, &result, debug_nn);
    if (res != EI_IMPULSE_OK) {
        ei_printf("ERR: Failed to run classifier (%d)\n", res);
        return;
    }

    // Print predictions
    ei_printf("Predictions:\n");
    for (size_t i = 0; i < EI_CLASSIFIER_LABEL_COUNT; i++) {
        ei_printf("    %s: ", result.classification[i].label);
        ei_printf_float(result.classification[i].value);
        ei_printf("\n");
    }

#if EI_CLASSIFIER_HAS_ANOMALY == 1
    ei_printf("    Anomaly score: ");
    ei_printf_float(result.anomaly);
    ei_printf("\n");
#endif

    delay(500); // Short delay before next inference cycle
}

/**
 * Get raw ADC signal data for Edge Impulse
 */
static int raw_adc_signal_get_data(size_t offset, size_t length, float *out_ptr) {
    memcpy(out_ptr, &input_data[offset], length * sizeof(float));
    return 0;
}
