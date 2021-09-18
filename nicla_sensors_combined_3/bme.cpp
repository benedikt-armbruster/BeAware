#include "bme.h"

#define BME_ID 171
#define TEMP_ID 128

namespace bme {

void enableBSEC() {
 SensorConfigurationPacket config;
  config.sensorId = BME_ID;
  config.sampleRate = 1;
  config.latency = 0;
  sensortec.configureSensor(config);
}

void enableTemp() {
 SensorConfigurationPacket config;
  config.sensorId = TEMP_ID;
  config.sampleRate = 1;
  config.latency = 0;
  sensortec.configureSensor(config);
}

void errLeds(void) {
  nicla::leds.setColor(red);
  delay(100);
  nicla::leds.setColor(off);
  delay(100);
}

bool begin(bool initBsec) {
  if (initBsec) {
    sensortec.begin();
  }
  enableBSEC();
  //enableTemp();
  sensortec.update();
  return true;
}

void checkIAQ(float iaq) {
  if (iaq <= 50.0) {
    // Excellent
    nicla::leds.setColor(0,1, 0);
  } else if (iaq <= 100.0) {
    // Good
    nicla::leds.setColor(green);
  } else if(iaq <= 150.0) {
    // Lighty polluted
    nicla::leds.setColor(yellow);
  } else if (iaq <= 200.0) {
    // Moderate polluted
    nicla::leds.setColor(0,69,255);
  } else if (iaq <= 250.0) {
    // Heavily polluted
    nicla::leds.setColor(red);
  } else if (iaq <= 350.0) {
    // Severely polluted
    nicla::leds.setColor(magenta);
  } else {
    // Extremely polluted
    nicla::leds.setColor(255,255,255);
  }
}

void printValuesAsJson() {
  StaticJsonBuffer<256> buffer;
  JsonObject& doc = buffer.createObject();
  insertDataToJsonObject(doc);
  doc.printTo(Serial);
}

bool readBME(){
  SensorDataPacket packet {
    .sensorId = BME_ID,
    .size = 29,
    .data = {0}
  };
  if(sensortec.readSensorData(packet)){
  
  float *ptr[] = {&values.temperature, &values.humidity, &values.gasResistance, &values.iaq, &values.staticIaq, &values.co2Equivalent, &values.breathVocEquivalent};
  for(int i = 0;i<7;i++){
    *ptr[i] = packet.getFloat(i*4);
  }
  //values.temperature = packet.getFloat(0) * 0.8;
  values.iaqAccuracy = packet.getInt8(20);
  return true;
  }
  return false;

}
bool readTemp(){
  SensorDataPacket packet {
    .sensorId = TEMP_ID,
    .size = 2,
    .data = {0}
  };
  if (sensortec.readSensorData(packet)) {
  values.temperature2 = ((float)packet.getInt16(0)) * 0.008;
  return true;
  }
  return false;
}

bool receive_update(unsigned long timeout_ms) {
  unsigned long upper_bound = millis() + timeout_ms;
  do {
    sensortec.update();
    if (readBME()) {
      return true;
    }
    delay(1);
  } while(millis() < upper_bound);
  return false;
}

void insertDataToJsonObject(JsonObject& doc) {
  sensortec.update();
  // while(!readBME()){
  //   delay(1);
  //   sensortec.update();
  // } // TODO remove busy waiting
  // while(!readTemp()){
  //   sensortec.update();
  // }
 // readBME();
  //readTemp();
  if (receive_update(2500)) {
    doc["sensor"] = "bme";
    doc["success"] = true;
    doc["TEMPERATURE"] = values.temperature;
    //doc["PRESSURE"] = values.pressure;
    doc["HUMIDITY"] = values.humidity;
    doc["IAQ"] = values.iaq;
    doc["STATIC_IAQ"] = values.staticIaq;
    doc["CO2_EQUIVALENT"] = values.co2Equivalent;
    doc["BREATH_VOC_EQUIVALENT"] = values.breathVocEquivalent;
    doc["AIQ_ACCURACY"] = values.iaqAccuracy;
    //doc["TEMPERATURE2"] = values.temperature2;
    //return doc;
   checkIAQ(values.iaq);
  } else {
    doc["sensor"] = "bme";
    doc["success"] = false;
    //return doc;
  }
}

}