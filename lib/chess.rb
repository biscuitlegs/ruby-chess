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
