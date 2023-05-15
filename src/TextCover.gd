extends Spatial


const tres = .8
const black = Color("#222222")
const gray = Color("#444444")

var tween
var move_allowed = true

const random_en = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const random_jp = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわを"

var random_text = random_jp


func _ready():
	
	language_prep()
	
	$Label3D.text = random_text[randi()%random_text.length()]
	rotation.z = randf() * 4


func _process(_delta):
	if global_translation.length_squared() > 64:
		if tween: tween.kill()
		queue_free()


func move_along(axis):
	if !move_allowed: 
		return
	
	var tr = global_translation
	if tr.x > tres || tr.x < -tres || tr.y > tres || tr.y < -tres:
		return
	
	var dir = Vector3(axis.y, axis.x, .0)
	if tween: tween.kill()
	tween = create_tween()
	var dur = rand_range(.5, .8)
	tween.tween_property(self, "global_translation", dir*(randf()+1.0), dur).as_relative()
	tween.parallel().tween_property($Label3D, "modulate", gray, dur)
	
	tween.tween_property($Label3D, "modulate", black, dur)

func allow_move():
	move_allowed = true


func fly_out(f):
	move_allowed = false
	
	if tween: tween.kill()
	var dur = rand_range(.5, .8)
	var dir = -translation * f
	dir.z = 0
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "translation", dir, dur).as_relative()
	tween.parallel().tween_property($Label3D, "modulate", black, dur)
	
	tween.tween_callback(self,"allow_move")

func language_prep():
	match SceneHelper.lang_curr:
		SceneHelper.LANG_JP:
			random_text = random_jp
		SceneHelper.LANG_EN:
			random_text = random_en
