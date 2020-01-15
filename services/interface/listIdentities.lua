local identities = Device2.listIdentities(operation)
if identities.error or not next(identities.devices) then return identities end

for k, identity in pairs(identities.devices) do
  if identity.state.config_io ~= nil then
    local configIO = identity.state.config_io
    configIO.reported = configIO.set
    identity.state.config_io = configIO
  end
end

return identities
