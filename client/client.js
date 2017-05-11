$(document).ready(function () {
    /*
    $("#click-me").click(function () {
        $.ajax({
            type: "POST",
            url: "/search",
            data: {
                search: $("#search").val()
            },
            success: function (data) {
                document.write(data);
            }
        });
    });
    */
    $("#search").keydown(function (event) {
        var contents = $("#search").val();
        var dataToSend = "";

        if (contents === "") {
            $.ajax({
                type: "POST",
                url: "/search",
                data: {
                    search: dataToSend
                },
                success: successFunction()
            });
        } else {
            $.ajax({
                type: "POST",
                url: "/search",
                data: {
                    search: contents
                },
                success: function (data) {
                    $(".text-area").text(data.toString());
                }
            });
        }

        function successFunction(data) {
            $("#.text-area").text(data.toString());
        }
    });
});