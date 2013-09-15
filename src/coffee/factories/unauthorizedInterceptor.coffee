@tg ?= {}
@tg.factories ?= {}
$$ = @tg.factories

$$.unauthorizedInterceptor = ($q, $location, FORBIDDEN_PATH, IGNORE_FORBIDDEN_AT) ->
  interceptor = (promise) ->
    return promise.then(
      _.identity,
      (response) ->
        if response.status in [401, 403] && not $location.path in IGNORE_FORBIDDEN_AT
          $location.path(FORBIDDEN_PATH)
        else
          return $q.reject(response)
    )
  return interceptor