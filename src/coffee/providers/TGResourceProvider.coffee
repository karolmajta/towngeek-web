@tg ?= {}
@tg.providers ?= {}
$$ = @tg.providers


TGResourceDescription = (apiRoot, url, providerHandle) ->

  p = providerHandle

  @methods =
    head: (config) -> p.$http(_.extend({medhod: "HEAD", url: url}, config))
    options: (config) -> p.$http(_.extend({medhod: "OPTIONS", url: url}, config))

  @canGet = () ->
    @methods.get = (id, config) =>
      if id
        resourceUrl = "#{ apiRoot }#{ url }#{ id }"
      else
        resourceUrl = "#{ apiRoot }#{ url }"
      return p.$http(_.extend({method: "GET", url: resourceUrl}, config))

    return @

  @canPost = () ->
    @methods.post = (data, config) =>
      resourceUrl = "#{ apiRoot }#{ url }"
      return p.$http(_.extend({method: "POST", url: resourceUrl, data: data}, config))
    return @

  @canPut = () ->
    @methods.put = (id, data, config) =>
      resourceUrl = "#{ apiRoot }#{ url }#{ id }"
      return p.$http(_.extend({method: "PUT", url: resourceUrl, data: data}, config))
    return @

  @canPatch = () ->
    @methods.patch = (id, data, config) =>
      resourceUrl = "#{ apiRoot }#{ url }#{ id }"
      return p.$http(_.extend({method: "PATCH", url: resourceUrl, data: data}, config))
    return @

  @canDelete = () ->
    @methods.delete = (id, config) =>
      resourceUrl = "#{ apiRoot }#{ url }#{ id }"
      return p.$http(_.extend({method: "DELETE", url: resourceUrl}, config))
    return @

  return @


$$.TGResourceProvider = (API_ROOT) ->

  rp =
    resourceMap: {}

  rp.getResource = (name) ->
    resourceDescription = rp.resourceMap[name]
    if resourceDescription is undefined
      return undefined
    else
      resource =
        head: resourceDescription.methods.head
        options: resourceDescription.methods.options
        get: resourceDescription.methods.get
        post: resourceDescription.methods.post
        put: resourceDescription.methods.put
        patch: resourceDescription.methods.patch
        delete: resourceDescription.methods.delete
      return resource


  @hasResource = (name, url) ->
    rp.resourceMap[name] = new TGResourceDescription(API_ROOT, url, rp)
    return rp.resourceMap[name]

  @$get = ($http, API_ROOT) ->
    rp.$http = $http
    rp.API_ROOT = API_ROOT
    return rp