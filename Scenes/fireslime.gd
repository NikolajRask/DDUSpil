extends KinematicBody2D

var speed = 30
var chase = false
var player = null
var fireSlimePosition = null
var health = 100
var in_attack_zone = false
var dead = false
var canTakeDamage = true
var fireTrail = preload("res://Scenes/fireTrail.tscn")
var timerStarted = false

func _physics_process(delta):
	if health > -999999:
		updateHealth()
		deadCheck()
		deal_with_damage()
		
		if chase == true:
			var displacement = (player.position - position).normalized() * speed * delta
			position += displacement
			
			if timerStarted == false:
				$trailTimer.start()
				timerStarted = true
				var fireTrailInstance = fireTrail.instance()
				fireTrailInstance.position = position  # Set the position to be the same as the fireSlimePosition
				get_parent().add_child(fireTrailInstance)  # Add the instance to the scene
				get_parent().move_child(fireTrailInstance,10)
			$AnimatedSprite.play("Walk")
			if player.position.x < position.x:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Death")

func _on_Detection_body_entered(body):
	player = body
	chase = true
	

# warning-ignore:unused_argument
func _on_Detection_body_exited(body):
	chase = false
	player = null


func deal_with_damage():
	if	canTakeDamage == true:
		if	in_attack_zone and Global.player_current_attack == true:
			health -= 20
			#print(health)
			canTakeDamage = false
			$takeDamageTimer.start()
			print("fire slime took damage")


func _on_deathTimer_timeout():
	self.queue_free()



func _on_takeDamageTimer_timeout():
	canTakeDamage = true

func updateHealth():
	var healthBar = $fireSlimeHealth
	
	healthBar.value = health
	if	health >= 100:
		healthBar.visible = false
	else:
		healthBar.visible = true

func deadCheck():
	if	health < 1 and health > -10000:
		$deathTimer.start()
		$AnimatedSprite.play("Death")
		$fireSlimeHealth.visible = false
		health = -999999999
		

func _on_slime_hitbox_area_entered(area):
	if	area.has_method("player"):
		in_attack_zone = true
		print("slimesui")
	if	area.has_method("FireBall"):
		health -= 2
		print("fireball zombieHit")
		area.get_parent().queue_free()
		updateHealth()


func _on_slime_hitbox_area_exited(area):
	if	area.has_method("player"):
		in_attack_zone = false


func _on_trailTimer_timeout():
	timerStarted = false
