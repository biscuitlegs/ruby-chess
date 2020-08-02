require_relative "lib/chess.rb"

board = Board.new
board.setup
board.show
p board.get_square([9, 9])