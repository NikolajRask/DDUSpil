extends KinematicBody2D

func _physics_process(delta):
	$AnimatedSprite.play("default")


func _on_Timer_timeout():
	self.queue_free()
