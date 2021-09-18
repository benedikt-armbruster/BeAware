#include "Wire.h"
#include "Max44009.h"
#include <ArduinoJson.h>

namespace gy {
    static Max44009 myLux(0x4A, Max44009::Boolean::False);
    static bool _ready = false;
    bool begin(bool);
    void printValuesAsJson(void);
    void insertDataToJsonObject(JsonObject&);
}