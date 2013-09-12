@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.LoginController = ($log, $scope, $routeParams, $location, currentUser, ON_LOGIN_PATH) ->

  if currentUser.isLoggedIn()
    if $routeParams.next
      $location.path($routeParams.next)
    else
      $location.path(ON_LOGIN_PATH)

  $scope.credentials =
    email: ""
    password: ""

  $scope.formMeta =
    isFetching: false
    hadError: false

  $scope.attemptLogin = () ->
    currentUser.login($scope.credentials.email, $scope.credentials.password, onLoginSuccess, onLoginError)
    $scope.formMeta.isFetching = true

  onLoginSuccess = (user) ->
    if $routeParams.next
      $location.path($routeParams.next)
    else
      $location.path(ON_LOGIN_PATH)

  onLoginError = (reason) ->
    $scope.formMeta.hadError = true
    $scope.formMeta.isFetching = false