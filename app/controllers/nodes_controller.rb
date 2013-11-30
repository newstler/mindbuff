class NodesController < ApplicationController
  before_action :set_node, only: [:show, :edit, :update, :destroy]

  # GET /nodes
  # GET /nodes.json
  def index
    @nodes = Node.all

    respond_to do |format|
      # if current_user
        format.html
        format.json { render json: {success: true, nodes: @nodes.collect{ |a| a.node_for_json }}.to_json }
      # else
      #   format.html
      #   format.json {render json: {success: false, message: "Unauthorized.", status: 401}.to_json}
      # end
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    existing_node = Node.where(link: node_params[:link]).first

    unless existing_node
      @node = Node.new(node_params)
    else
      @node = existing_node
      @node.tags << node_params[:tags]
    end

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render action: 'show', status: :created, location: @node }
      else
        format.html { render action: 'new' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      @node.attributes = node_params
      if @node.update
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url }
      format.json { head :no_content }
    end
  end

  def tags
    @nodes = Node.with_any_tags(params[:tags])

    respond_to do |format|
      # if current_user
        format.html
        format.json { render json: {success: true, nodes: @nodes.collect{ |a| a.node_for_json }}.to_json }
      # else
      #   format.html
      #   format.json {render json: {success: false, message: "Unauthorized.", status: 401}.to_json}
      # end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      # params.require(:node).permit(:link, tags: [])
      params.require(:node).permit!
    end
end
