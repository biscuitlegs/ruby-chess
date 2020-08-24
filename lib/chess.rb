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
                            squares << get_vertical_moves(human_position, 2, 8)
                        else
                            squares << get_vertical_moves(human_position, 1, 8)
                        end

                        squares << get_diagonal_moves(human_position, 1, 8)
                    else
                        if array_position[0] == 6
                            squares << get_vertical_moves(human_position, 2, 1)
                        else
                            squares << get_vertical_moves(human_position, 1, 1)
                        end

                        squares << get_diagonal_moves(human_position, 1, 1)
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
                    squares << get_horizontal_moves(human_position, 1)
                    squares << get_vertical_moves(human_position, 1)
                    squares << get_diagonal_moves(human_position, 1)

                else
            end
        else
            return squares
        end


        squares.flatten
    end


    private


    def get_knight_moves(human_position, squares=[])
        array_position = human_to_array_position(human_position)

        permutations = [1, 2, -1, -2].permutation(2).to_a.filter { |p| p[0].abs != p[1].abs }
        permutations.each do |permutation|
            y = array_position[0] + permutation[0]
            x = array_position[1] + permutation[1]
            squares << get_square([y, x]) if !get_square([y, x]).piece
        end

        squares
    end

    def get_diagonal_moves(human_position, limit=nil, direction=nil, squares=[])
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
                    
                    break if get_square(array_position).piece
                    squares << get_square(array_position)
                end
            end
        end


        squares
    end

    def get_horizontal_moves(human_position, limit=nil, direction=nil, squares=[])
        array_position = human_to_array_position(human_position)

        directions = [array_position[1].downto(limit ? array_position[1] - limit : 0), array_position[1].upto(limit ? array_position[1] + limit : 7)]

        if direction && direction.upcase == "A"
            directions.pop
        elsif direction && direction.upcase == "H"
            directions.shift
        end

        directions.each do |direction|
            direction.each do |n|
            next if array_position == [array_position[0], n]
            break if get_square([array_position[0], n]).piece
            squares << get_square([array_position[0], n])
            end
        end
        

        squares
    end

    def get_vertical_moves(human_position, limit=nil, direction=nil, squares=[])
        array_position = human_to_array_position(human_position)

        directions = [array_position[0].upto(limit ? array_position[0] + limit : 7).to_a, array_position[0].downto(limit ? array_position[0] - limit : 0).to_a]

        if direction == 8
            directions.pop
        elsif direction == 1
            directions.shift
        end
        
        directions.each do |direction|
            direction.each do |n|
                next if array_position == [n, array_position[1]]
                break if get_square([n, array_position[1]]).piece
                squares << get_square([n, array_position[1]])
            end
        end


        squares
    end

    def valid_piece?(piece)
        piece.capitalize =~ /(Pawn|Bishop|Knight|Rook|Queen|King)/ ? true : false
    end

    def invalid_piece_message
        "That is not a valid piece. Please choose a valid piece:\n"
    end

    def array_to_human_position(position)
        [number_to_letter(position[1]), position[0] + 1].join.capitalize
    end

    def human_to_array_position(position)
        [letter_to_number(position[0]) - 1, position[1].to_i - 1].reverse
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
