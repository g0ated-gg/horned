extends VBoxContainer

@export var cameraman: Cameraman

func _on_border_reached(border: Vector2):
	if cameraman and not Settings.centering:
		cameraman.on_border_reached(border)
