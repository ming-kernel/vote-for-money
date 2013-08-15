
$(function() {

    $.vote_group_data = {
        'stop': false,
        'betray_penalty': 0,
        'round_id': null,
        'users': [],
        'self': {'user_name': null,
                 'user_id': null,
                 'earnings': null,
                 'round_id': null
                },
        'opponents': [{'user_name': null,
                       'user_id': null,
                       'earnings': null,
                       'round_id': null,
                       'online': false,
                       'proposal': null,
                       'last_proposal_id': null
                      },
                      {'user_name': null,
                       'user_id': null,
                       'earnings': null,
                       'round_id': null,
                       'online': false,
                       'proposal': null,
                       'last_proposal_id': null
                      }
                     ],
        'round_decision': null,
        'last_round_decision': null
    };

    var is_english = function() {
        if (document.URL.indexOf('en') != -1)
            return true;
        else
            return false;
    };

    var is_chinese = function() {
        if (document.URL.indexOf('cn') != -1)
            return true;
        else
            return false;
    };

    var update_round_id = function() {
        $.ajax({
            url: '/users/next-round.json',
            type: 'POST',
            data: {
                'user_id': $.vote_group_data.self.user_id
            },
            success: function(d) {
                if (d) {
                    console.log("start_next_round");    
                }
                
            },
            async: false
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
                                      'earnings': group_info['self']['earnings'],
                                      'round_id': group_info['self']['round_id']});
        if (group_info['opponents'][0]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][0]['user_name'],
                                          'user_id': group_info['opponents'][0]['user_id'],
                                          'earnings': group_info['opponents'][0]['earnings'],
                                          'round_id': group_info['opponents'][0]['round_id']});
        }
        if (group_info['opponents'][1]['user_name']) {
            $.vote_group_data.users.push({'user_name': group_info['opponents'][1]['user_name'],
                                          'user_id': group_info['opponents'][1]['user_id'],
                                          'earnings': group_info['opponents'][1]['earnings'],
                                          'round_id': group_info['opponents'][1]['round_id']});
        }

        $.vote_group_data.users.sort(function(x, y) {return x.user_id - y.user_id;});
        $.vote_group_data['round_id'] = group_info['round_id'];
        $.vote_group_data['betray_penalty'] = group_info['betray_penalty'];

        $.vote_group_data['last_round_decision'] = group_info['last_round_decision'];
    };

    var parse_self = function(group_info) {
        $.vote_group_data.self.user_id = group_info['self']['user_id'];
        $.vote_group_data.self.user_name = group_info['self']['user_name'];
        $.vote_group_data.self.earnings = group_info['self']['earnings'];
        $.vote_group_data.self.round_id = group_info['self']['round_id']
    };

    var parse_opponent = function (group_info) {

        var left_opponent = group_info['opponents'][0];
        var right_opponent = group_info['opponents'][1];
        if (left_opponent['user_id'] > right_opponent['user_id']) {
            var tmp = left_opponent;
            left_opponent = right_opponent;
            right_opponent = tmp;
        }

        $.vote_group_data.opponents[0].user_name = left_opponent.user_name;
        $.vote_group_data.opponents[0].user_id = left_opponent.user_id;
        $.vote_group_data.opponents[0].online = left_opponent.online;
        $.vote_group_data.opponents[0].earnings = left_opponent.earnings;
        $.vote_group_data.opponents[0].round_id = left_opponent.round_id;
        $.vote_group_data.opponents[0].proposal = left_opponent.proposal;
  
        $.vote_group_data.opponents[1].user_name = right_opponent.user_name;
        $.vote_group_data.opponents[1].user_id = right_opponent.user_id;
        $.vote_group_data.opponents[1].online = right_opponent.online;
        $.vote_group_data.opponents[1].earnings = right_opponent.earnings;
        $.vote_group_data.opponents[1].round_id = right_opponent.round_id;
        $.vote_group_data.opponents[1].proposal = right_opponent.proposal;      
        // if (!$.vote_group_data.opponents[1].last_proposal_id)
        //     $.vote_group_data.opponents[1].last_proposal_id = right_opponent.proposal.id;

    };

    var parse_decision = function (group_info) {
        $.vote_group_data.round_decision = group_info['round_decision'];
        
    };

    var draw_global_statis = function() {
        if ($.vote_group_data.users[0])
            $('#statistics thead th')[1].textContent = $.vote_group_data.users[0].user_name;

        if ($.vote_group_data.users[1])
            $('#statistics thead th')[2].textContent = $.vote_group_data.users[1].user_name;

        if ($.vote_group_data.users[2])
            $('#statistics thead th')[3].textContent = $.vote_group_data.users[2].user_name;
        
        // update last earnings
        if ($.vote_group_data.last_round_decision) {
            
            if ($.vote_group_data.users[0].user_id === $.vote_group_data.last_round_decision.from)
                $('#statistics tbody tr')[1].children[1].textContent = $.vote_group_data.last_round_decision.money_a - $.vote_group_data.last_round_decision.submiter_penalty;
            else if ($.vote_group_data.users[0].user_id === $.vote_group_data.last_round_decision.to)
                $('#statistics tbody tr')[1].children[1].textContent = $.vote_group_data.last_round_decision.money_a - $.vote_group_data.last_round_decision.accepter_penalty;
            else
                $('#statistics tbody tr')[1].children[1].textContent = $.vote_group_data.last_round_decision.money_a;


            if ($.vote_group_data.users[1].user_id === $.vote_group_data.last_round_decision.from)
                $('#statistics tbody tr')[1].children[2].textContent = $.vote_group_data.last_round_decision.money_b - $.vote_group_data.last_round_decision.submiter_penalty;
            else if ($.vote_group_data.users[1].user_id === $.vote_group_data.last_round_decision.to)
                $('#statistics tbody tr')[1].children[2].textContent = $.vote_group_data.last_round_decision.money_b - $.vote_group_data.last_round_decision.accepter_penalty;
            else
                $('#statistics tbody tr')[1].children[2].textContent = $.vote_group_data.last_round_decision.money_b;

            if ($.vote_group_data.users[2].user_id === $.vote_group_data.last_round_decision.from)
                $('#statistics tbody tr')[1].children[3].textContent = $.vote_group_data.last_round_decision.money_c - $.vote_group_data.last_round_decision.submiter_penalty;
            else if ($.vote_group_data.users[2].user_id === $.vote_group_data.last_round_decision.to)
                $('#statistics tbody tr')[1].children[3].textContent = $.vote_group_data.last_round_decision.money_c - $.vote_group_data.last_round_decision.accepter_penalty;
            else
                $('#statistics tbody tr')[1].children[3].textContent = $.vote_group_data.last_round_decision.money_c;
        }

        // upate total earnings
        if ($.vote_group_data.users[0])
            $('#statistics tbody tr')[0].children[1].textContent = $.vote_group_data.users[0].earnings;

        if ($.vote_group_data.users[1])
            $('#statistics tbody tr')[0].children[2].textContent = $.vote_group_data.users[1].earnings;

        if ($.vote_group_data.users[2])
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

        $elem.find('th').slice(5).each(function (i, e) {
            if ($.vote_group_data.users[i] && $.vote_group_data.users[i].user_name)
                e.textContent = $.vote_group_data.users[i].user_name;
        });        

    };


    var draw_proposal_on_opponent = function($elem, opponent) {

        if (opponent.proposal) {
            console.log('get something');
            var $td = $elem.find('td');
            $td[1].textContent = opponent.proposal.money_a;
            $td[2].textContent = opponent.proposal.money_b;
            $td[3].textContent = opponent.proposal.money_c;
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

    var clear_my_proposal = function() {
        var $left_money = $('#left_opponent form').find('input');
        $left_money.each(function(i, e) {
            e.value = '';
        });

        var $right_money = $('#right_opponent form').find('input');
        $right_money.each(function(i, e) {
            e.value = '';
        });

    };

    var round_id_synced = function() {
        // group data has not received
        if (!$.vote_group_data.round_id)
            return true;

        if ($.vote_group_data.round_id === $.vote_group_data.users[0].round_id &&
            $.vote_group_data.round_id === $.vote_group_data.users[1].round_id &&
            $.vote_group_data.round_id === $.vote_group_data.users[2].round_id)
            return true;
        else
            return false;
    };

    var confirm_and_wait_next_round = function(opponent) {
        // actively accept a proposal
        if (opponent) {
            $('#next-round #first').text("You");
            $('#next-round #second').text(opponent.user_name);
            $('#next-round').modal('show');
            $('#next-round #ok').click(function() {
                console.log("ok clicked");
                update_round_id();
                // $('#next-round p').text('Wating for others to confirm');                
            });
            
        } else {
            // re-actively accept a proposal

            var proposal = $.vote_group_data.round_decision;
            console.log(proposal);
            if (proposal.from === $.vote_group_data.opponents[0].user_id)
                $('#next-round #first').text($.vote_group_data.opponents[0].user_name);
            else if (proposal.from === $.vote_group_data.opponents[1].user_id)
                $('#next-round #first').text($.vote_group_data.opponents[1].user_name);

            if (proposal.to === $.vote_group_data.self.user_id)
                if (is_english())
                    $('#next-round #second').text("You");
                else
                    $('#next-round #second').text("你");
            else if (proposal.to === $.vote_group_data.opponents[0].user_id)
                $('#next-round #second').text($.vote_group_data.opponents[0].user_name);
            else if (proposal.to === $.vote_group_data.opponents[1].user_id)
                $('#next-round #second').text($.vote_group_data.opponents[1].user_name);

            $('#next-round').modal('show');

            $('#next-round #ok').click(function() {
                console.log("ok clicked");
                update_round_id();
                // $('#next-round p').text('Wating for others to confirm');
               
            });

        }
        reset_group_data();
        clear_my_proposal();
        clear_opponent_proposal();
        // system_update_sync();        
    }

    var update_model = function () {
        var left_opponent = $.vote_group_data.opponents[0];
        var right_opponent = $.vote_group_data.opponents[1];
        if (left_opponent.user_name) {
            // console.log('update left');
            draw_name_on_opponent($('#left_opponent'), left_opponent);
            draw_proposal_on_opponent($('#left_opponent'), left_opponent);

            if (left_opponent.proposal && $.vote_group_data.opponents[0].last_proposal_id != left_opponent.proposal.id) {
                $('#left_opponent #opponent').find('td').effect("highlight", {}, 3000);
                // alert(left_opponent.proposal.id + " " + $.vote_group_data.opponents[0].last_proposal_id);
                $.vote_group_data.opponents[0].last_proposal_id = left_opponent.proposal.id;

            }

        }


        if (right_opponent.user_name) {
            // console.log('update right');
            draw_name_on_opponent($('#right_opponent'), right_opponent);
            draw_proposal_on_opponent($('#right_opponent'), right_opponent);

            if (right_opponent.proposal && $.vote_group_data.opponents[1].last_proposal_id != right_opponent.proposal.id) {
                $('#right_opponent #opponent').find('td').effect("highlight", {}, 3000);
                $.vote_group_data.opponents[1].last_proposal_id = right_opponent.proposal.id;
            }           
        }
        $('#basic-group-info #my-name').text($.vote_group_data.self.user_name);
        $('#basic-group-info #round-id').text($.vote_group_data.self.round_id);
        $('#basic-group-info #round-penlaty').text($.vote_group_data.betray_penalty);
        draw_global_statis();

        if ($.vote_group_data.round_decision) {
            confirm_and_wait_next_round(null);
        }
    };

    var accept_left_proposal = function() {

        var opponent = $.vote_group_data.opponents[0];
        if (opponent.proposal === null )
            return;

        $.ajax({
            url: '/proposals/accept.json',
            type: 'POST',
            data: {
                'proposal_id': opponent.proposal.id,
                'from': opponent.user_id,
                'to':$.vote_group_data.self.user_id
            },
            success: function(d) {
                console.log(d);
                if (d) {
                    console.log("accept left opponnent");
                    confirm_and_wait_next_round($.vote_group_data.opponents[0]);
                    
                }
                
            }
        });


    };
    var accept_right_proposal = function() {
        var opponent = $.vote_group_data.opponents[1];
        if (opponent.proposal === null)
            return;

        $.ajax({
            url: '/proposals/accept.json',
            type: 'POST',
            data: {
                'proposal_id': opponent.proposal.id,
                'from': opponent.user_id,
                'to':$.vote_group_data.self.user_id
            },
            success: function(d) {
                if (d) {
                    console.log("accept right opponent");
                    confirm_and_wait_next_round($.vote_group_data.opponents[1]);   
                }
                
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
                if (is_english())
                    alert("sum of money should be 100");
                else
                    alert("总数相加必须为 100 ");
                
                return false;
            }

            // console.log("submit left proposal");

            var proposal = {'proposal': {
                                          'from': $.vote_group_data.self.user_id,
                                          'to': $.vote_group_data.opponents[0].user_id,
                                          'moneys': moneys
                                        }
                           };

            $.ajax({
                url: '/proposals/create.json',
                type: 'POST',
                data: proposal,
                success: function(d) {
                    console.log("submited left proposal");
                    var $td = $('#left_opponent #me').find('td');
                    $td[1].textContent = moneys[0];
                    $td[2].textContent = moneys[1];
                    $td[3].textContent = moneys[2];
                    // console.log("moneys", moneys);
                    $td.effect("highlight", {}, 3000);
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
                if (is_english())
                    alert("sum of money should be 100");
                else
                    alert("总数相加必须为 100 ");

                return false;
            }
            // console.log('submit right proposal');

            var proposal = {'proposal': {
                                        'from': $.vote_group_data.self.user_id,
                                        'to': $.vote_group_data.opponents[1].user_id,
                                        'moneys': moneys
                                        }
                           };

            $.ajax({
                url: '/proposals/create.json',
                type: 'POST',
                data: proposal,
                success: function(d) {
                    // alert('proposal submited');
                    console.log("submitted right proposal");
                    var $td = $('#right_opponent #me').find('td');
                    $td[1].textContent = moneys[0];
                    $td[2].textContent = moneys[1];
                    $td[3].textContent = moneys[2];
                    // console.log("moneys", moneys);
                    $td.effect("highlight", {}, 3000);

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


    var stop_game = function() {
        $('#game-stop').modal('show');
        $('#game-stop #ok').click(function() {
            console.log('stop ok');
            window.location.replace("./");
        })
    };

    // init myself
    $.getJSON('/game/get-group-info.json', function(group_info) {
        if (!group_info) {
            if (is_english())
                alert("Please wait for Administrator to assgin you a group");
            else
                alert("请稍等，管理员给您随机分组之后就可以开始游戏了");

            return;    
        }
            

        if (group_info.stop === true) {
            stop_game();
        }

        console.log("system init");
        parse_group(group_info);
        parse_self(group_info);
        parse_opponent(group_info);
        parse_decision(group_info);
        init_model();
    });

    var system_update_sync = function() {

        var response = $.ajax({
                    url: '/game/get-group-info.json',
                    type: 'GET',
                    data: 'hi',
                    async: false
                }).responseText;

        var group_info = $.parseJSON(response);
        parse_group(group_info);
        parse_self(group_info);
        parse_opponent(group_info);
        parse_decision(group_info);
        update_model();
    };

    var system_update = function() {
        
        $.getJSON('/game/get-group-info.json', function(group_info) {
            if (!group_info)
                return;

            console.log('system update');
            
            if (group_info.stop === true) {
                stop_game();
            }

            if (round_id_synced())
                $('#next-round').modal('hide');

            if ($.vote_group_data.round_id === null && group_info.round_id === 0)
                if (is_english())
                    alert("You can start game now!");
                else
                    alert("您可以开始游戏了！");

            parse_group(group_info);
            parse_self(group_info);
            parse_opponent(group_info);
            parse_decision(group_info);
            update_model();

        });
           
    }

    window.setInterval(system_update, 2000);

});

