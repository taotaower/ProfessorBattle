defmodule Profbattle.Game do

  def new do
    # new will randomly create 3 profs to player1
    %{
      gameState: 0,
      round: 0, #delete maybe
      playerTurn: "",
      player1: [], #{prof1: #{prof: 1, hp:100, sp: 100}}
      player2: [],
      player1Action: "",
      player2Action: "",
      profNumPlayer1: 0,
      profNumPlayer2: 0,
      phrase: "",
      msg: "",

    }
  end


#  def select(game, professor) do
#    playerTurn = game.playerTurn
#    playerOneTeam = game.player1
#    playerTwoTeam = game.player2
#
#    if playerTurn == 1 do
#      addProfessor(game, 1, professor)
#    else
#      addProfessor(game, 2, professor)
#    end
#
#  end
#
#  def addProfessor(game, player, professor) do
#    gameState = game.gameState
#    round = game.round
#
#    if round == 6 do
#      round = 0
#      gameState = 2
#    else
#      round = round + 1
#    end
#
#    if player == 1 do
#      %{
#        gameState: gameState,
#        round: round,
#        playerTurn: 2,
#        player1: game.player1 ++ [[professor, 100, 0]],
#        player2: game.player2,
#        player1Action: game.player1Action,
#        player2Action: game.player2Action
#      }
#    else
#      %{
#        gameState: gameState,
#        round: round,
#        playerTurn: 1,
#        player1: game.player1,
#        player2: game.player2 ++ [[professor, 100, 0]],
#        player1Action: game.player1Action,
#        player2Aaction: game.player2Action
#      }
#    end
#  end

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
  #          playerTurn: game.playerTurn,
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
  #          playerTurn: game.playerTurn,
  #          player1: game.player1,
  #          player2: game.player2,
  #          player1Action: game.player1Action
  #          player2Aaction: "attack"
  #        }
  #      end
  #
  #    end
#
#  def swap(game, player, professor) do
#    if player == 1 do
#      professorArray = game.player1
#      first = List.first(professorArray)
#      professorArray = List.delete(professorArray, first)
#      second = List.first(professorArray)
#      third = List.last(professorArray)
#    else
#      professorArray = game.player2
#      first = List.first(professorArray)
#      professorArray = List.delete(professorArray, first)
#      second = List.first(professorArray)
#      third = List.last(professorArray)
#    end
#
#    if professor == 2 do
#      professorArray = [second, first, third]
#    else
#      professorArray = [third, second, first]
#    end
#
#    if player == 1 do
#      %{
#        gameState: game.gameState,
#        round: game.round + 1,
#        playerTurn: game.playerTurn,
#        player1: professorArray,
#        player2: game.player2,
#        player1Action: "swap",
#        player2Action: game.player2Action
#      }
#    else
#      %{
#        gameState: game.gameState,
#        round: game.round + 1,
#        playerTurn: game.playerTurn,
#        player1: game.player1,
#        player2: professorArray,
#        player1Action: game.player1Action,
#        player2Action: "swap"
#      }
#    end
#  end

