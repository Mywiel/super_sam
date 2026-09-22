extends Control


func set_time_label(value):
	$Time_Label.text = "TIME LEFT: " + str(value)


func set_coin_label(value):
	$Coin_Label.text = "COINS: " + str(value)
