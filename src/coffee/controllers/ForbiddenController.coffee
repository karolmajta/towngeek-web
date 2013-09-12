@tg ?= {}
@tg.controllers ?= {}
$$ = @tg.controllers

$$.ForbiddenController = ($log, currentUser) -> currentUser.logout()