class_name PlayerState
extends Node

## 引用父节点和系统
var player: Player
var state_machine: PlayerStateMachine
var animation_player: AnimationPlayer

## 初始化 - 设置引用
func init(player_node: Player, state_machine_node: PlayerStateMachine) -> void:
	player = player_node
	state_machine = state_machine_node
	animation_player = player_node.animation_player


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


## 虚方法 - 物理更新
func physics_update(_delta: float) -> void:
	# 子类实现具体逻辑
	pass


## 虚方法 - 输入处理
func handle_input(_event: InputEvent) -> void:
	# 子类实现具体逻辑
	pass


## 辅助方法 - 检查移动输入
func get_movement_input() -> float:
	return player.handle_movement_input()


## 辅助方法 - 应用移动
func apply_movement(input_direction: float, delta: float) -> void:
	player.apply_movement(input_direction, delta)
	player.execute_movement()


## 辅助方法 - 播放动画
func play_animation(anim_name: String) -> void:
	player.play_animation(anim_name)


## 辅助方法 - 更新精灵朝向
func update_sprite_facing(input_direction: float) -> void:
	player.update_sprite_facing(input_direction)


## 辅助方法 - 检查是否在地面上
func is_on_ground() -> bool:
	return player.is_on_ground()
