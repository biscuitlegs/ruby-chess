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
        end

        position.downcase!
        array_position = human_to_array_position(position)
        @squares[array_position[0]][array_position[1]]
    end

    def show
        board_string = ""

        @squares.reverse.each do |row|
            row.each_with_index do |piece, index|
                board_string += "\s#{piece}\s"
                board_string += "\n" if index == 7
            end
        end

        print board_string
        board_string
    end

    def populate
        pieces = ["Rook", "Knight", "Bishop", "Queen", "King", "Bishop", "Knight", "Rook"]

        (0..7).each do |number|
            @squares[0][number].piece = Object.const_get("Piece::#{pieces[number]}").new
            @squares[7][number].piece = Object.const_get("Piece::#{pieces[number]}").new
            @squares[7][number].piece.color = "White"
        end
    end

    def get_position(target_square)
        @squares.each_with_index do |row, row_index|
            row.each_with_index do |square, square_index|
                return [row_index, square_index] if square == target_square
            end
        end
    end


    private

    def get_horizontal_and_vertical_moves(human_position, squares=[])
        array_position = human_to_array_position(human_position)
        square = get_square(human_position)

        #left
        array_position[1].downto(0).each do |n|
            next if array_position == [array_position[0], n]
            break if get_square(array_to_human_position([array_position[0], n])).piece
            squares << get_square(array_to_human_position([array_position[0], n]))
        end

        #right
        (array_position[1]..7).each do |n|
            next if array_position == [array_position[0], n]
            break if get_square(array_to_human_position([array_position[0], n])).piece
            squares << get_square(array_to_human_position([array_position[0], n]))
        end

        #up
        (array_position[0]..7).each do |n|
            next if array_position == [n, array_position[1]]
            break if get_square(array_to_human_position([n, array_position[1]])).piece
            squares << get_square(array_to_human_position([n, array_position[1]]))
        end

        #down
        array_position[0].downto(0).each do |n|
            next if array_position == [n, array_position[1]]
            break if get_square(array_to_human_position([n, array_position[1]])).piece
            squares << get_square(array_to_human_position([n, array_position[1]]))
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
            return index + 1 if given_letter == letter
        end
    end

    def valid_position?(position)
        position.downcase =~ /^[a-h][1-8]$/ ? true : false
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
