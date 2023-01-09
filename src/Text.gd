extends Spatial


var accel = Vector3.ZERO
var speed = Vector3.ZERO
var center_pos = Vector3.ZERO

onready var t = $Text


func init(character, position):
	$Text.text = character
	translation = position


func _ready():
	# transition fade in
	var tween := create_tween()
	tween.tween_property($Text, "modulate:a", 1.0, 1.5)


func _process(delta):
	# random accel
	accel = Vector3(randf()-.5, randf()-.5, randf()-.5)
	
	# at center reactions
	var mode = DynamicColor.current_seq
	var c = at_center()
	if c != -1.0:
		# change color when look at, gradient from center
		t.modulate = DynamicColor.color_gr(c, t.modulate.a)
		react_center(mode)
	
	# mode 3 final ignore at center
	elif mode == 3:
		react_center(3)
	
	# go back to center if too far away
	elif t.translation.distance_squared_to(center_pos) > .2:
		accel += (center_pos - t.translation).normalized() * .5
	
	# move accordingly
	speed += .5 * accel * delta
	t.translate(speed * delta)


func react_center(mode):
	# MODE 0: slow down and go back to original place
	if mode == 0 || mode == 2:
		accel = -t.translation * 2
		speed *= .9
	
	# MODE 1: speed up
	elif mode == 1:
		accel *= 2
		speed *= 1.01
	
	# MODE 3: cover camera
	elif mode == 3:
		accel = center_pos - t.translation
		speed *= .96


const tres = 2
const tres_dist = 2 * tres * tres

# return the distance percentage from center
# return -1 when not in center area
func at_center() -> float:
	var tr = t.global_translation
	if tr.x < tres &&  tr.x > -tres && tr.y < tres && tr.y > -tres:
		return 1 - sqrt((tr.x * tr.x + tr.y * tr.y) / tres_dist)
	else:
		return -1.0


func update_center():
	center_pos -= translation
	
#	center_pos.x += randf()-.5
#	center_pos.y += randf()-.5
#	center_pos.z += randf()
