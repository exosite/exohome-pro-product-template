local identityState = Device2.getIdentityState(operation)
if identityState.error then return identityState end

if identityState.config_io ~= nil then
  local configIO = identityState.config_io
  configIO.reported = configIO.set
  identityState.config_io = configIO
end

return identityState
