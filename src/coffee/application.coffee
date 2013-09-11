application = angular.module('tg', ['ng', 'ngCookies'])

application.constant('API_ROOT', @TGENV.api_root)
application.constant('USER_COOKIE_NAME', "tgUserCookie")
application.constant('ANON_NAME', "Anonymous User")

application.factory('TGPaginatedResource', @tg.factories.TGPaginatedResource)

application.provider('TGResource', @tg.providers.TGResourceProvider)
application.provider('currentUser', @tg.providers.currentUserProvider)

application.controller('PageController', @tg.controllers.PageController)
application.controller('TopBarController', @tg.controllers.TopBarController)

application.controller('QuestionListController', @tg.controllers.QuestionListController)
application.controller('QuestionController', @tg.controllers.QuestionController)

application.config( ($routeProvider, TGResourceProvider) ->

  """
  Configuration of remote resources.
  """

  TGResourceProvider.hasResource('user', '/commons/users/')
    .canGet()
    .canPost()
  TGResourceProvider.hasResource('token', '/commons/token')
    .canGet()
  TGResourceProvider.hasResource('city', '/locations/cities/')
    .canGet()
  TGResourceProvider.hasResource('city', '/locations/city-knowledges/')
    .canGet()
    .canPost()
    .canDelete()
  TGResourceProvider.hasResource('question', '/qa/questions/')
    .canGet()
    .canPost()
  TGResourceProvider.hasResource('answer', '/qa/answers/')
    .canGet()
    .canPost()
  TGResourceProvider.hasResource('bookmark', '/ratings/bookmarks/')
    .canGet()
    .canPost()
    .canDelete()
  TGResourceProvider.hasResource('vote', '/ratings/votes/')
    .canGet()
    .canPost()
    .canDelete()

  """
  Configuration of routes.
  """

  $routeProvider.when('/login/',
    {
      templateUrl: "#{ @TGENV.version }/templates/login.html",
      controller: 'LoginController'
    }
  ).when('/register/',
    {
      templateUrl: "#{ @TGENV.version }/templates/register.html",
      controller: 'RegistrationController'
    }
  ).when('/profile/:id',
    {
      templateUrl: "#{ @TGENV.version }/templates/profile.html",
      controller: 'ProfileController'
    }
  ).when('/',
    {
      templateUrl: "#{ @TGENV.version }/templates/question_list.html",
      controller: 'QuestionListController'
    }
  ).when('/cities/:city',
    {
      templateUrl: "#{ @TGENV.version }/templates/question_list.html",
      controller: 'QuestionListController'
    }
  ).when('/questions/:id',
    {
    templateUrl: "#{ @TGENV.version }/templates/question.html",
    controller: 'QuestionController'
    }
  ).when('/not-found/',
    {
      templateUrl: "#{ @TGENV.version }/templates/404.html",
    }
  ).when('/forbidden/',
    {
      templateUrl: "#{ @TGENV.version }/templates/403.html",
    }
  ).otherwise(
    {
      redirectTo: "/not-found/"
    }
  )

)