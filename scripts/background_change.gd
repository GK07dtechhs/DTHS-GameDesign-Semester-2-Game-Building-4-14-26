extends Area2D

# Path to your background node
@export var sky_background_path: NodePath
@export var fade_duration: float = 1.0

# Light node paths
@export var light_start_path: NodePath
@export var light_middle_path: NodePath
@export var light_end_path: NodePath
@export var light_end2_path: NodePath

# Blue color
@export var enter_light_color: Color = Color(0.3, 0.6, 1.0)

var sky_background: Node = null

var light_start: PointLight2D
var light_middle: PointLight2D
var light_end: PointLight2D
var light_end2: PointLight2D

var triggered: bool = false  # prevents re-triggering (optional but clean)

func _ready() -> void:
	# Background
	if sky_background_path:
		sky_background = get_node(sky_background_path)
	else:
		push_error("sky_background_path not assigned!")
	
	# Lights
	light_start = get_node_or_null(light_start_path)
	light_middle = get_node_or_null(light_middle_path)
	light_end = get_node_or_null(light_end_path)
	light_end2 = get_node_or_null(light_end2_path)

	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if triggered:
		return
		
	if body.is_in_group("player") or body is CharacterBody2D:
		triggered = true
		_fade_background(0.0)
		_change_lights(enter_light_color) # stays blue permanently

func _fade_background(to_alpha: float) -> void:
	if sky_background:
		var tween = get_tree().create_tween()
		tween.tween_property(
			sky_background,
			"modulate:a",
			to_alpha,
			fade_duration
		)

func _change_lights(target_color: Color) -> void:
	var lights = [light_start, light_middle, light_end, light_end2]
	
	for light in lights:
		if light:
			var tween = get_tree().create_tween()
			tween.tween_property(
				light,
				"color",
				target_color,
				fade_duration
			)
