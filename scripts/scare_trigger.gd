extends Area2D

@onready var auge = $Auge
@onready var scare_timer = $ScareTimer

var triggered := false


func _on_body_entered(body):
	if body is Player and not triggered:
		triggered = true
		
		auge.visible = true
		AudioPlayerWorld.play_sfx("wilhelm")
		
		scare_timer.start()


func _on_scare_timer_timeout():
	auge.visible = false
