require_relative "lib/chess.rb"

board = Board.new
#board.populate
board.place_piece("Rook", "e5")
board.place_piece("Pawn", "f6")
board.place_piece("Queen", "g7")
board.place_piece("Bishop", "h8")
board.show
p board.get_diagonal_moves("a1")