class RefleshController < ApplicationController
  before_action :autorize_refresh_by_access_request!

  def create
    session =
      JWTSessions::Session.new(
        payload: claimless_payload,
        reflesh_by_access_allowed: true,
      )
    tokens =
      session.reflesh_by_access_allowed do
        raise JWTSessions::Errors::Unauthorized, 'Something not right here'
      end

    response.set_cookie(
      JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      secure: Rails.env.production?,
    )

    render json: { csrf: tokens[:csrf] }
  end
end
