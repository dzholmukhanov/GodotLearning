extends CanvasLayer

func on_game_started():
	$TitleLabel.hide()
	$StartLabel.hide()
	$ScoreLabel.show()

func on_game_menu():
	$TitleLabel.show()
	$StartLabel.show()
	$ScoreLabel.hide()
	
func on_game_score_changed(score: int):
	$ScoreLabel.text = str(score)

func show_message(message: String):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()
	yield($MessageTimer, "timeout")
	$MessageLabel.hide()