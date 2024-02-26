local function migration() return true end

return require('migrations.run_and_introspect')(migration, 'data')
