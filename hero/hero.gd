class_name Hero extends CharacterBody3D

@export var speed : float = 7.0

var mesh : Node3D
var camera : Camera3D
var gun_left : Gun
var gun_right : Gun

var look_direction: Vector3

signal dead

func die() -> void:
	Game.deaths += 1
	dead.emit()

func _ready() -> void:
	mesh = $HeroMesh
	camera = $Camera3D
	gun_left = $HeroMesh/GunLeft
	gun_left.buffers = [ Projectiles.hero_buffer ]
	gun_right = $HeroMesh/GunRight
	gun_right.buffers = [ Projectiles.hero_buffer ]

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	var cursor_position = _get_cursor_global_position()
	if cursor_position:
		var player_direction = cursor_position - global_position
		player_direction.y = 0.0
		if player_direction.length() > 0.001:
			look_direction = player_direction.normalized()
	var related_look_direction = position - look_direction
	if position != related_look_direction:
		mesh.look_at(related_look_direction)
	move_and_slide()
	
	if Input.is_action_pressed("fire"):
		gun_left.fire()
		gun_right.fire()

func _get_cursor_global_position(ray_length: float = 1000.0) -> Variant:
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)
	var ray_end: Vector3 = ray_origin + ray_dir * ray_length

	var params := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	params.collide_with_areas = false
	params.exclude = [self.get_rid()]

	var hit := get_world_3d().direct_space_state.intersect_ray(params)
	if hit.has("position"):
		return hit.position
	return null
