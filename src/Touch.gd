extends Control


const scale = Vector2(.8, .8)
const trans = .5
const delay = .2


func _ready():
	rect_scale = scale
	
	$in.modulate = Color(.5, .5, .5, trans)
	$out.modulate = Color(.5, .5, .5, .0)
	
	var tween := create_tween()
	tween.tween_property($in, "modulate:a", .0, .2)
	tween.parallel().tween_property($out, "modulate:a", trans, .2)
	tween.tween_property($out, "modulate:a", .0, .2)
	tween.tween_callback(self, "remove")


func remove():
	queue_free()
