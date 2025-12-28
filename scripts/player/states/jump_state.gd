# Jump State
# Player jumps upward
# 跳跃状态：玩家向上跳跃

class_name JumpState
extends PlayerStateBase


const JUMP_ANIMATION_NAME := &"jump"


func _init() -> void:
	state_type = PlayerState.State.JUMP


func enter() -> void:
	# Play jump animation when entering jump state
	if animation_player != null and animation_player.has_animation(JUMP_ANIMATION_NAME):
		animation_player.play(JUMP_ANIMATION_NAME)

	# Set jump velocity when entering jump state
	if player != null and config_manager != null:
		var jump_velocity = config_manager.get_player_jump_velocity()
		player.velocity.y = jump_velocity


func exit() -> void:
	# Clean up when exiting jump state
	pass


func process(delta: float) -> void:
	if player == null:
		return

	# Apply gravity
	apply_gravity(delta)

	# Apply air control (horizontal movement while jumping)
	apply_air_control(delta)

	# Transition to fall state when velocity becomes positive (falling)
	if player.velocity.y > 0:
		transition_state(PlayerState.State.FALL)

	player.move_and_slide()
