(function(){
  var path = location.pathname;
  var id = path.match(/^\/(v|star)\/(\w+)/)[2];
  if(id){
    alert(id);
  }
})();
