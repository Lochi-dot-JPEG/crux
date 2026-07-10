extends Node

const SAVE_PATH = "user://"
const FILE_NAME= "save.txt"


func _ready() -> void:
	Globals.loaded_save = _load_file()


func _save_file(data) -> void:
	var create_folder = DirAccess.open("user://")
	create_folder.make_dir_recursive(SAVE_PATH)
	ResourceSaver.save(data,_get_save_path())
	print("Saved in game slot "+ str())


func _get_save_path() -> String:
	return SAVE_PATH + FILE_NAME


func _load_file() -> SaveFile:
	var _path = _get_save_path()
	if not FileAccess.file_exists(_path): 
		var new_file = SaveFile.new()
		return new_file
	var file : SaveFile = load(_path)
	return file
