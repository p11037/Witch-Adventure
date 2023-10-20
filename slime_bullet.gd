extends CharacterBody2D


var player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bullet_scene = preload("res://bullet.tscn") 
var shoot_interval = 1 
var shoot_timer = 0

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
func _ready():
	get_node("AnimatedSprite2D").play("idle")
	set_process(true)
	
func _process(delta):
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0
		shoot()	
func shoot():
	var bullet = bullet_scene.instantiate()
	var bullet_position = global_position + Vector2(0, -25)  # เพิ่มค่า x และ y ที่ต้องการ
	bullet.global_position = bullet_position
	get_parent().add_child(bullet)


func _on_player_death_body_entered(body):
	if body.name == "player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "player":
		Game.playerHP -= 3


func death():
	Game.Point += 1
	Utils.saveGame()
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()


func _on_player_collision_area_entered(area):
	if area.is_in_group("Power"):
		velocity.y = -300
		death()
