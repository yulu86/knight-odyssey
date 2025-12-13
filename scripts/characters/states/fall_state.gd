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
	# 处理水平移动（空中控制）
	var input_direction = get_horizontal_movement_direction()
	move(input_direction, delta)
	update_sprite_facing(input_direction)

	# 检查着陆
	check_landing()


# 输入处理
func handle_input(_event: InputEvent) -> void:
	# Fall状态下主要处理移动输入
	pass


# 私有方法 - 检查着陆
func check_landing() -> void:
	if is_on_ground():
		# 根据水平输入决定转换到Idle还是Walk
		if has_no_horizontal_input():
			transition_to_state(PlayerStateMachine.State.IDLE)
		else:
			transition_to_state(PlayerStateMachine.State.WALK)


## 移动处理 - 更新速度和移动
func update_velocity(player_velocity: Vector2, input_direction: float, delta: float) -> Vector2:
	player_velocity = super.update_velocity(player_velocity, input_direction, delta)
	
	# 在下落状态下应用重力，加速下落
	player_velocity.y += player.gravity * delta

	# 限制最大下落速度，防止下落过快
	var max_fall_speed = player.gravity * 2
	player_velocity.y = min(player_velocity.y, max_fall_speed)

	return player_velocity
