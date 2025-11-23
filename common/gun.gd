class_name Gun extends Node3D

@export var projectile_types: Array[PackedScene]
@export var buffers: Array[Array]
@export var order: Order = Order.DEFAULT
@export var default_offset: Vector3 = Vector3.ZERO
@export var delay: float

@onready var delay_timer: Timer = $DelayTimer

enum Order { DEFAULT, RANDOM }
var index: int = 0

func fire(
	direction: Vector3 = Vector3(0, 0, 1), 
	global_direction: bool = false,
	offset = null
) -> void:
	if not is_zero_approx(delay) and not delay_timer.is_stopped():
		return
	var user = get_parent_node_3d()
	var world = get_tree().get_first_node_in_group("World")
	var projectile: Projectile = buffers[index].pop_back()
	if not projectile:
		projectile = projectile_types[index].instantiate()
		projectile.buffer = buffers[index]
	projectile.visible = false
	world.add_child(projectile)
	projectile.global_position = user.global_position
	if global_direction:
		projectile.direction = direction
	else:
		projectile.direction = user.global_transform.basis * direction
	projectile.look_at(projectile.position + projectile.direction)
	offset = default_offset if offset == null else offset
	projectile.position += user.global_transform.basis * offset
	projectile.visible = true
	if not is_zero_approx(delay) and delay_timer.is_stopped():
		delay_timer.start(delay)

	if projectile_types.size() > 1:
		if order == Order.DEFAULT:
			index += 1
			if index == projectile_types.size():
				index = 0
		elif order == Order.RANDOM:
			index = randi_range(0, projectile_types.size()-1)
