extends Node

# Player State Machine
# State machine for managing player character states
# 使用枚举而不是字符串来管理状态
class_name PlayerStateMachine

## The currently active state
## 当前活动的状态
var current_state: PlayerStateBase = null

## Factory for creating and managing states
## 用于创建和管理状态的工厂
var states_factory: PlayerStateFactory = null

## Reference to the player components this state machine controls
## 此状态机控制的玩家组件引用
var components: PlayerComponents = null


func _init() -> void:
	states_factory = PlayerStateFactory.new()


## Change to a new state by enum type
## 通过枚举类型切换到新状态
## @param state_type: The enum value for the state to change to
func change_state(state_type: int) -> void:
	var new_state: PlayerStateBase = states_factory.get_state(state_type)

	if new_state == null:
		return

	# Exit the current state if exists
	if current_state != null:
		current_state.exit()

	# Set up the new state
	current_state = new_state
	current_state.setup(components)
	current_state.state_changed.connect(change_state)
	current_state.enter()


## Process the current state
## 处理当前状态
## @param delta: Time since the last frame
func process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)
