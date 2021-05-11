local ipToGeo = {}

function ipToGeo.convertIP(ip)
	local ret = Geo.ipToGeo({
		ip = ip
	})
	local latitude = ret.value.coordinates[2]
	local longitude = ret.value.coordinates[1]
	local location = { location = to_json({ lat = latitude, lng = longitude }) }
	return location
end

return ipToGeo