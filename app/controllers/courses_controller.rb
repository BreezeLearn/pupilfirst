require 'net/http'

require 'json'

class CoursesController < ApplicationController
  before_action :authenticate_user!, except: %i[show apply]

  # GET /courses/:id/curriculum
  def curriculum
    @course = find_course
    @presenter = Courses::CurriculumPresenter.new(view_context, @course)
    render layout: 'student_course'
  end

  # GET /courses/:id/leaderboard?weeks_before=
  def leaderboard
    @course = find_course
    @on = params[:on]
    render layout: 'student_course'
  end

  # GET /courses/:id/apply
  def apply
    @course = find_course
    save_tag
    render layout: 'tailwind'
  end

  # GET /courses/:id/verifypayment
  def verifypayment
    @course = find_course
    transaction_id = params[:transaction_id]
    print transaction_id
    uri = URI("https://api.flutterwave.com/v3/transactions/#{transaction_id}/verify")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, 'Authorization' => 'Bearer FLWSECK_TEST-f0a8123689b4cb9955d91487e168c739-X')
    res = http.request(req)
    if res.code == '200'
      body = JSON[res.body]
      puts body
      puts @course.price
      puts @course.id
      if body['status'] == 'success' && body['data']['charged_amount'] >= @course.price && body['data']['meta']['course_id'] == @course.id.to_s #TODO: Check currency
        email = body['data']['customer']['email']
        name = body['data']['customer']['name']
        Applicant.transaction do
          #TODO : make this idempotent
          applicant = persisted_applicant(email, @course) || Applicant.create!(email: email, course: @course, name: name)

          # if context[:session][:applicant_tag].present? TODO: CHECK THIS
          #   applicant.tag_list.add(context[:session][:applicant_tag])
          #   applicant.save!
          # end

          # Generate token and send course enrollment email
          applicant.regenerate_login_token
          applicant.update!(login_mail_sent_at: Time.zone.now)
          ApplicantMailer.enrollment_verification(applicant).deliver_now
        end
        redirect_to :action => 'curriculum'
      else
        print 'else here'
      end
    end
  end

  # GET /courses/:id/(:slug)
  def show
    @course = find_course
    render layout: 'student'
  end

  # GET /courses/:id/review
  def review
    @course = find_course
    render layout: 'student_course'
  end

  # GET /courses/:id/students
  def students
    @course = find_course
    render layout: 'student_course'
  end

  # GET /courses/:id/report
  def report
    @course = find_course
    render layout: 'student_course'
  end

  private

  def persisted_applicant(email, course)
    @persisted_applicant ||= Applicant.with_email(email).where(course: course).first
  end

  def find_course
    authorize(policy_scope(Course).find(params[:id]))
  end

  def payment_successful
    true
  end

  def save_tag
    return if params[:tag].blank?

    if params[:tag].in?(current_school.founder_tag_list)
      session[:applicant_tag] = params[:tag]
    end
  end
end
