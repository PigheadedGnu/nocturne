class BuildQueueBuildingAdminController < AdminBaseController
  def model_class
    BuildQueueBuilding
  end

  def index
    # The first level of index, showing all BuildQueue
    instances = BuildQueue.all
    render "admin/instance_list.slang"
  end

  def build_queue_index
    # The second index level, showing the Buildings in the chosen BuildQueue
    instances = [] of Building
    BuildQueueBuilding.find_each("WHERE build_queue_id = ?", [params[:id_build_queue]]) do |bqb|
      instances << bqb.building
    end
    render "admin/instance_list.slang"
  end
end

class BuildQueueBuildingController < ApplicationController
  def index
    "BuildQueueBuilding Normal Page"
  end
end
