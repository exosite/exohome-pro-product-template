local interfaceOverload = {}

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