# EventBus - Global event bus for game-wide communication
# This is an AutoLoad singleton, do NOT use class_name
extends Node

# Score signals
@warning_ignore("unused_signal")
signal score_updated(new_score: int)

# Lives/health signals
@warning_ignore("unused_signal")
signal lives_updated(new_lives: int)

# Game state signals
@warning_ignore("unused_signal")
signal game_paused(is_paused: bool)

# Gameplay event signals
@warning_ignore("unused_signal")
signal coin_collected(value: int)

@warning_ignore("unused_signal")
signal player_damaged(damage: int)
