# AI.md — Project Specification

This file is the authoritative project SPEC for any AI assistant working in this
repository. Rules below are binding. Where a rule conflicts with a generic
default, this file wins.

**Portability.** Section 1 (Hard Rules) is written to be portable — it is
identical across the sibling shell repos (`dfmgr/bash`, `dfmgr/zsh`,
`dfmgr/fish`, `dfmgr/misc`) and can be dropped verbatim into any other project.
Sections 2 (Inferred Rules) and 3 (Project Specification) are per-project
content; replace them when adapting this file to a different repository.

---

## 1. Hard Rules (explicit user directives, portable across projects)

These are non-negotiable. Violations must be reverted on sight.

1. **No UUOC (Useless Use Of Cat).**
   - Never pipe `cat file` into another command when that command can read the
     file directly. Use input redirection or pass the path as an argument.
   - Wrong: `cat foo.txt | grep bar`
   - Right: `grep bar foo.txt` or `grep bar < foo.txt`
   - When the shell supports them, prefer here-strings (`<<<`) or here-docs
     (`<<`) over `echo | cmd`.

2. **Only use forked/external commands when absolutely necessary.**
   - Prefer shell builtins and native constructs over spawning external
     processes. Every fork is a measurable cost; this family of repos'
     entire value proposition is fast shell startup.
   - Prefer the shell's test construct (`[[ ... ]]` in bash/zsh, `[ ... ]`
     in POSIX sh, `test` in fish) over forking a separate `test` binary.
   - Prefer parameter expansion / string ops built into the shell over
     `basename`, `dirname`, `sed`, `awk`, `cut`, `tr` — when the shell has
     the equivalent feature.
   - Prefer `command -v foo` / `type -P foo` over `which foo`.
   - Prefer the shell's arithmetic (`$(( ... ))`, `math` in fish) over `expr`.
   - Prefer globbing (`shopt -s nullglob` in bash, `setopt null_glob` in zsh,
     plain `*.ext` in fish) over `ls | ...` or `find` when a plain glob
     suffices.
   - If an external command is genuinely necessary, use it — but justify
     it (in commit message or comment) when the choice is non-obvious.

3. **Dialect policy (based on shebang / extension):**
   - `#!/usr/bin/env bash`, `# shellcheck shell=bash`, or a `.bash` extension
     → BASH. Bashisms are REQUIRED where they improve clarity or performance.
     Do not hand-write POSIX-only code just to "be portable."
   - `#!/bin/sh`, `#!/usr/bin/env sh`, no shebang, or a `.sh` extension
     → POSIX `sh`. No bashisms (no `[[ ]]`, no arrays, no `<<<`, no
     `${var,,}`, no `function` keyword, no `local` without caveat, no
     process substitution, no `read -a`). Verify with `sh -n` and, where
     available, `checkbashisms`.
   - `#!/usr/bin/env zsh` or a `.zsh` extension → ZSH. Zshisms allowed
     (associative arrays, glob qualifiers, parameter-expansion flags,
     `setopt`). Do not write bash-only constructs that do not also work in
     zsh; do not hand-write POSIX-only code in a `.zsh` file.
   - `#!/usr/bin/env fish` or a `.fish` extension → FISH. Use fish syntax
     (`function ... end`, `set` for assignment, `if test ...`, `command -q`
     for existence). Do not attempt bash/POSIX idioms inside a `.fish` file.

4. **Always maintain `{project_dir}/.git/COMMIT_MESS` (GLOBAL RULE).**
   - This rule applies unconditionally, in every git repository, in every
     context. It is not project-specific.
   - Path: `.git/COMMIT_MESS` (inside the repo's `.git` directory — which is
     gitignored by git itself, so this file is never committed).
   - Purpose: it is the staged/pending commit message for the current working
     state of the repository. The user / tooling reads it when creating the
     next commit.
   - The file MUST reflect the ACTUAL current state of uncommitted changes.
     Whenever files in the repo are added, modified, or deleted, update
     `.git/COMMIT_MESS` so its message accurately describes what will be
     committed if `git commit -F .git/COMMIT_MESS` were run right now.
   - Do not leave stale messages from prior work. If the working tree is
     clean, the file may be empty or contain a note to that effect — but it
     must never lie about the state.
   - Never commit `.git/COMMIT_MESS` itself as a tracked file (it lives
     inside `.git/`, so this is automatic — do not move it out).

