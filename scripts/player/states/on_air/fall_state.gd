# Fall State
# Player falls downward
# 下落状态：玩家向下下落

class_name FallState
extends OnAirState


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


## Check for landing - transition to idle or move based on input
## 检查是否落地 - 根据输入切换到空闲或移动状态
## @param delta: Time since the last frame
func check_state_transitions(_delta: float) -> void:
	if player == null:
		return

	# Check for landing - transition to idle or move based on input
	if player.is_on_floor():
		var direction = get_input_direction()
		if is_zero_approx(direction) and is_zero_approx(player.velocity.x):
			transition_state(PlayerState.State.IDLE)
		else:
			transition_state(PlayerState.State.MOVE)
