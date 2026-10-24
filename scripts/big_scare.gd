extends CanvasLayer

@onready var face = $TextureRect
@onready var sound = $JumpScarePlayer
@onready var whisper = $WhisperPlayer
@onready var timer = $JumpScareTimer
@onready var level_music = $"../LevelMusic"

var triggered := false


func _on_big_scare_trigger_body_entered(body):
	if body is Player and not triggered:
		triggered = true

		face.visible = true
		sound.play()
		#level_music.stream.loop = false
		var tween = create_tween()
		tween.tween_property(level_music, "volume_db", -8.0, 2.0)
		tween.tween_property(level_music, "volume_db", -10.0, 2.0)
		tween.tween_property(level_music, "volume_db", -12.0, 2.0)
		tween.tween_property(level_music, "volume_db", -14.0, 2.0)
		
		whisper.play()
		timer.start()


func _on_jump_scare_timer_timeout():
	face.visible = false
