#include "Wire.h"
#include "Adafruit_TCS34725.h"
#include <ArduinoJson.h>
#include "Nicla_System.h"

namespace tcs { 
    static Adafruit_TCS34725 tcs_sensor;
    static bool _ready = false;
    bool begin(bool);
    void printValuesAsJson(void);
    void insertDataToJsonObject(JsonObject&);
}