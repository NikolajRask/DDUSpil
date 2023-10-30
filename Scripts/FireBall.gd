extends KinematicBody2D

const speed = 200
var velocity = Vector2()
var spawnDir = "none"
var hitCheck = false

func _ready():
	spawnDir = Global.playerDIR
	if	spawnDir == "none":
		$AnimatedSprite.rotate(-1.5)
	if	spawnDir == "back":
		$AnimatedSprite.rotate(1.5)
	if	spawnDir == "left":
		
		$AnimatedSprite.flip_h = false
	if	spawnDir == "right":
		
		$AnimatedSprite.flip_h = true
func _physics_process(delta):
	
	print(spawnDir)
	if	spawnDir == "none":
		velocity.y = speed * delta
		translate(velocity)
	if	spawnDir == "back":
		velocity.y = -speed * delta
		translate(velocity)
		$AnimatedSprite
	if	spawnDir == "left":
		velocity.x = -speed * delta
		translate(velocity)
		$AnimatedSprite.flip_h = false
	if	spawnDir == "right":
		velocity.x = speed * delta
		translate(velocity)
		$AnimatedSprite.flip_h = true

func flipSprite():
	if spawnDir == "none":
		pass
	

	"""
	if	spawnDir == "none":
		velocity.y = speed * delta
		translate(velocity)
	if	spawnDir == "back":
		velocity.y = -speed * delta
		translate(velocity)
	if	spawnDir == "left":
		velocity.x = -speed * delta
		translate(velocity)
		$AnimatedSprite.flip_h = false
	if	spawnDir == "right":
		velocity.x = speed * delta
		translate(velocity)
		$AnimatedSprite.flip_h = true
		"""


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	






