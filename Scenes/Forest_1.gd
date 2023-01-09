extends Node


var blink_allowed = true
var isPressed = false
var presstime
var passed = false
var blink_times = 0

var state_machine

onready var forest = $Forest
onready var anim_tree = $Eye/AnimationTree


func _ready():
	anim_tree.active = true
	state_machine = anim_tree["parameters/playback"]
	
	AuH._BG(AuH.FOREST_BG, -15.0, 2.0)
	AuH._FX(AuH.BREATH_FX, 0.0, .6)
	
	forest.cam.fov = 70


func blink():
	if !blink_allowed: return
	blink_allowed = false
	
	blink_times += 1
	
	state_machine.travel("eye_blink")
	yield(get_tree().create_timer(.4), "timeout")
	forest.random_trees_all()
	
	yield(get_tree().create_timer(.7), "timeout")
	blink_allowed = true


func _process(_delta):
	if passed:
		return
	if isPressed:
		$Camera2D.zoom *= .995
		var v = 1 - ($Camera2D.zoom.x - .6) / .4  # from 0 - 1
		AuH._vol(AuH.BG, 10*v-15)
		AuH._vol(AuH.FX, -15*v)
		
		forest.cam.fov = 70 - 20*v

	if $Camera2D.zoom.length_squared() < .6:
		pass_eye()


var touch_pos = Vector2.ZERO


func _on_screen_touch_down():
#	touch_pos = get_viewport().get_mouse_position()
	presstime = OS.get_ticks_msec()
	isPressed = true
	TA.hold_start(touch_pos)


func _on_screen_touch_up():
	isPressed = false
	TA.hold_end()
	if (OS.get_ticks_msec() - presstime < 1000):
		blink()
		if (blink_times > 6):
			Hint.show_hint("画面を触れたままに、夢の奥へ進む。", false)


func pass_eye():
	passed = true
	TA.hold_end()
	$ScreenTouch.queue_free()
	
	var tween := create_tween()
	tween.tween_property($Eye, "modulate:a", .0, 1.0)
	tween.tween_callback(self, "remove_eye")
	
	Hint.show_hint("画面をタッチして歩き、出口を探す。", false)


func remove_eye():
	$Eye.queue_free()
