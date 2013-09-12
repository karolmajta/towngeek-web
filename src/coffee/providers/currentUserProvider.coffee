@tg ?= {}
@tg.providers ?= {}
$$ = @tg.providers

$$.currentUserProvider =

  $get: ($log, $location, $cookieStore, $http, TGResource, USER_COOKIE_NAME, ANON_NAME) ->

    cu =
      fromNetwork:
        token: null
        user: null

    remoteUserToken = TGResource.getResource('token')
    remoteUser = TGResource.getResource('user')

    cu.isAnonymous = () ->
      cu.lazyLoginFromCache()
      not (cu.fromNetwork.user and cu.fromNetwork.token)

    cu.isLoggedIn = () -> not cu.isAnonymous()

    cu.fullName = () ->
      if cu.isAnonymous()
        ANON_NAME
      else
        fn = "#{ cu.fromNetwork.user.first_name }"
        ln = cu.fromNetwork.user.last_name
        if ln
          n = "#{ fn } #{ ln }"
        else
          n = fn
        return n

    cu.id = () ->
      if cu.isAnonymous()
        return null
      else
        return cu.fromNetwork.user.id

    cu.lazyLoginFromCache = () ->
      if cu.fromNetwork and cu.fromNetwork.token and cu.fromNetwork.user
        return
      else
        credentialsFromCache = $cookieStore.get(USER_COOKIE_NAME)
        if credentialsFromCache is undefined
          return
        else
          cu.fromNetwork = credentialsFromCache

    cu.login = (email, password, onSuccess, onFailure) ->

      config =
        params:
          email: email
          password: password

      remoteUserToken.get(null, config).then(
        ( (response) -> cu.onLoginSuccess(response.data, onSuccess, onFailure) ),
        ( (response) -> cu.onLoginError(response, onFailure) )
      )

    cu.onLoginSuccess = (responseData, onSuccess, onFailure) ->
      cu.fromNetwork.token = responseData.result.key
      remoteUser.get(responseData.result.user).then(
        ( (r) -> cu.onFetchUserSuccess(r.data, onSuccess) ),
        ( (r) -> cu.onFetchUserError(r, onFailure) )
      )

    cu.onLoginError = (response, onFailure) ->
      cu.fromNetwork.token = null
      cu.fromNetwork.user = null
      onFailure("Authorization failed...")

    cu.onFetchUserSuccess = (response, onSuccess) ->
      cu.fromNetwork.user = response.result
      $cookieStore.put(USER_COOKIE_NAME, cu.fromNetwork)
      $http.defaults.headers.common['Authorization'] = "Token #{ cu.fromNetwork.token }"
      onSuccess(cu.fromNetwork.user)

    cu.onFetchUserError = (response, onFailure) ->
      cu.fromNetwork.token = null
      cu.fromNetwork.user = null
      if onFailure then onFailure("Could not fetch user credentials from server...")

    cu.logout = (onSuccess) ->
      cu.fromNetwork.token = null
      cu.fromNetwork.user = null
      $cookieStore.remove(USER_COOKIE_NAME)
      delete $http.defaults.headers.common['Authorization']
      if onSuccess then onSuccess()

    return cu