output "instances_ids" {
  value = aws_instance.my_server[*].id
}

output "instances_public_ips" {
  value = aws_instance.my_server[*].public_ip
}

# Output a List
output "server_id_ip" {
  value = [
    for x in aws_instance.my_server :
    "Server with ID: ${x.id} has Public IP: ${x.public_ip}"
  ]
}

# Output a Map
output "server_id_ip_map" {
  value = {
    for x in aws_instance.my_server :
    x.id => x.public_ip // "i-12412412414435" = "15.33.77.104"
  }
}

# Output a List
output "users_unique_id_arn" {
  value = [
    for user in aws_iam_user.user :
    "UserID: ${user.unique_id} has ARN: ${user.arn}"
  ]
}

# Output a Map
output "users_unique_id_name_custom" {
  value = {
    for user in aws_iam_user.user :
    user.unique_id => user.name // "AIDA4BML4S5345K74HQFF" : "john"
    if length(user.name) < 7    // fileter by name length
  }
}
