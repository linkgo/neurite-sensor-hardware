tmr.alarm(0, 1000, 1, function()
    -- init module
    tsl2561 = require("tsl2561")
    tsl2561.init(i2c_sda, i2c_scl)

    -- read value
    l = tsl2561.readVisibleLux()
    print("lux: "..l.." lx")

    -- release module
    tsl2561 = nil
    package.loaded["tsl2561"]=nil
    collectgarbage()
end)