# defend prof will get angry

  def offSwap(playerTeam,profNum) do

    first = List.first(playerTeam)
    playerTeam = List.delete(playerTeam, first)
    second = List.first(playerTeam)
    third = List.last(playerTeam)
    if profNum == 2 do

      [second,third,first]
    else

      [second,first,third]
    end

  end

  def updateHP(defenseProf,playerTwoTeam) do

    List.replace_at(playerTwoTeam, 0, defenseProf)

  end


  def attackAction(game) do
    playerTurn = game.playerTurn
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    profNumPlayer1 = game.profNumPlayer1
    profNumPlayer2 = game.profNumPlayer2
    state = game.state
    msg = ""
    if playerTurn == "player1" do
      msg = "player1 attacks player2"
      attackProf = List.first(playerOneTeam)
      defenseProf = List.first(playerTwoTeam)
      hp = calAttack(attackProf,defenseProf)
      if hp <= 0 do
        profNumPlayer2 = profNumPlayer2 - 1
        defenseProf = Map.put(defenseProf,:status, "offline")
        defenseProf = Map.put(defenseProf,:hp, 0)
        playerTwoTeam = updateHP(defenseProf,playerTwoTeam)
        if profNumPlayer2 == 0 do
          msg = "player1 wins"
          state = 3
          else
          playerTwoTeam = offSwap(playerTwoTeam,profNumPlayer2)
        end

      else

        defenseProf = Map.put(defenseProf,:hp, hp)
        playerTwoTeam = updateHP(defenseProf,playerTwoTeam)
      end

      else
      msg = "player2 attacks player1"
      attackProf = List.first(playerTwoTeam)
      defenseProf = List.first(playerOneTeam)
      hp = calAttack(attackProf,defenseProf)
      if hp <= 0 do
        profNumPlayer1 = profNumPlayer1 - 1
        defenseProf = Map.put(defenseProf,:status, "offline")
        defenseProf = Map.put(defenseProf,:hp, 0)
        playerOneTeam = updateHP(defenseProf,playerOneTeam)
        if profNumPlayer1 == 0 do
          msg = "Player2 wins "
          state = 3
        else
          playerOneTeam = offSwap(playerOneTeam,profNumPlayer1)
        end

      else

        defenseProf = Map.put(defenseProf,:hp, hp)
        playerOneTeam = updateHP(defenseProf,playerOneTeam)
      end



    end


    %{
      gameState: state,
      round: (game.round + 1), #delete maybe
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam, #{prof1: #{prof: 1, hp:100, sp: 100}}
      player2: playerTwoTeam,
      player1Action: "",
      player2Action: "",
      profNumPlayer1: profNumPlayer1,
      profNumPlayer2: profNumPlayer2,
      phrase: "",
      msg: msg,
    }

  end




def swap(playerTeam,number,prof) do

    first = List.first(playerTeam)
    playerTeam = List.delete(playerTeam, first)
    second = List.first(playerTeam)
    third = List.last(playerTeam)
    if number == 3 do

      if prof == "0" do

        [second,third,first]

        else
        [third,second,first]

      end

    else

    [second,first,third]

    end




  end
  # when call swap current prof will go to the last position, selected prof should go to first

  def swapAction(game,prof) do

    playerTurn = game.playerTurn
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    profNumPlayer1 = game.profNumPlayer1
    profNumPlayer2 = game.profNumPlayer2
    msg = ""
    if playerTurn == "player1" do

      playerOneTeam = swap(playerOneTeam,profNumPlayer1,prof)
     else
      playerTwoTeam = swap(playerTwoTeam,profNumPlayer2,prof)

    end

    %{
      gameState: game.gameState,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: "",
      player2Action: "",
      profNumPlayer1: profNumPlayer1,
      profNumPlayer2: profNumPlayer2,
      phrase: "",
      msg: msg,
    }


  end


  def nextPlayer(player) do
    if player == "player1" do
      "player2"
    else
      "player1"
    end

  end





  def addPlayer(game) do


    playerTurn = initplayerTurn()
    %{
      gameState: 1,
      round: 0,
      playerTurn: playerTurn, # will generate randomly
      player1: [],
      player2: [],
      player1Action: "",
      player2Action: "",
      profs: profs(),
      profNumPlayer1: 0,
      profNumPlayer2: 0,
      phrase: "",
      msg: "",

    }
  end

  def getName(id) do
    Enum.fetch!(profs(),id).name
  end

  def selectProf(game,prof) do
    playerTurn = game.playerTurn
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    profNumPlayer1 = game.profNumPlayer1
    profNumPlayer2 = game.profNumPlayer2
    gameState = game.gameState
    gameProfs = game.profs
    if playerTurn == "player1" do
       playerOneTeam = playerOneTeam ++ [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: (profNumPlayer1+1), special: false, name: getName(prof) }]
       profNumPlayer1 = profNumPlayer1 + 1
    else
      playerTwoTeam = playerTwoTeam ++ [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: (profNumPlayer2+1), special: false, name: getName(prof) }]
      profNumPlayer2 = profNumPlayer2 + 1
    end

    updateProf = Map.put(Enum.fetch!(gameProfs,prof),:selected, true)
    gameProfs = List.replace_at(gameProfs, prof, updateProf)

    if (profNumPlayer1 + profNumPlayer2) == 6 do
      %{
        gameState: 2,
        round: 0,
        playerTurn: nextPlayer(playerTurn),
        player1: playerOneTeam,
        player2: playerTwoTeam,
        player1Action: "",
        player2Action: "",
        profNumPlayer1: profNumPlayer1,
        profNumPlayer2: profNumPlayer2,
        phrase: "",
        msg: "",
      }

      else

      %{
        gameState: 1,
        round: 0,
        playerTurn: nextPlayer(playerTurn),
        player1: playerOneTeam,
        player2: playerTwoTeam,
        player1Action: "",
        player2Action: "",
        profs: gameProfs,
        profNumPlayer1: profNumPlayer1,
        profNumPlayer2: profNumPlayer2,
        phrase: "",
        msg: "",
      }
    end
  end




  def profs() do
    # define profs' info here
    [
      %{id: 0, name: "clinger", hp: 3.63, attack: 4.05, defense: 3.95, speed: 3.61, special: 5.00, pic: "/images/Clinger.jpg", selected: false},
      %{id: 1, name: "tuck", hp: 4.37, attack: 3.43, defense: 4.53, speed: 4.23, special: 4.07, pic: "/images/Tuck.jpg",selected: false},
      %{id: 2, name: "platt", hp: 3.93, attack: 3.83, defense: 4.17, speed: 4.25, special: 3.57, pic: "/images/Platt.jpg",selected: false},
      %{id: 3, name: "young", hp: 4.78, attack: 3.42, defense: 4.84, speed: 4.83, special: 3.00, pic: "/images/Young.jpg",selected: false},
      %{id: 4, name: "weintraub", hp: 3.90, attack: 4.75, defense: 4.27, speed: 3.87, special: 4.76, pic: "/images/Michael.jpg",selected: false},
      %{id: 5, name: "derbinsky", hp: 4.73, attack: 3.90, defense: 4.73, speed: 4.58, special: 3.40, pic: "/images/nate.jpg",selected: false},
    ]
  end

  def initplayerTurn() do
    Enum.shuffle(["player1","player2"])
          |>List.first()
  end






