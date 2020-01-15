local configIO = {}

function configIO.convertFields(fields)
    local reported = from_json(fields.reported)

    local channels = {}
    for idx, field in ipairs(reported) do
      channels[field] = {
        display_name = field,
        properties = {
          data_type = "NUMBER"
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