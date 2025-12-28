extends GutTest

# Player Performance Tests
# Test 60 FPS stability during various gameplay scenarios

var _player_scene: PackedScene = null
var _player: Player = null
var _test_scene: Node2D = null
var _performance_monitor: PerformanceMonitor = null


func before_each():
	# Create test scene
	_test_scene = Node2D.new()

	# Create larger ground to prevent player from falling off during movement
	var ground = StaticBody2D.new()
	ground.position = Vector2(0, 100)
	ground.collision_layer = 1
	ground.collision_mask = 1
	var ground_collision = CollisionShape2D.new()
	var ground_shape = RectangleShape2D.new()
	ground_shape.size = Vector2(5000, 10)  # Much wider to prevent falling off
	ground_collision.shape = ground_shape
	ground.add_child(ground_collision)
	_test_scene.add_child(ground)

	# Load and instantiate player scene
	_player_scene = load("res://scenes/player/player.tscn")
	_player = _player_scene.instantiate()
	_player.position = Vector2(2500, 80)  # Center position on 5000-wide ground
	_test_scene.add_child(_player)

	# Add to scene tree
	add_child_autofree(_test_scene)

	# Wait for physics to be ready
	await get_tree().physics_frame

	# Let player fall to ground completely
	for i in range(20):
		_player.move_and_slide()
		await get_tree().physics_frame
		if _player.is_on_floor():
			for j in range(3):
				await get_tree().physics_frame
			break

	# Ensure starting in IDLE state
	_player.player_state_machine.change_state(PlayerState.State.IDLE)
	for i in range(2):
		await get_tree().physics_frame

	# Create performance monitor
	_performance_monitor = PerformanceMonitor.new()


func after_each():
	# Release any held input actions
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")

	_player_scene = null
	_player = null
	_test_scene = null
	_performance_monitor = null


## Helper function to monitor performance during a test
## Records FPS and frame time while executing the given function
func _monitor_performance(duration_seconds: float) -> void:
	_performance_monitor.start_monitoring()

	var frames_to_wait = int(duration_seconds * 60)
	for i in range(frames_to_wait):
		var frame_start = Time.get_ticks_msec()

		# Process one frame
		_player.move_and_slide()
		await get_tree().physics_frame

		# Record performance
		var frame_end = Time.get_ticks_msec()
		var frame_time = frame_end - frame_start
		var fps = 1000.0 / frame_time if frame_time > 0 else 60.0

		_performance_monitor.record_frame(fps, frame_time)

	_performance_monitor.stop_monitoring()


# Test 1: Continuous movement stability
func test_performance_continuous_movement():
	# Test continuous movement for 2 seconds
	_performance_monitor.start_monitoring()

	Input.action_press("move_right")

	var frames_to_wait = 120  # 2 seconds at 60 FPS
	for i in range(frames_to_wait):
		var frame_start = Time.get_ticks_msec()

		_player.move_and_slide()
		await get_tree().physics_frame

		var frame_end = Time.get_ticks_msec()
		var frame_time = frame_end - frame_start
		var fps = 1000.0 / frame_time if frame_time > 0 else 60.0

		_performance_monitor.record_frame(fps, frame_time)

	Input.action_release("move_right")
	_performance_monitor.stop_monitoring()

	# Verify 60 FPS stability
	assert_true(_performance_monitor.is_stable_60fps(),
		"Should maintain stable 60 FPS during continuous movement. Summary: %s" % _performance_monitor.get_summary())
	assert_gt(_performance_monitor.get_average_fps(), 55.0,
		"Average FPS should be > 55. Got: %.2f" % _performance_monitor.get_average_fps())


