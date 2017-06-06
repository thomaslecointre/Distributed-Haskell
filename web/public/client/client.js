$(document).ready(function () {
    
    var englishUsed = true;
    var en = $('#en');
    var fr = $('#fr');

    en.css('background-color', '#f44336');
    
    en.click(function () {
        if (!englishUsed) {
            englishUsed = true;
            en.css('background-color', '#f44336');
            fr.css('background-color', '#c5cae9');
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
            $('#chronological').text('Chronologique');
            $('#per-season').text('Par Saison');
            $('#pertinence').text('Pertinence');
            $('#submit').text('Essayer');
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
            if (keyword.val() !== '') {
                var keywordRegex = /[Nn]\/[Aa]/;
                if (keywordRegex.test(keyword.val())) {
                    keyword.css('color', 'red');
                    keyword.val('Enter a valid keyword');
                } else {
                    $.ajax({
                        type : 'GET',
                        url : '/search/' + series.val() + '/' + keyword.val(),
                        success : function (data) {
                            $('#text-area').text(data.toString());
                        }
                    });
                }
            } else {
                console.log('No text found in keyword element');
                keyword.css('color', 'red');
                keyword.val('Enter a valid keyword');
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
