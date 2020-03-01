extends KinematicBody2D


### constants ###

var collisionSize
var speed = 1000
var jump_power = 600
var screen_size
var jump_vector = Vector2()
var gravity_factor = 0.2
var gravity_velocity = 1


### shared vars ###

var velocity
var jumping


### constructor ###

func _init():
	pass


### functions ###

func _ready():
	screen_size = get_viewport_rect().size
	collisionSize = $CollisionShape2D.get_shape().get_extents()
	position.x = 10 + collisionSize.x
	position.y = screen_size.y - collisionSize.x


func _physics_process(delta):
	get_input(delta)
	velocity_modifiers(delta)
	player_animation()
	var collision = move_and_collide(velocity)
	if collision :
		velocity = 0
	


func get_input(delta):
	velocity = Vector2() # resets velocity every frame
	
	if is_on_floor():
		jumping = false
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_jump"):
		if is_on_floor() :
			jump()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed


func player_animation():
	if velocity.length() > 0:
		$AnimatedSprite.play()
		if velocity.x > 0:
			$AnimatedSprite.animation = "right"
		elif velocity.x < 0:
			$AnimatedSprite.animation = "left"
	else:
		$AnimatedSprite.stop()


func velocity_modifiers(delta):
	# set with frame data
	velocity = velocity * delta
	
	# jump speed
	var jump_speed = jump_vector.y/10
	if jumping :
		velocity.y -= jump_speed
		jump_vector.y -= jump_speed
	
	# add gravity
	gravity()
	velocity.y += gravity_velocity
	


func gravity():
	# gravity logic
	if !is_on_floor():
		gravity_velocity += gravity_velocity * gravity_factor
	else:
		gravity_velocity = 1


func jump():
	jumping = true
	jump_vector = Vector2()
	jump_vector.y = jump_power
