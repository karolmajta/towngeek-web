@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.TopBarController = ($scope, $location, currentUser) ->

  $scope.currentPath = () -> $location.path()