class_name JumpState
extends PlayerState

## 状态进入
func enter() -> void:
	# 播放跳跃动画（如果有）
	play_animation("jump")


## 状态退出
func exit() -> void:
	# 清理状态相关逻辑
	pass


## 物理更新
func physics_update(delta: float) -> void:
	# 获取移动输入
	var input_direction: float = get_movement_input()

	# 应用空中移动（空中控制力稍弱）
	apply_movement(input_direction * 0.8, delta)

	# 更新精灵朝向
	if input_direction != 0.0:
		update_sprite_facing(input_direction)

	# 检查是否开始下落
	if player.velocity.y > 0:
		state_machine.change_state(PlayerStateMachine.State.FALL)


## 输入处理
func handle_input(_event: InputEvent) -> void:
	# 跳跃状态的输入处理
	pass
