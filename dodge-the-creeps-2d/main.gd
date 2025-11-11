extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	

func _on_mob_timer_timeout() -> void:
	# 创建怪物
	var mob = mob_scene.instantiate()
	
	# 在 Path2D 上选择一个随机位置。
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# 设置怪物位置
	mob.position = mob_spawn_location.position
	
	# 将生物的朝向设置为与路径方向垂直。
	var direction = mob_spawn_location.rotation + PI / 2
	
	# 给方向增加一些随机性。
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# 选择生物的速度。
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
