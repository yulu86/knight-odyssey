# Idle State
# Player stands still when no movement input
# 空闲状态：玩家无移动输入时静止

class_name IdleState
extends OnFloorState


const IDLE_ANIMATION_NAME := &"idle"


func _init() -> void:
	state_type = PlayerState.State.IDLE


func enter() -> void:
	# Play idle animation when entering idle state
	if player != null and animation_player != null and animation_player.has_animation(IDLE_ANIMATION_NAME):
		animation_player.play(IDLE_ANIMATION_NAME)


func exit() -> void:
	# Clean up when exiting idle state
	pass


func process(_delta: float) -> void:
	super.process(_delta)

	if player == null:
		return

	# Check for jump input first (higher priority than movement)
	if Input.is_action_pressed("jump"):
		transition_state(PlayerState.State.JUMP)
		return

	# Check for movement input
	var direction = get_input_direction()
	if not is_zero_approx(direction):
		transition_state(PlayerState.State.MOVE)

	player.move_and_slide()
