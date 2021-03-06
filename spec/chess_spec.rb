require_relative "../lib/chess.rb"
require 'yaml'

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

    describe "#stalemated?" do
        let (:board) { Board.new }

        context "when the king is stalemated" do
            it "returns true" do
                board.squares[7][6].piece = Piece::King.new
                board.squares[5][5].piece = Piece::Queen.new("White")
                board.squares[5][7].piece = Piece::Rook.new("White")

                expect(board.stalemated?("g8")).to eql(true)
            end
        end
        context "when the king is not stalemated" do
            it "returns false" do
                board.squares[7][6].piece = Piece::King.new
                board.squares[5][5].piece = Piece::Queen.new("White")

                expect(board.stalemated?("g8")).to eql(false)
            end
        end
    end

    describe "#valid_move?" do
        let (:board) { Board.new }

        context "when given a valid move" do
            it "returns true" do
                board.squares[1][0].piece = Piece::Pawn.new
                board.squares[1][5].piece = Piece::King.new

                expect(board.valid_move?("a2", "a3")).to eql(true)
            end
        end

        context "when given an invalid move" do
            context "when there is no piece on the start square" do
                it "returns false" do
                    expect(board.valid_move?("a1", "a2")).to eql(false)
                end
            end
            context "when the destination square has an ally piece" do
                it "returns false" do
                    board.squares[0][0].piece = Piece::Pawn.new
                    board.squares[1][0].piece = Piece::Pawn.new

                    expect(board.valid_move?("a1", "a2")).to eql(false)
                end
            end
            context "when the piece cannot legally move from start to finish" do
                it "returns false" do
                    board.squares[0][0].piece = Piece::Rook.new
                    board.squares[5][0].piece = Piece::King.new

                    expect(board.valid_move?("a1", "h8")).to eql(false)
                end
            end
            context "when the move checks the player's own king" do
                it "returns false" do
                    board.squares[3][3].piece = Piece::King.new
                    board.squares[4][3].piece = Piece::Rook.new
                    board.squares[5][3].piece = Piece::Queen.new("White")

                    expect(board.valid_move?("d5", "c5")).to eql(false)
                end
            end
        end
    end

    describe "#pawn_promoted?" do
        let (:board) { Board.new }

        context "when a pawn should be promoted" do
            it "returns true" do
                board.squares[0][0].piece = Piece::King.new
                board.squares[7][7].piece = Piece::Pawn.new

                expect(board.pawn_promoted?).to eql(true)
            end
        end
        context "when a pawn should not be promoted" do
            it "returns false" do
                board.squares[3][3].piece = Piece::Pawn.new
                board.squares[1][1].piece = Piece::Pawn.new("White")

                expect(board.pawn_promoted?).to eql(false)
            end
        end
    end

    describe "#promote_pawn" do
        let (:board) { Board.new }

        context "when a valid promotion piece is chosen" do
            it "promotes the pawn to the chosen piece" do
                allow(board).to receive(:gets).and_return("Queen")
                board.squares[7][7].piece = Piece::Pawn.new("White")
                board.promote_pawn("h8")

                expect(board.squares[7][7].piece.name).to eql("Queen")
                expect(board.squares[7][7].piece.color).to eql("White")
            end
        end
        context "when an invalid promotion piece is chosen" do
            it "gets a valid piece choice before promoting" do
                allow(board).to receive(:gets).and_return("Jack", "Queen")
                board.squares[7][7].piece = Piece::Pawn.new("White")
                board.promote_pawn("h8")

                expect(board.squares[7][7].piece.name).to eql("Queen")
                expect(board.squares[7][7].piece.color).to eql("White")
            end
        end
        context "when the enemy king is on the destination square" do
            it "returns false" do
                board.squares[3][3].piece = Piece::King.new
                board.squares[0][3].piece = Piece::Queen.new("White")

                expect(board.valid_move?("d1", "d4")).to eql(false)
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

