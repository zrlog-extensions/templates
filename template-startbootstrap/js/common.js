$(document).ready(function(){
    var classes = ["teg-1", "teg-2", "teg-3", "teg-4", "teg-5","teg-6"];

    $("#tegcloud a").each(function(){
        $(this).addClass(classes[~~(Math.random()*classes.length)]);
    });
});