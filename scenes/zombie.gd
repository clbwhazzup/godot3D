class_name Zombie extends CharacterBody3D

@export_range(1, 35, 1) var speed: float = 2 # m/s
@export var jump_velocity = 200
@onready var following: CharacterBody3D = %Player
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var stuck_tolerance: float = 0.2
var jump_height: float = 3
var stuck_timer: float = 0.0
var jump_length: float = 0.0
var jumping: bool = false
var health: float = 100
func _physics_process(delta: float) -> void:
	if following:
		navigation_agent.target_position = following.transform.origin
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = self.transform.origin.direction_to(next_path_position) * speed
	# Add the gravity.
	if not is_on_floor():
		new_velocity += get_gravity() * delta
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func damage(d: float) -> void:
	health = health - d
	if health <= 0.0:
		get_tree().queue_delete(self)
