$(function() {
  // Cache jQuery objects for better performance
  var $container = $('#container');
  var $spinner = $('#spinner');
  var $numberMinigame = $('#numberminigame');
  var $numberMinigameNumbers = $('#numberminigame-numbers');
  var $logo = $('#logo');
  var $numbers = $('.numberminigame-numbers-number');
  var $guessthebox = $('#guessthebox');
  
  $spinner.hide();
  $numberMinigame.hide();
  $numberMinigameNumbers.hide();
  $guessthebox.hide();
      
  // Function to scramble the numberminigame-numbers-number
  function scrambleNumbers() {
    $numbers.sort(function() {
      return 0.5 - Math.random();
    });
    $numberMinigameNumbers.empty().append($numbers);
  }
  var correctBox = Math.floor(Math.random() * 3) + 1;

  function restartChallenge() {
    // go back to the number minigame
    $guessthebox.fadeOut('slow');
    correctBox = Math.floor(Math.random() * 3) + 1;
    var audioError = new Audio('assets/error.mp3');
    audioError.play();

    setTimeout(function() {
      $numberMinigame.fadeIn('slow');
      $numberMinigameNumbers.fadeIn('slow');
    }, 1000);
  }

  // Initial scramble
  scrambleNumbers();

  // Guess the box
  // random number between 1 and 3
  var wrong = 0;

  $(document).on('click', '.guesstheboxs-box', function() {
    var id = $(this).attr('id');
    var box = parseInt(id.substr(-1));

    if (box === correctBox) {
      $(this).css('background-color', 'green');
      var error = Math.floor(Math.random() * 20) + 1;
      if (error === 1) {
        restartChallenge();
      } else {
        setTimeout(function() {
          var completedAudio = new Audio('assets/completed.mp3');
          completedAudio.play();
          $guessthebox.fadeOut('slow');
          $spinner.fadeIn('slow');
          setTimeout(function() {
            $spinner.fadeOut('slow');
            var audioZip = new Audio('assets/zipsound.mp3');
            audioZip.play();
            correctBox = Math.floor(Math.random() * 3) + 1;
            $('.guesstheboxs-box').css('background-color', '#5e7194');
            $.post('https://bankrobbery/complete', JSON.stringify({}));
          }, 1000);
        }, 1500);
      }
    } else {
      $(this).css('background-color', 'red');
      restartChallenge();

      setTimeout(function() {
        $('.guesstheboxs-box').css('background-color', '#5e7194');
      }, 1000);
    }

    if (wrong === 2) {
      wrong = 0;
      restartChallenge();
    }

    // Update correctBox with a new random value
    correctBox = Math.floor(Math.random() * 3) + 1;
  });

  // numbergame
  var currNumber = 1;

  $(document).on('click', '.numberminigame-numbers-number', function() {
    var $this = $(this);
    var id = $this.attr('id');
    var number = parseInt(id.substr(-1)) || 10; // convert '0' to 10
    var audioClick = new Audio('assets/click.mp3');
    audioClick.play();

    if (number === currNumber) {
      $this.css('background-color', 'green');
      currNumber++;

      if (currNumber === 11) {
        currNumber = 1;
        var completedAudio = new Audio('assets/completed.mp3');
        setTimeout(function() {
          completedAudio.play();
        }, 1000);

        setTimeout(function() {
          $numbers.css('background-color', '#5e7194');
          scrambleNumbers();
          $numberMinigame.fadeOut('slow');
          $numberMinigameNumbers.fadeOut('slow');

          $guessthebox.fadeIn('slow');
        }, 1000);
      }
    } else {
      $this.css('background-color', 'red');
      $numbers.css('pointer-events', 'none');

      setTimeout(function() {
        $numbers.css('pointer-events', 'auto');
      }, 1000);

      var audioError = new Audio('assets/error.mp3');
      audioError.play();

      currNumber = 1;

      setTimeout(function() {
        $numbers.css('background-color', '#5e7194');
        scrambleNumbers();
      }, 1000);
    }

    // Update correctBox with a new random value
    correctBox = Math.floor(Math.random() * 3) + 1;
  });

  // check if escape is pressed
  $(document).keyup(function(e) {
    if (e.key === "Escape") {
      $.post('https://bankrobbery/close', JSON.stringify({}));
    }
  });

  // Set the initial visibility of the container based on the message
  $container.hide();

  window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.type === "ui") {
      if (item.status) {
        $logo.show();
        $container.fadeIn();

        setTimeout(function() {
          $logo.fadeOut('slow', function() {
            $spinner.fadeIn('slow', function() {
              $spinner.hide();
              $numberMinigame.fadeIn('slow');
              $numberMinigameNumbers.fadeIn('slow');
            });
          });
        }, 3000);
      } else {
        $container.fadeOut();
      }
    }

    if (item.type === "close") {
      $container.fadeOut();
    }
  });
});