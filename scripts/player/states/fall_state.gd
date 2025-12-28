# Fall State
# Player falls downward
# 下落状态：玩家向下下落

class_name FallState
extends PlayerStateBase


const FALL_ANIMATION_NAME := &"fall"


func _init() -> void:
	state_type = PlayerState.State.FALL


func enter() -> void:
	# Play fall animation when entering fall state
	if animation_player != null and animation_player.has_animation(FALL_ANIMATION_NAME):
		animation_player.play(FALL_ANIMATION_NAME)


func exit() -> void:
	# Clean up when exiting fall state
	pass


func process(delta: float) -> void:
	if player == null:
		return

	# Apply gravity
	apply_gravity(delta)

	# Apply air control (horizontal movement while falling)
	apply_air_control(delta)

	# Check for landing - transition to idle or move based on input
	if player.is_on_floor():
		var direction = get_input_direction()
		if is_zero_approx(direction):
			transition_state(PlayerState.State.IDLE)
		else:
			transition_state(PlayerState.State.MOVE)

	player.move_and_slide()
