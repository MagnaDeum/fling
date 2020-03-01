extends KinematicBody2D


### constants ###

var collisionSize
var speed = 1000
var jump_power = 600
var screen_size
var jump_vector = Vector2()
var gravity_factor = 0.2
var gravity_velocity = 0

### shared vars ###

var velocity
var jumping = false
var next_to_wall = false
# prev values to limit acceleration
var oldX
var oldY


### constructor ###

func _init():
	pass


### functions ###

func _ready():
	screen_size = get_viewport_rect().size
	collisionSize = $CollisionShape2D.get_shape().get_extents()
	position.x = 10 + collisionSize.x
	position.y = screen_size.y - collisionSize.y
	oldX = 0
	oldY = 0


func _physics_process(delta):
	
	get_input(delta)
	velocity_modifiers(delta)
	player_animation()
	
	# hard limit on speed
	if abs(velocity.x - oldX) > 50 :
		velocity.x = velocity.x /2
	if abs(velocity.y - oldY) > 50:
		velocity.y = velocity.y /2
	oldX = velocity.x
	oldY = velocity.y
	
	var collision = move_and_collide(velocity)
	# check if in the air
	if collision :
		jumping = false
		if collision.get_normal().x == 1 || collision.get_normal().x == -1:
			next_to_wall = true
			jump_vector = Vector2() # dont buffer jump while wall riding
	else:
		# no collision = airborne
		next_to_wall = false
		jumping = true
	
	


func get_input(delta):
	velocity = Vector2() # resets velocity every frame
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_jump"):
		if !jumping && !next_to_wall:
			jump()
	if Input.is_action_pressed("ui_up"):
		if next_to_wall:
			velocity.y -= 1
			
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
	elif !next_to_wall:
		velocity.y = 0
		jump_vector.y = 0
	elif next_to_wall:
		velocity.y = velocity.y * 20
	
	gravity()
	

func gravity():
	# gravity logic
	if jumping:
		if gravity_velocity == 0:
			gravity_velocity = 1 # don't get stuck multiplying by 0
		gravity_velocity += gravity_velocity * gravity_factor
	else:
		gravity_velocity = 0
	
	velocity.y += gravity_velocity


func jump():
	jumping = true
	jump_vector = Vector2()
	jump_vector.y = jump_power

