@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.QuestionListController = ($log, $scope, $routeParams, TGResource, TGPaginatedResource) ->

  rQuestion = TGResource.getResource('question')
  rQuestionList = new TGPaginatedResource(rQuestion, 10)
  consumePage = (data) ->
    $scope.questions.showSpinner = false
    for elem in data then $scope.questions.push(elem)

  consumeError = (response) ->
    $scope.questions.showSpinner = false

  $scope.questions = []

  $scope.questions.haveNextPage = () -> rQuestionList.hasNextPage()

  $scope.questions.fetchNextPage = () ->
    $scope.questions.showSpinner = true
    rQuestionList.getNextPage({city: $routeParams.city}, consumePage, consumeError )

  $scope.questions.showSpinner = false

  rQuestionList.getNextPage({city: $routeParams.city},
    ( consumePage  ),
    ( consumeError )
  )