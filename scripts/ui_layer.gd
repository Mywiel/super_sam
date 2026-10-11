extends CanvasLayer

func show_win_screen(
	flag: bool,
	level_coins: Array = [],
	total_coins: int = 0
):
	$WinScreen.visible = flag

	if flag:
		$WinScreen.set_results(level_coins, total_coins)
