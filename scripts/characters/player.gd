class_name Player
extends CharacterBody2D

## 移动相关参数 - 从配置文件加载
var move_speed: float
var acceleration: float
var floor_friction: float
var air_friction: float
var jump_velocity: float  # 跳跃初速度

## 调试参数 - 保留在检查器中可配置
@export var is_debug: bool = false

## 节点引用 - @onready 会在节点准备好后自动赋值
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

var player_components: PlayerComponents


## 初始化
func _ready() -> void:
	# 从配置管理器加载参数
	load_player_config()

	# 初始化状态机
	player_components = PlayerComponents.new()
	player_components.setup(self, sprite, animation_player)
	state_machine.init(player_components)

## 加载玩家配置
func load_player_config() -> void:
	move_speed = ConfigManager.get_player_value("move_speed", 150.0)
	acceleration = ConfigManager.get_player_value("acceleration", 300.0)
	floor_friction = ConfigManager.get_player_value("floor_friction", 1200.0)
	air_friction = ConfigManager.get_player_value("air_friction", 1800.0)
	jump_velocity = ConfigManager.get_player_value("jump_velocity", -320.0)
	is_debug = ConfigManager.get_player_value("is_debug", false)


## 更新 - 处理逻辑
func _process(delta: float) -> void:
	# 更新状态机
	state_machine.update(delta)


## 输入处理 - 处理输入事件
func _input(event: InputEvent) -> void:
	# 传递输入给状态机
	state_machine.handle_input(event)


## 检查是否在地面上
func is_on_ground() -> bool:
	return is_on_floor()


## 获取当前水平速度
func get_horizontal_speed() -> float:
	return velocity.x


## 播放动画
func play_animation(anim_name: String) -> void:
	assert(animation_player.has_animation(anim_name), "Invalid player animate name: " + anim_name)
	if not animation_player.current_animation == anim_name:
		animation_player.play(anim_name)
