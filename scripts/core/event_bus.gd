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

# Scene management signals
@warning_ignore("unused_signal")
signal scene_changed(scene_name: String)

@warning_ignore("unused_signal")
signal scene_loading_started(scene_path: String)

@warning_ignore("unused_signal")
signal scene_loading_progress(progress: float)

@warning_ignore("unused_signal")
signal scene_loading_finished(scene_path: String)

# Game initialization signals
@warning_ignore("unused_signal")
signal game_manager_initialized()

@warning_ignore("unused_signal")
signal config_loaded(success: bool)

# Save/Load signals
@warning_ignore("unused_signal")
signal game_saved(slot_id: int, success: bool)

@warning_ignore("unused_signal")
signal game_loaded(slot_id: int, success: bool)

@warning_ignore("unused_signal")
signal save_data_loaded(data: Dictionary)

# Level management signals
@warning_ignore("unused_signal")
signal level_loaded(level_id: String)

@warning_ignore("unused_signal")
signal level_started(level_id: String)

@warning_ignore("unused_signal")
signal level_completed(level_id: String, score: int)

@warning_ignore("unused_signal")
signal level_unlocked(level_id: String)

@warning_ignore("unused_signal")
signal checkpoint_reached(checkpoint_id: String)

@warning_ignore("unused_signal")
signal level_progress_saved(success: bool)
