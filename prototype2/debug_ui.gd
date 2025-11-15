extends VBoxContainer

@onready var fps: Label = $FPS
@onready var player_buffer_size: Label = $PlayerBufferSize
@onready var enemy_buffer_1_size: Label = $EnemyBuffer1Size
@onready var enemy_buffer_2_size: Label = $EnemyBuffer2Size
@onready var enemy_hp: Label = $EnemyHP
@onready var deaths: Label = $Deaths

var enemy: Enemy

func _ready() -> void:
	enemy = get_tree().get_first_node_in_group("Enemy")

func _physics_process(_delta: float) -> void:
	fps.text = "FPS: %.1f" % Engine.get_frames_per_second()
	player_buffer_size.text = "PlayerBufferSize: %d" % Projectiles.player_buffer.size()
	enemy_buffer_1_size.text = "EnemyBuffer1Size: %d" % Projectiles.enemy_buffer_1.size()
	enemy_buffer_2_size.text = "EnemyBuffer2Size: %d" % Projectiles.enemy_buffer_2.size()
	enemy_hp.text = "EnemyHP: %d" % (enemy.hp if enemy else 0)
	deaths.text = "Deaths: %d" % Game.deaths
