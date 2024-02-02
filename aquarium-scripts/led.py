from gpiozero import PWMLED
from time import sleep

led = PWMLED(26)

while True:
    led.value = 0  # off
    print(led.value)
    sleep(1)
    led.value = 0.5  # half brightness
    print(led.value)
    sleep(1)
    led.value = 1  # full brightness
    print(led.value)
    sleep(1)
