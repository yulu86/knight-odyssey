class_name FallState
extends PlayerState

# 状态进入
func enter() -> void:
	# 播放下落动画
	play_animation("fall")


# 状态退出
func exit() -> void:
	# 播放着陆动画（如果有）
	if is_on_ground():
		play_animation("land")


# 每帧更新
func update(delta: float) -> void:
	# 检查着陆
	check_landing()

	super.update(delta)


# 私有方法 - 检查着陆
func check_landing() -> void:
	if is_on_ground():
		# 根据水平输入决定转换到Idle还是Walk
		if not has_input_direction():
			transition_to_state(PlayerStateMachine.State.IDLE)
		else:
			transition_to_state(PlayerStateMachine.State.WALK)
