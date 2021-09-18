#include "gy.h"

namespace gy {
bool begin(bool initWire) {
  if (initWire) {
    Wire.begin();
    Wire.setClock(100000);
  }
  _ready = myLux.isConnected();
  if (_ready) {
    myLux.setContinuousMode();
  }
}

void printValuesAsJson() {
  StaticJsonBuffer<256> buffer;
  JsonObject& doc = buffer.createObject();
  insertDataToJsonObject(doc);
  doc.printTo(Serial);
}

void insertDataToJsonObject(JsonObject& doc) {
  //bool connected = myLux.isConnected();
  bool connected = true;
  if (_ready && connected) {
    float lux_max = myLux.getLux();
    int err = myLux.getError();
    if (err == MAX44009_OK) {
      doc["sensor"] = "gy";
      doc["success"] = true;
      doc["lux"] = lux_max;
      return;
    } else {
      doc["error"] = err;
    }
  } else {
    doc["error"] = -40;
  }
  doc["sensor"] = "gy";
  doc["success"] = false;
}

}
