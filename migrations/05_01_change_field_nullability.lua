local SPACE_NAME = 'nullable_field'

local function migration(...)
    local SPACE_NAME = ...

    local space = box.space[SPACE_NAME]

    local old_format = space:format()
    local new_format = table.deepcopy(old_format)
    new_format[2].is_nullable = false


    local FUNC_NAME = 'fill_nil_with_empty_strings'

    if box.schema.func.exists(FUNC_NAME) then
        box.func[FUNC_NAME]:drop()
    end

    box.schema.func.create(FUNC_NAME, {
        language = 'lua',
        is_deterministic = true,
        body = [[
        function(t)
            if t[2] == nil then
                return t:update({{'=', 2, ''}})
            else
                return t
            end
        end
        ]],
    })


    space:upgrade({
        func = FUNC_NAME,
        format = new_format,
    })
end

return require('migrations.run_and_introspect')(migration, SPACE_NAME)
