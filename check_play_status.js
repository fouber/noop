(function(){
  var path = location.pathname;
  var id = path.match(/^\/(v|star)\/(\w+)/)[1];
  if(id){
    alert(id);
  }
})();
