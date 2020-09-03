require_relative "lib/chess.rb"

board = Board.new
board.setup

board.show

p board.stalemated?("e1")


#p board.stalemated?("e8")
#game = Game.new
#p game.gameover?
#game.play
#game.board.place_piece("King", "a1")
#game.board.place_piece("Pawn", "a2")
#game.board.place_piece("Pawn", "b2")
#game.board.place_piece("Pawn", "b1")

#board.get_square("a8").piece.color = "White"

#board.place_piece("Rook", "h6")
#board.place_piece("Rook", "h7")
#board.place_piece("Rook", "g4")
#board.place_piece("Rook", "f4")
#board.move_piece("h8", "a5")
#game.board.show

#board.move_piece("d5", "c1")
#p board.in_check?("d4")

