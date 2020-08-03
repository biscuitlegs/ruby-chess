require_relative "lib/chess.rb"

board = Board.new
#board.setup
board.place_piece("Knight", "e5")
#board.place_piece("Pawn", "f3")
#board.place_piece("King", "f7")
board.place_piece("Queen", "d3")
board.place_piece("Bishop", "d7")
board.place_piece("Bishop", "c6")
board.place_piece("Knight", "g6")
board.place_piece("Queen", "g4")
board.place_piece("King", "c4")

board.show
p board.get_knight_moves("e5")
