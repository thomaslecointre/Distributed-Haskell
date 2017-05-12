$(document).ready(function () {
    $("#search").keyup(function (event) {
        var contents = $("#search").val();
        $.ajax({
          type : "POST",
          url : "/search",
          data : {
              search : $("#search").val()
          },
          success : function(data) {
            $(".text-area").text(data.toString());
          }
        });


    });
});
