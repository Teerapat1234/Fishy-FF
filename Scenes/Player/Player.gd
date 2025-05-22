extends Fish

signal player_died
@export var player_body : CharacterBody2D
var edge_of_screen := Vector2(1920,1080)
var fish_velocity : Vector2
@export var acceleration = 10

func _ready():
	super() #Calls the _ready() on fish.gd
	start()

func _physics_process(delta):
	turn()
	move_player(delta) #Player movement
	position.x = clampf(position.x, 0, edge_of_screen.x) #Clamp within border window
	position.y = clampf(position.y, 0, edge_of_screen.y) #Clamp within border window
	
func move_player(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(direction == Vector2.ZERO):
		fish_velocity = fish_velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		fish_velocity = fish_velocity.move_toward(direction * move_speed, acceleration * delta)
	player_body.velocity = fish_velocity
	player_body.move_and_slide()
func die():
	player_died.emit()
	queue_free() # Remove after this frame
	GameManager.game_over()
#Called once on start to init
func start():
	show()
	set_process(true)
	size = 5;
	text.text = str(size)
	self.scale = SizeManager.determine_size(size)
