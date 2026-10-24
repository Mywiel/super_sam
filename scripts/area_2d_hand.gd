extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("HAND KONTAKT: ", body)

	if body is Player:
		AudioPlayerWorld.play_sfx("wilhelm")
		get_tree().reload_current_scene()
