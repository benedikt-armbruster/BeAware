from pyhap.accessory import Bridge
from pyhap.accessory_driver import AccessoryDriver
import signal
import threading

from hka.accessories import TemperatureSensor, HumiditySensor, LightSensor, AirQualitySensor


class HKServer:

    def start1(self):
        handler = {'bme': {}, 'tcs': {}, 'gy': {}}
        driver = AccessoryDriver(port=51826)

        temp_acc = TemperatureSensor(driver, 'Temperature')
        driver.add_accessory(accessory=temp_acc)
        handler['bme']['TEMPERATURE'] = temp_acc.set_value

        hum_acc = HumiditySensor(driver, 'Humidity')
        driver.add_accessory(accessory=hum_acc)
        handler['bme']['HUMIDITY'] = hum_acc.set_value

        signal.signal(signal.SIGTERM, driver.signal_handler)

        threading.Thread(target=driver.start, daemon=True).start()

        return handler

    def start(self):
        handler = {'bme': {}, 'tcs': {}, 'gy': {}}
        driver = AccessoryDriver(port=51826)
        bridge = Bridge(driver, 'Nicla')

        temp_acc = TemperatureSensor(driver, 'Temperature')
        bridge.add_accessory(temp_acc)
        handler['bme']['TEMPERATURE'] = temp_acc.set_value

        hum_acc = HumiditySensor(driver, 'Humidity')
        bridge.add_accessory(hum_acc)
        handler['bme']['HUMIDITY'] = hum_acc.set_value

        light_acc = LightSensor(driver, 'LightSensor')
        bridge.add_accessory(light_acc)
        handler['gy']['lux'] = light_acc.set_value

        aiq_acc = AirQualitySensor(driver, 'AirQualitySensor')
        bridge.add_accessory(aiq_acc)
        handler['bme']['STATIC_IAQ'] = aiq_acc.set_value_aiq
        handler['bme']['CO2_EQUIVALENT'] = aiq_acc.set_value_co2
        handler['bme']['BREATH_VOC_EQUIVALENT'] = aiq_acc.set_value_voc

        driver.add_accessory(accessory=bridge)

        signal.signal(signal.SIGTERM, driver.signal_handler)

        threading.Thread(target=driver.start, daemon=True).start()

        return handler
