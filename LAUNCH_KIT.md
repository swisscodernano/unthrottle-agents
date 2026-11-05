# 🚀 Kit di Lancio Virale (`unthrottle-agents` + Libro *SUPER INTELLIGENCE* / *SUPER INTELLIGENZA*)

> 📖 **Link Ufficiale Amazon — Edizione Inglese (*SUPER INTELLIGENCE*):** [**`https://a.co/d/0gO1eMZX`**](https://a.co/d/0gO1eMZX)
> 📖 **Link Ufficiale Amazon — Edizione Italiana (*SUPER INTELLIGENZA*):** [**`https://a.co/d/0fA8p5u6`**](https://a.co/d/0fA8p5u6)
> 💻 **Repository GitHub Open-Source:** [**`https://github.com/swisscodernano/unthrottle-agents`**](https://github.com/swisscodernano/unthrottle-agents)

Tutti i testi qui sotto sono pronti da copiare e incollare, calibrati al millimetro per **Hacker News (`Show HN`)**, **Reddit (`r/LocalLLaMA`, `r/ClaudeAI`, `r/singularity`)**, **X / Twitter**, **LinkedIn** e **Video Shorts da 90 secondi**. L'orario migliore per pubblicare su **Hacker News** e **Reddit** è tra le **14:30 e le 16:00 CET** (8:30–10:00 EST, quando si sveglia la costa Est americana ed è già online tutta l'Europa).

---

## 1. Hacker News (`Show HN`)

**Title (max 80 chars):**
`Show HN: Unthrottle-Agents – Your 1M-context coding agents are capped at 256k/16k`

**URL:**
`https://github.com/swisscodernano/unthrottle-agents`

**First Comment (da postare subito dopo l'invio):**
> Hi HN,
>
> While running a 22-agent coding fleet across Google Antigravity (Gemini 4 Argon), OpenAI Codex CLI, Claude Code, Pi, and local `llama.cpp`, I kept hitting three systemic walls during long multi-file refactors:
>
> 1. **Silent 256k/16k CLI Throttles:** Even on models with a 1,048,576-token context window and 1M max output, single-turn generation always cut off or chained at ~16k tokens, and context compaction fired when the session was only ~25% full (around 256k tokens).
> 2. **Post-Compaction Amnesia (*Governance Decay*):** After the first checkpoint summary, agents frequently forgot standing repository rules (what Shiyang Chen's June 2026 paper calls *Governance Decay / Constraint Rot*).
> 3. **Multi-Agent File Collisions:** When running 4–10+ agents concurrently on the same repository, optimistic concurrency failed—agents overwrote each other's files or left stale lockfiles after a crash.
>
> So I built a two-line real-time telemetry bar that separates prefill speed (`↓ tok/s` and wall-clock seconds) from decode speed (`↑ tok/s` and wall-clock seconds) and audited the compiled binaries and configs of every major coding agent CLI:
>
> - **Antigravity (`agy-bin`)**: `defaultmodels.GeminiModelInfo` sets `MaxOutputTokens = 0x4000` (16,384) and `utils.GetCheckpointConfig` hardcodes the compaction threshold to `0x3e800` (256,000 tokens), leaving 75% of the 1M input window unused. Meanwhile, its internal `continuation.Orchestrator` actually has full multi-leg continuation logic (`64k × 16 = 1M`) once `initialMaxOutputTokens` is raised to `0x100000` (1,048,576) and `CheckpointConfig.MaxTokenLimit` is patched to `0xe7ef0` (950,000 tokens).
> - **Codex CLI**: defaults `tool_output_token_limit` to 10,000 tokens, silently truncating test logs and `git diff`s even when `model_context_window = 1000000`.
> - **Pi Coding Agent**: clamps `thinkingBudgets.high` to 16,384 tokens even when `thinkingLevel = "max"`, and passes `thinkingLevel = "max"` into compaction summaries with a `0.5 * reserveTokens` cap—causing reasoning models to burn the entire summary budget inside `<think>` and crash compaction with `stopReason === "length"`.
>
> I packaged the entire 5-part engineering toolkit into `unthrottle-agents` (MIT, zero dependencies, Python 3.9+, Linux `x86_64` + macOS `arm64`):
> 1. `bin/agent-audit` — 100% read-only diagnostic scanner across all agent harnesses and local `llama.cpp`.
> 2. `bin/agy-unlock-1m` — offset-independent `.gopclntab` binary & live `/proc/<pid>/mem` RAM unthrottler (950k continuous input + 64k/leg × 16 = 1M total output, with automatic `codesign` on macOS Apple Silicon).
> 3. `bin/agent-statusline` — 2-line real-time telemetry bar separating `↓ prefill` from `↑ decode` throughput and displaying live fleet task summaries.
> 4. `bin/agent-coord` — kernel-locked (`fcntl.flock`) multi-agent anti-collision engine and inter-agent fleet bus with git path-prefix overlap detection and OS process birth-time validation (`/proc/<pid>/stat` / `ps -o lstart=`).
> 5. `skills/super-intelligence/SKILL.md` (`Book2Skill`) — an installable Agent Skill for Claude Code, Antigravity, Codex, and Pi that enforces deterministic MCP tool sorting (`f_keep = 1.000` KV-cache retention), Constraint Pinning, and anti-collision locking.
>
> All of these tools grew out of the daily production engineering behind my new book, ***SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems***, available now on Amazon (**https://a.co/d/0gO1eMZX**) and in 11 languages worldwide.
>
> Happy to answer any questions about how the binary orchestrators, KV-cache prefix pinning, or the 22-agent anti-collision bus work under the hood!

---

## 2. Reddit (`r/LocalLLaMA`, `r/ClaudeAI`, `r/singularity`)

**Title:**
`I audited the binaries and configs of our 1M-context coding agents (Argon, Codex, Claude Code, Pi, llama.cpp). Almost all of them silently throttle you to 256k input and 16k output — here is the open-source scanner, 1M unthrottler & multi-agent anti-collision bus.`

**Body (pronto da incollare in Markdown):**
```markdown
While running a 24/7 multi-agent coding fleet across **Google Antigravity (Gemini 4 Argon)**, **Claude Code**, **OpenAI Codex CLI**, **Pi**, and local **`llama.cpp` (`llama-server`)**, I noticed that our "1M-context" agents kept developing amnesia after ~40 minutes, cutting off large single-turn refactors at 16k tokens, and stepping on each other's files when run in parallel.

Instead of guessing, I built a 2-line real-time statusbar (`bin/agent-statusline`) that separates **prefill speed (`↓ tok/s` and seconds)** from **decode speed (`↑ tok/s` and seconds)**, disassembled the Go binaries (`.gopclntab`), and inspected the default harness configs.

### What I Found Inside the Binaries & Harnesses

1. **Google Antigravity (`agy-bin` on Linux ELF `x86_64` & macOS Mach-O `arm64`):**
   - `defaultmodels.GeminiModelInfo` hardcodes `MaxOutputTokens = 0x4000` (**16,384 tokens**).
   - `utils.GetCheckpointConfig` hardcodes `MaxTokenLimit = 0x3e800` (**256,000 tokens**)—meaning the CLI compacts away **75% of your 1,048,576-token window** before you ever use it!
   - Yet inside the same binary, `continuation.Orchestrator` already contains a complete multi-leg continuation engine capable of chaining **65,536 tokens/leg × 16 legs = 1,048,576 tokens of continuous output** once unlocked.

2. **OpenAI Codex CLI (`~/.codex/config.toml`):**
   - Defaults `tool_output_token_limit = 10,000`, silently truncating test outputs, stack traces, and `git diff`s even when `model_context_window = 1000000`.

3. **Pi Coding Agent (`pi`):**
   - Clamps `DEFAULT_THINKING_BUDGETS.high = 16,384` even on `max`, and runs compaction summaries at `thinkingLevel = "max"` inside a `0.5 * reserveTokens` budget—so reasoning models burn the entire summary cap inside `<think>` and crash with `stopReason === "length"`.

4. **Local `llama.cpp` (`llama-server`) Silent KV-Cache Invalidation:**
   - When MCP servers register tools asynchronously in non-deterministic order or inject dynamic timestamps into system prompts, `f_keep` drops below `1.000`.
   - By enforcing deterministic alphabetical MCP tool sorting and anchoring dynamic telemetry to the user-turn suffix, our warm KV-cache retention stays at **`f_keep = 1.000` (100%)**, taking local prefill on an **RTX 6000 Ada** from **4.6 tok/s to 762 tok/s** (and cloud prefill to **47.2k tok/s**).

5. **Parallel Multi-Agent Collisions (2 to 22+ Concurrent Agents):**
   - Running multiple CLI agents on one repo without kernel locks leads to silent file overwrites and zombie lockfiles when processes crash.

---

### The Open-Source Toolkit: `unthrottle-agents` (MIT, Zero Dependencies)

Repo: **`https://github.com/swisscodernano/unthrottle-agents`**

It includes 5 standalone components:
- **`bin/agent-audit`** — 100% read-only diagnostic scanner across Antigravity, Codex, Claude Code, Pi, local `llama.cpp`, and fleet locks.
- **`bin/agy-unlock-1m`** — Offset-independent machine-code patcher for Linux `x86_64` ELF and macOS `arm64` Mach-O (plus live `/proc/<pid>/mem` hot-patching on Linux) that unlocks **950k continuous input** + **64k/leg (1M total) output**.
- **`bin/agent-statusline`** — 2-line real-time telemetry bar showing `in:230k/1M out:14.2k/1M(Σ1.3M) │ ↓47.2k/s(5.1s) ↑104/s(14.9s)` on line 1 and the latest completed fleet task summary on line 2.
- **`bin/agent-coord`** — Kernel-locked (`fcntl.flock`) multi-agent anti-collision & fleet coordination bus with git directory-prefix overlap detection and OS PID birth-time verification (`/proc/<pid>/stat` & `ps -o lstart=`).
- **`skills/super-intelligence/SKILL.md` (`Book2Skill`)** — Drop-in Agent Skill for `~/.claude/skills/`, `~/.gemini/skills/`, `~/.codex/skills/`, and `~/.pi/agent/skills/` that teaches your agents KV-cache discipline, **Constraint Pinning** (defeating post-compaction *Governance Decay*), and `agent-coord` locking.

---

### Companion Engineering Book: *SUPER INTELLIGENCE*

This toolkit was extracted directly from our production 22-agent architecture and is the official companion repo to my new book:
📖 ***SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems***
👉 **English Edition on Amazon:** **https://a.co/d/0gO1eMZX** *(also available in 11 languages across Amazon KDP & Rakuten Kobo)*.

Run `python3 ./bin/agent-audit` on your machine and let me know what throttles it catches!
```

---

## 3. X / Twitter Thread & LinkedIn Launch Post

### X / Twitter Launch Post (Single Long-Form Post or Thread Opener)

```text
Your "1M-context" AI coding agents are silently throttled to 256,000 input tokens and 16,384 output tokens in their compiled CLI binaries—and overwrite each other's files when run in parallel.

We disassembled the binaries, measured prefill (↓) vs decode (↑) in real time, and open-sourced the fix:

⚡ unthrottle-agents (MIT, Linux x86_64 + macOS arm64)

What’s inside:
1️⃣ bin/agent-audit — Read-only scanner for Antigravity (Argon), Claude Code, Codex CLI, Pi & local llama.cpp
2️⃣ bin/agy-unlock-1m — Binary & live-RAM unthrottler: 256k → 950k continuous input, 16k → 64k/leg × 16 = 1M output
3️⃣ bin/agent-statusline — 2-line telemetry bar separating ↓prefill tok/s from ↑decode tok/s
4️⃣ bin/agent-coord — Kernel-locked (fcntl.flock) multi-agent anti-collision & fleet bus (born from our 22-agent production fleet)
5️⃣ skills/super-intelligence/SKILL.md — Book2Skill module enforcing KV-cache prefix pinning (4.6 → 762 tok/s local prefill) & Constraint Pinning

📖 Official companion toolkit to my new book "SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems" — live now on Amazon:
👉 https://a.co/d/0gO1eMZX

GitHub repo in reply 👇
```

### LinkedIn Launch Post

```text
Why does a 1,000,000-token AI coding agent start forgetting your architecture after 40 minutes—and why do parallel agents collide on the same repository?

While engineering a 24/7 autonomous 22-agent software platform in Switzerland and writing my new book "SUPER INTELLIGENCE", we audited the compiled binaries and configurations of the leading coding agent CLIs (Google Antigravity / Gemini 4 Argon, Claude Code, OpenAI Codex CLI, Pi, and local llama.cpp).

The findings surprised even us:
• Hardcoded CLI Caps: Antigravity's binary hardcodes compaction at 0x3e800 (256k tokens—wasting 75% of the 1M window) and caps single-leg output at 0x4000 (16,384 tokens). Codex CLI truncates tool outputs at 10,000 tokens.
• Silent KV-Cache Invalidation: Non-deterministic MCP tool registration breaks prefix caching (f_keep < 1.000). Fixing it took our local RTX 6000 Ada prefill from 4.6 tok/s to 762 tok/s, and cloud prefill above 47,000 tok/s.
• Post-Compaction "Governance Decay": Standard checkpoint summaries silently drop standing engineering and safety rules unless you use Constraint Pinning.
• Multi-Agent Collisions: Running 5–20 agents in parallel without kernel-level file/prefix locks causes silent overwrites and stale lockfiles.

Today we are open-sourcing the complete 5-part engineering toolkit under the MIT license (`unthrottle-agents`):
✅ `bin/agent-audit` — 100% read-only diagnostic scanner
✅ `bin/agy-unlock-1m` — 950k input / 1M output unthrottler (Linux ELF x86_64 + macOS Mach-O arm64 + live RAM hot-patch)
✅ `bin/agent-statusline` — 2-line real-time telemetry bar separating prefill (↓) from decode (↑) speed
✅ `bin/agent-coord` — Kernel-locked (`fcntl.flock` + PID birth-time) multi-agent anti-collision & fleet bus
✅ `skills/super-intelligence/SKILL.md` — Installable Book2Skill for Claude Code, Antigravity, Codex, and Pi

📖 This repository is the official companion toolkit to my international book, "SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems", available today in 11 languages.

Grab the English edition on Amazon here:
👉 https://a.co/d/0gO1eMZX
```

---

## 4. Script per il Video Virale da 90 Secondi (X / YouTube Shorts / LinkedIn)

- **0:00 – 0:15 (Il Gancio Visivo):**
  Terminale diviso a metà. Sopra: un coding agent standard su un modello da 1M di token. Sotto: lo stesso agente con la barra a 2 righe (`in:230k/1M out:14.2k/1M(Σ1.3M) │ ↓47.2k/s(5.1s) ↑104/s(14.9s)`).
  *Voce (EN / IT):* "Paghi per un milione di token di contesto, ma il tuo coding agent si fa venire l'amnesia a 256.000 token, taglia i file a 16.000 e sovrascrive il lavoro degli altri agenti. Non è colpa del modello: è un freno a mano scritto nel binario del tuo terminale."
- **0:15 – 0:45 (La Prova nel Codice — `agent-audit` & `agy-unlock-1m`):**
  Lanci `python3 ./bin/agent-audit` e mostri in 2 secondi i semafori `[THROTTLED]` che diventano `[UNLOCKED]`:
  - `0x3e800` (256.000) → `0xe7ef0` (**950.000 token continui** prima di compattare);
  - `0x4000` (16.384) → `65.536` per gamba × 16 gambe = **1 milione di token in uscita**.
- **0:45 – 1:15 (Anti-Collisione a 22 Agenti + `Book2Skill`):**
  Mostri `bin/agent-coord status` che coordina la flotta con lock atomici del kernel (`fcntl.flock` + verifica birth-time del PID) e la skill `skills/super-intelligence/SKILL.md` installata in Claude Code e Antigravity che mantiene la KV-cache al 100% (`↓47.2k/s` cloud / `762 tok/s` locale).
- **1:15 – 1:30 (Call to Action con Link Amazon Diretto):**
  "L'intero toolkit a 5 moduli è gratis e open-source su GitHub (`unthrottle-agents`), e tutta l'architettura dietro queste flotte autonome è nel mio nuovo libro *SUPER INTELLIGENCE*, disponibile ora su Amazon al link **`https://a.co/d/0gO1eMZX`** e in 11 lingue nel mondo."
