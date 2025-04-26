extends Node
## Buffers just pressed inputs for a window of time.

## How long actions will be buffered for in milliseconds.
const BUFFER_WINDOW: int = 125


var key_timestamps: Dictionary[Key, int] = {}
var joy_button_timestamps: Dictionary[JoyButton, int] = {}
var mouse_button_timestamps: Dictionary[MouseButton, int] = {}


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		key_timestamps[event.physical_keycode] = Time.get_ticks_msec()
		return

	if event is InputEventJoypadButton:
		joy_button_timestamps[event.button_index] = Time.get_ticks_msec()
		return

	if event is InputEventMouseButton:
		mouse_button_timestamps[event.button_index] = Time.get_ticks_msec()
		return


## Check whether a key has been buffered.
##
## Make sure to clear a buffered key after using it with [method clear_buffered_key]
func is_key_buffered(key: Key) -> bool:
	if not key_timestamps.has(key):
		return false

	if Time.get_ticks_msec() - key_timestamps[key] > BUFFER_WINDOW:
		key_timestamps.erase(key)
		return false

	return true

## Check whether a joypad button has been buffered.
##
## Make sure to clear a buffered joypad button after using it with [method clear_buffered_joy_button]
func is_joy_button_buffered(joy_button: JoyButton) -> bool:
	if not joy_button_timestamps.has(joy_button):
		return false

	if Time.get_ticks_msec() - joy_button_timestamps[joy_button] > BUFFER_WINDOW:
		joy_button_timestamps.erase(joy_button)
		return false

	return true

## Check whether a mouse button has been buffered.
##
## Make sure to clear a buffered mouse button after using it with [method clear_buffered_mouse_button]
func is_mouse_button_buffered(mouse_button: MouseButton) -> bool:
	if not mouse_button_timestamps.has(mouse_button):
		return false

	if Time.get_ticks_msec() - mouse_button_timestamps[mouse_button] > BUFFER_WINDOW:
		mouse_button_timestamps.erase(mouse_button)
		return false

	return true

## Check whether an action has been buffered.
##
## Make sure to clear a buffered action after using it with [method clear_buffered_action]
func is_action_buffered(action: StringName) -> bool:
	if not InputMap.has_action(action):
		printerr("The InputMap does not have an action registered with the name: '%s'" % action)
		return false

	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey and is_key_buffered(event.physical_keycode):
			return true
		if event is InputEventJoypadButton and is_joy_button_buffered(event.button_index):
			return true
		if event is InputEventMouseButton and is_mouse_button_buffered(event.button_index):
			return true

	return false


## Clears a buffered key after use.
func clear_buffered_key(key: Key) -> void:
	if not key_timestamps.has(key):
		return

	key_timestamps.erase(key)

## Clears a buffered joypad button after use.
func clear_buffered_joy_button(joy_button: JoyButton) -> void:
	if not joy_button_timestamps.has(joy_button):
		return

	joy_button_timestamps.erase(joy_button)

## Clears a buffered mouse button after use.
func clear_buffered_mouse_button(mouse_button: MouseButton) -> void:
	if not mouse_button_timestamps.has(mouse_button):
		return

	mouse_button_timestamps.erase(mouse_button)

## Clears a buffered action after use.
func clear_buffered_action(action: StringName) -> void:
	if not InputMap.has_action(action):
		printerr("The InputMap does not have an action registered with the name: '%s'" % action)
		return

	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey:
			clear_buffered_key(event.physical_keycode)
		if event is InputEventJoypadButton:
			clear_buffered_joy_button(event.button_index)
		if event is InputEventMouseButton:
			clear_buffered_mouse_button(event.button_index)
