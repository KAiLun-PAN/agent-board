# 常用提示词 Prompts

适用于不读规则文件的 Agent（网页版 ChatGPT、临时会话等），或想显式提醒时使用。

## 开工

```text
开工前先读项目根目录的 BOARD.md 和 HISTORY.md 最近 5 条。
在 BOARD.md「进行中」登记本任务（新任务 ID、你的 Agent 标识、时间），并在「文件锁」登记你要修改的文件。
如果目标文件已被别人锁定，不要修改，先告诉我。
```

## 收工

```text
任务完成：释放你在 BOARD.md 里的文件锁，把任务行移到「最近完成」，
并在 HISTORY.md 最上面追加一条：一句话摘要、改动、原因、产物/证据路径、详见指针。只写摘要，不贴日志。
```

## 接手 / 找上下文

```text
在 HISTORY.md 里找和「<关键词>」相关的记录，顺着「详见」指针读相关文件，
总结当前状态和遗留问题后再继续，不要重新全量探索仓库。
```

## 卡住

```text
如果无法继续，把 BOARD.md 里你的任务状态改为 ⛔阻塞，备注写清楚在等什么，然后停下来告诉我。
```

---

## English

```text
Before starting: read BOARD.md and the latest 5 entries of HISTORY.md. Claim this task under "In Progress"
(new task ID, your agent ID, time) and lock the files you will edit under "File Locks".
If a target file is locked by someone else, do not edit it — tell me first.
```

```text
When done: release your locks in BOARD.md, move the task row to "Recently Done", and prepend an entry to HISTORY.md:
summary, changes, why, output/evidence paths, see-also pointers. Summaries only, no raw logs.
```
