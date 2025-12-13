class_name PlayerState
extends Node


@warning_ignore("unused_signal")
signal state_changed(new_state: PlayerStateMachine.State)


## 引用父节点和系统
var player: Player
var animation_player: AnimationPlayer

## 初始化 - 设置引用
func init(context_player: Player) -> void:
	player = context_player
	animation_player = context_player.animation_player


## 虚方法 - 状态进入时调用
func enter() -> void:
	# 子类实现具体逻辑
	pass


## 虚方法 - 状态退出时调用
func exit() -> void:
	# 子类实现具体逻辑
	pass


## 虚方法 - 每帧更新
func update(_delta: float) -> void:
	# 子类实现具体逻辑
	pass


## 虚方法 - 输入处理
func handle_input(_event: InputEvent) -> void:
	# 子类实现具体逻辑
	pass


## 辅助方法 - 是否水平无输入
func has_no_horizontal_input(input_direction: float = get_horizontal_movement_direction()) -> bool:
	return input_direction == 0.0


## 辅助方法 - 水平移动输入方向
func get_horizontal_movement_direction() -> float:
	var input_direction: float = 0.0

	# 使用输入动作获取方向
	if Input.is_action_pressed("move_left"):
		input_direction -= 1.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1.0

	return input_direction


## 辅助方法 - 应用移动
func move(input_direction: float, delta: float) -> void:
	player.update_velocity(input_direction, delta)
	player.move_and_slide()


## 辅助方法 - 播放动画
func play_animation(anim_name: String) -> void:	
	player.play_animation(anim_name)


## 辅助方法 - 更新精灵朝向
func update_sprite_facing(input_direction: float) -> void:
	player.update_sprite_facing(input_direction)


## 辅助方法 - 检查是否在地面上
func is_on_ground() -> bool:
	return player.is_on_ground()


func transition_to_state(new_state: PlayerStateMachine.State) -> void:
	state_changed.emit(new_state)
