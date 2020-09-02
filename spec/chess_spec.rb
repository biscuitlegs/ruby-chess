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
                expect(board.show).to eql("8 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "7 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "6 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "5 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "4 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "3 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "2 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "1 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "  A  B  C  D  E  F  G  H "
                                        )
            end
        end
        context "when a piece is on the board" do
            it "shows the piece on the board" do
                board.squares[0][0] = king
                allow(square).to receive(:to_s).and_return("⛶")
                allow(king).to receive(:to_s).and_return("♚")
                expect(board.show).to eql("8 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "7 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "6 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "5 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "4 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "3 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "2 ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "1 ♚  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶  ⛶ \n" +
                                          "  A  B  C  D  E  F  G  H "
                                        )
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

    describe "#setup" do
        let (:board) { Board.new }

        it "sets up pieces in their starting positions" do
            board.setup
            pieces = ["Rook", "Knight", "Bishop", "Queen", "King", "Bishop", "Knight", "Rook"]

            (0..7).each do |n|
                expect(board.squares[0][n].piece.name).to eql(pieces[n])
                expect(board.squares[7][n].piece.name).to eql(pieces[n])
            end
        end
    end

    describe "#get_moves" do
        let (:board) { Board.new }
        let (:black_piece) { double("black_piece") }
        let (:white_piece) { double("white_piece") }

        before do
            allow(black_piece).to receive(:color).and_return("Black")
            allow(white_piece).to receive(:color).and_return("White")
        end

        context "when the square has no piece" do
            it "returns an empty array" do
                expect(board.get_moves("c5")).to eql([])
            end
        end

        context "when the piece is a pawn" do
            context "when the piece moves for the first time" do
                context "when the piece is black" do
                    it "can move up to two squares forward" do
                        board.squares[1][0].piece = Piece::Pawn.new
                        
                        expect(board.get_moves("a2")).to include(
                            board.squares[2][0],
                            board.squares[3][0]
                        )
                        
                    end
                end
                context "when the piece is white" do
                    it "can move up to two squares forward" do
                        board.squares[6][0].piece = Piece::Pawn.new("White")
                        
                        expect(board.get_moves("a7")).to include(
                            board.squares[5][0],
                            board.squares[4][0]
                        )
                        
                    end
                end
            end

            context "when the piece has already moved" do
                it "can only move forward one square" do
                    board.squares[3][1].piece = Piece::Pawn.new

                    expect(board.get_moves("b4").length).to eql(1)
                    expect(board.get_moves("b4")).to include(
                        board.squares[4][1]
                    )
                end
            end

            context "when the piece is blocked" do
                it "cannot move forward" do
                    board.squares[3][1].piece = Piece::Pawn.new
                    board.squares[4][1].piece = white_piece

                    expect(board.get_moves("b4").length).to eql(0)
                end
            end

            context "when there is no adjacent diagonal enemy piece" do
                it "cannot move diagonally" do
                    board.squares[3][1].piece = Piece::Pawn.new

                    expect(board.get_moves("b4").length).to eql(1)
                    expect(board.get_moves("b4")).to include(
                        board.squares[4][1]
                    )
                end
            end

            context "when there is an adjacent diagonal enemy piece" do
                it "can move to that square" do
                    board.squares[3][1].piece = Piece::Pawn.new
                    board.squares[4][2].piece = white_piece
                    board.squares[4][0].piece = black_piece

                    expect(board.get_moves("b4").length).to eql(2)
                    expect(board.get_moves("b4")).to include(
                        board.squares[4][1],
                        board.squares[4][2]
                    )
                end
            end
        end

        context "when the piece is a bishop" do
            it "gets all available bishop moves" do
                board.squares[3][3].piece = Piece::Bishop.new
                board.squares[4][2].piece = white_piece
                board.squares[1][5].piece = black_piece
                board.squares[1][1].piece = black_piece
                
                expect(board.get_moves("d4").length).to eql(7)
                expect(board.get_moves("d4")).to include(
                    board.squares[2][2], 
                    board.squares[2][4], 
                    board.squares[4][4],
                    board.squares[5][5],
                    board.squares[6][6],
                    board.squares[7][7],
                    board.squares[4][2]
                )
            end
        end

        context "when the piece is a knight" do
            it "gets all available knight moves" do
                board.squares[3][3].piece = Piece::Knight.new
                board.squares[1][2].piece = black_piece
                board.squares[1][4].piece = black_piece
                board.squares[4][1].piece = black_piece
                board.squares[5][2].piece = white_piece
                board.squares[2][5].piece = black_piece
                board.squares[4][5].piece = black_piece

                expect(board.get_moves("d4").length).to eql(3)
                expect(board.get_moves("d4")).to include(
                    board.squares[5][4],
                    board.squares[2][1],
                    board.squares[5][2]
                )
            end
        end

        context "when the piece is a rook" do
            it "gets all available rook moves" do
                    board.squares[3][3].piece = Piece::Rook.new("Black")
                    board.squares[5][3].piece = white_piece
                    board.squares[3][1].piece = white_piece
                    board.squares[2][3].piece = black_piece
                    board.squares[3][4].piece = black_piece

                    expect(board.get_moves("d4").length).to eql(4)
                    expect(board.get_moves("d4")).to include(
                        board.squares[3][2],
                        board.squares[3][1],
                        board.squares[4][3],
                        board.squares[5][3],
                    )
            end
        end

        context "when the piece is a queen" do
            it "gets all available queen moves" do
                board.squares[3][3].piece = Piece::Queen.new("Black")
                board.squares[4][3].piece = white_piece
                board.squares[3][1].piece = white_piece
                board.squares[1][3].piece = black_piece
                board.squares[3][4].piece = black_piece
                board.squares[4][4].piece = black_piece
                board.squares[2][4].piece = white_piece
                board.squares[1][1].piece = white_piece
                board.squares[5][1].piece = black_piece

                expect(board.get_moves("d4").length).to eql(8)
                expect(board.get_moves("d4")).to include(
                    board.squares[4][3],
                    board.squares[2][4],
                    board.squares[2][3],
                    board.squares[2][2],
                    board.squares[1][1],
                    board.squares[3][2],
                    board.squares[3][1],
                    board.squares[4][2]
                )
            end
        end

        context "when the piece is a king" do
            it "gets all available king moves" do
                board.squares[3][3].piece = Piece::King.new
                board.squares[3][2].piece = white_piece
                board.squares[4][4].piece = white_piece
                board.squares[3][4].piece = black_piece
                board.squares[2][3].piece = black_piece

                expect(board.get_moves("d4").length).to eql(6)
                expect(board.get_moves("d4")).to include(
                    board.squares[4][3],
                    board.squares[4][2],
                    board.squares[2][2],
                    board.squares[2][4],
                    board.squares[3][2],
                    board.squares[4][4],
                )
            end
        end
    end

    describe "#in_check?" do
        let (:board) { Board.new }
        
        context "when the king is not in check" do
            it "returns false" do
                board.squares[3][3].piece = Piece::King.new
                expect(board.in_check?("d4")).to eql(false)
            end
        end

        context "when the king is in check" do
            it "returns true" do
                board.squares[3][0].piece = Piece::King.new
                board.squares[3][2].piece = Piece::Rook.new("White")
                expect(board.in_check?("a4")).to eql(true)
            end
        end
    end

    describe "#checkmated?" do
        let (:board) { Board.new }
        
        context "when the king is not checkmated" do
            it "returns false" do
                board.squares[3][0].piece = Piece::King.new
                board.squares[3][2].piece = Piece::Rook.new("White")
                expect(board.checkmated?("a4")).to eql(false)
            end
        end

        context "when the king is checkmated" do
            it "returns true" do
                board.squares[3][0].piece = Piece::King.new
                board.squares[3][1].piece = Piece::Queen.new("White")
                board.squares[3][2].piece = Piece::Rook.new("White")
                expect(board.checkmated?("a4")).to eql(true)
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
