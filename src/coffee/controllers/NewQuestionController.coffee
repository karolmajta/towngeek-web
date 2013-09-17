@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.NewQuestionController = ($log, $scope, $location, TGResource, currentUser, TGPaginatedResource, FORBIDDEN_PATH) ->

  if not currentUser.isLoggedIn()
    $location.path(FORBIDDEN_PATH)

  rQuestion = TGResource.getResource('question')
  rCity = TGResource.getResource('city')
  rCityList = new TGPaginatedResource(rCity, 100)

  $scope.cities = []
  rCityList.getNextPage({}, ( (l) -> $scope.cities = l ), (response)  ->)

  $scope.isPosting = false

  $scope.question =
    city: $scope.$routeParams.city
    text: ""

  $scope.attemptPostQuestion = () ->
    data =
      city: $scope.question.city
      text: $scope.question.text
    rQuestion.post(data).then(
      ( (response) -> $location.path("/questions/#{ response.data.result.id }") ),
      (response) -> $scope.isPosting = false
    )
    $scope.isPosting = true