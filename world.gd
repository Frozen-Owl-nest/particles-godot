extends Node2D

var particle = preload('res://particle.tscn')

func _ready():
	for i in range(200):
		var newParticle = particle.instantiate()
		var coordinates = Vector2(randi() % 60000 - 30000, randi() % 40000 - 20000)
		newParticle.position = coordinates
		self.add_child(newParticle)
	