#
#
#
#def attackAttack(p1,p2) do
#
#end
#
#def attackSwap(p1,p2,attacker) do
#
#end
#
#def swapSwap(p1,p2) do
#
#end
#
#
#def playerAction(game ,player, action) do
#  if player == "player1" do
#    if game.player2Action == "" do
#
#      %{
#        gameState: game.gameState,
#        round: game.round,
#        player1: playerOneTeam,
#        player2: playerTwoTeam,
#        player1Action: action,
#        player2Action: game.player2Action,
#      }
#    else
#
#      if action == "attack" do
#        if game.player2Action == "attack" do
#
#          attackAttack(game.player1,game.player2)
#        else
#          attackSwap(game.player1,game.player2, "player1")
#
#        end
#      else
#        if game.player2Action == "attack" do
#
#          attackSwap(game.player1,game.player2, "player2")
#        else
#          swapSwap(game.player1,game.player2)
#
#        end
#
#      end
#
#
#    end
#
#  else
#    if game.player1Action == "" do
#
#      %{
#        gameState: game.gameState,
#        round: game.round,
#        player1: playerOneTeam,
#        player2: playerTwoTeam,
#        player1Action: game.player1Action,
#        player2Action: action,
#      }
#    else
#
#      if action == "attack" do
#        if game.player1Action == "attack" do
#
#          attackAttack(game.player1,game.player2)
#        else
#          attackSwap()
#
#        end
#      else
#        if game.player1Action == "attack" do
#
#          attackSwap()
#        else
#          swapSwap(game.player1,game.player2)
#
#        end
#
#      end
#
#
#    end
#
#
#
#  end
#
#
#
#end






















































































































































#############################################################################################

# Joe's



# Joe Working on
# input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
def getAngry(defenseProf) do
  # get id for input, and old anger
  50 # return a new anger
end

# Joe working on
# input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
# input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
def calAttack(attackProf,defenseProf) do

  # same as anger

  attack = Enum.fetch!(profs(),attackProf.id).attack

  defenseProfDate = Enum.fetch!(profs(),defenseProf.id)
  defense = defenseProfDate.defense
  hp = defenseProf.hp
# return new HP
  50

end

# input id of a prof
def getHp(prof) do
  hp = Enum.fetch!(profs(),prof).hp

  # use hp above to cal a initial HP for prof
  100

end

end