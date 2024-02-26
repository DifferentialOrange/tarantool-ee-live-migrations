local SPACE_NAME = 'customers'

return {
    reinit = function()
        if box.space[SPACE_NAME] ~= nil then
            box.space[SPACE_NAME]:drop()
        end

        box.schema.space.create(SPACE_NAME, {if_not_exists = true})
        box.space[SPACE_NAME]:format({
            {name = 'id', type = 'unsigned'},
            {name = 'customer', type = 'string'},
        })
        box.space[SPACE_NAME]:create_index('pk', {parts = {'id'}, if_not_exists = true})
    end,

    fill_data = function()
        box.space[SPACE_NAME]:replace({1, 'John Doe'})
        box.space[SPACE_NAME]:replace({2, 'Jane Oed'})
    end,
}
