defmodule Profbattle.Game do

    def new do
    # new will randomly create 3 profs to player1
      %{
        gameState: 0,
        round: 0, #delete maybe
        selectingPlayer: 1,
        player1: [], #{prof1: #{prof: 1, hp:100, sp: 100}}
        player2: [],
        player1Action: "",
        player2Action: ""
      }
    end


    def select(game, professor) do
      selectingPlayer = game.selectingPlayer
      playerOneTeam = game.player1
      playerTwoTeam = game.player2

      if selectingPlayer == 1 do
        addProfessor(game, 1, professor)
        else
        addProfessor(game, 2, professor)
      end

    end

    def addProfessor(game, player, professor) do
      gameState = game.gameState
      round = game.round

      if round == 6 do
        round = 0
        gameState = 2
      else
        round = round + 1
      end

      if player == 1 do
        %{
          gameState: gameState,
          round: round,
          selectingPlayer: 2,
          player1: game.player1 ++ [[professor, 100, 0]],
          player2: game.player2,
          player1Action: game.player1Action,
          player2Action: game.player2Action
        }
      else
        %{
          gameState: gameState,
          round: round,
          selectingPlayer: 1,
          player1: game.player1,
          player2: game.player2 ++ [[professor, 100, 0]],
          player1Action: game.player1Action,
          player2Aaction: game.player2Action
        }
      end
    end

#    def attack(game, player) do
#      clinger = [hp: 3.63, attack: 3.95, defense: 3.95, speed: 3.61, special: 4.03] #1
#      tuck = [hp: 4.37, attack: 4.57, defense: 4.53, speed: 4.23, special: 4.42] #2
#      platt = [hp: 3.93, attack: 4.17, defense: 4.17, speed: 4.25, special: 4.63] #3
#      young = [hp: 4.78, attack: 4.58, defense: 4.84, speed: 4.83, special: 4.87] #4
#      weintraub = [hp: 3.90, attack: 3.25, defense: 4.27, speed: 3.87, special: 4.23] #5
#      derbinsky = [hp: 4.73, attack: 4.10, defense: 4.73, speed: 4.58, special: 4.70] #6
#
#      if player == 1 && game.player2Action == "" do
#        %{
#          gameState: game.gameState,
#          round: game.round,
#          selectingPlayer: game.selectingPlayer,
#          player1: game.player1,
#          player2: game.player2,
#          player1Action: "attack",
#          player2Aaction: game.player2Action
#        }
#      end
#
#      if player == 2 && game.player1Action == "" do
#        %{
#          gameState: game.gameState,
#          round: game.round,
#          selectingPlayer: game.selectingPlayer,
#          player1: game.player1,
#          player2: game.player2,
#          player1Action: game.player1Action
#          player2Aaction: "attack"
#        }
#      end
#
#    end

    def swap(game, player, professor) do
      if player == 1 do
        professorArray = game.player1
        first = List.first(professorArray)
        professorArray = List.delete(professorArray, first)
        second = List.first(professorArray)
        third = List.last(professorArray)
      else
        professorArray = game.player2
        first = List.first(professorArray)
        professorArray = List.delete(professorArray, first)
        second = List.first(professorArray)
        third = List.last(professorArray)
      end

      if professor == 2 do
        professorArray = [second, first, third]
      else
        professorArray = [third, second, first]
      end

      if player == 1 do
        %{
          gameState: game.gameState,
          round: game.round + 1,
          selectingPlayer: game.selectingPlayer,
          player1: professorArray,
          player2: game.player2,
          player1Action: "swap",
          player2Action: game.player2Action
        }
      else
        %{
          gameState: game.gameState,
          round: game.round + 1,
          selectingPlayer: game.selectingPlayer,
          player1: game.player1,
          player2: professorArray,
          player1Action: game.player1Action,
          player2Action: "swap"
        }
    end
  end



def addPlayer(game) do
  #[%{player1: %{}},%{player2: %{}}]


  %{
    gameState: 1,
    round: 0,
    selectingPlayer: 1, # will generate randomly
    player1: [],
    player2: [],
    player1Action: "",
    player2Action: ""
  }
end


   def profs() do
     # define profs' info here

    %{

    }
  end

end