Doorkeeper::Application.destroy_all
Doorkeeper::Application.create(name: "expert_advice_web", redirect_uri: "http://localhost:3000/")
