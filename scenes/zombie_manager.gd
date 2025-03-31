extends Node


var follow_update = 0.0

@onready var all_zombies: Array[Node] = self.get_children()
@onready var character: Player = %Player
@onready var spawner_manager: Node = %SpawnerManager


func _process(delta: float) -> void:
	if follow_update >= 0.5:
		follow_update = 0.0
		if all_zombies.size() > 0:
			call_deferred("closest_zombie")
	else:
		follow_update += delta

func _on_child_entered_tree(node: Node) -> void:
	if all_zombies:
		if node not in all_zombies:
			all_zombies.append(node)
		

func _on_child_exiting_tree(node: Node) -> void:
	all_zombies.erase(node)
	spawner_manager.killed_this_round += 1
	pass # Replace with function body.
	

func closest_zombie() -> void:
	var d: float = 5000
	var z: Node
	for zombie in all_zombies:
		if zombie.transform.origin.distance_to(character.transform.origin) < d:
			d = zombie.transform.origin.distance_to(character.transform.origin)
			z = zombie
	for zombie in all_zombies:
		if not zombie == z:
			zombie.following = z
		else:
			zombie.following = character
