extends GutScene

func _ready():
	# 配置GUT测试
	gut.directory = 'res://test/unit/'
	gut.include_subdirectories = true
	gut.log_level = gut.LOG_LEVEL_ALL
	
	# 运行测试
	gut.test_scripts(run_tests)

func run_tests():
	print("开始运行GUT测试...")
	
	# 设置测试结果回调
	gut.end_run.connect(_on_tests_finished)
	
	# 导出测试结果
	gut.export_if_tests_have_errors = true
	gut.export_paths = ['user://test_results.txt']
	
	# 开始测试
	gut.test_scripts()

func _on_tests_finished():
	print("\n=== 测试完成 ===")
	print("通过: ", gut.get_summary().get_passing_test_count())
	print("失败: ", gut.get_summary().get_failing_test_count())
	print("总计: ", gut.get_summary().get_total_test_count())
	
	# 等待2秒后退出
	await get_tree().create_timer(2.0).timeout
	get_tree().quit()