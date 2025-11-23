extends Node

@export var hero_buffer: Array[Projectile] = []

var _hero_projectile = preload("res://hero/hero_projectile.tscn")

func  _ready() -> void:
	_make_buffer(hero_buffer, _hero_projectile, 50)

func _make_buffer(array: Array[Projectile], type: PackedScene, size: int) -> void:
	for i in range(size):
		var current: Projectile = type.instantiate()
		current.buffer = array
		array.append(current)
