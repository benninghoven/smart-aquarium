#!/usr/bin/env python3
########################################################################
# Filename    : ADC.py
# Description : Use ADC module to read the voltage value of potentiometer.
# Author      : www.freenove.com
# modification: 2020/03/06
########################################################################
from ADCDevice import ADS7830, ADCDevice
from time import sleep
from colorama import Fore, Back, Style

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
