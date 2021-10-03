extends RigidBody2D
var movespeed = 32
var gravspeed = 5
var isActive = false
var rot = 0

func _integrate_forces(state):
	if isActive:
		if Input.is_action_just_pressed("move_left"):
			state.transform.origin += Vector2(-movespeed,0)
		elif Input.is_action_just_pressed("move_right"):
			state.transform.origin += Vector2(movespeed,0)
		elif Input.is_action_just_pressed("accelerate"):
			state.transform.origin += Vector2(0,gravspeed)
		elif Input.is_action_just_pressed("rotate_cw"):
			rot -= PI/2
			var before = state.transform.origin
			state.transform.origin = Vector2(0,0)
			state.transform=state.transform.rotated(rot)
			state.transform.origin = before
		elif Input.is_action_just_pressed("rotate_ccw"):
			rot += PI/2
			var before = state.transform.origin
			state.transform.origin = Vector2(0,0)
			state.transform=state.transform.rotated(rot)
			state.transform.origin = before
