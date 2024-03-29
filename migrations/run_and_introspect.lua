local net_box = require('net.box')
local json = require('json')

local function connect()
    local conn = net_box.connect('localhost:3301', {user = 'client', password = 'pass'})
    assert(conn:ping(), conn)
    return conn
end

local function call(conn, func, space_name)
    local func_dump = string.dump(func)
    local _, err = conn:eval(func_dump, {space_name})
    assert(err == nil, err)
end

local function introspect(conn, space_name)
    conn:reload_schema()

    local rows = conn.space[space_name]:select(nil, {limit = 1000})
    for i, row in ipairs(rows) do
        local map_row = row:tomap{names_only = true}
        print(('row %d: %s'):format(i, json.encode(map_row)))
    end
end

local function cleanup(conn)
    local _, err = conn:eval([[
        require('rebootstrap')()
    ]])
    assert(err == nil, err)
end

local function run_migration(func, space_name)
    local conn = connect()

    print('Before migration:')
    introspect(conn, space_name)

    call(conn, func, space_name)

    print('After migration:')
    introspect(conn, space_name)

    cleanup(conn)

    os.exit(0)
end

return run_migration
