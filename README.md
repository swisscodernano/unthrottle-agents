# ⚡ unthrottle-agents

**Your 1M-context AI coding agents are silently throttled to 256k input and 16k output. Measure it in real time and unlock the full window.**

[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg)](LICENSE)
[![Platform: Linux & macOS](https://img.shields.io/badge/Platform-Linux%20x86__64%20%7C%20macOS%20arm64-blue.svg)](#quick-start)
[![Book: SUPER INTELLIGENCE](https://img.shields.io/badge/Companion%20Book-SUPER%20INTELLIGENCE%20(11%20Languages)-amber.svg)](#companion-book-super-intelligence)

```text
argon.4-(high) │ ██░░░░░░ 22% │ in:230k/1M out:14.2k/1M(Σ1.3M) │ ↓47.2k/s(5.1s) ↑104/s(14.9s) │ 5h:10% 7d:2% │ $0.00 │ 10:15
↳ ult:10:15 │ Unlocked 950k continuous context window + 64k/leg (1M total) output ceiling across all fleet agents
```

---

## Why Your 1M-Token Coding Agent Feels Like It Has Amnesia After 40 Minutes

Frontier models in late 2026 (**Gemini 4 Argon**, **Claude Opus 5.5**, **GPT-5.6 / Codex**, **Xiaomi MiMo v2.6 Pro**, **MiniMax-M3.1-Flash**, **DeepSeek V4.1**) advertise **1,000,000-token context windows** and **64k–512k output ceilings**.

Yet if you inspect the compiled binaries and default harness configurations of the CLI agents you run every day, you discover a massive gap between **what the model API supports** and **what the local CLI harness permits**:

| Agent Harness | Advertised Model Window | Hidden Default CLI Throttle | What Actually Happens in Production | **With `unthrottle-agents`** |
| :--- | :--- | :--- | :--- | :--- |
| **Google Antigravity (`agy` / Argon)** | **1,048,576 in / 1M out** | `0x3e800` (**256k** compaction trigger) & `0x4000` (**16,384** output cap) | Compacts away 75% of your 1M window at 256k; truncates single-turn file generation at 16k | **950,000 in** (95% before compaction) + **65,536/leg × 16 legs = 1,048,576 out** |
| **OpenAI Codex CLI (`codex`)** | **1,000,000 in** | `tool_output_token_limit = 10,000` | Truncates test logs, `git diff`s, and large file reads at 10k tokens | **1,000,000 in** + **900,000 auto-compact** + **65,536 tool output** |
| **Pi Coding Agent (`pi`)** | **1,000,000 in / 512k out** | `DEFAULT_THINKING_BUDGETS.high = 16,384` + `0.5 * reserveTokens` summary cap | Throttles `<think>` even on `max`; long-session compaction crashes with `stopReason === "length"` | **65,536 thinking budget** + **950k/1M cloud compaction** + **Constraint Pinning** |
| **Claude Code (`claude` wrappers)** | **1,000,000 in / 64k out** | `32,000` output cap | Cuts off large multi-file refactors mid-stream | **1,000,000 in** + **64,000 out** |

---

## 🔬 Grounded in 2025–2026 Agent Systems Research

Every configuration and patch in this repository is backed by empirical measurements and four recent papers on long-horizon coding agents:

1. **Silent Prompt-Cache Invalidation (*"Silent and Costly: Characterizing and Detecting Prompt-Caching Mis-Integration in LLM Agents"*, Oct 2026 & *"Don't Break the Cache"*, Feb 2026)**
   - **Finding:** ~90% of prompt-caching failures in coding agents happen silently—most commonly when MCP servers register tools in non-deterministic async order or inject dynamic timestamps into system prompts, invalidating the KV-cache prefix (`f_keep < 1.000`) and tripling prefill latency (`↓`).
   - **Our Fix:** Deterministic alphabetical sorting of MCP server & tool registrations + immutable user-turn suffix anchoring (`f_keep = 1.000`).

2. **Governance Decay During Compaction (*"Governance Decay: How Context Compaction Silently Erases Safety Constraints in Long-Horizon LLM Agents"*, Chen, June 2026)**
   - **Finding:** Standard context compaction optimizes for task continuity and silently drops standing architectural rules (*Constraint Rot*) after the first checkpoint summary.
   - **Our Fix:** **Constraint Pinning** inside the compaction summarization prompt so standing invariants (worktree isolation, language, verification gates) survive across unlimited compactions.

3. **Observation Bloat vs. Reasoning (*"The Complexity Trap: Simple Observation Masking Is as Efficient as LLM Summarization"*, JetBrains Research, NeurIPS DL4Code)**
   - **Finding:** Over 80% of context bloat in SWE agents comes from stale tool outputs rather than reasoning turns, and reasoning at `max` effort *during* compaction wastes thousands of `<think>` tokens and hits output length caps.
   - **Our Fix:** Decouple session reasoning (`max` / `65,536` tokens) from compaction summarization reasoning (`low` with a guaranteed `>= 32,768` output ceiling).

4. **Separating Prefill (`↓`) from Decode (`↑`) Latency in Real Time**
   - Standard statusbars only show total tokens or cost. When an agent pauses for 12 seconds, you cannot tell if it is digesting a 300k uncached prompt (`↓ prefill`) or generating a slow reasoning trace (`↑ decode`).
   - Our **2-line statusbar** measures both rates in tokens/sec *and* wall-clock seconds (`↓47.2k/s(5.1s) ↑104/s(14.9s)`), alongside active/max input and output windows (`in:230k/1M out:14.2k/1M(Σ1.3M)`).

---

## 🚀 Quick Start (Linux `x86_64` & macOS Apple Silicon `arm64`)

### 1. Audit your current coding agents (100% read-only)

```bash
git clone https://github.com/aiagens/unthrottle-agents.git
cd unthrottle-agents
python3 ./bin/agent-audit
```

Example output:
```text
⚡ UNTHROTTLE-AGENTS — AI Coding Agent Context & Output Audit
Platform: Linux x86_64

  [UNLOCKED]   Antigravity Output Window      64k/leg + 1,048,576 (1M) Orchestrator ceiling active
  [UNLOCKED]   Antigravity Input Compaction   Compacts at 950,000 / 1,048,576 tokens (95% window)
  [UNLOCKED]   Antigravity hooks.json         Valid flat handler schema
  [UNLOCKED]   OpenAI Codex CLI Limits        1M context + 900k auto-compact + 64k tool_output_token_limit active
  [UNLOCKED]   Pi Coding Agent                thinkingBudgets.high=65536 (4x default) & compaction.reserveTokens=50000
  [UNLOCKED]   Local llama.cpp Router         Online at http://127.0.0.1:5569 (Qwen3.8-27B)
```

---

## 📖 Companion Book: *SUPER INTELLIGENCE* (Available in 11 Languages)

This toolkit was born while engineering a 24/7 autonomous multi-agent software & medical-AI platform in Switzerland and writing the international book **_SUPER INTELLIGENCE: How to Build, Govern, and Survive High-Density Autonomous AI Systems_**.

If this repository saved you tokens, unlocked your 1M context window, or helped you understand what happens inside modern agent orchestrators, support our independent research by grabbing the book (Kindle, Kobo EPUB3, Paperback, and Hardcover):

- 🇮🇹 **Italiano:** *SUPER INTELLIGENZA* (Amazon KDP & Rakuten Kobo)
- 🇬🇧 **English:** *SUPER INTELLIGENCE* (Amazon KDP & Rakuten Kobo)
- 🇩🇪 **Deutsch:** *SUPERINTELLIGENZ* | 🇫🇷 **Français:** *SUPER INTELLIGENCE* | 🇪🇸 **Español:** *SUPERINTELIGENCIA* | 🇵🇹 **Português:** *SUPERINTELIGÊNCIA*
- 🇯🇵 **日本語:** 『超知能』 | 🇨🇳 **中文:** 《超级智能》 | 🇰🇷 **한국어:** 『초지능』 | 🇷🇺 **Русский:** «СУПЕРИНТЕЛЛЕКТ» | 🇸🇦 **العربية:** «الذكاء الفائق»

---

## License

MIT License — Built for the open-source AI engineering community.
