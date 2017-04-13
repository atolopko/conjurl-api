# TODO: Ideally, this controller would be hosted in a separately
# deployed service, rather than bundled in our API backend project.
class ShortUrlRedirectController < ApplicationController
  def redirect
    key = params[:short_url_key]
    # TODO: Interestingly, bit.ly returns 301 (moved permanently), but
    # our product manager wants user agents to continue to use our
    # short URLs in the future for analytics purposes. We will return
    # a 302, to discourage use of the redirected URL.
    redirect_to ShortUrl[key].target_url
  rescue ActiveRecord::RecordNotFound => e
    render status: :not_found
  end
end