describe "Game" do
    let(:game) { Game.new }
    before do
        allow(game.board).to receive(:print).and_return(nil)
        allow(game.board).to receive(:puts).and_return(nil)
    end

    describe "#initialize" do
        it "starts with a default board and players" do
            expect(game.board.class).to eql(Board)
            expect(game.player_one.class).to eql(Player)
            expect(game.player_two.class).to eql(Player)
        end
    end

    describe "#gameover?" do
        before do 
            game.board = Board.new
            allow(game.board).to receive(:print).and_return(nil)
            allow(game.board).to receive(:puts).and_return(nil)
        end

        context "when the game cannot continue" do
            context "when there is a checkmate" do
                it "returns true" do
                    game.board.squares[0][0].piece = Piece::King.new("White")
                    game.board.squares[7][6].piece = Piece::King.new
                    game.board.squares[6][6].piece = Piece::Queen.new("White")
                    game.board.squares[5][6].piece = Piece::Rook.new("White")

                    expect(game.gameover?).to eql(true)
                end
            end
            context "when there is a stalemate" do
                it "returns true" do
                    game.board.squares[0][1].piece = Piece::King.new("White")
                    game.board.squares[7][6].piece = Piece::King.new
                    game.board.squares[5][5].piece = Piece::Queen.new("White")
                    game.board.squares[5][7].piece = Piece::Rook.new("White")

                    expect(game.gameover?).to eql(true)
                end
            end
        end
            
        context "when the game can continue" do
            it "returns false" do
                game.board.squares[1][1].piece = Piece::King.new("White")
                game.board.squares[7][6].piece = Piece::King.new
                game.board.squares[5][5].piece = Piece::Queen.new("White")

                expect(game.gameover?).to eql(false)
            end
        end
    end

    describe "#play_round" do
        context "when a player gives a valid move" do
            it "moves the piece" do
                piece = game.board.squares[1][0].piece
                allow(game).to receive(:gets).and_return("a2 a3", "a7 a6")
                game.play_round
                
                expect(game.board.squares[2][0].piece).to eql(piece)
            end
        end

        context "when a player gives an invalid move" do
            it "asks for a valid move before moving" do
                piece = game.board.squares[1][0].piece
                allow(game).to receive(:gets).and_return("z5 g7", "a2 a3", "b7 b6")
                game.play_round
                
                expect(game.board.squares[2][0].piece).to eql(piece)
            end
        end
    end

    describe "#play" do
        before do
            game.board = Board.new
            allow(game.board).to receive(:print).and_return(nil)
            allow(game.board).to receive(:puts).and_return(nil)
        end

        it "plays rounds until the game is over" do
            allow(game).to receive(:gets).and_return("f6 d6")
            game.board.squares[7][3].piece = Piece::King.new("White")
            game.board.squares[6][3].piece = Piece::Queen.new
            game.board.squares[5][5].piece = Piece::Rook.new
            game.board.squares[0][0].piece = Piece::King.new
            game.play
        end

        it "declares a winner when there is a checkmate" do
            allow(game).to receive(:gets).and_return("a6 g6")
            expect(game).to receive(:puts).at_least(1).times.and_return(
                game.winner_message("Black") || game.winner_message("White")
            )
            game.board.squares[7][6].piece = Piece::King.new("White")
            game.board.squares[6][6].piece = Piece::Queen.new
            game.board.squares[5][6].piece = Piece::Rook.new
            game.board.squares[0][0].piece = Piece::King.new
            game.play
        end

        it "declares a draw when there is a stalemate" do
            allow(game).to receive(:gets).and_return("h5 h6")
            expect(game).to receive(:puts).at_least(1).times.and_return(game.draw_message)
            game.board.squares[7][6].piece = Piece::King.new("White")
            game.board.squares[5][5].piece = Piece::Queen.new
            game.board.squares[4][7].piece = Piece::King.new
            game.play
        end
    end
    
    describe "#load_game" do
        let (:loaded_game) { double("game") }
        let (:loaded_board) { double("board") }
        let (:loaded_player) { double("player") }
        let (:loaded_turn_taker) { double("turn_taker") }
        let (:save) { double("save") }
        let (:save_list) { [save, save, save] }

        before do
            allow(Dir).to receive(:glob).and_return(save_list)
            allow(YAML).to receive(:load).and_return(loaded_game)
            allow(File).to receive(:read)
            allow(loaded_game).to receive(:board).and_return(:loaded_board)
            allow(loaded_game).to receive(:player_one).and_return(:loaded_player)
            allow(loaded_game).to receive(:player_two).and_return(:loaded_player)
            allow(loaded_game).to receive(:turn_taker).and_return(:loaded_turn_taker)
            allow(save).to receive(:match).and_return([])
        end

        context "when a valid save is chosen" do
            it "loads the saved game" do
                allow(game).to receive(:gets).and_return("2")
                
                game.load_game

                expect(game.board).to eql(:loaded_board)
                expect(game.player_one).to eql(:loaded_player)
                expect(game.player_two).to eql(:loaded_player)
                expect(game.turn_taker).to eql(:loaded_turn_taker)
            end
        end
        context "when an invalid save is chosen" do
            it "asks for a valid choice before loading the saved game" do
                allow(game).to receive(:gets).and_return("5", "2")

                game.load_game

                expect(game.board).to eql(:loaded_board)
                expect(game.player_one).to eql(:loaded_player)
                expect(game.player_two).to eql(:loaded_player)
                expect(game.turn_taker).to eql(:loaded_turn_taker)
            end
        end
    end

    describe "#save_game" do
        let (:saved_game) { double "saved_game" }

        it "saves the game" do
            allow(File).to receive(:exists?).and_return(true)
            allow(YAML).to receive(:dump).and_return(saved_game)
            allow(File).to receive(:write).with("savegames/#{Time.now.strftime("%d.%m.%y-%H.%M.%S")}.txt", saved_game)

            game.save_game
        end
    end
end
