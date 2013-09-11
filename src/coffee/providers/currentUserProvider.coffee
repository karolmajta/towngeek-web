@tg ?= {}
@tg.providers ?= {}
$$ = @tg.providers

$$.currentUserProvider =

  $get: ($log, $location, $cookieStore, TGResource, USER_COOKIE_NAME, ANON_NAME) ->

    cu =
      fromNetwork:
        token: null
        user: null

    remoteUserToken = TGResource.getResource('token')
    remoteUser = TGResource.getResource('user')

    cu.isAnonymous = () ->
      cu.lazyLoginFromCache()
      cu.fromNetwork.token is null

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

    cu.lazyLoginFromCache = () ->
      if cu.fromNetwork
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
      onSuccess(cu.fromNetwork.user)

    cu.onFetchUserError = (response, onFailure) ->
      cu.fromNetwork.token = null
      cu.fromNetwork.user = null
      onFailure("Could not fetch user credentials from server...")

    cu.logout = (onSuccess) ->
      cu.fromNetwork.token = null
      cu.fromNetwork.user = null
      $cookieStore.remove(USER_COOKIE_NAME)
      onSuccess()

    return cu