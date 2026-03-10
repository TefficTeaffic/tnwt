extends TextureRect

#=========объявление страниц блокнота
@onready var main = $notepad_main
@onready var attacks = $notepad_attacks
@onready var about = $notepad_about
@onready var extra = $notepad_extra

#==============кнопки в меню
func _on_attacks_notepad_button_pressed() -> void:
	main.visible = !main.visible
	attacks.visible = !attacks.visible

func _on_about_notepad_button_pressed() -> void:
	main.visible = !main.visible
	about.visible = !about.visible

func _on_extra_notepad_button_pressed() -> void:
	main.visible = !main.visible
	extra.visible = !extra.visible

#===кнопка возвращения на главную блокнота
func _on_back_to_notepad_button_pressed() -> void:
	if attacks.visible == true:
		main.visible = !main.visible
		attacks.visible = !attacks.visible
		
	else: if about.visible == true:
		main.visible = !main.visible
		about.visible = !about.visible
		
	else:
		main.visible = !main.visible
		extra.visible = !extra.visible
