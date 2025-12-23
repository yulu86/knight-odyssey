extends GutTest

# Player Scene Structure Test
# 测试 Player 场景结构是否正确

const PLAYER_SCENE_PATH = "res://scenes/player/player.tscn"

var _player_scene: PackedScene = null
var _player_instance: CharacterBody2D = null


func before_each():
	# Load the player scene
	_player_scene = load(PLAYER_SCENE_PATH)
	if _player_scene != null:
		_player_instance = _player_scene.instantiate()
		add_child_autoqfree(_player_instance)


func after_each():
	# Cleanup is handled by autoqfree
	_player_scene = null
	_player_instance = null


func test_player_scene_file_exists():
	# 测试 Player 场景文件是否存在
	assert_not_null(_player_scene, "Player scene file should exist at: " + PLAYER_SCENE_PATH)


func test_player_scene_root_type():
	# 测试 Player 场景根节点是否为 CharacterBody2D
	if _player_scene != null:
		assert_is(_player_instance, CharacterBody2D, "Player scene root should be CharacterBody2D")


func test_player_has_collision_shape():
	# 测试 Player 是否有 CollisionShape2D 子节点
	if _player_instance != null:
		var collision_shape = _player_instance.find_child("CollisionShape2D", true, false)
		assert_not_null(collision_shape, "Player should have CollisionShape2D child")

		if collision_shape != null:
			assert_is(collision_shape, CollisionShape2D, "CollisionShape2D should be CollisionShape2D type")


func test_player_collision_has_shape():
	# 测试 CollisionShape2D 是否有有效的 shape
	if _player_instance != null:
		var collision_shape = _player_instance.find_child("CollisionShape2D", true, false)

		if collision_shape != null:
			assert_not_null(collision_shape.shape, "CollisionShape2D should have a shape assigned")

			if collision_shape.shape != null:
				assert_is(collision_shape.shape, CapsuleShape2D, "Shape should be CapsuleShape2D")


func test_player_has_sprite():
	# 测试 Player 是否有 Sprite2D 子节点
	if _player_instance != null:
		var sprite = _player_instance.find_child("Sprite2D", true, false)
		assert_not_null(sprite, "Player should have Sprite2D child")

		if sprite != null:
			assert_is(sprite, Sprite2D, "Sprite2D should be Sprite2D type")


func test_player_has_animation_player():
	# 测试 Player 是否有 AnimationPlayer 子节点
	if _player_instance != null:
		var anim_player = _player_instance.find_child("AnimationPlayer", true, false)
		assert_not_null(anim_player, "Player should have AnimationPlayer child")

		if anim_player != null:
			assert_is(anim_player, AnimationPlayer, "AnimationPlayer should be AnimationPlayer type")


func test_player_scene_can_be_instantiated():
	# 测试场景可以正常实例化
	assert_not_null(_player_instance, "Player scene should be instantiated without errors")


func test_player_scene_structure_complete():
	# 综合测试：验证所有必需节点都存在
	if _player_instance == null:
		assert_true(false, "Player instance is null")
		return

	var has_collision = false
	var has_sprite = false
	var has_anim_player = false

	for child in _player_instance.get_children():
		if child is CollisionShape2D:
			has_collision = true
		elif child is Sprite2D:
			has_sprite = true
		elif child is AnimationPlayer:
			has_anim_player = true

	assert_true(has_collision, "Player should have CollisionShape2D")
	assert_true(has_sprite, "Player should have Sprite2D")
	assert_true(has_anim_player, "Player should have AnimationPlayer")
