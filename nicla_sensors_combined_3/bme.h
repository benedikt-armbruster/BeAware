#include "Arduino.h"
#include "BoschSensortec.h"
#include "Nicla_System.h"
#include <ArduinoJson.h>

namespace bme {
  struct bsec {
  float temperature;
  float humidity;
  float gasResistance;
  float iaq;
  float staticIaq;
  float co2Equivalent;
  float breathVocEquivalent;
  float temperature2;
uint8_t iaqAccuracy;
};
    static bsec values{0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0};
    bool begin(bool);
    void checkIaqSensorStatus(void);
    void printValuesAsJson(void);
    void insertDataToJsonObject(JsonObject&);
}