local identity = Device2.getIdentity(operation)
if identity.error then return identity end

if identity.state.config_io ~= nil then
  local configIO = identity.state.config_io
  configIO.reported = configIO.set
  identity.state.config_io = configIO
end

return identity
