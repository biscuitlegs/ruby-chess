require_relative "lib/chess.rb"

board = Board.new
#board.setup

board.squares[3][3].piece = Piece::King.new
board.squares[3][2].piece = Piece::Queen.new("White")
board.squares[4][4].piece = Piece::Queen.new("White")
board.squares[3][4].piece = Piece::Queen.new
board.squares[2][3].piece = Piece::Queen.new

board.squares[4][3],
board.squares[4][2],
board.squares[2][2],
board.squares[2][4],
board.squares[3][2],
board.squares[4][4],

board.show
p board.get_moves("d4")