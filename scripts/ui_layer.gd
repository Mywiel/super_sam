extends CanvasLayer

func show_win_screen(
	flag: bool,
	level_1_coins: int = 0,
	level_2_coins: int = 0,
	level_3_coins: int = 0,
	total_coins: int = 0
):
	$WinScreen.visible = flag

	if flag:
		$WinScreen.set_results(
			level_1_coins,
			level_2_coins,
			level_3_coins,
			total_coins
		)
