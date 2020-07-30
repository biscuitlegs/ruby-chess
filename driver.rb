require_relative "lib/chess.rb"

b = Board.new
b.place_piece("Pawn", "A1")
p b.squares[0][0]