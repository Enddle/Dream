extends Node3D

func _ready():
	update_pic(randi()%11)

func _process(_delta):
	if global_position.length_squared() > 6400:
		queue_free()

func update_pic(num):
	if num >= 0 && num <= 10:
		var dir = "res://src/trees/tree" + String(num) + ".png"
		$Sprite3D.texture = load(dir)
	$Sprite3D.flip_h = (randi()%2 == 0)
