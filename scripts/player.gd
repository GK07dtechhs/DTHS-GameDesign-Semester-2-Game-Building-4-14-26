extends CharacterBody2D

# Constants

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const STARTING_LIVES = 3
const STARTING_COINS = 0

# Instances

@onready var GameManager = get_tree().current_scene.get_node("LevelManager")
@onready var DestructibleTiles = %DestructibleTiles

@onready var Sprite = $AnimatedSprite2D
@onready var BufferTimer = $JumpBuffer

@onready var SwordCooldown = $SwordCooldown
@onready var SwordBuffer = $SwordBuffer
@onready var swordLeft = $SwordSwingLeft
@onready var swordRight = $SwordSwingRight

@onready var InvincibilityTimer = $InvincibilityTimer

@onready var Bomb = preload("res://scenes/bomb.tscn")
@onready var BombCooldown = $BombCooldown

# Conditionals

var swordSwinging = false
var swordEnabled = false
var placedBomb = false
var bufferEnabled = false
var facingLeft = false
var invincibility_frames = false

var destruction_mode = false # Swap modes when needed to prevent crashes

var Lives = STARTING_LIVES
var Coins = STARTING_COINS

var sheepHeld = null

func AddCoin(amount):
	Coins += amount
	GameManager.update_coins(Coins)

func ReduceLives(damage):
	if not invincibility_frames:
		invincibility_frames = true
		Lives -= damage
		
		if not sheepHeld == null:
			sheepHeld.dropSheep()
			sheepHeld = null
		
		if Lives <= 0:
			Lives = 0
			GameManager.game_over(self)
		else:
			InvincibilityTimer.start()
		GameManager.update_lives(Lives)

func _physics_process(delta: float):
	# Jumping
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if bufferEnabled and is_on_floor():
		bufferEnabled = false
		velocity.y = JUMP_VELOCITY
		
	
	if Input.is_action_just_pressed("jump"):
		bufferEnabled = true
		BufferTimer.start()
	
	# Moving directions
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		Sprite.flip_h = false
		facingLeft = false
	elif direction < 0:
		Sprite.flip_h = true
		facingLeft = true
	
	if Input.is_action_just_pressed("place_bomb") and not placedBomb and destruction_mode:
		placedBomb = true
		var newBomb = Bomb.instantiate()
		get_tree().get_current_scene().add_child(newBomb)
		
		newBomb.global_position = global_position
		newBomb.destructible_tiles = DestructibleTiles
		
		BombCooldown.start()
	
	if Input.is_action_just_pressed("swing_sword") and not swordSwinging and destruction_mode:
		$SwordSwingLeft/Collider.disabled = false
		$SwordSwingRight/Collider.disabled = false
		swordSwinging = true
		swordEnabled = true
		SwordCooldown.start()
		SwordBuffer.start()
	
	
	# Animations
	
	if swordEnabled:
		Sprite.play("swordswing")
	else:
		if is_on_floor():
			if direction == 0:
				Sprite.play("idle")
			else:
				Sprite.play("run")
		else: 
			Sprite.play("jump")
	
	# Moving directions
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Functions

func _destroy_tile():
	var tilemap = DestructibleTiles
	var hit_pos: Vector2 = global_position
	var tile_coords: Vector2i = tilemap.local_to_map(tilemap.to_local(hit_pos)) + Vector2i(0,-1)
	
	var direction = 1
	
	if facingLeft:
		direction = -1
	
	var baseTile = Vector2i(tile_coords.x + direction, tile_coords.y)
	var piercedTile = baseTile + Vector2i(direction,0)
	
	print(baseTile)
	print(piercedTile)
	
	DestructibleTiles.deleteCell(baseTile)
	DestructibleTiles.deleteCell(piercedTile)
	DestructibleTiles.deleteCell(baseTile + Vector2i(0, -1))
	DestructibleTiles.deleteCell(piercedTile + Vector2i(0, -1))

func sword_attacking(body : Node2D):
	if body.is_in_group("Destructible") or body.is_in_group("Enemy"):
			body.queue_free()

	if body == DestructibleTiles:
		_destroy_tile()


# Connections

func _on_jump_buffer_timeout():
	bufferEnabled = false

func _on_sword_cooldown_timeout():
	swordSwinging = false

func _on_invincibility_timer_timeout():
	invincibility_frames = false

func _on_sword_swing_left_body_entered(body: Node2D):
	if swordEnabled and facingLeft:
		sword_attacking(body)

func _on_sword_swing_right_body_entered(body: Node2D):
	if swordEnabled and not facingLeft:
		sword_attacking(body)

func _on_bomb_cooldown_timeout():
	placedBomb = false

func _on_sword_buffer_timeout():
	$SwordSwingLeft/Collider.disabled = true
	$SwordSwingRight/Collider.disabled = true
	swordEnabled = false
