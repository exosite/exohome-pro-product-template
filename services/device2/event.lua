--#EVENT device2 event

-- This script handles incoming messages from devices through the Device2 service event.
-- See http://docs.exosite.com/reference/services/device2/#event.


log.debug('BEFORE:' .. to_json(event))

if event.payload ~= nil then
  for idx, pl in ipairs(event.payload) do
    -- copy 'states' to 'data_in'
    if pl.values['states'] ~= nil then
      pl.values['data_in'] = pl.values['states']
    end
    
    if pl.values['fields'] ~= nil then
      local fields = from_json(pl.values['fields'])
      if type(fields) == "table" then
        local channels = {}
        for idx, field in ipairs(fields) do
          channels[field] = {
            display_name = field,
            properties = {
              data_type = "NUMBER"
            }
          }
        end
        local config_io = to_json({ channels = channels })
        pl.values['config_io'] = config_io
        Device2.setIdentityState({
          identity=event.identity,
          config_io = config_io
        })
      end
    end
  end
end

log.debug('AFTER: ' .. to_json(event))

return Interface.trigger({event="event", data=event})
-- Above line forward device data to all Murano Applications connected to this Product
-- To send data to a specific Application, use the 'triggerOne' operation.
-- See http://docs.exosite.com/reference/services/interface/#triggerone.
