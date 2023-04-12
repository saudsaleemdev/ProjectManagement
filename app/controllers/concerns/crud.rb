module Crud
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token
    before_action :find_resource, only: %i[show edit update destroy]
    before_action :set_default_response_format, only: %i[index show create update]
  end

  def index
    @resources = if paginate?
                   klass.page(params[:page])
                 else
                   klass.all
                 end
    respond_to do |format|
      format.html
      format.json { render json: @resources }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @resource }
    end
  end

  def edit; end

  def update
    if @resource.update(resource_params)
      respond_to do |format|
        format.html { redirect_to redirect_to_path, notice: 'Updated' }
        format.json { render json: { message: 'Updated', resource: @resource } }
      end
    else
      respond_with_error(@resource)
    end
  end

  def new
    @resource = klass.new

    respond_to do |format|
      format.html
      format.json { render json: @resource }
    end
  end

  def create
    @resource = klass.new(resource_params)

    if @resource.save
      respond_to do |format|
        format.html { redirect_to redirect_to_path, notice: 'Created' }
        format.json { render json: { message: 'Created', resource: @resource } }
      end
    else
      respond_with_error(@resource)
    end
  end

  def destroy
    if @resource.destroy
      respond_to do |format|
        format.html { redirect_to redirect_to_path, notice: 'Deleted' }
        format.json { render json: { message: 'Deleted' } }
      end
    else
      respond_with_error(@resource)
    end
  end

  private

  def find_resource
    @resource = klass.find(params[:id])
  end

  def redirect_to_path
    @resource
  end

  def klass
    controller_name.singularize.camelize.constantize
  end

  def klass_name
    klass.to_s
  end

  def resource_name
    controller_name.singularize
  end

  def resource_params
    params.require(resource_name).permit(permitted_attributes)
  end

  def paginate?
    false
  end

  def respond_with_error(status = :unprocessable_entity)
    respond_to do |format|
      format.html { redirect_to request.referer, notice: @resource.errors.full_messages.to_sentence }
      format.json { render json: { errors: @resource.errors.full_messages }, status: status }
    end
  end

  def set_default_response_format
    request.format = :json if request.headers['Accept'].include?('application/json')
  end
end
