return function()
    if box.space['data'] ~= nil then
        box.space['data']:drop()
    end

    box.schema.space.create('data', {if_not_exists = true})
    box.space['data']:format({
        {name = 'id', type = 'unsigned'},
        {name = 'payload', type = 'string'},
    })
    box.space['data']:create_index('pk', {parts = {'id'}, if_not_exists = true})

    box.space['data']:replace({1, 's1 s2'})
    box.space['data']:replace({2, '1w 2w3wwwwww'})
end
