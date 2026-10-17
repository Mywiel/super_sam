extends Control


func _on_start_pressed():
	# Neue Spielrunde: Gesamtzeit zurücksetzen
	get_tree().set_meta("completed_time_ms", 0)

	# Münzergebnisse vorheriger Durchläufe entfernen
	for level_number in range(1, 5):
		var key = "level_" + str(level_number) + "_coins"

		if get_tree().has_meta(key):
			get_tree().remove_meta(key)
			
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_leaderboard_pressed():
	OS.shell_open("https://www.mywiel.de/games/super-sam/leaderboard/")
