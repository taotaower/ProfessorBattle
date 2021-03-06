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
        this.phrase = props.phrase;
        this.action = props.action;
        this.renderPhrase = this.renderPhrase.bind(this);

    }

    renderPhrase(){
        if (this.action ===""){
            return
        }
        if (this.action === "swap"){
            return <div class="alert alert-info phrase" role="alert">
                <text>{this.phrase}</text>

            </div>}
        else if(this.action === "attack"){
            return <div class="alert alert-danger phrase" role="alert">
                <text>{this.phrase}</text>
            </div>
        }
        else if(this.action === "coffee"){
            return <div class="alert alert-success phrase" role="alert">
                <text>{this.phrase}</text>
            </div>
        }
        else {
            return <div class="alert alert-warning phrase" role="alert">
                <text>{this.phrase}</text>
            </div>
        }

    }

    render() {

        let instruct = "";
        let status = "";
        let profName = "Professor " + this.prof.name.charAt(0).toUpperCase() + this.prof.name.slice(1);
        if (this.instr){
            instruct = <h4 style={{position:"relative",top:"50px"}} >What will Professor {this.prof.name} do ?</h4>
        }
        if (this.prof.status !== 'active') {
            status = <button type="button" class="btn btn-danger" disabled>{this.prof.status}</button>
        }
        $('.phrase').delay(2000).fadeOut();
        return (

            <div class="container" style={{
                position: 'relative',

            }}>
                <h3>{profName}</h3>
                <div className={"row"}>
                <div className={"col-4"}>
                    <img src= {this.prof.pic} width={"128"}/>
                </div>
                <div className={"col-8"}>
                        {this.renderPhrase()}
                </div>
                </div>
                <div>
                    <p>HP</p>
                    <div class="progress">
                        <div class="progress-bar bg-success progress-bar-striped" role="progressbar" aria-valuenow= {this.prof.hp}
                             aria-valuemin="0" aria-valuemax="100" style={{width: this.prof.hp + "%"}}></div>
                    </div>
                    <p>Anger</p>

                    <div class="progress">
                        <div class="progress-bar bg-danger progress-bar-striped" role="progressbar" style={{width: this.prof.anger + "%"}}
                             aria-valuenow = {this.prof.anger} aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <div> <p></p> </div>
                    <div> <p></p> </div>
                    <div> {status} </div>
                </div>

                {instruct}

            </div>

        );
    }
}




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
            let selRadio = <input type="radio" name={"swapProf"} value={index} onClick={() => this.chooseProf(index)}/>;
            if (prof.status === "offline"){
                selRadio = <p></p>;
            }
            return (
                <div className={"col-5"}>
                <label>
                    {selRadio}
                    <div><b>{prof.name}</b></div>
                    <div><p></p></div>
                    <div><p></p></div>
                    <div><b>HP:</b> {Math.round(prof.hp)}</div>
                    <div><b>Anger:</b> {Math.round(prof.anger)}</div>
                    <div><b>Status:</b> {prof.status}</div>
                    <div><b>skill:</b> {prof.skill}</div>
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

        let profName = this.prof.name.charAt(0).toUpperCase() + this.prof.name.slice(1);

        let img = <img src={this.prof.pic.unselected} width={"128"} style={{cursor: "pointer"}}
                       onClick={() => this.selectProf(this.prof.id)}/>;

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
                <div><b>{profName}</b></div>
                <div><p></p></div>
                <div><p></p></div>
                <div>{img}</div>
                <div><b>HP:</b> {this.prof.hp}</div>
                <div><b>Attack:</b> {this.prof.attack}</div>
                <div><b>Defense:</b> {this.prof.defense}</div>
                <div><b>Speed:</b> {this.prof.speed}</div>
                <div><b>Special:</b> {this.prof.special}</div>
                <div><b>Skill:</b> {this.prof.skill}</div>
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
        this.renderButtons = this.renderButtons.bind(this);
        this.attackAction = this.attackAction.bind(this);
        this.selfAttackAction = this.selfAttackAction.bind(this);
        this.specialAttackAction = this.specialAttackAction.bind(this);
        this.coffeeAction = this.coffeeAction.bind(this);
        this.sleepAction = this.sleepAction.bind(this);
        // this.countDown = this.countDown.bind(this);

        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => {
                console.log("Unable to join", resp)
            });

        this.channel.on("update", this.gotView.bind(this))
    }

    gotView(view) {


        this.setState(view.game);
        this.forceUpdate()

    }

    showSwapPad(){

        let swapPad = $("#backup-pad");

        let actionBtns = $("#action-btns");

        swapPad.show("slow");
        actionBtns.hide();


    }
    coffeeAction(){
        this.channel.push("coffee", {})
    }

    attackAction(){
        this.channel.push("attack", {special: false})
    }

    selfAttackAction(){
        this.channel.push("selfAttack", {})
    }

    specialAttackAction(){
        this.channel.push("attack", {special: true})
    }

    sleepAction(){
        this.channel.push("sleep", {})
    }
    //
    // countDown(time){
    //
    //     function startTimer(duration, display) {
    //         let that = this;
    //         setInterval(function () {
    //
    //             duration = parseInt(duration) - 1;
    //             if (duration < 0) {
    //                 duration = 0;
    //                 this.channel.push("sleep", {})
    //             }
    //
    //             display.text(duration);
    //
    //
    //         }, 1000);
    //     }
    //
    //     let timer = $("#time");
    //     startTimer(time, timer);
    //
    //     return <div><b><span id="time">time</span></b> second(s) left for making action</div>
    // }


    renderButtons(special,status) {
        let specialBtn = <button id={"special-attack-btn"} className={"btn btn-danger btn-lg"}  disabled={true}><b>Special Attack !</b></button>;
        let coffeeBtn = <button id={"coffee-btn"} className={"btn btn-light btn-lg"}  disabled={true}><b>Ice Coffee</b></button>;
        let attackBtn = <button id={"attack-btn"} className={"btn btn-info"} onClick={this.attackAction}>Attack</button>;
        let swapBtn = <button id={"swap-btn"} className={"btn btn-warning"} onClick={this.showSwapPad}>Swap</button>;
        let skipBtn = "";
        if (special){
            specialBtn = <button id={"special-attack-btn"} className={"btn btn-danger btn-lg"} onClick={this.specialAttackAction}><b>Special Attack !</b></button>;
            coffeeBtn = <button id={"coffee-btn"} className={"btn btn-light btn-lg"} onClick={this.coffeeAction}><b>Ice Coffee</b></button>;
        }

        if (status === "Confusion" ){
            swapBtn = <button id={"swap-btn"} className={"btn btn-warning"} onClick={this.showSwapPad} disabled={true}>Swap</button>;
            specialBtn = <button id={"special-attack-btn"} className={"btn btn-danger btn-lg"}  disabled={true}><b>Special Attack !</b></button>;
            attackBtn = <button id={"attack-btn"} className={"btn btn-info"} onClick={this.selfAttackAction}>Attack Myself :(</button>;

        }
        if (status === "Asleep" ){
            attackBtn = <button id={"attack-btn"} className={"btn btn-info"} onClick={this.attackAction} disabled={true}>Attack</button>;
            specialBtn = <button id={"special-attack-btn"} className={"btn btn-danger btn-lg"}  disabled={true}><b>Special Attack !</b></button>;
            skipBtn = <button id={"skip-btn"} className={"btn btn-success"} onClick={this.sleepAction}>Sleep Over it</button>;
            swapBtn = <button id={"swap-btn"} className={"btn btn-warning"} onClick={this.showSwapPad} disabled={true}>Swap</button>;

        }

        if (this.player === this.state.playerTurn && this.player !== "watcher" ) {
            return <div id={"action-btns"}>
                <div  class="btn-group btn-group-lg" role="group" aria-label="Basic example" style={{position:"relative",top:"100px", left:"20px"}}>
                <div >
                    {attackBtn}
                </div>
                <div >
                    {swapBtn}
                </div>
                    <div >
                        {skipBtn}
                    </div>
            </div>
                <div className={"btn-group btn-group-lg"} role="group" style={{position:"relative", top:"100px", left:"100px"}}>
                    {specialBtn}
                    {coffeeBtn}
            </div>
            </div>

        } else {
            return null;
        }
    }
    
    render() {

        let playerString = this.state.playerTurn;
        let playerLength = 0;

        if (playerString === "player1")
            {playerString = <font color="blue"><b> Player 1</b></font>;}
        else
            {playerString = <font color="maroon"><b> Player 2</b></font>;}

        if (this.state.gameState == 0) {
            // Waiting for Player 2 to join screen
            return (
                <div class="container">
                    <div class="panel panel-default">
                        <div class="panel-body">Waiting for <font color="maroon"><b> Player 2</b></font> to join.</div>
                    </div>
                </div>
            )
        }
        else if (this.state.gameState == 1) {
            // Professor selection screen

            let selectingCon = <span>{playerString} is choosing their Professor.</span>;

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

                    <div style={{position:"relative",top:"20px", left:"20px"}}>
                        <h4>Tips: </h4>
                        <ul style={{type: "list-style-type:disc"}}>
                            <li>Professors with a higher speed will have a higher chance to escape.</li>
                            <li>When a professor uses his special attack, his rival will receive one of the following status effects:</li>
                            <ul>
                                <li><b>Confusion:</b> Rival will attack himself in his confusion.</li>
                                <li><b>Afraid:</b> Rival's defense attribute decreases.</li>
                                <li><b>Asleep:</b> Rival falls asleep and must drink coffee to wake up.</li>
                            </ul>
                            <li>Drinking coffee will remove any negative status effects and recover some HP.</li>
                        </ul>

                    </div>
                </div>
            )

        }

        else if (this.state.gameState == 2) {

            let fightCon = <span>{playerString} is choosing their action</span>;
            let attackBtn = "";
            let swapBtn = "";
            // if (this.player === this.state.playerTurn && this.player !== "watcher" ){
            //     attackBtn = <button id={"attack-btn"} className={"btn btn-info"}>Attack</button>;
            //     swapBtn =<button id={"swap-btn"} className={"btn btn-warning"} onClick={this.showSwapPad}>Swap</button>
            // }

            let display1 = "";
            let display2 = "";
            let backup = "";
            let special = false;
            let instr = false;
            let status = "";

            if (this.state.playerTurn === this.player) {
                fightCon = <span>{playerString}, select your action!</span>;
                instr = true;
            }


            if (this.player === "player1"){
                let prof = this.state.player1[0];
                special = prof.special;
                status = prof.status;
                display1 = <Display
                           key = {this.state.round}
                           prof = {prof}
                           instr = {instr}
                           phrase = {this.state.phrase1}
                           action ={this.state.player1Action}/>;
                display2 = <Display
                    key = {this.state.round}
                           prof = {this.state.player2[0]}
                    phrase = {this.state.phrase2}
                    action ={this.state.player2Action}/>;

                backup =  <div id={"backup"} > <BackupProf
                    key = {this.state.round}
                    profs={this.state.player1.slice(1,3)}
                    profNumPlayer={this.state.profNumPlayer1}
                    channel = {this.channel}/></div>;
            }
            else if(this.player === "player2") {
                let prof = this.state.player2[0];
                special = prof.special;
                status = prof.status;
                display1 = <Display
                    key = {this.state.round}
                    prof = {prof}
                    instr = {instr}
                    phrase = {this.state.phrase2}
                    action ={this.state.player2Action}/>;
                display2 = <Display
                    key = {this.state.round}
                    prof = {this.state.player1[0]}
                    phrase ={this.state.phrase1}
                    action ={this.state.player1Action}
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
                    prof = {this.state.player1[0]}
                    phrase ={this.state.phrase1}
                    action ={this.state.player1Action}/>;
                display2 = <Display
                    key = {this.state.round}
                    prof = {this.state.player2[0]}
                    phrase ={this.state.phrase2}
                    action ={this.state.player2Action}
                />;
            }


            return (

                <div>
                    <div class="alert alert-dark" role="alert">
                        {fightCon}
                        {/*{this.countDown(15)}*/}
                    </div>
                    {/*{this.renderOpenPhrs()}*/}
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
                        {this.renderButtons(special,status)}

                        </div>

                        <div className={"col"} style={{position:"relative", left:"20px", display: "none"}} id={"backup-pad"} >
                            {backup}
                        </div>

                    </div>

                </div>


            )

        }

        else if (this.state.gameState == 3) {

            return (<div>
                    <h1><b>GAME OVER</b></h1>
                    <h2>{this.state.msg}</h2>
                    <div><p></p></div>
                    <div><p></p></div>
                    <a href="/">Return to Game Lobby</a>
                    </div>
            )
        }

        else {

            return (<div>Something goes wrong</div>)
        }

        //       return (<div>{this.state.gameState}</div>)

    }
}


