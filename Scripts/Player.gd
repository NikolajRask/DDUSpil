extends KinematicBody2D

var speed = 100
var motion = Vector2.ZERO
var currentdir = "none"

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var Health = 100
var player_alive = true
var attack_ip = false
var enemyType = null

var FireBall = preload("res://Scenes/FireBall.tscn")
var Mana = 100

func _process(delta):
	if Health <=10:
		get_tree().change_scene("res://DeathScreen.tscn")
		Health = 100

func _physics_process(delta):
	player_movement(delta);
	enemy_attack();
	attack();
	updateHealth();
	updateMana();
	if Health <= 0:
		player_alive = false #alex endscreen
		Health = 0
	Global.playerDIR = currentdir
	
	if Input.is_action_just_pressed("FireBall") and Mana >=50:
		var fireball = FireBall.instance()
		fireball.position = position
		get_parent().add_child(fireball)
		Mana -= 50
		

# warning-ignore:unused_argument
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		currentdir = "right"
		motion.x = speed
		motion.y = 0
		playeranim(1);
	elif Input.is_action_pressed("ui_left"):
		currentdir = "left"
		motion.x = -speed
		motion.y = 0
		playeranim(1);
	elif Input.is_action_pressed("ui_down"):
		currentdir = "none"
		motion.y = speed
		motion.x = 0
		playeranim(1);
	elif Input.is_action_pressed("ui_up"):
		currentdir = "back"
		motion.y = -speed
		motion.x = 0
		playeranim(1);
	else:
		motion.x = 0
		motion.y = 0
		playeranim(0);
# warning-ignore:return_value_discarded
	move_and_slide(motion)
func playeranim(movement):
	var dir = currentdir;
	
	if dir == "right":
		$AnimatedSprite.flip_h = false
		if movement == 1:
			$AnimatedSprite.play("Sidewalk")
		elif movement == 0:
			if	attack_ip == false:
				$AnimatedSprite.play("SideIdle")
	if dir == "left":
		$AnimatedSprite.flip_h = true
		if movement == 1:
			$AnimatedSprite.play("Sidewalk")
		elif movement == 0:
			if	attack_ip == false:
				$AnimatedSprite.play("SideIdle")
	if dir == "back":
		if movement == 1:
			$AnimatedSprite.play("Backwalk")
		elif movement == 0:
			if	attack_ip == false:
				$AnimatedSprite.play("BackIdle")
	if dir == "none":
		$AnimatedSprite.flip_h = false
		if movement == 1:
			$AnimatedSprite.play("Frontwalk")
		elif movement == 0:
			if	attack_ip == false:
				$AnimatedSprite.play("FrontIdle")
		



func player():
	pass


func _on_player_hitbox_area_entered(area):
	if	area.has_method("enemy"):
		enemy_inattack_range = true
		if	area.has_method("slime"):
			enemyType = "slime"
		elif		area.has_method("zombie"):
			enemyType = "zombie"
		elif		area.has_method("fireTrail"):
			enemyType = "fireTrail"




func _on_player_hitbox_area_exited(area):
	if	area.has_method("enemy"):
		enemy_inattack_range = false
	
		
func enemy_attack():
	if	enemy_inattack_range and enemy_attack_cooldown == true:
		enemy_attack_cooldown = false
		$slimeCooldown.start();
		$playerRegen.start();
		print("took damage")
		print(enemyType)
		if	enemyType == "slime":
			Health -= 10
			print("slimeattack")
			print(Health)
		elif		enemyType == "zombie":
			Health -= 20
			print("zombieattack")
			print(Health)
		elif		enemyType == "fireTrail":
			Health -= 5
			print("fireBurn")
			print(Health)
		

func attack():
	var dir = currentdir

	if Input.is_action_just_pressed("attack") and attack_ip == false:
		Global.player_current_attack = true
		attack_ip = true

		if dir == "right":
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Sideattack")
			$playerAttack.start()
		elif dir == "left":
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Sideattack")
			$playerAttack.start()
		elif dir == "back":
			$AnimatedSprite.play("Backattack")
			$playerAttack.start()
		elif dir == "none":
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Frontattack")
			$playerAttack.start()

func _on_playerAttack_timeout():
	$playerAttack.stop()
	Global.player_current_attack = false
	attack_ip = false

	# Return to idle animation when the attack animation is complete
	if currentdir == "right" and not enemy_inattack_range:
		$AnimatedSprite.play("SideIdle")
	elif currentdir == "left" and not enemy_inattack_range:
		$AnimatedSprite.play("SideIdle")
	elif currentdir == "back" and not enemy_inattack_range:
		$AnimatedSprite.play("BackIdle")
	elif currentdir == "none" and not enemy_inattack_range:
		$AnimatedSprite.play("FrontIdle")


func _on_slimeCooldown_timeout():
	enemy_attack_cooldown = true


func updateHealth():
	var healthBar = $playerhealth
	
	healthBar.value = Health
	if	Health >= 100:
		#healthBar.visible = false
		pass
	else:
		healthBar.visible = true
func updateMana():
	var manaBar = $playerMana
	manaBar.value = Mana

func _on_playerRegen_timeout():
	if	Health < 100:
		Health += 20
		if	Health > 100:
			Health = 100
	elif Health <= 0:
		Health = 0
	


func _on_Timer_timeout():#ManaTimer
	Mana += 1
	if Mana > 100:
		Mana = 100
	$ManaTimer.start()
	
	
