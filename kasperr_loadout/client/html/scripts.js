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
  function openContainer() {
    $(".container").css("display", "block");
    $(".centered").empty();
    Object.keys(configs.loadouts).forEach(function (key) {
      $(".centered").append(`<button onclick="giveLoadout('${key}')">${key}</button>`);
    });
  }
  function closeContainer() {
    $(".container").css("display", "none");
    $(".centered").empty();
  }
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.open == true) {
      openContainer();
    }
    if (item.open == false) {
      closeContainer();
    }
  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://kasperr_loadout/close', JSON.stringify({}));
    }
  };
});


function giveLoadout(name) {
  Swal.fire({
    title: 'Udstyr modtaget!',
    text: "",
    type: 'success',
    showCancelButton: true,
    confirmButtonColor: configs.theme.primary_color,
    confirmButtonText: 'OK',
    showCancelButton: false
  });
  $.post('http://kasperr_loadout/giveLoadout', JSON.stringify({
    loadout: configs.loadouts[name]
  }));
}

function setTheme() {
  if(configs.theme.primary_color && configs.theme.secondary_color) {
    let primary_color = `--primary-color: ${configs.theme.primary_color}; `;
    let secondary_color = `--secondary-color: ${configs.theme.secondary_color}; `;
    $(":root").attr("style", primary_color + secondary_color);
  }
}