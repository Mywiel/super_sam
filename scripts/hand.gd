extends Area2D


func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		AudioPlayerWorld.play_sfx("hurt")
		get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
