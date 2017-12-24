require "./game"

game = Game.new(30, 30)
while true
	puts ""
	game.draw
	game.next
	sleep(0.4)
	Gem.win_platform? ? (system "cls") : (system "clear")
end