class_name EnemyCore extends Enemy

@onready var hero: Hero = get_tree().get_first_node_in_group("Hero")
@onready var gun: Gun = $Gun

func _ready() -> void:
	gun.buffers = [ Projectiles.enemy_buffer_1, Projectiles.enemy_buffer_2 ]

func _physics_process(_delta: float) -> void:
	gun.fire(global_position.direction_to(hero.global_position), true)

func _on_dead() -> void:
	queue_free()
