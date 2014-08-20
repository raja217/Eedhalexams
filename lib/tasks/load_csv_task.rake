namespace :db do

  desc "load user data from csv"
  task :load_csv_task  => :environment do

    require 'fastercsv'

    FasterCSV.foreach("st.csv") do |row|

      log=Logger.new("log/csv.log")
      log.debug "************** conversion started at #{Date.today}********************"

      s = Student.new(
        :admission_no => row[0],
        :first_name => row[1],
        :last_name => row[2],
        :email => row[3]

      )

       if s.save

      else
        log.debug "first_name    => #{s.first_name}" unless s.first_name.blank?
        log.debug "Addmission_n0 => #{s.admission_no}" unless s.admission_no.blank?
        log.debug "batch_name    => #{s.batch_id}" unless s.batch_id.blank?
        log.debug "error_name    => #{s.errors.full_messages}"
        log.debug "**************************************************************"
        puts s.errors.full_messages
      end

    end
  end
end