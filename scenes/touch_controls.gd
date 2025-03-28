extends AspectRatioContainer

@onready var touch_controls: AspectRatioContainer = $"."

func _ready() -> void:
	touch_controls.ratio = get_viewport_rect().size.x / get_viewport_rect().size.y
