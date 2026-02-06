extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var x : int = 0
	var y : int = 0 
	if Input.is_key_pressed(KEY_LEFT):
		x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		x += 1
	if Input.is_key_pressed(KEY_UP):
		y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		y += 1

	var input_direction := Vector2(x, y).normalized()
	velocity = input_direction * 200
	move_and_slide()
