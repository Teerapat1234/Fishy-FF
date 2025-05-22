# Your main scene script (e.g., attached to a Node2D)
extends Node

@onready var json_data_label: Label = $JSONDataLabel # Assuming you have a Label node in your scene
@onready var parsed_data_label: Label = $ParsedDataLabel # Another Label
@onready var stored_data_label: Label = $StoredDataLabel # Another Label

# An example of the JSON data as a string
const EXAMPLE_JSON_STRING: String = """
{
	"name": "Trout",
	"props": {
		"size": 5,
		"speed": 10
	}
}
"""

# Another example JSON block (for demonstration of multiple items)
const ANOTHER_EXAMPLE_JSON_STRING: String = """
{
	"name": "Salmon",
	"props": {
		"size": 8,
		"speed": 12
	}
}
"""

# An array to store our parsed FishData objects
var _all_fish_data: Array[FishData] = []

func _ready() -> void:
	# 1. Display the raw JSON string
	if json_data_label:
		json_data_label.text = "Raw JSON:\n" + EXAMPLE_JSON_STRING

	# 2. Fetch and parse the first JSON block
	print("--- Parsing First JSON Block ---")
	var parsed_trout_data: Dictionary = parse_json_data(EXAMPLE_JSON_STRING)
	if parsed_trout_data.empty():
		return # Exit if parsing failed

	# 3. Store the parsed data
	store_fish_data(parsed_trout_data)

	# 4. Fetch and parse the second JSON block
	print("\n--- Parsing Second JSON Block ---")
	var parsed_salmon_data: Dictionary = parse_json_data(ANOTHER_EXAMPLE_JSON_STRING)
	if parsed_salmon_data.empty():
		return # Exit if parsing failed

	# 5. Store the second parsed data
	store_fish_data(parsed_salmon_data)

	# 6. Display all stored data
	display_stored_fish_data()

	# 7. Demonstrate saving and loading to/from a file (optional)
	save_all_fish_data_to_file("user://fish_data.json")
	_all_fish_data.clear() # Clear current data to demonstrate loading
	load_all_fish_data_from_file("user://fish_data.json")
	print("\n--- After Loading from File ---")
	display_stored_fish_data()

func parse_json_data(json_string: String) -> Dictionary:
	var parsed_result = JSON.parse_string(json_string)

	if parsed_result == null:
		print_err("Failed to parse JSON string: " + json_string)
		if parsed_data_label:
			parsed_data_label.text = "Parsing Error: Invalid JSON"
		return {}

	# Check if the parsed result is a Dictionary (or Array, depending on your JSON root)
	if typeof(parsed_result) == TYPE_DICTIONARY:
		print("Successfully parsed JSON:")
		print(parsed_result)
		if parsed_data_label:
			parsed_data_label.text = "Parsed Data (Dictionary):\n" + str(parsed_result)
		return parsed_result
	else:
		print_err("JSON parsed successfully but is not a Dictionary: " + json_string)
		if parsed_data_label:
			parsed_data_label.text = "Parsing Error: JSON is not a Dictionary"
		return {}

func store_fish_data(data: Dictionary) -> void:
	# Convert the raw dictionary into our custom FishData object
	var fish = FishData.from_dict(data)
	_all_fish_data.append(fish)
	print(f"Stored fish: {fish.name} (Size: {fish.size}, Speed: {fish.speed})")

func display_stored_fish_data() -> void:
	var display_text = "Stored Fish Data:\n"
	if _all_fish_data.is_empty():
		display_text += "No fish data stored."
	else:
		for fish in _all_fish_data:
			display_text += f" - Name: {fish.name}, Size: {fish.size}, Speed: {fish.speed}\n"
	print(display_text)
	if stored_data_label:
		stored_data_label.text = display_text

func save_all_fish_data_to_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		print_err("Failed to open file for writing: " + file_path)
		return

	var data_to_save: Array = []
	for fish in _all_fish_data:
		data_to_save.append(fish.to_dict()) # Convert FishData objects back to dictionaries

	var json_string = JSON.stringify(data_to_save, "\t") # "\t" for pretty printing
	file.store_string(json_string)
	file.close()
	print(f"Successfully saved {_all_fish_data.size()} fish records to {file_path}")

func load_all_fish_data_from_file(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		print_err("File not found: " + file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print_err("Failed to open file for reading: " + file_path)
		return

	var json_string = file.get_as_text()
	file.close()

	var parsed_result = JSON.parse_string(json_string)

	if parsed_result == null:
		print_err("Failed to parse JSON from file: " + file_path)
		return

	if typeof(parsed_result) == TYPE_ARRAY:
		_all_fish_data.clear() # Clear existing data before loading
		for item_dict in parsed_result:
			if typeof(item_dict) == TYPE_DICTIONARY:
				var fish = FishData.from_dict(item_dict)
				_all_fish_data.append(fish)
		print(f"Successfully loaded {_all_fish_data.size()} fish records from {file_path}")
	else:
		print_err("Loaded JSON is not an Array of Dictionaries: " + file_path)
