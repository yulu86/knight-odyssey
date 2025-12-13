class_name FallState
extends PlayerState

## 状态进入
func enter() -> void:
	# 播放下落动画（如果有）
	play_animation("fall")


## 状态退出
func exit() -> void:
	# 清理状态相关逻辑
	pass


## 物理更新
func update(delta: float) -> void:
	# 获取移动输入
	var input_direction: float = get_movement_input()

	# 应用空中移动
	apply_movement(input_direction * 0.8, delta)

	# 更新精灵朝向
	if input_direction != 0.0:
		update_sprite_facing(input_direction)

	# 检查是否着陆
	if is_on_ground():
		# 根据水平速度决定进入空闲或行走状态
		if abs(player.velocity.x) > 10.0:
			state_changed.emit(PlayerStateMachine.State.WALK)
		else:
			state_changed.emit(PlayerStateMachine.State.IDLE)


## 输入处理
func handle_input(_event: InputEvent) -> void:
	# 下落状态的输入处理
	pass
