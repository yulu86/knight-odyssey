class_name WalkState
extends PlayerState

## 状态进入
func enter() -> void:
	# 播放walk动画
	play_animation("walk")


## 状态退出
func exit() -> void:
	# 清理状态相关逻辑（目前不需要）
	pass


## 物理更新
func physics_update(delta: float) -> void:
	# 获取移动输入
	var input_direction: float = get_movement_input()

	# 如果没有移动输入，切换到空闲状态
	if input_direction == 0.0:
		state_machine.change_state(PlayerStateMachine.State.IDLE)
		return

	# 应用移动
	apply_movement(input_direction, delta)

	# 更新精灵朝向
	update_sprite_facing(input_direction)


## 输入处理
func handle_input(event: InputEvent) -> void:
	# 目前行走状态不需要特殊输入处理
	pass