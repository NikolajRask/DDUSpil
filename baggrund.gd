extends Node2D
var speed = 20  # Adjust the speed as needed
var direction = 1

func _process(delta):
	# Move the sprite horizontally
	position.x += speed * direction * delta
