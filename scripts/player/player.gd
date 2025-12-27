extends CharacterBody2D

# Player class
# Handles player character behavior
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine


func _ready() -> void:
	if player_state_machine != null:
		var components = PlayerComponents.new(self)
		player_state_machine.components = components
		player_state_machine.change_state(PlayerState.State.IDLE)


func _process(_delta: float) -> void:
	# Called every frame
	pass
