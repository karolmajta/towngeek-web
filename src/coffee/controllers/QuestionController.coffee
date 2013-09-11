@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.QuestionController = ($log, $scope, $routeParams, TGResource, TGPaginatedResource) ->

  rAnswer = TGResource.getResource('answer')
  rAnswerList = new TGPaginatedResource(rAnswer, 10)

  consumePage = (data) ->
    $scope.answers.showSpinner = false
    for elem in data then $scope.answers.push(elem)

  consumeError = (response) ->
    $scope.answers.showSpinner = false

  $scope.answers = []

  $scope.answers.haveNextPage = () -> rAnswerList.hasNextPage()

  $scope.answers.fetchNextPage = () ->
    $scope.answers.showSpinner = true
    rAnswerList.getNextPage({'question': $scope.question.id}, consumePage, consumeError )

  $scope.answers.showSpinner = false

  # if there is no question in scope it means we are working outside of the context of a list
  # and need to get our question via HTTP basing on route prarams.

  # by default when working inside context of question list, do not auto-fetch answers, but
  # if we are working outside the context, just autofetch

  unless $scope.question
    rQuestion = TGResource.getResource('question')
    rQuestion.get($routeParams.id).then(
      ( (response) -> $scope.question = response.data.result; return response.data.result ),
      ( (response) -> $log.warn(response); return response )
    ).then(
      ( (question) -> rAnswerList.getNextPage({'question': question.id}, consumePage, consumeError) ),
      ( (response) -> $log.warn(response); return response )
    )