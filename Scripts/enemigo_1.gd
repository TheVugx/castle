extends CharacterBody2D

@export var speed: float = 80.0
@export var jump_force: float = -680.0
@export var gravity: float = 900.0

var mage: Node2D
var current_target: Node2D
var player_target: Node2D = null

@onready var detector = $PlayerDetector
@onready var ray_wallD = $RayWallD
@onready var ray_wallI = $RayWallI
@onready var ray_climb = $RayClimbCheck
@onready var animator = $AnimationPlayer

func _ready():
	mage = get_closest_target("mage")
	current_target = mage
	
	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	apply_gravity(delta)
	update_target()
	move_to_target()
	move_and_slide()

# Siempre busca al mago si no hay player
func update_target():
	if player_target != null:
		current_target = player_target
	else:
		current_target = mage

# Movimiento horizontal + salto
func move_to_target():
	if current_target == null:
		return
	
	var direction_x = sign(current_target.global_position.x - global_position.x)
	velocity.x = direction_x * speed
	if velocity.x != 0:
		animator.play("walk1")
	elif velocity.x == 0:
		animator.play("idle")
	
	# Voltear sprite
	if direction_x != 0:
		$Sprite2D.flip_h = direction_x < 0
	
	# Condición de salto
	if is_on_floor() \
	and (ray_wallI.is_colliding() or ray_wallD.is_colliding() ):
		velocity.y = jump_force
		animator.play("jump1")


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Detecta player
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_target = body

func _on_body_exited(body):
	if body == player_target:
		player_target = null

# 🔹 Buscar objetivo por grupo
func get_closest_target(group_name: String) -> Node2D:
	var nodes = get_tree().get_nodes_in_group(group_name)
	if nodes.is_empty():
		return null
	
	return nodes[0] # asumimos solo 1 mago
