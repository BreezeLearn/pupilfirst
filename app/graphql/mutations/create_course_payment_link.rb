require 'net/http'

require 'securerandom'
require 'json'

module Mutations
  class CreateCoursePaymentLink < GraphQL::Schema::Mutation
    argument :course_id, ID, required: true

    description 'Generate the payment link'

    field :payment_link, String, null: false

    def resolve(params)
      if (Course.exists?(params[:course_id]))
        current_user = context[:current_user] #.courses.find(course_id)
        if current_user.courses.exists?(params[:course_id])
          context[:notifications].push(kind: :error, title: 'Course has been already taken', body: '')
        else
          begin
            #TODO: generate payment link
            course = Course.find(params[:course_id])
            uri = URI('https://api.flutterwave.com/v3/payments')
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json', 'Authorization' => 'Bearer FLWSECK_TEST-f0a8123689b4cb9955d91487e168c739-X')

            req.body = {
              "tx_ref": SecureRandom.uuid,
              "amount": course.price.to_s,
              "currency": 'NGN',
              "redirect_url": 'http://www.school.localhost/courses/' + course.id.to_s + '/verifypayment', #TODO: Replace with the host url
              "meta": {
                "student_id": current_user.id,
                "course_id": course.id,
              },
              "customer": {
                "email": current_user.email, #TODO: Verify once
                "name": current_user.name, #TODO: Verify once
              },
              "customizations": {
                "title": course.name,
                "description": course.name + ' price',
                "logo": 'https://assets.piedpiper.com/logo.png',
              },
            }.to_json
            res = http.request(req)
            puts "response #{res.body}"
            if res.code == '200'
              { payment_link: JSON[res.body]['data']['link'] }
            else
              print 'else'
            end
          rescue
            print 'error'
          end
        end
      end
    end
  end
end
