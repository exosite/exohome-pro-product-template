local configIO = {}

function configIO.convertFields(fields)
    local reported = from_json(fields.reported)

    local channels = {}
    for idx, field in ipairs(reported) do
      channels[field] = {
        display_name = field,
        properties = {
          primitive_type = "NUMERIC",
          data_type = "NUMBER",
          control = true
        }
      }
    end
    local config_io = to_json({ channels = channels })
  
    return {
      set = config_io,
      reported = config_io,
      timestamp = fields.timestamp
    }
end

return configIO