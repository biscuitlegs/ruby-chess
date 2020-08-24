require_relative "lib/chess.rb"

board = Board.new
#board.setup


board.place_piece("Knight", "d4")
board.squares[5][4].piece = Piece::Bishop.new("White")
#make pieces able to move to square if it has a piece of enemy color
p board.get_moves("d4")
board.show

