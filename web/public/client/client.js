$(document).ready(function () {
    
    var englishUsed = true;
    var displayChoices = {
        CHRONOLOGICAL : "chronological",
        PERSEASON : "per-season",
        PERTINENCE : "pertinence",
        STATISTICS : "statistics" 
    };

    var displayChoice = displayChoices.CHRONOLOGICAL;

    var en = $('#en');
    var fr = $('#fr');

    en.css('background-color', '#f44336');
    
    en.click(function () {
        if (!englishUsed) {
            englishUsed = true;
            en.css('background-color', '#f44336');
            fr.css('background-color', '#c5cae9');
            $('#type-of-request').text('Type of Request');
            $('#keyword-request').text('Keyword');
            $('#statistics_request-request').text('statistics_request');
            $('#keyword-display').text('Keyword Display');
            $('#chronological').text('Chronological');
            $('#per-season').text('Per Season');
            $('#pertinence').text('Pertinence');
            $('#submit').text('Try');
        }
    });

    fr.click(function () {
        if (englishUsed) {
            englishUsed = false;
            fr.css('background-color', '#f44336');
            en.css('background-color', '#c5cae9');
            $('#type-of-request').text('Type de Requête');
            $('#keyword-request').text('Mot Clef');
            $('#statistics_request-request').text('Statistiques');
            $('#keyword-display').text('Affichage Mot Clef');
            $('#chronological').text('Chronologique');
            $('#per-season').text('Par Saison');
            $('#pertinence').text('Pertinence');
            $('#submit').text('Essayer');
        }
    });

    var keyword_request = $('#keyword-request');
    keyword_request.css('background-color', '#3f51b5');
    keyword_request.css('color', 'white');

    var statistics_request = $('#statistics-request');
    var keyword_display_types = $('#keyword-display-types');

    keyword_request.on({
        click: function() {
            displayChoice = displayChoices.CHRONOLOGICAL;
            keyword_request.css('background-color', '#3f51b5');
            keyword_request.css('color', 'white');
            keyword_display_types.css('opacity', '1');
            statistics_request.css('background-color', '#c5cae9');
            statistics_request.css('color', 'black');
            $('#search-keyword').removeAttr('disabled');
            // statistics_request.hover(function() {
            //     statistics_request.css('background-color', '#3f51b5');
            //     statistics_request.css('color', 'white');
            // });
        }
    });

    statistics_request.on({
        click : function() {
            displayChoice = displayChoices.STATISTICS;
            statistics_request.css('background-color', '#3f51b5');
            statistics_request.css('color', 'white');
            keyword_display_types.css('opacity', '0');
            keyword_request.css('background-color', '#c5cae9');
            keyword_request.css('color', 'black');
            $('#search-keyword').attr('disabled','disabled');
            // keyword_request.hover(function() {
            //     keyword_request.css('background-color', '#3f51b5');
            //     keyword_request.css('color', 'white');
            // });
        }
    });

    var chronological = $('#chronological');
    chronological.css('background-color', '#3f51b5');
    chronological.css('color', 'white');

    var per_season = $('#per-season');
    var pertinence = $('#pertinence');

    chronological.on({
        click: function() {
            if(displayChoice !== displayChoices.STATISTICS) {
                displayChoice = displayChoices.CHRONOLOGICAL;
            }
            chronological.css('background-color', '#3f51b5');
            chronological.css('color', 'white');
            per_season.css('background-color', '#c5cae9');
            per_season.css('color', 'black');
            pertinence.css('background-color', '#c5cae9');
            pertinence.css('color', 'black');
            // per_season.hover(function() {
            //     per_season.css('background-color', '#3f51b5');
            //     per_season.css('color', 'white');
            // });
            // pertinence.hover(function() {
            //     pertinence.css('background-color', '#3f51b5');
            //     pertinence.css('color', 'white');
            // });
        }
    });

    per_season.on({
        click: function() {
            if(displayChoice !== displayChoices.STATISTICS) {
                displayChoice = displayChoices.PERSEASON;
            }
            per_season.css('background-color', '#3f51b5');
            per_season.css('color', 'white');
            chronological.css('background-color', '#c5cae9');
            chronological.css('color', 'black');
            pertinence.css('background-color', '#c5cae9');
            pertinence.css('color', 'black');
            // chronological.hover(function() {
            //     chronological.css('background-color', '#3f51b5');
            //     chronological.css('color', 'white');
            // });
            // pertinence.hover(function() {
            //     pertinence.css('background-color', '#3f51b5');
            //     pertinence.css('color', 'white');
            // });
        }
    });

    pertinence.on({
        click: function() {
            if(displayChoice !== displayChoices.STATISTICS) {
                displayChoice = displayChoices.PERTINENCE;
            }
            pertinence.css('background-color', '#3f51b5');
            pertinence.css('color', 'white');
            per_season.css('background-color', '#c5cae9');
            per_season.css('color', 'black');
            chronological.css('background-color', '#c5cae9');
            chronological.css('color', 'black');
            // per_season.hover(function() {
            //     per_season.css('background-color', '#3f51b5');
            //     per_season.css('color', 'white');
            // });
            // chronological.hover(function() {
            //     chronological.css('background-color', '#3f51b5');
            //     chronological.css('color', 'white');
            // });
        }
    });

    var series = $('#search-series');
    var keyword = $('#search-keyword');
    
    series.click(function () {
        var style = series.attr('style');
        if (typeof style !== typeof undefined && style !== false) {
            series.val('');
            console.log('Removing all previous style overrides on series elements');
            series.removeAttr('style');
        }
    });

    keyword.click(function () {
        var style = keyword.attr('style');
        if (typeof style !== typeof undefined && style !== false) {
            keyword.val('');
            console.log('Removing all previous style overrides on keyword elements');
            keyword.removeAttr('style');
        }
    });

    $('#submit').click(function (event) {
        if (series.val() !== '') {
            if(displayChoice === displayChoices.STATISTICS) {
                $.ajax({
                    type : 'GET',
                    url : '/search/' + series.val() + '/N_A/' + displayChoice,
                    success : function (data) {
                        $('#text-area').text(data.toString());
                    }
                });
            } else {
                if (keyword.val() !== '') {
                    var keywordRegex = /[Nn]\/[Aa]/;
                    if (keywordRegex.test(keyword.val())) {
                        keyword.css('color', 'red');
                        keyword.val('Enter a valid keyword');
                    } else {
                        $.ajax({
                            type : 'GET',
                            url : '/search/' + series.val() + '/' + keyword.val() + '/' + displayChoice,
                            success : function (data) {
                                $('#text-area').html(data.toString());
                            }
                        });
                        $('#text-area').text("Processing request...");
                    }
                } else {
                    console.log('No text found in keyword element');
                    keyword.css('color', 'red');
                    keyword.val('Enter a valid keyword');
                }
            }
        } else {
            console.log('No text found in series element');
            series.css('color', 'red');
            series.val('Enter the name of a TV Series');
        }
    });

    $('#tryejs').click(function (event) {
        $.ajax({
            type : 'GET',
            url : '/tryejs',
            success : function (data) {
                console.log('Success');
                $('#text-area').html(data);
            }
        });
    });
});
