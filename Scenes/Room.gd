extends "res://Scenes/Ext/Rotate3D.gd"

var isPressed = false
var scene_out = false


func _ready():
	Connect.sendudp("1")
	
	if SceneHelper.isSpaces:
		$exit.visible = true


func _process(delta):
	if scene_out:
		return
	
	AuH._vol(AuH.BG, (cam.position.z / 40 - .5) * -12 + 6)
	
	Connect.sendextra(cam.position.z / 40 - .5)
	
	if isPressed:
		cam.position.z -= 2.5 * delta
	
	if cam.position.z < 10.0 && !scene_out:
		next_scene()


var touch_pos = Vector2.ZERO
var holdTiming = false

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		print("Mouse Click at: ", event.position)
		
		isPressed = true
		holdTiming = true
		touch_pos = event.position
		$touch_hold_timer.start()

	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		
		isPressed = false

		if holdTiming:
			TA.touch(event.position)
			
			var tween := create_tween()
			tween.tween_property(cam, "position:z", -8.0, .7).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(cam, "position:z", 8.0, 1.5).as_relative().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		else:
			TA.hold_end()


func _on_touch_hold_timeout():
	holdTiming = false
	
	if isPressed:
		TA.hold_start(touch_pos)


func next_scene():
	scene_out = true
	
	TA.hold_end()
	SceneHelper.fade_to_black(1.8, .5)
	AuH.vol_tween(AuH.BG, -20.0, 1.8)
	await get_tree().create_timer(1.8).timeout
	
	if SceneHelper.isSpaces:
		get_tree().change_scene_to_file("res://Spaces.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Forest_1.tscn")


func _on_exit_pressed():
	AuH.rand_note(randf_range(-20, 0), .0, "Reverb")
	next_scene()
