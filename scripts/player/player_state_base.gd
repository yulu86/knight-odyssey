extends Node

# Player State Base Class
# Base class for all player states
# 子类必须实现具体的行为逻辑
class_name PlayerStateBase


signal state_changed(to_state: PlayerState.State)


## Reference to the player state machine managing this state
var state_machine: Node = null

## Reference to the player character this state operates on
var character: CharacterBody2D = null


## Called when entering this state
## 进入此状态时调用
func enter() -> void:
	pass


## Called when exiting this state
## 退出此状态时调用
func exit() -> void:
	pass


## Called every frame
## 每帧调用
## @param delta: Time since the last frame
func process(_delta: float) -> void:
	pass


func transition_state(to_state: PlayerState.State) -> void:
	state_changed.emit(to_state)