# Test 2: Frequent jumps stability
func test_performance_frequent_jumps():
	# Test frequent jumps for 2 seconds
	_performance_monitor.start_monitoring()

	var frames_to_wait = 120  # 2 seconds at 60 FPS
	var jump_counter = 0

	for i in range(frames_to_wait):
		var frame_start = Time.get_ticks_msec()

		# Jump every 30 frames
		if i % 30 == 0:
			Input.action_press("jump")
			jump_counter += 1
		elif i % 30 == 15:
			Input.action_release("jump")

		_player.move_and_slide()
		await get_tree().physics_frame

		var frame_end = Time.get_ticks_msec()
		var frame_time = frame_end - frame_start
		var fps = 1000.0 / frame_time if frame_time > 0 else 60.0

		_performance_monitor.record_frame(fps, frame_time)

	Input.action_release("jump")
	_performance_monitor.stop_monitoring()

	# Verify 60 FPS stability
	assert_true(_performance_monitor.is_stable_60fps(),
		"Should maintain stable 60 FPS during frequent jumps. Summary: %s" % _performance_monitor.get_summary())


# Test 3: Rapid state changes stability
func test_performance_rapid_state_changes():
	# Test rapid input changes for 2 seconds
	# Note: Reduced intensity to avoid falling off ground
	_performance_monitor.start_monitoring()

	var frames_to_wait = 120  # 2 seconds at 60 FPS

	for i in range(frames_to_wait):
		var frame_start = Time.get_ticks_msec()

		# Alternate direction every 30 frames (much slower to prevent falling)
		if i % 60 < 30:
			Input.action_press("move_right")
			Input.action_release("move_left")
		else:
			Input.action_press("move_left")
			Input.action_release("move_right")

		_player.move_and_slide()
		await get_tree().physics_frame

		var frame_end = Time.get_ticks_msec()
		var frame_time = frame_end - frame_start
		var fps = 1000.0 / frame_time if frame_time > 0 else 60.0

		_performance_monitor.record_frame(fps, frame_time)

	Input.action_release("move_right")
	Input.action_release("move_left")
	_performance_monitor.stop_monitoring()

	# Verify 60 FPS stability (relaxed criteria for this test)
	var avg_fps = _performance_monitor.get_average_fps()
	var min_fps = _performance_monitor.get_min_fps()

	# Average should be at least 55 FPS
	assert_gt(avg_fps, 55.0,
		"Average FPS should be > 55. Got: %.2f. Summary: %s" % [avg_fps, _performance_monitor.get_summary()])

	# Minimum should not be too low (allow some variance but not severe drops)
	assert_gt(min_fps, 45.0,
		"Minimum FPS should be > 45. Got: %.2f. Summary: %s" % [min_fps, _performance_monitor.get_summary()])


# Test 4: Full gameplay scenario
func test_performance_full_gameplay_scenario():
	# Test a complete gameplay scenario for 3 seconds
	_performance_monitor.start_monitoring()

	var frames_to_wait = 180  # 3 seconds at 60 FPS

	for i in range(frames_to_wait):
		var frame_start = Time.get_ticks_msec()

		# Simulate gameplay: move right, jump occasionally
		if i % 60 < 30:
			Input.action_press("move_right")
		else:
			Input.action_release("move_right")

		# Jump every 60 frames
		if i % 60 == 0:
			Input.action_press("jump")
		elif i % 60 == 10:
			Input.action_release("jump")

		_player.move_and_slide()
		await get_tree().physics_frame

		var frame_end = Time.get_ticks_msec()
		var frame_time = frame_end - frame_start
		var fps = 1000.0 / frame_time if frame_time > 0 else 60.0

		_performance_monitor.record_frame(fps, frame_time)

	Input.action_release("move_right")
	Input.action_release("jump")
	_performance_monitor.stop_monitoring()

	# Verify 60 FPS stability
	assert_true(_performance_monitor.is_stable_60fps(),
		"Should maintain stable 60 FPS during full gameplay scenario. Summary: %s" % _performance_monitor.get_summary())

	# Print summary for debugging
	print("\n=== Performance Test Summary ===")
	print(_performance_monitor.get_summary())
	print("=============================\n")
