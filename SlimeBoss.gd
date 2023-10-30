extends KinematicBody2D

var speed = 0
var chase = false
var player = null
var spawnSlimes = false
var slimeTimer = true
var health = 2000
var in_attack_zone = false
var dead = false
var canTakeDamage = true
var slimeSpawnPos = 1
var fireSlime = preload("res://BossFireSlime.tscn")
func _physics_process(delta):
	print(slimeTimer)
	
	if	health > -999999:
		updateHealth();
		deadCheck()

		deal_with_damage();
		if	chase == true:
			position += (player.position - position)/speed
			$AnimatedSprite.play("Walk")
			if	player.position.x < position.x:
				$AnimatedSprite.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
		else:
				$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Death")

			
		
	
func _on_Detection_body_entered(body):
	spawnSlimes = true
	

func _on_Detection_body_exited(body):
	spawnSlimes = false




	



func deal_with_damage():
	if	canTakeDamage == true:
		if	in_attack_zone and Global.player_current_attack == true:
			health -= 20
			#print(health)
			canTakeDamage = false
			$takeDamageTimer.start()
			print("slime took damage")


func _on_deathTimer_timeout():
	self.queue_free()



func _on_takeDamageTimer_timeout():
	canTakeDamage = true

func updateHealth():
	var healthBar = $slimeHealth
	
	healthBar.value = health
	if	health >= 2000:
		healthBar.visible = false
	else:
		healthBar.visible = true

func deadCheck():
	if	health < 1 and health > -10000:
		$deathTimer.start()
		$AnimatedSprite.play("Death")
		$slimeHealth.visible = false
		health = -999999999
		
		
func spawnSlimes():
	if spawnSlimes == true and slimeTimer == true:
		var fireslime = fireSlime.instance()
		fireslime.position = $Slimespawn1.position
		Global.slimeSpawnPos = $Slimespawn1.position
		add_child(fireslime)
		slimeTimer = false

	
	
	


func _on_slime_hitbox_area_entered(area):
	if	area.has_method("player"):
		in_attack_zone = true
		print("slimesui")
	if	area.has_method("FireBall"):
		health -= 20
		print("fireball zombieHit")
		area.get_parent().queue_free()
		updateHealth()


func _on_slime_hitbox_area_exited(area):
	if	area.has_method("player"):
		in_attack_zone = false



func _on_Slimespawn_timer_timeout():
	slimeTimer = true
	$Slimespawntimer.start()
