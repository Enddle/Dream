extends Node3D


func _ready():
	var s = randf() + 0.2
	scale = Vector3(s, s, s)
	
	var r = randi()%5
	if r == 0:
		$mesh/light.light_color = Color(1.0, randf_range(.9, .94), .65)
	elif r == 1:
		$mesh/light.light_color = Color(.65, randf_range(.9, .94), 1.0)
	
