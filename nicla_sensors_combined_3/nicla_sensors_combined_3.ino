#include <Wire.h>
#include "bme.h"
#include "tcs.h"
#include "gy.h"
#include "Nicla_System.h"
#include <ArduinoJson.h>

// Entry point for the example
void setup(void)
{
  nicla::begin();
  nicla::leds.begin();
  nicla::enable3V3LDO(); // turn on 3.3V power for external sensors
  Serial.begin(115200);
  bme::begin(true);
  tcs::begin(false); // Should be initialize neverless
  gy::begin(false);
  
}
StaticJsonBuffer<512> jsonBuffer;
// Function that is looped forever
void loop(void)
{
  delay(10000);
  //if (Serial.available() > 0){
  //  Serial.read();
  
     JsonObject& root = jsonBuffer.createObject();
    tcs::insertDataToJsonObject(root.createNestedObject("tcs"));
    gy::insertDataToJsonObject(root.createNestedObject("gy"));
    bme::insertDataToJsonObject(root.createNestedObject("bme"));
    root.printTo(Serial);
    //root.prettyPrintTo(Serial);
      Serial.println("");
      jsonBuffer.clear();
  //}
  //delay(10000);
  // Don't know why, but we have to call this periodically to make sure the LDO stays on
  nicla::enable3V3LDO();
  // read serial data 
   if (Serial.available() > 0) {
     int bytes = Serial.available();
     while (bytes-- > 0) {
       Serial.read();
     }
   }
}
