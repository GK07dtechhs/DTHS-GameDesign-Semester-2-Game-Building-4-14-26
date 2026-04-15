extends CharacterBody2D

const SPEED = 90
const GRAVITY = 900  # adjust based on your game feel

var direction = 1

@onready var Left = $RayCastLeft
@onready var Right = $RayCastRight
@onready var Sprite = $AnimatedSprite2D

func _physics_process(delta: float):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	# Horizontal movement
	velocity.x = direction * SPEED

	# Move first
	move_and_slide()

	# Turn around if we hit a wall
	if is_on_wall():
		direction *= -1
		Sprite.flip_h = direction < 0

	# Optional: still keep raycasts for edge detection
	if Right.is_colliding():
		direction = -1
		Sprite.flip_h = true
		
	if Left.is_colliding():
		direction = 1
		Sprite.flip_h = false
