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

    local config_io = to_json({ channels = channels })
  
    return {
      set = config_io,
      reported = config_io,
      timestamp = fields.timestamp
    }
end

return configIO
