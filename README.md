Rails Lite
==========

Recreates a stripped down version of the process that begins with a URL and ends with a rendered view.
This includes building lite versions of a router, ActionController::Base, as well as params & session storage - all on top of the WEBrick gem.

- `Router` recreates Rails' `#draw` method by using `#instance_eval` to create a list of `Route` objects from the code inside the block.
- Regular expression objects are used to match a given url with any of the routes on file, creating a new instance of the controller and using `#send` to invoke the given action
- Within `ControllerBase`, the core methods `#params`, `#session`, `#redirect_to` and `#render` are rewritten from scratch.
- `#render` uses the ERB gem to bind variables into the loaded .erb files
