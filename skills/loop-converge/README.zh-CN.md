# loop-converge

**薄入口 `/loop-converge`：一调用就开代码收敛面试，再编译一次普通的 loop-graph run。**

[English](README.md) · 简体中文

`/loop-converge` 不是第二套运行时。它绑定一份预设包（删无用 / 去重 / 复用 /
合并 / 瘦身；监督节点必开），然后走
[loop-graph](../loop-graph/SKILL.md)，在 `.longgraph/<日期>-converge/` 下生成
执行者、监督者、ledger 与 directives。

## 什么时候用

多轮清理，且「完成」可核验：测试保持绿、检测器下降、净行数不增长、没有新的
公开面。运行会按区轮扫、每轮自己发现候选——它在**检测器重扫不再出货**时才结束，
而不是在预置清单做完时结束。每轮会落地共享证明门的最大安全相关工作集；fire 上限
只会开启下一次 fire，绝不会终止 run。一次能做完的整理不要用它。

## 怎么跑

1. 调用 `/loop-converge`（Claude Code 插件：`longgraph:loop-converge`）。
2. 回答短面试——范围、权限、启动——或直接接受每题的推荐项 A。
3. **A** 在 Codex 或 Claude Code 上创建两个节点。**B** 打印可复制的
   read-and-follow 提示词，可粘贴到 Grok Build 等其他宿主。

作者会话不会执行生成出来的节点。

## 文件

| 路径 | 是什么 |
| --- | --- |
| [`SKILL.md`](SKILL.md) | 入口：适配、绑包、开面试、交接 |
| [`preset.md`](preset.md) | 仅作者读取的绑包——北星、护栏、旋钮、检测器提示 |

运行时模板只在 [`../loop-graph/templates/`](../loop-graph/templates/)。
