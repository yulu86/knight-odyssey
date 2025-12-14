extends RefCounted
class_name PlayerComponents


var player: Player
var sprite: Sprite2D
var animation_player: AnimationPlayer


func setup(context_player: Player, context_sprite: Sprite2D, context_animation_player: AnimationPlayer) -> void:
	player = context_player
	sprite = context_sprite
	animation_player = context_animation_player
