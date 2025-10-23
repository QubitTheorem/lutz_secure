#!/bin/bash

# prints cool message

cat << "EOF"
          _____            _____                _____                    _____                      
         /\    \          /\    \              /\    \                  /\    \                     
        /::\____\        /::\____\            /::\    \                /::\    \                    
       /:::/    /       /:::/    /            \:::\    \               \:::\    \                   
      /:::/    /       /:::/    /              \:::\    \               \:::\    \                  
     /:::/    /       /:::/    /                \:::\    \               \:::\    \                 
    /:::/    /       /:::/    /                  \:::\    \               \:::\    \                
   /:::/    /       /:::/    /                   /::::\    \               \:::\    \               
  /:::/    /       /:::/    /      _____        /::::::\    \               \:::\    \              
 /:::/    /       /:::/____/      /\    \      /:::/\:::\    \               \:::\    \             
/:::/____/       |:::|    /      /::\____\    /:::/  \:::\____\_______________\:::\____\            
\:::\    \       |:::|____\     /:::/    /   /:::/    \::/    /\::::::::::::::::::/    /            
 \:::\    \       \:::\    \   /:::/    /   /:::/    / \/____/  \::::::::::::::::/____/             
  \:::\    \       \:::\    \ /:::/    /   /:::/    /            \:::\----\------                   
   \:::\    \       \:::\    /:::/    /   /:::/    /              \:::\    \                        
    \:::\    \       \:::\__/:::/    /    \::/    /                \:::\    \                       
     \:::\    \       \::::::::/    /      \/____/                  \:::\    \                      
      \:::\    \       \::::::/    /                                 \:::\    \                     
       \:::\____\       \::::/    /                                   \:::\____\                    
        \::/    /        \__/____/                                     \::/    /                    
         \/____/                                                        \/____/                     
                                                                                                    
          _____                    _____                    _____                    _____          
         /\    \                  /\    \                  /\    \                  /\    \         
        /::\    \                /::\    \                /::\    \                /::\    \        
       /::::\    \              /::::\    \              /::::\    \              /::::\    \       
      /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \      
     /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \     
    /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \    
   /::::\   \:::\    \      /::::\   \:::\    \       \:::\   \:::\    \       \:::\   \:::\    \   
  /::::::\   \:::\    \    /::::::\   \:::\    \    ___\:::\   \:::\    \    ___\:::\   \:::\    \  
 /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \  /\   \:::\   \:::\    \  /\   \:::\   \:::\    \ 
/:::/  \:::\   \:::|    |/:::/  \:::\   \:::\____\/::\   \:::\   \:::\____\/::\   \:::\   \:::\____\
\::/    \:::\  /:::|____|\::/    \:::\  /:::/    /\:::\   \:::\   \::/    /\:::\   \:::\   \::/    /
 \/_____/\:::\/:::/    /  \/____/ \:::\/:::/    /  \:::\   \:::\   \/____/  \:::\   \:::\   \/____/ 
          \::::::/    /            \::::::/    /    \:::\   \:::\    \       \:::\   \:::\    \     
           \::::/    /              \::::/    /      \:::\   \:::\____\       \:::\   \:::\____\    
            \__/____/               /:::/    /        \:::\  /:::/    /        \:::\  /:::/    /    
                                   /:::/    /          \:::\/:::/    /          \:::\/:::/    /     
                                  /:::/    /            \::::::/    /            \::::::/    /      
                                 /:::/    /              \::::/    /              \::::/    /       
                                 \::/    /                \::/    /                \::/    /        
                                  \/____/                  \/____/                  \/____/         
                                                                                                    



EOF


















# defines pc as an empty string
pc=""
# iterates trhough a loop 10 times
for i in {1..10}; do
        # concatonates a random number from 0-9 to pc
        pc+=$(( RANDOM % 10 ))
done
# defines what the email will look like and then sends it
(
  printf 'From: %s\n' "your.email@yourdomain.com"
  printf 'To: %s\n' "lrrotz06@gmail.com"
  printf 'Subject: %s\n' "Lutz security password"
  printf '\n'      # blank line separates headers from body
  printf 'Your password is: %s\n' "$pc"
) |msmtp --account=gmail lucarotz06@gmail.com
# adds the hash of the new code to email_code
echo -n "$pc" | sha512sum > email_code

# checks if the user themselves have a password
if [[ ! -f "user_pw" ]]; then
	# loops proccess of creating password
	while true; do
		echo -n "You do not yet have a password. Please enter a new password:"
		read -s user_password
		echo 
		echo -n "Please repeat password:"
		read -s repeat
		if [[ "$user_password" == "$repeat" ]]; then
			echo -n "$repeat" | sha512sum > "user_pw"
			echo
			break
		fi
	done
fi




echo -n  "Enter password: "
# collects input and stores it im user_password
read -s  user_pw
echo
# creates a hash of user_password
user_pw_hash=$(echo -n "$user_pw" | sha512sum)
# gets the hash stored in user_pw
user_pw_stored=$(cat user_pw)
# checks if the hash of the input is the same 
# as the hash stored in user_pw and echos an
# appropriate message
if [[ "$user_pw_hash" == "$user_pw_stored" ]]; then
	echo "Password correct."
	echo -n "Enter one time email code: "
	read user_code
	# turns the user input into a hash
	input_code=$(echo -n "$user_code" | sha512sum)
	# gets the stored hash
	email_code_stored=$(cat email_code)
	# checks if hash of input and stored hash match
	if [[ "$input_code" == "$email_code_stored" ]]; then
	# decrypts the file with the password
		openssl enc -d -aes-256-cbc -pbkdf2 -in super_secret.txt.enc -out super_secret.txt -pass pass:"$user_password"
		echo
		cat super_secret.txt
		openssl enc -aes-256-cbc -pbkdf2 -in super_secret.txt -out super_secret.txt.enc -pass pass:"$user_password"
		> super_secret.txt
	else
		echo "Email code incorrect."
	fi
else
	echo "Password incorrect."

fi
