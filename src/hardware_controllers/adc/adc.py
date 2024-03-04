#!/usr/bin/env python3
########################################################################
# Filename    : ADC.py
# Description : Use ADC module to read the voltage value of potentiometer.
# Author      : www.freenove.com
# modification: 2020/03/06
########################################################################
from time import sleep
from colorama import Fore, Back, Style
import smbus


class ADCDevice(object):
    def __init__(self):
        self.cmd = 0
        self.address = 0
        self.bus=smbus.SMBus(1)
        # print("ADCDevice init")

    def detectI2C(self,addr):
        try:
            self.bus.write_byte(addr,0)
            print("Found device in address 0x%x"%(addr))
            return True
        except:
            print("Not found device in address 0x%x"%(addr))
            return False

    def close(self):
        self.bus.close()


class ADS7830(ADCDevice):
    def __init__(self):
        super(ADS7830, self).__init__()
        self.cmd = 0x84
        self.address = 0x4b  # 0x4b is the default i2c address for ADS7830 Module.   

    def analogRead(self, chn):  # ADS7830 has 8 ADC input pins, chn:0,1,2,3,4,5,6,7
        value = self.bus.read_byte_data(self.address, self.cmd|(((chn<<2 | chn>>1)&0x07)<<4))
        return value

#print(f"{Fore.RED}This is red")
#print(f"{Back.GREEN}This has a green background")
#print(f"{Fore.YELLOW}{Back.BLUE}This has yellow foreground and blue background")

# Reset colors
#print(f"{Style.RESET_ALL}This is the default text color")

class Adc:
    def __init__(self):
        self.adc = ADS7830()


    def poll_sensor(self, analogChannel=0):
        value = self.adc.analogRead(analogChannel)
        voltage = value / 255.0 * 3.3
        return [value, voltage]


    def __del__(self):
        print("destroying adc object")
        self.adc.close()


#result = convert_to_ppm(adc_value, water_temperature)
#print(f"ADC Value: {adc_value}")
#print(f"Water Temperature: {water_temperature} °C")
#print(f"Compensated PPM Result: {result}")


#print(f"{Fore.RED}MODE: {mode}")
#print(f"{Style.RESET_ALL}")
