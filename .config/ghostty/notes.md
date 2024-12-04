# Things that need clarification

## Add instructions for path

This will probably be fixed when a brew package is made, but it would be helpful 
to demostrate how to set ghostty into your path

```bash
# Install using instructions provided
sudo ln -s /Applications/Ghostty.app/Contents/MacOS/ghostty /opt/ghostty
export PATH="/opt:$PATH"
```

## cli actions vs keymap actions

There are actions that you can execute that are listed in `ghostty +help`. There is also 
a list of actions that you can print with `ghostty +list-actions`. The wording makes
it sound as if you can use the actions in `ghostty +list-actions` in the CLI like `reload_config`


However, that is not the case. The actions in `ghostty +list-actions` are for config file actions
like setting a keymap: 


```ini
keybind = super+shift+comma=reload_config
```

Additionally, there is a style missmatch with `list_actions` vs `reload_config` 


## Commands that require restart but not labled
title = 
window-decoration =

# bugs

## copy-on-select

I can't seem to be able to get `copy-on-select` to work on macOS unless I am using it wrong

