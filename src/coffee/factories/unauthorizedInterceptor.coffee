@tg ?= {}
@tg.factories ?= {}
$$ = @tg.factories

$$.unauthorizedInterceptor = ($q, $location, FORBIDDEN_PATH) ->
  interceptor = (promise) ->
    return promise.then(
      _.identity,
      (response) ->
        if response.status == 403
          $location.path(FORBIDDEN_PATH)
        else
          return $q.reject(response)
    )
  return interceptor