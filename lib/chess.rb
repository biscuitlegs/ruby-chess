class Board
    attr_reader :squares

    def initialize(square=nil)
        @squares = Array.new(8) { Array.new(8) { square ? square : Square.new } }
    end

    def move_piece(start, finish)
        get_square(finish).piece = get_square(start).piece
        get_square(start).piece = nil
    end

    def remove_piece(position)
        get_square(position).piece = nil
    end

    def place_piece(piece, position)
        until valid_piece?(piece)
            puts invalid_piece_message
            piece = gets.chomp
        end

        piece.capitalize!
        get_square(position).piece = Object.const_get("Piece::#{piece}").new
    end

    def get_square(position)
        until valid_position?(position)
            puts invalid_position_message
            position = gets.chomp

            if position =~ /^\[\d\, \d\]$/
                position = [position[1].to_i, position[4].to_i]
            end
        end

        if position.is_a? String
            position.downcase!
            position = human_to_array_position(position)
        end

        @squares[position[0]][position[1]]
    end

    def show
        board_string = ""

        @squares.reverse.each_with_index do |row, row_index|
            board_string += 8.downto(1).to_a[row_index].to_s

            row.each_with_index do |piece, index|
                board_string += "\s#{piece}\s"
                board_string += "\n" if index == 7
            end
        end

        board_string += "\s"
        ("A".."H").to_a.each { |letter| board_string += "\s#{letter}\s" }

        print board_string
        print "\n"

        board_string
    end

    def setup
        backrow = ["Rook", "Knight", "Bishop", "Queen", "King", "Bishop", "Knight", "Rook"]

        (0..7).each do |number|
            @squares[0][number].piece = Object.const_get("Piece::#{backrow[number]}").new
            @squares[1][number].piece = Piece::Pawn.new
            @squares[7][number].piece = Object.const_get("Piece::#{backrow[number]}").new("White")
            @squares[6][number].piece = Piece::Pawn.new("White")
        end
    end

    def get_position(target_square)
        @squares.each_with_index do |row, row_index|
            row.each_with_index do |square, square_index|
                return [row_index, square_index] if square == target_square
            end
        end
    end

    def get_moves(human_position, squares=[])
        piece = get_square(human_position).piece
        array_position = human_to_array_position(human_position)

        if get_square(human_position).piece
            case piece.name
                when "Pawn"
                    if piece.color == "Black"
                        if array_position[0] == 1
                            squares << get_vertical_moves(human_position, false, 2, 8).select { |square| !square.piece }
                        else
                            squares << get_vertical_moves(human_position, false, 1, 8).select { |square| !square.piece }
                        end

                        squares << get_diagonal_moves(human_position, false, 1, 8).select { |square| square.piece && square.piece.color == "White" }
                    else
                        if array_position[0] == 6
                            squares << get_vertical_moves(human_position, false, 2, 1).select { |square| !square.piece }
                        else
                            squares << get_vertical_moves(human_position, false, 1, 1).select { |square| !square.piece }
                        end

                        squares << get_diagonal_moves(human_position, false, 1, 1).select { |square| square.piece && square.piece.color == "Black" }
                    end
                    
                when "Bishop"
                    squares << get_diagonal_moves(human_position)

                when "Knight"
                    squares << get_knight_moves(human_position)

                when "Rook"
                    squares << get_horizontal_moves(human_position)
                    squares << get_vertical_moves(human_position)

                when "Queen"
                    squares << get_horizontal_moves(human_position)
                    squares << get_vertical_moves(human_position)
                    squares << get_diagonal_moves(human_position)

                when "King"
                    squares << get_horizontal_moves(human_position, false, 1)
                    squares << get_vertical_moves(human_position, false, 1)
                    squares << get_diagonal_moves(human_position, false, 1)

                else
            end
        else
            return squares
        end


        squares.flatten
    end

    def checkmated?(position)
        if in_check?(position)
            king_moves = get_moves(position)

            king_moves.each do |square|
                original_piece = square.piece
                array_position = get_position(square)
                human_position = array_to_human_position(array_position)
                move_piece(position, human_position)
        
                if !in_check?(human_position)
                    move_piece(human_position, position)
                    square.piece = original_piece
                    return false
                end

                move_piece(human_position, position)
                square.piece = original_piece
            end
        else
            return false
        end

        true
    end

    def stalemated?(position)
        if !in_check?(position)
            ally_squares = @squares.flatten.select { |square| square.piece && square.piece.color == get_square(position).piece.color }

            ally_squares.each do |square|
                square_position = array_to_human_position(get_position(square))
                square_moves = get_moves(square_position)

                square_moves.each do |move|
                    original_piece = move.piece
                    array_position = get_position(move)
                    human_position = array_to_human_position(array_position)
                    move_piece(square_position, human_position)
            
                    if !in_check?(human_position)
                        move_piece(human_position, square_position)
                        move.piece = original_piece
                        return false
                    end

                    move_piece(human_position, square_position)
                    move.piece = original_piece
                end
            end
        else
            return false
        end

        true
    end

    def valid_move?(start, finish)
        if !get_square(start).piece || (get_square(finish).piece && get_square(start).piece.color == get_square(finish).piece.color) || (get_square(finish).piece && get_square(finish).piece.name == "King") || checks_own_king?(start, finish) || !get_moves(start).include?(get_square(finish))
            return false
        end
        
        true
    end

    def array_to_human_position(position)
        [number_to_letter(position[1]), position[0] + 1].join.capitalize
    end

    def human_to_array_position(position)
        [letter_to_number(position[0]) - 1, position[1].to_i - 1].reverse
    end

    def get_knight_moves(human_position, squares=[])
        array_position = human_to_array_position(human_position)

        permutations = [1, 2, -1, -2].permutation(2).to_a.filter { |p| p[0].abs != p[1].abs }
        permutations.each do |permutation|
            y = array_position[0] + permutation[0]
            x = array_position[1] + permutation[1]

            next if x < 0 || x > 7 || y < 0 || y > 7

            squares << get_square([y, x]) if !get_square([y, x]).piece || get_square([y, x]).piece.color != get_square(human_position).piece.color
        end

        squares
    end

    def get_diagonal_moves(human_position, ally_pieces=false, limit=nil, direction=nil, squares=[])
        directions = [[0, 0, "-", "-"], [7, 7, "+", "+"], [7, 0, "+", "-"], [0, 7, "-", "+"]]

        if direction == 8
            directions = [directions[1], directions[2]]
        elsif direction == 1
            directions = [directions[0], directions[3]]
        end

        directions.each do |set|
            array_position = human_to_array_position(human_position)

            catch (:reached_limit) do
                until array_position[0] == set[0] || array_position[1] == set[1]
                    array_position[0] = array_position[0].public_send(set[2], 1)
                    array_position[1] = array_position[1].public_send(set[3], 1)

                    [0, 1].each do |n|
                        throw :reached_limit if limit && human_to_array_position(human_position)[n] - (limit + 1) == array_position[n]
                        throw :reached_limit if limit && human_to_array_position(human_position)[n] + (limit + 1) == array_position[n]
                    end
                    
                    if !ally_pieces && get_square(array_position).piece && get_square(array_position).piece.color == get_square(human_position).piece.color
                        break
                    elsif get_square(array_position).piece && get_square(array_position).piece.color != get_square(human_position).piece.color
                        squares << get_square(array_position)
                        break
                    end
                    

                    squares << get_square(array_position)
                end
            end
        end


        squares
    end

    def get_horizontal_moves(human_position, ally_pieces=false, limit=nil, direction=nil, squares=[])
        array_position = human_to_array_position(human_position)

        directions = [array_position[1].downto(limit && array_position[1] - limit >= 0 ? array_position[1] - limit : 0), array_position[1].upto(limit && array_position[1] + limit <= 7 ? array_position[1] + limit : 7)]

        if direction && direction.upcase == "A"
            directions.pop
        elsif direction && direction.upcase == "H"
            directions.shift
        end

        directions.each do |direction|
            direction.each do |n|
                next if array_position == [array_position[0], n]

                if !ally_pieces && get_square([array_position[0], n]).piece && get_square([array_position[0], n]).piece.color == get_square(human_position).piece.color
                    break
                elsif get_square([array_position[0], n]).piece && get_square([array_position[0], n]).piece.color != get_square(human_position).piece.color
                    squares << get_square([array_position[0], n])
                    break
                end

                squares << get_square([array_position[0], n])
            end
        end
        

        squares
    end

    def get_vertical_moves(human_position, ally_pieces=false, limit=nil, direction=nil, squares=[])
        array_position = human_to_array_position(human_position)

        directions = [array_position[0].upto(limit && array_position[0] + limit <= 7 ? array_position[0] + limit : 7).to_a, array_position[0].downto(limit && array_position[0] - limit >= 0 ? array_position[0] - limit : 0).to_a]

        if direction == 8
            directions.pop
        elsif direction == 1
            directions.shift
        end
        
        directions.each do |direction|
            direction.each do |n|
                next if array_position == [n, array_position[1]]

                if !ally_pieces && get_square([n, array_position[1]]).piece && get_square([n, array_position[1]]).piece.color == get_square(human_position).piece.color
                    break
                elsif get_square([n, array_position[1]]).piece && get_square([n, array_position[1]]).piece.color != get_square(human_position).piece.color
                    squares << get_square([n, array_position[1]])
                    break
                end

                squares << get_square([n, array_position[1]])
            end
        end


        squares
    end

    def pawn_promoted?
        black_pawns = @squares.flatten.select { |square| square.piece && square.piece.name == "Pawn" && square.piece.color == "Black" }
        white_pawns = @squares.flatten.select { |square| square.piece && square.piece.name == "Pawn" && square.piece.color == "White" }

        black_pawns.each do |square|
            return true if get_position(square)[0] == 7
        end

        white_pawns.each do |square|
            return true if get_position(square)[0] == 0
        end

        false
    end

    def promote_pawn(position)
        pawn_color = get_square(position).piece.color

        puts "Congrats #{pawn_color}! Your Pawn on #{position.upcase} can be promoted!"
        puts "Please choose a piece to promote your Pawn to:"
        choice = gets.chomp

        until choice.capitalize =~ /(Bishop|Rook|Knight|Queen)/
            puts "That is not a valid promotion choice. Please try again:"
            choice = gets.chomp
        end

        get_square(position).piece = Object.const_get("Piece::#{choice.capitalize}").new
        get_square(position).piece.color = pawn_color
    end


    private

    def in_check?(position)
        king = get_square(position).piece

        enemy_squares = @squares.flatten.select { |square| square.piece && square.piece.color != king.color }

        enemy_squares.each do |square|
            array_position = get_position(square)
            human_position = array_to_human_position(array_position)
           
            return true if get_moves(human_position).include?(get_square(position))
        end

        false
    end

    def checks_own_king?(start, destination)
        
        ally_king = @squares.flatten.select { |square| square.piece && square.piece.name == "King" && square.piece.color == get_square(start).piece.color }[0]
        ally_king_position = array_to_human_position(get_position(ally_king))

        destination_piece = get_square(destination).piece

        
        if get_square(start).piece.name == "King"
            move_piece(start, destination)
            ally_king = get_square(destination)
            ally_king_position = destination
        else
            move_piece(start, destination)
        end
        
        if in_check?(ally_king_position)
            move_piece(destination, start)
            get_square(destination).piece = destination_piece
            return true
        else
            move_piece(destination, start)
            get_square(destination).piece = destination_piece
            return false
        end
    end

    def valid_piece?(piece)
        piece.capitalize =~ /(Pawn|Bishop|Knight|Rook|Queen|King)/ ? true : false
    end

    def invalid_piece_message
        "That is not a valid piece. Please choose a valid piece:\n"
    end

    def number_to_letter(given_number)
        ("a".."h").each_with_index do |letter, index|
            return letter if given_number == index
        end
    end

    def letter_to_number(given_letter)
        ("a".."h").each_with_index do |letter, index|
            return index + 1 if given_letter.downcase == letter.downcase
        end
    end

    def valid_position?(position)
        if position.is_a? String
            return false if !position.downcase.match(/^[a-h][1-8]$/)
        else
            position.each { |n| return false if n < 0 || n > 7 }
        end

        true
    end

    def invalid_position_message
        "That position doesn't exist. Please enter a valid position:\n"
    end
