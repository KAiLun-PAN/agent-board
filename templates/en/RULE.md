<!-- AGENT_BOARD_RULE_v1 · https://github.com/KAiLun-PAN/agent-board -->
## Multi-Agent Collaboration Protocol (Agent Board)

Several agents (Codex / Claude Code / Gemini / Cursor / humans) may work on this project at the same time.
Coordination happens through two files in the project root: **`BOARD.md` (task board)** and **`HISTORY.md` (history log)**.

**Every task MUST follow these rules:**

1. **Board first, then act**: before any task that edits files, read `BOARD.md`, then skim the latest entries in `HISTORY.md` as needed.
2. **Claim the task + lock the files**: add a row under "🔵 In Progress" (task ID, description, your agent ID, time) and list every file/dir you will modify under "🔒 File Locks".
3. **Locks are exclusive**: if a target file is locked by someone else, do not edit it — pick another task, wait, or coordinate in the notes. Reading needs no lock.
4. **Smallest lock, prefer new files**: lock only what you really change; create new files instead of editing shared ones when possible.
5. **Release on completion**: remove your locks → move the row to "✅ Recently Done" → prepend an entry to the **top** of `HISTORY.md`.
6. **History = summary + pointers**: what changed, why, where the output/evidence is, where the details live. No raw logs.
7. **Flag blockers**: if you cannot continue, set status to `⛔Blocked` and say what you are waiting for. **Never sit silently on a lock.**
8. **Need context?** Search `HISTORY.md` for related entries and follow their pointers instead of re-exploring the whole repo.

- Task ID: `T-<n>`, increasing, never reused. Agent ID: `A-<tool>-<name>`, e.g. `A-codex-api`, `A-claude-ui`.
- Status: `📋Todo` / `🔵In Progress` / `⛔Blocked` / `✅Done` / `❌Cancelled`.
- Commit message (if using git): `[T-012] one-line summary`.
<!-- /AGENT_BOARD_RULE_v1 -->
