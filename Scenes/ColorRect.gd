extends ColorRect


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible




func _on_Button_pressed():
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible
