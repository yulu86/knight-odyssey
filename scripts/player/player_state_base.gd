extends Node

# Player State Base Class
# Base class for all player states
# 子类必须实现具体的行为逻辑
class_name PlayerStateBase

## Reference to the player state machine managing this state
var state_machine: Node = null

## Reference to the player character this state operates on
var character: CharacterBody2D = null

## The state type enum value for this state
## Should be set by subclasses using PlayerState enum
var state_type: = -1


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
func process(delta: float) -> void:
	pass


## Called every physics frame
## 每个物理帧调用
## @param delta: Time since the last physics frame
func physics_process(delta: float) -> void:
	pass


## Handle input events
## 处理输入事件
## @param event: The input event to handle
func handle_input(event: InputEvent) -> void:
	pass
