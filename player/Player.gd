extends Area2D


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
var groundY


### constructor ###

func _init():
	pass



### functions ###

func _ready():
	screen_size = get_viewport_rect().size
	collisionSize = $CollisionShape2D.get_shape().get_extents()
	position.x = 10 + collisionSize.x
	position.y = screen_size.y - collisionSize.y
	groundY = screen_size.y - collisionSize.y


func _process(delta):
	velocity = Vector2() # resets velocity every frame
	player_control(delta)
	player_animation()
	gravity()
	set_position_with_speed(delta)


func player_control(delta):
	# for some reason, groundY is slightly smaller than position (probably clamps fault)
	if position.y > groundY-1 :
		jumping = false
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_jump"):
		if !jumping :
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


func set_position_with_speed(delta):
	# set with speed
	position += velocity * delta
	
	# jump speed
	var jump_speed = jump_vector.y/10
	if jumping :
		position.y -= jump_speed
		jump_vector.y -= jump_speed
	
	# add gravity
	position.y += gravity_velocity
	
	# clamp to screen
	position.x = clamp(position.x, 0 + collisionSize.x, screen_size.x - collisionSize.x)
	position.y = clamp(position.y, 0 + collisionSize.y, groundY)


func gravity():
	# gravity logic
	if jumping:
		gravity_velocity += gravity_velocity * gravity_factor
	else:
		gravity_velocity = 1


func jump():
	jumping = true
	jump_vector = Vector2()
	jump_vector.y = jump_power
