--#EVENT device2 event

-- This script handles incoming messages from devices through the Device2 service event.
-- See http://docs.exosite.com/reference/services/device2/#event.


log.debug('BEFORE:' .. to_json(event))

local configIO = require("configIO")
if event.payload ~= nil then
  for idx, pl in ipairs(event.payload) do
    -- copy 'states' to 'data_in'
    if pl.values['states'] ~= nil then
      pl.values['data_in'] = pl.values['states']
    end
    
    -- fake config_io data-in, to update exosense config_io cache
    if pl.values['fields'] ~= nil then
      local state = {
        set = pl.values['fields'],
        reported = pl.values['fields'],
        timestamp = pl.timestamp
      }
      local converted = configIO.convertFields(state)
      pl.values['config_io'] = converted.reported
    end
  end
end

log.debug('AFTER: ' .. to_json(event))

return Interface.trigger({event="event", data=event})
-- Above line forward device data to all Murano Applications connected to this Product
-- To send data to a specific Application, use the 'triggerOne' operation.
-- See http://docs.exosite.com/reference/services/interface/#triggerone.
