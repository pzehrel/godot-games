extends CharacterBody3D

signal squashed

# 最小移动速度
@export var min_speed = 10
# 最大移动速度
@export var max_speed = 18

func _physics_process(delta: float) -> void:
	self.move_and_slide()
	
func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# 我们通过将怪物放置在 start_position 来定位它
	# 并将其旋转朝向 player_position，使其看向玩家。
	self.look_at_from_position(start_position, player_position, Vector3.UP)
	
	# 在-45到+45度范围内随机旋转这个生物，
	# 以免它直接朝着玩家移动。
	self.rotate_y(randf_range(-PI / 4, PI / 4))
	
	# 我们计算一个随机速度（整数）
	var random_speed = randi_range(min_speed, max_speed)
	
	# 我们计算一个代表速度的前向速度。
	self.velocity = Vector3.FORWARD * random_speed
	
	# 然后我们根据生物的 Y 轴旋转来旋转速度向量
	# 以便朝着生物所看的方向移动。
	self.velocity = velocity.rotated(Vector3.UP, self.rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed


func squash() -> void:
	squashed.emit()
	self.queue_free()

# 离开屏幕释放对象
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	self.queue_free()
