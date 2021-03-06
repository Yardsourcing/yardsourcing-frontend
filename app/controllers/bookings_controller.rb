class BookingsController < ApplicationController
  before_action :set_yard, only: [:new, :create]

  def show
    @booking = BookingFacade.get_booking(params[:id])
  end

  def create
    params[:renter_id] = current_user.id
    params[:renter_email] = current_user.email
    booking = EngineService.create_booking(booking_params)
    if booking.include?(:error)
      flash[:error] = booking[:error]
      render :new, obj: @yard
    else
      redirect_to renter_dashboard_index_path
    end
  end

  def update
    booking = EngineService.update_booking_status({id: params[:id], status: params[:status]})
    redirect_to host_dashboard_index_path
  end

  def destroy
    booking = EngineService.delete_booking({id: params[:id]})
    if params[:host]
      redirect_to host_dashboard_index_path
    else
      redirect_to renter_dashboard_index_path
    end
  end

  private

  def booking_params
    params.permit(:renter_id, :renter_email, :yard_id, :booking_name, :date, :time, :duration, :description)
  end

  def set_yard
    @yard = YardFacade.yard_details(params[:yard_id])
  end
end
