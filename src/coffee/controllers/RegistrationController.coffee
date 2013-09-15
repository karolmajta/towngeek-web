@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.RegistrationController = ($log, $scope, $routeParams, $location, currentUser, TGResource, ON_LOGIN_PATH) ->

  if currentUser.isLoggedIn()
    if $routeParams.next
      $location.path($routeParams.next)
    else
      $location.path(ON_LOGIN_PATH)

  credentials =
    name: ""
    email: ""
    password1: ""
    password2: ""
    passwordsMatch: () -> @password1 == @password2
    areValid: () -> @email and @passwordsMatch() and _.str.trim(@name).length > 0 and @email.length > 0 and @password1.length > 0
    getFirstName: () -> _.str.words(@name)[0]
    getLastName: () ->_.str.toSentence(_.tail(_.str.words(@name)), " ", " ")

  rUser = TGResource.getResource('user')

  $scope.credentials = credentials

  $scope.formMeta =
    isFetching: false
    hadError: false

  $scope.attemptRegistration = () ->
    data =
      first_name: credentials.getFirstName()
      last_name: credentials.getLastName()
      email: credentials.email
      password: credentials.password1
    rUser.post(data).then(
      ( (response) -> onRegistrationSuccess(response.data.result) ),
      onRegistrationError
    )
    $scope.formMeta.isFetching = true

  onRegistrationSuccess = (user) ->
    $log.warn(user)
    currentUser.login(user.email, credentials.password1, onLoginSuccess, onLoginError)

  onLoginSuccess = (user) -> $location.path("/profiles/#{ user.id }")

  onRegistrationError = (reason) ->
    $scope.formMeta.hadError = true
    $scope.formMeta.isFetching = false

  onLoginError = (reason) ->
    $scope.formMeta.hadError = true
    $scope.formMeta.isFetching = false