@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.CityKnowledgeController = ($log, $scope, TGResource) ->

  rCityKnowledge = TGResource.getResource('city-knowledge')

  $scope.isFetching = false
  $scope.newKnowledges = []

  $scope.init = (city) ->
    $scope.city = city

  $scope.userHasKnowledge = () ->
    _.find($scope.$parent.cityKnowledges, (ck) -> ck.city.id == $scope.city.id)

  $scope.toggleKnowledge = () ->
    knowledge = _.find($scope.$parent.cityKnowledges, (ck) -> ck.city.id == $scope.city.id)
    if knowledge
      rCityKnowledge.delete(knowledge.id).then(( (resp) -> onDelete(knowledge.id) ), onResp)
      $scope.isFetching = true
    else
      rCityKnowledge.post({'city': $scope.city.id}).then(( (resp) -> onPost(resp.data.result) ), onResp)
      $scope.isFetching = true

  onPost = (knowledge) ->
    knowledge.city = $scope.city
    knowledge.user = $scope.currentUser.fromNetwork
    $scope.$parent.cityKnowledges.push(knowledge)
    $scope.isFetching = false

  onDelete = (id) ->
    removed = _.filter($scope.$parent.cityKnowledges, (ck) -> ck.id != id)
    $scope.$parent.cityKnowledges = removed
    $scope.isFetching = false

  onResp = (anyhing) -> $scope.isFetching = false