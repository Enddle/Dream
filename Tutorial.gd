extends Node


const hints = [
	"充電ケーブルを抜いてください。",  # 0
	"使い方：デバイスを回転させる。",  # 1
	"使い方：画面上の任意の場所をタッチする。",  # 2
	"使い方：画面をタッチし、触れたままにする。",   # 3
	"使い方：音楽をなるまで待てる。",  # 4
]

var tween
var anim_playing = false
var current_step = 1
var total_movement = 0.0
var presstime = 0
var touch_count = 0
var touching = false
var touching_time = 3.0
var wait_time = 10.0
var scene_out = false

onready var Anim = $Anim
onready var ipad = $TextureRect


func _ready():
	SceneHelper.isTutorial = true


func _process(delta):
	if current_step == 0:
		if !anim_playing:
			anim_playing = true
			Anim.play("charging_unplug_loop")
			show_hint(hints[0])
			
			yield(get_tree().create_timer(8), "timeout")
			Anim.play("charging_unplug")
			
			yield(get_tree().create_timer(3), "timeout")
			current_step = 1
			anim_playing = false
			
			show_hint(hints[1])
			
	elif current_step == 1:
		if !anim_playing:
			var g = Input.get_gyroscope() * delta
			ipad.rect_rotation += g.z * 180
			ipad.rect_scale.x += stepify(g.y, 0.01) * 2
			ipad.rect_scale.y += stepify(g.x, 0.01) * 2
			
			if ipad.rect_scale.x > 1:
				ipad.rect_scale.x = 1
			elif ipad.rect_scale.x < -1:
				ipad.rect_scale.x = -1
			
			if ipad.rect_scale.y > 1:
				ipad.rect_scale.y = 1
			elif ipad.rect_scale.y < -1:
				ipad.rect_scale.y = -1
			
			total_movement += g.length_squared()
			$progress.rect_scale.x = total_movement / .6
			if total_movement >= .6:
				anim_playing = true
				tween = create_tween()
				tween.tween_property(ipad, "rect_scale", Vector2(1, 1), 0.8)
				tween.parallel().tween_property(ipad, "rect_rotation", 0.0, 0.8)
				tween.parallel().tween_property($progress, "color:a", 0.0, 0.8)
				
				tween.tween_property($touch/a, "modulate:a", 1.0, 0.5)
				tween.parallel().tween_property($touch/b, "modulate:a", 1.0, 0.5)
				tween.parallel().tween_property($touch/c, "modulate:a", 1.0, 0.5)
				
				yield(get_tree().create_timer(1.0), "timeout")
				current_step = 2
				anim_playing = false
				
				show_hint(hints[2])
			
	elif current_step == 2:
		if !anim_playing && touch_count >= 3:
			anim_playing = true
			
			tween = create_tween()
			
			tween.tween_property($touch/a, "modulate:a", .0, 0.5).set_delay(.5)
			tween.parallel().tween_property($touch/b, "modulate:a", .0, 0.5).set_delay(.65)
			tween.parallel().tween_property($touch/c, "modulate:a", .0, 0.5).set_delay(.8)
			
			tween.tween_property($progress, "color:a", 1.0, 0.8).set_delay(1.0)
			
			yield(get_tree().create_timer(1.0), "timeout")
			$progress.rect_scale.x = 1
			current_step = 3
			anim_playing = false
			
			show_hint(hints[3])
	
	elif current_step == 3:
		if !anim_playing:
			touching_time += -delta if touching else delta / 2
			touching_time = min(touching_time, 3.0)
			
			$progress.rect_scale.x = touching_time / 3.0
			
			AuH._vol(AuH.BG, 6 - $progress.rect_scale.x * 12)
			
			if touching_time <= 0:
				$progress.rect_scale.x = 0
				
				anim_playing = true
				
				tween = create_tween()
				tween.set_ease(Tween.EASE_OUT).tween_property($progress, "rect_scale:x", 1.0, 1.0).set_delay(.5)
				tween.tween_property($progress, "rect_scale:x", .0, wait_time).set_delay(.5)
				
				AuH.vol_tween(AuH.BG, -6.0, wait_time + 0.5)
				TA.hold_end()
				
				yield(get_tree().create_timer(1.0), "timeout")
				
				AuH._FX(AuH.TENSEC_FX, .0, .0)
				$progress.rect_scale.x = 1
				current_step = 4
				show_hint(hints[4])
				yield(get_tree().create_timer(wait_time), "timeout")
				start_scene()


func show_hint(text):
	Hint.show_hint(text, false)
	pass



var touch_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
#		print("Mouse Click at: ", event.position)
		
		touch_pos = event.position
		
		show_hint(hints[current_step])
		
		if current_step == 2:
			if OS.get_ticks_msec() - presstime > 500:
				presstime = OS.get_ticks_msec()
		
		elif current_step == 3:
			touching = true
			TA.hold_start(touch_pos)


	if event is InputEventMouseButton and !event.is_pressed():
#		print("Mouse Unclick at: ", event.position)
		
		if current_step == 2:
			if touch_count >= 3:
				pass
			elif OS.get_ticks_msec() - presstime < 300:
				var t = $touch.get_child(touch_count)
				
				AuH.rand_note(rand_range(-20, 0), .0, "Reverb")
				TA.touch(touch_pos)
				
				tween = create_tween().set_trans(Tween.TRANS_BACK)
				tween.tween_property(t, "rect_scale", Vector2(.05, .05), .5)
				touch_count += 1
		
		elif current_step == 3:
			touching = false
			TA.hold_end()



func start_scene():
	SceneHelper.fade_to_black(1.0, 1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	SceneHelper.isTutorial = false
	get_tree().change_scene("res://Scenes/Room.tscn")


func _on_Button_pressed():
	if !scene_out:
		scene_out = true
		start_scene()
