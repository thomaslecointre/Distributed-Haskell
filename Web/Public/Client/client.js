$(document).ready(function () {
    $("#search").keyup(function (event) {
        var contents = $("#search").val();
        if(contents !== "") {
            $.ajax({
                type : "GET",
                url : "/search/" + contents,
                success : function(data) {
                    $(".text-area").text(data.toString());
                }
            });
        }
    });
});
