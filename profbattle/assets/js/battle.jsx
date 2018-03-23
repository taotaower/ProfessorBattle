import React from 'react';
import ReactDOM from 'react-dom';
import {Button} from 'reactstrap';

export default function run_game(root, channel) {
    ReactDOM.render(<Battle channel={channel}/>, root);
}

//gameState: Int
//  0 = 1player joined and waiting for player 2
//  1 = both players joined, professor selection screen
//  2 = professors selected, battle screen
//  3 = game over, victory screen

class Display extends React.Component {

    constructor(props) {
        super(props);

        this.prof = props.prof;
        this.instr = props.instr;

    }


    render() {

        let instruct = "";
        if (this.instr){
            instruct = <h4 style={{position:"relative",top:"50px"}} >What will Professor {this.prof.name} do ?</h4>
        }

        return (


            <div class="container" style={{
                position: 'relative',

            }}>
                <h3>{this.prof.name}</h3>
                <div class="card w-50">

                </div>
                <div>
                    <p>HP</p>
                    <div class="progress">
                        <div class="progress-bar bg-success" role="progressbar" aria-valuenow= {this.prof.hp}
                             aria-valuemin="0" aria-valuemax="100" style={{width: this.prof.hp + "%"}}></div>
                    </div>

                    <p>Anger</p>

                    <div class="progress">
                        <div class="progress-bar bg-danger" role="progressbar" style={{width: this.prof.anger + "%"}}
                             aria-valuenow = {this.prof.anger} aria-valuemin="0" aria-valuemax="100"></div>
                    </div>


                </div>

                {instruct}
            </div>
        );
    }

}

// class AttackBtn extends React.Component {
//
//     constructor(props) {
//         super(props);
//
//         this.channel = props.channel;
//
//         this.attackAction = this.attackAction.bind(this);
//     }
//     attackAction() {
//
//         this.channel.push("attack", {})
//
//     }
//
//
//     render() {
//
//         return (
//             <div class="justify-content-center">
//
//                 <div class="btn-group" role="group" aria-label="player1 commands">
//                     <button type="button" class="btn btn-secondary">ATTACK</button>
//         );
//     }
// }


class SelectProf extends React.Component {

    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.profs = props.profs;
        this.playerTurn = props.playerTurn;
        this.player1 = props.player1;
        this.player2 = props.player2;
        this.renderProfs = this.renderProfs.bind(this);
    }
    renderProfs(profs) {
        return profs.map((prof, index) => {
            return (
                <Prof key = {prof.id}
                      prof = {prof}
                      channel = {this.channel}
                      playerTurn = {this.playerTurn}
                      player1 = {this.player1}
                      player2 = {this.player2}/>
            );
        });
    }
    render() {
        return (<div className={"row"}>
            {this.renderProfs(this.profs)}
        </div>);
    }
}


class BackupProf extends React.Component {

    constructor(props) {
        super(props);
        //  this.clickEvent = this.clickEvent.bind(this);
        this.profs = props.profs;
        this.channel = props.channel;
        this.profNumPlayer = props.profNumPlayer ;
        this.swapAction = this.swapAction.bind(this);
        this.chooseProf = this.chooseProf.bind(this);
        this.renderProfs = this.renderProfs.bind(this);
        this.cancelSwap = this.cancelSwap.bind(this);

        this.SelectedId = "0";
    }

    swapAction(prof){
        this.channel.push("swap", {professor: prof})
        let swapPad = $("#backup-pad");
        swapPad.hide();

    }

    chooseProf(index){

        this.SelectedId = index;
        console.log(this.SelectedId)
    }

    cancelSwap(){
        let swapPad = $("#backup-pad");
        let actionBtns = $("#action-btns");

        swapPad.hide();
        actionBtns.show();

    }

