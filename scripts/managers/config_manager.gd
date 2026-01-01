# ConfigManager
# 配置管理器类，负责加载和管理游戏配置
extends Node

# 默认配置值
const DEFAULT_PLAYER_SPEED: float = 200.0
const DEFAULT_PLAYER_JUMP_VELOCITY: float = -400.0
const DEFAULT_WALK_SPEED: float = 200.0
const DEFAULT_ACCELERATION: float = 800.0
const DEFAULT_FRICTION: float = 800.0
const DEFAULT_GRAVITY: float = 1200.0
const DEFAULT_AIR_ACCELERATION: float = 600.0
const DEFAULT_AIR_FRICTION: float = 1000.0

# 当前配置值
var player_speed: float
var player_jump_velocity: float
var walk_speed: float
var acceleration: float
var friction: float
var gravity: float
var air_acceleration: float
var air_friction: float

func _init():
	# 初始化默认值
	player_speed = DEFAULT_PLAYER_SPEED
	player_jump_velocity = DEFAULT_PLAYER_JUMP_VELOCITY
	walk_speed = DEFAULT_WALK_SPEED
	acceleration = DEFAULT_ACCELERATION
	friction = DEFAULT_FRICTION
	gravity = DEFAULT_GRAVITY
	air_acceleration = DEFAULT_AIR_ACCELERATION
	air_friction = DEFAULT_AIR_FRICTION

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
	walk_speed = config.get_value("player", "walk_speed", DEFAULT_WALK_SPEED)
	acceleration = config.get_value("player", "acceleration", DEFAULT_ACCELERATION)
	friction = config.get_value("player", "friction", DEFAULT_FRICTION)
	gravity = config.get_value("player", "gravity", DEFAULT_GRAVITY)
	air_acceleration = config.get_value("player", "air_acceleration", DEFAULT_AIR_ACCELERATION)
	air_friction = config.get_value("player", "air_friction", DEFAULT_AIR_FRICTION)

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
	walk_speed = DEFAULT_WALK_SPEED
	acceleration = DEFAULT_ACCELERATION
	friction = DEFAULT_FRICTION
	gravity = DEFAULT_GRAVITY
	air_acceleration = DEFAULT_AIR_ACCELERATION
	air_friction = DEFAULT_AIR_FRICTION
	print("Config reset to default values")


# 获取行走速度
# @return: 行走速度值
func get_walk_speed() -> float:
	return walk_speed

# 获取加速度
# @return: 加速度值
func get_acceleration() -> float:
	return acceleration

# 获取摩擦力
# @return: 摩擦力值
func get_friction() -> float:
	return friction

# 设置行走速度
# @param speed: 新的行走速度值
func set_walk_speed(speed: float):
	walk_speed = speed

# 设置加速度
# @param accel: 新的加速度值
func set_acceleration(accel: float):
	acceleration = accel

# 设置摩擦力
# @param fric: 新的摩擦力值
func set_friction(fric: float):
	friction = fric


# 获取重力
# @return: 重力加速度值
func get_gravity() -> float:
	return gravity


# 获取空中加速度
# @return: 空中加速度值
func get_air_acceleration() -> float:
	return air_acceleration


# 获取空中摩擦力
# @return: 空中摩擦力值
func get_air_friction() -> float:
	return air_friction


# 设置重力
# @param g: 新的重力加速度值
func set_gravity(g: float):
	gravity = g


# 设置空中加速度
# @param accel: 新的空中加速度值
func set_air_acceleration(accel: float):
	air_acceleration = accel


# 设置空中摩擦力
# @param fric: 新的空中摩擦力值
func set_air_friction(fric: float):
	air_friction = fric