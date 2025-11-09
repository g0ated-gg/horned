extends VBoxContainer

@export var cameraman: Cameraman

func _on_border_reached(border: Vector2):
	if cameraman:
		cameraman.on_border_reached(border)
