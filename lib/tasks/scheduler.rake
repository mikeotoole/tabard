desc "This task is called by the Heroku scheduler add-on"
task :bill_customers => :environment do
    puts "Billing Customers"
    Invoice.bill_customers
    puts "Done"
end