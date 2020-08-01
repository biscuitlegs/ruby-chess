require_relative "../lib/chess.rb"

describe "Board" do
    let (:square) { double("square") }
    let (:king) { double("king") }
    let (:board) { Board.new(square) }

    before do
        allow(board).to receive(:puts)
        allow(board).to receive(:print)
    end

    describe "#initialize" do
        it "creates an 8x8 board with 64 squares" do
            expect(board.squares).to eql(Array.new(8) { Array.new(8, square) })
        end
    end

    describe "#get_square" do
        before { board.squares[0][0] = king }

        context "when given a valid postion" do
            it "gets the square at that position" do
                expect(board.get_square("a1")).to eql(king)
            end
        end
        context "when given an invalid postion" do
            it "prompts the user for a valid position" do
                allow(board).to receive(:gets).and_return("a1")
                expect(board).to receive(:gets)
                expect(board.get_square("z9")).to eql(king)
            end
        end
    end

    describe "#place_piece" do
        let (:board) { Board.new }

        it "places a piece on the board" do
            expect(board.squares[0][0].piece).to eql(nil)
            board.place_piece("King", "c5")
            expect(board.squares[4][2].piece.name).to eql("King")
        end
    end

    describe "#show" do
        context "when the board is empty" do
            it "shows an empty board" do
                allow(square).to receive(:to_s).and_return("⛶")
                expect(board.show).to eql(" ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n")
            end
        end
        context "when a piece is on the board" do
            it "shows the piece on the board" do
                board.squares[0][0] = king
                allow(square).to receive(:to_s).and_return("⛶")
                allow(king).to receive(:to_s).and_return("♚")
                expect(board.show).to eql(" ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          " ♚  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n")
            end
        end
    end

    describe "#remove_piece" do
        let (:board) { Board.new }

        it "removes a piece from the board" do
            board.squares[0][0].piece = king
            board.remove_piece("A1")
            expect(board.squares[0][0].piece).to eql(nil)
        end
    end

    describe "#move_piece" do
        let (:board) { Board.new }

        it "moves a piece on the board" do
            board.squares[0][0].piece = king
            board.move_piece("a1", "h8")
            expect(board.squares[7][7].piece).to eql(king)
        end
    end

    describe "#populate" do
        let (:board) { Board.new }

        it "sets up pieces in their starting positions" do
            board.populate
            pieces = ["Rook", "Knight", "Bishop", "Queen", "King", "Bishop", "Knight", "Rook"]

            (0..7).each do |n|
                expect(board.squares[0][n].piece.name).to eql(pieces[n])
                expect(board.squares[7][n].piece.name).to eql(pieces[n])
            end
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
        describe "#initialize" do
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
    end

    describe "Bishop" do
        describe "#initialze" do
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
    end

    describe "Knight" do
        describe "#initialize" do
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
    end

    describe "Rook" do
        describe "#initialize" do
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
    end

    describe "Queen" do
        describe "#initialize" do
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
    end

    describe "King" do
        describe "#initialize" do
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
end

describe "Player" do
    describe "#initialize" do
        context "when no name is given" do
            it "names the player as 'Player'" do
                expect(Player.new.name).to eql("Player")
            end
        end
        context "when a name is given" do
            it "names the player as that name" do
                expect(Player.new("Mark").name).to eql("Mark")
            end
        end
    end
end
