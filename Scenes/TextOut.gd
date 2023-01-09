extends "res://Scenes/Ext/Rotate3D.gd"


const textcover = preload("res://src/TextCover.tscn")

var covers = 50
var tween
var fly_out_f = 0.0
var scene_out = false
var touched = false
var touched_hint_delay = 4000
var timetick

onready var text_con = $World/Texts
onready var main_text = $World/MainText


func light_on_anim_ends():
	$Anim.play("arrow_indicate")
	indicator_show = true


func _ready():
	Connect.sendudp("5")
	
	randomize()
	timetick = OS.get_ticks_msec()
	
	$Anim.play("light_on")
	
	for n in covers:
		var tc = textcover.instance()
		
		var x = rand_range(-2, 2)
		var y = rand_range(-1.5, 1.5)
		
		tc.translation = Vector3(x, y, rand_range(-2, -4))
		
		text_con.add_child(tc)


func _process(delta):
	
	if !touched:
		if OS.get_ticks_msec() > timetick + touched_hint_delay:
			Hint.show_hint("画面に触れて、しばらくしたら離す。", false)
			touched_hint_delay += 4000
	
	covers = text_con.get_child_count()
	if covers < 30:
		scene_out = true
		$Anim.play("light_off")
		yield(get_tree().create_timer(4.0), "timeout")
		next_scene()
	
	if !isMobile:
		return
	
	var gyro = Input.get_gyroscope()
	gyro.z = .0
#	$Label.text = String(gyro)
	if gyro.length() > 1.0:
		text_con.get_child(randi()%covers).move_along(gyro)
		text_con.get_child(randi()%covers).move_along(gyro)
		text_con.get_child(randi()%covers).move_along(gyro)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		print("Mouse Click at: ", event.position)
		
		if tween: tween.kill()
		tween = create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(main_text, "translation:z", -12.0, 2.0)
		
		TA.hold_start(event.position)

	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		
		fly_out_f = (main_text.translation.z + 10) / 2
		if fly_out_f <= -.01:
			touched = true
		
		if tween: tween.kill()
		tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(main_text, "translation:z", -10.0, 1.0)
		tween.parallel().tween_callback(self, "fly_out")
		TA.hold_end()


func fly_out():
	TA.hold_end()
	for c in text_con.get_children():
		c.fly_out(fly_out_f)


func next_scene():
	TA.hold_end()
	
	SceneHelper.fade_to_black(0, 2.5)
	SceneHelper.rounds = 1
	get_tree().change_scene("res://Scenes/Forest_2.tscn")
