extends Control

@onready var results = $ResultContainer/Results


func set_results(level_coins, total_coins):
	var result_text = ""

	for i in range(level_coins.size()):
		result_text += (
			"LEVEL " + str(i + 1)
			+ ":   " + str(level_coins[i])
			+ " COINS\n"
		)

	result_text += "\nTOTAL:   " + str(total_coins) + " COINS"

	results.text = result_text

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
