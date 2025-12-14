class_name Player
extends CharacterBody2D

## 导出变量 - 在检查器中可配置
@export var move_speed: float = 150.0
@export var acceleration: float = 300.0
@export var friction: float = 1200.0
@export var jump_velocity: float = -320.0  # 跳跃初速度

## 私有变量
var gravity: float  # 从项目设置获取的重力

## 节点引用 - @onready 会在节点准备好后自动赋值
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

var player_components: PlayerComponents

## 初始化
func _ready() -> void:
	# 获取Godot默认重力设置
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	# 初始化状态机
	player_components = PlayerComponents.new()
	player_components.setup(self, animation_player)
	state_machine.init(self, player_components)


## 更新 - 处理逻辑
func _process(delta: float) -> void:
	# 更新状态机
	state_machine.update(delta)


## 输入处理 - 处理输入事件
func _input(event: InputEvent) -> void:
	# 传递输入给状态机
	state_machine.handle_input(event)


## 更新精灵朝向
func update_sprite_facing(input_direction: float) -> void:
	if input_direction < 0.0:
		# 向左移动
		sprite.flip_h = true
	elif input_direction > 0.0:
		# 向右移动
		sprite.flip_h = false


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
