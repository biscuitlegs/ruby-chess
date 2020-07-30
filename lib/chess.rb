class Board
    attr_reader :squares

    def initialize(square=nil)
        @squares = Array.new(8) { Array.new(8) { square ? square : Square.new } }
    end

    def get_square(position)
        until valid_position?(position)
            puts invalid_position_message
            position = gets.chomp
        end
        
        array_position = human_to_array_position(position)
        @squares[array_position[0]][array_position[1]]
    end


    private

    def human_to_array_position(position)
        [letter_to_number(position[0]) - 1, position[1].to_i - 1].reverse
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
    attr_reader :piece

    def initialize(piece=nil)
        @piece = piece
    end

    def occupied?
        self.piece ? true : false
    end
end

class Piece
    class Pawn
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "Pawn"
            @color = color
        end
    end

    class Bishop
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "Bishop"
            @color = color
        end
    end

    class Knight
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "Knight"
            @color = color
        end
    end

    class Rook
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "Rook"
            @color = color
        end
    end

    class Queen
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "Queen"
            @color = color
        end
    end

    class King
        attr_reader :name, :color

        def initialize(color="Black")
            @name = "King"
            @color = color
        end
    end
end

class Player
    attr_reader :name

    def initialize(name="Player")
        @name = name
    end
end
