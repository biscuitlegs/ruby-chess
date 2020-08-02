require_relative "lib/chess.rb"

board = Board.new
#board.populate
board.place_piece("Rook", "e5")
board.place_piece("Pawn", "f6")
board.place_piece("Queen", "d6")
board.place_piece("Bishop", "d4")
board.place_piece("Knight", "f3")
board.show
p board.get_diagonal_moves("e5")