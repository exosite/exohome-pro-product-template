local identity = Device2.getIdentity(operation)
if identity.error then return identity end

local configIO = require("configIO")
if identity.state.fields ~= nil then
  local fields = from_json(identity.state.fields.reported)
  identity.state.config_io = configIO.convertFields(fields)
end

return identity
