# loop-converge

**薄入口 `/loop-converge`：一调用就开代码收敛面试，再编译一次普通的 loop-graph run。**

[English](README.md) · 简体中文

`/loop-converge` 不是第二套运行时。它绑定一份预设包（删无用 / 去重 / 复用 /
合并 / 瘦身；监督节点必开），然后走
[loop-graph](../loop-graph/SKILL.md)，在 `.longgraph/<日期>-converge/` 下生成
执行者、监督者、ledger 与 directives。

## 什么时候用

多轮清理，且「完成」可核验：测试保持绿、检测器下降、净行数不增长、没有新的
公开面。一次能做完的整理不要用它。

## 怎么跑

1. 调用 `/loop-converge`（Claude Code 插件：`longgraph:loop-converge`）。
2. 回答短面试——范围、权限、启动——或直接接受每题的推荐项 A。
3. **A** 在当前宿主创建两个节点（Codex、Claude Code 或 Grok Build）。
   **B** 打印可复制的 read-and-follow 提示词，去别的宿主粘贴。

作者会话不会执行生成出来的节点。

## 文件

| 路径 | 是什么 |
| --- | --- |
| [`SKILL.md`](SKILL.md) | 入口：适配、绑包、开面试、交接 |
| [`preset.md`](preset.md) | 仅作者读取的绑包——北星、护栏、旋钮、检测器提示 |

运行时模板只在 [`../loop-graph/templates/`](../loop-graph/templates/)。
