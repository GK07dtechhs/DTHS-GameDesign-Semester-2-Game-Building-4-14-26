extends Camera2D

@export var boundary_area: Area2D
@export var smoothing_speed: float = 5.0

var min_pos: Vector2
var max_pos: Vector2

func _ready():
	# Calculate camera boundaries from Area2D
	var shape = boundary_area.get_node("CollisionShape2D").shape
	var size = shape.extents * 2
	var center = boundary_area.global_position

	var viewport_size = get_viewport_rect().size
	var half_screen = viewport_size * 0.5 * zoom

	min_pos = center - size / 2 + half_screen
	max_pos = center + size / 2 - half_screen

	# Start camera at player position (clamped)
	global_position = clamp_position(get_parent().global_position)

func _process(delta):
	# Smoothly follow the player while staying inside the Area2D
	var target = clamp_position(get_parent().global_position)
	global_position = global_position.move_toward(target, smoothing_speed * delta * 100)

# Helper function to clamp a position inside boundaries
func clamp_position(pos: Vector2) -> Vector2:
	return Vector2(
		clamp(pos.x, min_pos.x, max_pos.x),
		clamp(pos.y, min_pos.y, max_pos.y)
	)
