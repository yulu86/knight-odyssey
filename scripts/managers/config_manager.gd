extends Node

## 配置管理器单例
## 负责加载和管理游戏配置文件

# 配置文件路径
const CONFIG_PATH = "res://configs/player_config.cfg"

# 内部配置存储
var _config_file: ConfigFile
var _is_loaded: bool = false


## 初始化，加载配置文件
func _ready() -> void:
	load_config()


## 加载配置文件
func load_config() -> void:
	_config_file = ConfigFile.new()

	# 尝试加载配置文件
	var err = _config_file.load(CONFIG_PATH)

	if err != OK:
		print("Load player config failed, error code: ", err)
		_is_loaded = false
	else:		
		_is_loaded = true


## 获取玩家配置值
## @param key: 配置键名
## @param default_value: 默认值（当配置不存在时使用）
func get_player_value(key: String, default_value) -> Variant:
	if not _is_loaded:
		return default_value

	return _config_file.get_value("player", key, default_value)
