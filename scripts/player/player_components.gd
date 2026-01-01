class_name PlayerComponents
extends RefCounted


var player: Player
var sprite_2d: Sprite2D
var animation_player: AnimationPlayer
var config_manager: ConfigManager


func _init(context_player: Player):
	self.player = context_player
	self.sprite_2d = context_player.sprite_2d
	self.animation_player = context_player.animation_player
	self.config_manager = ConfigManager
