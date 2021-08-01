class SigninController < ApplicationController
  before_action :autorize_access_request!, only: [:destroy]

  def create
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      session =
        JWTSessions::Session.new(
          payload: payload,
          reflesh_by_access_allowed: true,
        )
      tokens = session.login
      response.set_cookoit(
        JWTSessions.access_cookiek,
        value: tokens[:access],
        httpoly: true,
        secure: Rails.env.production?,
      )
      render json: { crsf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: {
             error: 'Cannot find email/password combination',
           },
           status: :not_found
  end
end
