extends "res://Scenes/Ext/Rotate3D.gd"

var presstime = 0
var isPressed = false
var scene_out = false


func _process(delta):
	if scene_out:
		return
	
	AuH._vol(AuH.BG, (cam.translation.z / 40 - .5) * -12 + 6)
	
	if isPressed:
		cam.translation.z -= 2.5 * delta
	
	if cam.translation.z < 10.0 && !scene_out:
		scene_out = true
		
		SceneHelper.fade_to_black(1.8, .5)
		AuH.vol_tween(AuH.BG, -20.0, 1.8)
		yield(get_tree().create_timer(1.8), "timeout")
		next_scene()


var touch_pos = Vector2.ZERO


func _on_Button_button_down():
#	touch_pos = get_viewport().get_mouse_position()
	isPressed = true
	presstime = OS.get_ticks_msec()
	


func _on_Button_button_up():
	isPressed = false
	var timepass = OS.get_ticks_msec() - presstime
	
	if timepass < 1000:
		TA.touch(touch_pos)
		var tween := create_tween()
		tween.tween_property(cam, "translation:z", -8.0, .7).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(cam, "translation:z", 8.0, 1.5).as_relative().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func next_scene():
	get_tree().change_scene("res://Scenes/Forest_1.tscn")
