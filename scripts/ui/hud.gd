# HUD - Heads Up Display for game interface
# Manages score display, lives display, and pause menu
extends CanvasLayer

# Node references
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var lives_container: HBoxContainer = $MarginContainer/HBoxContainer/LivesContainer
@onready var pause_menu: Control = $PauseMenu
@onready var resume_button: Button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button: Button = $PauseMenu/VBoxContainer/QuitButton

# Internal state
var current_score: int = 0
var current_lives: int = 3
const MAX_LIVES: int = 5
var heart_nodes: Array[TextureRect] = []

# Heart texture resources
const HEART_FULL_TEXTURE = preload("res://assets/sprites/ui/heart_ui_full.png")
const HEART_EMPTY_TEXTURE = preload("res://assets/sprites/ui/heart_ui_empty.png")

# Animation configuration
const SCORE_ANIMATION_DURATION: float = 0.3
const DAMAGE_FLASH_COLOR: Color = Color(1, 0, 0, 1)
const DAMAGE_FLASH_DURATION: float = 0.5

# Tween for animations
var score_tween: Tween
var damage_tween: Tween

func _ready() -> void:
	# Connect EventBus signals
	EventBus.score_updated.connect(_on_score_updated)
	EventBus.lives_updated.connect(_on_lives_updated)

	# Connect button signals
	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	# Initialize heart nodes array
	_heart_nodes_init()

	# Initialize UI display
	update_score(0)
	update_lives(3)

	# Hide pause menu initially
	pause_menu.hide()

# Initialize heart nodes array from LivesContainer children
func _heart_nodes_init() -> void:
	heart_nodes.clear()
	for child in lives_container.get_children():
		if child is TextureRect:
			heart_nodes.append(child)
			# Set initial texture to full heart
			child.texture = HEART_FULL_TEXTURE

# Update score display with animation
func update_score(score: int) -> void:
	current_score = score
	score_label.text = "SCORE: %d" % current_score

	# Play scale animation
	if score_tween and score_tween.is_valid():
		score_tween.kill()
	score_tween = create_tween()
	score_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	score_tween.set_parallel(false)
	score_tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), SCORE_ANIMATION_DURATION * 0.5)
	score_tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), SCORE_ANIMATION_DURATION * 0.5)

# Update lives display with heart icons and damage flash
func update_lives(lives: int) -> void:
	var old_lives: int = current_lives
	current_lives = clamp(lives, 0, MAX_LIVES)

	for i in range(heart_nodes.size()):
		var heart: TextureRect = heart_nodes[i]
		if i < current_lives:
			heart.texture = HEART_FULL_TEXTURE
		else:
			heart.texture = HEART_EMPTY_TEXTURE

	# Flash red if lives decreased
	if current_lives < old_lives:
		_flash_hearts_red()

# Flash hearts red when damaged
func _flash_hearts_red() -> void:
	if damage_tween and damage_tween.is_valid():
		damage_tween.kill()

	damage_tween = create_tween()
	damage_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	for heart in heart_nodes:
		if heart.texture == HEART_FULL_TEXTURE:
			damage_tween.parallel().tween_property(heart, "modulate", DAMAGE_FLASH_COLOR, DAMAGE_FLASH_DURATION * 0.5)
			damage_tween.parallel().tween_property(heart, "modulate", Color.WHITE, DAMAGE_FLASH_DURATION * 0.5)

# Show pause menu
func show_pause_menu() -> void:
	pause_menu.show()
	get_tree().paused = true

# Hide pause menu
func hide_pause_menu() -> void:
	pause_menu.hide()
	get_tree().paused = false

# Toggle pause menu state
func _toggle_pause_menu() -> void:
	pause_menu.visible = not pause_menu.visible
	get_tree().paused = pause_menu.visible

# Handle input events
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause_menu()

# EventBus: score updated signal callback
func _on_score_updated(new_score: int) -> void:
	update_score(new_score)

# EventBus: lives updated signal callback
func _on_lives_updated(new_lives: int) -> void:
	update_lives(new_lives)

# Resume button pressed callback
func _on_resume_button_pressed() -> void:
	hide_pause_menu()

# Quit button pressed callback
func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
