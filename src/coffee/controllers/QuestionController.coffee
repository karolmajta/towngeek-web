@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.QuestionController = ($log, $scope, $routeParams, TGResource, TGPaginatedResource, currentUser) ->

  rAnswer = TGResource.getResource('answer')
  rAnswerList = new TGPaginatedResource(rAnswer, 10)
  rBookmark = TGResource.getResource('bookmark')

  consumePage = (data) ->
    $scope.answers.showSpinner = false
    unique = omitUploaded(data)
    for elem in unique then $scope.answers.push(elem)

  consumeError = (response) ->
    $scope.answers.showSpinner = false

  $scope.answers = []

  uploadedAnswers = []
  uploadedAnswers.add = (answer) ->
    uploadedAnswers.push(answer)
    $scope.answers.push(answer)
    $scope.answers = _.sortBy(_.sortBy($scope.answers, (b) -> b.issued_at).reverse(), (a) -> -a.score)

  $scope.uploadedAnswers = uploadedAnswers


  omitUploaded = (fetchedAnswers) ->
    for ua in uploadedAnswers
      fetchedAnswers = _.filter(fetchedAnswers, (fa) -> fa.id != ua.id)
    return fetchedAnswers

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

  $scope.isFetching = false

  $scope.toggleBookmark = () ->

    if not $scope.question.is_bookmarked
      rBookmark.post({'question': $scope.question.id}).then(( (resp) ->
        $scope.question.bookmark_count += 1
        $scope.question.is_bookmarked = true
        $scope.isFetching = false
      ), (response) ->
        $scope.isFetching = false
      )
      $scope.isFetching = true
    else
      config =
        params:
          user: currentUser.id()
          question: $scope.question.id
      rBookmark.get(null, config).then(
        ( (response) -> _.find(response.data.results, (b) -> b.question == $scope.question.id) ),
        (response) -> $scope.isFetching = false
      ).then(
        ( (bookmark) -> rBookmark.delete(bookmark.id)),
        (response) -> $scope.isFetching = false
      ).then(
        ( (response) ->
          $scope.question.bookmark_count = Math.max(0, $scope.question.bookmark_count-1);
          $scope.question.is_bookmarked = false;
          $scope.isFetching = false;
        ), (response) -> $scope.isFetching = false
      )
      $scope.isFetching = true

  $scope.newAnswer = ""

  $scope.isPostingAnswer = false

  $scope.attemptPostAnswer = () ->
    data =
      question: $scope.question.id
      text: $scope.newAnswer
    rAnswer.post(data).then(
      ( (response) -> uploadedAnswers.add(response.data.result) ),
      (response) ->
    )
    $scope.isPostingAnswer = true