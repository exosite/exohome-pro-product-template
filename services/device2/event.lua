--#EVENT device2 event
-- This script handles incoming messages from devices through the Device2 service event.
-- See http://docs.exosite.com/reference/services/device2/#event.
local configIO = require("configIO")
local ipToGeo = require("ipToGeo")
local M = require('moses')

log.debug('BEFORE:' .. to_json(event))
local resources = Device2.getIdentityState({
  identity = event.identity
  })

local location = ipToGeo.convertIP(event.ip)

local esh, module_data, provisioned_time = {}
local fields

if resources.provisioned_time ~= nil then
  esh = from_json(resources.esh.reported)
  module_data = from_json(resources.module.reported)
  provisioned_time = { provisioned_time = resources.provisioned_time.set }
  fields = resources.fields.reported
end

if event.payload ~= nil then
  for idx, pl in ipairs(event.payload) do
    -- copy 'states' and merge with resources data then transmit to 'data_in' and 'data_out' (for notify UI ack)
    if pl.values['states'] ~= nil then
      local states = from_json(pl.values['states'])
      local resources_data = to_json(M.extend(states, esh, module_data, provisioned_time, location ))
      log.debug(resources_data)
      pl.values['data_in'] = resources_data
      pl.values['data_out'] = resources_data
    end

    -- fake config_io data-in, to update exosense config_io cache
    if fields ~= nil then
      local origin_config_io = Keystore.get({ key = "config_io" }).value
      local state = {
        set = fields,
        reported = fields,
        timestamp = pl.timestamp
      }
      local new_config_io = configIO.convertFields(state).reported
      if origin_config_io == nil or origin_config_io ~= new_config_io then
        log.debug('Set new config_io')
        Keystore.set({ key = "config_io", value = new_config_io })
        pl.values['config_io'] = new_config_io
      end
    end
  end
end

log.debug('AFTER: ' .. to_json(event))

return Interface.trigger({ event = "event", data = event})
-- Above line forward device data to all Murano Applications connected to this Product
-- To send data to a specific Application, use the 'triggerOne' operation.
-- See http://docs.exosite.com/reference/services/interface/#triggerone.
