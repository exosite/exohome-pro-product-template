local M = require('moses')
local configIO = {}

function configIO.convertFields(fields)
    local reported = from_json(fields.reported)

    local channels = M(reported)
      :map(function(x)
        if R.isString(x) then
          return {x}
        elseif R.isTable(x) then
          return R.keys(x)
        else
          return {}
        end
      end)
      :flatten()
      :reduce(function(o, x)
        o[x] = {
          display_name = x,
          properties = {
            primitive_type = 'NUMERIC',
            data_type = 'NUMBER',
            control = true,
            locked = true,
          },
          protocol_config = {
            report_rate = 30000,
            timeout = 30000
          }
        }
        return o
      end, {})
      :value()

    channels = configIO.combineResourcesChannels(channels)

    local config_io = to_json({ channels = channels })

    return {
      set = config_io,
      reported = config_io,
      timestamp = fields.timestamp
    }
end

function configIO.combineResourcesChannels(channels)

  local resources_channels = configIO.resourcesChannels()
  local config_io = M.extend(channels, resources_channels)

  return config_io

end

function configIO.checkCurrentResourcesChannels()
  local current_resources_channels = Keystore.get({ key = "resources_channels" }).value
  local new_resources_channels = configIO.resourcesChannels()
  local resources_channels_changed
  if current_resources_channels == nil or not M.isEqual(from_json(current_resources_channels), new_resources_channels) then
    Keystore.set({ key = "resources_channels", value = to_json(new_resources_channels) })
    resources_channels_changed = true
  else
    resources_channels_changed = false
  end
  return resources_channels_changed
end

function configIO.resourcesChannels()

  local protocol_config = {
    report_rate = 30000,
    timeout = 30000
  }

  local properties_number = {
    control = true,
    data_type = "NUMBER",
    locked = true,
    primitive_type = "NUMERIC"
  }

  local properties_string = {
    control = true,
    data_type = "STRING",
    locked = true,
    primitive_type = "STRING"
  }

  local properties_location = {
    data_type = "LOCATION",
    data_unit = "LAT_LONG",
    locked = true,
    primitive_type = "JSON"
  }

  local resources_channels = {
    brand = {
      display_name = "brand",
      protocol_config = protocol_config,
      properties = properties_string
    },
    class = {
      display_name = "class",
      protocol_config = protocol_config,
      properties = properties_number
    },
    esh_version = {
      display_name = "esh_version",
      protocol_config = protocol_config,
      properties = properties_string
    },
    device_id = {
      display_name = "device_id",
      protocol_config = protocol_config,
      properties = properties_string
    },
    firmware_version = {
      display_name = "firmware_version",
      protocol_config = protocol_config,
      properties = properties_string
    },
    local_ip = {
      display_name = "local_ip",
      protocol_config = protocol_config,
      properties = properties_string
    },
    location = {
      display_name = "location",
      protocol_config = protocol_config,
      properties = properties_location
    },
    mac_address = {
      display_name = "mac_address",
      protocol_config = protocol_config,
      properties = properties_string
    },
    model = {
      display_name = "model",
      protocol_config = protocol_config,
      properties = properties_string
    },
    provisioned_time = {
      display_name = "provisioned_time",
      protocol_config = protocol_config,
      properties = properties_number
    },
    ssid = {
      display_name = "ssid",
      protocol_config = protocol_config,
      properties = properties_string
    }
  }

  return resources_channels
end

function configIO.checkOrInitiateCounter(event, resources)
  local set_config_io_counter
  if resources.set_config_io_counter == nil then
    set_config_io_counter = 0
    Device2.setIdentityState({
      identity = event.identity,
      set_config_io_counter = 0
    })
  else
    set_config_io_counter = resources.set_config_io_counter.set
  end
  return set_config_io_counter
end

function configIO.resetCounter(event)
  Device2.setIdentityState({
    identity = event.identity,
    set_config_io_counter = 1
  })
end

function configIO.incrementCounter(event, set_config_io_counter)
  Device2.setIdentityState({
    identity = event.identity,
    set_config_io_counter = set_config_io_counter + 1
  })
end

return configIO
