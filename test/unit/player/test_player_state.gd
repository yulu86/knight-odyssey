extends GutTest

# PlayerState Enum Test
# Test player state enum declaration and usage

# Preload the player state enum file
const PlayerStateFile = preload("res://scripts/player/player_state.gd")


func test_player_state_enum_exists():
	# Test that PlayerState enum exists with expected states
	assert_not_null(PlayerStateFile, "PlayerState file should exist")
	# Try accessing the enum to verify it exists
	var test_value = PlayerStateFile.PlayerState.IDLE
	assert_not_null(test_value, "PlayerState enum should be accessible")


func test_player_state_has_idle_state():
	# Test that IDLE state exists
	var idle_value = PlayerStateFile.PlayerState.IDLE
	assert_not_null(idle_value, "IDLE state should exist")


func test_player_state_has_move_state():
	# Test that MOVE state exists
	var move_value = PlayerStateFile.PlayerState.MOVE
	assert_not_null(move_value, "MOVE state should exist")


func test_player_state_has_jump_state():
	# Test that JUMP state exists
	var jump_value = PlayerStateFile.PlayerState.JUMP
	assert_not_null(jump_value, "JUMP state should exist")


func test_player_state_has_fall_state():
	# Test that FALL state exists
	var fall_value = PlayerStateFile.PlayerState.FALL
	assert_not_null(fall_value, "FALL state should exist")


func test_player_state_has_attack_state():
	# Test that ATTACK state exists
	var attack_value = PlayerStateFile.PlayerState.ATTACK
	assert_not_null(attack_value, "ATTACK state should exist")


func test_player_state_enum_values_are_unique():
	# Test that all enum values are unique
	var states = [PlayerStateFile.PlayerState.IDLE, PlayerStateFile.PlayerState.MOVE, PlayerStateFile.PlayerState.JUMP, PlayerStateFile.PlayerState.FALL, PlayerStateFile.PlayerState.ATTACK]
	var unique_states = []
	for state in states:
		if not state in unique_states:
			unique_states.append(state)
	assert_eq(states.size(), unique_states.size(), "All enum values should be unique")


func test_player_state_default_value():
	# Test that the first state (IDLE) has value 0
	assert_eq(PlayerStateFile.PlayerState.IDLE, 0, "IDLE should be the default state with value 0")


func test_player_state_enum_in_string():
	# Test that enum values can be converted to string for debugging
	var state = PlayerStateFile.PlayerState.JUMP
	var state_string = str(state)
	assert_true(state_string.length() > 0, "Enum should be convertible to string")


func test_player_state_enum_comparison():
	# Test that enum values can be compared
	var state1 = PlayerStateFile.PlayerState.IDLE
	var state2 = PlayerStateFile.PlayerState.IDLE
	var state3 = PlayerStateFile.PlayerState.MOVE
	assert_eq(state1, state2, "Same enum values should be equal")
	assert_true(state1 != state3, "Different enum values should not be equal")


func test_player_state_has_state_count_constant():
	# Test that STATE_COUNT constant exists
	assert_eq(PlayerStateFile.STATE_COUNT, 5, "STATE_COUNT should be 5")
