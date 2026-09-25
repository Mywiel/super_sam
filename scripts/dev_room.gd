extends Node2D

@onready var computer_screen = $UI_Layer/ComputerScreen
@onready var computer_hotspot = $MueScene/ComputerHotspot
@onready var player = $Player
@onready var small_message = $UI_Layer/SmallMessage
@onready var small_message_text = $UI_Layer/SmallMessage/Text

@onready var tea_hotspot = $MueScene/TeaHotspot
@onready var stormtrooper_hotspot = $StormtrooperHotspot
@onready var ideas_hotspot = $IdeasHotspot


func _ready():
	computer_hotspot.input_event.connect(_on_computer_hotspot_input_event)
	tea_hotspot.input_event.connect(_on_tea_hotspot_input_event)
	stormtrooper_hotspot.input_event.connect(_on_stormtrooper_hotspot_input_event)
	ideas_hotspot.input_event.connect(_on_ideas_hotspot_input_event)


func _on_computer_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false
		computer_screen.visible = true
		
func _on_tea_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false
		small_message.visible = false
		computer_screen.visible = false

		small_message_text.text = "TEA LEVEL:\nCRITICAL"
		small_message.position = Vector2(110, 120)
		small_message.visible = true
		
func _on_stormtrooper_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false
		computer_screen.visible = false

		small_message_text.text = "THE EMPIRE STRIKES BACK\nIS THE BEST STAR WARS MOVIE."
		small_message.position = Vector2(290, 75)
		small_message.visible = true
		
func _on_ideas_hotspot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		viewport.set_input_as_handled()
		player.jump_buffer = 0.0
		player.active = false
		computer_screen.visible = false

		small_message_text.text = "TOP SECRET\nCONFIDENTIAL"
		small_message.position = Vector2(285, 170)
		small_message.visible = true
		
func _unhandled_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:

		computer_screen.visible = false
		small_message.visible = false
		player.active = true
