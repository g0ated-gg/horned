class_name Player extends CharacterBody3D

@export var speed : float = 7.0
@export var look_direction: Vector3

var gun : Gun

signal dead

func die() -> void:
	Game.deaths += 1
	dead.emit()

func _ready() -> void:
	gun = $Gun
	gun.buffers = [ Projectiles.player_buffer ]

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	var related_look_direction = position - look_direction
	if position != related_look_direction:
		look_at(related_look_direction)
	move_and_slide()
	
	if Input.is_action_pressed("fire"):
		gun.fire()
