defmodule Profbattle.Game do

  def new do
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
      lastAction: DateTime.utc_now()
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

  def updateTeam(defenseProf,playerTwoTeam) do

    List.replace_at(playerTwoTeam, 0, defenseProf)

  end


  def cancelSpecial(attackProf) do
    attackProf = attackProf
                 |> Map.put(:anger, 0)
                 |> Map.put(:special, false)

  end


  def attackAction(game,special) do
    playerTurn = game.playerTurn
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    profNumPlayer1 = game.profNumPlayer1
    profNumPlayer2 = game.profNumPlayer2
    state = game.gameState
    player1Action = ""
    player2Action = ""
    phrase1 = ""
    phrase2 = ""
    msg = ""
    afraid = false;
    if playerTurn == "player1" do
      msg = "player1 attacks player2"
      attackProf = List.first(playerOneTeam)
      defenseProf = List.first(playerTwoTeam)
      if defenseProf.status == "Afraid" do
        afraid = true
        defenseProf = Map.put(defenseProf,:status, "active")
      end

      player1Action = "attack"
      phrase1 = getAttackPhrase(attackProf.id)
      oldHp =defenseProf.hp
      if special do
        # attack prof do a special
        hp = calSpecialAttack(attackProf,defenseProf,afraid)
        playerOneTeam = updateTeam(cancelSpecial(attackProf),playerOneTeam)
        phrase1= List.to_string([defenseProf.name , specialPhrs(attackProf.skill)])
        defenseProf = Map.put(defenseProf,:status, attackProf.skill)
        else
        hp = calAttack(attackProf,defenseProf,afraid)
      end
      if hp <= 0 do
        # defenseProf hp <= 0
        player1Action = "win"
        phrase1 = getWinPhrase(attackProf.id)
        profNumPlayer2 = profNumPlayer2 - 1
        defenseProf = Map.put(defenseProf,:status, "offline")
        defenseProf = Map.put(defenseProf,:hp, 0)
        playerTwoTeam = updateTeam(defenseProf,playerTwoTeam)
        if profNumPlayer2 == 0 do
          msg = "player1 wins"
          state = 3
          else
          playerTwoTeam = offSwap(playerTwoTeam,profNumPlayer2)
        end
      else
        # defenseProf hp > 0
        anger = getAngry(defenseProf,(hp - oldHp))
        if anger >= 100 do
          defenseProf = Map.put(defenseProf,:special, true)
        end
        defenseProf = Map.put(defenseProf,:hp, hp)
        defenseProf = Map.put(defenseProf,:anger, anger)
        playerTwoTeam = updateTeam(defenseProf,playerTwoTeam)
      end
      else
      # player2 attacks player1
      msg = "player2 attacks player1"
      attackProf = List.first(playerTwoTeam)
      defenseProf = List.first(playerOneTeam)
      if defenseProf.status == "Afraid" do
        afraid = true
        defenseProf = Map.put(defenseProf,:status, "active")
      end
      player2Action = "attack"
      phrase2 = getAttackPhrase(attackProf.id)
      oldHp =defenseProf.hp
      if special do
        # attack prof do a special
        hp = calSpecialAttack(attackProf,defenseProf,afraid)
        playerTwoTeam = updateTeam(cancelSpecial(attackProf),playerTwoTeam)
        phrase2=  List.to_string([ defenseProf.name , specialPhrs(attackProf.skill)])
        defenseProf = Map.put(defenseProf,:status, attackProf.skill)
      else
        hp = calAttack(attackProf,defenseProf,afraid)
      end
      if hp <= 0 do
        # defenseProf hp <= 0
        player2Action = "win"
        phrase2 = getWinPhrase(attackProf.id)
        profNumPlayer1 = profNumPlayer1 - 1
        defenseProf = Map.put(defenseProf,:status, "offline")
        defenseProf = Map.put(defenseProf,:hp, 0)
        playerOneTeam = updateTeam(defenseProf,playerOneTeam)
        if profNumPlayer1 == 0 do
          msg = "Player2 wins "
          state = 3
        else
          playerOneTeam = offSwap(playerOneTeam,profNumPlayer1)
        end
      else
        # defenseProf hp > 0
        anger = getAngry(defenseProf,(hp - oldHp))
        if anger >= 100 do
          defenseProf = Map.put(defenseProf,:special, true)
        end
        defenseProf = Map.put(defenseProf,:hp, hp)
        defenseProf = Map.put(defenseProf,:anger, anger)
        playerOneTeam = updateTeam(defenseProf,playerOneTeam)
      end

    end


    %{
      gameState: state,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: player1Action,
      player2Action: player2Action,
      profNumPlayer1: profNumPlayer1,
      profNumPlayer2: profNumPlayer2,
      phrase1: phrase1,
      phrase2: phrase2,
      phrase: "",
      msg: msg,
      lastAction: DateTime.utc_now()
    }

  end


  def selfAttackAction(game) do
    playerTurn = game.playerTurn
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    profNumPlayer1 = game.profNumPlayer1
    profNumPlayer2 = game.profNumPlayer2
    state = game.gameState
    player1Action = ""
    player2Action = ""
    phrase1 = ""
    phrase2 = ""
    msg = ""

    if playerTurn == "player1" do
      # player1 attack himself

      attackProf = List.first(playerOneTeam)
      player1Action = "attack"
      phrase1 = getAttackPhrase(attackProf.id)
      hp = attackProf.hp - 10

      if hp <= 0 do
        player2Action = "win"
        phrase2 = getWinPhrase(attackProf.id)
        profNumPlayer1 = profNumPlayer1 - 1
        attackProf = Map.put(attackProf,:status, "offline")
        attackProf = Map.put(attackProf,:hp, 0)
        playerOneTeam = updateTeam(attackProf,playerOneTeam)

        if profNumPlayer1 == 0 do
          msg = "Player2 wins "
          state = 3
        else
          playerOneTeam = offSwap(playerOneTeam,profNumPlayer1)
        end

        else
        # hp > 0
        attackProf = Map.put(attackProf,:status, "active")
        attackProf = Map.put(attackProf,:hp, hp)
        playerOneTeam = updateTeam(attackProf,playerOneTeam)


        end
      else

      # player2 attack himself

      attackProf = List.first(playerTwoTeam)
      player2Action = "attack"
      phrase2 = getAttackPhrase(attackProf.id)
      hp = attackProf.hp - 10
      if hp <= 0 do
        player1Action = "win"
        phrase1 = getWinPhrase(attackProf.id)
        profNumPlayer2 = profNumPlayer2 - 1
        attackProf = Map.put(attackProf,:status, "offline")
        attackProf = Map.put(attackProf,:hp, 0)
        playerTwoTeam = updateTeam(attackProf,playerTwoTeam)
        if profNumPlayer2 == 0 do
          msg = "player1 wins"
          state = 3
        else
          playerTwoTeam = offSwap(playerTwoTeam,profNumPlayer2)
        end
      else
      # hp > 0
        attackProf = Map.put(attackProf,:status, "active")
        attackProf = Map.put(attackProf,:hp, hp)
        playerTwoTeam = updateTeam(attackProf,playerTwoTeam)

      end

      end

    %{
      gameState: state,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: player1Action,
      player2Action: player2Action,
      profNumPlayer1: profNumPlayer1,
      profNumPlayer2: profNumPlayer2,
      phrase1: phrase1,
      phrase2: phrase2,
      phrase: "",
      msg: msg,
      lastAction: DateTime.utc_now()
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
    phrase1 = ""
    phrase2 = ""
    msg = ""
    player1Action = ""
    player2Action = ""
    if playerTurn == "player1" do

      if escape(playerOneTeam,playerTwoTeam) do

        profLeft = playerOneTeam
               |> List.first()
               |> addHP(10)

        playerOneTeam = updateTeam(profLeft,playerOneTeam)

        playerOneTeam = swap(playerOneTeam,profNumPlayer1,prof)
        player1Action = "swap"
        phrase1 = getTeamOpen(playerOneTeam)
        else
        player1Action = "caught"
        phrase1 = caughtPhrase()
      end

     else

      if escape(playerTwoTeam,playerOneTeam) do

        profLeft = playerTwoTeam
                   |> List.first()
                   |> addHP(10)
        playerTwoTeam = updateTeam(profLeft,playerTwoTeam)

        playerTwoTeam = swap(playerTwoTeam,profNumPlayer2,prof)
        phrase2 = getTeamOpen(playerTwoTeam)
        player2Action = "swap"
        else
        player2Action = "caught"
        phrase2 = caughtPhrase()
      end
    end

    %{
      gameState: game.gameState,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: player1Action,
      player2Action: player2Action,
      profNumPlayer1: profNumPlayer1,
      profNumPlayer2: profNumPlayer2,
      phrase1: phrase1,
      phrase2: phrase2,
      phrase: "",
      msg: msg,
      lastAction: DateTime.utc_now()
    }


  end



  def coffeeAction(game) do
    playerTurn = game.playerTurn
    player1Action = ""
    player2Action = ""
    phrase1 = ""
    phrase2 = ""
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    if playerTurn == "player1" do

      prof = playerOneTeam
             |> List.first()
             |> addHP(25)
      prof = Map.put(prof,:status, "active")
      playerOneTeam = updateTeam(prof,playerOneTeam)
      phrase1 = coffeePhrase()
      player1Action = "coffee"
    else
      prof = playerTwoTeam
             |> List.first()
             |> addHP(25)
      prof = Map.put(prof,:status, "active")
      playerTwoTeam = updateTeam(prof,playerTwoTeam)
      phrase2 = coffeePhrase()
      player2Action = "coffee"
    end


    %{
      gameState: game.gameState,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: player1Action,
      player2Action: player2Action,
      profNumPlayer1: game.profNumPlayer1,
      profNumPlayer2: game.profNumPlayer2,
      phrase1: phrase1,
      phrase2: phrase2,
      phrase: "",
      msg: "",
      lastAction: DateTime.utc_now()
    }


  end



  def sleepAction(game) do

    playerTurn = game.playerTurn
    player1Action = ""
    player2Action = ""
    phrase1 = ""
    phrase2 = ""
    playerOneTeam = game.player1
    playerTwoTeam = game.player2
    if playerTurn == "player1" do

      prof = playerOneTeam
             |> List.first()
      prof = Map.put(prof,:status, "active")
      playerOneTeam = updateTeam(prof,playerOneTeam)
      phrase1 = sleepPhrase()
      player1Action = "sleep"
    else
      prof = playerTwoTeam
             |> List.first()
      prof = Map.put(prof,:status, "active")
      playerTwoTeam = updateTeam(prof,playerTwoTeam)
      phrase2 = sleepPhrase()
      player2Action = "sleep"
    end


    %{
      gameState: game.gameState,
      round: (game.round + 1),
      playerTurn: nextPlayer(playerTurn),
      player1: playerOneTeam,
      player2: playerTwoTeam,
      player1Action: player1Action,
      player2Action: player2Action,
      profNumPlayer1: game.profNumPlayer1,
      profNumPlayer2: game.profNumPlayer2,
      phrase1: phrase1,
      phrase2: phrase2,
      phrase: "",
      msg: "",
      lastAction: DateTime.utc_now()
    }

  end


  def nextPlayer(player) do
    if player == "player1" do
      "player2"
    else
      "player1"
    end

  end


  def escape(team1,team2) do
    speed1 = Enum.fetch!(profs(),List.first(team1).id).speed
    speed2 = Enum.fetch!(profs(),List.first(team2).id).speed
    chance = true

    if speed1 > speed2 do
      chance = Enum.shuffle([true,true,false,true,true])
               |>List.first()
      else
      chance = Enum.shuffle([true,false])
               |>List.first()
    end

    chance
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
      lastAction: DateTime.utc_now()

    }
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
       playerOneTeam = playerOneTeam ++ [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: (profNumPlayer1+1), special: false, name: getName(prof), pic: getPic(prof),skill: getSkill(prof)}]
       profNumPlayer1 = profNumPlayer1 + 1
    else
      playerTwoTeam = playerTwoTeam ++ [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: (profNumPlayer2+1), special: false, name: getName(prof), pic: getPic(prof), skill: getSkill(prof) }]
      profNumPlayer2 = profNumPlayer2 + 1
    end

    updateProf = Map.put(Enum.fetch!(gameProfs,prof),:selected, true)
    gameProfs = List.replace_at(gameProfs, prof, updateProf)

    if (profNumPlayer1 + profNumPlayer2) == 6 do
      playerOneTeam = playerOneTeam
                      |> Enum.shuffle()
      playerTwoTeam = playerTwoTeam
                      |> Enum.shuffle()
      phrase1 = getTeamOpen(playerOneTeam)
      phrase2 =  getTeamOpen(playerTwoTeam)


      %{
        gameState: 2,
        round: 0,
        playerTurn: nextPlayer(playerTurn),
        player1: playerOneTeam,
        player2: playerTwoTeam,
        player1Action: "swap",
        player2Action: "swap",
        profNumPlayer1: profNumPlayer1,
        profNumPlayer2: profNumPlayer2,
        phrase1: phrase1,
        phrase2: phrase2,
        msg: "",
        lastAction: DateTime.utc_now()
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
        lastAction: DateTime.utc_now()
      }
    end
  end




  def profs() do
    # define profs' info here
    [
      %{id: 0, name: "clinger", hp: 3.63, attack: 4.05, defense: 3.95, speed: 3.61, special: 5.60,
        pic: %{unselected: "/images/Clinger.jpg", selected: "/images/Clinger-grey.jpg",
          oneSelected: "/images/Clinger-blue-grey.jpg", twoSelected: "/images/Clinger-red-grey.jpg"}, selected: false , skill: "Afraid"}, #Afraid
      %{id: 1, name: "tuck", hp: 4.37, attack: 3.43, defense: 4.53, speed: 4.23, special: 4.27,
        pic: %{unselected: "/images/Tuck.jpg", selected: "/images/Tuck-grey.jpg",
          oneSelected: "/images/Tuck-blue-grey.jpg", twoSelected: "/images/Tuck-red-grey.jpg"},selected: false, skill: "Confusion"}, #Confusion
      %{id: 2, name: "platt", hp: 3.93, attack: 3.83, defense: 4.17, speed: 4.25, special: 3.57,
        pic: %{unselected: "/images/Platt.jpg", selected: "/images/Platt-grey.jpg",
          oneSelected: "/images/Platt-blue-grey.jpg", twoSelected: "/images/Platt-red-grey.jpg"},selected: false, skill: "Confusion"},#Confusion
      %{id: 3, name: "young", hp: 4.78, attack: 3.42, defense: 4.84, speed: 4.83, special: 3.00,
        pic: %{unselected: "/images/Young.jpg", selected: "/images/Young-grey.jpg",
          oneSelected: "/images/Young-blue-grey.jpg", twoSelected: "/images/Young-red-grey.jpg"},selected: false, skill: "Asleep"},#Asleep
      %{id: 4, name: "weintraub", hp: 3.90, attack: 4.75, defense: 4.27, speed: 3.87, special: 4.76,
        pic: %{unselected: "/images/Michael.jpg", selected: "/images/Michael-grey.jpg",
          oneSelected: "/images/Michael-blue-grey.jpg", twoSelected: "/images/Michael-red-grey.jpg"},selected: false, skill: "Asleep"},#Asleep
      %{id: 5, name: "derbinsky", hp: 4.73, attack: 3.90, defense: 4.73, speed: 4.58, special: 3.40,
        pic: %{unselected: "/images/nate.jpg", selected: "/images/nate-grey.jpg",
          oneSelected: "/images/nate-blue-grey.jpg", twoSelected: "/images/nate-red-grey.jpg"},selected: false, skill: "Afraid"},#Afraid
    ]
  end


  def profsPhrase() do

    [
      %{id: 0, openPhrase: "I hope you've prepared questions for me" , winPhrase: "You may sit down now" ,attackPhrase: ["The problem with Scotland, is that it is full of Scots","Stand up when you address me"]},
      %{id: 1, openPhrase: "Good morning everybody!", winPhrase: "Good luck with your homework" ,attackPhrase: ["Most of our time in class will be spent on installing dependencies","Create a server for me in Elixir"]},
      %{id: 2, openPhrase: "Wait, these slides don't look familiar", winPhrase: "You obviously didn't read the slides" ,attackPhrase: ["R2-D2 is better than BB-8"]},
      %{id: 3, openPhrase: "What shall we discuss today?", winPhrase: "My notes will be available on Blackboard" ,attackPhrase: ["Prove this","Your assertions are invalid","1. Suppose for contradiction that {J1} ∪ R is not optimal for I.; 2. Since R ⊆ D, each job in R is pairwise disjoint from J1, so {J1} ∪ R is feasible for I.; 3. Since {J1} ∪ R is not optimal for I, it must be that there exists a larger feasible solution for I.; 4. Let S be a larger optimal solution for I, with J1 in S. (S exists by Lemma 1.);"]},
      %{id: 4, openPhrase: "Hopefully, everybody did reading assignment", winPhrase: "You will get a B if your project only meets expectations" ,attackPhrase: ["Reading quiz time!","Ni hao"]},
      %{id: 5, openPhrase: "I'm Nate, not Nat", winPhrase: "Any questions so far?" ,attackPhrase: ["You are stuck here, Wohahahaha","I have no idea when the class ends"]},
    ]

  end


  def specialPhrs(skill)do
    phrs = ""

    if skill == "Afraid" do
      phrs = "  is afraid!  He quivers in fear!"
    end
    if skill == "Confusion" do
      phrs = "  is confused!! He hurts himself in his confusion!"
    end
    if skill == "Asleep" do
      phrs = "  fell asleep!"
    end

    phrs
  end

  def caughtPhrase() do
    Enum.shuffle(["Oops, I get caught....","Literally, I don't wanna play this game....","OMG, Just Let me go!"])
    |>List.first()
  end

  def coffeePhrase() do
    Enum.shuffle(["Handle me cold brew, please....","Black ice coffee brings me to life","Ice Latte, please!"])
    |>List.first()
  end

  def sleepPhrase() do
    Enum.shuffle(["Let me take a nap....", "I'm just tired", "15 mins break, I just need a rest"])
    |>List.first()
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


  def getAttackPhrase(id) do
    Enum.fetch!(profsPhrase(),id).attackPhrase
                 |>Enum.shuffle()
                 |>List.first()
  end

  def getWinPhrase(id) do
    Enum.fetch!(profsPhrase(),id).winPhrase
  end


  def getPic(id) do
    Enum.fetch!(profs(),id).pic.unselected
  end

  def getName(id) do
    Enum.fetch!(profs(),id).name
  end

  def getSkill(id) do
    Enum.fetch!(profs(),id).skill
  end



  def calAttack(attackProf,defenseProf,afraid) do
    attack = Enum.fetch!(profs(),attackProf.id).attack
    defense = Enum.fetch!(profs(),defenseProf.id).defense
    hp = defenseProf.hp

    bonusDamage = 0
    if afraid do
      defense = defense * 0.75
    end

    if (attack + 1- defense) > 0 do
      bonusDamage = attack + 1 - defense
    end

    hp = hp - (20 + (bonusDamage * 10))


  end


  def calSpecialAttack(attackProf,defenseProf,afraid) do
    attack = Enum.fetch!(profs(),attackProf.id).attack
    defense = Enum.fetch!(profs(),defenseProf.id).defense
    hp = defenseProf.hp
    attackerHp = attackProf.hp

    bonusDamage = 0

    if afraid do
      defense = defense * 0.75
    end

    if (attack + 1 - defense) > 0 do
      bonusDamage = attack + 1 - defense
    end

    hp = hp - (20 + (bonusDamage * 10) + (100 - attackerHp) * 0.1)

  end



  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
  def getAngry(defenseProf,hpchange) do
    anger = defenseProf.anger
    special = Enum.fetch!(profs(),defenseProf.id).special

    anger = anger + (special * 12) + (hpchange / 2) + 5

    if anger > 100 do
      anger = 100
    end

    anger
  end


  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]
  # input [%{id: prof, hp: getHp(prof), anger: 0, status: "active", seq: 0, special: false}]


  # input id of a prof
  def getHp(prof) do
    hp = Enum.fetch!(profs(),prof).hp

    95 + ((hp - 3.63) * 13 )

  end

  def addHP(prof,amount) do
    hp = prof.hp + amount

    if hp > 100 do
      hp = 100
    end

    newProf = prof
             |> Map.put(:anger, 0)
             |> Map.put(:special, false)
             |> Map.put(:hp, hp)

  end


end