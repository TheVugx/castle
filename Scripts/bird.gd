extends CharacterBody2D

enum State {IDLE, ATTACK}
var state : State = State.IDLE
var target: Node2D = null
var home_pos: Vector2

func _ready():
	home_pos = global_position

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			return_to_home(delta)
		State.ATTACK:
			if target:
				var dir = (target.global_position - global_position).normalized()
				velocity = dir * 120.0
				move_and_slide()

func set_state_attack(player: Node2D):
	target = player
	state = State.ATTACK

func set_state_idle():
	target = null
	state = State.IDLE

func return_to_home(delta: float):
	var dist = global_position.distance_to(home_pos)
	if dist > 5.0:  
		var dir = (home_pos - global_position).normalized()
		velocity = dir * 100.0
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
