print("sensor job: light")
tsl2561 = require("tsl2561")
tsl2561.init()
local ch0, ch1 = tsl2561.readRaw()
tsl2561 = nil
package.loaded["tsl2561"] = nil
collectgarbage("collect")
file.remove("light.mqtt")
file.open("light.mqtt", "w")
file.write(ch0.." "..ch1)
file.flush()
file.close()
