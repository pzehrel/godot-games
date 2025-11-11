extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_message(text: String):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	# 等待 MessageTimer 倒计时结束。
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# 创建一个单次定时器并等待它完成。
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score: int): 
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	

func _on_message_timer_timeout() -> void:
	$Message.hide()
