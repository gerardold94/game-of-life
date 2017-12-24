require "./cell"

STATES = [Dead.new, Alive.new]

class Game
	attr_reader :gameboard

	def initialize(rows, cols, grid=nil)
		@rows, @cols = rows, cols
    # If there is a grid, initialize the board based on it
		if grid != nil
			@gameboard = Array.new(rows) { Array.new(cols) }
			grid.each_with_index { |r, ri| r.each_with_index { |c, ci| @gameboard[ri][ci] = Cell.new(STATES[c]) } }
		else
      # If there is no grid, initialize the board with a random state
			@gameboard = Array.new(rows) { Array.new(cols, Cell.new(STATES[rand(0..1)])) }
		end
	end

  # Verify that a cell has a valid position on the board
  #
  # == Parameters:
  # x::
  #   The cell's row
  # y::
  #   The cell's column
  #
  # == Returns:
  # A boolean, true if the position is valid otherwise return false
	def into_range(x, y)
		x.between?(0, @rows-1) and y.between?(0, @cols-1)
	end

  # Count the number of living neighbors of a cell
  #
  # == Parameters:
  # row::
  #   The cell's row
  # col::
  #   The cell's column
  #
  # == Returns:
  # An integer that represents the total number of living neighbors
	def count_neighbors(row, col)
    # Positions of all possible neighbors of a cell
		distance = [[0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, 0], [1, -1], [1, 1]]
		total = 0

    # Count the living neighbors of every cell
		for r, c in distance
			if into_range(r + row, c + col)
				total += @gameboard[r + row][c + col].is_alive? ? 1 : 0
			end
		end
		total
	end

  # Creates the next generation of the board
	def next
    # Create copy of actual state of the game
		new_game = Marshal.load(Marshal.dump(@gameboard))
    new_game.each_with_index do |r, ri|
      r.each_with_index do |cell, ci|
        # Calculating the number of living neighbors
        neighbors = count_neighbors(ri, ci)
        # Rule 1: Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
        # Rule 3: Any live cell with more than three live neighbours dies, as if by overpopulation
        if (neighbors < 2 or neighbors > 3) and cell.is_alive?
          new_game[ri][ci] = Cell.new(Dead.new)
        # Rule 4: Any dead cell with exactly three live neighbours
        # becomes a live cell, as if by reproduction
        elsif neighbors == 3 and not cell.is_alive?
          new_game[ri][ci] = Cell.new(Alive.new)
        # Rule 2: Any live cell with two or three live neighbours
        # lives on to the next generation. (It is not necessary)
        # elsif neighbors > 2 and cell.is_alive?
        #   new_game[ri][ci] = Cell.new(Alive.new)
        end
      end
    end
		@gameboard = new_game.clone
	end

  # Create a board on a binary basis (0, 1)
	def to_binary
    new_game = Marshal.load(Marshal.dump(@gameboard))
		for r in (0..@rows-1)
			for c in (0..@cols-1)
        new_game[r][c] = (new_game[r][c].is_alive?) ? 1 : 0
			end
		end
    new_game
	end

	def draw
		for row in @gameboard
      print " "
			for cell in row
				print "@ " if cell.is_alive?
				print ". " unless cell.is_alive?
			end
			puts ""
		end
	end
end