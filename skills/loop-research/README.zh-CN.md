# loop-research

**薄入口 `/loop-research`：用可比证据选定技术方案。**

[English](README.md) · 简体中文

`/loop-research` 绑定调研与选型 pack，再走
[loop-graph](../loop-graph/SKILL.md) 编译共享的执行者、监督者、ledger、directives 和
ops 文件；不增加调研运行时、节点或模板集。

## 什么时候用

适合方案尚未选定，且决策需要开源实现、第一手研究和公平 benchmark 或受控 A/B 评估
共同支撑的场景。结论只在已声明的准则下成立；证据不可比或不充分时会明确报告，而不会
杜撰赢家。选定后进入 `/loop-deliver`。

## 怎么跑

1. 调用 `/loop-research`（Claude Code 插件：`longgraph:loop-research`）。
2. 只回答仍无法推断的选择：决策边界、证据/数据/预算权限、启动方式；也可直接接受推荐项。
3. **A** 会在 Codex 或 Claude Code 中创建两个节点；**B** 输出给其他宿主的可复制提示词。

作者会话不会执行生成出来的运行节点。

## 文件

| 路径 | 是什么 |
| --- | --- |
| [`SKILL.md`](SKILL.md) | 适配、绑包和定向面试 |
| [`preset.md`](preset.md) | 证据漏斗、选型护栏、旋钮和产物重点 |

运行时模板只在 [`../loop-graph/templates/`](../loop-graph/templates/)。
