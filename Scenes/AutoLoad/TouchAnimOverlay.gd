extends CanvasLayer


const touch_a = preload("res://src/Touch.tscn")

var tween

func touch(pos = Vector2.ZERO):
	
	var t = touch_a.instance()
	
	t.rect_position = pos
#	t.rect_position = Vector2(2026, 1248)
	
	add_child(t)


func hold_start(pos = Vector2.ZERO):
	
	$hold.rect_position = pos
	
	if tween: tween.kill()
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($hold, "rect_scale", Vector2(.8, .8), .5)
	tween.parallel().tween_property($hold, "modulate", Color(.5, .5, .5, .5), .5)
	tween.tween_property($hold, "rect_scale", Vector2(.95, .95), 1.5)
	tween.parallel().tween_property($hold, "modulate", Color(.5, .5, .5, .3), 1.5)


func hold_end():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property($hold, "modulate", Color(.5, .5, .5, .0), .2)
	tween.parallel().tween_property($hold, "rect_scale", Vector2(.95, .95), .2)


func _ready():
	$hold.rect_scale = Vector2(.95, .95)
	$hold.modulate = Color(.5, .5, .5, .0)
