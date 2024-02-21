#!/usr/bin/env python3
########################################################################
# Filename    : ADC.py
# Description : Use ADC module to read the voltage value of potentiometer.
# Author      : www.freenove.com
# modification: 2020/03/06
########################################################################
import time
from ADCDevice import *

adc = ADCDevice() # Define an ADCDevice class object


def setup():
    global adc
    adc = ADS7830()
        

def loop():
    while True:
        analogChannel = 0
        value = adc.analogRead(analogChannel)    # read the ADC value of channel 0
        voltage = value / 255.0 * 3.3  # calculate the voltage value
        print (f'Channel: {analogChannel} ADC Value : {value}, Voltage : {voltage:.2f}')
        time.sleep(0.1)


def destroy():
    adc.close()
    

if __name__ == '__main__':   # Program entrance
    print('Program is starting ... ')
    try:
        setup()
        loop()
    except KeyboardInterrupt: # Press ctrl-c to end the program.
        destroy()

