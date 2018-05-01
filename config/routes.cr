Amber::Server.configure do |app|
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    # Reload clients browsers (development only)
    plug Amber::Pipe::Reload.new if Amber.env.development?

    plug Authenticate.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    # User stuff, autogenerated
    get "/profile", UserController, :show
    patch "/profile", UserController, :update
    get "/signinup", AuthController, :new
    post "/session", AuthController, :create
    get "/signout", AuthController, :delete
    post "/registration", AuthController, :register
    get "/", HomeController, :index

    # Nocturne stuff
  end

  # Admin Panel Routes
  routes :web, "/admin" do
    get "/", AdminController, :index
    # Models
    get "/models/buildqueue/", BuildQueueAdminController, :index

    get "/models/building/", BuildingAdminController, :index
    get "/models/building/new/", BuildingAdminController, :new
    post "/models/building/new/", BuildingAdminController, :create
    get "/models/building/:id/", BuildingAdminController, :read
    put "/models/building/:id/", BuildingAdminController, :update
    delete "/models/building/:id/", BuildingAdminController, :delete

    get "/models/crafter/", CrafterAdminController, :index
    get "/models/crafter/new/", CrafterAdminController, :new

    get "/models/furnishing/", FurnishingAdminController, :index

    get "/models/resource/", ResourceAdminController, :index

    get "/models/village/", VillageAdminController, :index

    get "/models/villager/", VillagerAdminController, :index
    # Relations
    get "/relations/buildqueuebuilding/", BuildQueueBuildingAdminController, :index
    get "/relations/buildingfurnishing/", BuildingFurnishingAdminController, :index
    get "/relations/buildingrequirement/", BuildingRequirementAdminController, :index
    get "/relations/buildingresource/", BuildingResourceAdminController, :index
    get "/relations/requiredcrafter/", RequiredCrafterAdminController, :index
    get "/relations/residingcrafter/", ResidingCrafterAdminController, :index
    get "/relations/resourcestore/", ResourceStoreAdminController, :index
    get "/relations/villagebuilding/", VillageBuildingAdminController, :index
  end

  routes :web, "/json" do
    # JSON routes for the API, might as well test it out
    get "/", VillageController, :json_index
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
