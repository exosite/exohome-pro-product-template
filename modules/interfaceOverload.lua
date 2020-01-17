local interfaceOverload = {}

function interfaceOverload.setIdentityState(operation)
    local result = Device2.setIdentityState(operation)
    log.debug('setIdentityState overload: ' .. to_json({
        operation = operation,
        result = result
    }))
    return result
end

return interfaceOverload