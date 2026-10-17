extends Node2D

@export var next_level: PackedScene = null
@export var level_time: int = 60
@export var is_final_level: bool = false
@export var test_mode : bool = false
@export var level_number: int
@export var bounce_force: float = 450.0

@onready var test_spawn: Marker2D = $TestSpawn
@onready var start = $Start
@onready var exit = $Exit
@onready var deathzone = $Deathzone
@onready var hud = $UI_Layer/HUD
@onready var ui_layer = $UI_Layer
@onready var doggo = get_node_or_null("Doggo")
@onready var treat_dialog = get_node_or_null("TreatDialog")
@onready var music = $LevelMusic
@onready var level_result_label = $UI_Layer/LevelResultLabel
#@onready var pause_button = $UI_Layer/PauseButton

var player = null
var timer_node = null
var time_left: int = 0
var win = false
var coin_count: int = 0
var level_elapsed_seconds: float = 0.0

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
		
	if treat_dialog:
		treat_dialog.visible = false
		
	coin_count = 0
	if get_tree().has_meta("return_coin_count"):
		coin_count = get_tree().get_meta("return_coin_count")
		update_coin_label()
		get_tree().remove_meta("return_coin_count")
	
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
	if not get_tree().paused and not win:
		level_elapsed_seconds += delta
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
	## player.global_position = start.get_spawn_position()		(bei Test deaktiviert)
	
	get_tree().reload_current_scene()

			
func _on_exit_body_entered(body):
	if body is Player and not win:
		# Ergebnis dieses Levels speichern
		get_tree().set_meta(
			"level_" + str(level_number) + "_coins",
			coin_count
		)
		
		# Zeit dieses erfolgreich abgeschlossenen Levels addieren
		var completed_time_ms = int(
			get_tree().get_meta("completed_time_ms", 0)
		)

		completed_time_ms += roundi(
			level_elapsed_seconds * 1000.0
		)

		get_tree().set_meta(
			"completed_time_ms",
			completed_time_ms
		)


		# Level sofort wirklich beenden
		exit.animate()
		player.active = false
		player.velocity.x = 0
		win = true

		# Einzel-Ergebnis anzeigen
		level_result_label.text = "LEVEL COMPLETE!\nCOINS: " + str(coin_count)
		level_result_label.visible = true

		await get_tree().create_timer(2.5).timeout

		if is_final_level:
			level_result_label.visible = false

			var level_coins = []
			var total_coins = 0

			for i in range(1, level_number + 1):
				var coins = get_tree().get_meta(
					"level_" + str(i) + "_coins",
					0
				)

				level_coins.append(coins)
				total_coins += coins

			ui_layer.show_win_screen(
				true,
				level_coins,
				total_coins
			)

		elif next_level != null:
			get_tree().change_scene_to_packed(next_level)
			
			
			
func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left == 10:
			music.pitch_scale = 1.10
			
		if time_left < 0:
			AudioPlayerWorld.play_sfx("hurt")
			reset_player()
	
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

# Dev Room:
func _on_secret_entrance_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/dev_room.tscn")

# Feuer:
func _on_area_2d_body_entered(body):
	if body is Player:
		AudioPlayerWorld.play_sfx("wilhelm")
		body.velocity.y = -bounce_force
# Hund:
func _on_doggo_treat_requested():
	player.active = false
	player.velocity.x = 0

	doggo.react_to_question()
	await get_tree().create_timer(0.5).timeout
	treat_dialog.visible = true
	treat_dialog.show()
	
func _on_yes_button_pressed():
	treat_dialog.visible = false
	
	if doggo.fed:
		player.active = true
		return
		
	doggo.give_treat()
	coin_count+=3
	update_coin_label()
	for i in 3:
		AudioPlayerWorld.play_sfx("collected")
		await get_tree().create_timer(0.12).timeout
	player.active = true
	
func _on_no_button_pressed():
	treat_dialog.visible = false
	doggo.cancel_question()
	player.active = true
		
func _on_treasure_chest_coins_found(amount):
	coin_count += amount
	update_coin_label()
