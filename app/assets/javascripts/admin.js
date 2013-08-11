$(function() {

//   <table>
//     <thead>
//         <tr>
//             <th>#</th>
//             <th>First Name</th>
//             <th>Last Name</th>
//             <th>Language</th>
//         </tr>
//     </thead>
//     <tbody>
//         <tr>
//             <td>1</td>
//             <td>Some</td>
//             <td>One</td>
//             <td>English</td>
//         </tr>
//         <tr>
//             <td>2</td>
//             <td>Joe</td>
//             <td>Sixpack</td>
//             <td>English</td>
//         </tr>
//     </tbody>
// </table>
  String.format = function() {
    var s = arguments[0];
    for (var i = 0; i < arguments.length - 1; i++) {       
      var reg = new RegExp("\\{" + i + "\\}", "gm");             
      s = s.replace(reg, arguments[i + 1]);
    }

    return s;
  };

  var clear_draw_data = function() {
    $('.nav-info').removeClass("active");
    $('#draw-head').children().remove();
    $('#draw-body').children().remove();
  };

  
  var draw_users = function(users) {
    var head = "<tr><th>#</th><th>Name</th><th>Group id</th></tr>";
    clear_draw_data();
    $('#users').addClass('active');
    $('#draw-head').append(head);
    var body = "";
    
    for (var i = 0; i < users.length; i++) {
      body = body + String.format("<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>", 
                                  i + 1, users[i].name, users[i].group_id);
    }
    $('#draw-body').append(body);


  };

  var draw_groups = function(groups) {
    var head = "<tr><th>#</th><th>Group id</th><th>Users number</th><th>Round id</th><th>Betray Penalty</th></tr>";
    clear_draw_data();
    $('#groups').addClass('active');
    $('#draw-head').append(head);
    var body = "";

    for (var i = 0; i < groups.length; i++) {
      body = body + String.format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>", 
                                  i + 1, groups[i].id, groups[i].users_number, groups[i].round_id, groups[i].betray_penalty);
    }
    $('#draw-body').append(body);
  };

  var draw_proposals = function(proposals) {
    var head = "<tr><th>Proposal id</th><th>From</th><th>To</th><th>Round id</th><th>Accepted?</th></tr>";
    clear_draw_data();
    $('#proposals').addClass('active');    
    $('#draw-head').append(head);

    var body = "";

    for (var i = 0; i < proposals.length; i++) {
      body = body + String.format("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>",
                                  proposals[i].id, proposals[i].from, proposals[i].to, proposals[i].round_id, proposals[i].accept);
    }

    $('#draw-body').append(body);


  };

  var init_users = function($elem) {
    $elem.click(function() {
      $.ajax({
        url: 'admin/show_users.json',
        type: 'GET',
        success: function(users) {
          console.log(users);
          draw_users(users);
        }
      });
      return false;
    });
  };

  var init_groups = function($elem) {
    $elem.click(function() {

      $.ajax({
        url: 'admin/show_groups.json',
        type: 'GET',
        success: function(groups) {
          console.log(groups);
          draw_groups(groups);
        }
      });
      return false;
    });

  };

  var init_proposals = function($elem) {
    $elem.click(function() {
      $.ajax({
        url: 'admin/show_proposals.json',
        type: 'GET',
        success: function(proposals) {
          console.log(proposals);
          draw_proposals(proposals);
        }
      });
      return false;
    });

  };

  init_users($('#users'));
  init_groups($('#groups'));
  init_proposals($('#proposals'));
  $('#users').trigger('click');
});