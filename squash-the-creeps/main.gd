extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	$SpawnPath/SpawnLocation.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize($SpawnPath/SpawnLocation.position, player_position)
	
	self.add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible):
		self.get_tree().reload_current_scene()
