extends GutTest

var HUD_scene = preload("res://scenes/ui/hud.tscn")
var hud: CanvasLayer

func before_each():
	hud = HUD_scene.instantiate()
	add_child(hud)
	await wait_frames(1)

func after_each():
	hud.queue_free()

# Test HUD scene can be instantiated
func test_hud_scene_instantiates():
	assert_not_null(hud, "HUD should instantiate")
	assert_eq(hud.name, "HUD", "HUD root node should be named HUD")

# Test initial score display
func test_initial_score_display():
	var score_label: Label = hud.get_node("MarginContainer/HBoxContainer/ScoreLabel")
	assert_not_null(score_label, "ScoreLabel should exist")
	assert_eq(score_label.text, "SCORE: 0", "Initial score should be 0")

# Test score update
func test_score_update():
	var score_label: Label = hud.get_node("MarginContainer/HBoxContainer/ScoreLabel")
	hud.update_score(100)
	assert_eq(score_label.text, "SCORE: 100", "Score should update to 100")

# Test EventBus signal connection
func test_score_updated_signal_connection():
	var score_label: Label = hud.get_node("MarginContainer/HBoxContainer/ScoreLabel")
	EventBus.score_updated.emit(250)
	await wait_frames(2)
	assert_eq(score_label.text, "SCORE: 250", "Score should update via EventBus signal")

# Test initial lives display
func test_initial_lives_display():
	var heart1: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart1")
	var heart2: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart2")
	var heart3: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart3")

	assert_not_null(heart1, "Heart1 should exist")
	assert_not_null(heart2, "Heart2 should exist")
	assert_not_null(heart3, "Heart3 should exist")

	# All hearts should be visible initially
	assert_true(heart1.visible, "Heart1 should be visible")
	assert_true(heart2.visible, "Heart2 should be visible")
	assert_true(heart3.visible, "Heart3 should be visible")

# Test lives decrease
func test_lives_decrease():
	var heart1: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart1")
	var heart2: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart2")
	var heart3: TextureRect = hud.get_node("MarginContainer/HBoxContainer/LivesContainer/Heart3")

	# Decrease lives to 2
	hud.update_lives(2)

	# Check heart textures (2 full hearts, 1 empty)
	assert_eq(hud.current_lives, 2, "Current lives should be 2")

# Test EventBus lives_updated signal connection
func test_lives_updated_signal_connection():
	EventBus.lives_updated.emit(1)
	await wait_frames(2)
	assert_eq(hud.current_lives, 1, "Lives should update via EventBus signal")

# Test pause menu initial state
func test_pause_menu_initially_hidden():
	var pause_menu: Control = hud.get_node("PauseMenu")
	assert_false(pause_menu.visible, "Pause menu should be hidden initially")

# Test show pause menu
func test_show_pause_menu():
	var pause_menu: Control = hud.get_node("PauseMenu")
	hud.show_pause_menu()
	assert_true(pause_menu.visible, "Pause menu should be visible")
	assert_true(get_tree().paused, "Game tree should be paused")

# Test hide pause menu
func test_hide_pause_menu():
	var pause_menu: Control = hud.get_node("PauseMenu")
	hud.show_pause_menu()
	hud.hide_pause_menu()
	assert_false(pause_menu.visible, "Pause menu should be hidden")
	assert_false(get_tree().paused, "Game tree should not be paused")

# Test Resume button
func test_resume_button():
	var pause_menu: Control = hud.get_node("PauseMenu")
	var resume_button: Button = hud.get_node("PauseMenu/VBoxContainer/ResumeButton")

	hud.show_pause_menu()
	resume_button.pressed.emit()

	await wait_frames(1)
	assert_false(pause_menu.visible, "Pause menu should be hidden after Resume")
	assert_false(get_tree().paused, "Game should resume after Resume button")
