LieDetector
===========

I created this gem to keep API description and actual API in sync. You write markdown document
with data structures and request descriptions, and then you can check it against real server
to check that description is really describe this server API.

All requests executed one by one, and if any of them fail we stop checking.

So, take a look at some example - current document describe a bit of GitHub API.

GitHub API Check
----------------

As you know github has public API. API you can call without authentification.
Set API host:

    self.http_defaults = {host: 'api.github.com', scheme: 'https', port: 443}

With Trafaret library we can define data types to check API results:

    Repo = T.construct({
      id: :integer,
      name: :string,
      full_name: :string,
      # ... hundred of other fields, tired to define them
      owner: {} # actually user info, but need not now
    })

So now we can get info about liedetector repo, store it, and then use it for next requests:

    request :repo_info, :get, '/repos/Deepwalker/liedetector' do
      status 200
      await Repo
      store :repo # we store API call result for later
    end