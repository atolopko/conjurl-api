# TODO: Ideally, this controller would be hosted in a separately
# deployed service, rather than bundled in our API backend project.
class ShortUrlRedirectController < ApplicationController
  def redirect
    key = params[:short_url_key]
    # NOTE: Interestingly, bit.ly goo.gl return 301 (Moved
    # Permanently), so let's do the same. 302 (Found) would seem
    # reasonable, so that user agent is encouraged to re-use the
    # shortened URL in future requests.
    redirect_to ShortUrl[key].target_url, status: :moved_permanently
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end
end
