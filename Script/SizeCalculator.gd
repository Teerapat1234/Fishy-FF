extends Node

const max_player_size = 200
const  min_fish_size = float(0.25)
const max_fish_size = float(5)
var calorie : float
var requiredCalorie : float
var nextFishSize : float

func determine_size(fish_size : int) -> Vector2:
	var new_size = lerpf(min_fish_size, max_fish_size, float(fish_size)/100)
	return Vector2(new_size,new_size)

func initLevel():
	calorie = 0.0
	requiredCalorie = 100.0
	nextFishSize = 1.0
	pass

func calorieCalculation(hp : float, optional_addedCalorie = 0, optional_hungerSaturation = 1):
	calorie += ((hp + optional_addedCalorie) * optional_hungerSaturation)
	requiredCalorie = 1000
	print("required calorie = ", requiredCalorie)
	print(calorie)
	if(calorie > requiredCalorie):
		print("end game")
		GameManager.game_over()
	return calorie
