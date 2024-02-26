local fio = require('fio')

return function()
    local spaces = {}
    local space_files = fio.listdir('./space')
    for _, file in ipairs(space_files) do
        local require_path = ('space.' .. file):gsub('.lua$', '')
        local module =require(require_path)
        table.insert(spaces, module)
    end

    for _, space in ipairs(spaces) do
        space.reinit()
        space.fill_data()
    end
end
