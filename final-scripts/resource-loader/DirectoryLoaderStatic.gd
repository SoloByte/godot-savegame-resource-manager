class_name DirectoryLoaderStatic


#NOTE: If returned resource is not stored outside of the scope of a function once
#the resource is not cached




static func loadFrom(file_path : String, type_hint : String = "") -> Resource:
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path, type_hint)
	else:
		push_warning("Resource at %s does not exist. Return value is null." % file_path)
		print("Resource at %s does not exist. Return value is null." % file_path)
		return null


static func loadAllFrom(directory_path : String, type_hint : String = "", deep : bool = false) -> Array:
	var dir : Directory = Directory.new()
	var resources : Array = []
	if dir.open(directory_path) == OK:
		dir.list_dir_begin(true, false)
		var file_name : String = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var file : String = directory_path.plus_file(file_name)
				var r = loadFrom(file, type_hint)
				if r:
					resources.append(r)
			else:
				if deep:
					var directory : String = directory_path.plus_file(file_name)
					resources += loadAllFrom(directory, type_hint, deep)
			file_name = dir.get_next()
	else:
		push_warning("Resources could not be loaded from %s. Did you mean %s ?" %[directory_path, directory_path.get_base_dir()])
		print("Resources could not be loaded from %s. Did you mean %s ?" % [directory_path, directory_path.get_base_dir()])
	
	dir.list_dir_end()
	return resources


static func asyncLoadFrom(file_path : String, object, function_name : String) -> ResourceLoaderAsync:
	var func_ref : FuncRef = FuncRef.new()
	func_ref.set_instance(object)
	func_ref.set_function(function_name)
	var rla : ResourceLoaderAsync = ResourceLoaderAsync.new(file_path, func_ref)
	return rla


static func asyncLoadAllFrom(file_path : String, object, function_name : String, type_hint : String = "", deep : bool = false) -> DirectoryLoaderAsync:
	var func_ref : FuncRef = FuncRef.new()
	func_ref.set_instance(object)
	func_ref.set_function(function_name)
	var dla : DirectoryLoaderAsync = DirectoryLoaderAsync.new(file_path, func_ref, type_hint, deep)
	return dla


#NOTE: Probably it is better to let the functions push a warning/error if path is not
#correct instead of trying to correct the path
#static func pCheckDirectoryPath(path : String, dir : Directory) -> String:
#	var return_path : String = ""
#	if path.get_extension() != "":
#		var old_directory : String = path
#		var extension : String = path.get_extension()
#		var new_directory : String = path.get_base_dir()
#
#		if dir.dir_exists(new_directory):
#			push_warning("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
#			print("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
#			return_path = new_directory
#			push_warning("Path changed to %s." % new_directory)
#			print("Path changed to %s." % new_directory)
#		else:
#			push_warning("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
#			print("Path %s included file extension %s. Function needs a directory path!" %[old_directory, extension])
#			push_warning("Resources could not be loaded from %s." %path)
#			print("Resources could not be loaded from %s." % path)
#	else:
#		if dir.dir_exists(path):
#			return_path = path
#
#	return return_path
