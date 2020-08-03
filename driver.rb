require_relative "lib/chess.rb"

board = Board.new
#board.setup
board.place_piece("Queen", "e5")
board.place_piece("King", "f4")
board.place_piece("Knight", "f6")
board.place_piece("Pawn", "d4")
board.place_piece("Bishop", "d6")
board.place_piece("pawn", "h2")
board.place_piece("pawn", "h8")
board.place_piece("pawn", "a1")
board.place_piece("pawn", "b8")
board.show
p board.get_diagonal_moves("e5")
