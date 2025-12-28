class_name PerformanceMonitor
extends RefCounted

# Performance Monitor
# Monitor FPS and frame time for performance testing

var fps_history: Array[float] = []
var frame_times: Array[float] = []
var max_samples: int = 600  # Store ~10 seconds at 60 FPS
var is_monitoring: bool = false
var _monitor_start_time: float = 0.0


func _init():
	fps_history.clear()
	frame_times.clear()


## Start monitoring performance
## Start collecting FPS and frame time data
func start_monitoring() -> void:
	fps_history.clear()
	frame_times.clear()
	is_monitoring = true
	_monitor_start_time = Time.get_ticks_msec()


## Stop monitoring performance
## Stop collecting performance data
func stop_monitoring() -> void:
	is_monitoring = false


## Record a frame sample
## Record FPS and frame time for current frame
func record_frame(fps: float, frame_time_ms: float) -> void:
	if not is_monitoring:
		return

	fps_history.append(fps)
	frame_times.append(frame_time_ms)

	# Keep only the most recent samples
	if fps_history.size() > max_samples:
		fps_history.pop_front()
		frame_times.pop_front()


## Get average FPS
## Calculate and return the average FPS over all recorded samples
func get_average_fps() -> float:
	if fps_history.is_empty():
		return 0.0

	var total: float = 0.0
	for fps in fps_history:
		total += fps

	return total / fps_history.size()


## Get minimum FPS
## Return the lowest FPS recorded
func get_min_fps() -> float:
	if fps_history.is_empty():
		return 0.0

	var min_fps: float = fps_history[0]
	for fps in fps_history:
		if fps < min_fps:
			min_fps = fps

	return min_fps


## Get maximum frame time in milliseconds
## Return the highest frame time recorded
func get_max_frame_time_ms() -> float:
	if frame_times.is_empty():
		return 0.0

	var max_time: float = frame_times[0]
	for time in frame_times:
		if time > max_time:
			max_time = time

	return max_time


## Check if 60 FPS is stable
## Returns true if average FPS >= 55 and variance is acceptable
func is_stable_60fps() -> bool:
	if fps_history.is_empty():
		return false

	var avg_fps := get_average_fps()
	var min_fps := get_min_fps()

	# Average should be at least 55 FPS
	if avg_fps < 55.0:
		return false

	# Minimum should be at least 45 FPS (allowing occasional frame drops)
	if min_fps < 45.0:
		return false

	# Check that at least 90% of frames are above 50 FPS
	var frames_above_50 = 0
	for fps in fps_history:
		if fps >= 50.0:
			frames_above_50 += 1

	var percentage_above_50 = float(frames_above_50) / float(fps_history.size())
	return percentage_above_50 >= 0.9


## Get monitoring duration in seconds
## Return how long monitoring has been active
func get_duration_seconds() -> float:
	if not is_monitoring:
		return 0.0

	return (Time.get_ticks_msec() - _monitor_start_time) / 1000.0


## Get FPS standard deviation
## Calculate the standard deviation of FPS readings
func get_fps_std_dev() -> float:
	if fps_history.size() < 2:
		return 0.0

	var avg := get_average_fps()
	var variance: float = 0.0

	for fps in fps_history:
		var diff = fps - avg
		variance += diff * diff

	variance /= fps_history.size()
	return sqrt(variance)


## Get performance summary as string
## Return a formatted summary of performance metrics
func get_summary() -> String:
	var summary := ""
	summary += "Performance Summary:\n"
	summary += "  Average FPS: %.2f\n" % get_average_fps()
	summary += "  Min FPS: %.2f\n" % get_min_fps()
	summary += "  Max Frame Time: %.2f ms\n" % get_max_frame_time_ms()
	summary += "  FPS Std Dev: %.2f\n" % get_fps_std_dev()
	summary += "  Stable 60 FPS: %s\n" % ("Yes" if is_stable_60fps() else "No")
	summary += "  Samples: %d\n" % fps_history.size()
	summary += "  Duration: %.2f seconds\n" % get_duration_seconds()

	return summary
