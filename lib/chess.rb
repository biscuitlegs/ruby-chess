class Board
    attr_reader :squares

    def initialize(square=nil)
        @squares = Array.new(8) { Array.new(8) { square ? square : Square.new } }
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
