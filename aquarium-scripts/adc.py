from signal import signal, SIGTERM, SIGHUP, pause
from smbus import SMBus
from gpiozero import PWMLED
from math import log10

bus = SMBus(1)
led = PWMLED(26)
steps = 255

fade_factor = (steps * log10(2))/(log10(steps))
#                   A0    A1...
ads7830_commands = (0x84, 0xc4, 0x94, 0xd4, 0xa4, 0xe4, 0xb4, 0xf4)





def read_ads7830(input):
    bus.write_byte(0x4b, ads7830_commands[input])
    return bus.read_byte(0x4b)


def safe_exit(signum, frame):
    exit(1)


def values(input):
    while True:

        value = read_ads7830(input)

        # FIXME: Not converting correctly from voltage to ppm

        temperature = 25 # READ FROM SENSOR LATER
        compensationCoefficient = 1.0 + 0.02 * (temperature - 25.0) # temperature compensation formula: fFinalResult(25^C) = fFinalResult(current)/(1.0+0.02*(fTP-25.0));
        averageVoltage = value  # average it out later
        compensationVolatge = averageVoltage / compensationCoefficient  # temperature compensation
        tdsValue = (
            133.42 * compensationVolatge ** 3
            - 255.86 * compensationVolatge ** 2
            + 857.39 * compensationVolatge
        ) * 0.5
        print(f"TDS----PPMValue:     {int(tdsValue)} ppm")
        print(f"TDS----VoltageValue: {int(value)}")

        yield (pow(2, (value/fade_factor))-1)/steps  # i have no idea wtf


try:
    print("signal")
    signal(SIGTERM, safe_exit)
    signal(SIGHUP, safe_exit)

    print("led source delay")
    led.source_delay = 0.05
    led.source = values(0)  # read from A0

    print("pause")
    pause()

except KeyboardInterrupt:
    pass

finally:
    print("finally")
    led.source = None
    led.close()
