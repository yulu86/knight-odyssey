extends GutTest

# ConfigManager Test
# 测试配置管理器功能

var ConfigManagerClass = load("res://scripts/managers/config_manager.gd")
var config_manager: ConfigManager
var test_config_path = "user://test_player.cfg"

func before_each():
	# 每个测试前的准备工作
	config_manager = ConfigManagerClass.new()
	# 清理之前的测试文件
	if FileAccess.file_exists(test_config_path):
		DirAccess.remove_absolute(test_config_path)

func after_each():
	# 每个测试后的清理工作
	if config_manager:
		config_manager = null
	# 清理测试文件
	if FileAccess.file_exists(test_config_path):
		DirAccess.remove_absolute(test_config_path)

func test_config_manager_class_exists():
	# 测试 ConfigManager 类是否存在
	assert_not_null(ConfigManager, "ConfigManager class should exist")

func test_config_manager_can_be_instantiated():
	# 测试 ConfigManager 是否可以被实例化
	assert_not_null(config_manager, "ConfigManager should be instantiable")

func test_load_player_config():
	# 测试加载玩家配置功能
	# 首先创建一个测试配置文件
	var test_config = ConfigFile.new()
	test_config.set_value("player", "speed", 200.0)
	test_config.set_value("player", "jump_velocity", -400.0)
	test_config.save(test_config_path)

	# 测试加载配置
	var result = config_manager.load_player_config(test_config_path)
	assert_true(result, "Loading player config should succeed")

	# 验证配置值
	assert_eq(config_manager.get_player_speed(), 200.0, "Player speed should be 200.0")
	assert_eq(config_manager.get_player_jump_velocity(), -400.0, "Player jump velocity should be -400.0")

func test_load_default_config_when_file_missing():
	# 测试配置文件不存在时加载默认值
	var result = config_manager.load_player_config("non_existent_file.cfg")
	assert_false(result, "Loading non-existent config should fail")

	# 应该返回默认值
	assert_eq(config_manager.get_player_speed(), 200.0, "Default player speed should be 200.0")
	assert_eq(config_manager.get_player_jump_velocity(), -400.0, "Default player jump velocity should be -400.0")

func test_get_player_speed_returns_correct_value():
	# 测试获取玩家速度的方法返回正确的值
	config_manager.load_player_config(test_config_path)
	var speed = config_manager.get_player_speed()
	assert_eq(speed, 200.0, "get_player_speed should return correct speed value")

func test_get_player_jump_velocity_returns_correct_value():
	# 测试获取玩家跳跃速度的方法返回正确的值
	config_manager.load_player_config(test_config_path)
	var jump_velocity = config_manager.get_player_jump_velocity()
	assert_eq(jump_velocity, -400.0, "get_player_jump_velocity should return correct jump velocity value")

func test_config_manager_handles_invalid_config_file():
	# 测试配置管理器处理无效配置文件
	# 创建一个缺少player节的配置文件
	var file = FileAccess.open(test_config_path, FileAccess.WRITE)
	file.store_string("[other_section]\nsome_value=123\n")
	file.close()

	# 尝试加载无效配置
	var result = config_manager.load_player_config(test_config_path)
	assert_false(result, "Loading invalid config should fail")

	# 应该使用默认值
	assert_eq(config_manager.get_player_speed(), 200.0, "Should use default speed when config is invalid")
	assert_eq(config_manager.get_player_jump_velocity(), -400.0, "Should use default jump velocity when config is invalid")

func test_load_actual_player_config():
	# 测试加载实际的玩家配置文件
	# 这个测试会在实际配置文件创建后通过
	var actual_config_path = "res://configs/player.cfg"

	# 如果配置文件存在，测试加载它
	if FileAccess.file_exists(actual_config_path):
		var result = config_manager.load_player_config(actual_config_path)
		assert_true(result, "Loading actual player config should succeed")

		# 验证实际的配置值
		assert_eq(config_manager.get_player_speed(), 200.0, "Actual player speed should be 200.0")
		assert_eq(config_manager.get_player_jump_velocity(), -400.0, "Actual player jump velocity should be -400.0")
	else:
		# 如果配置文件不存在，跳过测试
		pass_test("Player config file does not exist yet - skipping")