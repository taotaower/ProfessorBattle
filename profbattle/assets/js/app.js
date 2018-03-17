// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import run_game from "./battle";

function form_init() {
//     $('#game-button').click(() => {
//         let name = document.getElementById('game-input').value;
//     if (name.length > 0) {
//         window.open("/game/" + name, "_self");
//     }
// });
//


    $('#submit-name').on('click',function(){

        var name = $("#game-input").val();
        var url      = window.location.href;

        if (name){
            document.location = url + 'game/' + name
        }
        else {
            alert("You have to input a game name")
        }


    });

    $('#game-table').on('click','.btn-join',function () {
        console.log("clicking game table")
        var name = $(this).val();
        var url      = window.location.href;

        if (name){
            document.location = url + 'game/' + name
        }
        else {
            alert("Something Wrong")
        }

    })

}

function init() {
    let root = document.getElementById('game');
    if (root) {
        var  name = window.location.href.substr(33);
        let channel = socket.channel("games:" + window.gameName, {});
        run_game(root, channel);
    }

    if (document.getElementById('index-page')) {
        form_init();
    }
}

// Use jQuery to delay until page loaded.
$(init);