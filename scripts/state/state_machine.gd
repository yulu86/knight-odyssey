extends Node

# State machine for managing character states
# 用于管理角色状态的状态机
class_name StateMachine

## The currently active state
var current_state: Node = null

## Factory for creating and managing states
var states_factory: Node = null

## Reference to the character this state machine controls
var character: Node = null


func _init() -> void:
	states_factory = StateFactory.new()


## Change to a new state by key
## 通过键切换到新状态
func change_state(key: String) -> void:
	var new_state: Node = states_factory.get_state(key)

	if new_state == null:
		push_warning("State not found: " + key)
		return

	# Exit the current state if exists
	if current_state != null:
		current_state.exit()

	# Set up the new state
	current_state = new_state
	current_state.state_machine = self
	current_state.character = character
	current_state.enter()


## Process the current state
## 处理当前状态
func process(delta: float) -> void:
	if current_state != null:
		current_state.process(delta)


## Physics process the current state
## 物理处理当前状态
func physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_process(delta)
