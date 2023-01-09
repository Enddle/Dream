extends Node

onready var cam = $Camera
onready var world = $World

var isMobile = false
var center_rad = 0.0
var center_angle = 0.0
var center_away = false
var indicator_pos = Vector2()
var indicator_show = false

func _ready():
#	print(OS.get_name())
	isMobile = (OS.get_name() == "iOS")
	
	if isMobile:
		cam.rotation_degrees.z = 180
		world.rotation_degrees.y = 180


func _process(delta):
	# Get our data
	var grav = Input.get_gravity()
	var gyro = Input.get_gyroscope()
	
#	gyro *= Vector3(1.0, -1.0, -1.0)
		
	# Using our gyro and do a drift correction using our gravity vector gives the best result
	if isMobile:
		var new_basis = rotate_by_gyro(gyro, world.transform.basis, delta).orthonormalized()
		world.transform.basis = drift_correction(new_basis, grav)
		
		if !indicator_show:
			return
		
		center_rad = Vector3.UP.signed_angle_to(world.transform.basis.z, Vector3.FORWARD)
		center_angle = stepify(rad2deg(center_rad), 0.01)
		
		var proj_disx = world.transform.basis.z.project(Vector3.RIGHT).x
		var proj_disy = world.transform.basis.z.project(Vector3.UP).y
		var proj_disz = world.transform.basis.z.project(Vector3.FORWARD).z
		center_away = abs(proj_disy) > .6 || abs(proj_disx) > .9 || proj_disz < .0
		
#		indicator_pos = Vector2(sin(center_rad), -cos(center_rad))
		indicator_pos = Vector2(proj_disx, -proj_disy)

		
#		$Label.text = String(world.transform.basis.get_euler()) + "\n"
#		$Label.text += String(world.transform.basis.get_rotation_quat()) + "\n"
#		$Label.text = String(angle) + "\n"
#		$Label.text = String(proj_disx) + " || " + String(proj_disy) + ," || " + String(proj_disz) 
#		$Label.text += String(proj_disz) + "\n"
#		$Label.text += String()
		
#		$Label.text += String(stepify(proj_dis, 0.01))
#		$Label.text += String(stepify(angle, 0.1)) + "\n"
#		$Label.text += String(stepify(rad2deg(angle), 0.1)) + "\n"
#		Vector3.FORWARD.project(world.transform.basis.z)

		$arrow_pos/arrow.rect_rotation = center_angle
		$arrow_pos.rect_position = indicator_pos
		$arrow_pos.rect_position.x *= 1000
		$arrow_pos.rect_position.y *= 600
		$arrow_pos.visible = center_away



# https://github.com/godotengine/godot-demo-projects/tree/3.4-b0d4a7c/mobile/sensors
#
# This function takes our gyro input and update an orientation matrix accordingly
# The gyro is special as this vector does not contain a direction but rather a
# rotational velocity. This is why we multiply our values with delta.
func rotate_by_gyro(p_gyro, p_basis, p_delta):
	var rotate = Basis()
	
	rotate = rotate.rotated(p_basis.x, -p_gyro.x * p_delta)
	rotate = rotate.rotated(p_basis.y, p_gyro.y * p_delta)
	rotate = rotate.rotated(p_basis.z, -p_gyro.z * p_delta)
	
	return rotate * p_basis


# https://github.com/godotengine/godot-demo-projects/tree/3.4-b0d4a7c/mobile/sensors
#
# This function corrects the drift in our matrix by our gravity vector 
func drift_correction(p_basis, p_grav):
	# as always, make sure our vector is normalized but also invert as our gravity points down
	var real_up = -p_grav.normalized()
	
	# start by calculating the dot product, this gives us the cosine angle between our two vectors
	var dot = p_basis.y.dot(real_up)
	
	# if our dot is 1.0 we're good
	if (dot < 1.0):
		# the cross between our two vectors gives us a vector perpendicular to our two vectors
		var axis = p_basis.y.cross(real_up).normalized()
		var correction = Basis(axis, acos(dot))
		p_basis = correction * p_basis
	
	return p_basis
