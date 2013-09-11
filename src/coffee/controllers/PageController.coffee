@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.PageController = ($log, $scope, currentUser) ->
  $scope.currentUser = currentUser
