extends CharacterBody2D

@onready var sprite := $Sprite2D
@onready var timer := $Timer
var direction = 1

#func _ready():
#	timer.wait_time = 0.6
#	timer.start()

func _physics_process(delta):
	if direction == 1:
		sprite.flip_h = false
	elif direction == -1:
		sprite.flip_h = true

func _on_timer_timeout():
	if randf() < 0.3:
		if direction == 1:
			direction = -1
		elif direction == -1:
			direction = 1
	timer.start()
