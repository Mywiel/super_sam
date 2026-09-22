extends Node2D

signal collected(value: int)

@export var value: int = 1


func _on_area_2d_body_entered(body):
	if body is Player:
		collected.emit(value)
		queue_free()
