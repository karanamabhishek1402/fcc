---
name: free-claude-code
description: Install, configure, run, update, troubleshoot, or uninstall Free Claude Code (FCC) — the local proxy that runs Claude Code, Codex, OpenCode, Cline, Aider and other coding agents on free/cheap models (NVIDIA NIM, OpenRouter, Groq, Gemini, Ollama, LM Studio, 60+ providers). Use when the user mentions free-claude-code, FCC, fcc-server, fcc-claude, running Claude Code with free or local models, or routing Claude Code through another provider.
---

# Free Claude Code (FCC)

Source: https://github.com/Alishahryar1/free-claude-code (AGPL-3.0, not affiliated with Anthropic).

FCC is a local proxy (default `http://127.0.0.1:8082`, Admin UI at `/admin`) that speaks the Anthropic API to coding agents and forwards requests to OpenAI-compatible providers. Config lives in `~/.fcc/.env`; logs in `~/.fcc/logs/server.log`. Prefer changing settings in the Admin UI over editing `.env` by hand.

## 1. Install

Detect the OS first, then run the matching command. The installer is interactive (asks which coding agents to install) — tell the user to answer the prompts, or have them run it themselves with `! <command>` if the session can't take input.

macOS / Linux / WSL:
```bash
curl -fsSL "https://raw.githubusercontent.com/Alishahryar1/free-claude-code/main/scripts/install.sh" | sh
```

Windows PowerShell:
```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/Alishahryar1/free-claude-code/main/scripts/install.ps1")))
```

Installer flags (sh form → PowerShell form):
| Flag | Purpose |
| --- | --- |
| `--rtk-headroom` / `-RtkHeadroom` | RTK + Headroom token optimization (up to ~90% fewer tokens) |
| `--voice-local` / `-VoiceLocal` | Local Whisper voice transcription |
| `--torch-backend cu130` / `-TorchBackend cu130` | CUDA build of PyTorch (needs voice-local) |
| `--dry-run` / `-DryRun` | Print commands without running |

Pass sh flags as `... | sh -s -- --rtk-headroom`. The installer pulls in `uv` and Python 3.14 itself; the user doesn't need either beforehand. If a launcher says the agent is missing, install it (Claude Code: `npm install -g @anthropic-ai/claude-code`).

## 2. Start the server

- Windows / macOS: open the **Free Claude Code** app (tray / menu-bar icon → Admin, Restart, Quit).
- Linux / WSL: `fcc-server` and keep that terminal open (run it in the background if you need the shell).
- The `fcc-*` launchers start the server automatically if it isn't running.
- Check the install without starting: `fcc-server --version`.

## 3. Configure a provider (Admin UI → Providers)

Default and easiest free option is **NVIDIA NIM**:
1. Key from https://build.nvidia.com/settings/api-keys
2. Admin UI → Providers → NVIDIA NIM → **Add key** → paste → **Save**
3. Model Config → `MODEL` = `nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b` (or pick another) → **Apply**

Never ask the user to paste API keys into the chat; have them enter keys in the Admin UI.

Other common providers (`<prefix>/<model-id>` format for `MODEL`):
| Provider | Key setting | Example MODEL |
| --- | --- | --- |
| OpenRouter | `OPENROUTER_API_KEY` | `open_router/openrouter/free` |
| Groq | `GROQ_API_KEY` | `groq/llama-3.3-70b-versatile` |
| Google AI Studio | `GEMINI_API_KEY` | `gemini/models/gemini-3.1-flash-lite` |
| Cerebras | `CEREBRAS_API_KEY` | `cerebras/gpt-oss-120b` |
| DeepSeek | `DEEPSEEK_API_KEY` | `deepseek/deepseek-chat` |
| Mistral Codestral | `CODESTRAL_API_KEY` | `mistral_codestral/codestral-latest` |
| Ollama (local) | `OLLAMA_BASE_URL` (default `http://localhost:11434`) | `ollama/<tag>` |
| LM Studio (local) | `LM_STUDIO_BASE_URL` (default `http://localhost:1234/v1`) | `lmstudio/<model-id>` |
| llama.cpp (local) | `LLAMACPP_BASE_URL` (default `http://localhost:8080/v1`) | `llamacpp/<model-id>` |
| ChatGPT subscription | Providers → OAuth providers → Connect | `openai/<model-id>` |
| GitHub Copilot | OAuth connect (needs Copilot CLI on PATH) | `github_copilot/<model-id>` |

