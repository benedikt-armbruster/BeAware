#include "gy.h"
#include "Nicla_System.h"

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

void errLeds(void) {
  nicla::leds.setColor(red);
  delay(100);
  nicla::leds.setColor(off);
  delay(100);
}

void printValuesAsJson() {
  StaticJsonBuffer<256> buffer;
  JsonObject& doc = buffer.createObject();
  insertDataToJsonObject(doc);
  doc.printTo(Serial);
}
int number_of_errors = 0;

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
      number_of_errors = 0;
      return;
    } else {
      doc["error"] = err;
      errLeds();
      errLeds();
      number_of_errors++;
    }
  } else {
    doc["error"] = -40;
    errLeds();
    errLeds();
    errLeds();
    number_of_errors++;
  }
  doc["sensor"] = "gy";
  doc["success"] = false;
  // block on to many errors, so that the watchdog kicks in and resets the device
  while (number_of_errors > 50);
}

}
