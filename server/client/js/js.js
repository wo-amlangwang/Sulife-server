$(document).ready(function() {         
    var $body = $('body'),

    // Panels stuff
        window_width = $(window).width(),
        window_height = $(window).height(),

        cols = Math.ceil(window_width / config.panels.width),
        rows = Math.ceil(window_height / config.panels.height);          

    for(var r = 1; r <= rows; r++) {
        for(var c = 1; c <= cols; c++) {
            var $panel = $('<div class="panel"></div>');

            $panel.css({
                width: config.panels.width,
                height: config.panels.height,
                left: (c - 1) * config.panels.width,
                top: (r - 1) * config.panels.height
            }).appendTo($body).bind('flashIn', function(event, flashOut) {
                var $this = $(this);

                if($this.css('display') != 'none') {
                    $this.clearQueue().fadeTo(config.panels.animation_duration, 1, function() {
                        if(flashOut) {
                            $this.trigger('flashOut');
                        }
                    });
                }
            }).bind('flashOut', function() {
                $(this).fadeTo(config.panels.animation_duration, 0);
            });

            if(!config.panels.random_phones) {
                $panel.addClass('hide-on-phones');
            }
        }
    }

    var $panels = $('.panel'),
        panels_amount = rows * cols;
    
    function getPanelByIndex(index) {
        return $panels.eq((index.y * cols) + index.x);
    }

    function flashPanel(index, tail, i, last_index) {        
        var $panel = getPanelByIndex(index);

        i = (i !== undefined)? i : 0;

        $panel.trigger('flashIn', true);

        if(tail) {
            var flash_sibling = (Math.random() * 25 > Math.pow(1.1, i))? true : false;

            if(flash_sibling) {            
                function generateIndex(index, last_index) {
                    var side = Math.floor(Math.random() * 4) + 1,
                        new_index = {
                            x: index.x,
                            y: index.y
                        };
                        
                    if(side == 2 && index.x < cols) {                        
                        new_index.x = index.x + 1;  
                    } else if(side == 4 && index.x > 0) {
                        new_index.x = index.x - 1;                    
                    }

                    if(side == 1 && index.y > 0) {
                        new_index.y = index.y - 1;                    
                    } else if(side == 3 && index.y < rows) {
                        new_index.y = index.y + 1;                    
                    }                    

                    if((new_index.x == index.x && new_index.y == index.y) || (last_index && new_index.x == last_index.x && new_index.y == last_index.y)) {                        
                        new_index = generateIndex(index, last_index);
                    }

                    return new_index;
                }

                setTimeout(function() {
                    flashPanel(generateIndex(index, last_index), tail, i + 1, index);
                }, config.panels.animation_duration / 3.5);
                
            }
        }
    } 

    // Random flashing 
    function randomFlash() {
        var time = Math.floor(Math.random() * (config.panels.random_max_interval - config.panels.random_min_interval) + config.panels.random_min_interval);

        setTimeout(function() {
            if(config.panels.random) {
                var index = {
                    x: Math.floor(Math.random() * (cols + 1)),
                    y: Math.floor(Math.random() * (rows + 1))
                }

                flashPanel(index, config.panels.random_tails)
            }

            randomFlash();
        }, time);
    }

    randomFlash();

    // Hover flashing 
    $panels.mouseenter(function() {
        if(config.panels.hover) {
            $(this).trigger('flashIn', false);
        }
    }).mouseleave(function() {
        if(config.panels.hover) {
            $(this).trigger('flashOut');
        }
    });

    if(config.panels.hover && config.panels.hover_over_elements) {
        var last_index = {x: 0, y: 0};        

        $(document).mousemove(function(e) {   
            var index = {
                    x: Math.floor(e.clientX / config.panels.width),
                    y: Math.floor(e.clientY / config.panels.height)
                }

            if(index.x != last_index.x || index.y != last_index.y) {
                var $element = $(e.toElement);

                if(!$element.hasClass('panel')) {
                    var $panel = getPanelByIndex(index);

                    $panel.trigger('flashIn', false);
                }

                $(getPanelByIndex(last_index)).trigger('flashOut');
            }

            last_index = index;
        });
    }

    // Countdown 
    var date = new Date(config.countdown.year, config.countdown.month - 1, config.countdown.day, config.countdown.hours, config.countdown.minutes, config.countdown.seconds);
    var $countdown = $('#countdown');

    $countdown.countdown(date, function(event) {
        switch(event.type) {
            case "seconds":
            case "minutes":
            case "hours":
            case "days":
            case "weeks":
            case "daysLeft":
                $('.' + event.type, $countdown).text(event.value);
                break;

            case "finished":
                $countdown.text('LAUNCHED');
                break;
        }
    });

    // Subscription form 
    var messages = config.subscription,
        $form = $('#subscribe-form'),
        $email = $('#subscribe-email'),
        $button = $('#subscribe-submit'),
        $tooltip = $('#subscribe-tooltip');


    $form.submit(function(event) {
        event.preventDefault();

        var error = false,
            email = $email.val();
        

        if($tooltip.length == 0) {
            $tooltip = $('<p id="subscribe-tooltip" class="subscribe-tooltip"></p>');
        } else {
            $tooltip.removeClass('error success');
        }

        if(email.length == 0) {
            $tooltip.text(messages['empty_email']).addClass('error').appendTo($form);
        }
        else {
            $button.attr('disabled', 'disabled');

            $.post('subscribe.php', {
                'email': email,
                'ajax': 1
            },
            function(data) {
                if(data == null || typeof(data.status) == 'undefined' || (data.status == 'error' && typeof(data.error) == 'undefined')) {
                    $tooltip.text(messages['default']).addClass('error').appendTo($form);
                }
                else if(data.status == 'success') {
                    $tooltip.text(messages['success']).addClass('success').appendTo($form);
                }
                else {
                    var error_text = messages['default_error'];

                    switch(data.error) {
                        case 'empty_email':
                        case 'invalid_email':
                            error_text = messages[data.error];
                            break;
                    }

                    $tooltip.text(error_text).addClass('error').appendTo($form);
                }

                $button.removeAttr('disabled');
            },
            'json');
        }
    });

    // Remove tooltip on text change 
    $email.on('change focus click keyup', function() {
        if($(this).val().length > 0)
        {
            $tooltip.remove();
        }
    });
});