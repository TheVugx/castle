extends Area2D

@export var bird: BirdEnemy   # drag BirdEnemy node here in inspector

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	print("ENTER:", body.name)
	if body.is_in_group("player"):
		bird.set_target(body)
		
func _on_body_exited(body: Node2D):
	print("EXIT:", body.name)
	if body.is_in_group("player"):
		bird.set_idle()
