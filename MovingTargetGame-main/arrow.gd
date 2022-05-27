# arrow.gd

extends RigidBody2D

signal arrow_out()
signal arrow_sound()

const      MAX_Y = -20
const         Y0 = -4
const ARROW_POS0 = Vector2(0,Y0)

var rng = RandomNumberGenerator.new()

func _ready():
	gravity_scale = 0.0 # remove gravity force!
	position = ARROW_POS0
	rng.randomize()
	
# Tarea: Physics
# 1. Evitar que siga disparando flechas
# 2. Colisionar targets!!
# https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html#rotation-movement
func impulse():
	rng.randomize()
	var my_random_number = rng.randf_range(0.0,4.0)
	var desp = Y0 - position.y - 1
	var force = range_lerp(desp, MAX_Y+1, Y0, -350, -900) # FORCE * desp
	var impulse = Vector2(0, force).rotated(Global.Angle) # girar vector de fuerza(x,y)
	# print("desp=", desp, " force=", force, " impulse=", impulse)
	self.apply_central_impulse(impulse) # aplicar fuerza para mover flecha
	if my_random_number < 1:
		$shoot.play()
	if my_random_number >= 1:
		if my_random_number <2:
			$shoot2.play()
	if my_random_number >= 2:
		if my_random_number <3:
			$shoot3.play()
	if my_random_number >= 3:
		if my_random_number <=4:
			$shoot4.play()

func reset():
	emit_signal("arrow_out") # sale flecha pantalla o si dio en el target
	queue_free() ## Sol: erase arrow

func change_pos():
	if position.y < MAX_Y:
		position.y += 2

func _on_hit_finished():
	emit_signal("arrow_sound")
	reset()

func _on_arrow_body_entered(_body):
	Global.Score += 100
	$hit.play()

func _on_exit_screen_screen_exited():
	reset()
