extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var blink_timer = $BlinkTimer

signal treat_requested

var busy := false
var fed := false


func _ready():
	randomize()
	go_idle()
	start_blink_timer()


func start_blink_timer():
	blink_timer.wait_time = randf_range(3.0, 8.0)
	blink_timer.start()


func _on_blink_timer_timeout():
	if not busy:
		busy = true
		
		sprite.play("blink")
		await sprite.animation_finished
		
		go_idle()
		busy = false

	start_blink_timer()


func react_to_question():
	busy = true
	blink_timer.stop()

	sprite.play("ears")
	await sprite.animation_finished
	
	# bleibt auf dem letzten Ears-Frame stehen


func give_treat():
	if fed:
		return
		
	fed = true
	busy = true
	blink_timer.stop()

	sprite.play("wag")
	await sprite.animation_finished

	go_idle()
	busy = false
	start_blink_timer()


func cancel_question():
	go_idle()
	busy = false
	start_blink_timer()


func go_idle():
	sprite.stop()
	sprite.animation = "blink"
	sprite.frame = 0
	
func _on_area_2d_body_entered(body):
	if body is Player and not fed:
		treat_requested.emit()
