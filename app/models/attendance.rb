class Attendance < ActiveRecord::Base
  attr_accessible :note, :phep, :so_tiet_vang, :state

  belongs_to :lich_trinh_giang_day
  belongs_to :sinh_vien

  validates :lich_trinh_giang_day, :sinh_vien, :presence => true
  state_machine :state, :initial => :attendant do  
    #before_transition any => :absent, :do => :do_absent

    event :mark_absent do 
      transition :attendant => :absent # vang ca buoi hoc
    end
    
    event :mark_late do 
      transition :absent => :late # di tre, vang 1 so buoi hoc
    end
    
    event :mark_attendant do 
      transition all => :attendant #co mat
    end

    event :mark_idle do 
      transition all => :idle # khong phai di hoc
    end
  end
  
  def mark_idle
    self.phep = nil
    self.so_tiet_vang = 0
    self.note = nil
    super
  end

  def mark_attendant
    self.phep = nil
    self.so_tiet_vang = 0
    super
  end


  def mark_absent(phep)    
    self.phep = phep
    self.so_tiet_vang = self.lich_trinh_giang_day.so_tiet
    #self.save!
    super
  end

  def mark_late(stv, phep)    
    self.phep = phep
    self.so_tiet_vang = stv
    #self.save!
    super
  end

  def mark(stv, phep, idle)
    return nil if stv.nil? or stv > lich_trinh_giang_day.so_tiet
    if idle == true
      mark_idle      
    else
      if stv == 0
        mark_attendant
      end
      if stv > 0 and stv < lich_trinh_giang_day.so_tiet
        mark_late(stv, phep)
      end
      if stv > 0 and stv == lich_trinh_giang_day.so_tiet
        mark_absent(phep)
      end
    end
    return true
  end

  def turn(phep)
    if self.absent?
      self.mark_attendant
    elsif self.attendant?
      self.mark_absent(phep)
    end
  end
end