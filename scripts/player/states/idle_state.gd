# Idle State
# Player stands still when no movement input
# 空闲状态：玩家无移动输入时静止

class_name IdleState
extends PlayerStateBase


func _init() -> void:
	pass


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
		if not is_zero_approx(direction):
			transition_state(PlayerState.State.MOVE)
