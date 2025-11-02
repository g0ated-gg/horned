extends Control

@onready var character_name : RichTextAnimation = $Panel/VBoxContainer/Character
@onready var message : RichTextAnimation = $Panel/VBoxContainer/Message
@onready var menu : VBoxContainer = $Menu
const dialog_path : String = "res://prototype1/suzie.rk"

signal emotion_shown(character_tag, emotion_name)
signal dialog_finished

func _ready() -> void:
	Rakugo.sg_say.connect(_on_say)
	Rakugo.parser.add_regex_at_runtime("emotion", "^(.*?) emotion (.*?)$")
	Rakugo.sg_custom_regex.connect(_on_custom_regex)
	Rakugo.sg_menu.connect(_on_menu)
	Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
	Rakugo.parse_and_execute_script(dialog_path, "Main")

func _on_say(character:Dictionary, text:String):
	character_name.bbcode = character["name"]
	message.bbcode = text

func _on_custom_regex(key:String, result:RegExMatch):
	match key:
		"emotion": emotion_shown.emit(result.strings[1], result.strings[2])

func _on_menu(choices:Array):
	for i in range(choices.size()):
		var choice_button : Button = Button.new()
		choice_button.text = choices[i]
		choice_button.pressed.connect(func(): menu.visible = false; Rakugo.menu_return(i))
		menu.add_child(choice_button)
	menu.visible = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("apply") \
	and is_equal_approx(message.progress, 1.0) \
	and Rakugo.is_waiting_step():
		Rakugo.do_step()
	if Input.is_action_just_pressed("skip"):
		message.progress = 1.0

func _on_execute_script_finished(_file_name:String, _error_str:String):
	visible = false
	dialog_finished.emit()
