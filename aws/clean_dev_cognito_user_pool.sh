# Set your User Pool ID
USER_POOL_ID=$1

aws cognito-idp list-users --user-pool-id $USER_POOL_ID > user_pool.json

# undesireable list
cat user_pool.json | jq -r  '.Users[] | {Username, Email: (.Attributes[] | select(.Name == "email").Value)} | select((.Email | test(".*@ultralabs.io$") or test(".*@ourpetpolicy.com$") | not)) | .Email' > affected_emails.txt


# disable and delete undesireable list
cat user_pool.json |  jq -r '.Users[] | {Username, Email: (.Attributes[] | select(.Name == "email").Value)} | select((.Email | test(".*@ultralabs.io$") or test(".*@ourpetpolicy.com$") | not)) | .Username' | while read username; do
  echo "Disabling and Deleting user $username"
  aws cognito-idp admin-disable-user --user-pool-id $USER_POOL_ID --username "$username"
  aws cognito-idp admin-delete-user --user-pool-id $USER_POOL_ID --username "$username"
done

# enable ultralabs.io and ourpetpolicy.com users
cat user_pool.json | jq -r  '.Users[] | {Username, Email: (.Attributes[] | select(.Name == "email").Value)} | select((.Email | test(".*@ultralabs.io$") or test(".*@ourpetpolicy.com$"))) | .Email' > desired_emails.txt
cat user_pool.json |  jq -r '.Users[] | {Username, Email: (.Attributes[] | select(.Name == "email").Value)} | select((.Email | test(".*@ultralabs.io$") or test(".*@ourpetpolicy.com$"))) | .Username' | while read username; do
  echo "Enabling user $username"
  aws cognito-idp admin-enable-user --user-pool-id $USER_POOL_ID --username "$username"
done
