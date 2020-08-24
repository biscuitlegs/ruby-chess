require_relative "lib/chess.rb"

board = Board.new
board.setup

board.place_piece("Bishop", "d4")
board.place_piece("Knight", "c5")


board.show
p board.get_moves("d4")
