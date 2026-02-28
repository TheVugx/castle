class_name Enemy2
extends CharacterBody2D

@export var speed := 140.0
@export var gravity := 1400.0
@export var jump_force := 520.0
@export var climb_force := 180.0
@export var path_x_gain := 6.0
@export var max_fall_speed := 2000.0

@onready var path : Curve2D = $PathEnemy2.curve

var distance := 0.0

func _physics_process(delta):
	if path.point_count < 2:
		return

	# ---- Sample path ----
	distance += speed * delta
	var path_pos : Vector2 = path.sample_baked(distance)

	# =====================================================
	# Horizontal path following
	# =====================================================
	var dx := path_pos.x - global_position.x
	velocity.x = clamp(dx * path_x_gain, -speed, speed)

	# =====================================================
	# Vertical logic (hybrid physics)
	# =====================================================

	# --- Gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

	# --- Stop falling when path goes up ---
	if path_pos.y < global_position.y - 10:
		# Path wants to go up → counter gravity
		velocity.y = min(velocity.y, -climb_force)

	# --- Jump logic on path nodes ---
	if is_on_floor():
		var height_diff := path_pos.y - global_position.y

		# If next path point is significantly higher → jump
		if height_diff < -40:
			velocity.y = -jump_force

	# --- Clamp fall speed ---
	velocity.y = min(velocity.y, max_fall_speed)

	move_and_slide()
