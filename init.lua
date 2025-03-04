if not lib then
    return error(('%s you dont have ox_lib, download it: https://github.com/overextended/ox_lib'):format(GetCurrentResourceName()))
end

Shared = {}

-- if your framework is renamed then change it here
local es_extended = 'es_extended'
local qb_core = 'qb-core'
local esx = GetResourceState(es_extended):find('start')
local qb = GetResourceState(qb_core):find('start')


if esx then
    Shared = { esx = true, framework = es_extended }
elseif qb then
    Shared = { qb = true, framework = qb_core }
end

SetTimeout(100, function()
    if table.type(Shared) == 'empty' then
        for i = 1, 5 do
            warn(("No framework resource was found, check %s/main.lua"):format(cache.resource))
        end
    end
end)

require(IsDuplicityVersion() and 'server.server' or 'client.client')