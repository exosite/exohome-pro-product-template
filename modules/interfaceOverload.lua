local interfaceOverload = {}
local configIO = require("configIO")

function interfaceOverload.getIdentity(operation)
    local identity = Device2.getIdentity(operation)
    if identity.error then return identity end

    if identity.state.fields ~= nil then
    identity.state.config_io = configIO.convertFields(identity.state.fields)
    end

    return identity
end

function interfaceOverload.getIdentityState(operation)
    local identityState = Device2.getIdentityState(operation)
    if identityState.error then return identityState end

    if identityState.fields ~= nil then
    identityState.config_io = configIO.convertFields(identityState.fields)
    end

    return identityState
end

function interfaceOverload.listIdentities(operation)
    local identities = Device2.listIdentities(operation)
    if identities.error or not next(identities.devices) then return identities end

    for k, identity in pairs(identities.devices) do
        if identity.state.fields ~= nil then
            identity.state.config_io = configIO.convertFields(identity.state.fields)
        end
    end

    return identities
end

function interfaceOverload.setIdentityState(operation)
    if operation.data_out ~= nil then
        local data_out = from_json(operation.data_out)
        if data_out ~= nil then
            local action = {
                data = data_out,
                id = 'exosense',
                request = 'set'
            }
            operation.action = to_json(action)
        end
    end
    return Device2.setIdentityState(operation)
end

return interfaceOverload