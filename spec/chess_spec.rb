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

describe "Piece" do
    describe "Pawn" do
        it "starts with the correct name" do
            expect(Piece::Pawn.new.name).to eql("Pawn")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::Pawn.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::Pawn.new("White").color).to eql("White")
            end
        end
    end

    describe "Bishop" do
        it "starts with the correct name" do
            expect(Piece::Bishop.new.name).to eql("Bishop")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::Bishop.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::Bishop.new("White").color).to eql("White")
            end
        end
    end

    describe "Knight" do
        it "starts with the correct name" do
            expect(Piece::Knight.new.name).to eql("Knight")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::Knight.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::Knight.new("White").color).to eql("White")
            end
        end
    end

    describe "Rook" do
        it "starts with the correct name" do
            expect(Piece::Rook.new.name).to eql("Rook")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::Rook.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::Rook.new("White").color).to eql("White")
            end
        end
    end

    describe "Queen" do
        it "starts with the correct name" do
            expect(Piece::Queen.new.name).to eql("Queen")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::Queen.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::Queen.new("White").color).to eql("White")
            end
        end
    end

    describe "King" do
        it "starts with the correct name" do
            expect(Piece::King.new.name).to eql("King")
        end
        context "when no color is given" do
            it "starts as a black piece" do
                expect(Piece::King.new.color).to eql("Black")
            end
        end
        context "when a color is given" do
            it "starts as that color piece" do
                expect(Piece::King.new("White").color).to eql("White")
            end
        end
    end
end
