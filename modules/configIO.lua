local R = require('moses')
local configIO = {}

function configIO.convertFields(fields)
    local reported = from_json(fields.reported)

    local channels = R(reported)
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

    channels = configIO.combineOtherChannels(channels)

    local config_io = to_json({ channels = channels })

    return {
      set = config_io,
      reported = config_io,
      timestamp = fields.timestamp
    }
end

function configIO.combineOtherChannels(channels)

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

    local other_channels = {
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

  local config_io = R.extend(channels, other_channels)

  return config_io

end


return configIO