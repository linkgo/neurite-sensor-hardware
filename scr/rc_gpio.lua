print("config gpio...")
gpiomap = {[0]=3,[1]=10,[2]=4,[3]=9,[4]=1,[5]=2,[9]=11,[10]=12,[12]=6,[13]=7,[14]=5,[15]=8,[16]=0}
print("  [ok]")

led_r = gpiomap[14]
led_g = gpiomap[12]
led_b = gpiomap[13]

gpio.mode(led_r, gpio.OUTPUT)
gpio.write(led_r, gpio.LOW)
tmr.delay(250000)
gpio.write(led_r, gpio.HIGH)

gpio.mode(led_g, gpio.OUTPUT)
gpio.write(led_g, gpio.LOW)
tmr.delay(250000)
gpio.write(led_g, gpio.HIGH)

gpio.mode(led_b, gpio.OUTPUT)
gpio.write(led_b, gpio.LOW)
tmr.delay(250000)
gpio.write(led_b, gpio.HIGH)

gpio.write(led_r, gpio.LOW)
gpio.write(led_g, gpio.LOW)
gpio.write(led_b, gpio.LOW)
tmr.delay(250000)
gpio.write(led_r, gpio.HIGH)
gpio.write(led_g, gpio.HIGH)
gpio.write(led_b, gpio.HIGH)