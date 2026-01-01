class_name SaveManager
extends RefCounted

const SAVE_FILE_FORMAT = "user://save_%d.dat"
const SAVE_VERSION = 1


func save_game(slot_id: int, data: Dictionary) -> bool:
	if slot_id < 0:
		print("Error: Invalid slot_id: ", slot_id)
		return false

	var config_file = ConfigFile.new()
	var save_path = SAVE_FILE_FORMAT % slot_id

	config_file.set_value("metadata", "version", SAVE_VERSION)
	config_file.set_value("metadata", "save_time", Time.get_unix_time_from_system())
	config_file.set_value("metadata", "slot_id", slot_id)

	for key in data:
		config_file.set_value("data", key, data[key])

	var error = config_file.save(save_path)
	if error != OK:
		print("Error: Failed to save game to ", save_path, " Error: ", error)
		return false

	return true


func load_game(slot_id: int) -> Dictionary:
	if slot_id < 0:
		print("Error: Invalid slot_id: ", slot_id)
		return {}

	var save_path = SAVE_FILE_FORMAT % slot_id

	if not FileAccess.file_exists(save_path):
		print("Warning: Save file not found: ", save_path)
		return {}

	var config_file = ConfigFile.new()

	var error = config_file.load(save_path)
	if error != OK:
		print("Error: Failed to load save file: ", save_path, " Error: ", error)
		return {}

	var version = config_file.get_value("metadata", "version", 0)
	if version != SAVE_VERSION:
		print("Warning: Save file version mismatch. Expected: ", SAVE_VERSION, " Got: ", version)

	var result = {}

	var keys = config_file.get_section_keys("data")
	for key in keys:
		result[key] = config_file.get_value("data", key)

	return result


func delete_save(slot_id: int) -> bool:
	if slot_id < 0:
		print("Error: Invalid slot_id: ", slot_id)
		return false

	var save_path = SAVE_FILE_FORMAT % slot_id

	if not FileAccess.file_exists(save_path):
		print("Warning: Save file not found: ", save_path)
		return false

	var error = DirAccess.remove_absolute(save_path)
	if error != OK:
		print("Error: Failed to delete save file: ", save_path, " Error: ", error)
		return false

	return true


func save_exists(slot_id: int) -> bool:
	if slot_id < 0:
		return false

	var save_path = SAVE_FILE_FORMAT % slot_id

	return FileAccess.file_exists(save_path)


func get_save_metadata(slot_id: int) -> Dictionary:
	if slot_id < 0:
		print("Error: Invalid slot_id: ", slot_id)
		return {}

	var save_path = SAVE_FILE_FORMAT % slot_id

	if not FileAccess.file_exists(save_path):
		return {}

	var config_file = ConfigFile.new()

	var error = config_file.load(save_path)
	if error != OK:
		print("Error: Failed to load save metadata: ", save_path, " Error: ", error)
		return {}

	var result = {}
	var keys = config_file.get_section_keys("metadata")
	for key in keys:
		result[key] = config_file.get_value("metadata", key)

	return result
