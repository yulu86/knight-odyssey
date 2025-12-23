extends Node

# Player State Factory
# Factory class for creating and managing player state instances
# 使用枚举作为键来注册和获取状态
class_name PlayerStateFactory

## Dictionary mapping state enum values to state instances
## 状态枚举值到状态实例的映射字典
var states: Dictionary = {}


## Register a state with an enum key
## 使用枚举键注册状态
## @param state_type: The enum value for the state type
## @param state: The state instance to register
func register_state(state_type: int, state: PlayerStateBase) -> void:
	states[state_type] = state


## Get a state by enum key
## 通过枚举键获取状态
## @param state_type: The enum value for the state type
## @return: The state instance, or null if not found
func get_state(state_type: int) -> PlayerStateBase:
	if states.has(state_type):
		return states[state_type]
	return null
