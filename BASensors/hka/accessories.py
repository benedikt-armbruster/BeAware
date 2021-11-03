from pyhap.accessory import Accessory, Bridge
from pyhap.const import CATEGORY_SENSOR


class SimpleSensor(Accessory):
    category = CATEGORY_SENSOR

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        service_name, characteristic_name = self._get_service_and_characteristic_name()

        service = self.add_preload_service(service_name)
        self.characteristic = service.configure_char(characteristic_name)

    def set_value(self, value):
        self.characteristic.set_value(value)

    def _get_service_and_characteristic_name(self):
        raise NotImplemented


class TemperatureSensor(SimpleSensor):
    def _get_service_and_characteristic_name(self):
        return 'TemperatureSensor', 'CurrentTemperature'


class OccupancySensor(SimpleSensor):
    def _get_service_and_characteristic_name(self):
        return 'OccupancySensor', 'OccupancyDetected'


class LightSensor(SimpleSensor):
    def _get_service_and_characteristic_name(self):
        return 'LightSensor', 'CurrentAmbientLightLevel'


class HumiditySensor(SimpleSensor):
    def _get_service_and_characteristic_name(self):
        return 'HumiditySensor', 'CurrentRelativeHumidity'


class AirQualitySensor(Accessory):
    category = CATEGORY_SENSOR

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        service = self.add_preload_service('AirQualitySensor', chars=['AirQuality', 'VOCDensity', 'CarbonDioxideLevel'])
        self.char_aqi = service.configure_char('AirQuality')
        self.char_voc = service.configure_char('VOCDensity')
        self.char_co2 = service.configure_char('CarbonDioxideLevel')

    def set_value_aiq(self, iaq):
        # TODO map to 1 to 5
        if iaq <= 50.0:
            # Excellent
            iaq_index = 1
        elif iaq <= 100.0:
            # Good
            iaq_index = 2
        elif iaq <= 150.0:
            # Lighty
            iaq_index = 3
        elif iaq <= 200.0:
            # Moderate
            iaq_index = 4
        else:
            iaq_index = 5
        self.char_aqi.set_value(iaq_index)

    def set_value_voc(self, ppm):
        # convert from ppm to micrograms per cubic meter
        # Formula taken from https://www.teesing.com/en/page/library/tools/ppm-mg3-converter
        value = 40.9 * ppm * 78.9516

        self.char_voc.set_value(value)

    def set_value_co2(self, ppm):
        self.char_co2.set_value(ppm)
