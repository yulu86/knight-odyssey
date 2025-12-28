extends Node

# Player State Factory
# Factory class for creating and managing player state instances
# 使用枚举作为键来注册和获取状态
class_name PlayerStateFactory

## Dictionary mapping state enum values to state instances
## 状态枚举值到状态实例的映射字典
var states: Dictionary = {}


func _init() -> void:
	# Register all available states	
	states[PlayerState.State.IDLE] = IdleState
	states[PlayerState.State.MOVE] = WalkState
	states[PlayerState.State.JUMP] = JumpState
	states[PlayerState.State.FALL] = FallState


## Get a state by enum key
## 通过枚举键获取状态
## @param state_type: The enum value for the state type
## @return: The state instance, or null if not found
func get_state(state: PlayerState.State) -> PlayerStateBase:
	if states.has(state):
		return states[state].new()
	return null
