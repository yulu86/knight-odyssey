extends RefCounted
class_name PlayerComponents


var player: Player
var animation_player: AnimationPlayer


func setup(context_player: Player, context_animation_player: AnimationPlayer) -> void:
	player = context_player
	animation_player = context_animation_player
