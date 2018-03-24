defmodule Profbattle.Game do

  def new do
    # new will randomly create 3 profs to player1
    %{
      gameState: 0,
      round: 0, #delete maybe
      playerTurn: "",
      player1: [],
      player2: [],
      player1Action: "",
      player2Action: "",
      profNumPlayer1: 0,
      profNumPlayer2: 0,
      phrase: "",
      msg: "",

    }
  end


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
    state = game.gameState
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

      if prof == 0 do

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
    openPhrase1 = ""
    openPhrase2 = ""
    msg = ""
    if playerTurn == "player1" do

      playerOneTeam = swap(playerOneTeam,profNumPlayer1,prof)
      openPhrase1 = getTeamOpen(playerOneTeam)
     else
      playerTwoTeam = swap(playerTwoTeam,profNumPlayer2,prof)
      openPhrase2 = getTeamOpen(playerTwoTeam)

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
      openPhrase1: openPhrase1,
      openPhrase2: openPhrase2,
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
      openPhrase1 = getTeamOpen(playerOneTeam)
      openPhrase2 =  getTeamOpen(playerTwoTeam)


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
        openPhrase1: openPhrase1,
        openPhrase2: openPhrase2,
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
        msg: "",
      }
    end
  end




  def profs() do
    # define profs' info here
    [
      %{id: 0, name: "clinger", hp: 3.63, attack: 4.05, defense: 3.95, speed: 3.61, special: 5.00,
        pic: %{unselected: "/images/Clinger.jpg", selected: "/images/Clinger-grey.jpg",
          oneSelected: "/images/Clinger-blue-grey.jpg", twoSelected: "/images/Clinger-red-grey.jpg"}, selected: false},
      %{id: 1, name: "tuck", hp: 4.37, attack: 3.43, defense: 4.53, speed: 4.23, special: 4.07,
        pic: %{unselected: "/images/Tuck.jpg", selected: "/images/Tuck-grey.jpg",
          oneSelected: "/images/Tuck-blue-grey.jpg", twoSelected: "/images/Tuck-red-grey.jpg"},selected: false},
      %{id: 2, name: "platt", hp: 3.93, attack: 3.83, defense: 4.17, speed: 4.25, special: 3.57,
        pic: %{unselected: "/images/Platt.jpg", selected: "/images/Platt-grey.jpg",
          oneSelected: "/images/Platt-blue-grey.jpg", twoSelected: "/images/Platt-red-grey.jpg"},selected: false},
      %{id: 3, name: "young", hp: 4.78, attack: 3.42, defense: 4.84, speed: 4.83, special: 3.00,
        pic: %{unselected: "/images/Young.jpg", selected: "/images/Young-grey.jpg",
          oneSelected: "/images/Young-blue-grey.jpg", twoSelected: "/images/Young-red-grey.jpg"},selected: false},
      %{id: 4, name: "weintraub", hp: 3.90, attack: 4.75, defense: 4.27, speed: 3.87, special: 4.76,
        pic: %{unselected: "/images/Michael.jpg", selected: "/images/Michael-grey.jpg",
          oneSelected: "/images/Michael-blue-grey.jpg", twoSelected: "/images/Michael-red-grey.jpg"},selected: false},
      %{id: 5, name: "derbinsky", hp: 4.73, attack: 3.90, defense: 4.73, speed: 4.58, special: 3.40,
        pic: %{unselected: "/images/nate.jpg", selected: "/images/nate-grey.jpg",
          oneSelected: "/images/nate-blue-grey.jpg", twoSelected: "/images/nate-red-grey.jpg"},selected: false},
    ]
  end


  def profsPhrase() do

    [
      %{id: 0, openPhrase: "I hope you've prepared questions for me" , winPhrase: "You may sit down now" ,attackPhrase: ["The problem with Scotland, is that it is full of Scots","Stand up when you address me"]},
      %{id: 1, openPhrase: "Good morning everybody!", winPhrase: "Good luck for your homework" ,attackPhrase: ["Most of our time in class will spend on installing dependencies","Create a server for me in Elixir"]},
      %{id: 2, openPhrase: "Wait, these slides don't look familiar", winPhrase: "Obviously, You didn't read the slides" ,attackPhrase: ["R2-D2 is better than BB-8"]},
      %{id: 3, openPhrase: "What shall we discuss today?", winPhrase: "My notes will be available on Blackboard" ,attackPhrase: ["Prove this","Your assertions are invalid","1. Suppose for contradiction that {J1} ∪ R is not optimal for I.; 2. Since R ⊆ D, each job in R is pairwise disjoint from J1, so {J1} ∪ R is feasible for I.; 3. Since {J1} ∪ R is not optimal for I, it must be that there exists a larger feasible solution for I.; 4. Let S be a larger optimal solution for I, with J1 in S. (S exists by Lemma 1.);"]},
      %{id: 4, openPhrase: "Hopefully, everybody did reading assignment", winPhrase: "You will get B, if your project only meet expectation" ,attackPhrase: ["Reading quiz time","Ni hao"]},
      %{id: 5, openPhrase: "I'm Nate, not Nat", winPhrase: "Any questions so far?" ,attackPhrase: ["You are stuck here, Wohahahaha","I have no idea when the class ends"]},
    ]

  end

  def initplayerTurn() do
    Enum.shuffle(["player1","player2"])
          |>List.first()
  end

  def getTeamOpen(team) do
    List.first(team).id
    |> getOpenPhrase()

  end

  def getOpenPhrase(id) do
    Enum.fetch!(profsPhrase(),id).openPhrase
  end






















































































































































#############################################################################################

# Joe's

  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
  def getAngry(defenseProf) do
    anger = defenseProf.anger
    special = Enum.fetch!(profs(),defenseProf.id).special

    anger = anger + (special * 20)
    #50

  end

  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
  def calAttack(attackProf,defenseProf) do
    attack = Enum.fetch!(profs(),attackProf.id).attack
    defense = Enum.fetch!(profs(),defenseProf.id).defense
    hp = defenseProf.hp

    bonusDamage = 0

    if (attack - defense) > 0 do
      bonusDamage = attack - defense
    end

    hp = hp - (20 + (bonusDamage * 10))
    #50

  end

  # input id of a prof
  def getHp(prof) do
    hp = Enum.fetch!(profs(),prof).hp

    # use hp above to cal a initial HP for prof
    100

  end

end