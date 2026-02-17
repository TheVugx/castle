extends Area2D

@export var bird: CharacterBody2D 


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("ENTER:", body.name)
	if body.is_in_group("player"):
		bird.set_state_attack(body)

func _on_body_exited(body):
	print("EXIT:", body.name)
	if body.is_in_group("player"):
		bird.set_state_idle()
