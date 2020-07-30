require_relative "../lib/chess.rb"

describe "Board" do
    let (:square) { double("square") }
    let (:board) { Board.new(square) }

    describe "#initialize" do
        it "creates an 8x8 board with 64 squares" do
            expect(board.squares).to eql(Array.new(8) { Array.new(8, square) })
        end
    end
end
