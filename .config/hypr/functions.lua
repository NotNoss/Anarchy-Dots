function load_variant(variant_file,variant_name)
	variant_file = variant_file:gsub(".lua", "")
	require("config." .. variant_name .. "." .. variant_file)
end
