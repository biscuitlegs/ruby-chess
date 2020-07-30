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

describe "Square" do
    let (:queen) { double("queen") }

    describe "#initialize" do
        context "when no piece is given" do
            it "starts with no piece" do
                expect(Square.new.piece).to eql(nil)
            end
        end
        context "when a piece is given" do
            it "starts with the given piece" do
                expect(Square.new(queen).piece).to eql(queen)
            end
        end
    end

    describe "#occupied?" do
        context "when the square has no piece" do
            it "returns false" do
                expect(Square.new.occupied?).to eql(false)
            end
        end
        context "when the square has a piece" do
            it "returns true" do
                expect(Square.new(queen).occupied?).to eql(true)
            end
        end
    end
end
