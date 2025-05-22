# fish_data.gd (Optional: A separate file for your data structure)
# This helps in organizing and type-hinting your data.
class_name FishData

var name: String
var size: int
var speed: int

func _init(p_name: String = "", p_size: int = 0, p_speed: int = 0):
	name = p_name
	size = p_size
	speed = p_speed

func to_dict() -> Dictionary:
	return {
		"name": name,
		"props": {
			"size": size,
			"speed": speed
		}
	}

static func from_dict(data: Dictionary) -> FishData:
	var fish_data = FishData.new()
	if data.has("name"):
		fish_data.name = data["name"]
	if data.has("props") and typeof(data["props"]) == TYPE_DICTIONARY:
		var props = data["props"]
		if props.has("size"):
			fish_data.size = props["size"]
		if props.has("speed"):
			fish_data.speed = props["speed"]
	return fish_data
