local identity = Device2.getIdentity(operation)
if identity.error then return identity end

local configIO = require("configIO")
if identity.state.fields ~= nil then
  identity.state.config_io = configIO.convertFields(identity.state.fields)
end

return identity
