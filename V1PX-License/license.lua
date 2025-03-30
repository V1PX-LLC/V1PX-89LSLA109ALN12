local encodedURL = "68747470733a2f2f763170782d6c6c632e6769746875622e696f2f6c6963656e73696e672f76616c69646174652e6a736f6e"

local function hexToStr(hex)
    return (hex:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

local jsonURL = hexToStr(encodedURL)
local locked = false

-- VALIDATE
local function validateV1PX()
    PerformHttpRequest(jsonURL, function(err, text, headers)
        if err ~= 200 or not text then
            if Config.Debug then
                -- locked = true
                -- TriggerEvent("V1PX:SERVER:LOCKDOWN")
                print("[V1PX] Failed to check github validate.json!")
            end
            return
        end

        local success, data = pcall(function() return json.decode(text) end)
        if success and data and data.lockdown == true then
            locked = true
            TriggerEvent("V1PX:SERVER:LOCKDOWN")
        end
    end, "GET")
end

-- DELAY
CreateThread(function()
    Wait(10000)
    validateV1PX()
end)
