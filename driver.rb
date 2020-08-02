require_relative "lib/chess.rb"

board = Board.new
#board.populate
board.place_piece("Rook", "e5")
board.show
