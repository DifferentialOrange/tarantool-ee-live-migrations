local function migration()
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

    local space = box.space['data']

    local old_format = space:format()

    space:upgrade({
        func = FUNC_NAME,
        format = old_format,
    })
end

return require('migrations.run_and_introspect')(migration)
