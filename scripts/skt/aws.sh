
# Gets you the IP of a given instance
# Usage: skt-ip <env_name> <app_name>
skt-ip() {
  env_name="$1"
  app_name="$2"

  aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --filters "Name=tag:app_environment_id,Values=${env_name}" "Name=tag:Name,Values=${app_name}" \
    --output text \
    --profile skydev
}


# SSH's you into a given instance (uses above function to get ip)
# Usage: skt-ssh <env_name> <app_name>
skt-ssh() {
  env_name="$1"
  app_name="$2"
  extra_args="$3"

  instance_ip=$(skt-ip "${env_name}" "${app_name}")
  ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password gaguirre@"${instance_ip}" "${extra_args}"
}

# SSH's you into a given instance and tails app logs
# Usage: skt-logs <env_name> <app_name>
skt-logs() {
  env_name="$1"
  app_name="$2"

  instance_ip=$(skt-ip "${env_name}" "${app_name}")
  ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password gaguirre@"${instance_ip}" "tail -f /opt/${app_name}/logs/${app_name}.log"
}

# Gets all the apps currently running in a given environment,
# with their versions, on list/table format
# Usage: skt-env <env_name>
skt-env() {
  env_name="$1"
  aws ec2 describe-instances \
    --query "Reservations[].Instances[].{App: Tags[?Key == 'Name']|[0].Value, Version: Tags[?Key == 'nexus_version']|[0].Value, CloudConfigBranch: Tags[?Key == 'spring_cloud_config_branch_name']|[0].Value}" \
    --filters "Name=tag:app_environment_id,Values=${env_name}" "Name=instance-state-name,Values=running" \
    --output table \
    --profile skydev
}

# Finds out which version of an specific app is running in a given environment
# Usage: skt-env-app <env_name> <app_name>
skt-env-app() {
  env_name="$1"
  app_name="$2"

  aws ec2 describe-instances \
    --query "Reservations[].Instances[].{App: Tags[?Key == 'Name']|[0].Value, Version: Tags[?Key == 'nexus_version']|[0].Value, CloudConfigBranch: Tags[?Key == 'spring_cloud_config_branch_name']|[0].Value}" \
    --filters \
        "Name=tag:app_environment_id,Values=${env_name}" \
        "Name=instance-state-name,Values=running"        \
        "Name=tag:Name,Values=${app_name}"               \
    --output table \
    --profile skydev
}