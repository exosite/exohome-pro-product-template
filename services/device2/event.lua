--#EVENT device2 event
-- This script handles incoming messages from devices through the Device2 service event.
-- See http://docs.exosite.com/reference/services/device2/#event.
local configIO = require("configIO")
local M = require('moses')

log.debug('BEFORE:' .. to_json(event))
local resources = Device2.getIdentityState({
  identity = event.identity
})

if event.payload ~= nil then
  for idx, pl in ipairs(event.payload) do
    -- Copy 'states' and merge with resources data then transmit to 'data_in' and 'data_out' (for notify UI ack)
    if pl.values['states'] ~= nil then

      local states = from_json(pl.values['states'])
      local esh, module_data, provisioned_time = {}
      local fields
      if resources.provisioned_time ~= nil then
        esh = from_json(resources.esh.reported)
        module_data = from_json(resources.module.reported)
        provisioned_time = { provisioned_time = resources.provisioned_time.set }
        fields = resources.fields.reported
      end

      local resources_data = to_json(M.extend(states, esh, module_data, provisioned_time ))

      pl.values['data_in'] = resources_data
      pl.values['data_out'] = resources_data

      -- Fake config_io data-in to update exosense config_io cache when detected config_io changed
      if fields ~= nil then

        local set_config_io_counter
        set_config_io_counter = configIO.checkOrInitiateCounter(event, resources)

        local state = {
          set = fields,
          reported = fields,
          timestamp = pl.timestamp
        }
        local config_io = configIO.convertFields(state).reported

        local config_io_changed = configIO.checkCurrentResourcesChannels()
        if config_io_changed == true then
          log.debug('Set new config_io')
          pl.values['config_io'] = config_io
          configIO.resetCounter(event)
        elseif set_config_io_counter <= 2 then -- Only allow sending config_io twice after set config_io
          pl.values['config_io'] = config_io
          configIO.incrementCounter(event, set_config_io_counter)
        end
      end
    end

    -- Fake config_io data-in to update exosense config_io cache when provisioned
    if pl.values['fields'] ~= nil then
      log.debug('Set config_io when provisioned')
      local state = {
        set = pl.values['fields'],
        reported = pl.values['fields'],
        timestamp = pl.timestamp
      }
      local config_io = configIO.convertFields(state).reported
      pl.values['config_io'] = config_io
    end
  end
end

log.debug('AFTER: ' .. to_json(event))

return Interface.trigger({ event = "event", data = event})
-- Above line forward device data to all Murano Applications connected to this Product
-- To send data to a specific Application, use the 'triggerOne' operation.
-- See http://docs.exosite.com/reference/services/interface/#triggerone.
