#!/bin/bash
clear
. helper.conf 
echo " "
cat sentia.txt
echo " "
echo "Today we're working on the" "$stack" "Stack."
echo "The bucket we're getting our templates from and to is:" "$bucket"
echo "This is our parent-stack:" "$template"  
echo "--------------------------------------------------------------------------------------------"
echo " "
echo "What would you like to do? Choices are: sync-all, sync-s3, delete, create, git or quit:" 
read wish

if [ "$wish" == "create" ] ; then
        echo "As you wish, we shall create this new stack."
        aws cloudformation create-stack --stack-name "$stack" --template-url "$template" --capabilities CAPABILITY_NAMED_IAM 
        sleep 5
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "sync-all" ] ; then
        echo " "
        aws s3 sync ../ "$bucket" --exclude '*' --include '*.yaml' 
        aws cloudformation update-stack --stack-name $stack --template-url $template 
        echo "We shall bring the news to every corner and s3 bucket."
        sleep 5
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "sync-s3" ] ; then
        echo " "
        aws s3 sync ../ "$bucket" --exclude '*' --include '*.yaml' 
        echo "We shall bring the news to every s3 bucket. Just s3. S3."
        sleep 5
        clear
        ./helper.sh 
        exit 1
elif [ "$wish" == "delete" ] ; then
        echo "We shall destroy what you have created. After your confirmation."
        echo " "
        echo "We don't take prisoners. Sure about this? Yes or no..."
        read confirmation
          if [ "$confirmation" == "yes" ] ; then 
            aws cloudformation delete-stack --stack-name "$stack"
            sleep 5
            clear
            ./helper.sh  
            exit 1
          else
            echo "Cancelling and taking you back to the menu"
            sleep 2
            clear
            ./helper.sh  
            exit 1
          fi 
elif [ "$wish" == "git" ] ; then
        echo "We shall bring light to all git repositories. What do you want to say in your commit?" 
        read commit 
        cd ..
        git add *
        git commit -m "$commit"
        git push origin master
        echo "Done. Commit message is:" $commit 
        sleep 5
        cd helper 
        clear
        ./helper.sh  
        exit 1
elif [ "$wish" == "quit" ] ; then
        echo "Goodbye.."  
        exit 1
else
        echo "Please adhere to my command. I am giving you a second chance"
        sleep 2
        clear
        ./helper.sh
fi





