local SPACE_NAME = 'numerical_indexed'

local function migration(...)
    local SPACE_NAME = ...

    local space = box.space[SPACE_NAME]

    local old_format = space:format()
    local new_format = table.deepcopy(old_format)
    new_format[2].type = 'number'


    local FUNC_NAME = 'cast_to_number'

    if box.schema.func.exists(FUNC_NAME) then
        box.func[FUNC_NAME]:drop()
    end

    box.schema.func.create(FUNC_NAME, {
        language = 'lua',
        is_deterministic = true,
        body = [[
        function(t)
            local payload = t[2]
            local new_payload = tonumber(t[2])
            return {t[1], new_payload}
        end
        ]],
    })


    space.index['secondary']:drop()

    space:upgrade({
        func = FUNC_NAME,
        format = new_format,
    })

    space:create_index('secondary', {parts = {'val'}, if_not_exists = true})
end

return require('migrations.run_and_introspect')(migration, SPACE_NAME)
