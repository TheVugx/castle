class_name Enemy
extends CharacterBody2D

@export var speed := 140.0
@export var gravity := 1400.0
@export var jump_force := 520.0
@export var climb_force := 180.0
@export var path_x_gain := 6.0
@export var max_fall_speed := 2000.0

@onready var path : Curve2D = $Path2D.curve

var distance := 0.0

func _physics_process(delta):
	if path.point_count < 2:
		return

	# ---- Sample path ----
	distance += speed * delta
	var path_pos := path.sample_baked(distance)

	
	var dx := path_pos.x - global_position.x
	velocity.x = clamp(dx * path_x_gain, -speed, speed)

	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	
	if path_pos.y < global_position.y - 10:
		velocity.y = min(velocity.y, -climb_force)

	if is_on_floor():
		var height_diff := path_pos.y - global_position.y

		if height_diff < -40:
			velocity.y = -jump_force

	velocity.y = min(velocity.y, max_fall_speed)

	move_and_slide()
