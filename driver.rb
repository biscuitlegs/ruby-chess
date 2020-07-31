require_relative "lib/chess.rb"

board = Board.new
board.place_piece("pawn", "A1")
board.show
board.move_piece("a1", "z4")
puts ""
board.show