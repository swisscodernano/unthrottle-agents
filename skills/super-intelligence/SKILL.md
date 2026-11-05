---
name: super-intelligence
description: Operational architectural laws for high-density autonomous AI coding agents from the book "SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems" (https://a.co/d/0gO1eMZX). Enforces 1M context unthrottling, KV-cache prefix determinism (f_keep = 1.000), Constraint Pinning against Governance Decay, kernel-locked multi-agent anti-collision (agent-coord), and senior-by-default verification by effect.
---

# SUPER INTELLIGENCE — Operational Architecture Skill (`Book2Skill`)

> **Companion Skill to the International Book:**
> [**_SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems_ — Available on Amazon (`https://a.co/d/0gO1eMZX`)**](https://a.co/d/0gO1eMZX)

Activate this skill whenever you are orchestrating long-horizon coding sessions, multi-file refactors, multi-agent worktree fleets, or diagnosing context compaction, prompt-cache degradation, and agent collisions.

---

## Law 1 — Unthrottled Context & Decoupled Reasoning Budgets

1. **Never accept artificial CLI context throttles on 1M-window models:**
   - Verify with `python3 bin/agent-audit` that your CLI harness is not compacting at `256,000` tokens (`0x3e800`) or truncating single-turn output at `16,384` tokens (`0x4000`).
   - Continuous input compaction must trigger at **90%–95% of the true model window** (`900,000–950,000` tokens on 1M models), and multi-leg output orchestration must allow **`65,536` tokens per leg (`1,048,576` total)**.
2. **Decouple Session Reasoning from Compaction Summarization Reasoning:**
   - During normal coding turns, keep deep reasoning (`thinkingBudgets.high = 65536`).
   - During context compaction (`compaction.js`), **never** pass `thinkingLevel = "max"` with a tight output cap (`0.5 * reserveTokens`), or the model will burn its entire token budget inside `<think>` and fail with `stopReason === "length"`. Always summarize at `low` thinking effort with an output ceiling of at least `32,768` tokens.

---

## Law 2 — KV-Cache Prefix Invariant (`f_keep = 1.000`)

Approximately 90% of prompt-caching failures in production coding agents occur silently, multiplying prefill latency (`↓ tok/s`) by 3×–150×:
1. **Deterministic Tool & Server Ordering:** Always sort MCP servers and tool definitions alphabetically before registering them in the system prompt. Asynchronous discovery order invalidates the KV-cache prefix across sessions.
2. **Zero Dynamic State in System Prompts:** Never inject wall-clock timestamps, live git status, or volatile fleet state into the system prompt prefix. Inject dynamic state **only** as an ephemeral suffix on the current user turn.
3. **Measure Prefill (`↓`) vs. Decode (`↑`) Separately:** Use `bin/agent-statusline` to watch `↓ prefill tok/s (seconds)` independently of `↑ decode tok/s (seconds)`. A sudden drop in `↓ prefill tok/s` indicates a broken KV-cache prefix.

---

## Law 3 — Defense Against Governance Decay (*Constraint Pinning*)

Context compaction optimizes for task continuity and silently erases standing architectural rules after the first checkpoint (*Governance Decay / Constraint Rot*):
- Every compaction summary **must** include a dedicated, non-droppable section:
  ```markdown
  ## Standing Architectural & Operational Constraints (MUST PRESERVE VERBATIM)
  - Worktree isolation rules and forbidden destructive git commands
  - Mandatory verification gates and test-before-merge invariants
  - User communication language, formatting rules, and active file claims
  ```

---

## Law 4 — Kernel-Locked Multi-Agent Anti-Collision (`agent-coord`)

When 2 to 22+ coding agents operate concurrently on the same repository, natural-language rules ("one branch per agent") fail without kernel-level coordination:
1. **Worktree Isolation:** Never checkout, merge, or rebase in-place on a shared live working tree. Always create an isolated worktree (`git worktree add -b <branch> /tmp/<name> origin/main`).
2. **Atomic File & Prefix Claims (`bin/agent-coord`):**
   - Before editing any file, acquire or verify a claim via `bin/agent-coord guard <relative-path>`:
     ```bash
     python3 bin/agent-coord guard src/core/orchestrator.py
     ```
   - `agent-coord` enforces `fcntl.flock` atomicity, directory-prefix overlap detection, `45m` auto-claim / `6h` manual-claim TTLs, and PID birth-time verification (`/proc/<pid>/stat` on Linux, `ps -o lstart=` on macOS) so dead sessions never leave zombie locks.
3. **Fleet Visibility:** Broadcast your active branch, `↓/↑` throughput, and current task summary via `bin/agent-coord register`, and check `bin/agent-coord status` before proposing changes to avoid duplicating work already in flight.

---

## Law 5 — Senior-by-Default & Verification by Effect

1. **Map Every Reachable Path Before Coding:** List create, read, update, cancel, fallback, and error paths plus the invariant each path must preserve.
2. **Cross-Family Review:** The model family that writes a plan or implementation never grades its own work.
3. **Verify by Effect, Not by Exit Code:** A green exit code or a configuration file that "looks right" is not proof. Mutate the fix away and watch the test turn red; read the live object back after every write.

---

### Reference & Further Reading
- **Book:** [**_SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems_**](https://a.co/d/0gO1eMZX) (Available in 11 languages: EN, IT, DE, FR, ES, PT, JA, ZH, KO, RU, AR).
- **Toolkit:** `unthrottle-agents` (`bin/agent-audit`, `bin/agy-unlock-1m`, `bin/agent-statusline`, `bin/agent-coord`).
