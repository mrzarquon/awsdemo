#!/usr/bin/env ruby
# installed by userdata
# call via:
# /opt/awsdemo/pe_search.rb $task $pe_role $pe_build $region

require 'aws-sdk-core'

task = ARGV[0]
role = ARGV[1]
build = ARGV[2]
region = ARGV[3]

ec2 = Aws::EC2::Client.new( region: region )

# case task
# search: see below

servers = ec2.describe_instances({
	filters: [
		{
			name: "tag:pe_role",
			values: [role],
		},
		{
			name: "tag:pe_build",
			values: [build],
		},
	],
})

servers.reservations.each do |instance|
	puts instance.instances[0].private_dns_name
end

# case task
# wait
# poll for node in pe_role to complete task (aws tag updated)
# pe_task


# case task
# done
# update pe_task tag to = done
