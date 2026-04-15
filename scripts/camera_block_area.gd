extends Area2D

@export var push_offset_y: float = -200.0  # Negative = push camera up

var camera_target: Node2D
var original_offset_y: float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		camera_target = body.get_node("CameraTarget")
		original_offset_y = camera_target.position.y
		camera_target.position.y += push_offset_y

func _on_body_exited(body: Node) -> void:
	if body.name == "Player" and camera_target:
		camera_target.position.y = original_offset_y
