@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.ProfileController = ($log, $scope, $location, $routeParams, TGResource, TGPaginatedResource, currentUser) ->

  rUser = TGResource.getResource('user')
  rCity = TGResource.getResource('city')
  rCityList = new TGPaginatedResource(rCity, 100)
  rCityKnowledge = TGResource.getResource('city-knowledge')
  rCityKnowledgeList = new TGPaginatedResource(rCityKnowledge, 100)

  $scope.user = null
  $scope.cities = null
  $scope.cityKnowledges = null

  rUser.get($routeParams.id).then(
    ( (response) -> consumeUser(response) ),
    ( (response) -> consumeError(response) )
  )

  consumeUser = (response) ->
    $scope.user = response.data.result
    if $scope.user.id == currentUser.id()
      rCityList.getNextPage({}, consumeCities, consumeError)
    else
      rCityKnowledgeList.getNextPage({user: $scope.user.id}, consumeCityKnowledges, consumeError)

  consumeCities = (list) ->
    $scope.cities = list
    rCityKnowledgeList.getNextPage({user: $scope.user.id}, consumeCityKnowledges, consumeError)

  consumeCityKnowledges = (list) ->
    $scope.cityKnowledges = list

  consumeError = (response) ->
    $location = "/#/not-found/"