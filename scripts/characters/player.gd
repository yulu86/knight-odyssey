class_name Player
extends CharacterBody2D

## 导出变量 - 在检查器中可配置
@export var move_speed: float = 300.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0

## 节点引用 - @onready 会在节点准备好后自动赋值
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

## 初始化
func _ready() -> void:
	# 初始化状态机
	state_machine.init(self)


## 物理更新 - 每帧调用，处理物理相关逻辑
func _physics_process(delta: float) -> void:
	# 更新状态机
	state_machine.physics_process(delta)


## 输入处理 - 处理输入事件
func _input(event: InputEvent) -> void:
	# 传递输入给状态机
	state_machine.handle_input(event)


## 获取移动输入 - 返回-1(左)、0(停止)、1(右)
func handle_movement_input() -> float:
	var input_direction: float = 0.0

	# 使用输入动作获取方向
	if Input.is_action_pressed("move_left"):
		input_direction -= 1.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1.0

	return input_direction


## 移动处理 - 应用速度和移动
func apply_movement(input_direction: float, delta: float) -> void:
	# 计算目标速度
	var target_velocity: float = input_direction * move_speed

	# 使用加速和摩擦平滑过渡到目标速度
	if input_direction != 0.0:
		velocity.x = move_toward(velocity.x, target_velocity, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)


## 执行移动
func execute_movement() -> void:
	# 使用CharacterBody2D的move_and_slide方法
	move_and_slide()


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
	if animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
	else:
		print("警告：动画 '", anim_name, "' 不存在")
