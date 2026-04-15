extends StaticBody2D

@onready var Sprite = $LadderSprite
@onready var Step2 = $Step2
@onready var Step3 = $Step3

func OnBuild():
	Step2.set_deferred("disabled", false)
	Step3.set_deferred("disabled", false)
	Sprite.position = Vector2i(0,0)
	Sprite.region_rect = Rect2i(193,16,16,48)

func _ready():
	var Unbuilt = get_meta("Unbuilt")
	if Unbuilt == true:
		Sprite.position = Vector2i(0, 16)
		Sprite.region_rect = Rect2i(193,48,16,16)
		Step2.disabled = true
		Step3.disabled = true
