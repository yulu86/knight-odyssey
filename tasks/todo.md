# 任务计划：删除未使用的 state_machine 变量

## 任务描述
删除 `player_state_base.gd` 中未使用的 `state_machine` 变量，并确保所有测试用例通过。

## 分析结果
- `state_machine` 变量在 `PlayerStateBase` 中定义
- 在 `PlayerStateMachine.change_state()` 中被设置
- 但在所有状态类（states目录）中都没有被实际使用
- 确认可以安全删除

## 待办事项

- [x] 1. 从 `player_state_base.gd` 中删除 `state_machine` 变量定义（第15-16行）
- [x] 2. 从 `player_state_machine.gd` 中删除 `state_machine` 赋值语句（第40行）
- [x] 3. 运行所有测试用例，确保没有破坏任何功能
- [x] 4. 审查变更，确保代码一致性

## 审查部分

### 变更文件列表

1. **scripts/player/player_state_base.gd**
   - 删除了 `state_machine` 变量定义（第15-16行）

2. **scripts/player/player_state_machine.gd**
   - 删除了 `current_state.state_machine = self` 赋值语句（第40行）

3. **test/unit/player/test_player_state_base.gd**
   - 删除了 `test_player_state_base_has_state_machine_property` 测试
   - 删除了 `test_player_state_base_state_machine_initially_null` 测试

4. **test/unit/player/test_player_state_machine.gd**
   - 删除了 `test_player_state_machine_sets_state_machine_on_state` 测试

### 测试结果

- **测试脚本**: 8
- **测试用例**: 73
- **通过**: 73
- **断言**: 107
- **耗时**: 1.352s
- **状态**: ✅ 全部通过

### 结论

成功删除未使用的 `state_machine` 变量，简化了代码结构。由于该变量从未在状态类中被使用，删除后不会影响任何功能。所有测试用例通过，确保了变更的安全性。
