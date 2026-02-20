extends CharacterBody2D
class_name BirdEnemy

# ==============================
# CONFIG
# ==============================
@export var dive_duration := 1.2
@export var dive_depth := 30.0
@export var dive_cooldown := 2.0
@export var return_speed := 140.0
@export var bank_strength := 0.12

# ==============================
# STATE
# ==============================
enum State { IDLE, LOCK, DIVE, AT_SUCCESS, AT_FAILURE, RETURN }
var state : State = State.IDLE

var target: Node2D = null
var home_position: Vector2

# Bezier
var dive_t := 0.0
var p0 := Vector2.ZERO
var p1 := Vector2.ZERO
var p2 := Vector2.ZERO

var cooldown_timer := 0.0
var can_attack := true
var attack_active := false

# attack direction memory
var last_attack_dir := Vector2.ZERO

# ==============================
# READY
# ==============================
func _ready():
	home_position = global_position

# ==============================
# PROCESS
# ==============================
func _physics_process(delta):
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		if cooldown_timer <= 0.0:
			can_attack = true

	match state:
		State.IDLE:
			print("idle")
			pass

		State.LOCK:
			print("lock")
			lock_target()

		State.DIVE:
			print("dive")
			dive_behavior(delta)

		State.AT_SUCCESS:
			print("success")
			pass

		State.AT_FAILURE:
			print("failure")
			pass

		State.RETURN:
			print("return")
			return_home(delta)

# ==============================
# EXTERNAL API
# ==============================
func set_target(t: Node2D):
	target = t
	can_attack = true
	state = State.LOCK
	
func set_idle():
	target = null
	can_attack = false
	state = State.IDLE

# ==============================
# LOGIC
# ==============================
func lock_target():
	if target == null:
		state = State.IDLE
		return
	start_dive()

func start_dive():
	if not can_attack or target == null:
		state = State.IDLE
		return

	can_attack = false
	cooldown_timer = dive_cooldown
	dive_t = 0.0

	p0 = global_position
	p2 = target.global_position
	p1 = (p0 + p2) * 0.5 + Vector2(0, dive_depth)  # bottom of U

	state = State.DIVE


func dive_behavior(delta):
	dive_t += delta / dive_duration
	var t = clamp(dive_t, 0.0, 1.0)

	var prev = global_position
	var next_pos = bezier(p0, p1, p2, t)
	var motion = next_pos - prev  
	
	if motion.length() > 0.001:
		last_attack_dir = motion.normalized()
		
	var collision = move_and_collide(motion)
	
	if collision and attack_active:
		var collider = collision.get_collider()
		if collider and collider.is_in_group("player"):
			print("HIT PLAYER DURING DIVE")
			on_hit_player(collider)

	
	if motion.length() > 0.001:
		rotation = lerp_angle(rotation, motion.angle(), bank_strength)

		attack_active = (t > 0.35 and t < 0.65)

	if t >= 1.0:
		end_dive()

func on_hit_player(player):
	if player.has_method("take_damage"):
		player.take_damage(10)
	state = State.AT_SUCCESS


func end_dive():
	attack_active = false

	if target:
		var player_pos = target.global_position
		var bird_pos = global_position

		var horizontal_offset := 200.0   # diagonal X distance
		var vertical_offset := 100.0     # UP distance

		var new_pos: Vector2

		# Bird was on RIGHT side of player
		if bird_pos.x > player_pos.x:
			# reposition to LEFT + UP
			new_pos = player_pos + Vector2(-horizontal_offset, -vertical_offset)
		else:
			# Bird was on LEFT side of player
			# reposition to RIGHT + UP
			new_pos = player_pos + Vector2(horizontal_offset, -vertical_offset)

		global_position = new_pos

	state = State.AT_SUCCESS
# ==============================
# RETURN
# ==============================
func return_home(delta):
	var dir = home_position - global_position
	if dir.length() < 5.0:
		global_position = home_position
		velocity = Vector2.ZERO
		rotation = 0.0
		state = State.IDLE
		return

	velocity = dir.normalized() * return_speed
	move_and_slide()

# ==============================
# MATH
# ==============================
func bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var u = 1.0 - t
	return u * u * p0 + 2 * u * t * p1 + t * t * p2
