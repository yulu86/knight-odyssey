extends CharacterBody2D

# Player class
# Handles player character behavior
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# Called when the node enters the scene tree for the first time.
	pass


func _process(_delta: float) -> void:
	# Called every frame
	pass
