class_name Player extends CharacterBody3D

@export_range(1, 35, 1) var speed: float = 8 # m/s
@export_range(10, 400, 1) var acceleration: float = 35 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 5

@export var checkpoint: Vector3 = Vector3(0,0,0)

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var paused: = false
var air_time = 0.0

@onready var camera: Camera3D = $Camera3D
#@onready var overlay: Control = $"../TouchControls/Overlay"
@onready var character: Player = $"."
@onready var gun: StaticBody3D = $Camera3D/HandSlot/Pistol


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: #Mouse for camera
		capture_mouse()
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()

	if event is InputEventScreenDrag: #Drag for camera
		release_mouse()
		look_dir = event.relative * 0.001
		if not mouse_captured: _rotate_camera()

	if event is InputEventScreenTouch: #Touch for interact
		release_mouse()
		interact()

	if Input.is_action_just_pressed(&"exit"): 
		get_tree().quit()

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed(&"pause") && paused == false:
	#	release_mouse()
	#	paused = true
	#elif Input.is_action_just_pressed(&"pause") && paused == true:
	#	capture_mouse()
	#	paused = false
	if Input.is_action_just_pressed(&"interact"):
		interact()
		
	if Input.is_action_just_pressed(&"jump"): 
		jumping = true
		
	if Input.is_action_just_pressed(&"fire"):
		if gun:
			gun.fire()
		else:
			pass # knifing

	if mouse_captured: 
		_handle_joypad_camera_rotation(delta)

	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	
	if air_time >= 6.0:
		reset_to_checkpoint()

	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	#overlay.hide()

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	#overlay.show()

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	
	if is_on_floor():
		if air_time >= 2.0:
			reset_to_checkpoint()
		air_time = 0.0
	else:
		air_time += delta

	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() or is_on_ceiling_only() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func reset_to_checkpoint():
	character.transform.origin = checkpoint

func interact():
	pass
