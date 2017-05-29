$(document).ready(function () {
    var series = $("#search-series");
    var keyword = $("#search-keyword");
    
    series.click(function() {
        series.val("");
        var style = series.attr("style");
        if(typeof style !== typeof undefined && style !== false) {
            console.log("Removing all previous style overrides on series elements");
            series.removeAttr("style");
        }
    });

    keyword.click(function() {
        keyword.val("");
        var style = keyword.attr("style");
        if(typeof style !== typeof undefined && style !== false) {
            console.log("Removing all previous style overrides on keyword elements");
            keyword.removeAttr("style");
        }
    });

    $("#submit").click(function (event) {
        if(series.val() !== "") {
            if(keyword.val() !== "") {
                $.ajax({
                    type : "GET",
                    url : "/search/" + series + "/" + keyword,
                    success : function(data) {
                        $(".text-area").text(data.toString());
                    }
                });
            } else {
                console.log("No text found in keyword element");
                keyword.css("color", "red");
                keyword.val("Enter a valid keyword");
            }
        } else {
            console.log("No text found in series element");
            series.css("color", "red");
            series.val("Enter the name of a TV Series");
        }
    });
});
