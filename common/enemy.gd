class_name Enemy extends CharacterBody3D

@export var hp: int:
	set(value):
		var old_value = hp
		hp = 0 if value <= 0 else value
		if hp != old_value:
			hp_changed.emit()
			if hp == 0:
				dead.emit()

signal hp_changed
signal dead
