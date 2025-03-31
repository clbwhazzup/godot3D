extends Node
# Place in scene, then add 3DNode as children and move to desired 3D location

var spawn_timer = 0.0
var spawn_interval: float = 4.0
var zombie_ref: Resource = preload("res://scenes/zombie.tscn")

var intermission: bool = false
var intermission_timer: float = 0.0
var intermission_limit: float = 10.0

var round_number: int = 1
var round_zombie_limit: int = 6
var zombies_at_once_limit: int = 6
var spawned_this_round: int = 1
var killed_this_round: int = 0

@onready var all_spawners: Array[Node] = self.get_children()
@onready var zombie_manager: Node = %ZombieManager


func _process(delta: float) -> void:
	if intermission:
		if intermission_timer >= intermission_limit:
			intermission = false
			intermission = 0.0
		else:
			intermission_timer += delta

	elif not intermission:
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0
			if all_spawners.size() > 0 && zombie_manager.get_children().size() < zombies_at_once_limit && spawned_this_round < round_zombie_limit:
				spawn_random()
			elif spawned_this_round >= round_zombie_limit && killed_this_round >= spawned_this_round:
				new_round()
		else:
			spawn_timer += delta

func spawn_random() -> void:
	var spawn_location = all_spawners[randi_range(0, all_spawners.size() - 1)].transform.origin
	var new_zombie = zombie_ref.instantiate()
	zombie_manager.add_child(new_zombie)
	new_zombie.transform.origin = spawn_location
	new_zombie.following = %Player
	spawned_this_round += 1
	
func new_round():
	intermission = true
	intermission_timer = 0.0
	spawn_timer = 0.0
	spawned_this_round = 0
	killed_this_round = 0
	
	round_number += 1
	round_zombie_limit += roundi(round_zombie_limit * 0.3)
	zombies_at_once_limit += roundi(zombies_at_once_limit * 0.2)
	if spawn_interval >= 0.25:
		spawn_interval = spawn_interval * 0.95
	
	print(round_number, " ", round_zombie_limit, " ", zombies_at_once_limit, " ", spawn_interval)
