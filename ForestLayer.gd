extends ParallaxLayer


export var distance = 10.0


func _ready():
	
	# Randomly generates trees in this layer
	
	pass # Replace with function body.


func _process(delta):
	
	distance -= .5 * delta
	
	if distance <= 0:
		distance = 10
		return
	
	var x = distance
	
	var scaling = 1 / (x/2 + .1) + .5
	get_child(0).scale = Vector2(scaling, scaling)
	
	var opacity = -.1 * x + 1 if (x > .2) else 4.9 * x
	modulate.a = opacity
	
	var moscale = .1 * x
	motion_scale.x = moscale
	
