local result = Device2.getIdentity(operation)
log.debug('setIdentityState overload: ' .. to_json({
    operation = operation,
    result = result
}))
return result