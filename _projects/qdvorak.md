---
layout: project
title:  "QDvorak"
date:   "2021-04-30"
---

A keyboard layout for ErgoDox EZ.
Normally Dvorak, but switches to QWERTY when CTRL/CMD are held.
Keep muscle memory on those one-handed shortcuts CTRL-C/X/V.

# How it Works

This is a hardware layout for ErgoDox EZ.
Compared to software, ...
It's implemented in qmk_firmware.
There's a layer for QWERTY layout keys that gets activated on various triggers.
For CMD/CTRL, it's a temporary activation (the layer is activated only as long as the key is held).
There's also a special key to toggle the layer on/off -- useful, for example, when playing games that use a WASD layout.

# Use it

The [keymap file](https://github.com/fyhuang/qmk_firmware/tree/master/keyboards/ergodox_ez/keymaps/qdvorak) contains most of the modifications.
Note that I have the older ErgoDox EZ, without the RGB backlight.
So the keyboard state is communicated only by the 3 status LEDs on the top right.