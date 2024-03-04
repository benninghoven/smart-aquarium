####################
# Devin Benninghoven
# 02/02/24
####################
from adc.adc import Adc
from time import sleep
from colorama import Fore, Style
import os

current_script_dir = os.path.dirname(os.path.realpath(__file__))
parent_dir = os.path.abspath(os.path.join(current_script_dir, os.pardir))
os.chdir(parent_dir)


LOOPS = 10000000
SLEEPTIME = .3


adc = Adc()
for i in range(0, LOOPS):
    adc_value, voltage = adc.poll_sensor(0)
    if adc_value > 0:
        print(Fore.GREEN, end="\0")
    print(f"{adc_value: <3} - {voltage: .2f}V")
    print(Style.RESET_ALL, end="\0")
    sleep(SLEEPTIME)
