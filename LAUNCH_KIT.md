# 🚀 Kit di Lancio Virale (`unthrottle-agents` + Libro *SUPER INTELLIGENZA*)

Tutti i testi qui sotto sono pronti da copiare e incollare. L'orario migliore per pubblicare su **Hacker News** e **Reddit** è tra le **14:30 e le 16:00 CET** (8:30–10:00 EST, quando si sveglia la costa Est americana ed è già online tutta l'Europa).

---

## 1. Hacker News (`Show HN`)

**Title (max 80 chars):**
`Show HN: Unthrottle-Agents – Your 1M-context coding agents are capped at 256k/16k`

**URL:**
`https://github.com/<tuo-username>/unthrottle-agents`

**First Comment (da postare subito dopo l'invio):**
> Hi HN,
>
> While running long multi-file refactors across Google Antigravity (Gemini 4 Argon), OpenAI Codex CLI, Claude Code, and Pi, I kept noticing two strange behaviors:
> 1. Even on models with a 1,048,576-token context window and 1M max output, single-turn generation always cut off or chained at ~16k tokens, and context compaction fired when the session was only ~25% full (around 256k tokens).
> 2. After the first compaction, agents frequently forgot standing repository rules (what Shiyang Chen's June 2026 paper calls *Governance Decay / Constraint Rot*).
>
> So I built a two-line real-time telemetry bar that separates prefill speed (`↓ tok/s` and seconds) from decode speed (`↑ tok/s` and seconds) and audited the binaries and configs of every major coding agent CLI:
>
> - **Antigravity (`agy-bin`)**: `defaultmodels.GeminiModelInfo` sets `MaxOutputTokens = 0x4000` (16,384) and `utils.GetCheckpointConfig` hardcodes the compaction threshold to `0x3e800` (256,000 tokens), leaving 75% of the 1M input window unused. Meanwhile, its internal `continuation.Orchestrator` actually has full multi-leg continuation logic if `initialMaxOutputTokens` is raised to `0x100000` (1M).
> - **Codex CLI**: defaults `tool_output_token_limit` to 10,000 tokens, silently truncating test logs and diffs even when `model_context_window = 1000000`.
> - **Pi Coding Agent**: clamps `thinkingBudgets.high` to 16,384 tokens even when `thinkingLevel = "max"`, and passes `thinkingLevel = "max"` into compaction summaries with a `0.5 * reserveTokens` cap—causing reasoning models to burn the entire summary budget inside `<think>` and crash compaction with `stopReason === "length"`.
>
> I packaged the read-only diagnostic scanner (`agent-audit`), the 2-line prefill/decode telemetry bar (`agent-statusline`), and the paper-backed fixes (Constraint Pinning + deterministic MCP tool sorting to prevent silent KV-cache invalidation) into `unthrottle-agents` (MIT, zero dependencies, Linux `x86_64` + macOS `arm64`).
>
> These tools came out of the engineering research for my new book *SUPER INTELLIGENCE* (just published across 11 languages). Happy to answer any questions about how the orchestrators work under the hood!

---

## 2. Reddit (`r/LocalLLaMA`, `r/ClaudeAI`, `r/singularity`)

**Title:**
`I audited the binaries and configs of our 1M-context coding agents (Argon, Codex, Claude Code, Pi, llama.cpp). Almost all of them silently throttle you to 256k input and 16k output — here is the open-source scanner & fix.`

**Body:**
*(Usa il testo del `README.md` + il primo commento di Hacker News, aggiungendo per `r/LocalLLaMA` il dettaglio su `llama-server`: come l'ordinamento deterministico dei tool MCP e l'ancora sul messaggio utente mantengono `f_keep = 1.000` al 100% nella KV-cache su RTX 6000 Ada passando da 4,6 tok/s a 762 tok/s in prefill).*

---

## 3. Script per il Video Virale da 90 Secondi (X / YouTube Shorts / LinkedIn)

- **0:00 – 0:15 (Il Gancio Visivo):**
  Terminale diviso a metà. Sopra: un coding agent standard su un modello da 1M di token. Sotto: lo stesso agente con la tua barra a 2 righe (`in:239k/1M out:14.2k/1M │ ↓47.2k/s(5.1s) ↑104/s(14.9s)`).
  *Voce:* "Paghi per un milione di token di contesto, ma il tuo coding agent si fa venire l'amnesia a 256.000 token e taglia i file a 16.000. Non è colpa del modello: è un freno a mano scritto nel binario del tuo terminale."
- **0:15 – 0:45 (La Prova nel Codice):**
  Lanci `python3 ./bin/agent-audit` e mostri in 2 secondi i semafori `[THROTTLED]` che diventano `[UNLOCKED]`:
  - `0x3e800` (256.000) → `0xe7ef0` (950.000 token continui prima di compattare);
  - `0x4000` (16.384) → `65.536` per gamba × 16 gambe = **1 milione di token in uscita**.
- **0:45 – 1:15 (L'effetto dal vivo):**
  Mostri la seconda riga della barra di stato (`↳ ult:10:15 │ ...`) e la velocità di prefill (`↓47.2k/s`) quando la KV-cache non viene invalidata.
- **1:15 – 1:30 (Call to Action):**
  "Il toolkit è gratis e open-source su GitHub (`unthrottle-agents`), e tutta l'architettura dietro queste flotte autonome è nel mio nuovo libro *SUPER INTELLIGENZA*, disponibile oggi su Amazon e Kobo in 11 lingue."
