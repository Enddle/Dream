extends Node


const info_w = preload("res://src/info_w.png")
const info_b = preload("res://src/info_b.png")


var showing = false
var tween

#var next_hint = ""
#var next_black = false


func show_hint(text, black, cover = true):
	if tween:
		if cover: tween.kill()
		else: return
	tween = create_tween()
	
	if showing:
		tween.tween_property($Label, "modulate:a", 0.0, .5)
		tween.parallel().tween_property($TextureRect, "modulate:a", 0.0, .5)
	
	showing = true
	
	tween.tween_callback(self, "reset_hint", [text, black])
	
	tween.tween_property($TextureRect, "modulate:a", 1.0, 1.0).set_delay(.5)
	tween.parallel().tween_property($Label, "modulate:a", 1.0, 1.0).set_delay(.7)
	
	tween.tween_property($Label, "modulate:a", 0.0, .5).set_delay(5.0)
	tween.parallel().tween_property($TextureRect, "modulate:a", 0.0, .5).set_delay(5.15)
	tween.tween_callback(self, "show_ended")


func reset_hint(text, black):
	$TextureRect.texture = info_b if black else info_w
	$Label.modulate = Color.black if black else Color.white
	$TextureRect.modulate.a = 0.0
	$Label.modulate.a = 0.0
#	print(text)
	$Label.text = text


func show_ended():
	showing = false


func _on_icon_pressed():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property($Label, "modulate:a", 0.0, .5)
	tween.parallel().tween_property($TextureRect, "modulate:a", 0.0, .5)
	tween.tween_callback(self, "show_ended")
