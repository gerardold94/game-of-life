require "test/unit"
require "./game"

class GameboardTest < Test::Unit::TestCase
	def test_grid_should_five_rows_and_five_columns
		game = Game.new(5, 5)
		assert_equal 5, game.gameboard.size
		assert_equal 5, game.gameboard[0].size
	end

	def test_cell_alive
		game = Game.new(5, 5)
		game.gameboard[0][0] = Cell.new(Alive.new)
		assert_equal true, game.gameboard[0][0].is_alive?
	end

	def test_cell_is_dead
		game = Game.new(5, 5)
		game.gameboard[0][0] = Cell.new(Dead.new)
		assert_equal false, game.gameboard[0][0].is_alive?
	end

	def test_cell_is_in_valid_range
		game = Game.new(5, 5)
		assert_equal true, game.into_range(3, 4)
		assert_equal true, game.into_range(1, 2)
		assert_equal true, game.into_range(0, 0)
	end

	def test_cell_is_not_in_valid_range
		game = Game.new(5, 5)
		assert_equal false, game.into_range(5, 1)
		assert_equal false, game.into_range(5, 5)
		assert_equal false, game.into_range(6, 0)
	end

	def test_cell_has_two_alive_neighbors
		grid = [
			[0, 0, 0, 0, 0],
			[1, 1, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 1, 1, 1],
			[0, 0, 1, 0, 0]
		]
		game = Game.new(5, 5, grid)
		assert_equal 2, game.count_neighbors(0, 0)
		assert_equal 2, game.count_neighbors(3, 1)
		assert_equal 2, game.count_neighbors(4, 4)
	end

	def test_cell_has_zero_alive_neighbors
		grid = [
			[0, 0, 0, 0, 1],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 1, 0, 1],
			[0, 0, 0, 0, 0]
		]
		game = Game.new(5, 5, grid)
		assert_equal 0, game.count_neighbors(0, 0)
		assert_equal 0, game.count_neighbors(3, 2)
		assert_equal 0, game.count_neighbors(0, 4)
		assert_equal 0, game.count_neighbors(3, 4)
	end

	def test_next_generation_is_correct
		grid = [
			[1, 0, 1, 0, 1],
      [0, 1, 0, 1, 0],
      [1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		]
    new_generation = [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
    game = Game.new(5, 5, grid)
    game.next
    assert_equal game.to_binary, new_generation
	end
end