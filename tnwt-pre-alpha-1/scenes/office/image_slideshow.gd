extends VBoxContainer

#=====объявление картинок, текста и переменных
@onready var images = [
	preload("res://assets/extra/map_with_text.png"),
	preload("res://assets/extra/ljksdnfjkldnsvjlnsjokldvn.png")
]
@onready var count_text = [
	"1/2",
	"2/2"
]
@onready var name_text = [
	"Hotel map",
	"Attacks map"
]
@onready var show_box = $screenersuperHD
@onready var counter = $b/abaluga
@onready var namey = $a/image/image_name
@onready var index = 0


#=========смена картинок и текста
func image_change(direction: int):
	index = (index + direction) % images.size()
	if index < 0:
		index = images.size() - 1
	show_box.texture = images[index]
	counter.text = count_text[index]
	namey.text = name_text[index]

func _on_prev_image_pressed() -> void:
	image_change(-1)

func _on_next_image_pressed() -> void:
	image_change(1)
