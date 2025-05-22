extends Fish
class_name EnemyFish

var distance_traveled : float = 0
var distance_to_end = 1920 + 500

func init_fish(player_size : int, parsedSize : int, parsedSpeed : float, parsedHp : int, parsedFishName : String):
	#Randomize fish values
	size = parsedSize
	speed = parsedSpeed
	hp = parsedHp
	fishName = parsedFishName

	move_speed = randf_range(1, 3)
	var min_size = clamp(player_size - 15, 1, SizeManager.max_player_size-1)
	var max_size = clamp(player_size + 15, 1, SizeManager.max_player_size-1)
	size = randi_range(min_size, max_size)
	text.text = str(size)
	self.scale = SizeManager.determine_size(size)
	turn() # Turn to face direction after spawning

func _process(delta):
	#Move across the screen
	position += direction * move_speed
	distance_traveled += direction.length() * move_speed
	if(distance_traveled > distance_to_end):
		queue_free()

func _on_body_entered(player : Fish):
	if(not player.is_in_group("player")): #Early exit if not player
		return
	#What happens when colliding with player.
	if(player.size > size):
		queue_free()
		var calorie : float = SizeManager.calorieCalculation(player.hunger, size)
		player.checkHunger(calorie)
	else:
		player.die()
