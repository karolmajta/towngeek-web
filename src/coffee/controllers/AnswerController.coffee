@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.AnswerController = ($log, $scope, TGResource) ->

  rVote = TGResource.getResource('vote')

  $scope.voteIsChanging = false
  $scope.getParagraphs = () ->
    if $scope.answer
      allWords = _.str.words($scope.answer.text, "\n")
      goodWords = _.filter(allWords, (w) -> w != "")
      return goodWords
    else
      []

  voteValue = $scope.answer.my_vote

  $scope.toggleUpvote = () ->
    $log.warn("togglin...")
    if $scope.answer.my_vote == 1
      attemptVoteChange(0)
    else
      attemptVoteChange(1)

  $scope.toggleDownvote = () ->
    $log.warn("togglin d...")
    if $scope.answer.my_vote == -1
      attemptVoteChange(0)
    else
      attemptVoteChange(-1)

  attemptVoteChange = (val) ->
    data =
      answer: parseInt($scope.answer.id)
      value: val
    rVote.post(data).then(
      ( (response) -> if response.data
          $scope.answer.my_vote = response.data.result.value
          $scope.answer.score += response.data.result.value - voteValue
          voteValue = $scope.answer.my_vote),
      ( (response) -> $log.warn(response))
    )
    $scope.voteIsChanging = true