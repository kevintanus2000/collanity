<!DOCTYPE html>

<html>

<head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
  .box
  {
    width:49.8%;
    height:1000px;
    float:left;
    overflow: auto;
    margin-bottom:2%;
  }
  .genbox
  {
    margin:2%;
    height:50px; 
    width:50px;
  }
</style>

</head>

<body>

<label for="iboxes">Enter The Number Of New Boxes : </label>

<input type="text" id="iboxes">

<button type="button" id="start">Start</button> <br><br>

<div style="background-color:blue; margin-right:0.1%;" class="box" id="box1">

</div>

<div style="background-color:green; margin-left:0.1%" class="box" id="box2">

</div>

<script>
var lastBox = 0;

function changeBoxPlace(boxPlaceId, boxId)
{
  var box = $("#genbox" + boxId).clone();
  $("#genbox" + boxId).remove();
  if(boxPlaceId == 1)
  {
    box.attr('onclick','changeBoxPlace('+ 2 +','+boxId+')');
    $("#box2").append(box);
  }
  else
  {
    box.attr('onclick','changeBoxPlace('+ 1 +','+boxId+')');
    $("#box1").append(box);
  }
}

$(document).ready(function(){

  $("#start").click(function(){
    if($.isNumeric($("#iboxes").val()))
    {
      var inputBox = parseInt($("#iboxes").val());
      for (let i = lastBox + 1; i <= lastBox + inputBox; i++) {
        var randomColor = Math.floor(Math.random()*16777215).toString(16);
        var randomBox = Math.round((Math.random())+1);
        $("#box" + randomBox).append('<button type="button" class="genbox" id="genbox'+ i +'" onclick="changeBoxPlace('+ randomBox +',' + i +')" style="background-color:#'+ randomColor +';"><b>'+ i +'</b></button>');
      }
      lastBox += inputBox;
      $("#iboxes").val("");
    }
  });

});

</script>

</body>

</html>