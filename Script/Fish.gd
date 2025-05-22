extends Node2D
class_name Fish

#Base class for all fish, player and enemy
var starting_position : Vector2
var size : int
var direction : Vector2
var speed : float
var hp : float
var fishName : String
var hunger : float
@export var move_speed = 100.0
@export var text : Label
@export var sprite : Sprite2D
@export var debug = false

func _ready():
	if(debug == true):
		text.visible = true
	else:
		text.visible = false
	pass # Replace with function body.
func turn():
	#Turn based on our current direction, look left or right
	if(direction.x < 0):
		sprite.flip_h = false
	elif(direction.x > 0):
		sprite.flip_h = true
func checkHunger(calorie: float, optional_requiredCalorie = 100):
	hunger += calorie
	if(hunger > optional_requiredCalorie * 0.667):
		#size += nextFishSize + 1
		print("increase size")
		grow(10)
	pass
func grow(newSize : float):
	#Grow when eating an enemy-fish
	size += newSize
	text.text = str(size)
	var new_scale = SizeManager.determine_size(size)
	#Animate grow effect
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(new_scale.x + 0.1, new_scale.y + 0.1), 0.4)
	tween.tween_property(self, "scale", new_scale, 0.4)
