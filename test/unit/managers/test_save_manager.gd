extends GutTest

const TEST_SAVE_SLOT = 1
const TEST_SAVE_FILE_FORMAT = "user://save_%d.dat"
const TEST_SAVE_PATH = "user://save_1.dat"


func before_all():
	_clean_up_test_files()


func after_all():
	_clean_up_test_files()


func before_each():
	_clean_up_test_files()


func _clean_up_test_files():
	var file = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	if file:
		file.close()
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(TEST_SAVE_PATH)


func test_save_manager_class_exists():
	var save_manager = SaveManager.new()

	assert_not_null(
		save_manager,
		"SaveManager should be instantiatable"
	)


func test_save_game_creates_file():
	var save_manager = SaveManager.new()
	var test_data = {"score": 100, "level": 1, "player_pos": Vector2(100, 200)}

	var result = save_manager.save_game(TEST_SAVE_SLOT, test_data)

	assert_true(result, "save_game should return true on success")
	assert_true(FileAccess.file_exists(TEST_SAVE_PATH), "Save file should be created")


func test_load_game_returns_saved_data():
	var save_manager = SaveManager.new()
	var test_data = {
		"score": 100,
		"level": 1,
		"player_pos": Vector2(100, 200),
		"lives": 3
	}

	save_manager.save_game(TEST_SAVE_SLOT, test_data)
	var loaded_data = save_manager.load_game(TEST_SAVE_SLOT)

	assert_eq(
		loaded_data.get("score"),
		100,
		"Score should match saved value"
	)
	assert_eq(
		loaded_data.get("level"),
		1,
		"Level should match saved value"
	)
	assert_eq(
		loaded_data.get("player_pos"),
		Vector2(100, 200),
		"Player position should match saved value"
	)
	assert_eq(
		loaded_data.get("lives"),
		3,
		"Lives should match saved value"
	)


func test_load_nonexistent_save():
	var save_manager = SaveManager.new()

	var loaded_data = save_manager.load_game(TEST_SAVE_SLOT)

	assert_true(loaded_data.is_empty(), "Should return empty dict for nonexistent save")


func test_save_game_includes_timestamp():
	var save_manager = SaveManager.new()
	var test_data = {"score": 100}

	var time_before = Time.get_unix_time_from_system()
	save_manager.save_game(TEST_SAVE_SLOT, test_data)
	var time_after = Time.get_unix_time_from_system()

	var metadata = save_manager.get_save_metadata(TEST_SAVE_SLOT)

	assert_not_null(metadata.get("save_time"), "Save should include timestamp")
	var save_time = metadata.get("save_time")
	assert_true(
		save_time >= time_before and save_time <= time_after,
		"Timestamp should be between time before and after save"
	)


func test_save_game_includes_version():
	var save_manager = SaveManager.new()
	var test_data = {"score": 100}

	save_manager.save_game(TEST_SAVE_SLOT, test_data)
	var metadata = save_manager.get_save_metadata(TEST_SAVE_SLOT)

	assert_eq(
		metadata.get("version"),
		1,
		"Save version should be 1"
	)


func test_delete_save_removes_file():
	var save_manager = SaveManager.new()
	var test_data = {"score": 100}

	save_manager.save_game(TEST_SAVE_SLOT, test_data)
	assert_true(FileAccess.file_exists(TEST_SAVE_PATH), "File should exist before delete")

	var result = save_manager.delete_save(TEST_SAVE_SLOT)
	assert_true(result, "delete_save should return true on success")
	assert_false(FileAccess.file_exists(TEST_SAVE_PATH), "File should be removed after delete")


func test_delete_nonexistent_save():
	var save_manager = SaveManager.new()

	var result = save_manager.delete_save(TEST_SAVE_SLOT)

	assert_false(result, "delete_save should return false for nonexistent save")


func test_save_exists_returns_true_for_existing_save():
	var save_manager = SaveManager.new()
	var test_data = {"score": 100}

	save_manager.save_game(TEST_SAVE_SLOT, test_data)

	assert_true(
		save_manager.save_exists(TEST_SAVE_SLOT),
		"save_exists should return true for existing save"
	)


func test_save_exists_returns_false_for_nonexistent_save():
	var save_manager = SaveManager.new()

	assert_false(
		save_manager.save_exists(TEST_SAVE_SLOT),
		"save_exists should return false for nonexistent save"
	)


func test_get_save_metadata_for_nonexistent_save():
	var save_manager = SaveManager.new()

	var metadata = save_manager.get_save_metadata(TEST_SAVE_SLOT)

	assert_true(metadata.is_empty(), "Should return empty dict for nonexistent save")


func test_save_game_overwrites_existing_save():
	var save_manager = SaveManager.new()
	var test_data_1 = {"score": 100}
	var test_data_2 = {"score": 200}

	save_manager.save_game(TEST_SAVE_SLOT, test_data_1)
	save_manager.save_game(TEST_SAVE_SLOT, test_data_2)

	var loaded_data = save_manager.load_game(TEST_SAVE_SLOT)
	assert_eq(
		loaded_data.get("score"),
		200,
		"Save should be overwritten with new data"
	)
