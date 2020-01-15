local identityState = Device2.getIdentityState(operation)
if identityState.error then return identityState end

local configIO = require("configIO")
if identityState.fields ~= nil then
  local fields = from_json(identityState.fields.reported)
  identityState.config_io = configIO.convertFields(fields)
end

return identityState
