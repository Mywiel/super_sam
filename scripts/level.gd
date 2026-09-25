extends Node2D

@export var next_level: PackedScene = null
@export var level_time: int = 60
@export var is_final_level: bool = false
@export var test_mode : bool = false

@onready var test_spawn: Marker2D = $TestSpawn
@onready var start = $Start
@onready var exit = $Exit
@onready var deathzone = $Deathzone
@onready var hud = $UI_Layer/HUD
@onready var ui_layer = $UI_Layer

var player = null
var timer_node = null
var time_left: int = 0
var win = false
var coin_count: int = 0

# Test-Modus: 30 & 71 wieder ändern
func get_current_spawn_position():
	if test_mode:
		return test_spawn.global_position
	
	return start.get_spawn_position()

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		# player.global_position = start.get_spawn_position() bei Test aus
		player.global_position = get_current_spawn_position()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		# trap.connect("touched_player", _on_trap_touched_player) oder neu in Godot 4:
		trap.touched_player.connect(_on_trap_touched_player)
		
	coin_count = 0
	update_coin_label()
	connect_coins()
		
	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
	
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_deathzone_body_entered(body):	
	AudioPlayerWorld.play_sfx("hurt")		
	reset_player()		
																

func _on_trap_touched_player():
	AudioPlayerWorld.play_sfx("hurt")
	reset_player()
	
	
func reset_player():
	#player.velocity = Vector2.ZERO								# zurücksetzen
	## player.global_position = start.get_spawn_position()		(bei Test deaktiviert)
	#player.global_position = get_current_spawn_position()
	#coin_count = 0
	#update_coin_label()
	get_tree().reload_current_scene()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(2.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
			
func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			AudioPlayerWorld.play_sfx("hurt")
			reset_player()
			#time_left = level_time
			#hud.set_time_label(time_left)
	


func connect_coins():
	for coin in get_tree().get_nodes_in_group("coins"):
		if not coin.collected.is_connected(_on_coin_collected):
			coin.collected.connect(_on_coin_collected)

func _on_coin_collected(value: int):
	AudioPlayerWorld.play_sfx("collected")
	coin_count += value
	update_coin_label()

func update_coin_label():
	hud.set_coin_label(coin_count)


func _on_secret_entrance_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/dev_room.tscn")
