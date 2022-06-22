class GamesController < ApplicationController
    
    str = "";
    strv = "";
    strd = "";
    before_action :set_player, only:[:fill]
    before_action :check_token, only:[:fill]
    before_action :set_game, only:[:refresh, :fill, :winner]
    before_action :set_game_n, only:[:join]
    before_action :check_players_token, only:[:fill]
    before_action :check_player2, only:[:fill]
    before_action :check_players, only:[:join]
    before_action :check_char, only:[:fill]

    def create
        @game = Game.create(params_game)
        if @game.persisted?
            render status: 200, json: { char: "X", id: @game.id }
        else
            render status: 404, json: { message: "No se pudo crear el juego"}
        end
    end

    def join
        if @game.update(params_game)
            render status: 200, json: { char: "O", id: @game.id }
        else
            render status: 404, json: { message: "No se actualizo ese juego"}
        end
    end
    
    def fill
        if @game.state.at(params[:index].to_i) != "X" && @game.state.at(params[:index].to_i) != "O"
            @game.state = @game.state.tr(params[:index], @game.current_symbol)
            @game.current_symbol = @game.current_symbol == "X" ? "O" : "X"
            if @game.save
                render status: 200, json: { message: "Se lleno la casilla"}
            end 
        else
            render status: 404, json: { message: "La casilla esta ocupada"}
        end
    end
    
    def refresh
        render status: 200, json: { status: @game.state }
    end
    
    def winner

        # Check horizontal
        n = 0;
        while n < 9
            str = "#{str}#{@game.state.at(n)}";
            if n == 2
                str = "#{str} ";
            elsif n == 5 
                str = "#{str} ";
            end
            n += 1
        end
        
        # Check vertical
        n = 0;
        while n < 3
            u = n;
            while u < 9
                strv = "#{strv}#{@game.state.at(u)}";
                u += 3
            end
            strv = strv + " ";
            n += 1
        end

        # Check diagonal
        n = 0;
        while n < 9
            strd = "#{strd}#{@game.state.at(n)}"
            n += 4
        end
        strd = strd + " ";
        n = 2;
        while n < 7
            strd = "#{strd}#{@game.state.at(n)}"
            n += 2
        end
        strd = strd + " ";

        if /XXX/.match(str) || /XXX/.match(strv) || /XXX/.match(strd)
            @game.winner = 'X';
        end
        if /OOO/.match(str) || /OOO/.match(strv) || /OOO/.match(strd)
            @game.winner = 'O';
        end
        if @game.save
            render status: 200, json: { char: @game.winner }
        end
        str = "";
        strv = "";
        strd = "";
    end

    private

        def check_token
            return if request.headers["Authorization"] == "Bearer " + @user.token
            render status: 401, json: { message: "Jugador no autorizado"}
            false
        end

        def check_player2
            return if @game.player2 != nil
            render status: 404, json: { message: "Espere al otro jugador"}
            false
        end

        def check_players
            return if @game.player2 == nil
            render status: 404, json: { message: "La sala esta llena"}
            false
        end

        def check_players_token
            @player1 = User.find_by(name: @game.player1)
            @player2 = User.find_by(name: @game.player2)
            return if request.headers["Authorization"] == "Bearer " + @player1.token
            return if request.headers["Authorization"] == "Bearer " + @player2.token
            render status: 401, json: { message: "No esta en esta sala"}
            false
        end
        
        def params_game
            params.require(:game).permit(:name, :player1, :player2)
        end

        def set_game
            @game = Game.find_by(id: params[:id])
            if @game.blank?
                render status: 404, json: { message: "No se encontro ese juego: #{params[:id] }"}
                false
            end
        end

        def set_game_n
            @game = Game.find_by(name: params[:name])
            if @game.blank?
                render status: 404, json: { message: "No se encontro ese juego: #{params[:id] }"}
                false
            end
        end

        def set_player
            @user = User.find_by(name: params[:player])
            if @user.blank?
                render status: 404, json: { message: "No se encontro ese user: #{params[:player]}"}
                false
            end
        end

        def check_char
            return if @game.current_symbol == params[:char]
            render status: 404, json: { message: "No es su turno"}
            false
        end
end
