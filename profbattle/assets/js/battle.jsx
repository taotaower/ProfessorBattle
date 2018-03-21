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


    render() {

        return (

            <div class="container" style={{
                position: 'relative',

            }}>
                <p>Professor Clinger</p>
                <div class="card w-50">

                    <div class="row">
                        <p>HP</p>
                        <div class="progress">
                            <div class="progress-bar bg-success" role="progressbar" aria-valuenow="50"
                                 aria-valuemin="0" aria-valuemax="100" style={{width: 300}}></div>
                        </div>

                        <p>Anger</p>

                        <div class="progress">
                            <div class="progress-bar bg-danger" role="progressbar" style={{width: 300}}
                                 aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>

                    </div>
                </div>
            </div>
        );
    }

}

class ActionBtn extends React.Component {
    render() {

        return (
            <div class="justify-content-center">
                What will Professor Clinger do?
                <div class="btn-group" role="group" aria-label="player1 commands">
                    <button type="button" class="btn btn-secondary">ATTACK</button>
                    <button type="button" class="btn btn-secondary">SWAP</button>
                </div>
            </div>
        );
    }
}


class SelectProf extends React.Component {

    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.profs = props.profs;
        this.selectProf = props.selectProf;
        this.selectingPlayer = props.selectingPlayer;
        this.renderProfs = this.renderProfs.bind(this);
    }
    renderProfs(profs) {
        return profs.map((prof, index) => {
            return (
                <Prof key = {prof.id}
                    prof={prof}
                  //    channel = {this.channel}
                      selectProf={this.selectProf}
                      selectingPlayer = {this.selectingPlayer}/>
            );
        });
    }
    render() {
        return (<div className={"row"}>
            {this.renderProfs(this.profs)}
        </div>);
    }
}

class Prof extends React.Component {

    constructor(props) {
        super(props);
      //  this.clickEvent = this.clickEvent.bind(this);
        this.prof = props.prof;
        this.selectProf = props.selectProf.bind(this);
    //    this.channel = props.channel;
        this.selectingPlayer = props.selectingPlayer;
    }


    render(){

        let btn = <button type="button" className={"btn btn-primary"} onClick={() => this.selectProf(this.prof.id)}>Select</button>;

        if (this.prof.selected || this.selectingPlayer !== window.player){

            btn = <button type="button" className={"btn btn-secondary"} disabled>Select</button>;

        }


        return(
            <div className={"col-2"}>
                <div><b>{this.prof.name}</b></div>
                <div><p></p></div>
                <div><p></p></div>
                <div>{this.prof.pic} picture will show here</div>
                <div><b>HP:</b> {this.prof.hp}</div>
                <div><b>Attack:</b> {this.prof.attack}</div>
                <div><b>Defense:</b> {this.prof.defense}</div>
                <div><b>Speed:</b> {this.prof.speed}</div>
                <div><b>Special:</b> {this.prof.special}</div>
                <div><p></p></div>
                <div><p></p></div>
                {btn}
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
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => {
                console.log("Unable to join", resp)
            });
        this.selectProf = this.selectProf.bind(this);
        console.log("get reload for Battle")
    }




    gotView(view) {

        console.log("updating main view",view.game);
        console.log(this);

        this.setState(view.game);
        this.forceUpdate()
    }


    selectProf(prof) {

            this.channel.push("selectProf", {player: this.player, professor: prof})
                .receive("ok", this.gotView.bind(this))
                .receive("error", resp => { console.log("Unable to select", resp) });

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
            let selectingCon = <span>Please wait for another player to choose his/her Professor</span>;
            if (this.state.selectingPlayer === window.player){
                selectingCon = <span>Please select a Professor for yourself</span>;
            }
            console.log(this.state.selectingPlayer);

            return (
                <div>
                    {selectingCon}
                    <SelectProf key = {this.state.selectingPlayer}
                                profs={this.state.profs}
                                channel = {this.channel}
                                selectProf = {this.selectProf}
                                selectingPlayer = {this.state.selectingPlayer}/>
                </div>
            )

        }

        else if (this.state.gameState == 2) {
            // Main battle screen
            if (this.player === "player1")
                return (
                    <div>
                        <div className={"row"}>

                            <div className={"col"}>
                                <Display/>
                            </div>
                            <div className={"col"}>
                                <Display/>
                            </div>
                        </div>

                        <div className={"row"}>

                            <ActionBtn/>
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


