# Player State Enum
# Defines all possible states for the player character
# This file contains only the enum definition for player states
# Usage: preload("res://scripts/player/player_state.gd").PlayerState.IDLE

enum PlayerState {
	IDLE = 0,   # Idle state - player is standing still
	MOVE,       # Move state - player is moving on ground
	JUMP,       # Jump state - player is jumping
	FALL,       # Fall state - player is falling
	ATTACK,     # Attack state - player is attacking
}

# Constants for enum size
const STATE_COUNT: int = 5
