extends CharacterBody2D

@export var direction : Vector2 = Vector2.ONE

const SPEED = 200.0

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(direction * SPEED * delta)
	if collision: 
		if collision.get_collider() is Puppy:
			collision.get_collider().damage()
		elif collision.get_collider() is StaticBody2D:
			queue_free()
