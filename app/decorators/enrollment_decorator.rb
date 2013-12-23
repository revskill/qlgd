#encoding: utf-8
class EnrollmentDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  def initialize(obj,lich)    
    @object = obj
    @lich = lich
    @at = @object.attendances.with_lich(@lich)
  end
  def id
    @object.id
  end
  def so_tiet_vang
    return 0 unless @at
    return @at.so_tiet_vang if @at
  end
  def phep
    return false unless @at
    return @at.phep if @at
  end
  def status  	
  	return "Không vắng" unless @at
  	return @at.decorate.status if @at
  end
  def name
    @object.sinh_vien.hovaten
  end
  def code
    @object.sinh_vien.code
  end
end