    renderProfs(profs) {




        return profs.map((prof, index) => {
            let selRadio = <input type="radio"  value={index} onClick={() => this.chooseProf(index)}/>;
            if (prof.status === "offline"){
                selRadio = "";
            }
            return (
                <div className={"col-5"}>
                <label>
                    {selRadio}
                    <div><b>{prof.name}</b></div>
                    <div><p></p></div>
                    <div><p></p></div>
                    <div><b>HP:</b> {prof.hp}</div>
                    <div><b>Anger:</b> {prof.anger}</div>
                    <div><b>Status:</b> {prof.status}</div>
                    <div><p></p></div>
                    <div><p></p></div>
                </label>
                </div>

            );
        });
    }

    render(){
        let swapBtn = <button id={"ok"} className={"btn btn-primary"} onClick={() => this.swapAction(this.SelectedId)}>Ok</button>;

        if (this.profNumPlayer == 1){
            swapBtn = <button className={"btn btn-primary"} > You do not have any Professors in backup</button>
        }

        return(
            <div>
                <div className={"row"}>
                {this.renderProfs(this.profs)}
                </div>
                {swapBtn}
                <button id={"cancel"} className={"btn btn-danger"} onClick={this.cancelSwap}>Cancel</button>

            </div>
        )

    }



}

class Prof extends React.Component {

    constructor(props) {
        super(props);
      //  this.clickEvent = this.clickEvent.bind(this);
        this.prof = props.prof;
        this.channel = props.channel;
        this.playerTurn = props.playerTurn;
        this.player1 = props.player1;
        this.player2 = props.player2;
        this.selectProf = this.selectProf.bind(this);
    }

    selectProf(prof) {

        this.channel.push("selectProf", {professor: prof})

    }


    render(){

        console.log("p1=" + this.player1);
        console.log("p2=" + this.player2);

        let img = <img src={this.prof.pic.unselected} width={"128"} onClick={() => this.selectProf(this.prof.id)}/>;

        if (this.prof.selected || this.playerTurn !== window.player){

            img = <img src={this.prof.pic.selected} width={"128"}/>;

        }

            for (var i = 0; i < this.player1.length; i++) {
                if (this.player1[i].id === this.prof.id) {
                    img = <img src={this.prof.pic.oneSelected} width={"128"}/>;
                }
            }

            for (var i = 0; i < this.player2.length; i++) {
                if (this.player2[i].id === this.prof.id) {
                    img = <img src={this.prof.pic.twoSelected} width={"128"}/>;
                }
            }


        return(
            <div className={"col-2"}>
                <div><b>{this.prof.name}</b></div>
                <div><p></p></div>
                <div><p></p></div>
                <div>{img}</div>
                <div><b>HP:</b> {this.prof.hp}</div>
                <div><b>Attack:</b> {this.prof.attack}</div>
                <div><b>Defense:</b> {this.prof.defense}</div>
                <div><b>Speed:</b> {this.prof.speed}</div>
                <div><b>Special:</b> {this.prof.special}</div>
                <div><p></p></div>
                <div><p></p></div>
            </div>
        );
    }


}


class Battle extends React.Component {
    constructor(props) {
        super(props);
        this.player = window.player;
        this.channel = props.channel;
        this.state = {};
        this.showSwapPad = this.showSwapPad.bind(this);
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => {
                console.log("Unable to join", resp)
            });

