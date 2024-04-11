extends Node2D

var particlesInTheArea = []
var dependencies
var timer = randf()
var interval = 1
var beta = 0.4

func directionalVector(o1, o2):
	"""
	Calculates the directional vector from o1 to o2.

	Parameters:
	o1 (object): The first object with a 'position' attribute.
	o2 (object): The second object with a 'position' attribute.

	Returns:
	numpy.ndarray: The normalized directional vector pointing from o1 to o2.
	"""
	var directionalVector = (o2.position - o1.position).normalized()
	return directionalVector
	
func compare_distance(a, b):
	"""
	Compares the distances from a given position to objects 'a' and 'b'.

	Parameters:
	a (object): The first object with a 'position' attribute.
	b (object): The second object with a 'position' attribute.
	position (numpy.ndarray): The position from which distances are calculated.

	Returns:
	bool: True if the distance from 'position' to 'a' is greater than the distance
		  from 'position' to 'b', otherwise False.
	"""
	return position.distance_to(a.position) > position.distance_to(b.position)
	
func selectColour():
	"""
	Selects a color randomly from a predefined list of colors.

	Returns:
	tuple: A tuple representing the selected color. The tuple contains:
		   - The color code as a string ('R', 'G', 'B', 'Y').
		   - The corresponding Color object representing the RGB values of the color.
	"""
	var random_value = randi() % 4
	var selectedColour = ["R", Color(1, 0, 0)]
	match random_value:
		1: selectedColour = ["G", Color(0, 1, 0)]
		2: selectedColour = ["B", Color(0, 0, 1)]
		3: selectedColour = ["Y", Color(1, 1, 0)]
	return selectedColour
	
func _ready():
	var colour = selectColour()
	self.set_meta("colour", colour[0])
	dependencies = get_parent().get_meta("dependencyMatrix")[colour[0]]
	$Sprite2D.modulate = colour[1]

func _process(delta):
	var acceleration = Vector2(0,0)
	for particle in particlesInTheArea:
		var direction = directionalVector(self, particle)
		var particle_colour = particle.get_meta("colour")
		var dependency = dependencies[particle_colour]
		var r = position.distance_to(particle.position)/5000
		if r > beta:
			acceleration += direction * dependency * (1 - abs(2 * r - 1 - beta)/(1 - beta))
		else:
			acceleration += direction * (r/beta - 1)
	self.linear_velocity += acceleration * delta * 2500 - 0.1 * self.linear_velocity
	
	if abs(self.position.x) >= 30000:
		self.position.x = -self.position.x + abs(self.position.x)/self.position.x * 100
	if abs(self.position.y) >= 20000:
		self.position.y = -self.position.y + abs(self.position.y)/self.position.y * 100
	
func _on_area_2d_body_entered(body):
	if body != self:
		particlesInTheArea.append(body)

func _on_area_2d_body_exited(body):
	var index = particlesInTheArea.find(body)
	particlesInTheArea.pop_at(index)
