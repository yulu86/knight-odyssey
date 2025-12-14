class_name JumpState
extends PlayerState

# 状态进入
func enter() -> void:
	# 触发跳跃
	player.velocity.y = player.jump_velocity
	# 播放跳跃动画
	play_animation("jump")


# 状态退出
func exit() -> void:
	# 清理状态相关资源
	pass


func update(delta: float) -> void:
	if player.velocity.y >= 0:
		# 已经达到最高点，开始下落
		transition_to_state(PlayerStateMachine.State.FALL)

	super.update(delta)
