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


@export var camera_sensitivity: float = 0.01
@export var movement_speed: float = 10.0

var dragging: bool = false
var drag_accum: Vector2 = Vector2.ZERO
var camera_velocity: Vector3 = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		drag_accum += event.relative

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("center"):
		Settings.centering = !Settings.centering

	var cursor_position = _get_cursor_global_position()
	if cursor_position and player:
		var player_direction = cursor_position - player.global_position
		player_direction.y = 0.0
		if player_direction.length() > 0.001:
			player.look_direction = player_direction.normalized()

	velocity = Vector3.ZERO

	if Settings.centering and player:
		global_position = _get_centered_position()
		if floor_raycast.is_colliding():
			global_position.y = floor_raycast.get_collision_point().y
		return

	if dragging and drag_accum != Vector2.ZERO:
		var move_world = (-transform.basis.x * drag_accum.x - transform.basis.z * drag_accum.y) \
			* (camera_sensitivity / max(delta, 1e-6))
		velocity.x = move_world.x
		velocity.z = move_world.z
		drag_accum = Vector2.ZERO
	elif direction != Vector2.ZERO:
		velocity.x = direction.x * speed.x
		velocity.z = direction.y * speed.y

	move_and_slide()

	if floor_raycast.is_colliding():
		global_position.y = floor_raycast.get_collision_point().y

func on_border_reached(border: Vector2) -> void:
	if dragging:
		direction = Vector2.ZERO
	else:
		direction = border

func _get_centered_position() -> Vector3:
	var xz_offset := height * tan(PI * 0.5 - camera.rotation.x)
	return Vector3(player.global_position.x, 0.0, player.global_position.z - xz_offset)

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
