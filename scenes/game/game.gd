extends Node

var paused = false

signal pause_game

func _input(event): # when the menu action button is pressed the menu will open
	if event.is_action_pressed("pause"):
		paused = !paused
		emit_signal("pause_game", paused)

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		paused = true
		emit_signal("pause_game", paused)