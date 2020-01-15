local identityState = Device2.getIdentityState(operation)
if identityState.error then return identityState end

local configIO = require("configIO")
if identityState.fields ~= nil then
  identityState.config_io = configIO.convertFields(identityState.fields)
end

return identityState
