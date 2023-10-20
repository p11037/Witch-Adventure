extends CharacterBody2D

var speed = 200
var damage = 10

func _physics_process(delta):
	var collision_info = move_and_collide(Vector2(0, -1).normalized() * speed * delta)

	if collision_info:
		var collided_object = collision_info.get_collider()

		if collided_object is Node: # ตรวจสอบว่าชนกับ Node ใดๆ ก็ได้
			queue_free()

	# หากต้องการทำอย่างอื่นเพิ่มเติมทำต่อที่นี้


func _on_player_collision_body_entered(body):
	if body.name == "player":
		Game.playerHP -= 2
