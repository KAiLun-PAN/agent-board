# 历史记录 HISTORY

> 每完成一个任务，在**最上面**简短追加一条：改了什么、为什么、产物在哪。
> 只写摘要和「详见」指针，不粘贴过程日志。其他 Agent 需要上下文时，按指针去找。

---

## T-001 发布 Agent Board v1 — 2026-11-23

- **一句话**：把作者在多个项目里使用的「任务看板 + 历史记录」协同规则整理成可一键安装的开源仓库。
- **改动**：新增 `install.sh`（幂等、可卸载、支持 zh/en 与自定义文件名）、`templates/{zh,en}/`、`examples/`、`docs/PROMPTS.md`。
- **原因**：让 Codex / Claude Code / Gemini / Cursor 等不同 Agent 在同一项目里互不覆盖、通过文件互通上下文。
- **产物 / 证据**：本仓库即在使用这套协议（见本文件与 `BOARD.md`）。
- **负责人**：A-antigravity

## T-000 初始化 Agent Board — 2026-11-23

- **一句话**：引入「任务看板 + 历史记录」多 Agent 协同协议。
- **改动**：新增 `BOARD.md`、`HISTORY.md`，并在 Agent 规则文件中写入协同协议。
- **产物**：`BOARD.md`、`HISTORY.md`
- **负责人**：A-installer

---

## 记录模板（复制使用）

```markdown
## T-xxx 标题 — YYYY-MM-DD HH:mm

- **一句话**：
- **改动**：
  -
- **原因**：
- **产物 / 证据**：
- **详见**：（PR、提交、文档、日志路径；没有可省略）
- **负责人**：A-xxx
```
