class Alive
end

class Dead
end

# Represents a cell, it can be Alive or Dead
class Cell
	# Initialize the cell
	# == Parameters:
	# state::
	# 	Initial state of the cell (Alive or Dead)
	def initialize(state)
		@state = state
	end

	# == Returns:
	# A boolean, true if the cell is Alive otherwise returns false
	def is_alive?
		@state.instance_of?(Alive)
	end
end