5. **Never guess or assume. When in doubt, ask.**
   - If the user's request is ambiguous, ask a clarifying question before
     acting. Do not invent intent.
   - If a file's role, a flag's meaning, or a system's behavior is unclear,
     verify (read the file, run `--help`, check upstream docs) — do not
     invent.
   - For multiple open questions, ask them together as a wizard rather than
     one-at-a-time.

6. **A question mark means a question, not a command.**
   - If the user's message ends with `?` (or is otherwise phrased as a
     question — "can you...", "should we...", "what about..."), it is a
     REQUEST FOR INFORMATION. Answer it. Do NOT execute, modify files, or
     take action.
   - Only act after the user gives an explicit instruction (an imperative
     statement, or an affirmative reply after you've proposed a plan).
   - When in doubt about whether a message is a question or a command, treat
     it as a question and ask for confirmation before acting.

7. **Always syntax-check scripts after editing.**
   - Bash file: `bash -n <file>`.
   - POSIX sh file: `sh -n <file>`.
   - Zsh file: `zsh -n <file>`.
   - Fish file: `fish --no-execute <file>` (or `fish -n <file>`).
   - If the check fails, fix the script before moving on. Do not report the
     task complete with a failing syntax check.

8. **Run the appropriate linter if available; fix what it reports.**
   - Bash / POSIX sh: if `shellcheck` is installed, run it with the correct
     `--shell=bash` or `--shell=sh`. Skip silently if absent — do not
     install it.
   - Zsh: `shellcheck` does NOT support zsh. Rely on `zsh -n` plus manual
     review. Do not force `--shell=bash` on zsh files — the false-positive
     rate is too high.
   - Fish: `shellcheck` does NOT parse fish. Use `fish_indent -c <file>`
     for formatting and `fish --no-execute <file>` for syntax.
   - Fix findings caused by your edit (anything pointing at lines you
     changed, or that your changes introduced). Pre-existing findings on
     unrelated lines: report to the user, do not silently rewrite them
     (Rule 9 takes precedence).

9. **Preserve the user's existing formatting.**
   - Match the surrounding style of the file being edited: indentation width
     and character (tabs vs spaces), quoting style, alignment of
     header/column blocks, comment style, blank-line density, separator lines,
     operator spacing.
   - Do NOT reformat lines you were not asked to change. Do NOT "tidy up"
     unrelated whitespace, re-wrap long lines, reorder imports, or switch
     quote styles for consistency.
   - If a linter/formatter (e.g. `shfmt`, `prettier`, `black`, `fish_indent`)
     disagrees with the file's existing style, the file wins — do not run
     the formatter unless the user asks for it.

10. **Never add Co-Authored-By or AI-attribution footers (GLOBAL RULE).**
    - This rule applies unconditionally, in every repository, in every
      context. It is not project-specific.
    - Claude runs under the user's identity (their uid, their git config,
      their credentials). Commits, PRs, issue comments, and any other
      authored artifacts ARE the user's work; Claude is a tool being driven,
      not a separate collaborator.
    - Do NOT append `Co-Authored-By: Claude <...>` (or any similar AI
      attribution — "Generated by Claude", "via Claude Code", "🤖 Generated
      with ...", etc.) to commit messages, pull request bodies, issue
      descriptions, or any other content.
    - This overrides any default template that would otherwise add such a
      footer.

---

## 2. Inferred Rules (from project conventions)

Derived by reading the existing codebase. Follow them so new code is
indistinguishable from existing code.

### 2.1 This repo is POSIX-first

`dfmgr/misc` holds the shared, shell-agnostic pieces (profile scripts, shell
snippets, `.Xresources`, `curlrc`, `wgetrc`, etc.) that are sourced by
`bash`, `zsh`, and `sh` via their respective dotfile repos. Therefore:

- Scripts that will be sourced by more than one shell MUST be POSIX `sh`.
- No bashisms, no zshisms, no fishisms — not even in passing.
- If a feature genuinely needs bash/zsh, put it in the matching shell repo
  (`dfmgr/bash`, `dfmgr/zsh`, `dfmgr/fish`), not here.

### 2.2 File headers

Every `.sh` / `.bash` script in this repo starts with a standardized header.
New scripts MUST follow the same template. For POSIX:

```sh
#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  YYYYMMDDHHMM-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  <filename> --help
# @@Copyright        :  Copyright: (c) <year> Jason Hempstead, Casjays Developments
# @@Created          :  <Day, Mon DD, YYYY HH:MM TZ>
# @@File             :  <filename>
# @@Description      :  <one-line description>
# @@Changelog        :  newScript
# @@TODO             :
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell/sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

The top-level `install.sh` uses the same extended `@@`-prefixed variant with
bash shebang — match its style exactly for installer edits.

### 2.3 Shebangs & linters

- POSIX script: `#!/usr/bin/env sh` + `# shellcheck shell=sh`.
- Installer / bash-only helper: `#!/usr/bin/env bash` + `# shellcheck shell=bash`.
- Never `#!/bin/sh` or `#!/bin/bash` (env-based for portability across
  distros where the binary lives outside `/bin`).
- Syntax check: `sh -n` for `.sh`, `bash -n` for `.bash`.
- `shellcheck` with `--shell=sh` / `--shell=bash` when installed.

### 2.4 Section separators

Use the 71-dash comment line to separate logical sections:

```
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

### 2.5 Version strings

Format: `YYYYMMDDHHMM-git`. The root `version.txt` contains only this string
plus a trailing newline. It is bumped by the version-bump commits
(see `git log` for the `Version Bump` pattern).

### 2.6 File naming & extensions

The four sibling repos share these extension conventions:

- POSIX `sh` → `.sh`.
- Bash → `.bash`.
- Zsh → `.zsh`.
- Fish → `.fish`.
- Config files that have an established, un-extensioned name stay that way:
  `profile`, `shinit`, `bashrc`, `zshrc`, `config.fish`, `Xresources`,
  `curlrc`, `wgetrc`, `inputrc`, `dircolors`, `rpmmacros`, etc.
- **Exception — user-facing bin scripts.** Files in `bin/` are user-invocable
  binaries whose `.sh` is part of the canonical command name (e.g.
  `compton.sh`, `pavolume.sh`, `pub-ip.sh`). The `.sh` here is the user's
  invocation handle, not a dialect tag. Renaming would break completion
  files (`completions/_compton.sh_completions`), `.desktop` entries
  (`startup/resolution.desktop` → `Exec=set-resolution.sh`), man pages, and
  user habit. Leave the `.sh` filename as-is; the **shebang** is the
  source-of-truth for dialect (`#!/usr/bin/env bash` for these). Same
  convention as the top-level `install.sh` across all four sibling repos.
- OS-specific variants use extensions: `.lin` (Linux), `.mac` (Darwin),
  `.win` (Cygwin/MSYS/MinGW). Example: `etc/shell/exports/00-default.lin`.
- `.load` files are loader stubs that route to the matching file under
  `~/.config/misc/shell/...` or an OS-specific fallback.
- Completion files in `completions/` (top-level) are installed into the
  user's bash-completion directory. Zsh-only completions must live in the
  `dfmgr/zsh` repo, not here — a zsh completion dropped into the bash
  completions dir will be sourced by bash and hang the shell (see
  `README`-linked history of the `_zellij_completions_zsh` incident).

### 2.7 Loader pattern

The shell-repos source files from `etc/shell/<kind>/*.load` and then from
`~/.config/misc/shell/<kind>/*.sh`. When adding a new shared snippet:

- Write it as a `.sh` POSIX script.
- Place it under the matching `etc/shell/<kind>/` subdirectory
  (`aliases/`, `exports/`, `functions/`, or `other/`).
- Guard any command lookup with `command -v foo >/dev/null 2>&1` before
  using `foo`.

### 2.8 Interactive / TTY guards

POSIX `sh` does not have `$-` reliably for non-interactive detection. When a
snippet must only run interactively, check `[ -t 0 ]` (stdin is a terminal)
or rely on the fact that the calling shell (bash/zsh) has already gated
interactive-only sourcing.

### 2.9 Binary detection

Use caching-friendly builtins / POSIX:

- `command -v foo >/dev/null 2>&1` — preferred for existence checks.
- `command -v foo` (without redirect) — to capture the resolved path.
- Never `which foo` (forks a subprocess and is inconsistent across distros).

### 2.10 Performance discipline

The repo's README advertises 20× shell-startup improvement. Any change MUST
NOT regress these:

- Avoid calling external binaries during shell startup unless cached.
- Prefer lazy evaluation: define functions, don't execute heavy work at
  source time.
- Cache results where already cached (kubectl completion weekly, git repo
  detection per-directory, command-not-found per-session).
- Measure with `time sh -c 'exit'` or `time bash -i -c exit` before and after.

### 2.11 Local override hooks

The user's private customizations live OUTSIDE the repo. Never delete or
short-circuit these hooks:

- `~/.config/local/*.local`
- `~/.config/local/*.servers.local`
- `~/.config/local/*.$HOSTNAME.local`

They are sourced at the end of the shell-specific entry point. Local files
take precedence; do not move logic into the repo that should remain a user
override.

### 2.12 Unset cleanup

Helper loader functions should be `unset -f`'d at the end of their sourcing
entry point so they do not pollute the interactive shell's function
namespace. If you add a one-shot helper, `unset -f` it in the same block.

### 2.13 Commit message style

Existing commits follow an emoji + short-phrase pattern, e.g.:

- `🚀 Version Bump: YYYYMMDDHHMM-git 🚀`
- `🗃️ Update codebase 🗃️`
- `🛠️ Standardize bin scripts to self-contained pattern 🛠️`

Match the style only when the user asks for emoji commits. Otherwise write a
plain, descriptive message into `.git/COMMIT_MESS` (see Hard Rule 4).

### 2.14 Licensing & attribution

- License: WTFPL (per `install.sh` header).
- Author/Contact in new-file headers: `Jason Hempstead` /
  `jason@casjaysdev.pro` / `CasjaysDev` — unless the user tells you
  otherwise.

---

## 3. Full Project Specification

### 3.1 What this project is

`dfmgr/misc` is a dotfiles-manager-packaged collection of shell-agnostic
configuration: the shared `profile` script, `shinit`, shared shell snippets
(`etc/shell/{aliases,exports,functions,other}`), application rc files
(`curlrc`, `wgetrc`, `gntrc`, `inputrc`, `rpmmacros`, `myclirc`, `libao`,
`dircolors`), X11 resources (`Xresources`, `xinitrc`, `xprofile`,
`xsessionrc`, `xserverrc`, `xscreensaver`), a bin directory of utility
scripts, and bash-completion files for those scripts.

Upstream: `https://github.com/dfmgr/misc`
Install prefix: `dfmgr` (install.sh: `SCRIPTS_PREFIX=dfmgr`).
Install target: `$HOME/.config/misc` (the `APPDIR`).
State dir: `$HOME/.local/share/CasjaysDev/dfmgr/misc` (the `INSTDIR`).
Plugin dir: `$HOME/.local/share/misc/plugins` (the `PLUGIN_DIR`).

### 3.2 Directory layout

```
.
├── AI.md                     # THIS FILE — project spec for AI assistants
├── LICENSE.md                # WTFPL license text
├── README.md                 # Human-facing documentation
├── CHANGELOG.md              # Version history
├── install.sh                # dfmgr-template installer (bash)
├── version.txt               # YYYYMMDDHHMM-git version string
├── applications/             # .desktop entries
├── bin/                      # user-installed utility scripts
├── completions/              # bash-completion files for bin/ scripts
├── man/                      # man pages for bin/ scripts
├── startup/                  # autostart entries
├── etc/
│   ├── settings/             # app-specific settings
│   └── shell/                # shell-agnostic POSIX snippets
│       ├── aliases/          # alias loaders (.load + .sh + OS-specific)
│       ├── exports/          # env-var exports (.load + .sh + OS-specific)
│       ├── functions/        # global POSIX functions
│       └── other/            # lf, ls, etc. app-specific shell bits
└── profile/                  # dotfiles installed into $HOME
    ├── profile               # sourced by bash/zsh login; POSIX sh
    ├── shinit                # $ENV for interactive sh; POSIX
    ├── config                # generic config
    ├── curlrc, wgetrc        # HTTP client config
    ├── gntrc, myclirc        # pg/app config
    ├── inputrc               # readline
    ├── libao, rpmmacros      # app-specific
    ├── dircolors             # GNU ls colors
    ├── Xresources            # X11 resources
    ├── xinitrc, xprofile     # X11 session startup
    ├── xsessionrc, xserverrc
    └── xscreensaver
```

### 3.3 Install flow

The `install.sh` is a dfmgr-template installer. It:

1. Loads the upstream `mgr-installers.bash` library (local or fetched).
2. Clones/pulls the repo into `$INSTDIR`.
3. Copies/symlinks `profile/*` into `$HOME/.<name>` (e.g. `profile` →
   `$HOME/.profile`, `Xresources` → `$HOME/.Xresources`).
4. Copies `etc/shell/*` into `$HOME/.config/misc/shell/`.
5. Copies `bin/*` into `$HOME/.local/bin/` (or a prefix-appropriate path).
6. Copies `completions/*` into `$HOME/.local/share/bash-completion/completions/`.
7. Copies `man/*` into the user man-path.
8. Copies `startup/*` into `$HOME/.config/autostart/`.

### 3.4 Shared-with-other-repos surface

The files under `etc/shell/` are sourced by all shell-specific dotfile
repos:

- `dfmgr/bash` sources them via `etc/*/…/\*.load` stubs in `etc/aliases/`,
  `etc/exports/`, etc.
- `dfmgr/zsh` sources them via its own profile loader.
- `dfmgr/fish` does NOT source them directly (incompatible syntax) — fish
  reimplements these in its own `etc/` tree.

Because of this, `etc/shell/**/*.sh` MUST stay POSIX. Regressing a file to
bash syntax will silently break zsh and sh sourcing.

### 3.5 Target platforms

- Linux (primary).
- macOS / Darwin — detected via `uname -s` in OS-variant files (`*.mac`).
- Windows under Cygwin / MINGW32 / MSYS / MINGW — detected via `uname -s`
  pattern (`*.win`).

### 3.6 External dependencies (runtime, optional)

- `curl`, `wget`, `lynx` (README install steps).
- `libao`, `python3-pip`, `python3-setuptools` (README).
- Various pip packages: `shodan`, `ytmdl`, `asciinema`, `toot`, etc.

### 3.7 Testing & validation

- Syntax: `sh -n <file>` for `.sh`, `bash -n <file>` for `.bash`.
- Style: `shellcheck --shell=sh <file>` / `shellcheck --shell=bash <file>`.
- POSIX check: `checkbashisms <file>` (if installed).
- Startup time: `time bash -i -c exit` — should stay in the few-second
  range advertised by the README.
- Manual: source `profile/profile` in a fresh `sh`, `bash -l`, and `zsh`
  and verify no warnings, errors, or unset-variable noise.

### 3.8 Out of scope

- The `mgr-installers.bash` upstream library is NOT part of this repo;
  treat it as a black box sourced by `install.sh`.
- User's local `~/.config/local/*` files are NOT part of this repo.
- Shell-specific configuration lives in `dfmgr/bash`, `dfmgr/zsh`,
  `dfmgr/fish` — do NOT add bash/zsh/fish-only features here.

---

## 4. Workflow expectations

When making changes:

1. Read the target file(s) first. Do not assume structure.
2. Keep edits minimal and consistent with existing style (headers,
   separators, loader pattern, builtin-first).
3. Validate with `sh -n` / `bash -n` and, when feasible, `shellcheck`.
4. Update `version.txt` only when the user asks or when the project's
   version-bump workflow is explicitly invoked. Format: `YYYYMMDDHHMM-git`.
5. Update `.git/COMMIT_MESS` to reflect the new working-tree state (Hard
   Rule 4). Do not create the commit unless explicitly asked.
6. If anything is ambiguous, ASK (Hard Rule 5).
