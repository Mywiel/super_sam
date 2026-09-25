extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
