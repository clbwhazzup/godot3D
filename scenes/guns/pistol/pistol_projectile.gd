extends Area3D

var speed = 100
var damage: float

var timer: float = 0.0
var time_limit: float = 2.0

@onready var ray: RayCast3D = $RayCast3D

func _process(delta: float) -> void:
	position += ray.transform.basis * Vector3(0, 0, -speed) * delta
	timer += delta
	if timer >= time_limit:
		get_tree().queue_delete(self)

func _on_body_entered(body: Node3D) -> void:
	if body is Zombie:
		body.damage(damage)
	else:
		get_tree().queue_delete(self)
