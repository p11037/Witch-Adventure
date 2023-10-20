extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -430.0
var jumping = false
@onready var anim = get_node("AnimatedSprite2D")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attacking = false
var MAX_ATTACK_COUNT = 5
var attackCount = 3

# เพิ่ม RayCast2D
@onready var RightRaycast : RayCast2D = $RightRayCast2D
@onready var LeftRaycast : RayCast2D = $LeftRayCast2D2

func _ready():
	anim.play("idle")
	$AttackCollisionShape2D2.disabled = true

func _physics_process(delta):
	if not attacking:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
			get_node("AttackArea/CollisionShape2D").position = Vector2(-32,15)
		elif direction == 1: 
			get_node("AnimatedSprite2D").flip_h = false
			get_node("AttackArea/CollisionShape2D").position = Vector2(88,15)

		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("idle")

		if Input.is_action_just_pressed("ui_accept"):
			if not jumping and not attacking:
				velocity.y = JUMP_VELOCITY
				anim.play("charge")
				jumping = true

		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			jumping = false

		if Input.is_action_pressed("ui_down") and is_on_floor() and attackCount != 0:
			if not ((LeftRaycast.is_colliding()) or RightRaycast.is_colliding()):
				anim.play("attack")
				attacking = true
				attackCount -= 1
				$CollisionShape2D.disabled = true
				$AttackCollisionShape2D2.disabled = false
				$AttackArea/CollisionShape2D.disabled = false

		move_and_slide()

	if Game.playerHP <= 0:
		queue_free() 
		get_tree().change_scene_to_file("res://main.tscn")

	if attackCount <= 0 :
		attackCount = 0

func _on_animated_sprite_2d_animation_finished():
	if get_node("AnimatedSprite2D").animation == "attack":
		$AttackArea/CollisionShape2D.disabled = true 
		$CollisionShape2D.disabled = false
		$AttackCollisionShape2D2.disabled = true
		get_node("AnimatedSprite2D").play("idle")
		if attacking:
			attacking = false

	if get_node("AnimatedSprite2D").animation == "charge":
		get_node("AnimatedSprite2D").play("idle")
	
	if get_node("AnimatedSprite2D").animation == "take_damage":
		get_node("AnimatedSprite2D").play("idle")

func increment_attack_count():
	if not attacking:
		attackCount += 1
		if attackCount >= MAX_ATTACK_COUNT:
			attackCount = MAX_ATTACK_COUNT

func can_attack():
	return attackCount < MAX_ATTACK_COUNT and not attacking

# เพิ่มฟังก์ชันใหม่เพื่อระบุว่ากำลังโจมตีหรือไม่
func set_attacking(attacking_state):
	attacking = attacking_state


