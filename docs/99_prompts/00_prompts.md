# 1. 创建PRD

```
ultrathink 请根据 docs/00_scratch/ 目录下的图片，设计2D平台跳跃游戏`骑士的奥德赛大冒险`，按照GDD模版，输出游戏需求GDD文档到 docs/01_GDD/ 目录下。
要求:
- 游戏平台：支持PC、Mac
- 操作：支持键盘、Xbox手柄操作
游戏资产：
- 游戏资产: assets/
参考：
- GDD模版：docs/99_prompts/templates/GDD.md
```

# 2. 架构设计

```
use context7 请输出游戏架构概要设计:
1. 读取`游戏需求GDD`，理解游戏需求
3. 结合业界最佳实践中的成熟方案和合理的设计模式， 使用 `godot-copilot`技能进行架构设计
3. 委托 tech-docs-writer 输出详架构概要设计文档到 docs/02_arch/
约束：
- 概要设计文档输出架构设计需要按照`架构设计模版`输出
- 禁止输出详细实现代码 
参考文档:
- 游戏需求GDD: docs/01_PRD/01_游戏设计文档_骑士的奥德赛大冒险.md
- 架构设计模版: docs/99_prompts/templates/ARCH.md
```
