require_relative "lib/chess.rb"

board = Board.new
#board.setup
board.place_piece("Knight", "e5")
board.place_piece("Pawn", "f3")
board.place_piece("King", "f7")
board.place_piece("Queen", "f6")
board.place_piece("Bishop", "f4")
board.place_piece("Bishop", "d6")
board.place_piece("Queen", "d4")

board.show
p board.get_diagonal_moves("e5", 1)
