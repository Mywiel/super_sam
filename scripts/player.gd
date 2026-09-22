extends CharacterBody2D
class_name Player

@export var gravity = 400		# "export", damit man es auch im Inspector ändern kann/ jede Figur einen eigenen Wert haben kann
@export var speed = 120			# ohne "export" existiert der wert nur im Script, nicht im Inspector
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D

var active = true

#func _process(delta):
	#if Input.is_action_just_pressed("move_right"):
		#animated_sprite.play("run")

func _physics_process(delta):
	if is_on_floor() == false:					#(nur fallen, wenn er in der Luft ist)
		velocity.y += gravity * delta
		#print (velocity.y)
		if velocity.y > 500:				# wenn zu schnell? damit er nicht ewig fällt?
			velocity.y = 500				# bleibt dann wohl bei 500 stehen
	
	var direction = 0
	
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
			
		direction = Input.get_axis("move_left", "move_right")	# 1. argument is pressed: negative 1 oder 2. argument: positive 1 und zero, wenn beide oder keiner pressed
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)			# h = horizontal
	
	
	
	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)
	
	
func jump(force):
	AudioPlayerWorld.play_sfx("jump")
	velocity.y = -force
	

	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
