require_relative "lib/chess.rb"

game = Game.new
game.board = Board.new
game.board.squares[7][3].piece = Piece::King.new("White")
game.board.squares[6][3].piece = Piece::Queen.new
game.board.squares[5][5].piece = Piece::Rook.new
game.board.squares[0][0].piece = Piece::King.new
game.play
