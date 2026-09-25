extends Node2D

@onready var fart_player = $FartPlayer
@onready var fart_timer = $FartTimer

func _ready():
	start_fart_timer()

func start_fart_timer():
	fart_timer.wait_time = randf_range(15.0, 40.0)
	fart_timer.start()

func _on_fart_timer_timeout():
	fart_player.play()
	start_fart_timer()
