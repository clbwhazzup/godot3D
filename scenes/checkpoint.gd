extends Area3D

@onready var character: Player = %Player

func _on_body_entered(body: Node3D) -> void:
	if (body == character):
		body.checkpoint = self.transform.origin
