class EnrollmentsController < ApplicationController
  
  def index       	
   	lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: results.to_json
  end
  def update  	
  	lich = LichTrinhGiangDay.find(params[:lich_id])
  	attendance = lich.attendances.where(sinh_vien_id: params[:enrollment][:id]).first_or_create!
  	attendance.turn(params[:enrollment][:phep])
    enrollments = lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: results.to_json
  end
end  