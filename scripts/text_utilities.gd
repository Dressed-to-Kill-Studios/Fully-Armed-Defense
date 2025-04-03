extends Resource
class_name TextUtilities

const CHARACTER_LOOK_UP = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:<>?/"


static func encrypt_text(input_text: String, start_index: int = 0, end_index: int = -1) -> String:
	if input_text.is_empty() \
	or start_index < 0:
		push_error("Invalid input or range.")
		return input_text
	
	var encrypted_text: PackedStringArray = input_text.split()
	var range: Array = range(start_index, end_index + 1) if end_index > -1 else range(start_index, input_text.length())
	
	for index in range as Array[int]:
		if index >= encrypted_text.size(): break
		
		var random_character: String = CHARACTER_LOOK_UP[randi() % CHARACTER_LOOK_UP.length()]
		if bool(round(randf())): random_character.to_upper() #Coin flip
		
		encrypted_text[index] = random_character
	
	return "".join(encrypted_text)
