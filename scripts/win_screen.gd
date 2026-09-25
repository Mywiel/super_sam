extends Control

@onready var results = $ResultContainer/Results


func set_results(level_1_coins, level_2_coins, level_3_coins, total_coins):
	results.text = (
		"LEVEL 1:   " + str(level_1_coins) + " COINS\n"
		+ "LEVEL 2:   " + str(level_2_coins) + " COINS\n"
		+ "LEVEL 3:   " + str(level_3_coins) + " COINS\n\n"
		+ "TOTAL:   " + str(total_coins) + " COINS"
	)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
