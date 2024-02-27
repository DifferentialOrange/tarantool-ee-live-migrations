local SPACE_NAME = 'nullable_field'

return {
    reinit = function()
        if box.space[SPACE_NAME] ~= nil then
            box.space[SPACE_NAME]:drop()
        end

        box.schema.space.create(SPACE_NAME, {if_not_exists = true})
        box.space[SPACE_NAME]:format({
            {name = 'id', type = 'unsigned'},
            {name = 'val', type = 'string', is_nullable = true},
        })
        box.space[SPACE_NAME]:create_index('primary', {parts = {'id'}, if_not_exists = true})

        -- Migrating indexed field is blocked by bug:
        -- https://github.com/tarantool/tarantool-ee/issues/698
        -- box.space[SPACE_NAME]:create_index('secondary', {parts = {'val'}, if_not_exists = true, unique = false})
    end,

    fill_data = function()
        box.space[SPACE_NAME]:replace({1, 's1s2s3'})
        box.space[SPACE_NAME]:replace({2, '1w2w3wwwwww'})
        box.space[SPACE_NAME]:replace({3})
        box.space[SPACE_NAME]:replace({4, box.NULL})
        box.space[SPACE_NAME]:replace({5, ''})
    end,
}
