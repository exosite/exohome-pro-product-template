local identities = Device2.listIdentities(operation)
if identities.error or not next(identities.devices) then return identities end

local configIO = require("configIO")
for k, identity in pairs(identities.devices) do
  if identity.state.fields ~= nil then
    identity.state.config_io = configIO.convertFields(identity.state.fields)
  end
end

return identities
