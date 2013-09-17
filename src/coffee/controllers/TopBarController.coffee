@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.TopBarController = ($log, $scope, $location, currentUser, TGResource, TGPaginatedResource, $routeParams) ->

  $scope.currentPath = () -> $location.path()

  $scope.cities = null

  rCity = TGResource.getResource('city')
  rCityList = new TGPaginatedResource(rCity, 100)

  rCityList.getNextPage({}, ( (l) -> $scope.cities = l ), (response) -> )

  $scope.currentCity = () -> _.find($scope.cities, (c) -> c.id == parseInt($routeParams.city))