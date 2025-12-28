# On Air State Base Class
# Base class for all airborne player states (jump, fall)
# 空中状态基类：所有空中玩家状态的基类（跳跃、下落）

class_name OnAirState
extends PlayerStateBase


## Apply air control (horizontal movement while in air)
## 应用空中控制（空中的水平移动）
## @param delta: Time since the last frame
func apply_air_control(delta: float) -> void:
	if player == null or config_manager == null:
		return

	var direction = get_input_direction()
	var air_acceleration = config_manager.get_air_acceleration()
	var air_friction = config_manager.get_air_friction()

	if is_zero_approx(direction):
		player.velocity.x = move_toward(player.velocity.x, 0.0, air_friction * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, direction * config_manager.get_walk_speed(), air_acceleration * delta)
		update_sprite_facing(direction)