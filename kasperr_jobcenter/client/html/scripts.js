/*
  __  __           _            _                 _  __                         _____  
 |  \/  |         | |          | |               | |/ /                        |  __ \ 
 | \  / | __ _  __| | ___      | |__  _   _      | ' / __ _ ___ _ __   ___ _ __| |__) |
 | |\/| |/ _` |/ _` |/ _ \     | '_ \| | | |     |  < / _` / __| '_ \ / _ \ '__|  _  / 
 | |  | | (_| | (_| |  __/     | |_) | |_| |     | . \ (_| \__ \ |_) |  __/ |  | | \ \ 
 |_|  |_|\__,_|\__,_|\___|     |_.__/ \__, |     |_|\_\__,_|___/ .__/ \___|_|  |_|  \_\
                                       __/ |                   | |                     
                                      |___/                    |_|                     

  Author: Kasper Rasmussen
  Steam: https://steamcommunity.com/id/kasperrasmussen
*/

$(document).ready(function () {
  setTheme();
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.open == true) {
      openMenu();
    }
    if (item.open == false) {
      closeMenu();
    }
    if (item.notification == true) {
      Swal.fire({
        text: item.notification_msg,
        type: 'success',
        showCancelButton: true,
        confirmButtonColor: configs.theme.primary_color,
        confirmButtonText: 'OK',
        showCancelButton: false
      });
    }
  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://kasperr_jobcenter/close', JSON.stringify({}));
    }
  };
  $(".btnClose").click(function () {
    $.post('http://kasperr_jobcenter/close', JSON.stringify({}));
  });
  $(".selectJob").click(function () {
    let jobID = $(this).data("jobID");
    if(!configs.jobs[jobID].whitelisted) {
      let group = configs.jobs[jobID].group;
      $.post('http://kasperr_jobcenter/selectJob', JSON.stringify({
        group: group
      }));
    }
  });
  $('.scrollbox').bind('scroll',scrollChecker);
});

function openMenu() {
  $(".container").fadeIn();
  openHome();
}
function closeMenu() {
  $(".container").fadeOut();
  $("#home").css("display", "none");
  $("#showJobs").css("display", "none");
  $("#jobSelection").css("display", "none");
}

function openHome() {
  $("#home").css("display", "block");
  $("#showJobs").css("display", "none");
  $("#jobSelection").css("display", "none");
}

function openShowJobs() {
  $("#home").css("display", "none");
  $("#showJobs").css("display", "block");
  $("#jobSelection").css("display", "none");
  $(".whitelisted-jobs").empty();
  $(".unwhitelisted-jobs").empty();
  configs.jobs.forEach(function(element, index) {
    if(element.whitelisted) {
      $(".whitelisted-jobs").append(`
        <div onclick="openJobSelection(${index})">
          <h3>${element.title}</h3>
          <p>${element.shortDescription}</p>
        </div>
      `);
    } else {
      $(".unwhitelisted-jobs").append(`
        <div onclick="openJobSelection(${index})">
          <h3>${element.title}</h3>
          <p>${element.shortDescription}</p>
        </div>
      `);
    }
  });
}

function openJobSelection(id) {
  if(configs.jobs[id].title.length !== null || configs.jobs[id].title.length !== undefined  || configs.jobs[id].title.length > 0) {
    $("#home").css("display", "none");
    $("#showJobs").css("display", "none");
    $("#jobSelection").css("display", "block");
    $(".jobIcon").attr("src","icons/"+configs.jobs[id].iconName);
    $(".jobTitle").html(configs.jobs[id].title);
    $(".jobDescription").html(configs.jobs[id].description);
    $(".jobRequirements").empty();
    $('.scrollbox').scrollTop(0);
    configs.jobs[id].requirements.forEach(element => {
      $(".jobRequirements").append("<p> - " + element + "</p>");
    });
    if(configs.jobs[id].whitelisted) {
      $(".selectJob").html("Benyt vores Discord");
      $(".selectJob").prop("disabled",true);
      $(".selectJob").data( "group", "");
    } else {
      $(".selectJob").html("Vælg job");
      $(".selectJob").prop("disabled",false);
      $(".selectJob").data( "jobID", id);
    }
  }
}

function scrollChecker(e) {
    var elem = $(e.currentTarget);
    if (elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight()) {
        $(".scrollToBottom").css("display", "none");
    } else {
      $(".scrollToBottom").css("display", "block");
    }
}

function scrollToBottom() {
  var objDiv = document.getElementById("scrollbox");
  objDiv.scrollTop = objDiv.scrollHeight;
}

function setTheme() {
  if(configs.theme.primary_color && configs.theme.secondary_color) {
    let primary_color = `--primary-color: ${configs.theme.primary_color}; `;
    let secondary_color = `--secondary-color: ${configs.theme.secondary_color}; `;
    $(":root").attr("style", primary_color + secondary_color);
  }
}