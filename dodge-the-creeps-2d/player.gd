extends Area2D

signal hit

@export var speed = 400 # 玩家移动的速度 (像素/秒)。
var screen_size # 游戏窗口大小。

# 当节点首次进入场景树时调用。
func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size


# 每帧调用。'delta'是自上一帧以来的已用时间。
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 根据移动方向反转精灵
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		#$AnimatedSprite2D.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
