@tg ?= {}
@tg.filters ?= {}
$$ = @tg.filters

$$.nicedate = () ->
  (date) -> if not date then "" else moment(date).fromNow()
