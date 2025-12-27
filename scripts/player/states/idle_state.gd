# Idle State
# Player stands still when no movement input
# 空闲状态：玩家无移动输入时静止

class_name IdleState
extends PlayerStateBase


func _init() -> void:
	pass


func enter() -> void:
	# Reset velocity when entering idle state
	if player != null:
		player.velocity = Vector2.ZERO
		if animation_player != null and animation_player.has_animation(&"idle"):
			animation_player.play(&"idle")


func exit() -> void:
	# Clean up when exiting idle state
	pass


func process(_delta: float) -> void:
	# Check for movement input
	if player != null:
		var direction = Input.get_axis("move_left", "move_right")
		if not is_zero_approx(direction):
			transition_state(PlayerState.State.MOVE)
