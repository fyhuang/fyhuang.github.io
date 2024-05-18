---
layout: project
title:  "QDvorak"
date:   "2021-04-30"
---

A keyboard layout for ErgoDox EZ.
Normally Dvorak, but switches to QWERTY when CTRL/CMD are held.
Keep muscle memory and use one hand for shortcuts like CTRL-C/X/V.

# How it Started

This layout is inspired by the "Dvorak-Qwerty &#x2318;" layout from Mac OSX.
I used that layout for a while, but found that it had some issues.
Some software (at the time, IntelliJ) used low-level ways to access the keyboard, and messed up the layout.
Also, the layout only worked on OSX.

I wanted a similar layout that worked no matter the OS and software.
So I tried implementing it as a hardware layout for [ErgoDox EZ](https://ergodox-ez.com/).

# How it Works

QDvorak is implemented as a layout in qmk_firmware.
The [keymap file](https://github.com/fyhuang/qmk_firmware/tree/master/keyboards/ergodox_ez/keymaps/qdvorak) contains most of the modifications.

On top of a base Dvorak layer, there's a `QWRT` layer for QWERTY keys that gets activated on various triggers.

* CMD/CTRL activate the layer temporarily.
  The layer is activated only as long as the key is held.
  Once CMD/CTRL are released, the keyboard reverts to Dvorak layout.
* The top left index key toggles the layer on/off -- useful, for example, when playing games that use a WASD layout.

## Layering and CMD/CTRL handling

```c
#define BASE 0 // base layer == dvorak
#define QWRT 1 // qwerty
#define SYMB 2 // symbols
```

In a previous version, I had problems with the `QWRT` layer getting stuck in a bad interaction with the symbols layer, which I think was due to suboptimal layer ordering.

The keymap replaces the standard CTRL and CMD keycodes with custom keycodes (`CTRL_Q` and `CMD_Q` in the code).
`process_record_user` implements the behavior of the custom keycodes:

```c
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case CTRL_Q:
      if (record->event.pressed) {
          register_code(KC_LCTL);
          layer_on(QWRT);
      }
      else {
          layer_off(QWRT);
          unregister_code(KC_LCTL);
      }
      return false;

    case CMD_Q:
      if (record->event.pressed) {
          register_code(KC_LGUI);
          layer_on(QWRT);
      }
      else {
          layer_off(QWRT);
          unregister_code(KC_LGUI);
      }
      return false;
  }

  return true;
}
```

## Layer state LEDs

The keymap uses the blue and green LEDs on the ErgoDox EZ to indicate when the `QWRT` and `SYMB` layers are enabled.
This is done in the `layer_state_set_user` function, which is called by QMK whenever the layer state changes:

```c
layer_state_t layer_state_set_user(layer_state_t layer_state) {
  ergodox_board_led_off();
  ergodox_right_led_2_off();
  ergodox_right_led_3_off();

  if (layer_state & (1<<QWRT)) {
      ergodox_right_led_3_on();
  }

  if (layer_state & (1<<SYMB)) {
      ergodox_right_led_2_on();
  }

  return layer_state;
};
```

Note that I have the older ErgoDox EZ, without the RGB backlight.
So the keyboard state is communicated only by the 3 status LEDs on the top right.

## Caps lock

Unlike the standard ErgoDox EZ layout, I chose to add a caps lock key, which I use when typing all-caps names in code (e.g. `QMK_KEYBOARD_H`).
The keymap uses the red LED to indicate the caps lock state.
`led_set_user` is the function that QMK will call to indicate a change to the "keyboard LEDs" (i.e. num lock, caps lock, scroll lock) state:

```c
void led_set_user(uint8_t usb_led) {
    if (usb_led & (1<<USB_LED_CAPS_LOCK)) {
        ergodox_right_led_1_on();
    } else {
        ergodox_right_led_1_off();
    }
}
```

## Custom configuration

Custom configuration parameters can be set in a `config.h` file [in the same directory as the keymap](https://github.com/fyhuang/qmk_firmware/blob/master/keyboards/ergodox_ez/keymaps/qdvorak/config.h).
The keymap only changes one parameter, `TAPPING_TOGGLE`, which sets the behavior of `TT()` keys:

```c
#undef  TAPPING_TOGGLE
#define TAPPING_TOGGLE 2
```