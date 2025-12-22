# ConfigManager
# 配置管理器类，负责加载和管理游戏配置
class_name ConfigManager
extends RefCounted

# 默认配置值
const DEFAULT_PLAYER_SPEED: float = 200.0
const DEFAULT_PLAYER_JUMP_VELOCITY: float = -400.0

# 当前配置值
var player_speed: float
var player_jump_velocity: float

func _init():
	# 初始化默认值
	player_speed = DEFAULT_PLAYER_SPEED
	player_jump_velocity = DEFAULT_PLAYER_JUMP_VELOCITY

# 加载玩家配置
# @param config_path: 配置文件路径
# @return: 是否成功加载配置
func load_player_config(config_path: String) -> bool:
	var config = ConfigFile.new()

	# 检查文件是否存在
	if not FileAccess.file_exists(config_path):
		print("Warning: Config file not found: ", config_path, ". Using default values.")
		return false

	# 尝试加载配置文件
	var load_result = config.load(config_path)
	if load_result != OK:
		print("Error: Failed to load config file: ", config_path, ". Error code: ", load_result)
		return false

	# 验证配置文件是否包含所需的节和键
	if not config.has_section("player"):
		print("Error: Config file missing [player] section")
		return false

	# 读取配置值
	player_speed = config.get_value("player", "speed", DEFAULT_PLAYER_SPEED)
	player_jump_velocity = config.get_value("player", "jump_velocity", DEFAULT_PLAYER_JUMP_VELOCITY)

	print("Config loaded successfully from: ", config_path)
	print("Player speed: ", player_speed)
	print("Player jump velocity: ", player_jump_velocity)

	return true

# 获取玩家速度
# @return: 玩家速度值
func get_player_speed() -> float:
	return player_speed

# 获取玩家跳跃速度
# @return: 玩家跳跃速度值
func get_player_jump_velocity() -> float:
	return player_jump_velocity

# 设置玩家速度
# @param speed: 新的速度值
func set_player_speed(speed: float):
	player_speed = speed

# 设置玩家跳跃速度
# @param jump_velocity: 新的跳跃速度值
func set_player_jump_velocity(jump_velocity: float):
	player_jump_velocity = jump_velocity

# 保存配置到文件
# @param config_path: 保存路径
# @return: 是否成功保存
func save_player_config(config_path: String) -> bool:
	var config = ConfigFile.new()

	# 设置配置值
	config.set_value("player", "speed", player_speed)
	config.set_value("player", "jump_velocity", player_jump_velocity)

	# 保存到文件
	var save_result = config.save(config_path)
	if save_result != OK:
		print("Error: Failed to save config file: ", config_path, ". Error code: ", save_result)
		return false

	print("Config saved successfully to: ", config_path)
	return true

# 重置为默认配置值
func reset_to_defaults():
	player_speed = DEFAULT_PLAYER_SPEED
	player_jump_velocity = DEFAULT_PLAYER_JUMP_VELOCITY
	print("Config reset to default values")