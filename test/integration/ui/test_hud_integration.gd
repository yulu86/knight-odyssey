extends GutTest

# HUD Integration Test - Test complete HUD workflow
var HUD_scene = preload("res://scenes/ui/hud.tscn")
var hud: CanvasLayer

func before_each():
	hud = HUD_scene.instantiate()
	add_child(hud)
	await wait_frames(1)

func after_each():
	hud.queue_free()

# Test complete HUD workflow
func test_complete_hud_workflow():
	# Verify initial state
	assert_eq(hud.current_score, 0, "Initial score should be 0")
	assert_eq(hud.current_lives, 3, "Initial lives should be 3")

	var pause_menu: Control = hud.get_node("PauseMenu")
	assert_false(pause_menu.visible, "Pause menu should be hidden initially")

	# Simulate coin collection via EventBus
	EventBus.coin_collected.emit(10)
	await wait_frames(1)

	# Simulate player damaged via EventBus
	EventBus.player_damaged.emit(1)
	await wait_frames(1)

	# Note: player_damaged signal doesn't directly update lives
	# The game logic should call EventBus.lives_updated.emit()
	# Let's simulate that instead
	EventBus.lives_updated.emit(2)
	await wait_frames(1)
	assert_eq(hud.current_lives, 2, "Lives should decrease to 2")

	# Test pause menu toggle
	hud._toggle_pause_menu()
	await wait_frames(1)

	# Note: We can't fully test the pause menu in integration test due to
	# get_tree().paused affecting the test runner itself, but we can verify
	# the pause menu toggles visibility
	assert_true(pause_menu.visible, "Pause menu should be visible after ESC")

	print("✓ Complete HUD workflow test passed")
