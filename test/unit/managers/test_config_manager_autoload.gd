extends GutTest

func test_config_manager_global_access():
	assert_not_null(ConfigManager, "ConfigManager should be accessible as AutoLoad singleton")

func test_config_manager_is_node():
	assert_true(ConfigManager is Node, "ConfigManager should be a Node")
