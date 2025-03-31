extends StaticBody3D
var damage: float = 50.0
var projectile_ref: Resource = preload("res://scenes/guns/pistol/pistol_projectile.tscn")
@onready var level: Node = $"."
@onready var ray: RayCast3D = $RayCast3D

func fire() -> void:
	var new_projectile = projectile_ref.instantiate()
	level.add_child(new_projectile)
	new_projectile.damage = damage
	new_projectile.transform = ray.transform
