extends Node
## Buffers just pressed inputs for a window of time.

## How long actions will be buffered for in realtime milliseconds.
const BUFFER_WINDOW: int = 150

var enabled: bool = true:
	set(value):
		if enabled and not value:
			_key_timestamps.clear()
			_joy_button_timestamps.clear()
			_mouse_button_timestamps.clear()

		enabled = value


var _key_timestamps: Dictionary[Key, int] = {}
var _joy_button_timestamps: Dictionary[JoyButton, int] = {}
var _mouse_button_timestamps: Dictionary[MouseButton, int] = {}


func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return

	if event is InputEventKey:
		if event.pressed and not event.echo:
			_key_timestamps[event.physical_keycode] = Time.get_ticks_msec()

		return

	if event is InputEventJoypadButton:
		if event.pressed:
			_joy_button_timestamps[event.button_index] = Time.get_ticks_msec()

		return

	if event is InputEventMouseButton:
		if event.pressed:
			_mouse_button_timestamps[event.button_index] = Time.get_ticks_msec()

		return


## Check whether a key has been buffered.
##
## Make sure to clear a buffered key after using it with [method clear_buffered_key]
func is_key_buffered(key: Key) -> bool:
	if not _key_timestamps.has(key):
		return false

	if Time.get_ticks_msec() - _key_timestamps[key] > BUFFER_WINDOW:
		_key_timestamps.erase(key)
		return false

	return true


## Check whether a joypad button has been buffered.
##
## Make sure to clear a buffered joypad button after using it with [method clear_buffered_joy_button]
func is_joy_button_buffered(joy_button: JoyButton) -> bool:
	if not _joy_button_timestamps.has(joy_button):
		return false

	if Time.get_ticks_msec() - _joy_button_timestamps[joy_button] > BUFFER_WINDOW:
		_joy_button_timestamps.erase(joy_button)
		return false

	return true


## Check whether a mouse button has been buffered.
##
## Make sure to clear a buffered mouse button after using it with [method clear_buffered_mouse_button]
func is_mouse_button_buffered(mouse_button: MouseButton) -> bool:
	if not _mouse_button_timestamps.has(mouse_button):
		return false

	if Time.get_ticks_msec() - _mouse_button_timestamps[mouse_button] > BUFFER_WINDOW:
		_mouse_button_timestamps.erase(mouse_button)
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
	if not _key_timestamps.has(key):
		return

	_key_timestamps.erase(key)


## Clears a buffered joypad button after use.
func clear_buffered_joy_button(joy_button: JoyButton) -> void:
	if not _joy_button_timestamps.has(joy_button):
		return

	_joy_button_timestamps.erase(joy_button)


## Clears a buffered mouse button after use.
func clear_buffered_mouse_button(mouse_button: MouseButton) -> void:
	if not _mouse_button_timestamps.has(mouse_button):
		return

	_mouse_button_timestamps.erase(mouse_button)


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

