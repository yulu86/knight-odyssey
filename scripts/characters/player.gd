class_name Player
extends CharacterBody2D

## 导出变量 - 在检查器中可配置
@export var move_speed: float = 150.0
@export var acceleration: float = 300.0
@export var friction: float = 1200.0
@export var jump_velocity: float = -240.0  # 跳跃初速度

## 私有变量
var gravity: float  # 从项目设置获取的重力
var is_jumping: bool = false  # 跳跃状态标志

## 节点引用 - @onready 会在节点准备好后自动赋值
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

## 初始化
func _ready() -> void:
	# 获取Godot默认重力设置
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	# 初始化状态机
	state_machine.init(self)


## 更新 - 每帧调用，处理逻辑
func _process(delta: float) -> void:
	# 应用重力
	apply_gravity(delta)

	# 如果在地面上且不在跳跃状态，重置跳跃标志
	if is_on_floor() and velocity.y >= 0:
		reset_jump_state()

	# 更新状态机
	state_machine.update(delta)

	# 执行移动
	move_and_slide()


## 输入处理 - 处理输入事件
func _input(event: InputEvent) -> void:
	# 传递输入给状态机
	state_machine.handle_input(event)


## 移动处理 - 应用速度和移动
func update_velocity(input_direction: float, delta: float) -> void:
	# 计算目标速度
	var target_velocity: float = input_direction * move_speed

	# 使用加速和摩擦平滑过渡到目标速度
	if input_direction != 0.0:
		velocity.x = move_toward(velocity.x, target_velocity, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)


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


## 跳跃相关方法

## 应用重力
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		# 限制最大下落速度
		velocity.y = min(velocity.y, gravity * 2)

## 执行跳跃
func jump() -> void:
	if is_on_floor() and not is_jumping:
		velocity.y = jump_velocity
		is_jumping = true

## 检查是否可以跳跃
func can_jump() -> bool:
	return is_on_floor() and not is_jumping

## 重置跳跃状态
func reset_jump_state() -> void:
	is_jumping = false

## 获取跳跃状态
func get_jump_state() -> bool:
	return is_jumping
