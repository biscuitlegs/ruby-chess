require_relative "lib/chess.rb"

board = Board.new
board.setup

board.place_piece("King", "a4")
board.place_piece("King", "a4")
#board.get_square("h5").piece.color = "White"
#board.place_piece("Rook", "h6")
#board.place_piece("Rook", "h7")
#board.place_piece("Rook", "g4")
#board.place_piece("Rook", "f4")
#board.move_piece("h8", "a5")
board.show
p board.checkmated?("e1")
#p board.in_check?("h5")
#p board.checkmated?("h5")
#game = Game.new
#game.board.squares[5][5].piece = Piece::Queen.new("Black")
#game.board.squares[7][6].piece = nil
#game.board.squares[7][5].piece = nil
#game.board.squares[7][3].piece = nil
#game.board.squares[7][7].piece = nil
#game.board.squares[5][4].piece = Piece::Rook.new("Black")
#game.board.show
#game.play
