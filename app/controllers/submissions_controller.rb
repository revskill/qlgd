#encoding: utf-8
class SubmissionsController < ApplicationController

	def index
		@lop = LopMonHoc.find(params[:id])
		assignments = @lop.assignment_groups.includes(:assignments).inject([]) {|res, el| res + el.assignments}
		count = 0
		names = assignments.map {|a| {:name => a.name, :points => a.points, :group_name => a.assignment_group.name, :group_weight => a.assignment_group.weight}}
		enrollments = @lop.enrollments
		results = enrollments.map do |en|
			tmp = {:name => en.sinh_vien.hovaten, :assignments => [], :diem_qua_trinh => en.diem_qua_trinh}			
			assignments.each_with_index do |as, index|				
				tmp[:assignments] << EnrollmentSubmissionSerializer.new(EnrollmentSubmissionDecorator.new(en, as, index + count))
			end
			count += assignments.count
			tmp
		end
		group_results = enrollments.map do |en|
			tmp = {:name => en.sinh_vien.hovaten, :assignment_groups => [], :diem_qua_trinh => en.diem_qua_trinh}			
			@lop.assignment_groups.each do |ag|				
				tmp[:assignment_groups] << EnrollmentGroupSubmissionSerializer.new(EnrollmentGroupSubmissionDecorator.new(en, ag))
			end
			
			tmp
		end
	    render json: {:names => names, :results => results, :group_results => group_results}.to_json		
	end

	# post grades
	def update
		@lop = LopMonHoc.find(params[:id])
		@as= @lop.assignments.find(params[:assignment_id])
		@sub = @as.submissions.where(sinh_vien_id: params[:sinh_vien_id]).first
		if @sub
			@sub.grade = params[:grade]
			@sub.giang_vien_id = params[:giang_vien_id]
			@sub.save!
		else
			@sub = @as.submissions.create(sinh_vien_id: params[:sinh_vien_id], giang_vien_id: params[:giang_vien_id], grade: params[:grade])
		end

		assignments = @lop.assignment_groups.includes(:assignments).inject([]) {|res, el| res + el.assignments}
		count = 0		
		names = assignments.map {|a| {:name => a.name, :points => a.points, :group_name => a.assignment_group.name, :group_weight => a.assignment_group.weight}}
		enrollments = @lop.enrollments
		results = enrollments.map do |en|
			tmp = {:name => en.sinh_vien.hovaten, :assignments => [], :diem_qua_trinh => en.diem_qua_trinh}			
			assignments.each_with_index do |as, index|				
				tmp[:assignments] << EnrollmentSubmissionSerializer.new(EnrollmentSubmissionDecorator.new(en, as, index + count))
			end
			count += assignments.count
			tmp
		end
		
	    group_results = enrollments.map do |en|
			tmp = {:name => en.sinh_vien.hovaten, :assignment_groups => [], :diem_qua_trinh => en.diem_qua_trinh}			
			@lop.assignment_groups.each do |ag|				
				tmp[:assignment_groups] << EnrollmentGroupSubmissionSerializer.new(EnrollmentGroupSubmissionDecorator.new(en, ag))
			end
			
			tmp
		end
	    render json: {:names => names, :results => results, :group_results => group_results}.to_json	
	end
end