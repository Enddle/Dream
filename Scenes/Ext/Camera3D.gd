extends Node

@onready var cam = $Camera3D
@onready var world = $World

var isMobile = false
var isSynced = false

var init_grav = Vector3()

func _ready():
#	print(OS.get_name())
	isMobile = (OS.get_name() == "iOS")
	
	init_grav = Input.get_gravity()

func _process(delta):
	# Get our data
	var grav = Input.get_gravity()
	var gyro = Input.get_gyroscope()
	
#	gyro *= Vector3(1.0, -1.0, -1.0)
	
	# Using our gyro and do a drift correction using our gravity vector gives the best result
	if isMobile:
		var new_basis = rotate_by_gyro(gyro, cam.transform.basis, delta).orthonormalized()
		
#		if grav.distance_to(init_grav) < 0.05:
		if !isSynced:
			cam.transform.basis = drift_correction(new_basis, grav)
#		elif grav.x < 0.01 && grav.y > 0.99 && grav.z < 0.01:
#			cam.transform.basis = drift_correction(new_basis, grav)
		else:
			cam.transform.basis = new_basis
		



# https://github.com/godotengine/godot-demo-projects/tree/3.4-b0d4a7c/mobile/sensors
#
# This function takes our gyro input and update an orientation matrix accordingly
# The gyro is special as this vector does not contain a direction but rather a
# rotational velocity. This is why we multiply our values with delta.
func rotate_by_gyro(p_gyro, p_basis, p_delta):
	var rotate = Basis()
	
	rotate = rotate.rotated(p_basis.x, -p_gyro.x * p_delta)
	rotate = rotate.rotated(p_basis.y, -p_gyro.y * p_delta)
	rotate = rotate.rotated(p_basis.z, p_gyro.z * p_delta)
	
	return rotate * p_basis


# https://github.com/godotengine/godot-demo-projects/tree/3.4-b0d4a7c/mobile/sensors
#
# This function corrects the drift in our matrix by our gravity vector 
func drift_correction(p_basis, p_grav):
	# as always, make sure our vector is normalized but also invert as our gravity points down
	var real_up = -p_grav
	real_up.y = -real_up.y
	real_up.x = -real_up.x
	var vr_up = 2 * Vector3(0, 1, 0) - real_up
	var vr_upn = vr_up.normalized()
	
	# start by calculating the dot product, this gives us the cosine angle between our two vectors
	var dot = p_basis.tdoty(vr_upn)
	
#	$Label.text = String(real_up) + "\n"
#	$Label.text += String(vr_up) + "\n"
#	$Label.text += String(vr_upn) + "\n"
#	$Label.text += String(p_basis.y) + "\n"
#	$Label.text += String(dot) + "\n"
	
	# if our dot is 1.0 we're good
	if (dot < 1.0):
		# the cross between our two vectors gives us a vector perpendicular to our two vectors
		var axis = p_basis.y.cross(vr_upn).normalized()
		var correction = Basis(axis, acos(dot))
		p_basis = correction * p_basis
	
	isSynced = true
	
	return p_basis
