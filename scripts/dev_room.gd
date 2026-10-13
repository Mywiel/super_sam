extends Node2D

@export var coin_scene: PackedScene

@onready var computer_screen = $UI_Layer/ComputerScreen
@onready var computer_hotspot = $MueScene/ComputerHotspot
@onready var player = $Player
@onready var click_hint = $UI_Layer/ClickHint

@onready var tea_message = $UI_Layer/TeaMessage
@onready var stormtrooper_message = $UI_Layer/StormtrooperMessage
@onready var ideas_message = $UI_Layer/IdeasMessage

@onready var tea_hotspot = $MueScene/TeaHotspot
@onready var stormtrooper_hotspot = $StormtrooperHotspot
@onready var ideas_hotspot = $IdeasHotspot
@onready var vent_coin_spawn = $VentCoinSpawn
@onready var vent_coin_revealed := false

var custom_cursor = load("res://assets/textures/cursor_hand.png")


func _ready():
	computer_screen.visible = false
	tea_message.visible = false
	stormtrooper_message.visible = false
	ideas_message.visible = false
	
	computer_hotspot.input_event.connect(_on_computer_hotspot_input_event)
	tea_hotspot.input_event.connect(_on_tea_hotspot_input_event)
	stormtrooper_hotspot.input_event.connect(_on_stormtrooper_hotspot_input_event)
	ideas_hotspot.input_event.connect(_on_ideas_hotspot_input_event)
	
	computer_hotspot.mouse_entered.connect(_on_hotspot_mouse_entered)
	computer_hotspot.mouse_exited.connect(_on_hotspot_mouse_exited)

	tea_hotspot.mouse_entered.connect(_on_hotspot_mouse_entered)
	tea_hotspot.mouse_exited.connect(_on_hotspot_mouse_exited)

	stormtrooper_hotspot.mouse_entered.connect(_on_hotspot_mouse_entered)
	stormtrooper_hotspot.mouse_exited.connect(_on_hotspot_mouse_exited)

	ideas_hotspot.mouse_entered.connect(_on_hotspot_mouse_entered)
	ideas_hotspot.mouse_exited.connect(_on_hotspot_mouse_exited)


func _on_computer_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false
		
		tea_message.visible = false
		stormtrooper_message.visible = false
		ideas_message.visible = false
		computer_screen.visible = true
		
func _on_tea_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false

		computer_screen.visible = false
		stormtrooper_message.visible = false
		ideas_message.visible = false
		tea_message.visible = true
		
func _on_stormtrooper_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false

		computer_screen.visible = false
		tea_message.visible = false
		ideas_message.visible = false
		stormtrooper_message.visible = true

		
func _on_ideas_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false

		computer_screen.visible = false
		tea_message.visible = false
		stormtrooper_message.visible = false
		ideas_message.visible = true
		
func _unhandled_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:

		computer_screen.visible = false
		tea_message.visible = false
		stormtrooper_message.visible = false
		ideas_message.visible = false

		player.active = true


func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")

func _on_hint_timer_timeout():
	click_hint.visible = false
	

func _on_hotspot_mouse_entered():
	Input.set_custom_mouse_cursor(
		custom_cursor,
		Input.CURSOR_ARROW,
		Vector2(4, 2)
	)

func _on_hotspot_mouse_exited():
	Input.set_custom_mouse_cursor(null)


func _on_vent_secret_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and not vent_coin_revealed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		vent_coin_revealed = true

		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.collected.connect(_on_vent_coin_collected)
		coin.global_position = vent_coin_spawn.global_position
		
func _on_vent_coin_collected(value: int):
	var current_coins = get_tree().get_meta("return_coin_count", 0)
	get_tree().set_meta("return_coin_count", current_coins + value)

	AudioPlayerWorld.play_sfx("collected")


func _on_lvl_4_hotspot_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")
