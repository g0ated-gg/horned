extends Node2D

@onready var banana = preload("res://prototype1/banana.tscn")
@onready var borders = $Borders
@onready var shoot_timer = $ShootTimer

@export var active : bool = false :
	set(value):
		active = value
		if active:
			shoot_timer.start()
		else:
			shoot_timer.stop()

func _on_shoot_timer_timeout() -> void:
	if active:
		var b : CharacterBody2D = banana.instantiate()
		b.visible = false
		borders.add_child(b)
		var pos_variants = [
			Vector2(-192, randf_range(-192, 192)),
			Vector2(192, randf_range(-192, 192)),
			Vector2(randf_range(-192, 192), -192),
			Vector2(randf_range(-192, 192), 192)
		]
		b.position = pos_variants.pick_random()
		b.direction = b.position.direction_to(Vector2.ZERO)
		b.visible = true
