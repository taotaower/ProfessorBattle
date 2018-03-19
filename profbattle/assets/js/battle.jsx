import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_game(root, channel) {
    ReactDOM.render(<Battle channel={channel} />, root);
}

//gameState: Int
//  0 = 1player joined and waiting for player 2
//  1 = both players joined, professor selection screen
//  2 = professors selected, battle screen
//  3 = game over, victory screen

class Battle extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = {
            gameState: 2
        };
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp) });
    }

    gotView(view) {
        console.log("New view", view);
        this.setState(view.game);
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
        )} else if (this.state.gameState == 1) {
            // Professor selection screen
        } else if (this.state.gameState == 2) {
            // Main battle screen
            return (
                <div class="container">
                    <div class="card w-50">
                        <p>Professor Clinger</p>
                        <div class="row">
                            <p>HP</p>
                        <div class="progress">
                            <div class="progress-bar bg-success" role="progressbar" aria-valuenow="50"
                                 aria-valuemin="0" aria-valuemax="100" style={{width: 300}}></div>
                        </div>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        What will Professor Clinger do?
                        <div class="btn-group" role="group" aria-label="player1 commands">
                            <button type="button" class="btn btn-secondary">ATTACK</button>
                            <button type="button" class="btn btn-secondary">SWAP</button>
                        </div>
                    </div>
                </div>
            )} else if (this.state.gameState == 3) {
            // Game over screen
        }

    }
}