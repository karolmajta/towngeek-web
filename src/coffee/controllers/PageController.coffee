@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.PageController = ($log, $scope, currentUser, $routeParams) ->
  $scope.currentUser = currentUser
  $scope.$routeParams = $routeParams

