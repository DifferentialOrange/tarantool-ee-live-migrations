local SPACE_NAME = 'customers'

local function migration(...)
    local SPACE_NAME = ...

    local space = box.space[SPACE_NAME]

    local old_format = space:format()
    local new_format = table.deepcopy(old_format)
    new_format[2] = {name = 'name', type = 'string'}
    new_format[3] = {name = 'surname', type = 'string'}


    local FUNC_NAME = 'split'

    if box.schema.func.exists(FUNC_NAME) then
        box.func[FUNC_NAME]:drop()
    end

    box.schema.func.create(FUNC_NAME, {
        language = 'lua',
        is_deterministic = true,
        body = [[
        function(t)
            local payload = t[2]

            local splitted_data = {}
            local split_regex = '([^%s]+)'
            for v in string.gmatch(payload, split_regex) do
                table.insert(splitted_data, v)
            end

            local name = splitted_data[1]
            assert(name ~= nil)
            t = t:update({{'=', 2, name}})

            local surname = splitted_data[2]
            assert(surname ~= nil)
            t = t:update({{'=', 3, surname}})

            return t
        end
        ]],
    })


    space:upgrade({
        func = FUNC_NAME,
        format = new_format,
    })
end

return require('migrations.run_and_introspect')(migration, SPACE_NAME)
