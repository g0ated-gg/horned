class_name Cameraman extends CharacterBody3D

@export var player: Player
@export var speed: Vector2 = Vector2(5.0, 5.0)
@export var height: float = 6.0:
	set(value):
		height = value
		camera.position.y = height
@export var direction: Vector2 = Vector2.ZERO

@onready var camera: Camera3D = $Camera3D
@onready var floor_raycast: RayCast3D = $FloorRayCast3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var centered: bool = Input.is_action_pressed("center")
	if direction and not centered:
		velocity.x = direction.x * speed.x
		velocity.z = direction.y * speed.y
	else:
		velocity.x = move_toward(velocity.x, 0, speed.x)
		velocity.z = move_toward(velocity.z, 0, speed.y)

	var cursor_position = _get_cursor_global_position()
	if cursor_position and player:
		var player_direction = player.global_position.direction_to(cursor_position)
		player_direction.y = player.global_position.y
		player.look_direction = player_direction

	if centered:
		global_position = _get_centered_position()
		move_and_slide()
		global_position.y = floor_raycast.get_collision_point().y
	else:
		move_and_slide()

func on_border_reached(border: Vector2) -> void:
	direction = border

func _get_centered_position() -> Vector3:
	return Vector3(
		player.global_position.x,
		0.0,
		player.position.z - height * tan(camera.rotation.x)
	)

func _get_cursor_global_position(ray_length: float = 1000.0):
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_direction: Vector3 = camera.project_ray_normal(mouse_position)
	var ray_end: Vector3 = ray_origin + ray_direction * ray_length
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	)
	if result:
		return result.position
	else:
		return null
