#include "tcs.h"

namespace tcs {
  void indicateError();
bool begin(bool initWire) {
  if (initWire) {
    Wire.begin();
    Wire.setClock(100000);
  }
  tcs_sensor = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_614MS, TCS34725_GAIN_1X);
  _ready = tcs_sensor.begin();
}

void printValuesAsJson() {
  StaticJsonBuffer<256> buffer;
  JsonObject& doc = buffer.createObject();
  insertDataToJsonObject(doc);
  doc.printTo(Serial);
}

void insertDataToJsonObject(JsonObject& doc) {
  if (!_ready) {
    doc["sensor"] = "tcs";
    doc["success"] = false;
    doc["error"] = -1;
    return;
  }
  uint16_t r, g, b, c, colorTemp, lux_tcs;
  tcs_sensor.getRawData(&r, &g, &b, &c);
  if (!(r==0&&g==0&&b==0&c==0)) {
    colorTemp = tcs_sensor.calculateColorTemperature_dn40(r, g, b, c);
    lux_tcs = tcs_sensor.calculateLux(r, g, b);
    doc["sensor"] = "tcs";
    doc["success"] = true;
    doc["r"] = r;
    doc["g"] = g;
    doc["b"] = b;
    doc["c"] = c;
    doc["colorTemp"] = colorTemp;
    doc["lux"] = lux_tcs;
    //return doc;
  } else {
    //_ready = tcs_sensor.init();
    doc["sensor"] = "tcs";
    doc["success"] = false;
    doc["error"] = -2;
    //return doc;
  }
}

}
