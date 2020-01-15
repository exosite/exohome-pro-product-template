local configIO = {}

function configIO.convertFields(fields, ts)
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
  
    return {
      set = config_io,
      reported = config_io,
      timestamp = ts
    }
end

return configIO