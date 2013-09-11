@tg ?= {}
@tg.factories ?= {}
$$ = @tg.factories

$$.TGPaginatedResource = () ->

  paginatedResource = (remoteResource, pageSize) ->

    lastPage = 0
    hasNext = true

    @reset = () ->
      lastPage = 0
      hasNext = true

    @hasNextPage = () -> hasNext

    @getPageNo = (pageNo, overrideParams, onSuccess, onError) ->
      defaultParams =
        page: pageNo
      if pageSize
        defaultParams.page_size = pageSize
      params = _.extend(defaultParams, overrideParams)
      config =
        params: params

      remoteResource.get(null, config).then(
        ( (response) ->
          if response.data.next
            lastPage += 1
            hasNext = true
          else
            lastPage += 1
            hasNext = false
          onSuccess(response.data.results) ),
        ( (response) -> onError(response) )
      )

    @getNextPage = (overrideParams, onSuccess, onError) -> @getPageNo(lastPage + 1, overrideParams, onSuccess, onError)

    return this

  return paginatedResource