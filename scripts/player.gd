extends CharacterBody2D
class_name Player

@export var gravity = 400		# "export", damit man es auch im Inspector ändern kann/ jede Figur einen eigenen Wert haben kann
@export var speed = 120			# ohne "export" existiert der wert nur im Script, nicht im Inspector
@export var jump_force = 200
@export var jump_buffer_time: float = 0.12

@onready var animated_sprite = $AnimatedSprite2D

var active = true

# mobile Steuerung:
var movement_touch_index = -1
var movement_touch_start_position = Vector2.ZERO
var jump_touch_index = -1
var mobile_direction = 0.0
var jump_buffer: float = 0.0

@export var touch_deadzone = 3.5


func _physics_process(delta):
	if jump_buffer > 0:
		jump_buffer -= delta
	
	if is_on_floor() == false:					# nur fallen, wenn er in der Luft ist
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	
	var direction = 0
	
	if active == true:
		if Input.is_action_just_pressed("jump"):
			jump_buffer = jump_buffer_time
			
		if jump_buffer > 0 && is_on_floor():
			jump(jump_force)
			jump_buffer = 0
			
		direction = Input.get_axis("move_left", "move_right")
		
		if direction == 0:
			direction = mobile_direction
	
	else:
		mobile_direction = 0.0
		movement_touch_index = -1
		jump_touch_index = -1
	
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	
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
		
	
func _input(event):
	if active == false:
		return

	var half_screen = get_viewport_rect().size.x / 2

	# Finger wird aufgesetzt oder losgelassen
	if event is InputEventScreenTouch:
		if event.pressed:
			
			# Linke Hälfte = Bewegung
			if event.position.x < half_screen and movement_touch_index == -1:
				movement_touch_index = event.index
				movement_touch_start_position = event.position
			
			# Rechte Hälfte = Sprung
			elif event.position.x >= half_screen and jump_touch_index == -1:
				jump_touch_index = event.index
				jump_buffer = jump_buffer_time

		else:
			# Bewegungsfinger losgelassen
			if event.index == movement_touch_index:
				movement_touch_index = -1
				mobile_direction = 0.0

			# Sprungfinger losgelassen
			if event.index == jump_touch_index:
				jump_touch_index = -1

	# Bewegungsfinger wird nach links/rechts gezogen
	elif event is InputEventScreenDrag:
		if event.index == movement_touch_index:
			var distance = event.position.x - movement_touch_start_position.x

			if abs(distance) < touch_deadzone:
				mobile_direction = 0.0
			else:
				mobile_direction = sign(distance)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
