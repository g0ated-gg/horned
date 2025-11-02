extends Node3D

@onready var fps = $CanvasLayer/FPS
@onready var suzie = $Suzie
@onready var animation_player = $Suzie/AnimationPlayer
@onready var happy = animation_player.get_animation("happy")
@onready var dialog = $CanvasLayer/Dialog
@onready var cage = $Cage

func _ready() -> void:
	dialog.emotion_shown.connect(_on_emotion)
	happy.loop_mode = Animation.LOOP_LINEAR
	dialog.dialog_finished.connect(func(): cage.active = true)

func _on_emotion(character_tag : String, emotion_name : String):
	match character_tag:
		"s":
			if emotion_name == "default":
				animation_player.stop()
			else:
				animation_player.play(emotion_name)

func _process(_delta: float) -> void:
	fps.text = "FPS: %.1f" % Engine.get_frames_per_second()
