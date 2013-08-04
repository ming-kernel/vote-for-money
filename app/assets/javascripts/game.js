
$(function() {

    $.vote_group_data = {
        'users': [],
        'self': {'user_name': null,
                 'user_id': null,
                 'earnings': null
                },
        'opponents': [{'user_name': null,
                       'user_id': null,
                       'online': false,
                       'earnings': null,
                       'proposal': null
                      },
                      {'user_name': null,
                       'user_id': null,
                       'online': false,
                       'earnings': null,
                       'proposal': null}
                     ],
        'round_decision': null
    };

    var start_next_round = function() {
        $.ajax({
            url: 'users/next-round.json',
            type: 'POST',
            data: {
                'user_id': $.vote_group_data.self.user_id
            },
            success: function(d) {
                // $('#dialog').dialog('open');
                // alert('start next round');
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
                                      'user_id': group_info['self']['user_id'],
                                      'earnings': group_info['self']['earnings']});
        if (group_info['opponents'][0]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][0]['user_name'],
                                          'user_id': group_info['opponents'][0]['user_id'],
                                          'earnings': group_info['opponents'][0]['earnings']});
        }
        if (group_info['opponents'][1]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][1]['user_name'],
                                          'user_id': group_info['opponents'][1]['user_id'],
                                          'earnings': group_info['opponents'][1]['earnings']});
        }

        $.vote_group_data.users.sort(function(x, y) {return x.user_id - y.user_id;});
        $.vote_group_data['round_id'] = group_info['round_id'];
    };

    var parse_self = function(group_info) {
        $.vote_group_data.self.user_id = group_info['self']['user_id'];
        $.vote_group_data.self.user_name = group_info['self']['user_name'];
        $.vote_group_data.self.earnings = group_info['self']['earnings'];
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
        
    };

    var draw_global_statis = function() {
        $('#statistics thead th')[1].textContent = $.vote_group_data.users[0].user_name;
        $('#statistics thead th')[2].textContent = $.vote_group_data.users[1].user_name;
        $('#statistics thead th')[3].textContent = $.vote_group_data.users[2].user_name;
        
        // update last earnings
        if ($.vote_group_data.round_decision) {
            $('#statistics tbody tr')[1].children[1].textContent = $.vote_group_data.round_decision.money_a;
            $('#statistics tbody tr')[1].children[2].textContent = $.vote_group_data.round_decision.money_b;
            $('#statistics tbody tr')[1].children[3].textContent = $.vote_group_data.round_decision.money_c;
        }

        // upate total earnings
        $('#statistics tbody tr')[0].children[1].textContent = $.vote_group_data.users[0].earnings;
        $('#statistics tbody tr')[0].children[2].textContent = $.vote_group_data.users[1].earnings;
        $('#statistics tbody tr')[0].children[3].textContent = $.vote_group_data.users[2].earnings;

    };

    var draw_name_on_opponent = function($elem, opponent) {
        if (opponent.user_name)
            $elem.find('span#opponent_name').text(opponent.user_name);

        if (opponent.online === false)
            $elem.find('span#status').text("(offline)").addClass("muted");
        else
            $elem.find('span#status').text("(online)").addClass("text-success");

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

    var clear_opponent_proposal = function() {
        $('#left_opponent #opponent td')[1].textContent = '';
        $('#left_opponent #opponent td')[2].textContent = '';
        $('#left_opponent #opponent td')[3].textContent = '';

        $('#right_opponent #opponent td')[1].textContent = '';
        $('#right_opponent #opponent td')[2].textContent = '';
        $('#right_opponent #opponent td')[3].textContent = '';
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

        // console.log('round_id = ' + $.vote_group_data['round_id']);
        $('#round-id span').text($.vote_group_data['round_id']);
        draw_global_statis();

        if ($.vote_group_data.round_decision) {
            // alert("An agreement has been made, let's start next round");
            start_next_round();
            reset_group_data();
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
                clear_opponent_proposal();
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
                'proposal_id': opponent.proposal.id,
                'from': opponent.user_id,
                'to':$.vote_group_data.self.user_id
            },
            success: function(d) {
                console.log(d);
                clear_opponent_proposal();
            }
        });


    };

    var money_is_valid = function(moneys) {
        var sum = 0;
        for (var i = 0; i < moneys.length; i++) {
            sum += moneys[i];
        }
        return sum === 100;
    };

    var init_left_opponent = function($elem, opponent) {
        draw_name_on_opponent($elem, opponent);

        $elem.find('form').submit(function() {
            var $money = $elem.find('input');
            var moneys = [];
            $money.each(function(i, e) {
                moneys.push(parseInt(e.value, 10));
            });

            if (!money_is_valid(moneys)) {
                alert("sum of money should be 100");
                return false;
            }

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
                    // alert('proposal submited');
                    console.log(d);

                }
            });

            return false;
        });

        $elem.find('#accept').click(function() {
            accept_left_proposal();
            return false;
        });


    };

    var init_right_opponent = function($elem, opponent) {
        draw_name_on_opponent($elem, opponent);

        $elem.find('form').submit(function() {
            var $money = $elem.find('input');
            var moneys = [];
            $money.each(function(i, e) {
                moneys.push(parseInt(e.value, 10));
            });

            if (!money_is_valid(moneys)) {
                alert("sum of money should be 100");
                return false;
            }
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
                    // alert('proposal submited');
                    console.log(d);

                }
            });

            return false;
        });

        $elem.find('#accept').click(function() {
            accept_right_proposal();
            return false;
        });

    };



    var init_model = function () {

        init_left_opponent($('#left_opponent'), $.vote_group_data.opponents[0]);
        init_right_opponent($('#right_opponent'), $.vote_group_data.opponents[1]);
        draw_global_statis();
    };


    // $("#dialog").dialog({ autostart: true});

    // $('html').click(function() {
    //     $("#dialog").dialog("close");
    // });

    // $('#dialog').click(function(event){
    //   event.stopPropagation();
    // });

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
                console.log(group_info);
                parse_group(group_info);
                parse_self(group_info);
                parse_opponent(group_info);
                parse_decision(group_info);
                update_model();
            }
        });
    });

    timer.set({ time : 5000, autostart : true });


});

