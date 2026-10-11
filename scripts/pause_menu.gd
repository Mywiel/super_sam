extends Control

func toggle_pause():
	var paused = not get_tree().paused
	get_tree().paused = paused
	visible = paused


func _on_pause_button_pressed():
	toggle_pause()
