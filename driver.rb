require_relative "lib/chess.rb"

board = Board.new
#board.setup
board.place_piece("King", "g8")
board.place_piece("King", "h6")
board.place_piece("Queen", "e6")
board.get_square("h6").piece.color = "White"
board.get_square("e6").piece.color = "White"
#board.place_piece("Rook", "h6")
#board.place_piece("Rook", "h7")
#board.place_piece("Rook", "g4")
#board.place_piece("Rook", "f4")
#board.move_piece("h8", "a5")
board.show
p board.stalemated?("g8")
#board.move_piece("d5", "c1")
#p board.in_check?("d4")

