# Hyper Layer Architecture

Single-chord shortcuts on macOS using `right_cmd` as a Hyper key. Specifically:

- `hyper + 1..9` → switch to tmux window 1..9 (no prefix)
- `hyper + space` → tmux prefix (alongside `C-Space`)

The chord must clear three layers to reach tmux. A break in any of them kills the shortcut, so know the whole chain before debugging.

## Why this is more complicated than it should be

- **AeroSpace** owns `alt-*` and `alt-shift-*` system-wide for workspace switching. Any Hyper that contains Alt collides.
- **macOS** swallows the Cmd modifier before the terminal ever sees it.
- **Ghostty** strips Ctrl/Shift on digit keys, so `Ctrl+Shift+1` arrives as plain `1`.
- **tmux 3.6a** doesn't recognize `F13`+ as key names — `bind -n F13 …` errors with "unknown key".

The only path that survives all four is: rewrite the chord into an F-key in Karabiner, hand-roll an escape sequence in Ghostty, and consume it via `user-keys` in tmux.

## The three layers

### 1. Karabiner — variable-based hyper layer

File: `~/.config/karabiner/karabiner.json` (symlinked from `~/dotfiles/karabiner/.config/karabiner/`).

The rule is **variable-based**, not a modifier remap. The naive pattern ("right_command → Ctrl+Opt+Cmd+Shift") fires on press and consumes `right_cmd` before any digit-combo rule can match. Instead:

- `right_command` press → `set_variable hyper=1`. No `to_if_alone` — pressing right_cmd alone produces nothing.
- `right_command` release → `set_variable hyper=0`.
- Conditional rules (`variable_if hyper=1`):
  - digit `1..9` → `f13..f21`
  - `spacebar` → `Ctrl+Opt+Shift+Space` (the tmux `prefix2` chord)

Verify with **Karabiner-EventViewer**: pressing `hyper+1` should emit `f13`.

### 2. Ghostty — explicit F-key → escape sequence keybinds

File: `~/.config/ghostty/config`.

Ghostty does not emit any bytes for F13+ by default, so the keypress dies in the terminal. Add explicit keybinds:

```
keybind = f13=text:\x1b[1;2P
keybind = f14=text:\x1b[1;2Q
keybind = f15=text:\x1b[1;2R
keybind = f16=text:\x1b[1;2S
keybind = f17=text:\x1b[15;2~
keybind = f18=text:\x1b[17;2~
keybind = f19=text:\x1b[18;2~
keybind = f20=text:\x1b[19;2~
keybind = f21=text:\x1b[20;2~
```

These are standard xterm Shift+F1..Shift+F9 sequences. They match the system terminfo (`infocmp -1 | grep kf1[3-9]`), so tools that read terminfo will also recognize them.

Use the bare `fN` form. `physical:fN` did not work in testing.

Verify: `cat -v` in a Ghostty pane, press `hyper+1`, you should see `^[[1;2P`.

### 3. tmux — `user-keys` + bindings

File: `~/.config/tmux/tmux.conf`.

tmux 3.6a's key parser tops out at F12. Declare the escape sequences as user-keys and bind those:

```tmux
set -s user-keys[0] "\e[1;2P"     # F13
set -s user-keys[1] "\e[1;2Q"     # F14
set -s user-keys[2] "\e[1;2R"     # F15
set -s user-keys[3] "\e[1;2S"     # F16
set -s user-keys[4] "\e[15;2~"    # F17
set -s user-keys[5] "\e[17;2~"    # F18
set -s user-keys[6] "\e[18;2~"    # F19
set -s user-keys[7] "\e[19;2~"    # F20
set -s user-keys[8] "\e[20;2~"    # F21
bind -n User0 select-window -t :1
bind -n User1 select-window -t :2
…
bind -n User8 select-window -t :9
```

Prefix setup (separate from the layer):

```tmux
set -g prefix  C-Space
set -g prefix2 C-M-S-Space        # hyper+space, after Karabiner translation
bind C-M-S-Space send-prefix -2
```

## Debug order when a chord breaks

1. **Karabiner-EventViewer** — press the chord. Does the right output (e.g. `f13`) appear?
   - No → Karabiner rule problem. Most common cause: a different rule fired first and consumed `right_command`. Check rule order.
   - Yes → continue.

2. **`cat -v` in Ghostty** — press the chord. Does the expected escape sequence (`^[[1;2P` etc.) appear?
   - No → Ghostty keybind problem. Check that `keybind = fN=text:...` exists and reload config.
   - Yes → continue.

3. **`tmux list-keys -T root | grep User`** — confirm the `User0..User8` bindings exist. If they error on load (e.g. "unknown key: F21"), check tmux version with `tmux -V` and ensure you used `user-keys`, not `F13+` by name.

## Rollback

A pre-rewrite snapshot of the Karabiner config sits at:

```
~/dotfiles/karabiner/.config/karabiner/karabiner.json.bak-hyperdigits
```

To revert Karabiner to the simple "right_cmd → Ctrl+Opt+Cmd+Shift" modifier behavior, copy that backup back over `karabiner.json`. The Ghostty and tmux changes can stay — they'll just be no-ops if no F13+ presses arrive.

## Extending it

To add more single-chord Hyper combos:

1. Pick an unused destination key Karabiner can emit (`f22..f24`, navigation keys, etc., as long as macOS doesn't reserve it).
2. Add a Karabiner manipulator under the Hyper layer rule with the new `from`/`to`.
3. If it's an F-key past F12, add a Ghostty `keybind` to emit a unique escape sequence.
4. Add a matching `user-keys` slot and `bind -n` in tmux.

Cheap path for combos that don't need to be global: just use `prefix + key` (i.e. `hyper+space …`) instead.
