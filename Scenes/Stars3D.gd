extends "res://Scenes/Ext/Rotate3D.gd"

const star = preload("res://src/Star.tscn")

var accel = Vector3.ZERO
var speed = Vector3.ZERO
var timetick
var laststar
var timepress
var scene_out = false

onready var pointer = $Camera/Spatial/Pointer
onready var star_con = $World/Stars


func _ready():
	randomize()
	timetick = OS.get_ticks_msec() / 1000
	laststar = timetick - 1
	
#	SceneHelper.rounds = 1
#	AuH._BG(AuH.SPACE_2_BG)
	
	if SceneHelper.rounds == 0:
		AuH._BG(AuH.SPACE_BG)
	elif SceneHelper.rounds == 1:
		AuH._BG(AuH.SPACE_2_BG)


func _process(delta):
	if scene_out:
		return
	
	if OS.get_ticks_msec() / 1000 - timetick > 30:
		next_scene()
		scene_out = true
	
	accel = Vector3(randf()-.5, randf()-.5, randf()-.5) * 10
	if pointer.translation.distance_squared_to(Vector3.ZERO) > 0.75:
		accel -= pointer.translation.normalized() * 5
	speed += .5 * accel * delta
	pointer.translate(speed * delta * 2)
	
	if (OS.get_ticks_msec() % 2000 <= 20):
		add_star()


func _on_screen_touch_down():
	timepress = OS.get_ticks_msec()


func _on_screen_touch_up():
	var t = OS.get_ticks_msec()
	if t - timepress < 1000:
		if t - laststar > 800:
			laststar = t
			
			TA.touch()
			add_star()


func add_star():
	var s = star.instance()
	var t = pointer.global_transform
	star_con.add_child(s)
	s.global_transform = t
	
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")


func next_scene():
	if SceneHelper.rounds == 1:
		var tween := create_tween()
		tween.tween_property(pointer, "global_translation", Vector3.ZERO, 5.0)
		yield(get_tree().create_timer(3), "timeout")
		yield(get_tree().create_timer(1), "timeout")
		
		SceneHelper.fade_to(Color.white, 1.0, 3.0)
		
		yield(get_tree().create_timer(.75), "timeout")
		
		AuH._FX(AuH.ZOOM_FX, .0, .0)
		
		yield(get_tree().create_timer(.25), "timeout")

	get_tree().change_scene("res://Scenes/TextIn.tscn")
