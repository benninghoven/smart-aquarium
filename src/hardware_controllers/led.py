##################################
# Devin Benninghoven
# 02/08/24
# Controller for LED light
##################################


from gpiozero import PWMLED

led = PWMLED(26)

# 0 - 1 for value
led.value = 1
# will turn off after script is finished
