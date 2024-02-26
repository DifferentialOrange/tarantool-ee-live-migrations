local function migration()
    local FUNC_NAME = 'embed'

    local space = box.space['data']

    local old_format = space:format()
    local new_format = table.deepcopy(old_format)
    new_format[2] = {name = 'payload', type = 'map'}

    if box.schema.func.exists(FUNC_NAME) then
        box.func[FUNC_NAME]:drop()
    end

    box.schema.func.create(FUNC_NAME, {
        language = 'lua',
        is_deterministic = true,
        body = [[
        function(t)
            local payload = t[2]
            local new_payload = {data = payload}
            return {t[1], new_payload}
        end
        ]],
    })

    space:upgrade({
        func = FUNC_NAME,
        format = new_format,
    })
end

return require('migrations.run_and_introspect')(migration)
