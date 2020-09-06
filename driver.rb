require_relative "lib/chess.rb"

game = Game.new
game.board.squares[1][0].piece = Piece::Pawn.new("White")
game.board.show
#game.play