The full 61-provider table is in the repo README ("Provider catalog"). Any other OpenAI-compatible endpoint: Providers → Custom providers → Add provider.

Useful extras in Model Config:
- **Tier routing**: `MODEL_FABLE`, `MODEL_OPUS`, `MODEL_SONNET`, `MODEL_HAIKU` override `MODEL` per Claude tier.
- **Fallback Models**: ordered list tried automatically when the primary fails (may consume quota on several providers).
- **Reasoning effort** per model: From client / Off / Low…Max / Inherit.
- **Proxy Authentication**: protects the proxy with a bearer token (`ANTHROPIC_AUTH_TOKEN`).

Prefer tool-capable models with large context; small local models often fail on agent system prompts.

## 4. Run a coding agent

| Agent | Command |
| --- | --- |
| Claude Code | `fcc-claude` |
| Codex | `fcc-codex` |
| OpenCode | `fcc-opencode` |
| Cline | `fcc-cline` |
| Aider | `fcc-aider` |
| Pi / Hermes / Grok Build / Muse Code / DeepSeek Harness | `fcc-pi` / `fcc-hermes` / `fcc-grok` / `fcc-muse` / `fcc-dsh` |

Extra args pass through (e.g. `fcc-claude -p "hi"`). In Claude Code, `/model` lists FCC models.

Manual wiring (only if the launcher can't be used): `ANTHROPIC_BASE_URL=http://127.0.0.1:8082` and `ANTHROPIC_AUTH_TOKEN=<proxy token or any value>`.

Editor/desktop clients (VS Code Claude Code, VS Code Chat, Claude Desktop, Codex app, JetBrains ACP, DeepSeek Harness Desktop): start FCC → Admin UI → **Integrations** → **Connect**, then reload/restart the client. **Disconnect** undoes it. Claude Desktop must be fully quit before connecting.

## 5. Optional: Discord / Telegram bot, voice

Admin UI → Messaging. Set platform, bot token, allowed channel/user ID, and an absolute **Allowed Directory**, then Apply. Bot commands: `/stats`, `/stop`, `/clear` (reply to a message to scope it). Voice: Messaging → Voice, use `nvidia_nim` or local Whisper (requires the `--voice-local` install).

## 6. Maintain

- Update: stop all FCC commands, then `fcc-update`.
- Diagnose: `fcc-doctor` (paste output into bug reports); read `~/.fcc/logs/server.log`.
- Uninstall (removes FCC + `~/.fcc/`, keeps uv/Python/agents):
  - sh: `curl -fsSL "https://raw.githubusercontent.com/Alishahryar1/free-claude-code/main/scripts/uninstall.sh" | sh`
  - PowerShell: `& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/Alishahryar1/free-claude-code/main/scripts/uninstall.ps1")))`
  Confirm with the user before uninstalling.

## Troubleshooting checklist

1. `fcc-server --version` — is it installed and on PATH? If not, open a new shell or re-run the installer.
2. Is the server up? `curl -s http://127.0.0.1:8082/admin -o /dev/null -w '%{http_code}'` (or check the `PORT` in `~/.fcc/.env`).
3. Provider errors (401/403/429): key wrong or quota exhausted → fix key in Admin, or add Fallback Models.
4. Model not in dropdown: click **Refresh models**, or type `<provider-id>/<exact-model-id>` manually.
5. Local model server started after FCC: Admin → provider card → **Test** / Refresh models.
6. Integration changes not visible: restart the client app; after OAuth connects, restart running agents.
7. Still stuck: run `fcc-doctor` and check the server log, then point the user to https://github.com/Alishahryar1/free-claude-code/issues.

Free-tier limits are set by each provider and change over time; don't promise specific quotas.
