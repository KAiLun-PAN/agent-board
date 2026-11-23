# Task Board BOARD

> The **single dispatch point** for multi-agent work. Every agent MUST read this board and register here before editing files.
> Completed work is logged in [HISTORY.md](HISTORY.md). Full protocol: the Agent Board section in `AGENTS.md` / `CLAUDE.md`.

## Protocol (cheat sheet)

1. **Register before acting**: claim the task under "In Progress", list files to edit under "File Locks".
2. **Exclusive locks**: one agent per file at a time; reading needs no lock.
3. **Smallest lock, prefer new files**: never lock the whole repo.
4. **Release on completion**: release locks → move to "Recently Done" → prepend an entry to `HISTORY.md`.
5. **Flag blockers**: set `⛔Blocked` and state what you are waiting for.

- Task ID: `T-<n>` (never reused) · Agent: `A-<tool>-<name>` · Status: `📋Todo` `🔵In Progress` `⛔Blocked` `✅Done` `❌Cancelled`

---

## 🔵 In Progress

| Task ID | Task | Owner | Status | Claimed at | Planned output | Notes |
|---|---|---|---|---|---|---|
| _(none)_ | | | | | | |

## 🔒 File Locks

| File / Dir | Holder | Locked at | Task |
|---|---|---|---|
| _(none)_ | | | |

## 📋 Backlog

| Task ID | Task | Files (estimate) | Source | Notes |
|---|---|---|---|---|
| _(none)_ | | | | |

## ✅ Recently Done (last 10, older ones in HISTORY.md)

| Task ID | Task | Done by | Done at | Output / conclusion |
|---|---|---|---|---|
| T-000 | Initialize Agent Board task board and history log | A-installer | {{DATE}} | `BOARD.md`, `HISTORY.md` |

## ❌ Cancelled

| Task ID | Task | Reason |
|---|---|---|
| _(none)_ | | |
