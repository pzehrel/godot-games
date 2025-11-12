extends CharacterBody3D

signal hit

# 玩家每秒移动的米数。
@export var speed = 14

# 空中时的向下加速度，单位为米/秒²。
@export var fall_acceleration = 75

# 角色跳跃时施加的垂直冲量，单位为米/秒。
@export var jump_impulse = 20

# 角色在弹跳过怪物时施加的垂直冲量，单位为米/秒。
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

# 物理引擎的process
func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
		# 在3D中，XZ平面是地面。
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# 设置 basis 属性会影响节点的旋转。
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		pass
		
	# 地面速度
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# 垂直速度
	if not is_on_floor(): # 如果在空中，会向地面坠落。字面意义上的重力。
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if self.is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	
	for index in range(self.get_slide_collision_count()):
		var collision = self.get_slide_collision(index)
		
		var mob = collision.get_collider()
		if mob == null:
			continue
		
		if mob.is_in_group("mob"):
			# 判断玩家是否踩在怪物上方
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
			
	
	# 移动角色
	self.velocity = target_velocity
	self.move_and_slide();
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	self.queue_free()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
	
