return function()
    local spaces = {
        require('space.01_data'),
        require('space.02_customers'),
        require('space.03_numerical'),
    }

    for _, space in ipairs(spaces) do
        space.reinit()
        space.fill_data()
    end
end
