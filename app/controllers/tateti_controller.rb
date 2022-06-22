class TatetiController < ApplicationController

    board = 
    turn = X
    winnerComps = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6],
    ]
    
    def fill
        if board[params_square] == ""
            board = board.insert(params_square)
            render status: 200
        else
            render status: 404, json: { message: "La casilla esta ocupada"}
        end
    end

    def checkWinner

    end

    private
        def params_square
            params.permit(:index)
        end
end
