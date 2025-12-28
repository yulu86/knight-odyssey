extends GutTest

func test_game_manager_is_autoload_singleton() -> void:
	# Arrange & Act
	var game_manager = GameManager

	# Assert
	assert_not_null(game_manager, "GameManager should be accessible as a singleton")


func test_game_manager_auto_initialized() -> void:
	# Arrange & Act
	var game_manager = GameManager

	# Assert
	assert_true(
		game_manager.is_game_manager_initialized(),
		"GameManager should be initialized on game startup"
	)


func test_game_manager_singleton_unique() -> void:
	# Arrange & Act
	var first_ref = GameManager
	var second_ref = GameManager

	# Assert
	assert_same(
		first_ref,
		second_ref,
		"All references to GameManager should point to the same instance"
	)