        this.channel.on("update", this.gotView.bind(this))
    }



    gotView(view) {

        console.log(view.game.player1);
        console.log(view.game.player2);
        console.log(view.game.round);

        this.setState(view.game);
        this.forceUpdate()

    }

    showSwapPad(){

        let swapPad = $("#backup-pad");

        let actionBtns = $("#action-btns");

        swapPad.show("slow");
        actionBtns.hide();


    }


    render() {

        if (this.state.gameState == 0) {
            // Waiting for Player 2 to join screen
            return (
                <div class="container">
                    <div class="panel panel-default">
                        <div class="panel-body">Waiting for Player 2 to join.</div>
                    </div>
                </div>
            )
        }
        else if (this.state.gameState == 1) {
            // Professor selection screen
            let playerString = this.state.playerTurn;

            if (playerString === "player1")
            {playerString = <font color="blue"><b> Player 1</b></font>;}
            else
            {playerString = <font color="red"><b> Player 2</b></font>;}

            let selectingCon = <span>{playerString} is choosing their Professor</span>;

            let playerLength = 0

            if (this.state.playerTurn === "player1")
            {playerLength = this.state.player1.length;}
            else
            {playerLength = this.state.player2.length;}

            if (this.state.playerTurn === this.player) {
                if (playerLength === 0) {
                    selectingCon = <span>{playerString}, select your first Professor!</span>;
                }
                if (playerLength === 1) {
                    selectingCon = <span>{playerString}, select your second Professor!</span>;
                }
                if (playerLength === 2) {
                    selectingCon = <span>{playerString}, select your final Professor!</span>;
                }
            }

            return (
                <div>
                    {selectingCon}
                    <SelectProf key = {this.state.playerTurn}
                                profs={this.state.profs}
                                channel = {this.channel}
                                playerTurn = {this.state.playerTurn}
                                player1 = {this.state.player1}
                                player2 = {this.state.player2}/>
                </div>
            )

        }

        else if (this.state.gameState == 2) {

            let fightCon = <span>{this.state.playerTurn} is choosing his/her Action</span>;
            let attackBtn = "";
            let swapBtn = "";
            if (this.player === this.state.playerTurn && this.player !== "watcher" ){
                attackBtn = <button id={"attack-btn"} className={"btn btn-info"}>Attack</button>;
                swapBtn =<button id={"swap-btn"} className={"btn btn-warning"} onClick={this.showSwapPad}>Swap</button>
            }

            let display1 = "";
            let display2 = "";
            let backup = "";


            if (this.player === "player1"){
                display1 = <Display
                           key = {this.state.round}
                           prof = {this.state.player1[0]}
                           instr = {true}/>;
                display2 = <Display
                    key = {this.state.round}
                           prof = {this.state.player2[0]}
                           />;

                backup =  <div id={"backup"} > <BackupProf
                    key = {this.state.round}
                    profs={this.state.player1.slice(1,3)}
                    profNumPlayer={this.state.profNumPlayer1}
                    channel = {this.channel}/></div>;
            }
            else if(this.player === "player2") {
                display1 = <Display
                    key = {this.state.round}
                    prof = {this.state.player2[0]}
                    instr = {true}/>;
                display2 = <Display
                    key = {this.state.round}
                    prof = {this.state.player1[0]}
                    />;

                backup =  <div id={"backup"} > <BackupProf
                    key = {this.state.round}
                    profs={this.state.player2.slice(1,3)}
                    profNumPlayer={this.state.profNumPlayer2}
                    channel = {this.channel}/></div>;
            }
            else {
                display1 = <Display
                    key = {this.state.round}
                    prof = {this.state.player1[0]}/>;
                display2 = <Display
                    key = {this.state.round}
                    prof = {this.state.player2[0]}
                />;
            }


            return (

                <div>
                    <div class="alert alert-dark" role="alert">
                        {fightCon}
                    </div>

                    <div className={"row"}>

                        <div className={"col"}>
                            {display1}
                        </div>
                        <div className={"col"}>
                            {display2}
                        </div>
                    </div>

                    <div className={"row"}>

                        <div className={"col"}>
                    <div id={"action-btns"} class="btn-group btn-group-lg" role="group" aria-label="Basic example" style={{position:"relative",top:"100px", left:"20px"}}>

                        <div >
                            {attackBtn}
                        </div>

                        <div >
                            {swapBtn}
                        </div>
                    </div>

                    </div>
                        <div className={"col"} style={{position:"relative", left:"20px", display: "none"}} id={"backup-pad"} >
                            {backup}
                        </div>

                    </div>

                </div>


            )

        }

        else if (this.state.gameState == 3) {
            // Game over screen
        }

        else {

            return (<div>Something goes wrong</div>)
        }

        //       return (<div>{this.state.gameState}</div>)

    }
}


