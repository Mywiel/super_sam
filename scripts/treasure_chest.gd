extends Node2D



signal coins_found(amount: int)

@export var coin_amount: int = 5

@onready var sprite = $AnimatedSprite2D
@onready var coin_popup = $CoinPopup

var opened := false
var coin_count = 0


func _on_area_2d_body_entered(body):
	if body is Player and not opened:
		opened = true

		sprite.frame = 1

		coins_found.emit(coin_amount)

		coin_popup.text = "+" + str(coin_amount) + " COINS!"
		coin_popup.visible = true
		coin_count += coin_amount

		for i in 5:
			AudioPlayerWorld.play_sfx("collected")
			await get_tree().create_timer(0.12).timeout

		await get_tree().create_timer(1.0).timeout
		coin_popup.visible = false
