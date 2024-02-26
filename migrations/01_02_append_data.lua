local SPACE_NAME = 'data'

local function migration(...)
    local SPACE_NAME = ...

    local space = box.space[SPACE_NAME]

    local old_format = space:format()
    local new_format = old_format


    local FUNC_NAME = 'append'

    if box.schema.func.exists(FUNC_NAME) then
        box.func[FUNC_NAME]:drop()
    end

    box.schema.func.create(FUNC_NAME, {
        language = 'lua',
        is_deterministic = true,
        body = [[
        function(t)
            local payload_len = #t[2]
            return t:update({{':', 2, payload_len + 1, 0, '_tail'}})
        end
        ]],
    })


    space:upgrade({
        func = FUNC_NAME,
        format = new_format,
    })
end

return require('migrations.run_and_introspect')(migration, SPACE_NAME)
