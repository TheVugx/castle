extends CharacterBody2D
#constantes del personaje 
@export var move_speed: float = 200.0
@export var jump_force: float = 420.0
@export var gravity: float = 1200.0
#variables del personaje 
var direction: float = 0.0
var is_jumping: bool = false
#importaciones
@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement()
	handle_jump()
	move_and_slide()
	update_state()


func handle_movement() -> void:
	# Captura input horizontal (A/D o ←/→)
	direction = Input.get_axis("ui_left", "ui_right")

	velocity.x = direction * move_speed

func handle_jump() -> void:
	# Solo puede saltar si está en el suelo
	if is_on_floor():
		is_jumping = false


		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_force
			is_jumping = true

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func update_state() -> void:
	# Esta función NO anima todavía
	# Solo define estados lógicos que luego usarás
	# con AnimatedSprite2D o AnimationPlayer

	if not is_on_floor():
		if velocity.y < 0:
			animationPlayer.play("jump")
			pass
		else:
			# Estado: cayendo
			pass
	else:
		if direction != 0:
			animationPlayer.play("walk")
			pass
		else:
			animationPlayer.play("idle")
			pass
