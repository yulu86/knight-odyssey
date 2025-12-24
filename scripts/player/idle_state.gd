# Idle State
# Player stands still when no movement input
# 空闲状态：玩家无移动输入时静止

class_name IdleState
extends PlayerStateBase

## Transition flag to indicate state change
## Should be checked by state machine to determine next state
var transition_state: int = -1


func _init() -> void:
	state_type = PlayerState.State.IDLE


func enter() -> void:
	# Reset velocity when entering idle state
	if character != null:
		character.velocity = Vector2.ZERO


func exit() -> void:
	# Clean up when exiting idle state
	pass


func process(_delta: float) -> void:
	# Check for movement input
	if character != null:
		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			transition_state = PlayerState.State.MOVE
		else:
			transition_state = -1
