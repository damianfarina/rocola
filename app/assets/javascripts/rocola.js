/**
 * Rocola Javascript library
 */

var Rocola = Rocola || {};
Rocola.namespace = function (ns_string) {
  var parts = ns_string.split('.'),
  parent = Rocola,
  i;
  // strip redundant leading global
  if (parts[0] === "Rocola") {
    parts = parts.slice(1);
  }
  for (i = 0; i < parts.length; i += 1) {
    // create a property if it doesn't exist
    if (typeof parent[parts[i]] === "undefined") {
      parent[parts[i]] = {};
    }
    parent = parent[parts[i]];
  }
  return parent;
}

Rocola.exec = function( controller, action ) {
  if ( controller !== "" && Rocola[controller] && action !== "" && typeof Rocola[controller][action] == "object" && typeof Rocola[controller][action].init == "function" ) {
    Rocola[controller][action].init();
  }
}

Rocola.init = function() {
  var body = document.body,
  controller = body.getAttribute( "data-controller" ),
  action = body.getAttribute( "data-action" );

  Rocola.exec( controller, action );
}

$( document ).ready( Rocola.init );