extends CharacterBody2D

const SPEED = 20

var direction = 1
var touchedPlayer = false
var dropped = false

@onready var Left = $RayLeft
@onready var Right = $RayRight
@onready var Sprite = $AnimatedSprite2D
@onready var PlayerDetection = $PlayerDetection
@onready var Collider = $Collider
@onready var DropTimer = $DropTimer

func changeColliderState(value : bool):
	Collider.disabled = value

func dropSheep():
	if touchedPlayer and not dropped:
		dropped = true
		touchedPlayer = false
		call_deferred("reparent", get_tree().current_scene)
		call_deferred("changeColliderState", false)
		DropTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if not is_on_floor() and not touchedPlayer:
		velocity += get_gravity() * delta
	
	if not touchedPlayer:
		# Direction switching
		if Right.is_colliding():
			direction = -1
			Sprite.flip_h = true
		
		if Left.is_colliding():
			direction = 1
			Sprite.flip_h = false
		
		# Horizontal movement
		velocity.x = direction * SPEED
	else:
		# When held, stop movement
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_player_detection_body_entered(body: Node2D):
	if body.name == "Player" and not touchedPlayer and not dropped:
		if body.sheepHeld == null:
			touchedPlayer = true
			body.sheepHeld = self
			call_deferred("reparent", body)
			call_deferred("changeColliderState", true)

func _on_drop_timer_timeout():
	dropped = false
