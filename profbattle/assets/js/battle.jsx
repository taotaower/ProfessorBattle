import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_game(root, channel) {
    ReactDOM.render(<Battle channel={channel} />, root);
}

class Battle extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = {
            //add state stuff here
        };
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp) });
    }

    gotView(view) {
        console.log("New view", view);
        this.setState(view.game);
    }
}