extends Control

@onready var results = $ResultContainer/Results
var final_coins: int = 0
var final_time_ms: int = 0


func set_results(level_coins, total_coins):
	final_coins = total_coins
	final_time_ms = int(get_tree().get_meta("completed_time_ms", 0))
	var result_text = ""

	for i in range(level_coins.size()):
		result_text += (
			"LEVEL " + str(i + 1)
			+ ":   " + str(level_coins[i])
			+ " COINS\n"
		)

	result_text += "\nTOTAL:   " + str(total_coins) + " COINS"
	
	
	var total_time_ms: int = int(
		get_tree().get_meta("completed_time_ms", 0)
	)

	var minutes: int = int(total_time_ms / 60000.0)
	var seconds: int = int(total_time_ms / 1000.0) % 60

	result_text += "\nTIME:   %02d:%02d" % [minutes, seconds]
	results.text = result_text

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")


func _on_hall_of_fame_button_pressed():
	var game_version = str(
		ProjectSettings.get_setting("application/config/version")
	)

	var url = (
		"https://www.mywiel.de/games/super-sam/leaderboard/"
		+ "?coins=" + str(final_coins)
		+ "&time_ms=" + str(final_time_ms)
		+ "&game_version=" + game_version
	)

	OS.shell_open(url)
