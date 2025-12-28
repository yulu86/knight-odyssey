extends Node

# Player State Base Class
# Base class for all player states
# 子类必须实现具体的行为逻辑
class_name PlayerStateBase


## Signal emitted when requesting a state transition
## 发出状态转换请求时触发此信号
## @param to_state: The target state to transition to
signal state_changed(to_state: PlayerState.State)


var player: Player
var sprite_2d: Sprite2D
var animation_player: AnimationPlayer
var config_manager: ConfigManager

## The state type enum value for this state
## 此状态的类型枚举值
var state_type: PlayerState.State = PlayerState.State.IDLE


func setup(components: PlayerComponents) -> void:
	player = components.player
	sprite_2d = components.sprite_2d
	animation_player = components.animation_player
	config_manager = components.config_manager


## Called when entering this state
## 进入此状态时调用
func enter() -> void:
	pass


## Called when exiting this state
## 退出此状态时调用
func exit() -> void:
	pass


## Called every frame
## 每帧调用
## @param delta: Time since the last frame
func process(_delta: float) -> void:
	pass


## Request a transition to another state
## 请求转换到另一个状态
## @param to_state: The target state to transition to
func transition_state(to_state: PlayerState.State) -> void:
	state_changed.emit(to_state)


func get_input_direction() -> float:
	return Input.get_axis("move_left", "move_right")


## Update sprite facing direction based on movement direction
func update_sprite_facing(direction: float) -> void:
	if sprite_2d != null:
		if direction > 0:
			sprite_2d.flip_h = false
		else:
			sprite_2d.flip_h = true


## Apply gravity to player vertical velocity
## @param delta: Time since the last frame
func apply_gravity(delta: float) -> void:
	if player != null and config_manager != null:
		var gravity = config_manager.get_gravity()
		player.velocity.y += gravity * delta


## Apply air control (horizontal movement while in air)
## @param delta: Time since the last frame
func apply_air_control(delta: float) -> void:
	if player == null or config_manager == null:
		return

	var direction = get_input_direction()
	var air_acceleration = config_manager.get_air_acceleration()
	var air_friction = config_manager.get_air_friction()

	if is_zero_approx(direction):
		player.velocity.x = move_toward(player.velocity.x, 0.0, air_friction * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, direction * config_manager.get_walk_speed(), air_acceleration * delta)
		update_sprite_facing(direction)
