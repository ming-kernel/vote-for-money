
$(function() {

    $.vote_group_data = {
        'users': [],
        'self': {'user_name': null,
                 'user_id': null
                },
        'opponents': [{'user_name': null,
                       'user_id': null,
                       'online': false,
                       'proposal': null
                      },
                      {'user_name': null,
                       'user_id': null,
                       'online': false,
                       'proposal': null}
                     ],
        'round_decision': null
    };

    var start_next_round = function() {
        $.ajax({
            url: 'users/next-round.json',
            type: 'POST',
            data: {
                'user_id': $.vote_group_data.self.user_id,
            },
            success: function(d) {

                console.log(d);
            }
        });


    };

    var reset_group_data = function() {
        var opponents = $.vote_group_data.opponents;
        for (var i = 0; i < opponents.length; i++) {
            opponents[i].proposal = null;
        }
        $.vote_group_data.round_decision = null;
    };

    var parse_group = function(group_info) {
        $.vote_group_data.users = [];
        $.vote_group_data.users.push({'user_name': group_info['self']['user_name'],
                                      'user_id': group_info['self']['user_id']});
        if (group_info['opponents'][0]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][0]['user_name'],
                                          'user_id': group_info['opponents'][0]['user_id']})
        }
        if (group_info['opponents'][1]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][1]['user_name'],
                                          'user_id': group_info['opponents'][1]['user_id']})
        }

        $.vote_group_data.users.sort(function(x, y) {return x.user_id - y.user_id});

    };

    var parse_self = function(group_info) {
        $.vote_group_data.self.user_id = group_info['self']['user_id'];
        $.vote_group_data.self.user_name = group_info['self']['user_name'];

    };

    var parse_opponent = function (group_info) {

        var left_opponent = group_info['opponents'][0];
        var right_opponent = group_info['opponents'][1];
        if (left_opponent['user_id'] > right_opponent['user_id']) {
            var tmp = left_opponent;
            left_opponent = right_opponent;
            right_opponent = tmp;
        }

        $.vote_group_data.opponents[0] = left_opponent;
        $.vote_group_data.opponents[1] = right_opponent;
    };

    var parse_decision = function (group_info) {
        $.vote_group_data.round_decision = group_info['round_decision'];
        if ($.vote_group_data.round_decision) {
            alert("An agreement has been made, let's start next round");
            start_next_round();
            reset_group_data();

        }
    };

    var draw_name_on_opponent = function($elem, opponent) {
        if (opponent.user_name)
            $elem.find('span#opponent_name').text(opponent.user_name);

        $elem.find('label').each(function (i, e) {
            if ($.vote_group_data.users[i] && $.vote_group_data.users[i].user_name)
                e.textContent = $.vote_group_data.users[i].user_name;
        });

        $elem.find('th').slice(1, 4).each(function (i, e) {
            if ($.vote_group_data.users[i] && $.vote_group_data.users[i].user_name)
                e.textContent = $.vote_group_data.users[i].user_name;
        });

    };

    var draw_proposal_on_opponent = function($elem, opponent) {

        if (opponent.proposal) {
            console.log('get something');
//            $table_body = $elem.find('#opponent');

            var $td = $elem.find('td');
            $td[1].textContent = opponent.proposal.money_a;
            $td[2].textContent = opponent.proposal.money_b;
            $td[3].textContent = opponent.proposal.money_c;

//            var row_string = '<tr><td>' + opponent.proposal.money_a + '</td>' +
//                                  '<td>' + opponent.proposal.money_b + '</td>' +
//                                  '<td>' + opponent.proposal.money_c + '</td></tr>';
//            $(row_string).appendTo($table_body);

        }
    };


    var update_model = function () {
        var left_opponent = $.vote_group_data.opponents[0];
        var right_opponent = $.vote_group_data.opponents[1];
        if (left_opponent.user_name) {
            console.log('update left');
            draw_name_on_opponent($('#left_opponent'), left_opponent);
            draw_proposal_on_opponent($('#left_opponent'), left_opponent);
        }


        if (right_opponent.user_name) {
            console.log('update right');
            draw_name_on_opponent($('#right_opponent'), right_opponent);
            draw_proposal_on_opponent($('#right_opponent'), right_opponent);
        }


    };

    var accept_left_proposal = function() {

        var opponent = $.vote_group_data.opponents[0];

//        console.log("accept proposal");
//        console.log(opponent.user_name + ' ' + opponent.pending_proposal.proposal_id);
//
//        if (!opponent.user_name || !opponent.pending_proposal.proposal_id)  {
//            alert('this proposal not valid');
//            return;
//        }

        alert('accept left proposal');

        $.ajax({
            url: 'proposals/accept.json',
            type: 'POST',
            data: {
                'proposal_id': opponent.proposal.id,
                'from': opponent.user_id,
                'to':$.vote_group_data.self.user_id
            },
            success: function(d) {

                console.log(d);
            }
        });


    };
    var accept_right_proposal = function() {
        var opponent = $.vote_group_data.opponents[1];
//
//        console.log("accept proposal");
//        console.log(opponent.user_name + ' ' + opponent.pending_proposal.proposal_id);
//
//        if (!opponent.user_name || !opponent.pending_proposal.proposal_id)  {
//            alert('this proposal not valid');
//            return;
//        }

        alert('accept right proposal');
        $.ajax({
            url: 'proposals/accept.json',
            type: 'POST',
            data: {
                'proposal_id': opponent.proposal.proposal_id,
                'from': opponent.user_id,
                'to':$.vote_group_data.self.user_id
            },
            success: function(d) {

                console.log(d);
            }
        });


    };

    var init_left_opponent = function($elem, opponent) {
        draw_name_on_opponent($elem, opponent);

        $elem.children('form').submit(function() {
            var $money = $elem.find('input');
            var moneys = [];
            $money.each(function(i, e) {
                moneys.push(parseInt(e.value));
            });
            console.log("submit left proposal");

            var proposal = {'proposal': {
                                          'from': $.vote_group_data.self.user_id,
                                          'to': $.vote_group_data.opponents[0].user_id,
                                          'moneys': moneys
                                        }
                           };

            $.ajax({
                url: 'proposals/create.json',
                type: 'POST',
                data: proposal,
                success: function(d) {
                    alert('proposal submited');
                    console.log(d);

                }
            });

            return false;
        });

        $elem.children('button').click(function() {
            accept_left_proposal();
            return false;
        });


    };

    var init_right_opponent = function($elem, opponent) {
        draw_name_on_opponent($elem, opponent);

        $elem.children('form').submit(function() {
            var $money = $elem.find('input');
            var moneys = [];
            $money.each(function(i, e) {
                moneys.push(parseInt(e.value));
            });

            console.log('submit right proposal');

            var proposal = {'proposal': {
                                        'from': $.vote_group_data.self.user_id,
                                        'to': $.vote_group_data.opponents[1].user_id,
                                        'moneys': moneys
                                        }
                           };

            $.ajax({
                url: 'proposals/create.json',
                type: 'POST',
                data: proposal,
                success: function(d) {
                    alert('proposal submited');
                    console.log(d);

                }
            });

            return false;
        });

        $elem.children('button').click(function() {
            accept_right_proposal();
            return false;
        });

    };



    var init_model = function () {

        init_left_opponent($('#left_opponent'), $.vote_group_data.opponents[0]);
        init_right_opponent($('#right_opponent'), $.vote_group_data.opponents[1]);

    };

    // init myself
    $.getJSON('game/get-group-info.json', function(group_info) {
        parse_group(group_info);
        parse_self(group_info);
        parse_opponent(group_info);
        parse_decision(group_info);
        init_model();
    });



    var timer = $.timer(function() {

        $.ajax({
            url: 'game/get-group-info.json',
            type: 'GET',
            data: 'hi',
            success: function(group_info) {
                parse_group(group_info);
                parse_self(group_info);
                parse_opponent(group_info);
                parse_decision(group_info);
                update_model();
            }
        })
    });

    timer.set({ time : 5000, autostart : true });


});

