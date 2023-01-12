extends Node


const pausetime = 30000
const pausetime_t = 10000
const countdown = 20.0


var tween
var rounds = 0
var isMobile

var isStarting = false
var isTutorial = false
var isCredit = false

var scene_out = false
var timetick = OS.get_ticks_msec()

onready var crect = $ColorRect


func _ready():
	isMobile = (OS.get_name() == "iOS")
	hide_restart(false)
#	show_restart()


func _process(delta):
	if !isMobile:
		return
	
	if scene_out:
		return
	
	if isStarting || isCredit:
		return
	
	var ptime = pausetime
	if isTutorial:
		ptime = pausetime_t
	
	var g = Input.get_gyroscope() * delta
	if stepify(g.length(), 0.001) != 0:
		timetick = OS.get_ticks_msec()
	
	if timetick + ptime - OS.get_ticks_msec() < 0:
		scene_out = true
		if isTutorial:
			restart_end()
		else:
			show_restart()
	
#	$Label.text = String(timetick + ptime - OS.get_ticks_msec())


func fade_to_black(dura_in, dura_out):
	fade_to(Color.black, dura_in, dura_out)


func fade_to(c, dura_in, dura_out):
	crect.modulate = c
	crect.modulate.a = 0.0
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(crect, "modulate:a", 1.0, dura_in)
	tween.tween_callback(self, "hide_restart", [false])
	tween.tween_property(crect, "modulate:a", 0.0, dura_out)


func show_restart():
	$return_screen/back/countdown.modulate.a = 0.0
	$return_screen/back/countdown.value = 100
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_callback(self, "restart_visible", [true])
	tween.tween_property($return_screen, "modulate:a", 1.0, 1.0)
	tween.tween_property($return_screen/back/countdown, "modulate:a", 1.0, 1.0).set_delay(1.0)
	tween.tween_property($return_screen/back/countdown, "value", 0.0, countdown)
	tween.tween_callback(self, "restart_end")
	


func hide_restart(anim = true):
	if anim:
		if tween: tween.kill()
		tween = create_tween()
		tween.tween_property($return_screen, "modulate:a", .0, 1.0)
		tween.tween_callback(self, "restart_visible", [false])
	else:
		$return_screen.modulate.a = 0
		restart_visible(false)


func restart_visible(v):
	$return_screen.visible = v
	timetick = OS.get_ticks_msec()
	scene_out = false


func restart_end():
	fade_to_black(1.0, 1.0)
	AuH.vol_tween(AuH.BG, -50.0, 1.0)
	
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")
	
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://StartingScreen.tscn")


func _on_return_back_down():
	$return_screen/back.modulate.a = .4
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")


func _on_return_back_up():
	$return_screen/back.modulate.a = 1.0
	restart_end()


func _on_return_cancel_down():
	$return_screen/cancel.modulate.a = .4
	AuH.rand_note(rand_range(-20, 0), .0, "Reverb")


func _on_return_cancel_up():
	$return_screen/cancel.modulate.a = 1.0
	hide_restart()
