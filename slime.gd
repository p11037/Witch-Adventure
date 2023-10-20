extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 30
var player
var chase = false


#var bullet_scene = preload("res://bullet.tscn") 
#var shoot_interval = 1 
#var shoot_timer = 0

func _ready():
	get_node("AnimatedSprite2D").play("idle")

#	set_process(true)
	
#func _process(delta):
#	shoot_timer += delta
#	if shoot_timer >= shoot_interval:
#		shoot_timer = 0
#		shoot()	
#func shoot():
#	var bullet = bullet_scene.instantiate()
#	var bullet_position = global_position + Vector2(0, -25)  # เพิ่มค่า x และ y ที่ต้องการ
#	bullet.global_position = bullet_position
#	get_parent().add_child(bullet)
			
func _physics_process(delta):
	velocity.y += gravity * delta
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("run")
		player = get_node("../../player/player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = false
		else:
			get_node("AnimatedSprite2D").flip_h = true
		velocity.x = direction.x * SPEED
	else :
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0
	move_and_slide()
	
func _on_player_detection_body_entered(body):
	if body.name == "player":
		chase = true
#		print("player")


func _on_player_detection_body_exited(body):
	if body.name == "player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "player":
		Game.playerHP -= 3


func death():
	Game.Point += 1
	Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()


func _on_player_collision_area_entered(area):
	pass
#	if area.is_in_group("Power"):
#		velocity.y = -300
#		get_node("AnimatedSprite2D").play("Death")
#		await get_node("AnimatedSprite2D").animation_finished
#		self.queue_free()


func _on_player_death_area_entered(area):
	if area.is_in_group("Power"):
		velocity.y = -300
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