end

class Square
    attr_accessor :piece

    def initialize(piece=nil)
        @piece = piece
    end

    def occupied?
        self.piece ? true : false
    end

    def to_s
        piece ? self.piece.to_s : "\u26f6"
    end
end

class Piece
    class Pawn
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "Pawn"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265f" : "\u2659"
        end
    end

    class Bishop
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "Bishop"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265d" : "\u2657"
        end
    end

    class Knight
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "Knight"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265e" : "\u2658"
        end
    end

    class Rook
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "Rook"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265c" : "\u2656"
        end
    end

    class Queen
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "Queen"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265b" : "\u2655"
        end
    end

    class King
        attr_reader :name
        attr_accessor :color

        def initialize(color="Black")
            @name = "King"
            @color = color
        end

        def to_s
            color == "Black" ? "\u265a" : "\u2654"
        end
    end
end

class Player
    attr_reader :name

    def initialize(name="Player")
        @name = name
    end
end

class Game
    attr_accessor :board, :player_one, :player_two

    def initialize(board=Board.new, player_one=Player.new("Black"), player_two=Player.new("White"))
        @board = board
        @board.setup
        @player_one = player_one
        @player_two = player_two
    end

    def play
        play_round until gameover?
        
        @board.show

        if get_winning_color == "Draw"
            puts draw_message
        else
            winner = [@player_one, @player_two].select { |player| player.name == get_winning_color }[0]
            puts winner_message(winner.name)
        end
    end

    def play_round
        [@player_one, @player_two].each do |player|
            @board.show
            puts "It's #{player.name}'s move.\n"
            puts "To move a piece, type it's position and the intended destination, for example: 'd4 e5'."

            move_choice = gets.chomp

            until valid_move_format?(move_choice) && @board.valid_move?(move_choice.split[0], move_choice.split[1]) && player.name == @board.get_square(move_choice.split[0]).piece.color
                puts "That move is not valid. Please try again:"
                move_choice = gets.chomp
            end

            @board.move_piece(move_choice.split[0], move_choice.split[1])

            @board.promote_pawn(move_choice.split[1]) if @board.pawn_promoted?

            break if gameover?
        end
    end

    def gameover?
        king_squares = @board.squares.flatten.select { |square| square.piece && square.piece.name == "King" }
        king_squares.each do |square|
            king_position = @board.array_to_human_position(@board.get_position(square))
            return true if @board.checkmated?(king_position) || @board.stalemated?(king_position)
        end

        false
    end

    def get_winning_color
        king_squares = @board.squares.flatten.select { |square| square.piece && square.piece.name == "King" }
        king_squares.each do |square|
            king_position = @board.array_to_human_position(@board.get_position(square))
            return "Draw" if @board.stalemated?(king_position)
            if @board.checkmated?(king_position)
                return square.piece.color == "Black" ? "White" : "Black"
            end
        end
    end

    def draw_message
        puts "\nStalemate! The game ended in a draw.\n"
    end

    def winner_message(name)
        "\nCongrats #{name}! You won!\n"
    end

    private

    def valid_move_format?(move)
        move =~ /[a-h][1-8] [a-h][1-8]/ ? true : false
    end
end
