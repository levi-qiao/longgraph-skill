# loop-deliver

**薄入口 `/loop-deliver`：把多轮需求交付跑成有验收证据的纵向切片。**

[English](README.md) · 简体中文

`/loop-deliver` 绑定需求交付 pack，再走
[loop-graph](../loop-graph/SKILL.md) 编译共享的执行者、监督者、ledger、directives 和
ops 文件；不增加运行节点，也不复制模板。

## 什么时候用

适合需要多轮推进的功能、集成、迁移或行为变更。每个切片把一条需求行为绑定到真实
消费者路径和验收检查。代码清理用 `/loop-converge`；方案尚未选定时用
`/loop-research`。

## 怎么跑

1. 调用 `/loop-deliver`（Claude Code 插件：`longgraph:loop-deliver`）。
2. 只回答仍无法推断的选择：结果/验收、权限、启动方式；也可直接接受推荐项。
3. **A** 会在 Codex 或 Claude Code 中创建两个节点；**B** 输出给其他宿主的可复制提示词。

作者会话不会执行生成出来的运行节点。

## 文件

| 路径 | 是什么 |
| --- | --- |
| [`SKILL.md`](SKILL.md) | 适配、绑包和定向面试 |
| [`preset.md`](preset.md) | 北星、纵向切片规则、旋钮和产物重点 |

运行时模板只在 [`../loop-graph/templates/`](../loop-graph/templates/)。
